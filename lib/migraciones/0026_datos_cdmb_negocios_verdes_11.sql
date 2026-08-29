begin;

-- Generado por lib/migraciones/generar_0026.py desde BASE_ACTUALIZADA_NV_ka.xlsx — no editar a mano.
-- Uno de varios archivos partidos (ver README.md) — correr TODOS, en cualquier orden, cada uno es su propia transacción.

-- Parte 11 de 17.

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

-- RUBY STELLA MORALES
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'pendiente-clasificar'),
  municipio = 'Matanza',
  vereda_id = null,
  direccion = 'Finca Sierravento Vereda Campo Hermoso el provenir',
  latitud = 7.3711111111111105,
  longitud = -73.11055555555555,
  descripcion_corta = null,
  descripcion = null,
  producto = 'IDEA DE NEGOCIO',
  telefono = '3013820103',
  whatsapp = '573013820103',
  email = null,
  representante_legal = 'RUBY STELLA MORALES',
  nit = '51684570',
  naturaleza_juridica = null,
  delegado = null,
  rut_camara_comercio = null,
  responsable_cdmb = null,
  novedad = 'RETIRADO',
  tipo_negocio_verde = 'No aplica',
  anio_registro = 2023,
  cota_msnm = '1698 msnm',
  este = '73°06''38"',
  norte = '7°22''16"',
  aplicacion_ficha_2025 = null,
  observaciones = 'NO Ingresa al programa',
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
where nombre = 'RUBY STELLA MORALES';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select 'e7914b01-2e44-47ea-bb62-bd818ebb7c44', 'RUBY STELLA MORALES', generar_slug_unico('RUBY STELLA MORALES', 'e7914b01-2e44-47ea-bb62-bd818ebb7c44'), (select id from categorias_oficiales where slug = 'pendiente-clasificar'), 'Matanza', null, 'Finca Sierravento Vereda Campo Hermoso el provenir', 7.3711111111111105, -73.11055555555555, null, null, 'IDEA DE NEGOCIO', '3013820103', '573013820103', null, 'RUBY STELLA MORALES', '51684570', null, null, null, null, 'RETIRADO', 'No aplica', 2023, '1698 msnm', '73°06''38"', '7°22''16"', null, 'NO Ingresa al programa', null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, true, false, false, false, false
where not exists (select 1 from negocios where nombre = 'RUBY STELLA MORALES');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'RUBY STELLA MORALES');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'RUBY STELLA MORALES'), (select id from categorias_oficiales where slug = 'pendiente-clasificar');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'RUBY STELLA MORALES');
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'RUBY STELLA MORALES');

-- AGROCEBOLLA
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'pendiente-clasificar'),
  municipio = 'Tona',
  vereda_id = null,
  direccion = 'FINCA CRISTALES VEREDA CUESTA BOA - BERLIN',
  latitud = 7.21227,
  longitud = -72.889,
  descripcion_corta = null,
  descripcion = null,
  producto = 'CEBOLLA',
  telefono = '3102457011 - 3148822335',
  whatsapp = '3102457011 - 3148822335',
  email = 'agrocebollasantander23@gmail.com',
  representante_legal = 'OSCAR MAURICIO CAPACHO',
  nit = '13742817',
  naturaleza_juridica = null,
  delegado = null,
  rut_camara_comercio = null,
  responsable_cdmb = 'ANDRES VALDERRAMA',
  novedad = 'SUSPENDIDO',
  tipo_negocio_verde = null,
  anio_registro = 2023,
  cota_msnm = '3627 msnm',
  este = '72.889',
  norte = '7.21227',
  aplicacion_ficha_2025 = null,
  observaciones = 'Ingresa al programa',
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
where nombre = 'AGROCEBOLLA';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select '4148208d-9309-4961-947c-f11c3b65b077', 'AGROCEBOLLA', generar_slug_unico('AGROCEBOLLA', '4148208d-9309-4961-947c-f11c3b65b077'), (select id from categorias_oficiales where slug = 'pendiente-clasificar'), 'Tona', null, 'FINCA CRISTALES VEREDA CUESTA BOA - BERLIN', 7.21227, -72.889, null, null, 'CEBOLLA', '3102457011 - 3148822335', '3102457011 - 3148822335', 'agrocebollasantander23@gmail.com', 'OSCAR MAURICIO CAPACHO', '13742817', null, null, null, 'ANDRES VALDERRAMA', 'SUSPENDIDO', null, 2023, '3627 msnm', '72.889', '7.21227', null, 'Ingresa al programa', null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, true, false, false, false, false
where not exists (select 1 from negocios where nombre = 'AGROCEBOLLA');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'AGROCEBOLLA');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'AGROCEBOLLA'), (select id from categorias_oficiales where slug = 'pendiente-clasificar');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'AGROCEBOLLA');
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'AGROCEBOLLA');

-- AVICOSACOL
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'),
  municipio = 'Matanza',
  vereda_id = (select id from veredas where municipio = 'Matanza' and slug = 'alto-bravo'),
  direccion = 'VEREDA ALTO BRAVO, FINCA VIRELIA',
  latitud = 7.371666666666666,
  longitud = -73.095,
  descripcion_corta = 'Produccion de café y se comercializa en grano verde, exporadicamente se trabaja el valor agregado del café',
  descripcion = 'Produccion de café y se comercializa en grano verde, exporadicamente se trabaja el valor agregado del café',
  producto = 'CAFÉ',
  telefono = '3014245809',
  whatsapp = '573014245809',
  email = 'robermesa12@gmail.com',
  representante_legal = 'ROBERTO MESA VANEGAS',
  nit = '901299505-1',
  naturaleza_juridica = 'Jurídica',
  delegado = null,
  rut_camara_comercio = 'Cámara de comercio',
  responsable_cdmb = 'ANDRES VALDERRAMA',
  novedad = 'ACTIVO',
  tipo_negocio_verde = 'Dinamizadoras',
  anio_registro = 2023,
  cota_msnm = '1385 msnm',
  este = '73°05''42"',
  norte = '7°22''18"',
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
  pozo_septico = 'No',
  alcantarillado = null,
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
  canal_venta = 'B2B',
  exportacion = 'No',
  huella_carbono = 'NO',
  fortalezas_ambiental = 'Educación en el manejo ambiental. Actividades sostenibles con el medio ambientes. Conservación y preservación de los servicios ecosistémicos',
  fortalezas_social = 'Capacitación a la comunidad. Educación ambiental con respeto al café y al cacao',
  fortalezas_economico = 'Modelo de negocio rentable. Empresa legalmente registrada en Cámara de Comercio',
  emprendimiento_verde = true,
  sello_marca = false,
  avalado = false,
  destacado = false,
  activo = true
where nombre = 'AVICOSACOL';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select 'dfea1b5e-cd17-4637-b247-fcb73b97b3a6', 'AVICOSACOL', generar_slug_unico('AVICOSACOL', 'dfea1b5e-cd17-4637-b247-fcb73b97b3a6'), (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'), 'Matanza', (select id from veredas where municipio = 'Matanza' and slug = 'alto-bravo'), 'VEREDA ALTO BRAVO, FINCA VIRELIA', 7.371666666666666, -73.095, 'Produccion de café y se comercializa en grano verde, exporadicamente se trabaja el valor agregado del café', 'Produccion de café y se comercializa en grano verde, exporadicamente se trabaja el valor agregado del café', 'CAFÉ', '3014245809', '573014245809', 'robermesa12@gmail.com', 'ROBERTO MESA VANEGAS', '901299505-1', 'Jurídica', null, 'Cámara de comercio', 'ANDRES VALDERRAMA', 'ACTIVO', 'Dinamizadoras', 2023, '1385 msnm', '73°05''42"', '7°22''18"', 'Actualizó', 'Se realizo visita y se actualizo ficha de verificacion', null, 'No', 'No', null, 'No', null, 'No', 'No', 'No', null, null, null, 'No', null, null, 'No', null, null, null, null, 'No', 'B2B', 'No', 'NO', 'Educación en el manejo ambiental. Actividades sostenibles con el medio ambientes. Conservación y preservación de los servicios ecosistémicos', 'Capacitación a la comunidad. Educación ambiental con respeto al café y al cacao', 'Modelo de negocio rentable. Empresa legalmente registrada en Cámara de Comercio', true, false, false, false, true
where not exists (select 1 from negocios where nombre = 'AVICOSACOL');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'AVICOSACOL');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'AVICOSACOL'), (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'AVICOSACOL');
insert into negocios_subcategorias (negocio_id, subcategoria_id) select (select id from negocios where nombre = 'AVICOSACOL'), id from subcategorias where slug = 'agroindustria-sostenible';
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'AVICOSACOL');
insert into negocios_actividades (negocio_id, actividad_productiva_id) select (select id from negocios where nombre = 'AVICOSACOL'), id from actividades_productivas where slug = 'agroindustrial-alimentario';
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'AVICOSACOL'), 2024, 44.5 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'AVICOSACOL'), 2025, 45.5 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;

