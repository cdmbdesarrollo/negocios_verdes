-- 0017_iconos_actividades_productivas.sql
--
-- 0016 le puso emoji a categorías y subcategorías al sembrar la taxonomía
-- oficial del Plan Nacional de Negocios Verdes 2022-2030, pero el insert de
-- actividades_productivas solo trajo (subcategoria_id, nombre, slug, orden)
-- — se quedó sin icono. Esta migración solo llena esa columna por slug, no
-- toca nombres/orden/estructura. No requiere ningún cambio de código nuevo:
-- el Dart que lee actividad.icono ya está desplegado desde el reordenamiento
-- de filtros Municipio/Categoría/Subcategoría/Actividad — apenas corra este
-- UPDATE, los íconos aparecen solos.

update actividades_productivas set icono = v.icono
from (values
  ('agricultura-organica', '🌱'),
  ('agroecologia', '🌿'),
  ('agricultura-sostenible', '🚜'),
  ('ganaderia-sostenible', '🐄'),
  ('acuicultura-pesca-sostenible', '🐟'),

  ('agroindustrial-alimentario', '🥫'),
  ('agroindustrial-no-alimentario', '⚙️'),

  ('recursos-geneticos-productos-derivados', '🧪'),
  ('productos-fauna-silvestre', '🦎'),
  ('no-maderables', '🌰'),
  ('maderables', '🪵'),

  ('productos-biotecnologia', '🔬'),

  ('servicios-turismo-naturaleza', '🏞️'),
  ('otros-servicios-turismo-sostenible', '🧭'),

  ('aprovechamiento-residuos-organicos', '🍂'),
  ('aprovechamiento-residuos-inorganicos', '🗑️'),

  ('textiles-sostenibles', '🧵'),
  ('confeccion-manufactura', '✂️'),
  ('joyeria-artesania-bisuteria', '💍'),

  ('construccion-edificaciones-infraestructura', '🏢'),
  ('biomateriales-ecomateriales-equipos-ecoeficientes', '🧱'),

  ('biopolimeros-fibras-empaques-reciclables', '🧴'),

  ('generacion-comercializacion-energia-fncer', '☀️'),
  ('tecnologias-informacion-ambiental', '💻'),

  ('preservacion', '🌲'),
  ('restauracion', '🪴'),
  ('recuperacion-remediacion', '🩹'),

  ('motorizado', '🚗'),
  ('no-motorizado', '🚶')
) as v(slug, icono)
where actividades_productivas.slug = v.slug;
