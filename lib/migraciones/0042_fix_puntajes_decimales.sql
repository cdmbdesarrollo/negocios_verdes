-- 0042_fix_puntajes_decimales.sql
--
-- Corrección de datos: 4 puntajes de seguimiento quedaron guardados como
-- fracción (0.61, 0.67, 0.67, 0.68) en vez de sobre 100 (61, 67, 67, 68) —
-- heredado de la carga 0026, donde esas celdas venían con formato de
-- porcentaje. Se veía en el dashboard como un promedio anual más bajo de lo
-- real. El historial de esos negocios confirma la escala (p. ej. 2022:65.74
-- 2023:65.74 2024:0.68 2025:73.60).
--
-- Los 0.00 (3 filas de 2025) NO se tocan: son negocios no calificados ese
-- año y el dashboard ya los excluye de los promedios (puntaje > 0).
--
-- A futuro: CHECK de rango 0–100 en la tabla. Un 0 < puntaje < 1 lo
-- rechaza el formulario admin (validador del campo), no la base, por si
-- alguna vez existe un puntaje real así de bajo.

update negocio_puntajes
set puntaje = round(puntaje * 100, 2)
where puntaje > 0 and puntaje < 1;

alter table negocio_puntajes drop constraint if exists negocio_puntajes_rango;
alter table negocio_puntajes add constraint negocio_puntajes_rango
  check (puntaje >= 0 and puntaje <= 100);