-- REFUGIO HONEY
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'pendiente-clasificar'),
  municipio = 'Rionegro',
  vereda_id = null,
  direccion = 'FINCA EL REFUGIO VEREDA MIRAFLOREZ',
  latitud = 7.237222222222222,
  longitud = -73.1825,
  descripcion_corta = null,
  descripcion = null,
  producto = 'MIEL',
  telefono = '3168179081',
  whatsapp = '573168179081',
  email = 'danielpinilla0919@gmail.com',
  representante_legal = 'IVAN DANIEL PINILLA MANOSLAVA',
  nit = '1005150995',
  naturaleza_juridica = null,
  delegado = null,
  rut_camara_comercio = null,
  responsable_cdmb = 'ANDRES VALDERRAMA',
  novedad = 'SUSPENDIDO',
  tipo_negocio_verde = 'Inicial',
  anio_registro = 2023,
  cota_msnm = '909 msnm',
  este = '73°10''57"',
  norte = '7°14''14"',
  aplicacion_ficha_2025 = null,
  observaciones = 'ingresa al programa',
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
where nombre = 'REFUGIO HONEY';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select 'c233c421-8fbe-4f7c-973a-38a5cfd85502', 'REFUGIO HONEY', generar_slug_unico('REFUGIO HONEY', 'c233c421-8fbe-4f7c-973a-38a5cfd85502'), (select id from categorias_oficiales where slug = 'pendiente-clasificar'), 'Rionegro', null, 'FINCA EL REFUGIO VEREDA MIRAFLOREZ', 7.237222222222222, -73.1825, null, null, 'MIEL', '3168179081', '573168179081', 'danielpinilla0919@gmail.com', 'IVAN DANIEL PINILLA MANOSLAVA', '1005150995', null, null, null, 'ANDRES VALDERRAMA', 'SUSPENDIDO', 'Inicial', 2023, '909 msnm', '73°10''57"', '7°14''14"', null, 'ingresa al programa', null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, true, false, false, false, false
where not exists (select 1 from negocios where nombre = 'REFUGIO HONEY');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'REFUGIO HONEY');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'REFUGIO HONEY'), (select id from categorias_oficiales where slug = 'pendiente-clasificar');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'REFUGIO HONEY');
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'REFUGIO HONEY');

-- NATURALES VICTORIA
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'pendiente-clasificar'),
  municipio = 'Girón',
  vereda_id = null,
  direccion = 'CALLE 47 # 28-85 EL POBLADO',
  latitud = 7.075555555555555,
  longitud = -73.16972222222223,
  descripcion_corta = null,
  descripcion = null,
  producto = 'PULPAS DE FRUTA',
  telefono = '3157690210',
  whatsapp = '573157690210',
  email = 'cjazmincalderon@gmail.com',
  representante_legal = 'CLAUDIA JAZMIN CALDERON',
  nit = '63550985',
  naturaleza_juridica = null,
  delegado = null,
  rut_camara_comercio = null,
  responsable_cdmb = 'ANDRES VALDERRAMA',
  novedad = 'SUSPENDIDO',
  tipo_negocio_verde = 'Inicial',
  anio_registro = 2023,
  cota_msnm = '689 msnm',
  este = '73°10''11"',
  norte = '7°04''32"',
  aplicacion_ficha_2025 = null,
  observaciones = 'ingresa al programa',
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
where nombre = 'NATURALES VICTORIA';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select 'ff293f26-2df7-441b-a36c-41cfec2a55d8', 'NATURALES VICTORIA', generar_slug_unico('NATURALES VICTORIA', 'ff293f26-2df7-441b-a36c-41cfec2a55d8'), (select id from categorias_oficiales where slug = 'pendiente-clasificar'), 'Girón', null, 'CALLE 47 # 28-85 EL POBLADO', 7.075555555555555, -73.16972222222223, null, null, 'PULPAS DE FRUTA', '3157690210', '573157690210', 'cjazmincalderon@gmail.com', 'CLAUDIA JAZMIN CALDERON', '63550985', null, null, null, 'ANDRES VALDERRAMA', 'SUSPENDIDO', 'Inicial', 2023, '689 msnm', '73°10''11"', '7°04''32"', null, 'ingresa al programa', null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, true, false, false, false, false
where not exists (select 1 from negocios where nombre = 'NATURALES VICTORIA');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'NATURALES VICTORIA');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'NATURALES VICTORIA'), (select id from categorias_oficiales where slug = 'pendiente-clasificar');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'NATURALES VICTORIA');
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'NATURALES VICTORIA');

-- NATIVA SANTANDER
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'pendiente-clasificar'),
  municipio = 'Bucaramanga',
  vereda_id = null,
  direccion = 'CARRERA 28A # 40-106',
  latitud = 7.120555555555555,
  longitud = -73.11388888888888,
  descripcion_corta = null,
  descripcion = null,
  producto = 'ARTESANIAS',
  telefono = '3173961523 - 3212464651',
  whatsapp = '3173961523 - 3212464651',
  email = 'creactivasas@gmail.com',
  representante_legal = 'MAYLIN TATIANA JARAMILLO',
  nit = '900967314-2',
  naturaleza_juridica = null,
  delegado = null,
  rut_camara_comercio = null,
  responsable_cdmb = 'LAURA RUIZ',
  novedad = 'RETIRADO',
  tipo_negocio_verde = null,
  anio_registro = 2023,
  cota_msnm = null,
  este = '73°06''50"',
  norte = '7°07''14"',
  aplicacion_ficha_2025 = null,
  observaciones = 'ingresa al programa',
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
where nombre = 'NATIVA SANTANDER';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select '57c5741e-275a-4b4e-8ffa-617d5446d545', 'NATIVA SANTANDER', generar_slug_unico('NATIVA SANTANDER', '57c5741e-275a-4b4e-8ffa-617d5446d545'), (select id from categorias_oficiales where slug = 'pendiente-clasificar'), 'Bucaramanga', null, 'CARRERA 28A # 40-106', 7.120555555555555, -73.11388888888888, null, null, 'ARTESANIAS', '3173961523 - 3212464651', '3173961523 - 3212464651', 'creactivasas@gmail.com', 'MAYLIN TATIANA JARAMILLO', '900967314-2', null, null, null, 'LAURA RUIZ', 'RETIRADO', null, 2023, null, '73°06''50"', '7°07''14"', null, 'ingresa al programa', null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, true, false, false, false, false
where not exists (select 1 from negocios where nombre = 'NATIVA SANTANDER');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'NATIVA SANTANDER');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'NATIVA SANTANDER'), (select id from categorias_oficiales where slug = 'pendiente-clasificar');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'NATIVA SANTANDER');
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'NATIVA SANTANDER');

-- HONEY B
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'),
  municipio = 'Bucaramanga',
  vereda_id = (select id from veredas where municipio = 'Bucaramanga' and slug = 'perimetro-urbano'),
  direccion = 'CARRERA 17 # 98-03 TORRE MOLINOS T2 APT 403',
  latitud = 7.088989444444445,
  longitud = -73.12149972222221,
  descripcion_corta = 'Fabricación de jabones y detergentes, preparados para limpiar y pulir; perfumes y preparados de tocador',
  descripcion = 'Fabricación de jabones y detergentes, preparados para limpiar y pulir; perfumes y preparados de tocador',
  producto = 'SHAMPOO SÓLIDO A BASE DE MIEL DE ABEJAS',
  telefono = '3144832741',
  whatsapp = '573144832741',
  email = 'santiago9006@hotmail.com',
  representante_legal = 'CARLOS SANTIAGO CAVANZO SANCHEZ',
  nit = '1005289006-4',
  naturaleza_juridica = 'Natural',
  delegado = null,
  rut_camara_comercio = 'Cámara de comercio',
  responsable_cdmb = 'CARINE GARCIA',
  novedad = 'RETIRADO',
  tipo_negocio_verde = 'Dinamizadoras',
  anio_registro = 2023,
  cota_msnm = null,
  este = '73°7''17.399"',
  norte = '7°5''20.362"',
  aplicacion_ficha_2025 = 'Actualizó',
  observaciones = null,
  registro_nacional_turismo = null,
  uso_suelo = 'Sí',
  concesion_aguas = 'Acueducto',
  concesion_aguas_vencimiento = null,
  vertimientos = null,
  vertimientos_vencimiento = null,
  pueaa = 'No',
  pgris = 'No',
  pozo_septico = null,
  alcantarillado = 'Sí',
  ica = null,
  ica_vencimiento = null,
  invima = 'No',
  invima_vencimiento = null,
  certificado_tenencia_animales = null,
  buenas_practicas_agricolas = null,
  buenas_practicas_apicolas = null,
  registro_apicola = null,
  intervencion_cauce = null,
  capacidad_carga = null,
  sstt = 'No',
  canal_venta = 'B2C',
  exportacion = null,
  huella_carbono = null,
  fortalezas_ambiental = 'El producto (shampoo seco) es ecológico, y reduce el consumo de agua en su uso.
 • Utiliza miel natural proveniente de una fuente sostenible (asociación de campesinos que sustituyeron cultivos ilícitos).
 • El emprendimiento promueve el uso de ingredientes naturales y evita químicos contaminantes.
 • El fundador realiza charlas ambientales, lo que refuerza la educación y conciencia ecológica.',
  fortalezas_social = 'Genera impacto social positivo al apoyar asociaciones de campesinos en proceso de sustitución de cultivos ilícitos.
 • El emprendedor es joven, comprometido y con liderazgo social, lo que inspira a otros.
 • Contribuye a la sensibilización ambiental a través de educación y comunicación.
 • Promueve el consumo responsable y la economía local.
Genera impacto social positivo al apoyar asociaciones de campesinos en proceso de sustitución de cultivos ilícitos.
 • El emprendedor es joven, comprometido y con liderazgo social, lo que inspira a otros.
 • Contribuye a la sensibilización ambiental a través de educación y comunicación.
 • Promueve el consumo responsable y la economía local.
Genera impacto social positivo al apoyar asociaciones de campesinos en proceso de sustitución de cultivos ilícitos.
 • El emprendedor es joven, comprometido y con liderazgo social, lo que inspira a otros.
 • Contribuye a la sensibilización ambiental a través de educación y comunicación.
 • Promueve el consumo responsable y la economía local.',
  fortalezas_economico = 'Bajo costo de producción inicial por el tipo de producto y materia prima accesible.
 • Producto innovador con potencial de crecimiento en mercados sostenibles.
 • Genera valor agregado a la miel, impulsando una cadena de valor local.
 • Alta demanda potencial por la tendencia hacia productos naturales y ecológicos.',
  emprendimiento_verde = true,
  sello_marca = false,
  avalado = false,
  destacado = false,
  activo = false
