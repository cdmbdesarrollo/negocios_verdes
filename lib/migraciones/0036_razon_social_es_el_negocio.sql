-- 0036_razon_social_es_el_negocio.sql
--
-- Corrección de modelo (pedido explícito de CDMB):
--
--   * La RAZÓN SOCIAL es el nombre del negocio verde — no es un dato de la
--     persona. Se verificó contra los datos: en los 87 vínculos jurídicos
--     con razón social, esta coincide EXACTAMENTE con `negocios.nombre`
--     (0 diferencias). Así que no se guarda aparte: se deriva del negocio.
--   * El REPRESENTANTE LEGAL es siempre una persona (natural, o la persona
--     natural que firma por una entidad jurídica). Vive en
--     `representantes.nombres`. La ficha pública y el admin muestran ese
--     nombre — nunca la razón social en su lugar (era el bug de 0031/0035:
--     `_display_representante` prefería `razon_social`).
--
-- Cambios:
--   1. `_display_representante` -> solo `nombres` (la persona).
--   2. Se elimina `representantes.razon_social` (0031) y
--      `negocio_representante.razon_social` (0035) — redundantes.
--   3. `guardar_representante` y `asignar_representante_negocio` pierden
--      `p_razon_social` (firmas nuevas: drop + create, patrón del proyecto).
--   4. `v_representantes` pierde `razones_negocios` y gana `negocios_nombres`
--      (los nombres de los negocios que representa = sus razones sociales,
--      para el buscador y para mostrar la asociación).
--   5. Backfill de `negocios.representante_legal` con el nombre de la persona.
--   6. `search_path` fijo en `generar_slug_unico`, `immutable_unaccent` y
--      `set_updated_at` (advisor `function_search_path_mutable`).
--
-- No tocado a propósito:
--   * `unaccent` sigue en el esquema `public` — moverlo rompería la columna
--     generada `negocios.busqueda` y su índice. Aviso aceptado.
--   * "Leaked password protection" es un toggle de Auth (Dashboard →
--     Authentication → Policies), no se puede activar por SQL.
--
-- Idempotente. Depende de 0035.

begin;

-- 1. La vista se recrea al final; hay que soltarla antes de tocar columnas.
drop view if exists v_representantes;

-- 2. El "nombre para mostrar" del representante es la PERSONA, siempre.
create or replace function _display_representante(p_id uuid)
returns text language sql stable set search_path = public as $$
  select nullif(trim(coalesce(nombres,'') || ' ' || coalesce(apellidos,'')), '')
  from representantes where id = p_id
$$;

-- 3a. guardar_representante sin p_razon_social.
do $$
declare r record;
begin
  for r in
    select p.oid::regprocedure as f
    from pg_proc p join pg_namespace n on n.oid = p.pronamespace
    where n.nspname = 'public' and p.proname = 'guardar_representante'
  loop
    execute format('drop function %s', r.f);
  end loop;
end $$;

create function guardar_representante(
  p_id uuid, p_nombres text, p_apellidos text,
  p_naturaleza_juridica text, p_documento text, p_tipo_documento text,
  p_telefono text, p_correo text, p_direccion text, p_municipio text
) returns uuid
language plpgsql security definer set search_path = public as $$
declare v_id uuid := coalesce(p_id, gen_random_uuid());
begin
  if not es_admin() then
    raise exception 'No autorizado: se requiere una cuenta administradora de CDMB.';
  end if;
  if p_nombres is null or trim(p_nombres) = '' then
    raise exception 'El nombre del representante legal es obligatorio.';
  end if;
  insert into representantes
    (id, nombres, apellidos, naturaleza_juridica,
     documento, tipo_documento, telefono, correo, direccion, municipio)
  values (v_id, trim(p_nombres), p_apellidos, p_naturaleza_juridica,
          p_documento, p_tipo_documento, p_telefono, p_correo, p_direccion,
          p_municipio)
  on conflict (id) do update set
    nombres = excluded.nombres, apellidos = excluded.apellidos,
    naturaleza_juridica = excluded.naturaleza_juridica,
    documento = excluded.documento, tipo_documento = excluded.tipo_documento,
    telefono = excluded.telefono, correo = excluded.correo,
    direccion = excluded.direccion, municipio = excluded.municipio,
    updated_at = now();
  return v_id;
