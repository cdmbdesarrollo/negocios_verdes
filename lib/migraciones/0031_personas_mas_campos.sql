-- 0031_personas_mas_campos.sql
--
-- Las 3 bases de personas (responsables_cdmb / delegados / representantes,
-- ver 0029) ganan más campos para parecerse a las de trámites CDMB:
--   * todas: tipo_documento, direccion
--   * responsables y delegados: cargo
--   * representantes: naturaleza_juridica (Natural / Jurídica) y razon_social
--     (cuando es Jurídica el "nombre" que se muestra es la razón social, no
--     nombres+apellidos). Un representante se sigue pudiendo vincular a uno o
--     varios negocios (tabla puente negocio_representante); el NIT sigue
--     siendo POR NEGOCIO en esa tabla puente (cada negocio tiene el suyo, o
--     va como persona natural).
--
-- Las 3 RPC `guardar_*` cambian de firma (más parámetros): se borran todas
-- las versiones y se recrea una sola de cada una, igual que 0028 con
-- guardar_negocio. Las vistas `v_*` (0030) usan `select *`, así que recogen
-- las columnas nuevas solas. Idempotente. Depende de 0029/0030.

alter table responsables_cdmb add column if not exists tipo_documento text;
alter table responsables_cdmb add column if not exists cargo text;
alter table responsables_cdmb add column if not exists direccion text;

alter table delegados add column if not exists tipo_documento text;
alter table delegados add column if not exists cargo text;
alter table delegados add column if not exists direccion text;

alter table representantes add column if not exists tipo_documento text;
alter table representantes add column if not exists direccion text;
alter table representantes add column if not exists naturaleza_juridica text;
alter table representantes add column if not exists razon_social text;

-- Backfill de naturaleza del representante desde la asignación vigente
-- (si todos sus negocios coinciden en la naturaleza, se copia; si no, se
-- deja nula para que el admin la defina).
update representantes r set naturaleza_juridica = sub.nat
from (
  select representante_id,
         case when count(distinct naturaleza_juridica) = 1
              then max(naturaleza_juridica) end as nat
  from negocio_representante
  where vigente_hasta is null and naturaleza_juridica is not null
  group by representante_id
) sub
where sub.representante_id = r.id
  and sub.nat is not null
  and r.naturaleza_juridica is null;

-- ===================================================================
-- RPC guardar_* con la firma nueva
-- ===================================================================
do $$
declare
  r record;
begin
  for r in
    select p.oid::regprocedure as firma
    from pg_proc p join pg_namespace n on n.oid = p.pronamespace
    where n.nspname = 'public'
      and p.proname in ('guardar_responsable','guardar_delegado','guardar_representante')
  loop
    execute format('drop function %s', r.firma);
  end loop;
end $$;

create function guardar_responsable(
  p_id uuid, p_nombres text, p_apellidos text,
  p_documento text, p_tipo_documento text,
  p_telefono text, p_correo text, p_cargo text, p_direccion text
) returns uuid
language plpgsql security definer set search_path = public as $$
declare v_id uuid := coalesce(p_id, gen_random_uuid());
begin
  if not es_admin() then
    raise exception 'No autorizado: se requiere una cuenta administradora de CDMB.';
  end if;
  if p_nombres is null or trim(p_nombres) = '' then
    raise exception 'El nombre es obligatorio.';
  end if;
  insert into responsables_cdmb
    (id, nombres, apellidos, documento, tipo_documento, telefono, correo, cargo, direccion)
  values (v_id, trim(p_nombres), p_apellidos, p_documento, p_tipo_documento,
          p_telefono, p_correo, p_cargo, p_direccion)
  on conflict (id) do update set
    nombres = excluded.nombres, apellidos = excluded.apellidos,
    documento = excluded.documento, tipo_documento = excluded.tipo_documento,
    telefono = excluded.telefono, correo = excluded.correo,
    cargo = excluded.cargo, direccion = excluded.direccion,
    updated_at = now();
  return v_id;
end $$;