where nombre = 'HONEY B';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select '8733b6eb-935b-48b3-a3d4-3e5c7b6afd99', 'HONEY B', generar_slug_unico('HONEY B', '8733b6eb-935b-48b3-a3d4-3e5c7b6afd99'), (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'), 'Bucaramanga', (select id from veredas where municipio = 'Bucaramanga' and slug = 'perimetro-urbano'), 'CARRERA 17 # 98-03 TORRE MOLINOS T2 APT 403', 7.088989444444445, -73.12149972222221, 'Fabricación de jabones y detergentes, preparados para limpiar y pulir; perfumes y preparados de tocador', 'Fabricación de jabones y detergentes, preparados para limpiar y pulir; perfumes y preparados de tocador', 'SHAMPOO SÓLIDO A BASE DE MIEL DE ABEJAS', '3144832741', '573144832741', 'santiago9006@hotmail.com', 'CARLOS SANTIAGO CAVANZO SANCHEZ', '1005289006-4', 'Natural', null, 'Cámara de comercio', 'CARINE GARCIA', 'RETIRADO', 'Dinamizadoras', 2023, null, '73°7''17.399"', '7°5''20.362"', 'Actualizó', null, null, 'Sí', 'Acueducto', null, null, null, 'No', 'No', null, 'Sí', null, null, 'No', null, null, null, null, null, null, null, 'No', 'B2C', null, null, 'El producto (shampoo seco) es ecológico, y reduce el consumo de agua en su uso.
 • Utiliza miel natural proveniente de una fuente sostenible (asociación de campesinos que sustituyeron cultivos ilícitos).
 • El emprendimiento promueve el uso de ingredientes naturales y evita químicos contaminantes.
 • El fundador realiza charlas ambientales, lo que refuerza la educación y conciencia ecológica.', 'Genera impacto social positivo al apoyar asociaciones de campesinos en proceso de sustitución de cultivos ilícitos.
 • El emprendedor es joven, comprometido y con liderazgo social, lo que inspira a otros.
 • Contribuye a la sensibilización ambiental a través de educación y comunicación.
 • Promueve el consumo responsable y la economía local.
Genera impacto social positivo al apoyar asociaciones de campesinos en proceso de sustitución de cultivos ilícitos.
 • El emprendedor es joven, comprometido y con liderazgo social, lo que inspira a otros.
 • Contribuye a la sensibilización ambiental a través de educación y comunicación.
 • Promueve el consumo responsable y la economía local.
Genera impacto social positivo al apoyar asociaciones de campesinos en proceso de sustitución de cultivos ilícitos.
 • El emprendedor es joven, comprometido y con liderazgo social, lo que inspira a otros.
 • Contribuye a la sensibilización ambiental a través de educación y comunicación.
 • Promueve el consumo responsable y la economía local.', 'Bajo costo de producción inicial por el tipo de producto y materia prima accesible.
 • Producto innovador con potencial de crecimiento en mercados sostenibles.
 • Genera valor agregado a la miel, impulsando una cadena de valor local.
 • Alta demanda potencial por la tendencia hacia productos naturales y ecológicos.', true, false, false, false, false
where not exists (select 1 from negocios where nombre = 'HONEY B');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'HONEY B');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'HONEY B'), (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'HONEY B');
insert into negocios_subcategorias (negocio_id, subcategoria_id) select (select id from negocios where nombre = 'HONEY B'), id from subcategorias where slug = 'agroindustria-sostenible';
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'HONEY B');
insert into negocios_actividades (negocio_id, actividad_productiva_id) select (select id from negocios where nombre = 'HONEY B'), id from actividades_productivas where slug = 'agroindustrial-no-alimentario';
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'HONEY B'), 2024, 67.3 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'HONEY B'), 2025, 50.8 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;

-- ROSANTU CACAO NIBS
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'),
  municipio = 'Lebrija',
  vereda_id = (select id from veredas where municipio = 'Lebrija' and slug = 'palonegro'),
  direccion = 'FCA LOS ROSALES VDA PALONEGRO VIA LA Y AL AEROPUERTO',
  latitud = 7.106035555555555,
  longitud = -73.18734472222222,
  descripcion_corta = 'Empresa dedicada a la producción y transformación del cultivo de cacao en productos artesanales como chocolate en bola y chocolate en polvo. Promueve la…',
  descripcion = 'Empresa dedicada a la producción y transformación del cultivo de cacao en productos artesanales como chocolate en bola y chocolate en polvo. Promueve la agricultura sostenible mediante un sistema agroforestal que respeta los ciclos naturales y protege la biodiversidad, evitando el uso de pesticidas y fertilizantes químicos. Sus chocolates se elaboran con ingredientes 100% naturales, libres de aditivos, y abre sus puertas al público a través de tours de cacao que ofrecen una experiencia educativa y vivencial en torno al origen del chocolate.',
  producto = 'CHOCOLATE DE MESA Y TRANSFORMACIÓN DE DERIVADOS DEL CACAO',
  telefono = '3002486318',
  whatsapp = '573002486318',
  email = 'paogomez09@gmail.com - losrosalescacao@gmail.com',
  representante_legal = 'DOLLY PAOLA GÓMEZ CARRASCAL',
  nit = '37863116-3',
  naturaleza_juridica = 'Natural',
  delegado = null,
  rut_camara_comercio = 'Cámara de comercio',
  responsable_cdmb = 'NATALY RAMIREZ',
  novedad = 'ACTIVO',
  tipo_negocio_verde = 'Dinamizadoras',
  anio_registro = 2023,
  cota_msnm = '1097 msnm',
  este = '73°11''14,441"',
  norte = '7°6''21,728"',
  aplicacion_ficha_2025 = 'Actualizó',
  observaciones = 'Se realizo visita y se aplico ficha de verificacion',
  registro_nacional_turismo = 'No',
  uso_suelo = 'No',
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
  invima = 'Sí',
  invima_vencimiento = '2035-11-06',
  certificado_tenencia_animales = null,
  buenas_practicas_agricolas = 'Sí',
  buenas_practicas_apicolas = null,
  registro_apicola = null,
  intervencion_cauce = null,
  capacidad_carga = 'No',
  sstt = 'No',
  canal_venta = 'B2C',
  exportacion = 'No',
  huella_carbono = 'NO',
  fortalezas_ambiental = 'EMPRESA QUE SE DEDICA A TRANSFORMACION DE PRODUCTOS A BASE DEL FRUTO DE CACAO CON UN ENFOQUE ORGANICO ARTESANAL , AMBIENTALMENTE SOSTENIBLE',
  fortalezas_social = 'La empresa cuenta con un componente social atractivo ya que en el momento de la contratación de los empleados tiene muy presente implementar el enfoque diferencial además la mayoría de sus empleados son mujeres.',
  fortalezas_economico = 'Alto valor agregado. Diversificación de ingresos.',
  emprendimiento_verde = false,
  sello_marca = false,
  avalado = true,
  destacado = false,
  activo = true
where nombre = 'ROSANTU CACAO NIBS';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select '3bcd2229-6e92-4fb8-9117-13d2718e37bf', 'ROSANTU CACAO NIBS', generar_slug_unico('ROSANTU CACAO NIBS', '3bcd2229-6e92-4fb8-9117-13d2718e37bf'), (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'), 'Lebrija', (select id from veredas where municipio = 'Lebrija' and slug = 'palonegro'), 'FCA LOS ROSALES VDA PALONEGRO VIA LA Y AL AEROPUERTO', 7.106035555555555, -73.18734472222222, 'Empresa dedicada a la producción y transformación del cultivo de cacao en productos artesanales como chocolate en bola y chocolate en polvo. Promueve la…', 'Empresa dedicada a la producción y transformación del cultivo de cacao en productos artesanales como chocolate en bola y chocolate en polvo. Promueve la agricultura sostenible mediante un sistema agroforestal que respeta los ciclos naturales y protege la biodiversidad, evitando el uso de pesticidas y fertilizantes químicos. Sus chocolates se elaboran con ingredientes 100% naturales, libres de aditivos, y abre sus puertas al público a través de tours de cacao que ofrecen una experiencia educativa y vivencial en torno al origen del chocolate.', 'CHOCOLATE DE MESA Y TRANSFORMACIÓN DE DERIVADOS DEL CACAO', '3002486318', '573002486318', 'paogomez09@gmail.com - losrosalescacao@gmail.com', 'DOLLY PAOLA GÓMEZ CARRASCAL', '37863116-3', 'Natural', null, 'Cámara de comercio', 'NATALY RAMIREZ', 'ACTIVO', 'Dinamizadoras', 2023, '1097 msnm', '73°11''14,441"', '7°6''21,728"', 'Actualizó', 'Se realizo visita y se aplico ficha de verificacion', 'No', 'No', 'Acueducto veredal', null, null, null, 'No', 'No', 'Sí', null, null, null, 'Sí', '2035-11-06', null, 'Sí', null, null, null, 'No', 'No', 'B2C', 'No', 'NO', 'EMPRESA QUE SE DEDICA A TRANSFORMACION DE PRODUCTOS A BASE DEL FRUTO DE CACAO CON UN ENFOQUE ORGANICO ARTESANAL , AMBIENTALMENTE SOSTENIBLE', 'La empresa cuenta con un componente social atractivo ya que en el momento de la contratación de los empleados tiene muy presente implementar el enfoque diferencial además la mayoría de sus empleados son mujeres.', 'Alto valor agregado. Diversificación de ingresos.', false, false, true, false, true
where not exists (select 1 from negocios where nombre = 'ROSANTU CACAO NIBS');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'ROSANTU CACAO NIBS');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'ROSANTU CACAO NIBS'), (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'ROSANTU CACAO NIBS');
insert into negocios_subcategorias (negocio_id, subcategoria_id) select (select id from negocios where nombre = 'ROSANTU CACAO NIBS'), id from subcategorias where slug = 'agroindustria-sostenible';
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'ROSANTU CACAO NIBS');
insert into negocios_actividades (negocio_id, actividad_productiva_id) select (select id from negocios where nombre = 'ROSANTU CACAO NIBS'), id from actividades_productivas where slug = 'agroindustrial-alimentario';
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'ROSANTU CACAO NIBS'), 2024, 79.3 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'ROSANTU CACAO NIBS'), 2025, 72.0 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;

