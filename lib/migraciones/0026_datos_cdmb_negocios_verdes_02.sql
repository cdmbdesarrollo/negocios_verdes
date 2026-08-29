begin;

-- Generado por lib/migraciones/generar_0026.py desde BASE_ACTUALIZADA_NV_ka.xlsx — no editar a mano.
-- Uno de varios archivos partidos (ver README.md) — correr TODOS, en cualquier orden, cada uno es su propia transacción.

-- Parte 2 de 17.

-- Categoría comodín para negocios sin categoría reconocible en el
-- Excel (columna NOT NULL, no se puede dejar en blanco). activo=false
-- así no aparece como chip de filtro en el buscador público.
insert into categorias_oficiales (nombre, slug, descripcion, icono, orden, activo)
select 'Pendiente de clasificar', 'pendiente-clasificar',
  'Negocio importado de la base CDMB sin categoría oficial asignada todavía — revisar y corregir desde /admin/negocios.',
  '⏳', 99, false
where not exists (select 1 from categorias_oficiales where slug = 'pendiente-clasificar');

delete from negocios where nombre = 'Bucarretes SAS BIC';

-- Veredas encontradas en la base real (normalizadas de escritura).
insert into veredas (municipio, nombre, slug) values
  ('Bucaramanga', 'Perimetro Urbano', 'perimetro-urbano'),
  ('Bucaramanga', 'Rosa Blanca', 'rosa-blanca'),
  ('Bucaramanga', 'San Jose', 'san-jose'),
  ('Bucaramanga', 'San Pedro Bajo', 'san-pedro-bajo'),
  ('Bucaramanga', 'Santos Bajo', 'santos-bajo'),
  ('Bucaramanga', 'Vijagual', 'vijagual'),
  ('California', 'Centro', 'centro'),
  ('California', 'Perimetro Urbano', 'perimetro-urbano'),
  ('Charta', 'Centro Trincheras Parte Baja', 'centro-trincheras-parte-baja'),
  ('Charta', 'El Roble', 'el-roble'),
  ('Charta', 'Perimetro Urbano', 'perimetro-urbano'),
  ('El Playón', 'Perimetro Urbano', 'perimetro-urbano'),
  ('El Playón', 'San Pedro de la Tigra', 'san-pedro-de-la-tigra'),
  ('Floridablanca', 'Helechales', 'helechales'),
  ('Floridablanca', 'LA Judia', 'la-judia'),
  ('Floridablanca', 'Monterrey - Acapulco', 'monterrey-acapulco'),
  ('Floridablanca', 'Perimetro Urbano', 'perimetro-urbano'),
  ('Floridablanca', 'Vericute', 'vericute'),
  ('Girón', 'Acapulco', 'acapulco'),
  ('Girón', 'Altamira', 'altamira'),
  ('Girón', 'Chocoita', 'chocoita'),
  ('Girón', 'El Cedro', 'el-cedro'),
  ('Girón', 'Lagunetas', 'lagunetas'),
  ('Girón', 'Llano Grande', 'llano-grande'),
  ('Girón', 'Motoso', 'motoso'),
  ('Girón', 'Nazareth', 'nazareth'),
  ('Girón', 'Palmitas', 'palmitas'),
  ('Girón', 'Perimetro Urbano', 'perimetro-urbano'),
  ('Girón', 'Rio Frio', 'rio-frio'),
  ('Lebrija', 'Altos de Palonegro', 'altos-de-palonegro'),
  ('Lebrija', 'Cuchilla', 'cuchilla'),
  ('Lebrija', 'EL Cosme', 'el-cosme'),
  ('Lebrija', 'La Cuchilla', 'la-cuchilla'),
  ('Lebrija', 'Lisboa', 'lisboa'),
  ('Lebrija', 'Palonegro', 'palonegro'),
  ('Lebrija', 'Panorama', 'panorama'),
  ('Lebrija', 'Perimetro Urbano', 'perimetro-urbano'),
  ('Lebrija', 'Piedras Negras', 'piedras-negras'),
  ('Lebrija', 'San Gabriel', 'san-gabriel'),
  ('Lebrija', 'San Nicolas', 'san-nicolas'),
  ('Lebrija', 'San Nicolas Alto', 'san-nicolas-alto'),
  ('Lebrija', 'San Nicolas Bajo', 'san-nicolas-bajo'),
  ('Lebrija', 'Santa Rosa', 'santa-rosa'),
  ('Lebrija', 'Santo Domingo', 'santo-domingo'),
  ('Matanza', 'Alto Bravo', 'alto-bravo'),
  ('Matanza', 'Aventinos', 'aventinos'),
  ('Matanza', 'El Filo', 'el-filo'),
  ('Matanza', 'Santa Ana', 'santa-ana'),
  ('Piedecuesta', 'Barrio Blanco', 'barrio-blanco'),
  ('Piedecuesta', 'Blanquiscal', 'blanquiscal'),
  ('Piedecuesta', 'Caneyes', 'caneyes'),
  ('Piedecuesta', 'Casiano', 'casiano'),
  ('Piedecuesta', 'Cristales', 'cristales'),
  ('Piedecuesta', 'Diamante', 'diamante'),
  ('Piedecuesta', 'El Diamante', 'el-diamante'),
  ('Piedecuesta', 'El Duende', 'el-duende'),
  ('Piedecuesta', 'El Guamo', 'el-guamo'),
  ('Piedecuesta', 'El Volador', 'el-volador'),
  ('Piedecuesta', 'Guatiguara', 'guatiguara'),
  ('Piedecuesta', 'La Colombiana', 'la-colombiana'),
  ('Piedecuesta', 'La Esperanza', 'la-esperanza'),
  ('Piedecuesta', 'La Urgua', 'la-urgua'),
  ('Piedecuesta', 'Los Colorados', 'los-colorados'),
  ('Piedecuesta', 'Mesita de San Javier', 'mesita-de-san-javier'),
  ('Piedecuesta', 'Monterredondo', 'monterredondo'),
  ('Piedecuesta', 'Perimetro Urbano', 'perimetro-urbano'),
  ('Piedecuesta', 'San Francisco', 'san-francisco'),
  ('Piedecuesta', 'San Miguel', 'san-miguel'),
  ('Piedecuesta', 'Sevilla', 'sevilla'),
  ('Piedecuesta', 'Umpala', 'umpala'),
  ('Piedecuesta', 'Via Curos', 'via-curos'),
  ('Piedecuesta', 'Volador', 'volador'),
  ('Rionegro', 'Honduras Caña Brava', 'honduras-cana-brava'),
  ('Rionegro', 'La Ceiba', 'la-ceiba'),
  ('Rionegro', 'La Cristalina', 'la-cristalina'),
  ('Rionegro', 'La Paz', 'la-paz'),
  ('Rionegro', 'La Plazueña', 'la-plazuena'),
  ('Rionegro', 'La Union', 'la-union'),
  ('Rionegro', 'La Union de Galapagos de Rionegro', 'la-union-de-galapagos-de-rionegro'),
  ('Rionegro', 'Perimetro Urbano', 'perimetro-urbano'),
  ('Rionegro', 'Popas', 'popas'),
  ('Rionegro', 'Portachuelo', 'portachuelo'),
  ('Rionegro', 'San Jose Arevalo', 'san-jose-arevalo'),
  ('Rionegro', 'San Pablo', 'san-pablo'),
  ('Rionegro', 'Valparaiso', 'valparaiso'),
  ('Suratá', 'Bachiga', 'bachiga'),
  ('Suratá', 'Capilla Alta', 'capilla-alta'),
  ('Suratá', 'El Porvenir', 'el-porvenir'),
  ('Suratá', 'La Violeta', 'la-violeta'),
  ('Suratá', 'Vereda Porvenir', 'vereda-porvenir'),
  ('Tona', 'Berlin', 'berlin'),
  ('Tona', 'Perimetro Urbano', 'perimetro-urbano'),
  ('Tona', 'Pirgua Parte Baje', 'pirgua-parte-baje'),
  ('Tona', 'Vegas', 'vegas'),
  ('Vetas', 'El Salado', 'el-salado'),
  ('Vetas', 'LA Chorrera', 'la-chorrera'),
  ('Vetas', 'Mongora', 'mongora')
on conflict (municipio, slug) do nothing;

-- Opciones reales encontradas en el Excel para los campos de
-- selector (incluye responsable_cdmb/delegado) — completa lo que
-- 0025_ficha_tecnica_catalogos.sql no haya anticipado, sin
-- duplicar lo que ya sembró esa migración.
insert into opciones_campo (campo, valor) values
  ('alcantarillado', 'No'),
  ('alcantarillado', 'No hay ficha'),
  ('alcantarillado', 'Sí'),
  ('aplicacion_ficha_2025', 'Actualizó'),
  ('aplicacion_ficha_2025', 'No actualizó'),
  ('buenas_practicas_agricolas', 'No'),
  ('buenas_practicas_agricolas', 'Sí'),
  ('buenas_practicas_apicolas', 'No'),
  ('buenas_practicas_apicolas', 'Sí'),
  ('canal_venta', 'B2B'),
  ('canal_venta', 'B2C'),
  ('canal_venta', 'Mixta'),
  ('capacidad_carga', 'No'),
  ('capacidad_carga', 'Sí'),
  ('certificado_tenencia_animales', 'No'),
  ('concesion_aguas', 'Acueducto'),
  ('concesion_aguas', 'Acueducto veredal'),
  ('concesion_aguas', 'No'),
  ('concesion_aguas', 'No hay ficha'),
  ('concesion_aguas', 'Sí'),
  ('delegado', 'ADRIANA BUENO'),
  ('delegado', 'ANDREA JULIANA MORENO - CRISTIAN SALGUERO'),
  ('delegado', 'ANDREA SUPELANO PRADA'),
  ('delegado', 'CARMEN EDUVIA PRADA'),
  ('delegado', 'CLAUDIA LORENA RUEDA'),
  ('delegado', 'DANIELA'),
  ('delegado', 'DAVID MURCIA'),
  ('delegado', 'DEISY VIVIANA ARDILA CARDENAS'),
  ('delegado', 'DIANA LUCERO BUITRAGO FORERO'),
  ('delegado', 'DIANA MARCELA BARRIOS'),
  ('delegado', 'DIEGO VILLAMIL'),
  ('delegado', 'EDINSON FRIAS'),
  ('delegado', 'EDINSON ROJAS - INGRID ROJAS'),
  ('delegado', 'EDWIN YESID MURCIA DIAZ'),
  ('delegado', 'ELIZABETH PINZON'),
  ('delegado', 'ESELL NUNES'),
  ('delegado', 'FERNANDO BAUTISTA ZAPATA'),
  ('delegado', 'GABRIEL ALBERTO MARQUEZ FRANCO'),
  ('delegado', 'ISMALDO LIZCANO'),
  ('delegado', 'IVONNE PAOLA HINCAPIE'),
  ('delegado', 'JAIME GONZALES LEON'),
  ('delegado', 'JAZMIN RODRIGUEZ'),
  ('delegado', 'JORGE BLANCO'),
  ('delegado', 'JUAN DAVID MESA'),
  ('delegado', 'LORENA CADAVID VALENCIA'),
  ('delegado', 'LUZ DARY'),
  ('delegado', 'LYAN PIERRE FELIPE GALVIS GIL'),
  ('delegado', 'MARIO CASTAÑEDA'),
  ('delegado', 'MAYRA ALVAREZ'),
  ('delegado', 'MERCEDES ANGEL MORENO'),
  ('delegado', 'MILTON HERNÁNDEZ'),
  ('delegado', 'MIRIAM VARGAS'),
  ('delegado', 'NANCY DOMINGUEZ'),
  ('delegado', 'NANCY JAIMES'),
  ('delegado', 'NELSON PEREZ'),
  ('delegado', 'OSCAR ORTIZ BALLESTEROS'),
  ('delegado', 'PAOLA ORTEGA'),
  ('delegado', 'RICARDO CENTENO'),
  ('delegado', 'SANDRA REY HERNANDEZ'),
  ('delegado', 'SERGIO ANDRES MORENO HERNANDEZ'),
  ('delegado', 'VLADIMIR LEON'),
  ('delegado', 'YAZMIN RIVERA GOMEZ'),
  ('exportacion', 'No'),
  ('exportacion', 'Sí'),
  ('ica', 'No'),
  ('ica', 'No hay ficha'),
  ('ica', 'Sí'),
  ('intervencion_cauce', 'No'),
  ('invima', 'No'),
  ('invima', 'Sí'),
  ('pgris', 'No'),
  ('pgris', 'No hay ficha'),
  ('pgris', 'Sí'),
  ('pozo_septico', 'No'),
  ('pozo_septico', 'No hay ficha'),
  ('pozo_septico', 'Sí'),
  ('pueaa', 'No'),
  ('pueaa', 'No hay ficha'),
  ('pueaa', 'Sí'),
  ('registro_apicola', 'No'),
  ('registro_nacional_turismo', 'No'),
  ('registro_nacional_turismo', 'Sí'),
  ('responsable_cdmb', 'ALEXANDER FLOREZ'),
  ('responsable_cdmb', 'ALEXANDRA SOTOMONTE'),
  ('responsable_cdmb', 'ALVARO ALFEREZ'),
  ('responsable_cdmb', 'ANA RUEDA'),
  ('responsable_cdmb', 'ANDRES VALDERRAMA'),
  ('responsable_cdmb', 'CARINE GARCIA'),
  ('responsable_cdmb', 'CLAUDIA SANCHEZ'),
  ('responsable_cdmb', 'CRISTAL VILLAREAL'),
  ('responsable_cdmb', 'DANIEL BONNET'),
  ('responsable_cdmb', 'DIANA NAVARRO'),
  ('responsable_cdmb', 'DIEGO GUTIERREZ'),
  ('responsable_cdmb', 'EDITH GARCÍA'),
  ('responsable_cdmb', 'GENNY JULIANA FERREIRA'),
  ('responsable_cdmb', 'HEINER ORTIZ'),
  ('responsable_cdmb', 'IAN CARLOS RUIZ'),
  ('responsable_cdmb', 'JENNIFER BLANCO'),
  ('responsable_cdmb', 'JUAN JOSE'),
  ('responsable_cdmb', 'JUAN SEBASTIAN'),
  ('responsable_cdmb', 'JULIAN CACERES'),
  ('responsable_cdmb', 'KAREN CAMACHO'),
  ('responsable_cdmb', 'LAURA CAROLINA RODRIGUEZ'),
  ('responsable_cdmb', 'LAURA RUIZ'),
  ('responsable_cdmb', 'LILIANA CACERES'),
  ('responsable_cdmb', 'LUZ ANDREA ISAZA'),
  ('responsable_cdmb', 'NATALY RAMIREZ'),
  ('responsable_cdmb', 'PIER FRATALLI'),
  ('responsable_cdmb', 'SARY YULITZA HIDALGO'),
  ('responsable_cdmb', 'SEBASTIAN BONNET'),
  ('responsable_cdmb', 'SILVIA GARCIA'),
  ('responsable_cdmb', 'SILVIA VALDIVIESO'),
  ('responsable_cdmb', 'SIOMAR FLOREZ'),
  ('responsable_cdmb', 'SUJEY DÍAZ'),
  ('responsable_cdmb', 'VIVIANA ANDREA BARAJAS'),
  ('responsable_cdmb', 'XIMENA REYES'),
  ('responsable_cdmb', 'YEINNI PAOLA CRISTANCHO'),
  ('rut_camara_comercio', 'Cámara de comercio'),
  ('rut_camara_comercio', 'Cámara de comercio y RUT'),
  ('rut_camara_comercio', 'No tiene'),
  ('rut_camara_comercio', 'RUT'),
  ('rut_camara_comercio', 'Sin verificar'),
  ('sstt', 'En implementación'),
  ('sstt', 'No'),
  ('sstt', 'No hay ficha'),
  ('sstt', 'Sí'),
  ('tipo_negocio_verde', 'Avanzado'),
  ('tipo_negocio_verde', 'Básico'),
  ('tipo_negocio_verde', 'Dinamizadoras'),
  ('tipo_negocio_verde', 'Inicial'),
  ('tipo_negocio_verde', 'Intermedio'),
  ('tipo_negocio_verde', 'No aplica'),
  ('tipo_negocio_verde', 'Satisfactorio'),
  ('uso_suelo', 'No'),
  ('uso_suelo', 'SI. Hay un certificado'),
  ('uso_suelo', 'Sí'),
  ('vertimientos', 'No'),
  ('vertimientos', 'No hay ficha'),
  ('vertimientos', 'Requiere'),
  ('vertimientos', 'Sí')
