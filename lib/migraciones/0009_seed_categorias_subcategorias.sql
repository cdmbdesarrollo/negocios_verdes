-- 0009_seed_categorias_subcategorias.sql
-- Semilla inicial de categorías oficiales y subcategorías descriptivas.
--
-- Es investigación propia (negociosverdes.gov.co + Corpamag), NO una
-- transcripción literal de un documento CDMB vigente — revisar y ajustar
-- desde /admin/categorias y /admin/subcategorias si no calza exactamente
-- con la clasificación real que usa CDMB. No hace falta tocar código para
-- corregir nombres, agregar o desactivar categorías/subcategorías.

insert into categorias_oficiales (nombre, slug, descripcion, icono, orden) values
  ('Agrosistemas Sostenibles', 'agrosistemas-sostenibles', 'Agricultura, ganadería y producción agropecuaria con prácticas sostenibles.', '🌱', 1),
  ('Biocomercio y Uso Sostenible de la Biodiversidad', 'biocomercio', 'Aprovechamiento sostenible de especies nativas, ingredientes naturales, fauna y flora.', '🌿', 2),
  ('Ecoturismo y Turismo de Naturaleza', 'ecoturismo', 'Servicios turísticos con enfoque de conservación del entorno natural.', '🥾', 3),
  ('Construcción Sostenible', 'construccion-sostenible', 'Bioconstrucción y arquitectura con materiales y técnicas de bajo impacto.', '🏗️', 4),
  ('Energías Renovables', 'energias-renovables', 'Generación y uso de fuentes no convencionales de energía renovable.', '☀️', 5),
  ('Aprovechamiento y Valorización de Residuos', 'aprovechamiento-residuos', 'Reciclaje, reúso y economía circular.', '♻️', 6),
  ('Ecoproductos Industriales y Tecnologías Verdes', 'ecoproductos-industriales', 'Bienes manufacturados con menor impacto ambiental.', '🧪', 7),
  ('Educación y Consultoría Ambiental', 'educacion-consultoria-ambiental', 'Formación, asesoría y servicios técnicos ambientales.', '📚', 8)
on conflict (slug) do nothing;

insert into subcategorias (categoria_oficial_id, nombre, slug, icono, orden)
select c.id, s.nombre, s.slug, s.icono, s.orden
from (values
  ('agrosistemas-sostenibles', 'Apicultura', 'apicultura', '🐝', 1),
  ('agrosistemas-sostenibles', 'Café Especial y Orgánico', 'cafe-especial-organico', '☕', 2),
  ('agrosistemas-sostenibles', 'Huertas Agroecológicas', 'huertas-agroecologicas', '🥬', 3),
  ('agrosistemas-sostenibles', 'Ganadería Sostenible', 'ganaderia-sostenible', '🐄', 4),
  ('agrosistemas-sostenibles', 'Agroforestería', 'agroforesteria', '🌳', 5),

  ('biocomercio', 'Cosmética Natural', 'cosmetica-natural', '🧴', 1),
  ('biocomercio', 'Artesanías con Fibras Naturales', 'artesanias-fibras-naturales', '🧺', 2),
  ('biocomercio', 'Plantas Medicinales', 'plantas-medicinales', '🌾', 3),
  ('biocomercio', 'Viveros de Especies Nativas', 'viveros-especies-nativas', '🪴', 4),

  ('ecoturismo', 'Turismo de Aventura', 'turismo-aventura', '🧗', 1),
  ('ecoturismo', 'Avistamiento de Aves', 'avistamiento-aves', '🦜', 2),
  ('ecoturismo', 'Senderismo Ecológico', 'senderismo-ecologico', '🥾', 3),
  ('ecoturismo', 'Hospedaje Ecológico', 'hospedaje-ecologico', '🏕️', 4),
  ('ecoturismo', 'Agroturismo', 'agroturismo', '🚜', 5),

  ('construccion-sostenible', 'Bioconstrucción', 'bioconstruccion', '🧱', 1),
  ('construccion-sostenible', 'Arquitectura Bioclimática', 'arquitectura-bioclimatica', '🏡', 2),

  ('energias-renovables', 'Energía Solar', 'energia-solar', '🔆', 1),
  ('energias-renovables', 'Estufas Eficientes y Ecológicas', 'estufas-eficientes', '🔥', 2),

  ('aprovechamiento-residuos', 'Reciclaje', 'reciclaje', '♻️', 1),
  ('aprovechamiento-residuos', 'Compostaje y Lombricultura', 'compostaje-lombricultura', '🪱', 2),
  ('aprovechamiento-residuos', 'Economía Circular', 'economia-circular', '🔄', 3),

  ('ecoproductos-industriales', 'Aseo y Cosmética Biodegradable', 'aseo-cosmetica-biodegradable', '🧼', 1),
  ('ecoproductos-industriales', 'Empaques Biodegradables', 'empaques-biodegradables', '📦', 2),

  ('educacion-consultoria-ambiental', 'Educación Ambiental', 'educacion-ambiental', '🎓', 1),
  ('educacion-consultoria-ambiental', 'Consultoría en Sostenibilidad', 'consultoria-sostenibilidad', '📋', 2)
) as s(categoria_slug, nombre, slug, icono, orden)
join categorias_oficiales c on c.slug = s.categoria_slug
on conflict (slug) do nothing;