-- ALL NATURAL
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'),
  municipio = 'Bucaramanga',
  vereda_id = (select id from veredas where municipio = 'Bucaramanga' and slug = 'perimetro-urbano'),
  direccion = 'CARRERA 33 NO 86-144 APT 1116',
  latitud = 7.098393055555555,
  longitud = -7.075537777777778,
  descripcion_corta = 'Comercializacion y distribucion de productos alimenticios orgánicos en el mercado colombiano',
  descripcion = 'Comercializacion y distribucion de productos alimenticios orgánicos en el mercado colombiano',
  producto = 'CAFÉ ESPECIAL DE ORIGEN',
  telefono = '3005663456',
  whatsapp = '573005663456',
  email = 'contacto@allnaturalcolombia.com.co',
  representante_legal = 'LEONOR RIOS LOZANO',
  nit = '901432609-7',
  naturaleza_juridica = 'Jurídica',
  delegado = null,
  rut_camara_comercio = 'Cámara de comercio y RUT',
  responsable_cdmb = 'CARINE GARCIA',
  novedad = 'SUSPENDIDO',
  tipo_negocio_verde = 'Dinamizadoras',
  anio_registro = 2023,
  cota_msnm = null,
  este = '7°04''31.936"',
  norte = '7°5''54.215"',
  aplicacion_ficha_2025 = 'Actualizó',
  observaciones = null,
  registro_nacional_turismo = null,
  uso_suelo = 'No',
  concesion_aguas = null,
  concesion_aguas_vencimiento = null,
  vertimientos = null,
  vertimientos_vencimiento = null,
  pueaa = null,
  pgris = 'Sí',
  pozo_septico = null,
  alcantarillado = null,
  ica = null,
  ica_vencimiento = null,
  invima = 'Sí',
  invima_vencimiento = '2034-07-23',
  certificado_tenencia_animales = null,
  buenas_practicas_agricolas = null,
  buenas_practicas_apicolas = null,
  registro_apicola = null,
  intervencion_cauce = null,
  capacidad_carga = null,
  sstt = null,
  canal_venta = 'B2C',
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
where nombre = 'ALL NATURAL';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select '126fde9f-9021-48df-a110-24e1079cfb37', 'ALL NATURAL', generar_slug_unico('ALL NATURAL', '126fde9f-9021-48df-a110-24e1079cfb37'), (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'), 'Bucaramanga', (select id from veredas where municipio = 'Bucaramanga' and slug = 'perimetro-urbano'), 'CARRERA 33 NO 86-144 APT 1116', 7.098393055555555, -7.075537777777778, 'Comercializacion y distribucion de productos alimenticios orgánicos en el mercado colombiano', 'Comercializacion y distribucion de productos alimenticios orgánicos en el mercado colombiano', 'CAFÉ ESPECIAL DE ORIGEN', '3005663456', '573005663456', 'contacto@allnaturalcolombia.com.co', 'LEONOR RIOS LOZANO', '901432609-7', 'Jurídica', null, 'Cámara de comercio y RUT', 'CARINE GARCIA', 'SUSPENDIDO', 'Dinamizadoras', 2023, null, '7°04''31.936"', '7°5''54.215"', 'Actualizó', null, null, 'No', null, null, null, null, null, 'Sí', null, null, null, null, 'Sí', '2034-07-23', null, null, null, null, null, null, null, 'B2C', null, null, null, null, null, true, false, false, false, false
where not exists (select 1 from negocios where nombre = 'ALL NATURAL');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'ALL NATURAL');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'ALL NATURAL'), (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'ALL NATURAL');
insert into negocios_subcategorias (negocio_id, subcategoria_id) select (select id from negocios where nombre = 'ALL NATURAL'), id from subcategorias where slug = 'agroindustria-sostenible';
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'ALL NATURAL');
insert into negocios_actividades (negocio_id, actividad_productiva_id) select (select id from negocios where nombre = 'ALL NATURAL'), id from actividades_productivas where slug = 'agroindustrial-alimentario';
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'ALL NATURAL'), 2024, 60.2 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;

-- OIL AVOCADO TONA
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'),
  municipio = 'Tona',
  vereda_id = (select id from veredas where municipio = 'Tona' and slug = 'pirgua-parte-baje'),
  direccion = 'VEREDA PIRGUA PARTE BAJA, FINCA EL NARANJO',
  latitud = null,
  longitud = null,
  descripcion_corta = 'Cultivos agroecológicos de aguacate hass y extracción del aceite extravirgen en dos presentación de 30 ml y 250 ml de manera artesanal dirigido a las…',
  descripcion = 'Cultivos agroecológicos de aguacate hass y extracción del aceite extravirgen en dos presentación de 30 ml y 250 ml de manera artesanal dirigido a las familias en general a nivel regional, comercializado de manera virtual con la marca  OIL AVOCADO TONA',
  producto = 'ACEITE DE AGUACATE EXTRAVIRGEN',
  telefono = '3007811176',
  whatsapp = '573007811176',
  email = 'marce_12-o5@hotmail.com',
  representante_legal = 'MARCELA GUTIERREZ VILLAMIZAR',
  nit = '1098746728-2',
  naturaleza_juridica = 'Natural',
  delegado = null,
  rut_camara_comercio = 'Cámara de comercio',
  responsable_cdmb = 'ANA RUEDA',
  novedad = 'ACTIVO',
  tipo_negocio_verde = 'Dinamizadoras',
  anio_registro = 2023,
  cota_msnm = '1444.1 msnm',
  este = '73°01674845',
  norte = '7°16741872',
  aplicacion_ficha_2025 = 'Actualizó',
  observaciones = 'Se realizo visita y se aplico ficha de verificacion',
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
  exportacion = 'No',
  huella_carbono = null,
  fortalezas_ambiental = 'SI, Cultivos egroecológicos de aguacate has (22 hec de conservación)
-Sistemas agroforestales, estrategias de restauración, reforestación con especies y cercas vivas.
- En los ecomercados campesinos se realizan campañas de consumo sostenible. 
-Envase de vidrio.
-No se utilizan materiales peligrosos y/o tóxicos en los procesos.
-Ficha técnica.',
  fortalezas_social = 'Generación de empleos - campesinos de la zona.
-Alianza con Cooperativa coainto de Tona. 
-En alianza con la secretaria de agricultura y JAC se incentiva  A cultivar de aguacate has en la zona.',
  fortalezas_economico = 'Tiene claro alguno de los costos y gastos de operación del negocio',
  emprendimiento_verde = true,
  sello_marca = false,
  avalado = false,
  destacado = false,
  activo = true
where nombre = 'OIL AVOCADO TONA';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select '486d5a8d-1c1b-4016-acc8-efaefa27c167', 'OIL AVOCADO TONA', generar_slug_unico('OIL AVOCADO TONA', '486d5a8d-1c1b-4016-acc8-efaefa27c167'), (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'), 'Tona', (select id from veredas where municipio = 'Tona' and slug = 'pirgua-parte-baje'), 'VEREDA PIRGUA PARTE BAJA, FINCA EL NARANJO', null, null, 'Cultivos agroecológicos de aguacate hass y extracción del aceite extravirgen en dos presentación de 30 ml y 250 ml de manera artesanal dirigido a las…', 'Cultivos agroecológicos de aguacate hass y extracción del aceite extravirgen en dos presentación de 30 ml y 250 ml de manera artesanal dirigido a las familias en general a nivel regional, comercializado de manera virtual con la marca  OIL AVOCADO TONA', 'ACEITE DE AGUACATE EXTRAVIRGEN', '3007811176', '573007811176', 'marce_12-o5@hotmail.com', 'MARCELA GUTIERREZ VILLAMIZAR', '1098746728-2', 'Natural', null, 'Cámara de comercio', 'ANA RUEDA', 'ACTIVO', 'Dinamizadoras', 2023, '1444.1 msnm', '73°01674845', '7°16741872', 'Actualizó', 'Se realizo visita y se aplico ficha de verificacion', null, 'Sí', 'Acueducto veredal', null, null, null, 'No', 'No', 'Sí', null, null, null, 'No', null, null, 'No', null, null, null, null, 'No', 'B2C', 'No', null, 'SI, Cultivos egroecológicos de aguacate has (22 hec de conservación)
-Sistemas agroforestales, estrategias de restauración, reforestación con especies y cercas vivas.
- En los ecomercados campesinos se realizan campañas de consumo sostenible. 
-Envase de vidrio.
-No se utilizan materiales peligrosos y/o tóxicos en los procesos.
-Ficha técnica.', 'Generación de empleos - campesinos de la zona.
-Alianza con Cooperativa coainto de Tona. 
-En alianza con la secretaria de agricultura y JAC se incentiva  A cultivar de aguacate has en la zona.', 'Tiene claro alguno de los costos y gastos de operación del negocio', true, false, false, false, true
where not exists (select 1 from negocios where nombre = 'OIL AVOCADO TONA');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'OIL AVOCADO TONA');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'OIL AVOCADO TONA'), (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'OIL AVOCADO TONA');
insert into negocios_subcategorias (negocio_id, subcategoria_id) select (select id from negocios where nombre = 'OIL AVOCADO TONA'), id from subcategorias where slug = 'agroindustria-sostenible';
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'OIL AVOCADO TONA');
insert into negocios_actividades (negocio_id, actividad_productiva_id) select (select id from negocios where nombre = 'OIL AVOCADO TONA'), id from actividades_productivas where slug = 'agroindustrial-alimentario';
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'OIL AVOCADO TONA'), 2024, 52.3 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'OIL AVOCADO TONA'), 2025, 57.0 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;