on conflict (campo, valor) do nothing;


-- Negocios de esta parte (INSERT + categoría/subcategoría/actividad + puntajes de cada uno, juntos).

-- BEBIDAS LEJAYIM S.A.S. BIC
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'),
  municipio = 'Lebrija',
  vereda_id = (select id from veredas where municipio = 'Lebrija' and slug = 'santo-domingo'),
  direccion = 'FINCA VISTA HERMOSA VEREDA SANTO DOMINGO',
  latitud = 7.103086666666666,
  longitud = -73.23898750000001,
  descripcion_corta = 'Explotación de la industria alimenticia en general, en especial las frutas, hortalizas y sus derivados y los negocios que se relacionen directamente con…',
  descripcion = 'Explotación de la industria alimenticia en general, en especial las frutas, hortalizas y sus derivados y los negocios que se relacionen directamente con dicha industria. Producción y comercialización de frutas en presentaciones como jugos, zumos, bebidas saludables y fruta fresca. Su objeto social también incluye las actividades propias de las sociedades BIC',
  producto = 'BEBIDAS NATURALES',
  telefono = '3163550373',
  whatsapp = '573163550373',
  email = 'bebidaslejayim@gmail.com',
  representante_legal = 'GERARDO RIVERA ARANDA',
  nit = '901178193-6',
  naturaleza_juridica = 'Jurídica',
  delegado = 'YAZMIN RIVERA GOMEZ',
  rut_camara_comercio = 'Cámara de comercio',
  responsable_cdmb = 'SEBASTIAN BONNET',
  novedad = 'ACTIVO',
  tipo_negocio_verde = 'Dinamizadoras',
  anio_registro = 2019,
  cota_msnm = '1140.8 msnm',
  este = '73°14''20.355''''',
  norte = '7°6''11.112''''',
  aplicacion_ficha_2025 = 'Actualizó',
  observaciones = null,
  registro_nacional_turismo = null,
  uso_suelo = 'Sí',
  concesion_aguas = 'Acueducto veredal',
  concesion_aguas_vencimiento = null,
  vertimientos = null,
  vertimientos_vencimiento = null,
  pueaa = 'No',
  pgris = 'Sí',
  pozo_septico = 'Sí',
  alcantarillado = null,
  ica = null,
  ica_vencimiento = null,
  invima = 'Sí',
  invima_vencimiento = '2029-04-23',
  certificado_tenencia_animales = null,
  buenas_practicas_agricolas = null,
  buenas_practicas_apicolas = null,
  registro_apicola = null,
  intervencion_cauce = null,
  capacidad_carga = null,
  sstt = 'Sí',
  canal_venta = 'Mixta',
  exportacion = 'No',
  huella_carbono = 'SI',
  fortalezas_ambiental = 'Cultivo propio de frutas bajo prácticas orgánicas (sin químicos ni pesticidas).
 • Control total sobre la trazabilidad del producto desde la siembra hasta el jugo final.
 • Promueve la producción limpia y sostenible a nivel local.
 • Reducción de impacto ambiental al evitar transporte de materia prima de larga distancia',
  fortalezas_social = 'Genera empleo en el campo y en el proceso de transformación.
 • Fomenta la agricultura sostenible y el consumo responsable entre los consumidores.
 • Promueve el desarrollo rural y la conexión directa entre productor y consumidor.
 • Potencial de trabajo colaborativo con comunidades o asociaciones agrícolas.',
  fortalezas_economico = 'Integración vertical (siembran y transforman) reduce intermediarios y costos.
Alta demanda de productos naturales y saludables (jugos orgánicos, sin conservantes), Posibilidad de aprovechar el sello marca para posicionarse en mercados especializados.
  Diversificación de productos (jugos, pulpas, néctares)',
  emprendimiento_verde = false,
  sello_marca = true,
  avalado = true,
  destacado = false,
  activo = true
where nombre = 'BEBIDAS LEJAYIM S.A.S. BIC';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select 'c5a8c467-151e-4b12-ad6a-5d2fb87e88d5', 'BEBIDAS LEJAYIM S.A.S. BIC', generar_slug_unico('BEBIDAS LEJAYIM S.A.S. BIC', 'c5a8c467-151e-4b12-ad6a-5d2fb87e88d5'), (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'), 'Lebrija', (select id from veredas where municipio = 'Lebrija' and slug = 'santo-domingo'), 'FINCA VISTA HERMOSA VEREDA SANTO DOMINGO', 7.103086666666666, -73.23898750000001, 'Explotación de la industria alimenticia en general, en especial las frutas, hortalizas y sus derivados y los negocios que se relacionen directamente con…', 'Explotación de la industria alimenticia en general, en especial las frutas, hortalizas y sus derivados y los negocios que se relacionen directamente con dicha industria. Producción y comercialización de frutas en presentaciones como jugos, zumos, bebidas saludables y fruta fresca. Su objeto social también incluye las actividades propias de las sociedades BIC', 'BEBIDAS NATURALES', '3163550373', '573163550373', 'bebidaslejayim@gmail.com', 'GERARDO RIVERA ARANDA', '901178193-6', 'Jurídica', 'YAZMIN RIVERA GOMEZ', 'Cámara de comercio', 'SEBASTIAN BONNET', 'ACTIVO', 'Dinamizadoras', 2019, '1140.8 msnm', '73°14''20.355''''', '7°6''11.112''''', 'Actualizó', null, null, 'Sí', 'Acueducto veredal', null, null, null, 'No', 'Sí', 'Sí', null, null, null, 'Sí', '2029-04-23', null, null, null, null, null, null, 'Sí', 'Mixta', 'No', 'SI', 'Cultivo propio de frutas bajo prácticas orgánicas (sin químicos ni pesticidas).
 • Control total sobre la trazabilidad del producto desde la siembra hasta el jugo final.
 • Promueve la producción limpia y sostenible a nivel local.
 • Reducción de impacto ambiental al evitar transporte de materia prima de larga distancia', 'Genera empleo en el campo y en el proceso de transformación.
 • Fomenta la agricultura sostenible y el consumo responsable entre los consumidores.
 • Promueve el desarrollo rural y la conexión directa entre productor y consumidor.
 • Potencial de trabajo colaborativo con comunidades o asociaciones agrícolas.', 'Integración vertical (siembran y transforman) reduce intermediarios y costos.
Alta demanda de productos naturales y saludables (jugos orgánicos, sin conservantes), Posibilidad de aprovechar el sello marca para posicionarse en mercados especializados.
  Diversificación de productos (jugos, pulpas, néctares)', false, true, true, false, true
where not exists (select 1 from negocios where nombre = 'BEBIDAS LEJAYIM S.A.S. BIC');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'BEBIDAS LEJAYIM S.A.S. BIC');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'BEBIDAS LEJAYIM S.A.S. BIC'), (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'BEBIDAS LEJAYIM S.A.S. BIC');
insert into negocios_subcategorias (negocio_id, subcategoria_id) select (select id from negocios where nombre = 'BEBIDAS LEJAYIM S.A.S. BIC'), id from subcategorias where slug = 'agroindustria-sostenible';
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'BEBIDAS LEJAYIM S.A.S. BIC');
insert into negocios_actividades (negocio_id, actividad_productiva_id) select (select id from negocios where nombre = 'BEBIDAS LEJAYIM S.A.S. BIC'), id from actividades_productivas where slug = 'agroindustrial-alimentario';
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'BEBIDAS LEJAYIM S.A.S. BIC'), 2021, 54.16 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'BEBIDAS LEJAYIM S.A.S. BIC'), 2022, 67.75 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'BEBIDAS LEJAYIM S.A.S. BIC'), 2023, 71.92 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'BEBIDAS LEJAYIM S.A.S. BIC'), 2024, 72.5 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'BEBIDAS LEJAYIM S.A.S. BIC'), 2025, 71.7 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;

-- SAN FERNANDO COFFEE AND FARM S.A.S. BIC
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'),
  municipio = 'Piedecuesta',
  vereda_id = (select id from veredas where municipio = 'Piedecuesta' and slug = 'el-guamo'),
  direccion = 'FINCA SAN FERNANDO KM 4 VIA LA PUNTA MESITAS DE SAN JAVIER VDA EL GUAMO',
  latitud = 6.938055555555556,
  longitud = -73.05888888888889,
  descripcion_corta = 'Producción, transformación, torrefacción (tostión), empaque, embalaje,comercialización y venta al por mayor y detal a nivel nacional e internacional y…',
  descripcion = 'Producción, transformación, torrefacción (tostión), empaque, embalaje,comercialización y venta al por mayor y detal a nivel nacional e internacional y exportación de café en cereza, pergamino,café verde, café tostado en grano y molido y sus derivados involucradas en la producción y conservación del medio ambiente',
  producto = 'CAFÉ TOSTADO',
  telefono = '3151111323',
  whatsapp = '573151111323',
  email = 'sanfernando.coffeeandfarm@gmail.com',
  representante_legal = 'GONZALO ENRIQUE MANCILLA DIAZ',
  nit = '900569613-2',
  naturaleza_juridica = 'Jurídica',
  delegado = 'DIANA LUCERO BUITRAGO FORERO',
  rut_camara_comercio = 'Cámara de comercio',
  responsable_cdmb = 'XIMENA REYES',
  novedad = 'ACTIVO',
  tipo_negocio_verde = 'Dinamizadoras',
  anio_registro = 2017,
  cota_msnm = '154.7',
  este = '73°3''32''''',
  norte = '6°56''17''''',
  aplicacion_ficha_2025 = 'Actualizó',
  observaciones = 'Se realizo visita y se actualizo ficha de verificacion',
  registro_nacional_turismo = null,
  uso_suelo = 'No',
  concesion_aguas = 'No',
  concesion_aguas_vencimiento = null,
  vertimientos = 'No',
  vertimientos_vencimiento = null,
  pueaa = 'No',
  pgris = 'No',
  pozo_septico = 'Sí',
  alcantarillado = null,
  ica = null,
  ica_vencimiento = null,
  invima = 'Sí',
  invima_vencimiento = '2030-08-14',
  certificado_tenencia_animales = null,
  buenas_practicas_agricolas = 'No',
  buenas_practicas_apicolas = null,
  registro_apicola = null,
  intervencion_cauce = null,
  capacidad_carga = null,
  sstt = 'No',
  canal_venta = 'Mixta',
  exportacion = 'Sí',
  huella_carbono = 'NO',
  fortalezas_ambiental = 'Paneles solares',
  fortalezas_social = 'Generan empleo en la zona aledaña',
  fortalezas_economico = 'Variedad de productos y posicionamiento de su linea premiun',
  emprendimiento_verde = false,
  sello_marca = true,
  avalado = true,
  destacado = false,
  activo = true
