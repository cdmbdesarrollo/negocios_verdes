-- 0030_personas_vistas_y_eliminar.sql
--
-- Pantalla /admin/personas: gestionar los tres tipos de persona (ver 0029)
-- sin tener que abrir un negocio.
--
--   * 3 vistas `v_*` = la tabla + a cuántos negocios está asignada cada
--     persona (en total y vigentes ahora). `security_invoker = true` para
--     que la RLS de la tabla base (solo admin) siga aplicando.
--   * 3 RPC `eliminar_*` para borrar una persona SOLO si nunca se asignó a
--     ningún negocio (si tiene historial se conserva — la traza no se
--     rompe; el mensaje se lo explica al admin).
--
-- Idempotente. Depende de 0029.

create or replace view v_responsables_cdmb
with (security_invoker = true) as
select r.*,
  (select count(*) from negocio_responsable nr where nr.responsable_id = r.id)
    as negocios_total,
  (select count(*) from negocio_responsable nr
    where nr.responsable_id = r.id and nr.vigente_hasta is null)
    as negocios_vigentes
from responsables_cdmb r;

create or replace view v_delegados
with (security_invoker = true) as
select d.*,
  (select count(*) from negocio_delegado nd where nd.delegado_id = d.id)
    as negocios_total,
  (select count(*) from negocio_delegado nd
    where nd.delegado_id = d.id and nd.vigente_hasta is null)
    as negocios_vigentes
from delegados d;

create or replace view v_representantes
with (security_invoker = true) as
select p.*,
  (select count(*) from negocio_representante nr where nr.representante_id = p.id)
    as negocios_total,
  (select count(*) from negocio_representante nr
    where nr.representante_id = p.id and nr.vigente_hasta is null)
    as negocios_vigentes
from representantes p;

grant select on v_responsables_cdmb, v_delegados, v_representantes to authenticated;
revoke all on v_responsables_cdmb, v_delegados, v_representantes from anon;

create or replace function eliminar_responsable(p_id uuid) returns void
language plpgsql security definer set search_path = public as $$
begin
  if not es_admin() then
    raise exception 'No autorizado: se requiere una cuenta administradora de CDMB.';
  end if;
  if exists (select 1 from negocio_responsable where responsable_id = p_id) then
    raise exception 'No se puede eliminar: esta persona está (o estuvo) asignada a un negocio. Quítala de los negocios primero; el historial se conserva.';
  end if;
  delete from responsables_cdmb where id = p_id;
end $$;

create or replace function eliminar_delegado(p_id uuid) returns void
language plpgsql security definer set search_path = public as $$
begin
  if not es_admin() then
    raise exception 'No autorizado: se requiere una cuenta administradora de CDMB.';
  end if;
  if exists (select 1 from negocio_delegado where delegado_id = p_id) then
    raise exception 'No se puede eliminar: esta persona está (o estuvo) asignada a un negocio. Quítala de los negocios primero; el historial se conserva.';
  end if;
  delete from delegados where id = p_id;
end $$;

create or replace function eliminar_representante(p_id uuid) returns void
language plpgsql security definer set search_path = public as $$
begin
  if not es_admin() then
    raise exception 'No autorizado: se requiere una cuenta administradora de CDMB.';
  end if;
  if exists (select 1 from negocio_representante where representante_id = p_id) then
    raise exception 'No se puede eliminar: esta persona está (o estuvo) asignada a un negocio. Quítala de los negocios primero; el historial se conserva.';
  end if;
  delete from representantes where id = p_id;
end $$;

do $$
declare
  f text;
begin
  foreach f in array array[
    'eliminar_responsable(uuid)',
    'eliminar_delegado(uuid)',
    'eliminar_representante(uuid)'
  ]
  loop
    execute format('revoke all on function %s from public', f);
    execute format('grant execute on function %s to authenticated', f);
  end loop;
end $$;