-- ASOCIACIÓN CAMPESINA DE PRODUCTORES AGRICOLAS DE RIONEGRO SANTANDER -VEN FUTURO
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'),
  municipio = 'Rionegro',
  vereda_id = (select id from veredas where municipio = 'Rionegro' and slug = 'la-union-de-galapagos-de-rionegro'),
  direccion = 'VEREDA LA UNION DE GALAPAGOS DE RIONEGRO',
  latitud = 7.400555555555556,
  longitud = -73.22277777777778,
  descripcion_corta = 'Transformación de cacao en chocolate de mesa, nits, trufas y mucilago comercializado con la marca chocolaterra',
  descripcion = 'Transformación de cacao en chocolate de mesa, nits, trufas y mucilago comercializado con la marca chocolaterra',
  producto = 'CHOCOLATE DE MESA',
  telefono = '3213441964',
  whatsapp = '573213441964',
  email = 'asociacionvenfuturo@gmail.com',
  representante_legal = 'ANA KATHERINE HERNANDEZ ANGARITA',
  nit = '901478168-9',
  naturaleza_juridica = 'Jurídica',
  delegado = null,
  rut_camara_comercio = 'Cámara de comercio',
  responsable_cdmb = 'ANA RUEDA',
  novedad = 'ACTIVO',
  tipo_negocio_verde = 'Dinamizadoras',
  anio_registro = 2023,
  cota_msnm = '982.5 msnm',
  este = '73°13''22"',
  norte = '7°24''2"',
  aplicacion_ficha_2025 = 'Actualizó',
  observaciones = 'Se realizo visita y se actualizo ficha de verificacion',
  registro_nacional_turismo = null,
  uso_suelo = 'No',
  concesion_aguas = 'Acueducto veredal',
  concesion_aguas_vencimiento = null,
  vertimientos = 'No',
  vertimientos_vencimiento = null,
  pueaa = 'No',
  pgris = 'No',
  pozo_septico = 'No',
  alcantarillado = null,
  ica = null,
  ica_vencimiento = null,
  invima = 'Sí',
  invima_vencimiento = '2034-05-30',
  certificado_tenencia_animales = null,
  buenas_practicas_agricolas = 'No',
  buenas_practicas_apicolas = null,
  registro_apicola = null,
  intervencion_cauce = null,
  capacidad_carga = null,
  sstt = 'No',
  canal_venta = 'B2C',
  exportacion = 'No',
  huella_carbono = null,
  fortalezas_ambiental = 'Restauración y conservación de bosques. Producción agropecuaria sostenible (Amigable con el medio ambiente). Biodiversidad. Taller en BPA',
  fortalezas_social = 'Participación comunitaria en actividades. Proyectos de responsabilidad social. Formaciones complementarias con la comunidad, institución.',
  fortalezas_economico = 'Modelo de negocio en crecimiento. econocimiento, Local, regional y nacional. Recursos tangibles importantes (Aval de confianza negocios verdes, Notificación sanitaria). Empresa legalmente registrada en Cámara de Comercio y RNT.',
  emprendimiento_verde = false,
  sello_marca = false,
  avalado = true,
  destacado = false,
  activo = true
where nombre = 'ASOCIACIÓN CAMPESINA DE PRODUCTORES AGRICOLAS DE RIONEGRO SANTANDER -VEN FUTURO';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select '06bfbe4c-db88-48a7-8bbb-074c9aa5dc8b', 'ASOCIACIÓN CAMPESINA DE PRODUCTORES AGRICOLAS DE RIONEGRO SANTANDER -VEN FUTURO', generar_slug_unico('ASOCIACIÓN CAMPESINA DE PRODUCTORES AGRICOLAS DE RIONEGRO SANTANDER -VEN FUTURO', '06bfbe4c-db88-48a7-8bbb-074c9aa5dc8b'), (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'), 'Rionegro', (select id from veredas where municipio = 'Rionegro' and slug = 'la-union-de-galapagos-de-rionegro'), 'VEREDA LA UNION DE GALAPAGOS DE RIONEGRO', 7.400555555555556, -73.22277777777778, 'Transformación de cacao en chocolate de mesa, nits, trufas y mucilago comercializado con la marca chocolaterra', 'Transformación de cacao en chocolate de mesa, nits, trufas y mucilago comercializado con la marca chocolaterra', 'CHOCOLATE DE MESA', '3213441964', '573213441964', 'asociacionvenfuturo@gmail.com', 'ANA KATHERINE HERNANDEZ ANGARITA', '901478168-9', 'Jurídica', null, 'Cámara de comercio', 'ANA RUEDA', 'ACTIVO', 'Dinamizadoras', 2023, '982.5 msnm', '73°13''22"', '7°24''2"', 'Actualizó', 'Se realizo visita y se actualizo ficha de verificacion', null, 'No', 'Acueducto veredal', null, 'No', null, 'No', 'No', 'No', null, null, null, 'Sí', '2034-05-30', null, 'No', null, null, null, null, 'No', 'B2C', 'No', null, 'Restauración y conservación de bosques. Producción agropecuaria sostenible (Amigable con el medio ambiente). Biodiversidad. Taller en BPA', 'Participación comunitaria en actividades. Proyectos de responsabilidad social. Formaciones complementarias con la comunidad, institución.', 'Modelo de negocio en crecimiento. econocimiento, Local, regional y nacional. Recursos tangibles importantes (Aval de confianza negocios verdes, Notificación sanitaria). Empresa legalmente registrada en Cámara de Comercio y RNT.', false, false, true, false, true
where not exists (select 1 from negocios where nombre = 'ASOCIACIÓN CAMPESINA DE PRODUCTORES AGRICOLAS DE RIONEGRO SANTANDER -VEN FUTURO');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'ASOCIACIÓN CAMPESINA DE PRODUCTORES AGRICOLAS DE RIONEGRO SANTANDER -VEN FUTURO');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'ASOCIACIÓN CAMPESINA DE PRODUCTORES AGRICOLAS DE RIONEGRO SANTANDER -VEN FUTURO'), (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'ASOCIACIÓN CAMPESINA DE PRODUCTORES AGRICOLAS DE RIONEGRO SANTANDER -VEN FUTURO');
insert into negocios_subcategorias (negocio_id, subcategoria_id) select (select id from negocios where nombre = 'ASOCIACIÓN CAMPESINA DE PRODUCTORES AGRICOLAS DE RIONEGRO SANTANDER -VEN FUTURO'), id from subcategorias where slug = 'agroindustria-sostenible';
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'ASOCIACIÓN CAMPESINA DE PRODUCTORES AGRICOLAS DE RIONEGRO SANTANDER -VEN FUTURO');
insert into negocios_actividades (negocio_id, actividad_productiva_id) select (select id from negocios where nombre = 'ASOCIACIÓN CAMPESINA DE PRODUCTORES AGRICOLAS DE RIONEGRO SANTANDER -VEN FUTURO'), id from actividades_productivas where slug = 'agroindustrial-alimentario';
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'ASOCIACIÓN CAMPESINA DE PRODUCTORES AGRICOLAS DE RIONEGRO SANTANDER -VEN FUTURO'), 2024, 55.6 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'ASOCIACIÓN CAMPESINA DE PRODUCTORES AGRICOLAS DE RIONEGRO SANTANDER -VEN FUTURO'), 2025, 68.8 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;

-- BISUTERIA MODA NATURAL
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'pendiente-clasificar'),
  municipio = 'Floridablanca',
  vereda_id = null,
  direccion = 'CARRERA18N # 51-20 BARRIO VILLAS',
  latitud = null,
  longitud = null,
  descripcion_corta = null,
  descripcion = null,
  producto = 'BISUTERIA',
  telefono = '3132828917',
  whatsapp = '573132828917',
  email = 'modanatural49@hotmail.com',
  representante_legal = 'CLAUDIA DÍAZ PLATA',
  nit = '37659840',
  naturaleza_juridica = null,
  delegado = null,
  rut_camara_comercio = null,
  responsable_cdmb = null,
  novedad = 'RETIRADO',
  tipo_negocio_verde = 'No aplica',
  anio_registro = 2023,
  cota_msnm = null,
  este = null,
  norte = null,
  aplicacion_ficha_2025 = null,
  observaciones = 'Ingresa al programa',
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
where nombre = 'BISUTERIA MODA NATURAL';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select '47bf810d-8b4c-42eb-978a-876113f30dd6', 'BISUTERIA MODA NATURAL', generar_slug_unico('BISUTERIA MODA NATURAL', '47bf810d-8b4c-42eb-978a-876113f30dd6'), (select id from categorias_oficiales where slug = 'pendiente-clasificar'), 'Floridablanca', null, 'CARRERA18N # 51-20 BARRIO VILLAS', null, null, null, null, 'BISUTERIA', '3132828917', '573132828917', 'modanatural49@hotmail.com', 'CLAUDIA DÍAZ PLATA', '37659840', null, null, null, null, 'RETIRADO', 'No aplica', 2023, null, null, null, null, 'Ingresa al programa', null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, true, false, false, false, false
where not exists (select 1 from negocios where nombre = 'BISUTERIA MODA NATURAL');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'BISUTERIA MODA NATURAL');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'BISUTERIA MODA NATURAL'), (select id from categorias_oficiales where slug = 'pendiente-clasificar');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'BISUTERIA MODA NATURAL');
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'BISUTERIA MODA NATURAL');