where nombre = 'SAN FERNANDO COFFEE AND FARM S.A.S. BIC';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select '31fd82ae-8e12-442b-93e6-350b3cc9f67a', 'SAN FERNANDO COFFEE AND FARM S.A.S. BIC', generar_slug_unico('SAN FERNANDO COFFEE AND FARM S.A.S. BIC', '31fd82ae-8e12-442b-93e6-350b3cc9f67a'), (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'), 'Piedecuesta', (select id from veredas where municipio = 'Piedecuesta' and slug = 'el-guamo'), 'FINCA SAN FERNANDO KM 4 VIA LA PUNTA MESITAS DE SAN JAVIER VDA EL GUAMO', 6.938055555555556, -73.05888888888889, 'Producción, transformación, torrefacción (tostión), empaque, embalaje,comercialización y venta al por mayor y detal a nivel nacional e internacional y…', 'Producción, transformación, torrefacción (tostión), empaque, embalaje,comercialización y venta al por mayor y detal a nivel nacional e internacional y exportación de café en cereza, pergamino,café verde, café tostado en grano y molido y sus derivados involucradas en la producción y conservación del medio ambiente', 'CAFÉ TOSTADO', '3151111323', '573151111323', 'sanfernando.coffeeandfarm@gmail.com', 'GONZALO ENRIQUE MANCILLA DIAZ', '900569613-2', 'Jurídica', 'DIANA LUCERO BUITRAGO FORERO', 'Cámara de comercio', 'XIMENA REYES', 'ACTIVO', 'Dinamizadoras', 2017, '154.7', '73°3''32''''', '6°56''17''''', 'Actualizó', 'Se realizo visita y se actualizo ficha de verificacion', null, 'No', 'No', null, 'No', null, 'No', 'No', 'Sí', null, null, null, 'Sí', '2030-08-14', null, 'No', null, null, null, null, 'No', 'Mixta', 'Sí', 'NO', 'Paneles solares', 'Generan empleo en la zona aledaña', 'Variedad de productos y posicionamiento de su linea premiun', false, true, true, false, true
where not exists (select 1 from negocios where nombre = 'SAN FERNANDO COFFEE AND FARM S.A.S. BIC');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'SAN FERNANDO COFFEE AND FARM S.A.S. BIC');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'SAN FERNANDO COFFEE AND FARM S.A.S. BIC'), (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'SAN FERNANDO COFFEE AND FARM S.A.S. BIC');
insert into negocios_subcategorias (negocio_id, subcategoria_id) select (select id from negocios where nombre = 'SAN FERNANDO COFFEE AND FARM S.A.S. BIC'), id from subcategorias where slug = 'agroindustria-sostenible';
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'SAN FERNANDO COFFEE AND FARM S.A.S. BIC');
insert into negocios_actividades (negocio_id, actividad_productiva_id) select (select id from negocios where nombre = 'SAN FERNANDO COFFEE AND FARM S.A.S. BIC'), id from actividades_productivas where slug = 'agroindustrial-alimentario';
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'SAN FERNANDO COFFEE AND FARM S.A.S. BIC'), 2021, 69.54 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'SAN FERNANDO COFFEE AND FARM S.A.S. BIC'), 2022, 74.06 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'SAN FERNANDO COFFEE AND FARM S.A.S. BIC'), 2023, 77.39 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'SAN FERNANDO COFFEE AND FARM S.A.S. BIC'), 2024, 79.8 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'SAN FERNANDO COFFEE AND FARM S.A.S. BIC'), 2025, 75.3 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;

-- CULTIVOS Y TRATAMIENTOS AMBIENTALES SAS
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'pendiente-clasificar'),
  municipio = 'Rionegro',
  vereda_id = null,
  direccion = 'Carrera 6 B No. 2 - 41',
  latitud = 7.1171388888888885,
  longitud = -73.13052777777777,
  descripcion_corta = null,
  descripcion = null,
  producto = 'CONSULTORÍA AMBIENTAL',
  telefono = '3002857953-3144313038',
  whatsapp = '3002857953-3144313038',
  email = 'ismagol1669_@hotmail.com',
  representante_legal = 'ISMAEL GALVIS CASTRO -ING DE PISCICULTURA',
  nit = '900605603',
  naturaleza_juridica = null,
  delegado = null,
  rut_camara_comercio = null,
  responsable_cdmb = null,
  novedad = 'INACTIVO',
  tipo_negocio_verde = null,
  anio_registro = 2019,
  cota_msnm = '816 msnm',
  este = '73°7''49,9''''',
  norte = '7°7''1,7''''',
  aplicacion_ficha_2025 = null,
  observaciones = 'Formalizar alianza',
  registro_nacional_turismo = null,
  uso_suelo = null,
  concesion_aguas = null,
  concesion_aguas_vencimiento = null,
  vertimientos = null,
  vertimientos_vencimiento = null,
  pueaa = null,
  pgris = null,
  pozo_septico = null,
  alcantarillado = null,
  ica = null,
  ica_vencimiento = null,
  invima = null,
  invima_vencimiento = null,
  certificado_tenencia_animales = null,
  buenas_practicas_agricolas = null,
  buenas_practicas_apicolas = null,
  registro_apicola = null,
  intervencion_cauce = null,
  capacidad_carga = null,
  sstt = null,
  canal_venta = null,
  exportacion = null,
  huella_carbono = null,
  fortalezas_ambiental = null,
  fortalezas_social = null,
  fortalezas_economico = null,
  emprendimiento_verde = true,
  sello_marca = false,
  avalado = false,
  destacado = false,
  activo = false
where nombre = 'CULTIVOS Y TRATAMIENTOS AMBIENTALES SAS';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select '94bf971f-35da-480a-9d87-672205d3d07c', 'CULTIVOS Y TRATAMIENTOS AMBIENTALES SAS', generar_slug_unico('CULTIVOS Y TRATAMIENTOS AMBIENTALES SAS', '94bf971f-35da-480a-9d87-672205d3d07c'), (select id from categorias_oficiales where slug = 'pendiente-clasificar'), 'Rionegro', null, 'Carrera 6 B No. 2 - 41', 7.1171388888888885, -73.13052777777777, null, null, 'CONSULTORÍA AMBIENTAL', '3002857953-3144313038', '3002857953-3144313038', 'ismagol1669_@hotmail.com', 'ISMAEL GALVIS CASTRO -ING DE PISCICULTURA', '900605603', null, null, null, null, 'INACTIVO', null, 2019, '816 msnm', '73°7''49,9''''', '7°7''1,7''''', null, 'Formalizar alianza', null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, true, false, false, false, false
where not exists (select 1 from negocios where nombre = 'CULTIVOS Y TRATAMIENTOS AMBIENTALES SAS');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'CULTIVOS Y TRATAMIENTOS AMBIENTALES SAS');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'CULTIVOS Y TRATAMIENTOS AMBIENTALES SAS'), (select id from categorias_oficiales where slug = 'pendiente-clasificar');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'CULTIVOS Y TRATAMIENTOS AMBIENTALES SAS');
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'CULTIVOS Y TRATAMIENTOS AMBIENTALES SAS');

-- REINA DE LA CUESTA
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'),
  municipio = 'Piedecuesta',
  vereda_id = (select id from veredas where municipio = 'Piedecuesta' and slug = 'el-volador'),
  direccion = 'FINCA MIRAFLORES VEREDA EL VOLADOR',
  latitud = 7.130638888888888,
  longitud = -73.11344444444444,
  descripcion_corta = 'Elaboración de bebida a base de zumo de mandarina exprimido y fermentado naturalmente.',
  descripcion = 'Elaboración de bebida a base de zumo de mandarina exprimido y fermentado naturalmente.',
  producto = 'VINO DE MANDARINA',
  telefono = '3157974691 - 3112961070',
  whatsapp = '3157974691 - 3112961070',
  email = 'reinadelacuesta@gmail.com',
  representante_legal = 'PABLO ANTONIO ALVAREZ ALVAREZ',
  nit = '5462529-4',
  naturaleza_juridica = 'Natural',
  delegado = 'MIRIAM VARGAS',
  rut_camara_comercio = 'Cámara de comercio',
  responsable_cdmb = 'CARINE GARCIA',
  novedad = 'ACTIVO',
  tipo_negocio_verde = 'Dinamizadoras',
  anio_registro = 2019,
  cota_msnm = '1.009 msnm',
  este = '73°6''48,4''''',
  norte = '7°7''50,3''''',
  aplicacion_ficha_2025 = 'Actualizó',
  observaciones = null,
  registro_nacional_turismo = null,
  uso_suelo = 'Sí',
  concesion_aguas = 'Sí',
  concesion_aguas_vencimiento = '2029-07-31',
  vertimientos = null,
  vertimientos_vencimiento = null,
  pueaa = 'Sí',
  pgris = 'Sí',
  pozo_septico = 'Sí',
  alcantarillado = null,
  ica = null,
  ica_vencimiento = null,
  invima = 'Sí',
  invima_vencimiento = '2029-11-19',
  certificado_tenencia_animales = null,
  buenas_practicas_agricolas = 'Sí',
  buenas_practicas_apicolas = null,
  registro_apicola = null,
  intervencion_cauce = null,
  capacidad_carga = null,
  sstt = 'Sí',
  canal_venta = 'B2C',
  exportacion = 'No',
  huella_carbono = 'NO',
  fortalezas_ambiental = 'Cultivan mandarina de forma artesanal y sin químicos, promoviendo la agricultura limpia y sostenible.
 • Cuentan con sello de Negocios Verdes, que respalda su compromiso ambiental.
 • Tienen permiso de concesión de aguas y pozo séptico, garantizando manejo responsable del recurso hídrico.
 • Producen un vino natural y de bajo impacto ambiental.
 • Buen cumplimiento de requisitos ambientales y sanitarios.',
  fortalezas_social = 'Emprendimiento liderado por adultos mayores, ejemplo de inclusión y aprovechamiento de saberes tradicionales.
 • Participan activamente en el mercado campesino de la Mesa de los Santos, fortaleciendo la economía local.
 • Su proceso artesanal preserva conocimientos rurales y culturales de la región.
 • Cumplen con Seguridad y Salud en el Trabajo, garantizando bienestar laboral.
 • Generan confianza con consumidores mediante la venta directa y la cercanía al cliente.',
  fortalezas_economico = 'Cuentan con registro INVIMA, lo que les permite comercializar formalmente.
 • Tienen sello de Negocio Verde, que aumenta su reconocimiento y acceso a ferias o programas de apoyo.
 • Poseen ficha técnica del producto, reflejando formalidad y control de calidad.
 • Manejan su propia materia prima, reduciendo costos de insumos.
 • Cuentan con un punto de venta fijo, lo que asegura presencia en el mercado local.',
  emprendimiento_verde = false,
  sello_marca = true,
  avalado = true,
  destacado = false,
  activo = true
where nombre = 'REINA DE LA CUESTA';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select '9e31d71a-e43d-4222-b547-89cafd964e7a', 'REINA DE LA CUESTA', generar_slug_unico('REINA DE LA CUESTA', '9e31d71a-e43d-4222-b547-89cafd964e7a'), (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'), 'Piedecuesta', (select id from veredas where municipio = 'Piedecuesta' and slug = 'el-volador'), 'FINCA MIRAFLORES VEREDA EL VOLADOR', 7.130638888888888, -73.11344444444444, 'Elaboración de bebida a base de zumo de mandarina exprimido y fermentado naturalmente.', 'Elaboración de bebida a base de zumo de mandarina exprimido y fermentado naturalmente.', 'VINO DE MANDARINA', '3157974691 - 3112961070', '3157974691 - 3112961070', 'reinadelacuesta@gmail.com', 'PABLO ANTONIO ALVAREZ ALVAREZ', '5462529-4', 'Natural', 'MIRIAM VARGAS', 'Cámara de comercio', 'CARINE GARCIA', 'ACTIVO', 'Dinamizadoras', 2019, '1.009 msnm', '73°6''48,4''''', '7°7''50,3''''', 'Actualizó', null, null, 'Sí', 'Sí', '2029-07-31', null, null, 'Sí', 'Sí', 'Sí', null, null, null, 'Sí', '2029-11-19', null, 'Sí', null, null, null, null, 'Sí', 'B2C', 'No', 'NO', 'Cultivan mandarina de forma artesanal y sin químicos, promoviendo la agricultura limpia y sostenible.
 • Cuentan con sello de Negocios Verdes, que respalda su compromiso ambiental.
 • Tienen permiso de concesión de aguas y pozo séptico, garantizando manejo responsable del recurso hídrico.
 • Producen un vino natural y de bajo impacto ambiental.
 • Buen cumplimiento de requisitos ambientales y sanitarios.', 'Emprendimiento liderado por adultos mayores, ejemplo de inclusión y aprovechamiento de saberes tradicionales.
 • Participan activamente en el mercado campesino de la Mesa de los Santos, fortaleciendo la economía local.
 • Su proceso artesanal preserva conocimientos rurales y culturales de la región.
 • Cumplen con Seguridad y Salud en el Trabajo, garantizando bienestar laboral.
 • Generan confianza con consumidores mediante la venta directa y la cercanía al cliente.', 'Cuentan con registro INVIMA, lo que les permite comercializar formalmente.
 • Tienen sello de Negocio Verde, que aumenta su reconocimiento y acceso a ferias o programas de apoyo.
 • Poseen ficha técnica del producto, reflejando formalidad y control de calidad.
 • Manejan su propia materia prima, reduciendo costos de insumos.
 • Cuentan con un punto de venta fijo, lo que asegura presencia en el mercado local.', false, true, true, false, true
where not exists (select 1 from negocios where nombre = 'REINA DE LA CUESTA');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'REINA DE LA CUESTA');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'REINA DE LA CUESTA'), (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'REINA DE LA CUESTA');
insert into negocios_subcategorias (negocio_id, subcategoria_id) select (select id from negocios where nombre = 'REINA DE LA CUESTA'), id from subcategorias where slug = 'agroindustria-sostenible';
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'REINA DE LA CUESTA');
insert into negocios_actividades (negocio_id, actividad_productiva_id) select (select id from negocios where nombre = 'REINA DE LA CUESTA'), id from actividades_productivas where slug = 'agroindustrial-alimentario';
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'REINA DE LA CUESTA'), 2020, 51.03 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'REINA DE LA CUESTA'), 2021, 58.82 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'REINA DE LA CUESTA'), 2022, 61.15 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'REINA DE LA CUESTA'), 2023, 75.97 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'REINA DE LA CUESTA'), 2024, 72.1 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'REINA DE LA CUESTA'), 2025, 76.6 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;

