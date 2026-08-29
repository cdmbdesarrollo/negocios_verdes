-- 0035_representante_razon_social_por_negocio.sql
--
-- La razón social es DEL NEGOCIO, y un mismo representante legal puede
-- firmar por varios negocios con razones sociales (y NITs) distintos. Se
-- guarda por vínculo, en la tabla puente `negocio_representante`, junto al
-- NIT y la naturaleza que ya vivían ahí (0029/0031).
--
--   * `negocio_representante.razon_social` (nueva). Backfill: el nombre del
--     negocio cuando su naturaleza es Jurídica.
--   * `representantes.razon_social` (0031) queda como cache del valor único
--     — backfill cuando todos sus vínculos comparten una sola razón social.
--   * `asignar_representante_negocio` gana `p_razon_social` (firma nueva: se
--     borra y recrea, patrón de 0028/0031).
--   * `v_representantes` gana `nits_negocios` (ya en 0034) y
--     `razones_negocios` para el buscador.
--
-- `negocios.representante_legal` (público, denormalizado) sigue siendo el
-- NOMBRE DE LA PERSONA (`_display_representante`), no la razón social.
--
-- Idempotente. Depende de 0034.

alter table negocio_representante add column if not exists razon_social text;

update negocio_representante nr set razon_social = n.nombre
from negocios n
where n.id = nr.negocio_id
  and nr.naturaleza_juridica = 'Jurídica'
  and (nr.razon_social is null or trim(nr.razon_social) = '');

update representantes r set razon_social = sub.rs
from (
  select representante_id,
         case when count(distinct razon_social) = 1 then max(razon_social) end as rs
  from negocio_representante
  where razon_social is not null and trim(razon_social) <> ''
  group by representante_id
) sub
where sub.representante_id = r.id
  and sub.rs is not null
  and (r.razon_social is null or trim(r.razon_social) = '');

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
  p_razon_social text default null, p_nota text default null
) returns void
language plpgsql security definer set search_path = public as $$
declare
  v_actual uuid; v_nit text; v_nat text; v_rs text;
begin
  if not es_admin() then
    raise exception 'No autorizado: se requiere una cuenta administradora de CDMB.';
  end if;
  select representante_id, nit, naturaleza_juridica, razon_social
    into v_actual, v_nit, v_nat, v_rs
  from negocio_representante
  where negocio_id = p_negocio_id and vigente_hasta is null;

  if v_actual is not distinct from p_representante_id
     and v_nit is not distinct from p_nit
     and v_nat is not distinct from p_naturaleza_juridica
     and v_rs is not distinct from p_razon_social then
    return;
  end if;

  update negocio_representante set vigente_hasta = now()
  where negocio_id = p_negocio_id and vigente_hasta is null;
  insert into negocio_representante
    (negocio_id, representante_id, nit, naturaleza_juridica, razon_social,
     asignado_por, nota)
  values (p_negocio_id, p_representante_id, p_nit, p_naturaleza_juridica,
          p_razon_social, auth.uid(), p_nota);
  update negocios set
    representante_legal = _display_representante(p_representante_id),
    nit = p_nit,
    naturaleza_juridica = p_naturaleza_juridica
  where id = p_negocio_id;
  insert into admin_logs (admin_id, accion, entidad, entidad_id, detalle)
  values (auth.uid(), 'asignar_representante', 'negocios', p_negocio_id,
          jsonb_build_object('representante_id', p_representante_id, 'nit', p_nit,
                             'naturaleza_juridica', p_naturaleza_juridica,
                             'razon_social', p_razon_social, 'nota', p_nota));
end $$;

revoke all on function asignar_representante_negocio(uuid,uuid,text,text,text,text) from public;
grant execute on function asignar_representante_negocio(uuid,uuid,text,text,text,text) to authenticated;

drop view if exists v_representantes;
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
  (select string_agg(distinct nr.razon_social, ' | ') from negocio_representante nr
    where nr.representante_id = p.id and nr.razon_social is not null
      and trim(nr.razon_social) <> '')
    as razones_negocios
from representantes p;
grant select on v_representantes to authenticated;
revoke all on v_representantes from anon;