-- SAIVI LAB
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'ecoproductos-industriales'),
  municipio = 'Piedecuesta',
  vereda_id = (select id from veredas where municipio = 'Piedecuesta' and slug = 'perimetro-urbano'),
  direccion = 'CARRERA 3W NO.8N-265',
  latitud = null,
  longitud = null,
  descripcion_corta = 'Es una empresa que vende fiulamentos , hace capacitaciones y talleres a niños y jovenes en economica circular, hace impresiones en 3d con plasticos…',
  descripcion = 'Es una empresa que vende fiulamentos , hace capacitaciones y talleres a niños y jovenes en economica circular, hace impresiones en 3d con plasticos recuperados',
  producto = 'PORTA ACCESORIOS',
  telefono = '3133071729',
  whatsapp = '573133071729',
  email = 'silmarilarte@gmail.com',
  representante_legal = 'GABRIELA SÁNCHEZ JAIMES',
  nit = '37862509-1',
  naturaleza_juridica = 'Natural',
  delegado = null,
  rut_camara_comercio = 'Cámara de comercio y RUT',
  responsable_cdmb = 'CRISTAL VILLAREAL',
  novedad = 'ACTIVO',
  tipo_negocio_verde = 'Dinamizadoras',
  anio_registro = 2023,
  cota_msnm = null,
  este = null,
  norte = null,
  aplicacion_ficha_2025 = 'Actualizó',
  observaciones = null,
  registro_nacional_turismo = null,
  uso_suelo = 'No',
  concesion_aguas = 'Acueducto',
  concesion_aguas_vencimiento = null,
  vertimientos = null,
  vertimientos_vencimiento = null,
  pueaa = 'No',
  pgris = 'No',
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
  sstt = 'No',
  canal_venta = 'B2C',
  exportacion = null,
  huella_carbono = null,
  fortalezas_ambiental = 'Elabora productos a partir de plástico PET recuperado, contribuyendo a la reducción de residuos y la economía circular.
 • Promueve la reutilización y reciclaje de materiales, evitando que lleguen a vertederos o ecosistemas.
 • Propuesta con potencial de impacto ambiental positivo y conciencia ecológica.
 • Puede generar educación ambiental al mostrar el valor de transformar residuos en productos útiles.
Elabora productos a partir de plástico PET recuperado, contribuyendo a la reducción de residuos y la economía circular.
 • Promueve la reutilización y reciclaje de materiales, evitando que lleguen a vertederos o ecosistemas.
 • Propuesta con potencial de impacto ambiental positivo y conciencia ecológica.
 • Puede generar educación ambiental al mostrar el valor de transformar residuos en productos útiles.',
  fortalezas_social = 'Emprendimiento liderado por jóvenes con visión ambiental, comprometidos con la sostenibilidad.
 • Potencial de inspirar a otros emprendimientos o comunidades sobre el reciclaje y la innovación.
 • Trabajo artesanal y creativo que fomenta la cultura del aprovechamiento de residuos.
 • Capacidad de adaptarse y experimentar con nuevos diseños y materiales reciclados.',
  fortalezas_economico = 'Uso de materia prima de bajo costo (plástico recuperado).
 • Modelo productivo con alto valor agregado a partir de residuos sin valor inicial.
 • Posibilidad de desarrollar una línea de productos diferenciados y personalizados (como souvenirs o accesorios).
 • Potencial para acceder a convocatorias o fondos de emprendimiento verde.',
  emprendimiento_verde = true,
  sello_marca = false,
  avalado = false,
  destacado = false,
  activo = true
where nombre = 'SAIVI LAB';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select 'd2041c40-3e47-4372-95c6-a12ddba1a256', 'SAIVI LAB', generar_slug_unico('SAIVI LAB', 'd2041c40-3e47-4372-95c6-a12ddba1a256'), (select id from categorias_oficiales where slug = 'ecoproductos-industriales'), 'Piedecuesta', (select id from veredas where municipio = 'Piedecuesta' and slug = 'perimetro-urbano'), 'CARRERA 3W NO.8N-265', null, null, 'Es una empresa que vende fiulamentos , hace capacitaciones y talleres a niños y jovenes en economica circular, hace impresiones en 3d con plasticos…', 'Es una empresa que vende fiulamentos , hace capacitaciones y talleres a niños y jovenes en economica circular, hace impresiones en 3d con plasticos recuperados', 'PORTA ACCESORIOS', '3133071729', '573133071729', 'silmarilarte@gmail.com', 'GABRIELA SÁNCHEZ JAIMES', '37862509-1', 'Natural', null, 'Cámara de comercio y RUT', 'CRISTAL VILLAREAL', 'ACTIVO', 'Dinamizadoras', 2023, null, null, null, 'Actualizó', null, null, 'No', 'Acueducto', null, null, null, 'No', 'No', null, 'Sí', null, null, null, null, null, null, null, null, null, null, 'No', 'B2C', null, null, 'Elabora productos a partir de plástico PET recuperado, contribuyendo a la reducción de residuos y la economía circular.
 • Promueve la reutilización y reciclaje de materiales, evitando que lleguen a vertederos o ecosistemas.
 • Propuesta con potencial de impacto ambiental positivo y conciencia ecológica.
 • Puede generar educación ambiental al mostrar el valor de transformar residuos en productos útiles.
Elabora productos a partir de plástico PET recuperado, contribuyendo a la reducción de residuos y la economía circular.
 • Promueve la reutilización y reciclaje de materiales, evitando que lleguen a vertederos o ecosistemas.
 • Propuesta con potencial de impacto ambiental positivo y conciencia ecológica.
 • Puede generar educación ambiental al mostrar el valor de transformar residuos en productos útiles.', 'Emprendimiento liderado por jóvenes con visión ambiental, comprometidos con la sostenibilidad.
 • Potencial de inspirar a otros emprendimientos o comunidades sobre el reciclaje y la innovación.
 • Trabajo artesanal y creativo que fomenta la cultura del aprovechamiento de residuos.
 • Capacidad de adaptarse y experimentar con nuevos diseños y materiales reciclados.', 'Uso de materia prima de bajo costo (plástico recuperado).
 • Modelo productivo con alto valor agregado a partir de residuos sin valor inicial.
 • Posibilidad de desarrollar una línea de productos diferenciados y personalizados (como souvenirs o accesorios).
 • Potencial para acceder a convocatorias o fondos de emprendimiento verde.', true, false, false, false, true
where not exists (select 1 from negocios where nombre = 'SAIVI LAB');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'SAIVI LAB');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'SAIVI LAB'), (select id from categorias_oficiales where slug = 'ecoproductos-industriales');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'SAIVI LAB');
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'SAIVI LAB');
insert into negocios_actividades (negocio_id, actividad_productiva_id) select (select id from negocios where nombre = 'SAIVI LAB'), id from actividades_productivas where slug = 'aprovechamiento-residuos-inorganicos';
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'SAIVI LAB'), 2024, 45.1 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'SAIVI LAB'), 2025, 45.1 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;

-- BOLSOS TEJIDOS
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'pendiente-clasificar'),
  municipio = 'Bucaramanga',
  vereda_id = null,
  direccion = 'CARRERA 26A # 105-20',
  latitud = null,
  longitud = null,
  descripcion_corta = null,
  descripcion = null,
  producto = 'BOLSO EN TRAPILLO',
  telefono = '3184002226',
  whatsapp = '573184002226',
  email = 'dgdfabiana23@gmail.com',
  representante_legal = 'DEICY FABIANA GUEVARA ARDILA',
  nit = '63490034',
  naturaleza_juridica = null,
  delegado = null,
  rut_camara_comercio = null,
  responsable_cdmb = null,
  novedad = 'RETIRADO',
  tipo_negocio_verde = 'No aplica',
  anio_registro = 2023,
  cota_msnm = null,
  este = null,
  norte = null,
  aplicacion_ficha_2025 = null,
  observaciones = 'Ingresa al programa',
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
where nombre = 'BOLSOS TEJIDOS';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select '74cc7e2e-76cc-4c5f-a175-e8fff00d1072', 'BOLSOS TEJIDOS', generar_slug_unico('BOLSOS TEJIDOS', '74cc7e2e-76cc-4c5f-a175-e8fff00d1072'), (select id from categorias_oficiales where slug = 'pendiente-clasificar'), 'Bucaramanga', null, 'CARRERA 26A # 105-20', null, null, null, null, 'BOLSO EN TRAPILLO', '3184002226', '573184002226', 'dgdfabiana23@gmail.com', 'DEICY FABIANA GUEVARA ARDILA', '63490034', null, null, null, null, 'RETIRADO', 'No aplica', 2023, null, null, null, null, 'Ingresa al programa', null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, true, false, false, false, false
where not exists (select 1 from negocios where nombre = 'BOLSOS TEJIDOS');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'BOLSOS TEJIDOS');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'BOLSOS TEJIDOS'), (select id from categorias_oficiales where slug = 'pendiente-clasificar');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'BOLSOS TEJIDOS');
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'BOLSOS TEJIDOS');