-- ASOCIACIÓN DE APICULTORES INTEGRALES DEL MUNICIPIO DE RIONEGRO SANTANDER "APIRIO"
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'),
  municipio = 'Rionegro',
  vereda_id = (select id from veredas where municipio = 'Rionegro' and slug = 'san-pablo'),
  direccion = 'KM 4 VÍA LLANO PALMAS VEREDA SAN PABLO, FINCA SAN PABLITO',
  latitud = 7.128972222222222,
  longitud = -73.18158333333334,
  descripcion_corta = 'Apirio es una asociación conformada por 22 asociados dedicados producir, transformar agroindustrialmente y comercializar la producción apícola ya que cría y…',
  descripcion = 'Apirio es una asociación conformada por 22 asociados dedicados producir, transformar agroindustrialmente y comercializar la producción apícola ya que cría y cuidan  abejas Apis mellifera que contribuye a la preservación de la biodiversidad a través de la polinización y así obtener productos como la miel y polen. De igual manera también se dedican a otras actividades agrícolas principalmente cultivo de cacao y citricos, dado que para vivir solo de la apicultura se debe contar con un promedio de 100 a 150 colmenas. De los 22 asociados 8 son miujeres cabeza de hogar. De todos los poductos que se derivan de la actividad apícola, los asociados comercializan únicamente la miel de abejas, aunque se han inciado ejercicios de asesoramiento técnico que incluye la venta de las colmenas, la adecuación del sitio de producción y acompañamiento técnico durante la etpa inicial de la explotación. La mayoría de asociados desarrollan la actividad con prácticas ancestrales y equipos de extracción manual. La población objetivo está conformada por personas que desean alimentarse de forma sana y saludable con productos naturales no ultraprocesados. APIRIO cuenta con un aliado comercial estratégico que comercializa la mayor parte de la producción de miel de los asociados; el aliado es una tienda de frutos secos ubicada en Bogotá llamada NOVA NUEZ',
  producto = 'MIEL Y POLEN DE ABEJAS',
  telefono = '3158008137',
  whatsapp = '573158008137',
  email = 'jballesterosriano@gmail.com',
  representante_legal = 'JUAN CARLOS BALLESTEROS RIAÑO',
  nit = '901097536-0',
  naturaleza_juridica = 'Jurídica',
  delegado = null,
  rut_camara_comercio = 'Cámara de comercio',
  responsable_cdmb = 'ANA RUEDA',
  novedad = 'ACTIVO',
  tipo_negocio_verde = 'Dinamizadoras',
  anio_registro = 2020,
  cota_msnm = '1053.5 m',
  este = '73°10''53,7''''',
  norte = '7°7''44,3''''',
  aplicacion_ficha_2025 = 'Actualizó',
  observaciones = 'Se realizo visita y se aplico ficha de verificacion',
  registro_nacional_turismo = null,
  uso_suelo = 'Sí',
  concesion_aguas = 'No',
  concesion_aguas_vencimiento = null,
  vertimientos = null,
  vertimientos_vencimiento = null,
  pueaa = 'No',
  pgris = 'No',
  pozo_septico = 'Sí',
  alcantarillado = null,
  ica = null,
  ica_vencimiento = null,
  invima = 'Sí',
  invima_vencimiento = '2036-03-03',
  certificado_tenencia_animales = null,
  buenas_practicas_agricolas = null,
  buenas_practicas_apicolas = 'No',
  registro_apicola = 'No',
  intervencion_cauce = null,
  capacidad_carga = null,
  sstt = 'No',
  canal_venta = 'B2C',
  exportacion = 'No',
  huella_carbono = null,
  fortalezas_ambiental = 'SI, No se utilizan materiales peligrosos y/o tóxicos en los procesos. -Envase de vidrio. -Se desarrollan acciones como estrategias de restauración y reforestación con especies nativas',
  fortalezas_social = 'Sensibilización sobre el cuidado y peligro de exponer sin los elementos de protección ante enjambres y charlas de consumo sostenible  -Genera empleo local',
  fortalezas_economico = 'Tiene claro algunos costos y gastos pero no la totalidad de operación del negocio. -Registros financieros Excel',
  emprendimiento_verde = false,
  sello_marca = false,
  avalado = true,
  destacado = false,
  activo = true
where nombre = 'ASOCIACIÓN DE APICULTORES INTEGRALES DEL MUNICIPIO DE RIONEGRO SANTANDER "APIRIO"';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select '8cdd7e0b-0b76-4bff-88da-ee846b64049c', 'ASOCIACIÓN DE APICULTORES INTEGRALES DEL MUNICIPIO DE RIONEGRO SANTANDER "APIRIO"', generar_slug_unico('ASOCIACIÓN DE APICULTORES INTEGRALES DEL MUNICIPIO DE RIONEGRO SANTANDER "APIRIO"', '8cdd7e0b-0b76-4bff-88da-ee846b64049c'), (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'), 'Rionegro', (select id from veredas where municipio = 'Rionegro' and slug = 'san-pablo'), 'KM 4 VÍA LLANO PALMAS VEREDA SAN PABLO, FINCA SAN PABLITO', 7.128972222222222, -73.18158333333334, 'Apirio es una asociación conformada por 22 asociados dedicados producir, transformar agroindustrialmente y comercializar la producción apícola ya que cría y…', 'Apirio es una asociación conformada por 22 asociados dedicados producir, transformar agroindustrialmente y comercializar la producción apícola ya que cría y cuidan  abejas Apis mellifera que contribuye a la preservación de la biodiversidad a través de la polinización y así obtener productos como la miel y polen. De igual manera también se dedican a otras actividades agrícolas principalmente cultivo de cacao y citricos, dado que para vivir solo de la apicultura se debe contar con un promedio de 100 a 150 colmenas. De los 22 asociados 8 son miujeres cabeza de hogar. De todos los poductos que se derivan de la actividad apícola, los asociados comercializan únicamente la miel de abejas, aunque se han inciado ejercicios de asesoramiento técnico que incluye la venta de las colmenas, la adecuación del sitio de producción y acompañamiento técnico durante la etpa inicial de la explotación. La mayoría de asociados desarrollan la actividad con prácticas ancestrales y equipos de extracción manual. La población objetivo está conformada por personas que desean alimentarse de forma sana y saludable con productos naturales no ultraprocesados. APIRIO cuenta con un aliado comercial estratégico que comercializa la mayor parte de la producción de miel de los asociados; el aliado es una tienda de frutos secos ubicada en Bogotá llamada NOVA NUEZ', 'MIEL Y POLEN DE ABEJAS', '3158008137', '573158008137', 'jballesterosriano@gmail.com', 'JUAN CARLOS BALLESTEROS RIAÑO', '901097536-0', 'Jurídica', null, 'Cámara de comercio', 'ANA RUEDA', 'ACTIVO', 'Dinamizadoras', 2020, '1053.5 m', '73°10''53,7''''', '7°7''44,3''''', 'Actualizó', 'Se realizo visita y se aplico ficha de verificacion', null, 'Sí', 'No', null, null, null, 'No', 'No', 'Sí', null, null, null, 'Sí', '2036-03-03', null, null, 'No', 'No', null, null, 'No', 'B2C', 'No', null, 'SI, No se utilizan materiales peligrosos y/o tóxicos en los procesos. -Envase de vidrio. -Se desarrollan acciones como estrategias de restauración y reforestación con especies nativas', 'Sensibilización sobre el cuidado y peligro de exponer sin los elementos de protección ante enjambres y charlas de consumo sostenible  -Genera empleo local', 'Tiene claro algunos costos y gastos pero no la totalidad de operación del negocio. -Registros financieros Excel', false, false, true, false, true
where not exists (select 1 from negocios where nombre = 'ASOCIACIÓN DE APICULTORES INTEGRALES DEL MUNICIPIO DE RIONEGRO SANTANDER "APIRIO"');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'ASOCIACIÓN DE APICULTORES INTEGRALES DEL MUNICIPIO DE RIONEGRO SANTANDER "APIRIO"');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'ASOCIACIÓN DE APICULTORES INTEGRALES DEL MUNICIPIO DE RIONEGRO SANTANDER "APIRIO"'), (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'ASOCIACIÓN DE APICULTORES INTEGRALES DEL MUNICIPIO DE RIONEGRO SANTANDER "APIRIO"');
insert into negocios_subcategorias (negocio_id, subcategoria_id) select (select id from negocios where nombre = 'ASOCIACIÓN DE APICULTORES INTEGRALES DEL MUNICIPIO DE RIONEGRO SANTANDER "APIRIO"'), id from subcategorias where slug = 'agroindustria-sostenible';
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'ASOCIACIÓN DE APICULTORES INTEGRALES DEL MUNICIPIO DE RIONEGRO SANTANDER "APIRIO"');
insert into negocios_actividades (negocio_id, actividad_productiva_id) select (select id from negocios where nombre = 'ASOCIACIÓN DE APICULTORES INTEGRALES DEL MUNICIPIO DE RIONEGRO SANTANDER "APIRIO"'), id from actividades_productivas where slug = 'agroindustrial-alimentario';
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'ASOCIACIÓN DE APICULTORES INTEGRALES DEL MUNICIPIO DE RIONEGRO SANTANDER "APIRIO"'), 2020, 34.56 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'ASOCIACIÓN DE APICULTORES INTEGRALES DEL MUNICIPIO DE RIONEGRO SANTANDER "APIRIO"'), 2021, 34.53 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'ASOCIACIÓN DE APICULTORES INTEGRALES DEL MUNICIPIO DE RIONEGRO SANTANDER "APIRIO"'), 2022, 37.78 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'ASOCIACIÓN DE APICULTORES INTEGRALES DEL MUNICIPIO DE RIONEGRO SANTANDER "APIRIO"'), 2023, 37.78 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'ASOCIACIÓN DE APICULTORES INTEGRALES DEL MUNICIPIO DE RIONEGRO SANTANDER "APIRIO"'), 2024, 53.5 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'ASOCIACIÓN DE APICULTORES INTEGRALES DEL MUNICIPIO DE RIONEGRO SANTANDER "APIRIO"'), 2025, 61.1 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;

-- FUNDACIÓN SOY VERDE
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'pendiente-clasificar'),
  municipio = 'Floridablanca',
  vereda_id = null,
  direccion = 'calle 35A # 2 A E -31 apto 102 barrio la cumbre MATACHINES',
  latitud = 6.912777777777778,
  longitud = -73.02527777777777,
  descripcion_corta = null,
  descripcion = null,
  producto = 'RECICLAJE DE PLASTICO',
  telefono = '3128456393',
  whatsapp = '573128456393',
  email = 'fundaciónsoyverde2019@gmail.com',
  representante_legal = 'CARLOS NORBERTO DIAZ',
  nit = '901310295-4',
  naturaleza_juridica = null,
  delegado = null,
  rut_camara_comercio = null,
  responsable_cdmb = 'ANA RUEDA',
  novedad = 'RETIRADO',
  tipo_negocio_verde = 'Intermedio',
  anio_registro = 2022,
  cota_msnm = '1.543 mnsn',
  este = '73°1''31''''',
  norte = '6°54''46''''',
  aplicacion_ficha_2025 = null,
  observaciones = 'Continua en el programa',
  registro_nacional_turismo = null,
  uso_suelo = null,
  concesion_aguas = null,
  concesion_aguas_vencimiento = null,
  vertimientos = null,
  vertimientos_vencimiento = null,
  pueaa = null,
  pgris = null,
  pozo_septico = null,
  alcantarillado = null,
  ica = null,
  ica_vencimiento = null,
  invima = null,
  invima_vencimiento = null,
  certificado_tenencia_animales = null,
  buenas_practicas_agricolas = null,
  buenas_practicas_apicolas = null,
  registro_apicola = null,
  intervencion_cauce = null,
  capacidad_carga = null,
  sstt = null,
  canal_venta = null,
  exportacion = null,
  huella_carbono = null,
  fortalezas_ambiental = null,
  fortalezas_social = null,
  fortalezas_economico = null,
  emprendimiento_verde = true,
  sello_marca = false,
  avalado = false,
  destacado = false,
  activo = false