create function guardar_delegado(
  p_id uuid, p_nombres text, p_apellidos text,
  p_documento text, p_tipo_documento text,
  p_telefono text, p_correo text, p_cargo text, p_direccion text
) returns uuid
language plpgsql security definer set search_path = public as $$
declare v_id uuid := coalesce(p_id, gen_random_uuid());
begin
  if not es_admin() then
    raise exception 'No autorizado: se requiere una cuenta administradora de CDMB.';
  end if;
  if p_nombres is null or trim(p_nombres) = '' then
    raise exception 'El nombre es obligatorio.';
  end if;
  insert into delegados
    (id, nombres, apellidos, documento, tipo_documento, telefono, correo, cargo, direccion)
  values (v_id, trim(p_nombres), p_apellidos, p_documento, p_tipo_documento,
          p_telefono, p_correo, p_cargo, p_direccion)
  on conflict (id) do update set
    nombres = excluded.nombres, apellidos = excluded.apellidos,
    documento = excluded.documento, tipo_documento = excluded.tipo_documento,
    telefono = excluded.telefono, correo = excluded.correo,
    cargo = excluded.cargo, direccion = excluded.direccion,
    updated_at = now();
  return v_id;
end $$;

create function guardar_representante(
  p_id uuid, p_nombres text, p_apellidos text,
  p_razon_social text, p_naturaleza_juridica text,
  p_documento text, p_tipo_documento text,
  p_telefono text, p_correo text, p_direccion text
) returns uuid
language plpgsql security definer set search_path = public as $$
declare v_id uuid := coalesce(p_id, gen_random_uuid());
begin
  if not es_admin() then
    raise exception 'No autorizado: se requiere una cuenta administradora de CDMB.';
  end if;
  if (p_nombres is null or trim(p_nombres) = '')
     and (p_razon_social is null or trim(p_razon_social) = '') then
    raise exception 'Pon el nombre (persona natural) o la razón social (jurídica).';
  end if;
  insert into representantes
    (id, nombres, apellidos, razon_social, naturaleza_juridica,
     documento, tipo_documento, telefono, correo, direccion)
  values (v_id, nullif(trim(coalesce(p_nombres,'')), ''), p_apellidos,
          nullif(trim(coalesce(p_razon_social,'')), ''), p_naturaleza_juridica,
          p_documento, p_tipo_documento, p_telefono, p_correo, p_direccion)
  on conflict (id) do update set
    nombres = excluded.nombres, apellidos = excluded.apellidos,
    razon_social = excluded.razon_social,
    naturaleza_juridica = excluded.naturaleza_juridica,
    documento = excluded.documento, tipo_documento = excluded.tipo_documento,
    telefono = excluded.telefono, correo = excluded.correo,
    direccion = excluded.direccion, updated_at = now();
  return v_id;
end $$;

do $$
declare f text;
begin
  foreach f in array array[
    'guardar_responsable(uuid,text,text,text,text,text,text,text,text)',
    'guardar_delegado(uuid,text,text,text,text,text,text,text,text)',
    'guardar_representante(uuid,text,text,text,text,text,text,text,text,text)'
  ]
  loop
    execute format('revoke all on function %s from public', f);
    execute format('grant execute on function %s to authenticated', f);
  end loop;
end $$;

-- El nombre que se copia a negocios.representante_legal: razón social si es
-- jurídica, si no nombres + apellidos.
create or replace function _display_representante(p_id uuid)
returns text language sql stable set search_path = public as $$
  select coalesce(
           nullif(trim(coalesce(razon_social,'')), ''),
           nullif(trim(coalesce(nombres,'') || ' ' || coalesce(apellidos,'')), '')
         )
  from representantes where id = p_id
$$;

create or replace function asignar_representante_negocio(
  p_negocio_id uuid, p_representante_id uuid,
  p_nit text default null, p_naturaleza_juridica text default null,
  p_nota text default null
) returns void
language plpgsql security definer set search_path = public as $$
declare
  v_actual uuid;
  v_nit_actual text;
  v_nat_actual text;
begin
  if not es_admin() then
    raise exception 'No autorizado: se requiere una cuenta administradora de CDMB.';
  end if;
  select representante_id, nit, naturaleza_juridica
    into v_actual, v_nit_actual, v_nat_actual
  from negocio_representante
  where negocio_id = p_negocio_id and vigente_hasta is null;

  if v_actual is not distinct from p_representante_id
     and v_nit_actual is not distinct from p_nit
     and v_nat_actual is not distinct from p_naturaleza_juridica then
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
          jsonb_build_object('representante_id', p_representante_id,
                             'nit', p_nit, 'naturaleza_juridica', p_naturaleza_juridica,
                             'nota', p_nota));
end $$;

revoke all on function asignar_representante_negocio(uuid,uuid,text,text,text) from public;
grant execute on function asignar_representante_negocio(uuid,uuid,text,text,text) to authenticated;