-- ECOFINCA MIRADOR SAN ANTONIO S.A.S
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'),
  municipio = 'Charta',
  vereda_id = (select id from veredas where municipio = 'Charta' and slug = 'el-roble'),
  direccion = 'FINCA TAPIAS VEREDA EL ROBLE',
  latitud = 7.2707,
  longitud = -72.9668138888889,
  descripcion_corta = 'Eco- finca Mirador San Antonio fomenta el turismo ecológico en el municipio de Charta, provincia de soto Norte y páramo de Santurbán, utilizando nuestros…',
  descripcion = 'Eco- finca Mirador San Antonio fomenta el turismo ecológico en el municipio de Charta, provincia de soto Norte y páramo de Santurbán, utilizando nuestros espacios para vivir experiencias únicas en turismo de naturaleza, agricultura ecológica, hospedaje rural, glamping, restaurante, eventos educativos, sociales y corporativos, en un espacio natural que promueve el disfrute en familia de los turistas.',
  producto = 'TURISMO DE NATURALEZA',
  telefono = '3208675845',
  whatsapp = '573208675845',
  email = 'ecomiradorsanantonio@gmail.com',
  representante_legal = 'LEIDY TATIANA VILLABONA VILLAMIZAR',
  nit = '901794771-5',
  naturaleza_juridica = 'Jurídica',
  delegado = null,
  rut_camara_comercio = 'Cámara de comercio',
  responsable_cdmb = 'KAREN CAMACHO',
  novedad = 'ACTIVO',
  tipo_negocio_verde = null,
  anio_registro = 2023,
  cota_msnm = '2160 msnm',
  este = '72°58''0.53"',
  norte = '7°16''14,52"',
  aplicacion_ficha_2025 = 'Actualizó',
  observaciones = 'Se realizo visita y se aplico ficha de verificacion',
  registro_nacional_turismo = 'Sí',
  uso_suelo = 'No',
  concesion_aguas = 'No',
  concesion_aguas_vencimiento = null,
  vertimientos = null,
  vertimientos_vencimiento = null,
  pueaa = 'No',
  pgris = 'Sí',
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
  capacidad_carga = 'No',
  sstt = 'Sí',
  canal_venta = 'Mixta',
  exportacion = 'No',
  huella_carbono = 'NO',
  fortalezas_ambiental = 'Conservación de ecosistemas mediante actividades responsables. Promoción de prácticas sostenibles (reutilización, reciclaje, energías limpias). Incentivo al turismo con bajo impacto ecológico.',
  fortalezas_social = 'Generación de empleo local y fortalecimiento del tejido comunitario. Rescate y promoción de tradiciones rurales y culturales.',
  fortalezas_economico = 'Diversificación de ingresos. Alto valor agregado.',
  emprendimiento_verde = false,
  sello_marca = true,
  avalado = true,
  destacado = false,
  activo = true
where nombre = 'ECOFINCA MIRADOR SAN ANTONIO S.A.S';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select '447e3462-3ff2-4127-b594-8a4ad3ce022b', 'ECOFINCA MIRADOR SAN ANTONIO S.A.S', generar_slug_unico('ECOFINCA MIRADOR SAN ANTONIO S.A.S', '447e3462-3ff2-4127-b594-8a4ad3ce022b'), (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'), 'Charta', (select id from veredas where municipio = 'Charta' and slug = 'el-roble'), 'FINCA TAPIAS VEREDA EL ROBLE', 7.2707, -72.9668138888889, 'Eco- finca Mirador San Antonio fomenta el turismo ecológico en el municipio de Charta, provincia de soto Norte y páramo de Santurbán, utilizando nuestros…', 'Eco- finca Mirador San Antonio fomenta el turismo ecológico en el municipio de Charta, provincia de soto Norte y páramo de Santurbán, utilizando nuestros espacios para vivir experiencias únicas en turismo de naturaleza, agricultura ecológica, hospedaje rural, glamping, restaurante, eventos educativos, sociales y corporativos, en un espacio natural que promueve el disfrute en familia de los turistas.', 'TURISMO DE NATURALEZA', '3208675845', '573208675845', 'ecomiradorsanantonio@gmail.com', 'LEIDY TATIANA VILLABONA VILLAMIZAR', '901794771-5', 'Jurídica', null, 'Cámara de comercio', 'KAREN CAMACHO', 'ACTIVO', null, 2023, '2160 msnm', '72°58''0.53"', '7°16''14,52"', 'Actualizó', 'Se realizo visita y se aplico ficha de verificacion', 'Sí', 'No', 'No', null, null, null, 'No', 'Sí', 'Sí', null, null, null, null, null, null, null, null, null, null, 'No', 'Sí', 'Mixta', 'No', 'NO', 'Conservación de ecosistemas mediante actividades responsables. Promoción de prácticas sostenibles (reutilización, reciclaje, energías limpias). Incentivo al turismo con bajo impacto ecológico.', 'Generación de empleo local y fortalecimiento del tejido comunitario. Rescate y promoción de tradiciones rurales y culturales.', 'Diversificación de ingresos. Alto valor agregado.', false, true, true, false, true
where not exists (select 1 from negocios where nombre = 'ECOFINCA MIRADOR SAN ANTONIO S.A.S');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'ECOFINCA MIRADOR SAN ANTONIO S.A.S');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'ECOFINCA MIRADOR SAN ANTONIO S.A.S'), (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'ECOFINCA MIRADOR SAN ANTONIO S.A.S');
insert into negocios_subcategorias (negocio_id, subcategoria_id) select (select id from negocios where nombre = 'ECOFINCA MIRADOR SAN ANTONIO S.A.S'), id from subcategorias where slug = 'turismo-sostenible';
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'ECOFINCA MIRADOR SAN ANTONIO S.A.S');
insert into negocios_actividades (negocio_id, actividad_productiva_id) select (select id from negocios where nombre = 'ECOFINCA MIRADOR SAN ANTONIO S.A.S'), id from actividades_productivas where slug = 'servicios-turismo-naturaleza';
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'ECOFINCA MIRADOR SAN ANTONIO S.A.S'), 2024, 79.1 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'ECOFINCA MIRADOR SAN ANTONIO S.A.S'), 2025, 82.4 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;

-- LAGUNAS NEGRAS
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'pendiente-clasificar'),
  municipio = 'Vetas',
  vereda_id = null,
  direccion = 'FINCA LAGUNAS NEGRAS VEREDA ORTEGON',
  latitud = 7.283283333333333,
  longitud = -72.89498888888889,
  descripcion_corta = null,
  descripcion = null,
  producto = 'ECOTURISMO',
  telefono = '3142596205 - 3222827729',
  whatsapp = '3142596205 - 3222827729',
  email = 'lizetvivianat@gmail.com',
  representante_legal = 'NEFTALY RAMIREZ - MONICA BAUTISTA SANTANDER',
  nit = null,
  naturaleza_juridica = null,
  delegado = null,
  rut_camara_comercio = null,
  responsable_cdmb = 'ANDRES VALDERRAMA',
  novedad = 'RETIRADO',
  tipo_negocio_verde = 'Inicial',
  anio_registro = 2023,
  cota_msnm = '3682 msnm',
  este = '72°53''41,96"',
  norte = '7°16''59,82"',
  aplicacion_ficha_2025 = null,
  observaciones = 'Ingresa al programa',
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
where nombre = 'LAGUNAS NEGRAS';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select 'c41a9851-5c65-446a-90fd-bc04eae84037', 'LAGUNAS NEGRAS', generar_slug_unico('LAGUNAS NEGRAS', 'c41a9851-5c65-446a-90fd-bc04eae84037'), (select id from categorias_oficiales where slug = 'pendiente-clasificar'), 'Vetas', null, 'FINCA LAGUNAS NEGRAS VEREDA ORTEGON', 7.283283333333333, -72.89498888888889, null, null, 'ECOTURISMO', '3142596205 - 3222827729', '3142596205 - 3222827729', 'lizetvivianat@gmail.com', 'NEFTALY RAMIREZ - MONICA BAUTISTA SANTANDER', null, null, null, null, 'ANDRES VALDERRAMA', 'RETIRADO', 'Inicial', 2023, '3682 msnm', '72°53''41,96"', '7°16''59,82"', null, 'Ingresa al programa', null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, true, false, false, false, false
where not exists (select 1 from negocios where nombre = 'LAGUNAS NEGRAS');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'LAGUNAS NEGRAS');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'LAGUNAS NEGRAS'), (select id from categorias_oficiales where slug = 'pendiente-clasificar');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'LAGUNAS NEGRAS');
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'LAGUNAS NEGRAS');

-- GLAMPING CASA DEL SOL
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'),
  municipio = 'Lebrija',
  vereda_id = (select id from veredas where municipio = 'Lebrija' and slug = 'altos-de-palonegro'),
  direccion = 'FINCA JERUSALEN VEREDA ALTOS DE
PALONEGRO',
  latitud = 7.122593888888889,
  longitud = -73.187055,
  descripcion_corta = 'Servicio de alojamiento rural  y restaurante ecoturismo',
  descripcion = 'Servicio de alojamiento rural  y restaurante ecoturismo',
  producto = 'HOTEL ECOTURISMO',
  telefono = '3182352711',
  whatsapp = '573182352711',
  email = 'matiscastro16@hotmail.com',
  representante_legal = 'MARTHA MARIA CASTRO MARTINEZ',
  nit = '63275775-9',
  naturaleza_juridica = 'Natural',
  delegado = 'JAIME GONZALES LEON',
  rut_camara_comercio = 'Cámara de comercio',
  responsable_cdmb = 'DIEGO GUTIERREZ',
  novedad = 'ACTIVO',
  tipo_negocio_verde = 'Dinamizadoras',
  anio_registro = 2023,
  cota_msnm = null,
  este = '73°11''13,398"',
  norte = '7°7''21,338"',
  aplicacion_ficha_2025 = 'Actualizó',
  observaciones = 'Se realizo visita y se aplico ficha de verificacion',
  registro_nacional_turismo = 'Sí',
  uso_suelo = 'No',
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
  invima = null,
  invima_vencimiento = null,
  certificado_tenencia_animales = null,
  buenas_practicas_agricolas = null,
  buenas_practicas_apicolas = null,
  registro_apicola = null,
  intervencion_cauce = null,
  capacidad_carga = 'No',
  sstt = 'No',
  canal_venta = 'Mixta',
  exportacion = 'No',
  huella_carbono = 'NO',
  fortalezas_ambiental = 'Conservación activa del entorno mediante recorridos guiados. Sensibilización ecológica que puede inspirar cambios en hábitos de los visitantes.',
  fortalezas_social = 'Promoción de la identidad cultural a través de la música y la educación. Fomento del conocimiento ambiental y cultural entre los visitantes.',
  fortalezas_economico = 'La empresa cuenta con un componente económico solido es una empresa muy bien organizada y con unos objetivos de crecimiento muy altos , actualmente tiene 9 glamping con naturaleza a su alrededor.',
  emprendimiento_verde = true,
  sello_marca = false,
  avalado = false,
  destacado = false,
  activo = true