where nombre = 'FUNDACIÓN SOY VERDE';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select 'c51238ec-05f2-46ed-a9b4-b75dc4b16ad3', 'FUNDACIÓN SOY VERDE', generar_slug_unico('FUNDACIÓN SOY VERDE', 'c51238ec-05f2-46ed-a9b4-b75dc4b16ad3'), (select id from categorias_oficiales where slug = 'pendiente-clasificar'), 'Floridablanca', null, 'calle 35A # 2 A E -31 apto 102 barrio la cumbre MATACHINES', 6.912777777777778, -73.02527777777777, null, null, 'RECICLAJE DE PLASTICO', '3128456393', '573128456393', 'fundaciónsoyverde2019@gmail.com', 'CARLOS NORBERTO DIAZ', '901310295-4', null, null, null, 'ANA RUEDA', 'RETIRADO', 'Intermedio', 2022, '1.543 mnsn', '73°1''31''''', '6°54''46''''', null, 'Continua en el programa', null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, true, false, false, false, false
where not exists (select 1 from negocios where nombre = 'FUNDACIÓN SOY VERDE');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'FUNDACIÓN SOY VERDE');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'FUNDACIÓN SOY VERDE'), (select id from categorias_oficiales where slug = 'pendiente-clasificar');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'FUNDACIÓN SOY VERDE');
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'FUNDACIÓN SOY VERDE');
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'FUNDACIÓN SOY VERDE'), 2022, 44.2 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'FUNDACIÓN SOY VERDE'), 2023, 44.2 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;

-- CAFÉ SANTA CECILIA
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'),
  municipio = 'Floridablanca',
  vereda_id = (select id from veredas where municipio = 'Floridablanca' and slug = 'la-judia'),
  direccion = 'PARCELA SANTA CECILIA VEREDA LA JUDIA- FLORIDABLANCA',
  latitud = 7.086971666666666,
  longitud = null,
  descripcion_corta = 'Cultivo, Trilla, tostion y molienda de café Organico',
  descripcion = 'Cultivo, Trilla, tostion y molienda de café Organico',
  producto = 'TRANSFORMACIÒN DE CAFÉ ORGANICO',
  telefono = '3203217693',
  whatsapp = '573203217693',
  email = 'cafesantacecilia.info@gmail.com',
  representante_legal = 'YEMERSON HERNANDEZ MARTINEZ',
  nit = '1098623258-4',
  naturaleza_juridica = 'Natural',
  delegado = null,
  rut_camara_comercio = 'Cámara de comercio y RUT',
  responsable_cdmb = 'HEINER ORTIZ',
  novedad = 'SUSPENDIDO',
  tipo_negocio_verde = 'Dinamizadoras',
  anio_registro = 2022,
  cota_msnm = '1645.3 msnm',
  este = '73°2''55.,135''''',
  norte = '7°5''13.098''''',
  aplicacion_ficha_2025 = 'No actualizó',
  observaciones = 'No se realizo visita ni se aplico ficha de verificacion',
  registro_nacional_turismo = null,
  uso_suelo = 'Sí',
  concesion_aguas = 'No',
  concesion_aguas_vencimiento = null,
  vertimientos = 'No',
  vertimientos_vencimiento = null,
  pueaa = 'No',
  pgris = 'No',
  pozo_septico = 'No',
  alcantarillado = 'No',
  ica = null,
  ica_vencimiento = null,
  invima = 'No',
  invima_vencimiento = null,
  certificado_tenencia_animales = null,
  buenas_practicas_agricolas = 'No',
  buenas_practicas_apicolas = null,
  registro_apicola = null,
  intervencion_cauce = null,
  capacidad_carga = null,
  sstt = 'No',
  canal_venta = 'B2C',
  exportacion = null,
  huella_carbono = null,
  fortalezas_ambiental = 'Sistemas agroforestales o silvopastoriles, estrategias de restauración y reforestación con especies nativas o endémicas, cercas vivas, rescate de plántulas, fertilización orgánica, entre otros.',
  fortalezas_social = 'Genera educación ambiental con las personas que capta compra del café y clientes.',
  fortalezas_economico = 'Tiene claro algunos costos y gastos pero No la totalidad de operación del negocio
-Libro contable',
  emprendimiento_verde = true,
  sello_marca = false,
  avalado = false,
  destacado = false,
  activo = false
where nombre = 'CAFÉ SANTA CECILIA';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select '56169c1c-6575-4968-a1a1-f8fd7d807020', 'CAFÉ SANTA CECILIA', generar_slug_unico('CAFÉ SANTA CECILIA', '56169c1c-6575-4968-a1a1-f8fd7d807020'), (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'), 'Floridablanca', (select id from veredas where municipio = 'Floridablanca' and slug = 'la-judia'), 'PARCELA SANTA CECILIA VEREDA LA JUDIA- FLORIDABLANCA', 7.086971666666666, null, 'Cultivo, Trilla, tostion y molienda de café Organico', 'Cultivo, Trilla, tostion y molienda de café Organico', 'TRANSFORMACIÒN DE CAFÉ ORGANICO', '3203217693', '573203217693', 'cafesantacecilia.info@gmail.com', 'YEMERSON HERNANDEZ MARTINEZ', '1098623258-4', 'Natural', null, 'Cámara de comercio y RUT', 'HEINER ORTIZ', 'SUSPENDIDO', 'Dinamizadoras', 2022, '1645.3 msnm', '73°2''55.,135''''', '7°5''13.098''''', 'No actualizó', 'No se realizo visita ni se aplico ficha de verificacion', null, 'Sí', 'No', null, 'No', null, 'No', 'No', 'No', 'No', null, null, 'No', null, null, 'No', null, null, null, null, 'No', 'B2C', null, null, 'Sistemas agroforestales o silvopastoriles, estrategias de restauración y reforestación con especies nativas o endémicas, cercas vivas, rescate de plántulas, fertilización orgánica, entre otros.', 'Genera educación ambiental con las personas que capta compra del café y clientes.', 'Tiene claro algunos costos y gastos pero No la totalidad de operación del negocio
-Libro contable', true, false, false, false, false
where not exists (select 1 from negocios where nombre = 'CAFÉ SANTA CECILIA');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'CAFÉ SANTA CECILIA');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'CAFÉ SANTA CECILIA'), (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'CAFÉ SANTA CECILIA');
insert into negocios_subcategorias (negocio_id, subcategoria_id) select (select id from negocios where nombre = 'CAFÉ SANTA CECILIA'), id from subcategorias where slug = 'agrosistemas-sostenibles';
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'CAFÉ SANTA CECILIA');
insert into negocios_actividades (negocio_id, actividad_productiva_id) select (select id from negocios where nombre = 'CAFÉ SANTA CECILIA'), id from actividades_productivas where slug = 'agricultura-organica';
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'CAFÉ SANTA CECILIA'), 2023, 49.81 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'CAFÉ SANTA CECILIA'), 2024, 56.5 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;

-- GRUPO NATURAL ANDINO S.A.S E.S.P.
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'ecoproductos-industriales'),
  municipio = 'Piedecuesta',
  vereda_id = (select id from veredas where municipio = 'Piedecuesta' and slug = 'el-diamante'),
  direccion = 'FINCA EL REFUGIO, VEREDA EL DIAMANTE, PIEDECUESTA SANTANDER',
  latitud = 6.981111111111111,
  longitud = -73.08388888888888,
  descripcion_corta = 'Servicio especial de transporte y tratamiento para residuos solidos organicos aprovechables',
  descripcion = 'Servicio especial de transporte y tratamiento para residuos solidos organicos aprovechables',
  producto = 'RECOLECCION DE RESIDUOS ORGANICOS Y CAPACITACION SOBRE LA CORRECTA DISPOSICION DE LOS MISMOS',
  telefono = '3144025536',
  whatsapp = '573144025536',
  email = 'gruponaturalsas@gmail.com',
  representante_legal = 'ERIKA VIVIANA MEJIA GUERRERO',
  nit = '901176628-9',
  naturaleza_juridica = 'Jurídica',
  delegado = null,
  rut_camara_comercio = 'Cámara de comercio',
  responsable_cdmb = 'SILVIA VALDIVIESO',
  novedad = 'ACTIVO',
  tipo_negocio_verde = 'Satisfactorio',
  anio_registro = 2021,
  cota_msnm = '903.7 msnm',
  este = '73°5''2''''',
  norte = '6°58''52''''',
  aplicacion_ficha_2025 = 'Actualizó',
  observaciones = 'Se realizo visita y se actualizo ficha de verificacion',
  registro_nacional_turismo = null,
  uso_suelo = 'Sí',
  concesion_aguas = 'Acueducto veredal',
  concesion_aguas_vencimiento = null,
  vertimientos = null,
  vertimientos_vencimiento = null,
  pueaa = 'No',
  pgris = 'No',
  pozo_septico = 'Sí',
  alcantarillado = null,
  ica = null,
  ica_vencimiento = null,
  invima = null,
  invima_vencimiento = null,
  certificado_tenencia_animales = null,
  buenas_practicas_agricolas = null,
  buenas_practicas_apicolas = null,
  registro_apicola = null,
  intervencion_cauce = null,
  capacidad_carga = null,
  sstt = 'No',
  canal_venta = 'B2C',
  exportacion = 'No',
  huella_carbono = 'NO',
  fortalezas_ambiental = 'Manejo adecuado de residuos orgánicos',
  fortalezas_social = 'Generación de empleo local',
  fortalezas_economico = 'Reducción de costos de disposición para clientes',
  emprendimiento_verde = false,
  sello_marca = false,
  avalado = true,
  destacado = false,
  activo = true
where nombre = 'GRUPO NATURAL ANDINO S.A.S E.S.P.';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select '479f24f4-af4a-4f17-93c2-31bb811556e1', 'GRUPO NATURAL ANDINO S.A.S E.S.P.', generar_slug_unico('GRUPO NATURAL ANDINO S.A.S E.S.P.', '479f24f4-af4a-4f17-93c2-31bb811556e1'), (select id from categorias_oficiales where slug = 'ecoproductos-industriales'), 'Piedecuesta', (select id from veredas where municipio = 'Piedecuesta' and slug = 'el-diamante'), 'FINCA EL REFUGIO, VEREDA EL DIAMANTE, PIEDECUESTA SANTANDER', 6.981111111111111, -73.08388888888888, 'Servicio especial de transporte y tratamiento para residuos solidos organicos aprovechables', 'Servicio especial de transporte y tratamiento para residuos solidos organicos aprovechables', 'RECOLECCION DE RESIDUOS ORGANICOS Y CAPACITACION SOBRE LA CORRECTA DISPOSICION DE LOS MISMOS', '3144025536', '573144025536', 'gruponaturalsas@gmail.com', 'ERIKA VIVIANA MEJIA GUERRERO', '901176628-9', 'Jurídica', null, 'Cámara de comercio', 'SILVIA VALDIVIESO', 'ACTIVO', 'Satisfactorio', 2021, '903.7 msnm', '73°5''2''''', '6°58''52''''', 'Actualizó', 'Se realizo visita y se actualizo ficha de verificacion', null, 'Sí', 'Acueducto veredal', null, null, null, 'No', 'No', 'Sí', null, null, null, null, null, null, null, null, null, null, null, 'No', 'B2C', 'No', 'NO', 'Manejo adecuado de residuos orgánicos', 'Generación de empleo local', 'Reducción de costos de disposición para clientes', false, false, true, false, true
where not exists (select 1 from negocios where nombre = 'GRUPO NATURAL ANDINO S.A.S E.S.P.');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'GRUPO NATURAL ANDINO S.A.S E.S.P.');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'GRUPO NATURAL ANDINO S.A.S E.S.P.'), (select id from categorias_oficiales where slug = 'ecoproductos-industriales');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'GRUPO NATURAL ANDINO S.A.S E.S.P.');
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'GRUPO NATURAL ANDINO S.A.S E.S.P.');
insert into negocios_actividades (negocio_id, actividad_productiva_id) select (select id from negocios where nombre = 'GRUPO NATURAL ANDINO S.A.S E.S.P.'), id from actividades_productivas where slug = 'aprovechamiento-residuos-organicos';
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'GRUPO NATURAL ANDINO S.A.S E.S.P.'), 2021, 63.97 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'GRUPO NATURAL ANDINO S.A.S E.S.P.'), 2022, 74.39 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'GRUPO NATURAL ANDINO S.A.S E.S.P.'), 2023, 75.7 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'GRUPO NATURAL ANDINO S.A.S E.S.P.'), 2024, 72.0 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'GRUPO NATURAL ANDINO S.A.S E.S.P.'), 2025, 57.9 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;

