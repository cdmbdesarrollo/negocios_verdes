-- 0033_refrescar_vistas_personas.sql
--
-- HOTFIX. Postgres NO re-expande `select *` cuando se agregan columnas a la
-- tabla base: congela la lista de columnas al crear la vista. 0031 y 0032
-- agregaron columnas a responsables_cdmb / delegados / representantes pero
-- las vistas `v_*` (0030) siguieron con las columnas viejas — el admin
-- pedía `v_responsables_cdmb.tipo_documento` y Postgres respondía "column
-- does not exist", rompiendo /admin/personas Y el formulario de edición de
-- cualquier negocio (que también lee de las vistas).
--
-- Se recrean las 3 vistas para que `r.*` vuelva a expandir todas las
-- columnas actuales. (Los comentarios de 0031/0032 que decían "las vistas
-- recogen las columnas nuevas solas" estaban equivocados.)
--
-- Idempotente. Correr DESPUÉS de 0032.

drop view if exists v_responsables_cdmb;
drop view if exists v_delegados;
drop view if exists v_representantes;

create view v_responsables_cdmb
with (security_invoker = true) as
select r.*,
  (select count(*) from negocio_responsable nr where nr.responsable_id = r.id)
    as negocios_total,
  (select count(*) from negocio_responsable nr
    where nr.responsable_id = r.id and nr.vigente_hasta is null)
    as negocios_vigentes
from responsables_cdmb r;

create view v_delegados
with (security_invoker = true) as
select d.*,
  (select count(*) from negocio_delegado nd where nd.delegado_id = d.id)
    as negocios_total,
  (select count(*) from negocio_delegado nd
    where nd.delegado_id = d.id and nd.vigente_hasta is null)
    as negocios_vigentes
from delegados d;

create view v_representantes
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
