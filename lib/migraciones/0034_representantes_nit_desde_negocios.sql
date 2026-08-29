-- 0034_representantes_nit_desde_negocios.sql
--
-- El NIT / cédula de cada representante legal YA está en la base: en la
-- tabla puente `negocio_representante` (columna `nit`, poblada en 0029 desde
-- `negocios.nit`). Pero `representantes.documento` quedó vacío, así que el
-- buscador de representantes no encontraba a nadie por NIT ni por cédula.
--
--   1) Backfill: para cada representante cuyos negocios comparten UN mismo
--      NIT, se copia a `representantes.documento` (y `tipo_documento` según
--      la naturaleza). Si tiene NITs distintos en varios negocios, se deja
--      vacío (no se puede elegir uno solo).
--   2) La vista `v_representantes` gana `nits_negocios` = todos los NITs
--      distintos de sus negocios, separados por espacio, para que el
--      buscador filtre también por ahí aunque `documento` esté vacío.
--
-- Idempotente. Depende de 0031/0033.

update representantes r set
  documento = sub.doc,
  tipo_documento = case
    when r.naturaleza_juridica = 'Jurídica' then 'NIT'
    when r.naturaleza_juridica = 'Natural' then 'Cédula de ciudadanía'
    else r.tipo_documento
  end
from (
  select representante_id,
         case when count(distinct nit) = 1 then max(nit) end as doc
  from negocio_representante
  where nit is not null and trim(nit) <> ''
  group by representante_id
) sub
where sub.representante_id = r.id
  and sub.doc is not null
  and (r.documento is null or trim(r.documento) = '');

-- Recrear la vista para sumar nits_negocios (y de paso re-expandir `p.*`,
-- ver la lección de 0033).
drop view if exists v_representantes;
create view v_representantes
with (security_invoker = true) as
select p.*,
  (select count(*) from negocio_representante nr where nr.representante_id = p.id)
    as negocios_total,
  (select count(*) from negocio_representante nr
    where nr.representante_id = p.id and nr.vigente_hasta is null)
    as negocios_vigentes,
  (select string_agg(distinct nr.nit, ' ')
    from negocio_representante nr
    where nr.representante_id = p.id and nr.nit is not null and trim(nr.nit) <> '')
    as nits_negocios
from representantes p;

grant select on v_representantes to authenticated;
revoke all on v_representantes from anon;