-- ASOCIACION MUNICIPAL DE  MUJERES  CAMPESINAS DE LEBRIJA AMMUCALE
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'pendiente-clasificar'),
  municipio = 'Lebrija',
  vereda_id = null,
  direccion = 'Carrera 14D N. 12 – 20 Barrio Cabecera del Llano (ASOVIPOL)',
  latitud = 7.14638888888889,
  longitud = -73.34083333333332,
  descripcion_corta = null,
  descripcion = null,
  producto = 'FRUTAS Y HORTALIZAS',
  telefono = '3172884849',
  whatsapp = '573172884849',
  email = 'ammucale@hotmail.com',
  representante_legal = 'ISOLINA NIÑO CALDERÓN',
  nit = '804001605-7',
  naturaleza_juridica = null,
  delegado = null,
  rut_camara_comercio = null,
  responsable_cdmb = null,
  novedad = 'RETIRADO',
  tipo_negocio_verde = null,
  anio_registro = 2018,
  cota_msnm = '982 msnm',
  este = '73°20''27''''',
  norte = '7°08''47''''',
  aplicacion_ficha_2025 = null,
  observaciones = 'Retirado',
  registro_nacional_turismo = null,
  uso_suelo = null,
  concesion_aguas = null,
  concesion_aguas_vencimiento = null,
  vertimientos = null,
  vertimientos_vencimiento = null,
  pueaa = null,
  pgris = null,
  pozo_septico = null,
  alcantarillado = null,
  ica = null,
  ica_vencimiento = null,
  invima = null,
  invima_vencimiento = null,
  certificado_tenencia_animales = null,
  buenas_practicas_agricolas = null,
  buenas_practicas_apicolas = null,
  registro_apicola = null,
  intervencion_cauce = null,
  capacidad_carga = null,
  sstt = null,
  canal_venta = null,
  exportacion = null,
  huella_carbono = null,
  fortalezas_ambiental = '-No se utilizan materiales peligrosos y/o tóxicos en los procesos.',
  fortalezas_social = null,
  fortalezas_economico = null,
  emprendimiento_verde = true,
  sello_marca = false,
  avalado = false,
  destacado = false,
  activo = false
where nombre = 'ASOCIACION MUNICIPAL DE  MUJERES  CAMPESINAS DE LEBRIJA AMMUCALE';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select '95a7fa34-4fa4-4781-bf15-18c3960ad04b', 'ASOCIACION MUNICIPAL DE  MUJERES  CAMPESINAS DE LEBRIJA AMMUCALE', generar_slug_unico('ASOCIACION MUNICIPAL DE  MUJERES  CAMPESINAS DE LEBRIJA AMMUCALE', '95a7fa34-4fa4-4781-bf15-18c3960ad04b'), (select id from categorias_oficiales where slug = 'pendiente-clasificar'), 'Lebrija', null, 'Carrera 14D N. 12 – 20 Barrio Cabecera del Llano (ASOVIPOL)', 7.14638888888889, -73.34083333333332, null, null, 'FRUTAS Y HORTALIZAS', '3172884849', '573172884849', 'ammucale@hotmail.com', 'ISOLINA NIÑO CALDERÓN', '804001605-7', null, null, null, null, 'RETIRADO', null, 2018, '982 msnm', '73°20''27''''', '7°08''47''''', null, 'Retirado', null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, '-No se utilizan materiales peligrosos y/o tóxicos en los procesos.', null, null, true, false, false, false, false
where not exists (select 1 from negocios where nombre = 'ASOCIACION MUNICIPAL DE  MUJERES  CAMPESINAS DE LEBRIJA AMMUCALE');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'ASOCIACION MUNICIPAL DE  MUJERES  CAMPESINAS DE LEBRIJA AMMUCALE');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'ASOCIACION MUNICIPAL DE  MUJERES  CAMPESINAS DE LEBRIJA AMMUCALE'), (select id from categorias_oficiales where slug = 'pendiente-clasificar');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'ASOCIACION MUNICIPAL DE  MUJERES  CAMPESINAS DE LEBRIJA AMMUCALE');
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'ASOCIACION MUNICIPAL DE  MUJERES  CAMPESINAS DE LEBRIJA AMMUCALE');

-- ECO ENERGY LATIN AMERICA S.A.S. BIC
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'calidad-ambiental'),
  municipio = 'Bucaramanga',
  vereda_id = (select id from veredas where municipio = 'Bucaramanga' and slug = 'perimetro-urbano'),
  direccion = 'CALLE 105A 21-70',
  latitud = 7.194444444444445,
  longitud = -73.1286111111111,
  descripcion_corta = 'Ejecuciòn de contratos de innovaciòn, consultorias, diseños estudios, implementaciòn, interventorias en dispciplinas de la ingenieria electrica, electronica…',
  descripcion = 'Ejecuciòn de contratos de innovaciòn, consultorias, diseños estudios, implementaciòn, interventorias en dispciplinas de la ingenieria electrica, electronica y civil tales como diseñores de plataforma tecnologica para la localizaciòn y monitoreo a vehiculos, motos, embarcaciones.',
  producto = 'SERVICIO DE INSTALACIÓN DE PROYECTOS DE FUENTES NO CONVENCIONALES DE ENERGIA FNCE 1',
  telefono = '3165252178',
  whatsapp = '573165252178',
  email = 'gerencia@ecoenergylatinamerica.com',
  representante_legal = 'JOSE LEONARDO RIVERA MORA',
  nit = '901156642-7',
  naturaleza_juridica = null,
  delegado = null,
  rut_camara_comercio = null,
  responsable_cdmb = 'HEINER ORTIZ',
  novedad = 'SUSPENDIDO',
  tipo_negocio_verde = null,
  anio_registro = 2021,
  cota_msnm = null,
  este = '73°07''43''''',
  norte = '7°11''40''''',
  aplicacion_ficha_2025 = 'No actualizó',
  observaciones = 'No realizo visita ni se aplico ficha de verificacion',
  registro_nacional_turismo = null,
  uso_suelo = null,
  concesion_aguas = null,
  concesion_aguas_vencimiento = null,
  vertimientos = null,
  vertimientos_vencimiento = null,
  pueaa = null,
  pgris = null,
  pozo_septico = null,
  alcantarillado = null,
  ica = null,
  ica_vencimiento = null,
  invima = null,
  invima_vencimiento = null,
  certificado_tenencia_animales = null,
  buenas_practicas_agricolas = null,
  buenas_practicas_apicolas = null,
  registro_apicola = null,
  intervencion_cauce = null,
  capacidad_carga = null,
  sstt = null,
  canal_venta = null,
  exportacion = null,
  huella_carbono = null,
  fortalezas_ambiental = null,
  fortalezas_social = null,
  fortalezas_economico = null,
  emprendimiento_verde = true,
  sello_marca = false,
  avalado = false,
  destacado = false,
  activo = false
where nombre = 'ECO ENERGY LATIN AMERICA S.A.S. BIC';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select 'd0b95bae-3c8b-4181-9f18-62b1a635c088', 'ECO ENERGY LATIN AMERICA S.A.S. BIC', generar_slug_unico('ECO ENERGY LATIN AMERICA S.A.S. BIC', 'd0b95bae-3c8b-4181-9f18-62b1a635c088'), (select id from categorias_oficiales where slug = 'calidad-ambiental'), 'Bucaramanga', (select id from veredas where municipio = 'Bucaramanga' and slug = 'perimetro-urbano'), 'CALLE 105A 21-70', 7.194444444444445, -73.1286111111111, 'Ejecuciòn de contratos de innovaciòn, consultorias, diseños estudios, implementaciòn, interventorias en dispciplinas de la ingenieria electrica, electronica…', 'Ejecuciòn de contratos de innovaciòn, consultorias, diseños estudios, implementaciòn, interventorias en dispciplinas de la ingenieria electrica, electronica y civil tales como diseñores de plataforma tecnologica para la localizaciòn y monitoreo a vehiculos, motos, embarcaciones.', 'SERVICIO DE INSTALACIÓN DE PROYECTOS DE FUENTES NO CONVENCIONALES DE ENERGIA FNCE 1', '3165252178', '573165252178', 'gerencia@ecoenergylatinamerica.com', 'JOSE LEONARDO RIVERA MORA', '901156642-7', null, null, null, 'HEINER ORTIZ', 'SUSPENDIDO', null, 2021, null, '73°07''43''''', '7°11''40''''', 'No actualizó', 'No realizo visita ni se aplico ficha de verificacion', null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, true, false, false, false, false
where not exists (select 1 from negocios where nombre = 'ECO ENERGY LATIN AMERICA S.A.S. BIC');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'ECO ENERGY LATIN AMERICA S.A.S. BIC');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'ECO ENERGY LATIN AMERICA S.A.S. BIC'), (select id from categorias_oficiales where slug = 'calidad-ambiental');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'ECO ENERGY LATIN AMERICA S.A.S. BIC');
insert into negocios_subcategorias (negocio_id, subcategoria_id) select (select id from negocios where nombre = 'ECO ENERGY LATIN AMERICA S.A.S. BIC'), id from subcategorias where slug = 'tecnologias-verdes';
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'ECO ENERGY LATIN AMERICA S.A.S. BIC');
insert into negocios_actividades (negocio_id, actividad_productiva_id) select (select id from negocios where nombre = 'ECO ENERGY LATIN AMERICA S.A.S. BIC'), id from actividades_productivas where slug = 'generacion-comercializacion-energia-fncer';
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'ECO ENERGY LATIN AMERICA S.A.S. BIC'), 2022, 70.1 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'ECO ENERGY LATIN AMERICA S.A.S. BIC'), 2023, 82.72 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'ECO ENERGY LATIN AMERICA S.A.S. BIC'), 2024, 96.1 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;

-- PAPERLAB
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'ecoproductos-industriales'),
  municipio = 'Bucaramanga',
  vereda_id = (select id from veredas where municipio = 'Bucaramanga' and slug = 'perimetro-urbano'),
  direccion = 'CALLE 35 # 26-45 APTO 3B - CALLE 7  13 - 23',
  latitud = 7.137777777777778,
  longitud = -73.13305555555554,
  descripcion_corta = 'Recolección y reciclaje de papel de oficina y su comercialización. la empresa presta el servicio  para el archivo confidencial que se genera en las…',
  descripcion = 'Recolección y reciclaje de papel de oficina y su comercialización. la empresa presta el servicio  para el archivo confidencial que se genera en las empresas,asegurando su destrucciòn y posteriormente este material es vendido a empresas que se dedican a la producciòn de papel con fines hiegienicos.',
  producto = 'RECOLECCIÓN DE PAPEL RECICLADO',
  telefono = '3212074744',
  whatsapp = '573212074744',
  email = 'operaciones@paperlab.com.co',
  representante_legal = 'MARTA LUCIA AYCARDI SEPULVEDA',
  nit = '63537026-6',
  naturaleza_juridica = 'Natural',
  delegado = null,
  rut_camara_comercio = 'Cámara de comercio',
  responsable_cdmb = 'CLAUDIA SANCHEZ',
  novedad = 'ACTIVO',
  tipo_negocio_verde = 'Dinamizadoras',
  anio_registro = 2018,
  cota_msnm = '934.5 msnm',
  este = '73°7''59''''',
  norte = '7°8''16''''',
  aplicacion_ficha_2025 = 'Actualizó',
  observaciones = 'Se realizo visita y se actualizo ficha de verificacion',
  registro_nacional_turismo = null,
  uso_suelo = null,
  concesion_aguas = 'Acueducto',
  concesion_aguas_vencimiento = null,
  vertimientos = null,
  vertimientos_vencimiento = null,
  pueaa = null,
  pgris = 'Sí',
  pozo_septico = null,
  alcantarillado = 'Sí',
  ica = null,
  ica_vencimiento = null,
  invima = null,
  invima_vencimiento = null,
  certificado_tenencia_animales = null,
  buenas_practicas_agricolas = null,
  buenas_practicas_apicolas = null,
  registro_apicola = null,
  intervencion_cauce = null,
  capacidad_carga = null,
  sstt = 'Sí',
  canal_venta = 'B2B',
  exportacion = 'No',
  huella_carbono = 'SI',
  fortalezas_ambiental = 'Por cada tonelada de papel reciclado se dejan de talar 17 árboles en el mundo',
  fortalezas_social = 'Generan empleos indirectos y contribuyen con el desarrollo de la Región',
  fortalezas_economico = 'No compra el reciclaje realiza en contraprestación charlas de como reciclar',
  emprendimiento_verde = false,
  sello_marca = false,
  avalado = true,
  destacado = false,
  activo = true