end $$;

revoke all on function guardar_representante(uuid,text,text,text,text,text,text,text,text,text) from public;
grant execute on function guardar_representante(uuid,text,text,text,text,text,text,text,text,text) to authenticated;

-- 3b. asignar_representante_negocio sin p_razon_social.
do $$
declare r record;
begin
  for r in
    select p.oid::regprocedure as f
    from pg_proc p join pg_namespace n on n.oid = p.pronamespace
    where n.nspname = 'public' and p.proname = 'asignar_representante_negocio'
  loop
    execute format('drop function %s', r.f);
  end loop;
end $$;

create function asignar_representante_negocio(
  p_negocio_id uuid, p_representante_id uuid,
  p_nit text default null, p_naturaleza_juridica text default null,
  p_nota text default null
) returns void
language plpgsql security definer set search_path = public as $$
declare
  v_actual uuid; v_nit text; v_nat text;
begin
  if not es_admin() then
    raise exception 'No autorizado: se requiere una cuenta administradora de CDMB.';
  end if;
  select representante_id, nit, naturaleza_juridica
    into v_actual, v_nit, v_nat
  from negocio_representante
  where negocio_id = p_negocio_id and vigente_hasta is null;

  if v_actual is not distinct from p_representante_id
     and v_nit is not distinct from p_nit
     and v_nat is not distinct from p_naturaleza_juridica then
    return;
  end if;

  update negocio_representante set vigente_hasta = now()
  where negocio_id = p_negocio_id and vigente_hasta is null;
  insert into negocio_representante
    (negocio_id, representante_id, nit, naturaleza_juridica, asignado_por, nota)
  values (p_negocio_id, p_representante_id, p_nit, p_naturaleza_juridica,
          auth.uid(), p_nota);
  update negocios set
    representante_legal = _display_representante(p_representante_id),
    nit = p_nit,
    naturaleza_juridica = p_naturaleza_juridica
  where id = p_negocio_id;
  insert into admin_logs (admin_id, accion, entidad, entidad_id, detalle)
  values (auth.uid(), 'asignar_representante', 'negocios', p_negocio_id,
          jsonb_build_object('representante_id', p_representante_id, 'nit', p_nit,
                             'naturaleza_juridica', p_naturaleza_juridica,
                             'nota', p_nota));
end $$;

revoke all on function asignar_representante_negocio(uuid,uuid,text,text,text) from public;
grant execute on function asignar_representante_negocio(uuid,uuid,text,text,text) to authenticated;

-- 4. Fuera las columnas redundantes.
alter table representantes        drop column if exists razon_social;
alter table negocio_representante drop column if exists razon_social;

-- 5. Vista nueva: sin razones_negocios, con negocios_nombres.
create view v_representantes with (security_invoker = true) as
select p.*,
  (select count(*) from negocio_representante nr where nr.representante_id = p.id)
    as negocios_total,
  (select count(*) from negocio_representante nr
    where nr.representante_id = p.id and nr.vigente_hasta is null)
    as negocios_vigentes,
  (select string_agg(distinct nr.nit, ' ') from negocio_representante nr
    where nr.representante_id = p.id and nr.nit is not null and trim(nr.nit) <> '')
    as nits_negocios,
  (select string_agg(distinct n.nombre, ' | ')
     from negocio_representante nr join negocios n on n.id = nr.negocio_id
    where nr.representante_id = p.id)
    as negocios_nombres
from representantes p;
grant select on v_representantes to authenticated;
revoke all on v_representantes from anon;

-- 6. Backfill del nombre denormalizado (la persona, no la razón social).
update negocios n set representante_legal = _display_representante(nr.representante_id)
from negocio_representante nr
where nr.negocio_id = n.id and nr.vigente_hasta is null
  and _display_representante(nr.representante_id) is distinct from n.representante_legal;

-- 7. search_path fijo (advisor function_search_path_mutable).
alter function generar_slug_unico(text, uuid) set search_path = public;
alter function immutable_unaccent(text)        set search_path = public;
alter function set_updated_at()                set search_path = public;

commit;
