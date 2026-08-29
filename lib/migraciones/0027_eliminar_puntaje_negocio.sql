-- 0027_eliminar_puntaje_negocio.sql
--
-- Gestión de puntajes de seguimiento por año desde /admin/negocios:
-- ya existía `guardar_puntaje_negocio` (0022) para crear/actualizar un año,
-- faltaba poder QUITAR un año cargado por error. Mismo patrón exacto:
-- SECURITY DEFINER + chequeo es_admin() interno (bypassa RLS por diseño,
-- ver CLAUDE.md — el chequeo interno no es opcional), revoke a public y
-- grant solo a authenticated.
--
-- El historial completo (todos los años con puntaje de cada negocio) ya se
-- lee tal cual desde negocio_puntajes; no hace falta nada nuevo para eso.

create or replace function eliminar_puntaje_negocio(
  p_negocio_id uuid,
  p_anio smallint
)
returns void
language plpgsql
security definer
set search_path = public
as $$
begin
  if not es_admin() then
    raise exception 'No autorizado: se requiere una cuenta administradora de CDMB.';
  end if;

  delete from negocio_puntajes
  where negocio_id = p_negocio_id and anio = p_anio;
end;
$$;

revoke all on function eliminar_puntaje_negocio from public;
grant execute on function eliminar_puntaje_negocio to authenticated;