where nombre = 'GLAMPING CASA DEL SOL';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select '0a40f2c3-0543-4294-a94e-2cd423edb3ad', 'GLAMPING CASA DEL SOL', generar_slug_unico('GLAMPING CASA DEL SOL', '0a40f2c3-0543-4294-a94e-2cd423edb3ad'), (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'), 'Lebrija', (select id from veredas where municipio = 'Lebrija' and slug = 'altos-de-palonegro'), 'FINCA JERUSALEN VEREDA ALTOS DE
PALONEGRO', 7.122593888888889, -73.187055, 'Servicio de alojamiento rural  y restaurante ecoturismo', 'Servicio de alojamiento rural  y restaurante ecoturismo', 'HOTEL ECOTURISMO', '3182352711', '573182352711', 'matiscastro16@hotmail.com', 'MARTHA MARIA CASTRO MARTINEZ', '63275775-9', 'Natural', 'JAIME GONZALES LEON', 'Cámara de comercio', 'DIEGO GUTIERREZ', 'ACTIVO', 'Dinamizadoras', 2023, null, '73°11''13,398"', '7°7''21,338"', 'Actualizó', 'Se realizo visita y se aplico ficha de verificacion', 'Sí', 'No', 'No', null, null, null, 'No', 'No', 'Sí', null, null, null, null, null, null, null, null, null, null, 'No', 'No', 'Mixta', 'No', 'NO', 'Conservación activa del entorno mediante recorridos guiados. Sensibilización ecológica que puede inspirar cambios en hábitos de los visitantes.', 'Promoción de la identidad cultural a través de la música y la educación. Fomento del conocimiento ambiental y cultural entre los visitantes.', 'La empresa cuenta con un componente económico solido es una empresa muy bien organizada y con unos objetivos de crecimiento muy altos , actualmente tiene 9 glamping con naturaleza a su alrededor.', true, false, false, false, true
where not exists (select 1 from negocios where nombre = 'GLAMPING CASA DEL SOL');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'GLAMPING CASA DEL SOL');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'GLAMPING CASA DEL SOL'), (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'GLAMPING CASA DEL SOL');
insert into negocios_subcategorias (negocio_id, subcategoria_id) select (select id from negocios where nombre = 'GLAMPING CASA DEL SOL'), id from subcategorias where slug = 'turismo-sostenible';
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'GLAMPING CASA DEL SOL');
insert into negocios_actividades (negocio_id, actividad_productiva_id) select (select id from negocios where nombre = 'GLAMPING CASA DEL SOL'), id from actividades_productivas where slug = 'servicios-turismo-naturaleza';
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'GLAMPING CASA DEL SOL'), 2024, 60.2 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'GLAMPING CASA DEL SOL'), 2025, 67.3 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;

-- CHOCOLATE RENACER
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'),
  municipio = 'Rionegro',
  vereda_id = (select id from veredas where municipio = 'Rionegro' and slug = 'san-jose-arevalo'),
  direccion = 'VEREDA SAN JOSE AREVALO FINCA LA TACHUELA',
  latitud = 6.984166666666667,
  longitud = -73.16833333333334,
  descripcion_corta = 'Cultivo, transformación y comercialización de cacao.',
  descripcion = 'Cultivo, transformación y comercialización de cacao.',
  producto = 'CHOCOLATE DE MESA CON AZÚCAR Y SIN AZUCAR',
  telefono = '3163340263',
  whatsapp = '573163340263',
  email = 'guiareyes@hotmail.com',
  representante_legal = 'GUILLERMO ALBERTO REYES JIMENEZ',
  nit = '900989390-7',
  naturaleza_juridica = 'Jurídica',
  delegado = null,
  rut_camara_comercio = 'Cámara de comercio',
  responsable_cdmb = 'SILVIA VALDIVIESO',
  novedad = 'ACTIVO',
  tipo_negocio_verde = null,
  anio_registro = 2023,
  cota_msnm = '826 msnm',
  este = '73°10''6''''',
  norte = '6°59''3''''',
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
  invima_vencimiento = '2027-07-17',
  certificado_tenencia_animales = null,
  buenas_practicas_agricolas = 'No',
  buenas_practicas_apicolas = null,
  registro_apicola = null,
  intervencion_cauce = null,
  capacidad_carga = null,
  sstt = 'No',
  canal_venta = 'Mixta',
  exportacion = 'No',
  huella_carbono = 'NO',
  fortalezas_ambiental = 'Cultivo de manejo Agroecológico con sistema agroforestal. Buenas prácticas hídricas (uso de aguas lluvias).',
  fortalezas_social = 'Trabajo asociativo, inclusión laboral (campesinos y reinsertados).',
  fortalezas_economico = 'Diversificación de productos',
  emprendimiento_verde = true,
  sello_marca = false,
  avalado = false,
  destacado = false,
  activo = true
where nombre = 'CHOCOLATE RENACER';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select '045b7145-4c57-427a-aec8-979ebda89213', 'CHOCOLATE RENACER', generar_slug_unico('CHOCOLATE RENACER', '045b7145-4c57-427a-aec8-979ebda89213'), (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'), 'Rionegro', (select id from veredas where municipio = 'Rionegro' and slug = 'san-jose-arevalo'), 'VEREDA SAN JOSE AREVALO FINCA LA TACHUELA', 6.984166666666667, -73.16833333333334, 'Cultivo, transformación y comercialización de cacao.', 'Cultivo, transformación y comercialización de cacao.', 'CHOCOLATE DE MESA CON AZÚCAR Y SIN AZUCAR', '3163340263', '573163340263', 'guiareyes@hotmail.com', 'GUILLERMO ALBERTO REYES JIMENEZ', '900989390-7', 'Jurídica', null, 'Cámara de comercio', 'SILVIA VALDIVIESO', 'ACTIVO', null, 2023, '826 msnm', '73°10''6''''', '6°59''3''''', 'Actualizó', 'Se realizo visita y se aplico ficha de verificacion', null, 'Sí', 'No', null, null, null, 'No', 'No', 'Sí', null, null, null, 'Sí', '2027-07-17', null, 'No', null, null, null, null, 'No', 'Mixta', 'No', 'NO', 'Cultivo de manejo Agroecológico con sistema agroforestal. Buenas prácticas hídricas (uso de aguas lluvias).', 'Trabajo asociativo, inclusión laboral (campesinos y reinsertados).', 'Diversificación de productos', true, false, false, false, true
where not exists (select 1 from negocios where nombre = 'CHOCOLATE RENACER');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'CHOCOLATE RENACER');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'CHOCOLATE RENACER'), (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'CHOCOLATE RENACER');
insert into negocios_subcategorias (negocio_id, subcategoria_id) select (select id from negocios where nombre = 'CHOCOLATE RENACER'), id from subcategorias where slug = 'agroindustria-sostenible';
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'CHOCOLATE RENACER');
insert into negocios_actividades (negocio_id, actividad_productiva_id) select (select id from negocios where nombre = 'CHOCOLATE RENACER'), id from actividades_productivas where slug = 'agroindustrial-alimentario';
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'CHOCOLATE RENACER'), 2024, 55.4 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'CHOCOLATE RENACER'), 2025, 55.6 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;

-- GALERIA EL LEGADO
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'pendiente-clasificar'),
  municipio = 'California',
  vereda_id = null,
  direccion = 'CARRERA 6 # 3-22',
  latitud = null,
  longitud = null,
  descripcion_corta = null,
  descripcion = null,
  producto = 'ARTESANIAS',
  telefono = '3163116896 - 3204945779',
  whatsapp = '3163116896 - 3204945779',
  email = null,
  representante_legal = 'SONIA GELVES - LUCY ROJAS',
  nit = null,
  naturaleza_juridica = null,
  delegado = null,
  rut_camara_comercio = null,
  responsable_cdmb = 'DANIEL BONNET',
  novedad = 'INACTIVO',
  tipo_negocio_verde = 'Inicial',
  anio_registro = 2023,
  cota_msnm = null,
  este = null,
  norte = null,
  aplicacion_ficha_2025 = null,
  observaciones = 'Ingresa al programa',
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
where nombre = 'GALERIA EL LEGADO';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select '2f30ba27-6fac-4fef-94e0-c197ec85c144', 'GALERIA EL LEGADO', generar_slug_unico('GALERIA EL LEGADO', '2f30ba27-6fac-4fef-94e0-c197ec85c144'), (select id from categorias_oficiales where slug = 'pendiente-clasificar'), 'California', null, 'CARRERA 6 # 3-22', null, null, null, null, 'ARTESANIAS', '3163116896 - 3204945779', '3163116896 - 3204945779', null, 'SONIA GELVES - LUCY ROJAS', null, null, null, null, 'DANIEL BONNET', 'INACTIVO', 'Inicial', 2023, null, null, null, null, 'Ingresa al programa', null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, true, false, false, false, false
where not exists (select 1 from negocios where nombre = 'GALERIA EL LEGADO');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'GALERIA EL LEGADO');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'GALERIA EL LEGADO'), (select id from categorias_oficiales where slug = 'pendiente-clasificar');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'GALERIA EL LEGADO');
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'GALERIA EL LEGADO');


commit;