where nombre = 'PAPERLAB';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select '604f5d9d-0ced-4ee1-b889-c8d224682494', 'PAPERLAB', generar_slug_unico('PAPERLAB', '604f5d9d-0ced-4ee1-b889-c8d224682494'), (select id from categorias_oficiales where slug = 'ecoproductos-industriales'), 'Bucaramanga', (select id from veredas where municipio = 'Bucaramanga' and slug = 'perimetro-urbano'), 'CALLE 35 # 26-45 APTO 3B - CALLE 7  13 - 23', 7.137777777777778, -73.13305555555554, 'Recolección y reciclaje de papel de oficina y su comercialización. la empresa presta el servicio  para el archivo confidencial que se genera en las…', 'Recolección y reciclaje de papel de oficina y su comercialización. la empresa presta el servicio  para el archivo confidencial que se genera en las empresas,asegurando su destrucciòn y posteriormente este material es vendido a empresas que se dedican a la producciòn de papel con fines hiegienicos.', 'RECOLECCIÓN DE PAPEL RECICLADO', '3212074744', '573212074744', 'operaciones@paperlab.com.co', 'MARTA LUCIA AYCARDI SEPULVEDA', '63537026-6', 'Natural', null, 'Cámara de comercio', 'CLAUDIA SANCHEZ', 'ACTIVO', 'Dinamizadoras', 2018, '934.5 msnm', '73°7''59''''', '7°8''16''''', 'Actualizó', 'Se realizo visita y se actualizo ficha de verificacion', null, null, 'Acueducto', null, null, null, null, 'Sí', null, 'Sí', null, null, null, null, null, null, null, null, null, null, 'Sí', 'B2B', 'No', 'SI', 'Por cada tonelada de papel reciclado se dejan de talar 17 árboles en el mundo', 'Generan empleos indirectos y contribuyen con el desarrollo de la Región', 'No compra el reciclaje realiza en contraprestación charlas de como reciclar', false, false, true, false, true
where not exists (select 1 from negocios where nombre = 'PAPERLAB');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'PAPERLAB');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'PAPERLAB'), (select id from categorias_oficiales where slug = 'ecoproductos-industriales');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'PAPERLAB');
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'PAPERLAB');
insert into negocios_actividades (negocio_id, actividad_productiva_id) select (select id from negocios where nombre = 'PAPERLAB'), id from actividades_productivas where slug = 'aprovechamiento-residuos-inorganicos';
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'PAPERLAB'), 2020, 51.37 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'PAPERLAB'), 2021, 60.98 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'PAPERLAB'), 2022, 60.98 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'PAPERLAB'), 2023, 76.13 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'PAPERLAB'), 2024, 75.8 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'PAPERLAB'), 2025, 77.1 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;

-- RECICLAJE MAPRES S.A.S.
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'ecoproductos-industriales'),
  municipio = 'Bucaramanga',
  vereda_id = (select id from veredas where municipio = 'Bucaramanga' and slug = 'perimetro-urbano'),
  direccion = 'CALLE 31 # 7-86 BARRIO GIRARDOT - CALLE 9 # 15 - 93 BARRIO CHAPINERO',
  latitud = 7.098333333333333,
  longitud = -73.11,
  descripcion_corta = 'Empresa familiar que en la actualidad tiene el 80% de la capacidad está enfocada en la línea del plástico reciclado y el otro 20% está en la…',
  descripcion = 'Empresa familiar que en la actualidad tiene el 80% de la capacidad está enfocada en la línea del plástico reciclado y el otro 20% está en la comercialización de materiales ferrosos y no ferrosos. La especialidad de la empresa es la recoleccion, transformacion y comercializacion de plastico molido reciclado, como lo es PEAD, PP, PVC y otro tipo de plásticos, los cuales son comercializados como materia prima para aquellas empresas que hacen nuevamente productos de plasticos como son; estibas, canastas, manguera y demás.',
  producto = 'PLASTICO MOLIDO, POLIPROPILENO, POLIETILENO',
  telefono = '3173811752',
  whatsapp = '573173811752',
  email = 'mapres.sas@gmail.com',
  representante_legal = 'JUAN PABLO DIAZ MALDONADO',
  nit = '900445577-2',
  naturaleza_juridica = 'Jurídica',
  delegado = null,
  rut_camara_comercio = 'Cámara de comercio',
  responsable_cdmb = 'CLAUDIA SANCHEZ',
  novedad = 'ACTIVO',
  tipo_negocio_verde = 'Dinamizadoras',
  anio_registro = 2019,
  cota_msnm = '1.400 msnm',
  este = '73°6''36''''',
  norte = '7°5''54''''',
  aplicacion_ficha_2025 = 'Actualizó',
  observaciones = 'Se realizo visita y se aplico ficha de verificacion',
  registro_nacional_turismo = null,
  uso_suelo = 'Sí',
  concesion_aguas = 'Acueducto',
  concesion_aguas_vencimiento = null,
  vertimientos = null,
  vertimientos_vencimiento = null,
  pueaa = 'No',
  pgris = 'Sí',
  pozo_septico = null,
  alcantarillado = 'Sí',
  ica = null,
  ica_vencimiento = null,
  invima = null,
  invima_vencimiento = null,
  certificado_tenencia_animales = null,
  buenas_practicas_agricolas = null,
  buenas_practicas_apicolas = null,
  registro_apicola = null,
  intervencion_cauce = null,
  capacidad_carga = null,
  sstt = 'Sí',
  canal_venta = 'B2B',
  exportacion = 'No',
  huella_carbono = 'NO',
  fortalezas_ambiental = 'TRASNFORMACION DE RESIDUOS PLASTICOS APROVECHABLES',
  fortalezas_social = 'La empresa reciclaje Mapres tiene un componente social con un enfoque de equidad de género al momento de su contratación de personal tiene muy presente el enfoque diferencial.',
  fortalezas_economico = 'Alto valor agregado. Diversificación de ingresos.',
  emprendimiento_verde = false,
  sello_marca = true,
  avalado = true,
  destacado = false,
  activo = true
where nombre = 'RECICLAJE MAPRES S.A.S.';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select '40b43850-f4a1-4846-84ba-3882ec88b9bf', 'RECICLAJE MAPRES S.A.S.', generar_slug_unico('RECICLAJE MAPRES S.A.S.', '40b43850-f4a1-4846-84ba-3882ec88b9bf'), (select id from categorias_oficiales where slug = 'ecoproductos-industriales'), 'Bucaramanga', (select id from veredas where municipio = 'Bucaramanga' and slug = 'perimetro-urbano'), 'CALLE 31 # 7-86 BARRIO GIRARDOT - CALLE 9 # 15 - 93 BARRIO CHAPINERO', 7.098333333333333, -73.11, 'Empresa familiar que en la actualidad tiene el 80% de la capacidad está enfocada en la línea del plástico reciclado y el otro 20% está en la…', 'Empresa familiar que en la actualidad tiene el 80% de la capacidad está enfocada en la línea del plástico reciclado y el otro 20% está en la comercialización de materiales ferrosos y no ferrosos. La especialidad de la empresa es la recoleccion, transformacion y comercializacion de plastico molido reciclado, como lo es PEAD, PP, PVC y otro tipo de plásticos, los cuales son comercializados como materia prima para aquellas empresas que hacen nuevamente productos de plasticos como son; estibas, canastas, manguera y demás.', 'PLASTICO MOLIDO, POLIPROPILENO, POLIETILENO', '3173811752', '573173811752', 'mapres.sas@gmail.com', 'JUAN PABLO DIAZ MALDONADO', '900445577-2', 'Jurídica', null, 'Cámara de comercio', 'CLAUDIA SANCHEZ', 'ACTIVO', 'Dinamizadoras', 2019, '1.400 msnm', '73°6''36''''', '7°5''54''''', 'Actualizó', 'Se realizo visita y se aplico ficha de verificacion', null, 'Sí', 'Acueducto', null, null, null, 'No', 'Sí', null, 'Sí', null, null, null, null, null, null, null, null, null, null, 'Sí', 'B2B', 'No', 'NO', 'TRASNFORMACION DE RESIDUOS PLASTICOS APROVECHABLES', 'La empresa reciclaje Mapres tiene un componente social con un enfoque de equidad de género al momento de su contratación de personal tiene muy presente el enfoque diferencial.', 'Alto valor agregado. Diversificación de ingresos.', false, true, true, false, true
where not exists (select 1 from negocios where nombre = 'RECICLAJE MAPRES S.A.S.');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'RECICLAJE MAPRES S.A.S.');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'RECICLAJE MAPRES S.A.S.'), (select id from categorias_oficiales where slug = 'ecoproductos-industriales');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'RECICLAJE MAPRES S.A.S.');
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'RECICLAJE MAPRES S.A.S.');
insert into negocios_actividades (negocio_id, actividad_productiva_id) select (select id from negocios where nombre = 'RECICLAJE MAPRES S.A.S.'), id from actividades_productivas where slug = 'aprovechamiento-residuos-inorganicos';
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'RECICLAJE MAPRES S.A.S.'), 2020, 61.79 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'RECICLAJE MAPRES S.A.S.'), 2021, 64.38 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'RECICLAJE MAPRES S.A.S.'), 2022, 61.21 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'RECICLAJE MAPRES S.A.S.'), 2023, 61.21 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'RECICLAJE MAPRES S.A.S.'), 2024, 68.7 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'RECICLAJE MAPRES S.A.S.'), 2025, 75.9 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;

-- LUIS EDUARDO ACEVEDO - INGEANDES
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'pendiente-clasificar'),
  municipio = 'Bucaramanga',
  vereda_id = null,
  direccion = null,
  latitud = 7.083444444444444,
  longitud = -73.16169444444445,
  descripcion_corta = null,
  descripcion = null,
  producto = 'ECONOMÍA CIRCULAR',
  telefono = '3118080836',
  whatsapp = '573118080836',
  email = null,
  representante_legal = 'LUIS EDUARDO ACEVEDO',
  nit = null,
  naturaleza_juridica = null,
  delegado = null,
  rut_camara_comercio = null,
  responsable_cdmb = null,
  novedad = 'RETIRADO',
  tipo_negocio_verde = null,
  anio_registro = 2021,
  cota_msnm = null,
  este = '73°09''42,1''''',
  norte = '7°05''00,4''''',
  aplicacion_ficha_2025 = null,
  observaciones = 'Revisión si aplica retiro',
  registro_nacional_turismo = null,
  uso_suelo = null,
  concesion_aguas = null,
  concesion_aguas_vencimiento = null,
  vertimientos = null,
  vertimientos_vencimiento = null,
  pueaa = null,
  pgris = null,
  pozo_septico = null,
  alcantarillado = null,
  ica = null,
  ica_vencimiento = null,
  invima = null,
  invima_vencimiento = null,
  certificado_tenencia_animales = null,
  buenas_practicas_agricolas = null,
  buenas_practicas_apicolas = null,
  registro_apicola = null,
  intervencion_cauce = null,
  capacidad_carga = null,
  sstt = null,
  canal_venta = null,
  exportacion = null,
  huella_carbono = null,
  fortalezas_ambiental = null,
  fortalezas_social = null,
  fortalezas_economico = null,
  emprendimiento_verde = true,
  sello_marca = false,
  avalado = false,
  destacado = false,
  activo = false
where nombre = 'LUIS EDUARDO ACEVEDO - INGEANDES';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select '883d1f5f-e787-49cc-9e67-1be59d1d1791', 'LUIS EDUARDO ACEVEDO - INGEANDES', generar_slug_unico('LUIS EDUARDO ACEVEDO - INGEANDES', '883d1f5f-e787-49cc-9e67-1be59d1d1791'), (select id from categorias_oficiales where slug = 'pendiente-clasificar'), 'Bucaramanga', null, null, 7.083444444444444, -73.16169444444445, null, null, 'ECONOMÍA CIRCULAR', '3118080836', '573118080836', null, 'LUIS EDUARDO ACEVEDO', null, null, null, null, null, 'RETIRADO', null, 2021, null, '73°09''42,1''''', '7°05''00,4''''', null, 'Revisión si aplica retiro', null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, true, false, false, false, false
where not exists (select 1 from negocios where nombre = 'LUIS EDUARDO ACEVEDO - INGEANDES');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'LUIS EDUARDO ACEVEDO - INGEANDES');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'LUIS EDUARDO ACEVEDO - INGEANDES'), (select id from categorias_oficiales where slug = 'pendiente-clasificar');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'LUIS EDUARDO ACEVEDO - INGEANDES');
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'LUIS EDUARDO ACEVEDO - INGEANDES');

-- ASOCIACIÓN DE ARTESANAS Y AGRICULTORES HECHO EN LEBRIJA
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'ecoproductos-industriales'),
  municipio = 'Lebrija',
  vereda_id = (select id from veredas where municipio = 'Lebrija' and slug = 'piedras-negras'),
  direccion = 'PRIMAX SAN PABLO, LOCALES 3 Y 4, LEBRIJA, SANTANDER',
  latitud = null,
  longitud = null,
  descripcion_corta = 'La asociacion realizará las actividades de bienestar social a sus asociados relacionados con la elaboración de artesanías que destaquen al municipio de…',
  descripcion = 'La asociacion realizará las actividades de bienestar social a sus asociados relacionados con la elaboración de artesanías que destaquen al municipio de lebrija y a santander, siembra y cosecha de productos agricolas y pecuarios y su comercialización. para lograrlo se propone: 1- elaboración de bisutería 2- tejido en crochet 3- cestería 4- cerámicas 5- bordados y decoración de accesorios 6- elaboración de dulces, pulpas, mermeladas naturales y alimentos que se cosechan en la región. 7- accesorios y prendas con la fibra de piña. 8- tejeduría en telar y tintes de fibras naturales. 9- productos hechos con reciclaje.
ACTIVIDADES DE BIENESTAR SOCIAL A SUS ASOCIADOS RELACIONADOS CON LA ELABORACIÓN
DE ARTESANÍAS QUE DESTAQUEN AL MUNICIPIO DE LEBRIJA Y A SANTANDER, SIEMBRA Y
COSECHA DE PRODUCTOS AGRICOLAS Y PECUARIOS Y SU COMERCIALIZACIÓN. PARA LOGRARLO
SE PROPONE: 1- ELABORACIÓN DE BISUTERÍA 2- TEJIDO EN CROCHET 3- CESTERÍA 4-
CERÁMICAS 5- BORDADOS Y DECORACIÓN DE ACCESORIOS 6- ELABORACIÓN DE DULCES,
PULPAS, MERMELADAS NATURALES Y ALIMENTOS QUE SE COSECHAN EN LA REGIÓN. 7-
ACCESORIOS Y PRENDAS CON LA FIBRA DE PIÑA. 8- TEJEDURÍA EN TELAR Y TINTES DE
FIBRAS NATURALES. 9- PRODUCTOS HECHOS CON RECICLAJE.',
  producto = 'PRODUCTOS ARTESANALES ELABORADOS CON FIBRA DE HOJA DE PIÑA',
  telefono = '3188682601 - 3182364601',
  whatsapp = '3188682601 - 3182364601',
  email = 'hechoenlebrija1@gmail.com',
  representante_legal = 'VALENTINA RINCON ARDILA',
  nit = '901369011-4',
  naturaleza_juridica = 'Jurídica',
  delegado = 'DEISY VIVIANA ARDILA CARDENAS',
  rut_camara_comercio = 'Cámara de comercio',
  responsable_cdmb = 'NATALY RAMIREZ',
  novedad = 'ACTIVO',
  tipo_negocio_verde = 'Dinamizadoras',
  anio_registro = 2021,
  cota_msnm = '1.142 msnm',
  este = '73°13''6635"',
  norte = '7°4''33268"',
  aplicacion_ficha_2025 = 'Actualizó',
  observaciones = null,
  registro_nacional_turismo = 'Sí',
  uso_suelo = 'Sí',
  concesion_aguas = 'Acueducto veredal',
  concesion_aguas_vencimiento = null,
  vertimientos = null,
  vertimientos_vencimiento = null,
  pueaa = 'No',
  pgris = 'No',
  pozo_septico = 'Sí',
  alcantarillado = null,
  ica = null,
  ica_vencimiento = null,
  invima = null,
  invima_vencimiento = null,
  certificado_tenencia_animales = null,
  buenas_practicas_agricolas = 'No',
  buenas_practicas_apicolas = null,
  registro_apicola = null,
  intervencion_cauce = null,
  capacidad_carga = 'No',
  sstt = null,
  canal_venta = 'B2B',
  exportacion = 'No',
  huella_carbono = 'NO',
  fortalezas_ambiental = 'APROVECHAMIENTO DE RESIDUOS AGROINDUSTRIALES REDUCIENEDO LA CANTIDAD DE DESECHOS,CONTAMINANCION Y QUEMAS DISMINUYE EL MATERIAL SINTETICO EN ACCESORIOS , PROMUEVE LA ECONOMIA CIRCULAR MEDIANTE EL RECICLAJE DE BIOMASA, PRODUCCION ARTESANAL CON BAJO CONSUMO ENERGETICO',
  fortalezas_social = 'GENERA EMPLEO E INGRESOS A COMUNIDADES RURALES Y MUJERES CAMPESINAS Y MADRES CABEZA DE FAMILIA, TRANSMITE SABERES TRADICIONALES  Y PROMUEVE EL TRABAJO ASOCIATIVO',
  fortalezas_economico = 'BAJO COSTO DE MATERIA PRIMA, NICHO DE MERCADO CRECIENTE EN PRODUCTOS ECOLOGICOS Y SOSTENIBLES . CAPACIDAD DE DIVERSIFICACIÓN',
  emprendimiento_verde = false,
  sello_marca = true,
  avalado = true,
  destacado = false,
  activo = true
where nombre = 'ASOCIACIÓN DE ARTESANAS Y AGRICULTORES HECHO EN LEBRIJA';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select 'e7285b31-0b87-4ec5-87d1-b87106711c27', 'ASOCIACIÓN DE ARTESANAS Y AGRICULTORES HECHO EN LEBRIJA', generar_slug_unico('ASOCIACIÓN DE ARTESANAS Y AGRICULTORES HECHO EN LEBRIJA', 'e7285b31-0b87-4ec5-87d1-b87106711c27'), (select id from categorias_oficiales where slug = 'ecoproductos-industriales'), 'Lebrija', (select id from veredas where municipio = 'Lebrija' and slug = 'piedras-negras'), 'PRIMAX SAN PABLO, LOCALES 3 Y 4, LEBRIJA, SANTANDER', null, null, 'La asociacion realizará las actividades de bienestar social a sus asociados relacionados con la elaboración de artesanías que destaquen al municipio de…', 'La asociacion realizará las actividades de bienestar social a sus asociados relacionados con la elaboración de artesanías que destaquen al municipio de lebrija y a santander, siembra y cosecha de productos agricolas y pecuarios y su comercialización. para lograrlo se propone: 1- elaboración de bisutería 2- tejido en crochet 3- cestería 4- cerámicas 5- bordados y decoración de accesorios 6- elaboración de dulces, pulpas, mermeladas naturales y alimentos que se cosechan en la región. 7- accesorios y prendas con la fibra de piña. 8- tejeduría en telar y tintes de fibras naturales. 9- productos hechos con reciclaje.
ACTIVIDADES DE BIENESTAR SOCIAL A SUS ASOCIADOS RELACIONADOS CON LA ELABORACIÓN
DE ARTESANÍAS QUE DESTAQUEN AL MUNICIPIO DE LEBRIJA Y A SANTANDER, SIEMBRA Y
COSECHA DE PRODUCTOS AGRICOLAS Y PECUARIOS Y SU COMERCIALIZACIÓN. PARA LOGRARLO
SE PROPONE: 1- ELABORACIÓN DE BISUTERÍA 2- TEJIDO EN CROCHET 3- CESTERÍA 4-
CERÁMICAS 5- BORDADOS Y DECORACIÓN DE ACCESORIOS 6- ELABORACIÓN DE DULCES,
PULPAS, MERMELADAS NATURALES Y ALIMENTOS QUE SE COSECHAN EN LA REGIÓN. 7-
ACCESORIOS Y PRENDAS CON LA FIBRA DE PIÑA. 8- TEJEDURÍA EN TELAR Y TINTES DE
FIBRAS NATURALES. 9- PRODUCTOS HECHOS CON RECICLAJE.', 'PRODUCTOS ARTESANALES ELABORADOS CON FIBRA DE HOJA DE PIÑA', '3188682601 - 3182364601', '3188682601 - 3182364601', 'hechoenlebrija1@gmail.com', 'VALENTINA RINCON ARDILA', '901369011-4', 'Jurídica', 'DEISY VIVIANA ARDILA CARDENAS', 'Cámara de comercio', 'NATALY RAMIREZ', 'ACTIVO', 'Dinamizadoras', 2021, '1.142 msnm', '73°13''6635"', '7°4''33268"', 'Actualizó', null, 'Sí', 'Sí', 'Acueducto veredal', null, null, null, 'No', 'No', 'Sí', null, null, null, null, null, null, 'No', null, null, null, 'No', null, 'B2B', 'No', 'NO', 'APROVECHAMIENTO DE RESIDUOS AGROINDUSTRIALES REDUCIENEDO LA CANTIDAD DE DESECHOS,CONTAMINANCION Y QUEMAS DISMINUYE EL MATERIAL SINTETICO EN ACCESORIOS , PROMUEVE LA ECONOMIA CIRCULAR MEDIANTE EL RECICLAJE DE BIOMASA, PRODUCCION ARTESANAL CON BAJO CONSUMO ENERGETICO', 'GENERA EMPLEO E INGRESOS A COMUNIDADES RURALES Y MUJERES CAMPESINAS Y MADRES CABEZA DE FAMILIA, TRANSMITE SABERES TRADICIONALES  Y PROMUEVE EL TRABAJO ASOCIATIVO', 'BAJO COSTO DE MATERIA PRIMA, NICHO DE MERCADO CRECIENTE EN PRODUCTOS ECOLOGICOS Y SOSTENIBLES . CAPACIDAD DE DIVERSIFICACIÓN', false, true, true, false, true
where not exists (select 1 from negocios where nombre = 'ASOCIACIÓN DE ARTESANAS Y AGRICULTORES HECHO EN LEBRIJA');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'ASOCIACIÓN DE ARTESANAS Y AGRICULTORES HECHO EN LEBRIJA');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'ASOCIACIÓN DE ARTESANAS Y AGRICULTORES HECHO EN LEBRIJA'), (select id from categorias_oficiales where slug = 'ecoproductos-industriales');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'ASOCIACIÓN DE ARTESANAS Y AGRICULTORES HECHO EN LEBRIJA');
insert into negocios_subcategorias (negocio_id, subcategoria_id) select (select id from negocios where nombre = 'ASOCIACIÓN DE ARTESANAS Y AGRICULTORES HECHO EN LEBRIJA'), id from subcategorias where slug = 'moda-sostenible';
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'ASOCIACIÓN DE ARTESANAS Y AGRICULTORES HECHO EN LEBRIJA');
insert into negocios_actividades (negocio_id, actividad_productiva_id) select (select id from negocios where nombre = 'ASOCIACIÓN DE ARTESANAS Y AGRICULTORES HECHO EN LEBRIJA'), id from actividades_productivas where slug = 'joyeria-artesania-bisuteria';
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'ASOCIACIÓN DE ARTESANAS Y AGRICULTORES HECHO EN LEBRIJA'), 2022, 51.0 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'ASOCIACIÓN DE ARTESANAS Y AGRICULTORES HECHO EN LEBRIJA'), 2023, 70.19 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'ASOCIACIÓN DE ARTESANAS Y AGRICULTORES HECHO EN LEBRIJA'), 2024, 60.2 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'ASOCIACIÓN DE ARTESANAS Y AGRICULTORES HECHO EN LEBRIJA'), 2025, 71.8 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;

-- ALIANZA PORKCOLOMBIA-LEONIDAS GÓMEZ
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'pendiente-clasificar'),
  municipio = 'El Playón',
  vereda_id = null,
  direccion = 'Granja Buenos Aires, Vereda Tres Portones',
  latitud = 7.088349999999999,
  longitud = -73.07896666666666,
  descripcion_corta = null,
  descripcion = null,
  producto = 'CERDO EN PIE',
  telefono = '3184674496',
  whatsapp = '573184674496',
  email = 'mildredp_20@hotmail.com',
  representante_legal = 'LEONIDAS GÓMEZ',
  nit = '91157947',
  naturaleza_juridica = null,
  delegado = null,
  rut_camara_comercio = null,
  responsable_cdmb = null,
  novedad = 'RETIRADO',
  tipo_negocio_verde = null,
  anio_registro = 2020,
  cota_msnm = '1.120 msnm',
  este = '73°04''44,28''''',
  norte = '7°05''18,06''''',
  aplicacion_ficha_2025 = null,
  observaciones = 'Revisión si aplica retiro',
  registro_nacional_turismo = null,
  uso_suelo = null,
  concesion_aguas = null,
  concesion_aguas_vencimiento = null,
  vertimientos = null,
  vertimientos_vencimiento = null,
  pueaa = null,
  pgris = null,
  pozo_septico = null,
  alcantarillado = null,
  ica = null,
  ica_vencimiento = null,
  invima = null,
  invima_vencimiento = null,
  certificado_tenencia_animales = null,
  buenas_practicas_agricolas = null,
  buenas_practicas_apicolas = null,
  registro_apicola = null,
  intervencion_cauce = null,
  capacidad_carga = null,
  sstt = null,
  canal_venta = null,
  exportacion = null,
  huella_carbono = null,
  fortalezas_ambiental = null,
  fortalezas_social = null,
  fortalezas_economico = null,
  emprendimiento_verde = true,
  sello_marca = false,
  avalado = false,
  destacado = false,
  activo = false
where nombre = 'ALIANZA PORKCOLOMBIA-LEONIDAS GÓMEZ';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select '235d2145-9b6e-4c07-a97a-f29138c23c8b', 'ALIANZA PORKCOLOMBIA-LEONIDAS GÓMEZ', generar_slug_unico('ALIANZA PORKCOLOMBIA-LEONIDAS GÓMEZ', '235d2145-9b6e-4c07-a97a-f29138c23c8b'), (select id from categorias_oficiales where slug = 'pendiente-clasificar'), 'El Playón', null, 'Granja Buenos Aires, Vereda Tres Portones', 7.088349999999999, -73.07896666666666, null, null, 'CERDO EN PIE', '3184674496', '573184674496', 'mildredp_20@hotmail.com', 'LEONIDAS GÓMEZ', '91157947', null, null, null, null, 'RETIRADO', null, 2020, '1.120 msnm', '73°04''44,28''''', '7°05''18,06''''', null, 'Revisión si aplica retiro', null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, true, false, false, false, false
where not exists (select 1 from negocios where nombre = 'ALIANZA PORKCOLOMBIA-LEONIDAS GÓMEZ');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'ALIANZA PORKCOLOMBIA-LEONIDAS GÓMEZ');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'ALIANZA PORKCOLOMBIA-LEONIDAS GÓMEZ'), (select id from categorias_oficiales where slug = 'pendiente-clasificar');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'ALIANZA PORKCOLOMBIA-LEONIDAS GÓMEZ');
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'ALIANZA PORKCOLOMBIA-LEONIDAS GÓMEZ');
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'ALIANZA PORKCOLOMBIA-LEONIDAS GÓMEZ'), 2020, 28.66 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'ALIANZA PORKCOLOMBIA-LEONIDAS GÓMEZ'), 2021, 30.13 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;


commit;
