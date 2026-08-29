begin;

-- Generado por lib/migraciones/generar_0026.py desde BASE_ACTUALIZADA_NV_ka.xlsx — no editar a mano.
-- Uno de varios archivos partidos (ver README.md) — correr TODOS, en cualquier orden, cada uno es su propia transacción.

-- Parte 8 de 17.

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

-- OCAROMA S.A.S.
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'),
  municipio = 'El Playón',
  vereda_id = (select id from veredas where municipio = 'El Playón' and slug = 'san-pedro-de-la-tigra'),
  direccion = 'CARRERA 23 57-160 EL BOSQUE VILLAS DE MEDITERRANEO',
  latitud = 7.086872222222222,
  longitud = -73.12090277777777,
  descripcion_corta = 'Trabajo de cultivo de cacao con manejo agroecologico, ubicada en el municipio del playon santander, cuenta con terreno propio con 8 hectarias de cultivo de…',
  descripcion = 'Trabajo de cultivo de cacao con manejo agroecologico, ubicada en el municipio del playon santander, cuenta con terreno propio con 8 hectarias de cultivo de cacao, que es trabajada por la señora Betsi y dos colaboradores de la finca. De donde se proveen de la materia prima para la produccion de chocolateria. Su proceso de produccion y comercializacion se realiza en la ciudad de Bucaramanga.',
  producto = 'CHOCOLATINA EN TABLETA',
  telefono = '3152605352',
  whatsapp = '573152605352',
  email = 'ocaromachocolateria@gmail.com',
  representante_legal = 'BETSI RUEDA CARVAJAL',
  nit = '901638240-9',
  naturaleza_juridica = 'Jurídica',
  delegado = null,
  rut_camara_comercio = 'Cámara de comercio',
  responsable_cdmb = 'XIMENA REYES',
  novedad = 'ACTIVO',
  tipo_negocio_verde = 'Satisfactorio',
  anio_registro = 2022,
  cota_msnm = '899 msnm',
  este = '73°7''15,25''''',
  norte = '7°5''12,74''''',
  aplicacion_ficha_2025 = 'Actualizó',
  observaciones = 'Se realizo visita y se actualizo ficha de verificacion',
  registro_nacional_turismo = null,
  uso_suelo = 'Sí',
  concesion_aguas = 'Sí',
  concesion_aguas_vencimiento = '2027-09-06',
  vertimientos = null,
  vertimientos_vencimiento = null,
  pueaa = 'No',
  pgris = 'No',
  pozo_septico = 'Sí',
  alcantarillado = null,
  ica = null,
  ica_vencimiento = null,
  invima = 'Sí',
  invima_vencimiento = '2032-11-23',
  certificado_tenencia_animales = null,
  buenas_practicas_agricolas = 'Sí',
  buenas_practicas_apicolas = null,
  registro_apicola = null,
  intervencion_cauce = null,
  capacidad_carga = null,
  sstt = 'No',
  canal_venta = 'Mixta',
  exportacion = 'No',
  huella_carbono = 'NO',
  fortalezas_ambiental = 'Se implementan acciones para combatir el cambio climático y sus impactos. Sustituye los empaques y emablajes convencionales por biodegradables de baja carga contaminante. No utlizan materiales peligrosos ni tóxicos en el proceso. No realiza vertimientos',
  fortalezas_social = 'Contratación con enfoque diferencial. Realiza campañas donde promueve el consumo consciente y economía circular.',
  fortalezas_economico = 'Cuenta con estados financieros.',
  emprendimiento_verde = false,
  sello_marca = false,
  avalado = true,
  destacado = false,
  activo = true
where nombre = 'OCAROMA S.A.S.';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select '684aaacd-61b7-4420-9764-d44570502e87', 'OCAROMA S.A.S.', generar_slug_unico('OCAROMA S.A.S.', '684aaacd-61b7-4420-9764-d44570502e87'), (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'), 'El Playón', (select id from veredas where municipio = 'El Playón' and slug = 'san-pedro-de-la-tigra'), 'CARRERA 23 57-160 EL BOSQUE VILLAS DE MEDITERRANEO', 7.086872222222222, -73.12090277777777, 'Trabajo de cultivo de cacao con manejo agroecologico, ubicada en el municipio del playon santander, cuenta con terreno propio con 8 hectarias de cultivo de…', 'Trabajo de cultivo de cacao con manejo agroecologico, ubicada en el municipio del playon santander, cuenta con terreno propio con 8 hectarias de cultivo de cacao, que es trabajada por la señora Betsi y dos colaboradores de la finca. De donde se proveen de la materia prima para la produccion de chocolateria. Su proceso de produccion y comercializacion se realiza en la ciudad de Bucaramanga.', 'CHOCOLATINA EN TABLETA', '3152605352', '573152605352', 'ocaromachocolateria@gmail.com', 'BETSI RUEDA CARVAJAL', '901638240-9', 'Jurídica', null, 'Cámara de comercio', 'XIMENA REYES', 'ACTIVO', 'Satisfactorio', 2022, '899 msnm', '73°7''15,25''''', '7°5''12,74''''', 'Actualizó', 'Se realizo visita y se actualizo ficha de verificacion', null, 'Sí', 'Sí', '2027-09-06', null, null, 'No', 'No', 'Sí', null, null, null, 'Sí', '2032-11-23', null, 'Sí', null, null, null, null, 'No', 'Mixta', 'No', 'NO', 'Se implementan acciones para combatir el cambio climático y sus impactos. Sustituye los empaques y emablajes convencionales por biodegradables de baja carga contaminante. No utlizan materiales peligrosos ni tóxicos en el proceso. No realiza vertimientos', 'Contratación con enfoque diferencial. Realiza campañas donde promueve el consumo consciente y economía circular.', 'Cuenta con estados financieros.', false, false, true, false, true
where not exists (select 1 from negocios where nombre = 'OCAROMA S.A.S.');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'OCAROMA S.A.S.');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'OCAROMA S.A.S.'), (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'OCAROMA S.A.S.');
insert into negocios_subcategorias (negocio_id, subcategoria_id) select (select id from negocios where nombre = 'OCAROMA S.A.S.'), id from subcategorias where slug = 'agroindustria-sostenible';
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'OCAROMA S.A.S.');
insert into negocios_actividades (negocio_id, actividad_productiva_id) select (select id from negocios where nombre = 'OCAROMA S.A.S.'), id from actividades_productivas where slug = 'agroindustrial-alimentario';
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'OCAROMA S.A.S.'), 2023, 44.43 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'OCAROMA S.A.S.'), 2024, 64.0 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'OCAROMA S.A.S.'), 2025, 58.7 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;

-- ESPONJADOS CON AMOR ARTESANAL
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'),
  municipio = 'Piedecuesta',
  vereda_id = null,
  direccion = 'CLL 1A N 3-57 PALERMO 1 PIEDECUESTA',
  latitud = null,
  longitud = null,
  descripcion_corta = null,
  descripcion = null,
  producto = 'ESPONJADOS TRADICIONALES',
  telefono = '3156235416',
  whatsapp = '573156235416',
  email = 'Sandra.gomez1011@hotmail.com',
  representante_legal = 'SANDRA MILENA GOMEZ RIVERO',
  nit = null,
  naturaleza_juridica = null,
  delegado = null,
  rut_camara_comercio = null,
  responsable_cdmb = 'SUJEY DÍAZ',
  novedad = 'RETIRADO',
  tipo_negocio_verde = 'Inicial',
  anio_registro = 2022,
  cota_msnm = null,
  este = null,
  norte = null,
  aplicacion_ficha_2025 = 'No actualizó',
  observaciones = 'No se realizo visita ni actualizo ficha de verificacion',
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
where nombre = 'ESPONJADOS CON AMOR ARTESANAL';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select '3e220a5b-b9aa-48b2-a57e-643299654884', 'ESPONJADOS CON AMOR ARTESANAL', generar_slug_unico('ESPONJADOS CON AMOR ARTESANAL', '3e220a5b-b9aa-48b2-a57e-643299654884'), (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'), 'Piedecuesta', null, 'CLL 1A N 3-57 PALERMO 1 PIEDECUESTA', null, null, null, null, 'ESPONJADOS TRADICIONALES', '3156235416', '573156235416', 'Sandra.gomez1011@hotmail.com', 'SANDRA MILENA GOMEZ RIVERO', null, null, null, null, 'SUJEY DÍAZ', 'RETIRADO', 'Inicial', 2022, null, null, null, 'No actualizó', 'No se realizo visita ni actualizo ficha de verificacion', null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, true, false, false, false, false
where not exists (select 1 from negocios where nombre = 'ESPONJADOS CON AMOR ARTESANAL');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'ESPONJADOS CON AMOR ARTESANAL');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'ESPONJADOS CON AMOR ARTESANAL'), (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'ESPONJADOS CON AMOR ARTESANAL');
insert into negocios_subcategorias (negocio_id, subcategoria_id) select (select id from negocios where nombre = 'ESPONJADOS CON AMOR ARTESANAL'), id from subcategorias where slug = 'agroindustria-sostenible';
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'ESPONJADOS CON AMOR ARTESANAL');
insert into negocios_actividades (negocio_id, actividad_productiva_id) select (select id from negocios where nombre = 'ESPONJADOS CON AMOR ARTESANAL'), id from actividades_productivas where slug = 'agroindustrial-no-alimentario';

-- NUSCAA
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'),
  municipio = 'Piedecuesta',
  vereda_id = (select id from veredas where municipio = 'Piedecuesta' and slug = 'la-esperanza'),
  direccion = 'FINCA CANAGUAY VEREDA LA ESPERANZA',
  latitud = 7.017814722222222,
  longitud = -73.10467277777778,
  descripcion_corta = 'Transformación y comercialización de cosméticos capilares y faciales a base de plantas, hortalizas, semillas y frutas.',
  descripcion = 'Transformación y comercialización de cosméticos capilares y faciales a base de plantas, hortalizas, semillas y frutas.',
  producto = 'COSMETICOS NATURALES',
  telefono = '3057728711 - 3003727497',
  whatsapp = '3057728711 - 3003727497',
  email = 'estefanygomez01@hotmail.com',
  representante_legal = 'KELLY STEFANY GODOY ABRIL',
  nit = '1098698604-1',
  naturaleza_juridica = 'Natural',
  delegado = null,
  rut_camara_comercio = 'Cámara de comercio',
  responsable_cdmb = 'DIEGO GUTIERREZ',
  novedad = 'ACTIVO',
  tipo_negocio_verde = 'Avanzado',
  anio_registro = 2022,
  cota_msnm = '1056 msnm',
  este = '73°6''16.822''''',
  norte = '7°1''4,133''''',
  aplicacion_ficha_2025 = 'Actualizó',
  observaciones = 'Se realizo visita y se actualizo ficha de verificacion',
  registro_nacional_turismo = null,
  uso_suelo = 'No',
  concesion_aguas = 'Acueducto veredal',
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
  exportacion = 'No',
  huella_carbono = 'NO',
  fortalezas_ambiental = 'Productos orgánicos libre de químicos',
  fortalezas_social = 'Apoyo al campesinado y vinculación con fundaciones y escuelas',
  fortalezas_economico = 'Buena oferta económica',
  emprendimiento_verde = true,
  sello_marca = false,
  avalado = false,
  destacado = false,
  activo = true
where nombre = 'NUSCAA';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select '25821b86-0b7f-460f-b57b-3d3edaa25ca9', 'NUSCAA', generar_slug_unico('NUSCAA', '25821b86-0b7f-460f-b57b-3d3edaa25ca9'), (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'), 'Piedecuesta', (select id from veredas where municipio = 'Piedecuesta' and slug = 'la-esperanza'), 'FINCA CANAGUAY VEREDA LA ESPERANZA', 7.017814722222222, -73.10467277777778, 'Transformación y comercialización de cosméticos capilares y faciales a base de plantas, hortalizas, semillas y frutas.', 'Transformación y comercialización de cosméticos capilares y faciales a base de plantas, hortalizas, semillas y frutas.', 'COSMETICOS NATURALES', '3057728711 - 3003727497', '3057728711 - 3003727497', 'estefanygomez01@hotmail.com', 'KELLY STEFANY GODOY ABRIL', '1098698604-1', 'Natural', null, 'Cámara de comercio', 'DIEGO GUTIERREZ', 'ACTIVO', 'Avanzado', 2022, '1056 msnm', '73°6''16.822''''', '7°1''4,133''''', 'Actualizó', 'Se realizo visita y se actualizo ficha de verificacion', null, 'No', 'Acueducto veredal', null, null, null, 'No', 'No', null, 'Sí', null, null, 'No', null, null, null, null, null, null, null, 'No', 'B2C', 'No', 'NO', 'Productos orgánicos libre de químicos', 'Apoyo al campesinado y vinculación con fundaciones y escuelas', 'Buena oferta económica', true, false, false, false, true
where not exists (select 1 from negocios where nombre = 'NUSCAA');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'NUSCAA');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'NUSCAA'), (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'NUSCAA');
insert into negocios_subcategorias (negocio_id, subcategoria_id) select (select id from negocios where nombre = 'NUSCAA'), id from subcategorias where slug = 'agroindustria-sostenible';
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'NUSCAA');
insert into negocios_actividades (negocio_id, actividad_productiva_id) select (select id from negocios where nombre = 'NUSCAA'), id from actividades_productivas where slug = 'agroindustrial-no-alimentario';
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'NUSCAA'), 2023, 36.86 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'NUSCAA'), 2024, 88.4 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'NUSCAA'), 2025, 87.1 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;

-- JUAN PABLO VERA CALDERON
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'pendiente-clasificar'),
  municipio = 'Girón',
  vereda_id = null,
  direccion = null,
  latitud = null,
  longitud = null,
  descripcion_corta = null,
  descripcion = null,
  producto = null,
  telefono = '3176712133',
  whatsapp = '573176712133',
  email = 'jpcoordinador2016@gmail.com',
  representante_legal = null,
  nit = null,
  naturaleza_juridica = null,
  delegado = null,
  rut_camara_comercio = null,
  responsable_cdmb = null,
  novedad = 'RETIRADO',
  tipo_negocio_verde = 'No aplica',
  anio_registro = 2022,
  cota_msnm = null,
  este = null,
  norte = null,
  aplicacion_ficha_2025 = null,
  observaciones = 'No cumplimiento de requisitos',
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
where nombre = 'JUAN PABLO VERA CALDERON';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select 'bdf63025-b80c-4ad4-ac6f-738cacb283d8', 'JUAN PABLO VERA CALDERON', generar_slug_unico('JUAN PABLO VERA CALDERON', 'bdf63025-b80c-4ad4-ac6f-738cacb283d8'), (select id from categorias_oficiales where slug = 'pendiente-clasificar'), 'Girón', null, null, null, null, null, null, null, '3176712133', '573176712133', 'jpcoordinador2016@gmail.com', null, null, null, null, null, null, 'RETIRADO', 'No aplica', 2022, null, null, null, null, 'No cumplimiento de requisitos', null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, true, false, false, false, false
where not exists (select 1 from negocios where nombre = 'JUAN PABLO VERA CALDERON');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'JUAN PABLO VERA CALDERON');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'JUAN PABLO VERA CALDERON'), (select id from categorias_oficiales where slug = 'pendiente-clasificar');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'JUAN PABLO VERA CALDERON');
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'JUAN PABLO VERA CALDERON');

-- FINCA LOS ROSALES
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'),
  municipio = 'Lebrija',
  vereda_id = (select id from veredas where municipio = 'Lebrija' and slug = 'san-nicolas-bajo'),
  direccion = 'VEREDA SAN NICOLAS BAJO, FINCA LOS ROSALES',
  latitud = null,
  longitud = null,
  descripcion_corta = 'Plantación forestal y autorenovable de bambu arquitectonico y alistamiento de manera artesanal, dirigido al mercado verde a nivel nacional',
  descripcion = 'Plantación forestal y autorenovable de bambu arquitectonico y alistamiento de manera artesanal, dirigido al mercado verde a nivel nacional',
  producto = 'PLANTACIÓN FORESTAL DE BAMBU REF #2 - FINCA LOS ROSALES',
  telefono = '3203339863',
  whatsapp = '573203339863',
  email = 'hmdmarulanda@gmail.com',
  representante_legal = 'HELGA MARÍA DIAZ BELTRAN',
  nit = '37815287',
  naturaleza_juridica = null,
  delegado = null,
  rut_camara_comercio = 'RUT',
  responsable_cdmb = 'ANDRES VALDERRAMA',
  novedad = 'ACTIVO',
  tipo_negocio_verde = 'Dinamizadoras',
  anio_registro = 2022,
  cota_msnm = '1175.3 msnm',
  este = '73°243507',
  norte = '7°12188072',
  aplicacion_ficha_2025 = 'No actualizó',
  observaciones = 'No se realizo visita ni actualizo ficha de verificacion',
  registro_nacional_turismo = null,
  uso_suelo = 'No',
  concesion_aguas = 'Acueducto veredal',
  concesion_aguas_vencimiento = null,
  vertimientos = null,
  vertimientos_vencimiento = null,
  pueaa = 'No',
  pgris = 'No',
  pozo_septico = 'Sí',
  alcantarillado = 'No',
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
  fortalezas_ambiental = null,
  fortalezas_social = null,
  fortalezas_economico = null,
  emprendimiento_verde = true,
  sello_marca = false,
  avalado = false,
  destacado = false,
  activo = true
where nombre = 'FINCA LOS ROSALES';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select '9297a4b5-f082-43b4-b722-05f8ff72c663', 'FINCA LOS ROSALES', generar_slug_unico('FINCA LOS ROSALES', '9297a4b5-f082-43b4-b722-05f8ff72c663'), (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'), 'Lebrija', (select id from veredas where municipio = 'Lebrija' and slug = 'san-nicolas-bajo'), 'VEREDA SAN NICOLAS BAJO, FINCA LOS ROSALES', null, null, 'Plantación forestal y autorenovable de bambu arquitectonico y alistamiento de manera artesanal, dirigido al mercado verde a nivel nacional', 'Plantación forestal y autorenovable de bambu arquitectonico y alistamiento de manera artesanal, dirigido al mercado verde a nivel nacional', 'PLANTACIÓN FORESTAL DE BAMBU REF #2 - FINCA LOS ROSALES', '3203339863', '573203339863', 'hmdmarulanda@gmail.com', 'HELGA MARÍA DIAZ BELTRAN', '37815287', null, null, 'RUT', 'ANDRES VALDERRAMA', 'ACTIVO', 'Dinamizadoras', 2022, '1175.3 msnm', '73°243507', '7°12188072', 'No actualizó', 'No se realizo visita ni actualizo ficha de verificacion', null, 'No', 'Acueducto veredal', null, null, null, 'No', 'No', 'Sí', 'No', null, null, null, null, null, null, null, null, null, null, 'No', 'B2C', 'No', 'NO', null, null, null, true, false, false, false, true
where not exists (select 1 from negocios where nombre = 'FINCA LOS ROSALES');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'FINCA LOS ROSALES');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'FINCA LOS ROSALES'), (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'FINCA LOS ROSALES');
insert into negocios_subcategorias (negocio_id, subcategoria_id) select (select id from negocios where nombre = 'FINCA LOS ROSALES'), id from subcategorias where slug = 'biocomercio';
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'FINCA LOS ROSALES');
insert into negocios_actividades (negocio_id, actividad_productiva_id) select (select id from negocios where nombre = 'FINCA LOS ROSALES'), id from actividades_productivas where slug = 'maderables';
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'FINCA LOS ROSALES'), 2024, 50.5 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;

-- ORGÁNICO & MEDICINAL
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'),
  municipio = 'Lebrija',
  vereda_id = (select id from veredas where municipio = 'Lebrija' and slug = 'san-gabriel'),
  direccion = 'AL LADO DE LA ESCUELA SEDE K PORTUGAL,FINCA ORLANDA #3',
  latitud = 7.105869444444444,
  longitud = null,
  descripcion_corta = 'Cultivo ecológico de café, cacao y hierbas aromáticas donde se elabora café molido con especias, chocolate de mesa en bola e infusión aromática.',
  descripcion = 'Cultivo ecológico de café, cacao y hierbas aromáticas donde se elabora café molido con especias, chocolate de mesa en bola e infusión aromática.',
  producto = 'CAFÉ SOSTENIBLE CON ESPECIAS',
  telefono = '3158228579',
  whatsapp = '573158228579',
  email = 'marinamayorga05@hotmail.com',
  representante_legal = 'MARINA MAYORGA TRIANA',
  nit = '28098059-7',
  naturaleza_juridica = null,
  delegado = null,
  rut_camara_comercio = 'RUT',
  responsable_cdmb = 'HEINER ORTIZ',
  novedad = 'ACTIVO',
  tipo_negocio_verde = 'Dinamizadoras',
  anio_registro = 2023,
  cota_msnm = '1092 msnm',
  este = '73°16°35,53''''',
  norte = '7°6''21,13''''',
  aplicacion_ficha_2025 = 'Actualizó',
  observaciones = 'Se realizo visita y se aplico ficha de verificacion',
  registro_nacional_turismo = null,
  uso_suelo = 'Sí',
  concesion_aguas = null,
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
  buenas_practicas_agricolas = null,
  buenas_practicas_apicolas = null,
  registro_apicola = null,
  intervencion_cauce = null,
  capacidad_carga = null,
  sstt = 'No',
  canal_venta = 'B2C',
  exportacion = null,
  huella_carbono = null,
  fortalezas_ambiental = 'SI, Sistemas agroforestales o silvopastoriles, estrategias de restauración y reforestación con especies nativas o endémicas, cercas vivas, rescate de plántulas, fertilización orgánica, entre otros.
-Cultivos agroecológicos de hierbas aromáticas, café y cacao. 
-Elaboración de sus propios abonos con material orgánico.
-No se utilizan materiales peligrosos y/o tóxicos en los procesos.
-Empaques ecológicos Craff y cartón.
-Reutiliza el agua del lavado para regar plantas y recoge agua lluvias tanque de 2mil LT',
  fortalezas_social = 'si, Articula con la asociación de mujeres campesinas de la zona AMUCALE.
-Acciones de educación ambiental como en temporada de vacaciones capacitaciones a niños y jóvenes de cómo proteger los recursos naturales.',
  fortalezas_economico = 'Tiene claro algunos costos y gastos pero no la totalidad de operación del negocio',
  emprendimiento_verde = true,
  sello_marca = false,
  avalado = false,
  destacado = false,
  activo = true
where nombre = 'ORGÁNICO & MEDICINAL';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select '00893aaa-7889-4625-aea7-5c5aa6603db1', 'ORGÁNICO & MEDICINAL', generar_slug_unico('ORGÁNICO & MEDICINAL', '00893aaa-7889-4625-aea7-5c5aa6603db1'), (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'), 'Lebrija', (select id from veredas where municipio = 'Lebrija' and slug = 'san-gabriel'), 'AL LADO DE LA ESCUELA SEDE K PORTUGAL,FINCA ORLANDA #3', 7.105869444444444, null, 'Cultivo ecológico de café, cacao y hierbas aromáticas donde se elabora café molido con especias, chocolate de mesa en bola e infusión aromática.', 'Cultivo ecológico de café, cacao y hierbas aromáticas donde se elabora café molido con especias, chocolate de mesa en bola e infusión aromática.', 'CAFÉ SOSTENIBLE CON ESPECIAS', '3158228579', '573158228579', 'marinamayorga05@hotmail.com', 'MARINA MAYORGA TRIANA', '28098059-7', null, null, 'RUT', 'HEINER ORTIZ', 'ACTIVO', 'Dinamizadoras', 2023, '1092 msnm', '73°16°35,53''''', '7°6''21,13''''', 'Actualizó', 'Se realizo visita y se aplico ficha de verificacion', null, 'Sí', null, null, null, null, 'No', 'No', 'Sí', null, null, null, 'No', null, null, null, null, null, null, null, 'No', 'B2C', null, null, 'SI, Sistemas agroforestales o silvopastoriles, estrategias de restauración y reforestación con especies nativas o endémicas, cercas vivas, rescate de plántulas, fertilización orgánica, entre otros.
-Cultivos agroecológicos de hierbas aromáticas, café y cacao. 
-Elaboración de sus propios abonos con material orgánico.
-No se utilizan materiales peligrosos y/o tóxicos en los procesos.
-Empaques ecológicos Craff y cartón.
-Reutiliza el agua del lavado para regar plantas y recoge agua lluvias tanque de 2mil LT', 'si, Articula con la asociación de mujeres campesinas de la zona AMUCALE.
-Acciones de educación ambiental como en temporada de vacaciones capacitaciones a niños y jóvenes de cómo proteger los recursos naturales.', 'Tiene claro algunos costos y gastos pero no la totalidad de operación del negocio', true, false, false, false, true
where not exists (select 1 from negocios where nombre = 'ORGÁNICO & MEDICINAL');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'ORGÁNICO & MEDICINAL');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'ORGÁNICO & MEDICINAL'), (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'ORGÁNICO & MEDICINAL');
insert into negocios_subcategorias (negocio_id, subcategoria_id) select (select id from negocios where nombre = 'ORGÁNICO & MEDICINAL'), id from subcategorias where slug = 'agroindustria-sostenible';
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'ORGÁNICO & MEDICINAL');
insert into negocios_actividades (negocio_id, actividad_productiva_id) select (select id from negocios where nombre = 'ORGÁNICO & MEDICINAL'), id from actividades_productivas where slug = 'agroindustrial-alimentario';
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'ORGÁNICO & MEDICINAL'), 2024, 50.6 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'ORGÁNICO & MEDICINAL'), 2025, 51.8 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;

-- DIANA CAROLINA PRADO
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'pendiente-clasificar'),
  municipio = 'Lebrija',
  vereda_id = null,
  direccion = null,
  latitud = null,
  longitud = null,
  descripcion_corta = null,
  descripcion = null,
  producto = 'PROMOTORA TURISTICA',
  telefono = '3187539957',
  whatsapp = '573187539957',
  email = 'topocohidrosogamoso@gmail.com',
  representante_legal = 'DIANA CAROLINA PRADO',
  nit = '1098673250',
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
  observaciones = 'No cumplimiento de requisitos',
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
where nombre = 'DIANA CAROLINA PRADO';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select '5aee2475-d0ec-42a3-8a97-d0272cd58f2e', 'DIANA CAROLINA PRADO', generar_slug_unico('DIANA CAROLINA PRADO', '5aee2475-d0ec-42a3-8a97-d0272cd58f2e'), (select id from categorias_oficiales where slug = 'pendiente-clasificar'), 'Lebrija', null, null, null, null, null, null, 'PROMOTORA TURISTICA', '3187539957', '573187539957', 'topocohidrosogamoso@gmail.com', 'DIANA CAROLINA PRADO', '1098673250', null, null, null, null, 'RETIRADO', 'No aplica', 2023, null, null, null, null, 'No cumplimiento de requisitos', null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, true, false, false, false, false
where not exists (select 1 from negocios where nombre = 'DIANA CAROLINA PRADO');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'DIANA CAROLINA PRADO');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'DIANA CAROLINA PRADO'), (select id from categorias_oficiales where slug = 'pendiente-clasificar');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'DIANA CAROLINA PRADO');
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'DIANA CAROLINA PRADO');

-- ADRIANA PINTO GARCIA
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'pendiente-clasificar'),
  municipio = 'Lebrija',
  vereda_id = null,
  direccion = null,
  latitud = null,
  longitud = null,
  descripcion_corta = null,
  descripcion = null,
  producto = null,
  telefono = null,
  whatsapp = null,
  email = null,
  representante_legal = null,
  nit = null,
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
  observaciones = 'No cumplimiento de requisitos',
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
where nombre = 'ADRIANA PINTO GARCIA';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select 'd3de96a0-1b63-4734-8c39-1f6dbacaf9b6', 'ADRIANA PINTO GARCIA', generar_slug_unico('ADRIANA PINTO GARCIA', 'd3de96a0-1b63-4734-8c39-1f6dbacaf9b6'), (select id from categorias_oficiales where slug = 'pendiente-clasificar'), 'Lebrija', null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, 'RETIRADO', 'No aplica', 2023, null, null, null, null, 'No cumplimiento de requisitos', null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, true, false, false, false, false
where not exists (select 1 from negocios where nombre = 'ADRIANA PINTO GARCIA');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'ADRIANA PINTO GARCIA');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'ADRIANA PINTO GARCIA'), (select id from categorias_oficiales where slug = 'pendiente-clasificar');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'ADRIANA PINTO GARCIA');
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'ADRIANA PINTO GARCIA');

-- AGROEMPRENDER D&A
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'pendiente-clasificar'),
  municipio = 'Floridablanca',
  vereda_id = null,
  direccion = 'FINCA LA VEGA VEREDA AGUA BLANCA',
  latitud = 7.1075277777777774,
  longitud = -73.04663888888889,
  descripcion_corta = null,
  descripcion = null,
  producto = 'BROTES Y GERMINADOS',
  telefono = '3016585430',
  whatsapp = '573016585430',
  email = null,
  representante_legal = 'AURA VILABONA PABON',
  nit = '63501929',
  naturaleza_juridica = null,
  delegado = null,
  rut_camara_comercio = null,
  responsable_cdmb = 'ALEXANDRA SOTOMONTE',
  novedad = 'SUSPENDIDO',
  tipo_negocio_verde = 'Inicial',
  anio_registro = 2023,
  cota_msnm = '1590',
  este = '73°2''47,9''''',
  norte = '7°6''27,1''''',
  aplicacion_ficha_2025 = null,
  observaciones = 'Emprendimiento',
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
where nombre = 'AGROEMPRENDER D&A';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select 'b9abe63c-4937-4026-a5cf-ac495a9582bc', 'AGROEMPRENDER D&A', generar_slug_unico('AGROEMPRENDER D&A', 'b9abe63c-4937-4026-a5cf-ac495a9582bc'), (select id from categorias_oficiales where slug = 'pendiente-clasificar'), 'Floridablanca', null, 'FINCA LA VEGA VEREDA AGUA BLANCA', 7.1075277777777774, -73.04663888888889, null, null, 'BROTES Y GERMINADOS', '3016585430', '573016585430', null, 'AURA VILABONA PABON', '63501929', null, null, null, 'ALEXANDRA SOTOMONTE', 'SUSPENDIDO', 'Inicial', 2023, '1590', '73°2''47,9''''', '7°6''27,1''''', null, 'Emprendimiento', null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, true, false, false, false, false
where not exists (select 1 from negocios where nombre = 'AGROEMPRENDER D&A');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'AGROEMPRENDER D&A');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'AGROEMPRENDER D&A'), (select id from categorias_oficiales where slug = 'pendiente-clasificar');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'AGROEMPRENDER D&A');
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'AGROEMPRENDER D&A');

-- LU FRUITS
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'pendiente-clasificar'),
  municipio = 'Lebrija',
  vereda_id = null,
  direccion = null,
  latitud = 7.091980555555555,
  longitud = -73.25661111111111,
  descripcion_corta = null,
  descripcion = null,
  producto = 'PULPAS DE FRUTA',
  telefono = '3175195165',
  whatsapp = '573175195165',
  email = 'lucialopez1722@gmail.com',
  representante_legal = 'ADRIANA LUCÍA LÓPEZ',
  nit = null,
  naturaleza_juridica = null,
  delegado = null,
  rut_camara_comercio = null,
  responsable_cdmb = 'ANA RUEDA',
  novedad = 'SUSPENDIDO',
  tipo_negocio_verde = null,
  anio_registro = 2023,
  cota_msnm = '1123',
  este = '73°15''23,8''''',
  norte = '7°5''31.13''''',
  aplicacion_ficha_2025 = null,
  observaciones = 'Por definir',
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
where nombre = 'LU FRUITS';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select '7042bfb6-dff8-46ac-9e5d-328bc7f81c61', 'LU FRUITS', generar_slug_unico('LU FRUITS', '7042bfb6-dff8-46ac-9e5d-328bc7f81c61'), (select id from categorias_oficiales where slug = 'pendiente-clasificar'), 'Lebrija', null, null, 7.091980555555555, -73.25661111111111, null, null, 'PULPAS DE FRUTA', '3175195165', '573175195165', 'lucialopez1722@gmail.com', 'ADRIANA LUCÍA LÓPEZ', null, null, null, null, 'ANA RUEDA', 'SUSPENDIDO', null, 2023, '1123', '73°15''23,8''''', '7°5''31.13''''', null, 'Por definir', null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, true, false, false, false, false
where not exists (select 1 from negocios where nombre = 'LU FRUITS');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'LU FRUITS');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'LU FRUITS'), (select id from categorias_oficiales where slug = 'pendiente-clasificar');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'LU FRUITS');
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'LU FRUITS');

-- EDINSON ALBERTO PACHECO
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'pendiente-clasificar'),
  municipio = 'Floridablanca',
  vereda_id = null,
  direccion = null,
  latitud = 7.105166666666666,
  longitud = -73.04511111111111,
  descripcion_corta = null,
  descripcion = null,
  producto = null,
  telefono = '3204954106',
  whatsapp = '573204954106',
  email = 'com_caibi37@hotmail.com',
  representante_legal = null,
  nit = null,
  naturaleza_juridica = null,
  delegado = null,
  rut_camara_comercio = null,
  responsable_cdmb = null,
  novedad = 'RETIRADO',
  tipo_negocio_verde = 'No aplica',
  anio_registro = 2023,
  cota_msnm = '1723',
  este = '73°2''42,4''''',
  norte = '7°6''18,6''''',
  aplicacion_ficha_2025 = null,
  observaciones = 'No cumplimiento de requisitos',
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
where nombre = 'EDINSON ALBERTO PACHECO';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select '1855f672-f384-41a1-ae94-3a29d20e2dc0', 'EDINSON ALBERTO PACHECO', generar_slug_unico('EDINSON ALBERTO PACHECO', '1855f672-f384-41a1-ae94-3a29d20e2dc0'), (select id from categorias_oficiales where slug = 'pendiente-clasificar'), 'Floridablanca', null, null, 7.105166666666666, -73.04511111111111, null, null, null, '3204954106', '573204954106', 'com_caibi37@hotmail.com', null, null, null, null, null, null, 'RETIRADO', 'No aplica', 2023, '1723', '73°2''42,4''''', '7°6''18,6''''', null, 'No cumplimiento de requisitos', null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, true, false, false, false, false
where not exists (select 1 from negocios where nombre = 'EDINSON ALBERTO PACHECO');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'EDINSON ALBERTO PACHECO');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'EDINSON ALBERTO PACHECO'), (select id from categorias_oficiales where slug = 'pendiente-clasificar');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'EDINSON ALBERTO PACHECO');
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'EDINSON ALBERTO PACHECO');

-- CERRO SANTO CAFÉ
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'),
  municipio = 'Floridablanca',
  vereda_id = (select id from veredas where municipio = 'Floridablanca' and slug = 'helechales'),
  direccion = 'FINCA EL RECREO EN LA VEREDA HELECHALES FLORIDABLANCA JUNTO AL CERRO DE SANTISIMO, OTRA DIRECCION CARRERA 35 NO. 11-31 LOS PINOS',
  latitud = 7.078351388888889,
  longitud = -73.07372222222222,
  descripcion_corta = 'Empresa dedicada a la produccion y comercializacion de café en grano y molido utilizando tecnicas de seleccionado estandarizadas que garantizan la calidad…',
  descripcion = 'Empresa dedicada a la produccion y comercializacion de café en grano y molido utilizando tecnicas de seleccionado estandarizadas que garantizan la calidad final del producto',
  producto = 'CAFÉ',
  telefono = '3156762700',
  whatsapp = '573156762700',
  email = 'elpifon3@hotmail.com',
  representante_legal = 'LAURA ANGELINA OSMA PINZON',
  nit = '1098739722-1',
  naturaleza_juridica = 'Natural',
  delegado = 'ELIZABETH PINZON',
  rut_camara_comercio = 'Cámara de comercio',
  responsable_cdmb = 'CARINE GARCIA',
  novedad = 'ACTIVO',
  tipo_negocio_verde = 'Dinamizadoras',
  anio_registro = 2023,
  cota_msnm = null,
  este = '73°4''25.400',
  norte = '7°4''42.065',
  aplicacion_ficha_2025 = 'Actualizó',
  observaciones = null,
  registro_nacional_turismo = null,
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
  invima_vencimiento = '2028-12-03',
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
  fortalezas_ambiental = 'Producción de café orgánico sin uso de agroquímicos.
 • Conservación del suelo y protección de fuentes hídricas en la zona cafetera.
 • Aporte a la biodiversidad mediante prácticas sostenibles.
 Aprovechamiento responsable de la cáscara y residuos del café (posibilidad de compostaje o uso artesanal).',
  fortalezas_social = '• Liderado por adultos mayores con experiencia y saberes tradicionales.
 • Transmisión de conocimientos y cultura cafetera.
 • Genera reconocimiento local y sentido de pertenencia comunitaria.
 • Contribuye al arraigo rural y preservación de la tradición cafetera.',
  fortalezas_economico = 'Producto de calidad con registro INVIMA, lo que da confianza al consumidor.
 , Cuentan con ventas estables en pequeña escala.
 ,Diferenciación por ser un café orgánico y artesanal.
 ,Posibilidad de vender en nichos de mercado (cafés especiales, tiendas naturales o locales turísticos).',
  emprendimiento_verde = false,
  sello_marca = false,
  avalado = true,
  destacado = false,
  activo = true
where nombre = 'CERRO SANTO CAFÉ';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select 'c4009c4d-0d58-4cd0-a966-f1de9cdac81e', 'CERRO SANTO CAFÉ', generar_slug_unico('CERRO SANTO CAFÉ', 'c4009c4d-0d58-4cd0-a966-f1de9cdac81e'), (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'), 'Floridablanca', (select id from veredas where municipio = 'Floridablanca' and slug = 'helechales'), 'FINCA EL RECREO EN LA VEREDA HELECHALES FLORIDABLANCA JUNTO AL CERRO DE SANTISIMO, OTRA DIRECCION CARRERA 35 NO. 11-31 LOS PINOS', 7.078351388888889, -73.07372222222222, 'Empresa dedicada a la produccion y comercializacion de café en grano y molido utilizando tecnicas de seleccionado estandarizadas que garantizan la calidad…', 'Empresa dedicada a la produccion y comercializacion de café en grano y molido utilizando tecnicas de seleccionado estandarizadas que garantizan la calidad final del producto', 'CAFÉ', '3156762700', '573156762700', 'elpifon3@hotmail.com', 'LAURA ANGELINA OSMA PINZON', '1098739722-1', 'Natural', 'ELIZABETH PINZON', 'Cámara de comercio', 'CARINE GARCIA', 'ACTIVO', 'Dinamizadoras', 2023, null, '73°4''25.400', '7°4''42.065', 'Actualizó', null, null, 'No', 'Acueducto veredal', null, null, null, 'No', 'No', 'Sí', null, null, null, 'Sí', '2028-12-03', null, 'No', null, null, null, null, 'No', 'Mixta', 'No', 'NO', 'Producción de café orgánico sin uso de agroquímicos.
 • Conservación del suelo y protección de fuentes hídricas en la zona cafetera.
 • Aporte a la biodiversidad mediante prácticas sostenibles.
 Aprovechamiento responsable de la cáscara y residuos del café (posibilidad de compostaje o uso artesanal).', '• Liderado por adultos mayores con experiencia y saberes tradicionales.
 • Transmisión de conocimientos y cultura cafetera.
 • Genera reconocimiento local y sentido de pertenencia comunitaria.
 • Contribuye al arraigo rural y preservación de la tradición cafetera.', 'Producto de calidad con registro INVIMA, lo que da confianza al consumidor.
 , Cuentan con ventas estables en pequeña escala.
 ,Diferenciación por ser un café orgánico y artesanal.
 ,Posibilidad de vender en nichos de mercado (cafés especiales, tiendas naturales o locales turísticos).', false, false, true, false, true
where not exists (select 1 from negocios where nombre = 'CERRO SANTO CAFÉ');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'CERRO SANTO CAFÉ');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'CERRO SANTO CAFÉ'), (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'CERRO SANTO CAFÉ');
insert into negocios_subcategorias (negocio_id, subcategoria_id) select (select id from negocios where nombre = 'CERRO SANTO CAFÉ'), id from subcategorias where slug = 'agroindustria-sostenible';
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'CERRO SANTO CAFÉ');
insert into negocios_actividades (negocio_id, actividad_productiva_id) select (select id from negocios where nombre = 'CERRO SANTO CAFÉ'), id from actividades_productivas where slug = 'agroindustrial-alimentario';
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'CERRO SANTO CAFÉ'), 2023, 50.15 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'CERRO SANTO CAFÉ'), 2024, 60.4 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'CERRO SANTO CAFÉ'), 2025, 61.7 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;

-- GREEN FOREST
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'pendiente-clasificar'),
  municipio = 'Bucaramanga',
  vereda_id = null,
  direccion = 'Calle 67 # 16 -09',
  latitud = null,
  longitud = null,
  descripcion_corta = null,
  descripcion = null,
  producto = 'EDUCACION AMBIENTAL',
  telefono = '3167846490',
  whatsapp = '573167846490',
  email = 'fundaciongreenforest@gmail.com',
  representante_legal = 'MIGUEL LUGO',
  nit = null,
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
where nombre = 'GREEN FOREST';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select 'ff506422-37c0-41cf-aa0a-628e7efe7fd0', 'GREEN FOREST', generar_slug_unico('GREEN FOREST', 'ff506422-37c0-41cf-aa0a-628e7efe7fd0'), (select id from categorias_oficiales where slug = 'pendiente-clasificar'), 'Bucaramanga', null, 'Calle 67 # 16 -09', null, null, null, null, 'EDUCACION AMBIENTAL', '3167846490', '573167846490', 'fundaciongreenforest@gmail.com', 'MIGUEL LUGO', null, null, null, null, null, 'RETIRADO', 'No aplica', 2023, null, null, null, null, 'NO Ingresa al programa', null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, true, false, false, false, false
where not exists (select 1 from negocios where nombre = 'GREEN FOREST');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'GREEN FOREST');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'GREEN FOREST'), (select id from categorias_oficiales where slug = 'pendiente-clasificar');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'GREEN FOREST');
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'GREEN FOREST');

-- PSICORESILIENCIA
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'pendiente-clasificar'),
  municipio = 'Bucaramanga',
  vereda_id = null,
  direccion = 'CARRERA 23 # 47-63',
  latitud = null,
  longitud = null,
  descripcion_corta = null,
  descripcion = null,
  producto = 'EDUCACION AMBIENTAL',
  telefono = '3026717250',
  whatsapp = '573026717250',
  email = 'psicoresilienciabga@gmail.com',
  representante_legal = 'MAYRA M. BURGOS',
  nit = null,
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
where nombre = 'PSICORESILIENCIA';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select 'f6ef73a5-3183-4b60-9a85-33e9b49fd872', 'PSICORESILIENCIA', generar_slug_unico('PSICORESILIENCIA', 'f6ef73a5-3183-4b60-9a85-33e9b49fd872'), (select id from categorias_oficiales where slug = 'pendiente-clasificar'), 'Bucaramanga', null, 'CARRERA 23 # 47-63', null, null, null, null, 'EDUCACION AMBIENTAL', '3026717250', '573026717250', 'psicoresilienciabga@gmail.com', 'MAYRA M. BURGOS', null, null, null, null, null, 'RETIRADO', 'No aplica', 2023, null, null, null, null, 'NO Ingresa al programa', null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, true, false, false, false, false
where not exists (select 1 from negocios where nombre = 'PSICORESILIENCIA');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'PSICORESILIENCIA');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'PSICORESILIENCIA'), (select id from categorias_oficiales where slug = 'pendiente-clasificar');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'PSICORESILIENCIA');
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'PSICORESILIENCIA');

-- FMB AGROSOLUCIONES S.A.S. E.S.P.
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'pendiente-clasificar'),
  municipio = 'Floridablanca',
  vereda_id = null,
  direccion = 'VIA CORREDOR RIO FRIO CALLE 210 #9-631',
  latitud = 7.0552777777777775,
  longitud = -73.13194444444444,
  descripcion_corta = 'Empresa dedicada al tratamiento valorización de los residuos sólidos y líquidos orgánicos provenientes del beneficio animal y que son aprovechables. Cuenta…',
  descripcion = 'Empresa dedicada al tratamiento valorización de los residuos sólidos y líquidos orgánicos provenientes del beneficio animal y que son aprovechables. Cuenta con personal profesional experto en la investigación, producción y comercialización de acondicionadores de suelos orgánico-minerales y biofertilizantes líquidos de alta calidad, amigables con el medio ambiente que pueden utilizarse con efectividad en diversos cultivos.',
  producto = 'ABONOS ORGÁNICOS',
  telefono = '3185088238',
  whatsapp = '573185088238',
  email = 'fmbagrosolucionessas@gmail.com',
  representante_legal = 'BETSY PALOMINO DUARTE',
  nit = '901521359-2',
  naturaleza_juridica = null,
  delegado = null,
  rut_camara_comercio = null,
  responsable_cdmb = 'SILVIA GARCIA',
  novedad = 'SUSPENDIDO',
  tipo_negocio_verde = 'Inicial',
  anio_registro = 2022,
  cota_msnm = '753 msnm',
  este = '73°7''55''''',
  norte = '7°3''19''''',
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
  emprendimiento_verde = false,
  sello_marca = false,
  avalado = true,
  destacado = false,
  activo = false
where nombre = 'FMB AGROSOLUCIONES S.A.S. E.S.P.';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select '2a0d4aba-5786-4993-9b80-714597a8e6f6', 'FMB AGROSOLUCIONES S.A.S. E.S.P.', generar_slug_unico('FMB AGROSOLUCIONES S.A.S. E.S.P.', '2a0d4aba-5786-4993-9b80-714597a8e6f6'), (select id from categorias_oficiales where slug = 'pendiente-clasificar'), 'Floridablanca', null, 'VIA CORREDOR RIO FRIO CALLE 210 #9-631', 7.0552777777777775, -73.13194444444444, 'Empresa dedicada al tratamiento valorización de los residuos sólidos y líquidos orgánicos provenientes del beneficio animal y que son aprovechables. Cuenta…', 'Empresa dedicada al tratamiento valorización de los residuos sólidos y líquidos orgánicos provenientes del beneficio animal y que son aprovechables. Cuenta con personal profesional experto en la investigación, producción y comercialización de acondicionadores de suelos orgánico-minerales y biofertilizantes líquidos de alta calidad, amigables con el medio ambiente que pueden utilizarse con efectividad en diversos cultivos.', 'ABONOS ORGÁNICOS', '3185088238', '573185088238', 'fmbagrosolucionessas@gmail.com', 'BETSY PALOMINO DUARTE', '901521359-2', null, null, null, 'SILVIA GARCIA', 'SUSPENDIDO', 'Inicial', 2022, '753 msnm', '73°7''55''''', '7°3''19''''', null, 'Continua en el programa', null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, false, false, true, false, false
where not exists (select 1 from negocios where nombre = 'FMB AGROSOLUCIONES S.A.S. E.S.P.');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'FMB AGROSOLUCIONES S.A.S. E.S.P.');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'FMB AGROSOLUCIONES S.A.S. E.S.P.'), (select id from categorias_oficiales where slug = 'pendiente-clasificar');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'FMB AGROSOLUCIONES S.A.S. E.S.P.');
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'FMB AGROSOLUCIONES S.A.S. E.S.P.');
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'FMB AGROSOLUCIONES S.A.S. E.S.P.'), 2023, 63.85 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;

-- COMERCIALIZADORA Y RECUPERADORA AMBIENTAL LAURA SOFIA S.A.S
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'ecoproductos-industriales'),
  municipio = 'Bucaramanga',
  vereda_id = (select id from veredas where municipio = 'Bucaramanga' and slug = 'perimetro-urbano'),
  direccion = 'CALLE 7 # 13 - 23 BARRIO SAN RAFAEL',
  latitud = 7.137861111111111,
  longitud = -73.13308333333333,
  descripcion_corta = 'La empresa Comercializadora y recuperadora ambiental Laura Sofia SAS, es fundada en el año 2015, como una respuesta dirigida a cumplir con la…',
  descripcion = 'La empresa Comercializadora y recuperadora ambiental Laura Sofia SAS, es fundada en el año 2015, como una respuesta dirigida a cumplir con la responsabilidad social y ambiental. Dado al enorme crecimiento industrial, y el complicado control de residuos sólidos, siendo causante de un mal manejo y desentendimiento de posibles consecuencias ambientales. La empresa, como una posible alternativa ante dicha problemática, tiene como objetivo principal, permitir darle una nueva oportunidad al material que ya ha sido previamente usado, a través del desarrollo de estrategias sostenibles y responsables orientadas a la mitigación del impacto ambiental, promoviendo así la economía circular y aportando a la perdurabilidad de los recursos naturales.',
  producto = 'RECOLECCIÓN, SELECCIÓN, PRENSADO, DESTRUCCIÓN Y ENVIO DE PAPEL, CARTON, PET Y VIDRIO',
  telefono = '3222177226',
  whatsapp = '573222177226',
  email = 'laurasofiasas@gmail.com',
  representante_legal = 'JUAN DANIEL FLOREZ DOMINGUEZ',
  nit = '900988942-8',
  naturaleza_juridica = 'Jurídica',
  delegado = 'NANCY DOMINGUEZ',
  rut_camara_comercio = 'Cámara de comercio',
  responsable_cdmb = 'CLAUDIA SANCHEZ',
  novedad = 'ACTIVO',
  tipo_negocio_verde = 'Dinamizadoras',
  anio_registro = 2023,
  cota_msnm = '937 msnm',
  este = '73°7''59,1''''',
  norte = '7°8''16,3''''',
  aplicacion_ficha_2025 = 'Actualizó',
  observaciones = 'Se realizo visita y se actualizo ficha de verificacion',
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
  invima = null,
  invima_vencimiento = null,
  certificado_tenencia_animales = null,
  buenas_practicas_agricolas = null,
  buenas_practicas_apicolas = null,
  registro_apicola = null,
  intervencion_cauce = null,
  capacidad_carga = null,
  sstt = 'Sí',
  canal_venta = 'Mixta',
  exportacion = 'No',
  huella_carbono = 'NO',
  fortalezas_ambiental = 'Por cada tonelada de papel reciclado se dejan de talar 17 árboles en el mundo',
  fortalezas_social = 'Realizan charlas ambientales y buenas prácticas con las plantas',
  fortalezas_economico = 'Reconocidos en el sector empresarial',
  emprendimiento_verde = false,
  sello_marca = false,
  avalado = true,
  destacado = false,
  activo = true
where nombre = 'COMERCIALIZADORA Y RECUPERADORA AMBIENTAL LAURA SOFIA S.A.S';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select '6f1abdce-fa9d-4b76-b8d2-eed63a0b6431', 'COMERCIALIZADORA Y RECUPERADORA AMBIENTAL LAURA SOFIA S.A.S', generar_slug_unico('COMERCIALIZADORA Y RECUPERADORA AMBIENTAL LAURA SOFIA S.A.S', '6f1abdce-fa9d-4b76-b8d2-eed63a0b6431'), (select id from categorias_oficiales where slug = 'ecoproductos-industriales'), 'Bucaramanga', (select id from veredas where municipio = 'Bucaramanga' and slug = 'perimetro-urbano'), 'CALLE 7 # 13 - 23 BARRIO SAN RAFAEL', 7.137861111111111, -73.13308333333333, 'La empresa Comercializadora y recuperadora ambiental Laura Sofia SAS, es fundada en el año 2015, como una respuesta dirigida a cumplir con la…', 'La empresa Comercializadora y recuperadora ambiental Laura Sofia SAS, es fundada en el año 2015, como una respuesta dirigida a cumplir con la responsabilidad social y ambiental. Dado al enorme crecimiento industrial, y el complicado control de residuos sólidos, siendo causante de un mal manejo y desentendimiento de posibles consecuencias ambientales. La empresa, como una posible alternativa ante dicha problemática, tiene como objetivo principal, permitir darle una nueva oportunidad al material que ya ha sido previamente usado, a través del desarrollo de estrategias sostenibles y responsables orientadas a la mitigación del impacto ambiental, promoviendo así la economía circular y aportando a la perdurabilidad de los recursos naturales.', 'RECOLECCIÓN, SELECCIÓN, PRENSADO, DESTRUCCIÓN Y ENVIO DE PAPEL, CARTON, PET Y VIDRIO', '3222177226', '573222177226', 'laurasofiasas@gmail.com', 'JUAN DANIEL FLOREZ DOMINGUEZ', '900988942-8', 'Jurídica', 'NANCY DOMINGUEZ', 'Cámara de comercio', 'CLAUDIA SANCHEZ', 'ACTIVO', 'Dinamizadoras', 2023, '937 msnm', '73°7''59,1''''', '7°8''16,3''''', 'Actualizó', 'Se realizo visita y se actualizo ficha de verificacion', null, 'Sí', 'Acueducto', null, null, null, 'No', 'No', null, 'Sí', null, null, null, null, null, null, null, null, null, null, 'Sí', 'Mixta', 'No', 'NO', 'Por cada tonelada de papel reciclado se dejan de talar 17 árboles en el mundo', 'Realizan charlas ambientales y buenas prácticas con las plantas', 'Reconocidos en el sector empresarial', false, false, true, false, true
where not exists (select 1 from negocios where nombre = 'COMERCIALIZADORA Y RECUPERADORA AMBIENTAL LAURA SOFIA S.A.S');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'COMERCIALIZADORA Y RECUPERADORA AMBIENTAL LAURA SOFIA S.A.S');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'COMERCIALIZADORA Y RECUPERADORA AMBIENTAL LAURA SOFIA S.A.S'), (select id from categorias_oficiales where slug = 'ecoproductos-industriales');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'COMERCIALIZADORA Y RECUPERADORA AMBIENTAL LAURA SOFIA S.A.S');
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'COMERCIALIZADORA Y RECUPERADORA AMBIENTAL LAURA SOFIA S.A.S');
insert into negocios_actividades (negocio_id, actividad_productiva_id) select (select id from negocios where nombre = 'COMERCIALIZADORA Y RECUPERADORA AMBIENTAL LAURA SOFIA S.A.S'), id from actividades_productivas where slug = 'aprovechamiento-residuos-inorganicos';
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'COMERCIALIZADORA Y RECUPERADORA AMBIENTAL LAURA SOFIA S.A.S'), 2023, 51.03 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'COMERCIALIZADORA Y RECUPERADORA AMBIENTAL LAURA SOFIA S.A.S'), 2024, 76.2 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'COMERCIALIZADORA Y RECUPERADORA AMBIENTAL LAURA SOFIA S.A.S'), 2025, 74.9 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;

-- JRVG RECUPERADORA S.A.S.
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'ecoproductos-industriales'),
  municipio = 'Bucaramanga',
  vereda_id = (select id from veredas where municipio = 'Bucaramanga' and slug = 'perimetro-urbano'),
  direccion = 'CARRERA 8 # 13-27  BARRIO GAITAN',
  latitud = 7.143055555555556,
  longitud = -73.15361111111112,
  descripcion_corta = 'Recuperación y comercialización de excedentes industriales de chatarra y tuberías destinadas a procesos de pilotaje y construcción. De manera…',
  descripcion = 'Recuperación y comercialización de excedentes industriales de chatarra y tuberías destinadas a procesos de pilotaje y construcción. De manera complementaria, presta servicios de mano de obra especializada, actuando como facilitadora en operaciones productivas. La empresa crea valor agregado mediante la implementación de altos estándares de calidad, eficiencia operativa y cumplimiento de los requerimientos de sus clientes.',
  producto = 'CHATARRA COLD ROLLED',
  telefono = '3225078768',
  whatsapp = '573225078768',
  email = 'financiero@jrvg.com.co',
  representante_legal = 'JOSE RICARDO VILLALBA GALLARDO',
  nit = '901526649-6',
  naturaleza_juridica = 'Jurídica',
  delegado = 'DANIELA',
  rut_camara_comercio = 'Cámara de comercio',
  responsable_cdmb = 'DIANA NAVARRO',
  novedad = 'ACTIVO',
  tipo_negocio_verde = 'Avanzado',
  anio_registro = 2022,
  cota_msnm = '659 msnm',
  este = '73°09''13''''',
  norte = '7°08''35''''',
  aplicacion_ficha_2025 = 'Actualizó',
  observaciones = 'Se realizo visita y se actualizo ficha de verificacion',
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
  fortalezas_ambiental = 'Contribuye al reciclaje y reducción de residuos industriales.',
  fortalezas_social = 'Genera empleo especializado y fomenta la economía circular.',
  fortalezas_economico = 'Alta demanda del mercado industrial.',
  emprendimiento_verde = false,
  sello_marca = true,
  avalado = true,
  destacado = false,
  activo = true
where nombre = 'JRVG RECUPERADORA S.A.S.';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select 'd5d0e44d-3c8b-48fc-912b-d3a26ebc97db', 'JRVG RECUPERADORA S.A.S.', generar_slug_unico('JRVG RECUPERADORA S.A.S.', 'd5d0e44d-3c8b-48fc-912b-d3a26ebc97db'), (select id from categorias_oficiales where slug = 'ecoproductos-industriales'), 'Bucaramanga', (select id from veredas where municipio = 'Bucaramanga' and slug = 'perimetro-urbano'), 'CARRERA 8 # 13-27  BARRIO GAITAN', 7.143055555555556, -73.15361111111112, 'Recuperación y comercialización de excedentes industriales de chatarra y tuberías destinadas a procesos de pilotaje y construcción. De manera…', 'Recuperación y comercialización de excedentes industriales de chatarra y tuberías destinadas a procesos de pilotaje y construcción. De manera complementaria, presta servicios de mano de obra especializada, actuando como facilitadora en operaciones productivas. La empresa crea valor agregado mediante la implementación de altos estándares de calidad, eficiencia operativa y cumplimiento de los requerimientos de sus clientes.', 'CHATARRA COLD ROLLED', '3225078768', '573225078768', 'financiero@jrvg.com.co', 'JOSE RICARDO VILLALBA GALLARDO', '901526649-6', 'Jurídica', 'DANIELA', 'Cámara de comercio', 'DIANA NAVARRO', 'ACTIVO', 'Avanzado', 2022, '659 msnm', '73°09''13''''', '7°08''35''''', 'Actualizó', 'Se realizo visita y se actualizo ficha de verificacion', null, 'Sí', 'Acueducto', null, null, null, 'No', 'No', null, 'Sí', null, null, null, null, null, null, null, null, null, null, 'Sí', 'B2B', 'No', 'NO', 'Contribuye al reciclaje y reducción de residuos industriales.', 'Genera empleo especializado y fomenta la economía circular.', 'Alta demanda del mercado industrial.', false, true, true, false, true
where not exists (select 1 from negocios where nombre = 'JRVG RECUPERADORA S.A.S.');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'JRVG RECUPERADORA S.A.S.');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'JRVG RECUPERADORA S.A.S.'), (select id from categorias_oficiales where slug = 'ecoproductos-industriales');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'JRVG RECUPERADORA S.A.S.');
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'JRVG RECUPERADORA S.A.S.');
insert into negocios_actividades (negocio_id, actividad_productiva_id) select (select id from negocios where nombre = 'JRVG RECUPERADORA S.A.S.'), id from actividades_productivas where slug = 'aprovechamiento-residuos-inorganicos';
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'JRVG RECUPERADORA S.A.S.'), 2023, 0.61 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'JRVG RECUPERADORA S.A.S.'), 2024, 81.1 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'JRVG RECUPERADORA S.A.S.'), 2025, 75.0 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;

-- SUCULENTAS HERRERA
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'),
  municipio = 'Lebrija',
  vereda_id = (select id from veredas where municipio = 'Lebrija' and slug = 'el-cosme'),
  direccion = 'CALLE 16 #8-02 LOTE 9 PARCELA LA HERRERA, VEREDA EL COSME',
  latitud = 7.119191666666667,
  longitud = -73.21480555555556,
  descripcion_corta = 'Plantar y reproducir suculentas',
  descripcion = 'Plantar y reproducir suculentas',
  producto = 'SUCULENTAS',
  telefono = '318 5379989',
  whatsapp = '318 5379989',
  email = 'laherrera.1501@gmaill.com',
  representante_legal = 'LUZ AMANDA HERRERA FLOREZ',
  nit = '28217963',
  naturaleza_juridica = null,
  delegado = null,
  rut_camara_comercio = null,
  responsable_cdmb = 'DANIEL BONNET',
  novedad = 'SUSPENDIDO',
  tipo_negocio_verde = 'Dinamizadoras',
  anio_registro = 2023,
  cota_msnm = '1.016 msnm',
  este = '73°12''53,3''''',
  norte = '7°7''9,09''''',
  aplicacion_ficha_2025 = 'Actualizó',
  observaciones = 'Se realizo visita y se aplico ficha de verificacion',
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
where nombre = 'SUCULENTAS HERRERA';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select 'a8ff5d94-d250-4c4f-81cc-66182f5c3d10', 'SUCULENTAS HERRERA', generar_slug_unico('SUCULENTAS HERRERA', 'a8ff5d94-d250-4c4f-81cc-66182f5c3d10'), (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'), 'Lebrija', (select id from veredas where municipio = 'Lebrija' and slug = 'el-cosme'), 'CALLE 16 #8-02 LOTE 9 PARCELA LA HERRERA, VEREDA EL COSME', 7.119191666666667, -73.21480555555556, 'Plantar y reproducir suculentas', 'Plantar y reproducir suculentas', 'SUCULENTAS', '318 5379989', '318 5379989', 'laherrera.1501@gmaill.com', 'LUZ AMANDA HERRERA FLOREZ', '28217963', null, null, null, 'DANIEL BONNET', 'SUSPENDIDO', 'Dinamizadoras', 2023, '1.016 msnm', '73°12''53,3''''', '7°7''9,09''''', 'Actualizó', 'Se realizo visita y se aplico ficha de verificacion', null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, true, false, false, false, false
where not exists (select 1 from negocios where nombre = 'SUCULENTAS HERRERA');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'SUCULENTAS HERRERA');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'SUCULENTAS HERRERA'), (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'SUCULENTAS HERRERA');
insert into negocios_subcategorias (negocio_id, subcategoria_id) select (select id from negocios where nombre = 'SUCULENTAS HERRERA'), id from subcategorias where slug = 'agrosistemas-sostenibles';
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'SUCULENTAS HERRERA');
insert into negocios_actividades (negocio_id, actividad_productiva_id) select (select id from negocios where nombre = 'SUCULENTAS HERRERA'), id from actividades_productivas where slug = 'agricultura-organica';
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'SUCULENTAS HERRERA'), 2024, 23.1 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;

-- CHOCONELA
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'),
  municipio = 'Lebrija',
  vereda_id = (select id from veredas where municipio = 'Lebrija' and slug = 'la-cuchilla'),
  direccion = 'VEREDA LA CUCHILLA FINCA TIERRA BUENA LOTE 2',
  latitud = 7.138333333333334,
  longitud = -73.29583333333333,
  descripcion_corta = 'Producción, transformación y comercialización de de cacao endulzado con panela en diferentes porcentajes, chocolate en barra al 100%, nibs de cacao, cacao…',
  descripcion = 'Producción, transformación y comercialización de de cacao endulzado con panela en diferentes porcentajes, chocolate en barra al 100%, nibs de cacao, cacao en polvo, manteca de cacao y sabajon de cacao.',
  producto = 'CHOCOLATE DE MESA',
  telefono = '3174753323',
  whatsapp = '573174753323',
  email = 'luzardila747@gmail.com',
  representante_legal = 'LUZ MERY ARDILA ORTIZ',
  nit = '30203851-2',
  naturaleza_juridica = 'Natural',
  delegado = null,
  rut_camara_comercio = 'Cámara de comercio',
  responsable_cdmb = 'XIMENA REYES',
  novedad = 'ACTIVO',
  tipo_negocio_verde = 'Intermedio',
  anio_registro = 2023,
  cota_msnm = '1003 msnm',
  este = '73°17''45''''',
  norte = '7°8''18''''',
  aplicacion_ficha_2025 = 'Actualizó',
  observaciones = 'Se realizo visita y se actualizo ficha de verificacion',
  registro_nacional_turismo = null,
  uso_suelo = 'No',
  concesion_aguas = 'Sí',
  concesion_aguas_vencimiento = '2028-12-19',
  vertimientos = null,
  vertimientos_vencimiento = null,
  pueaa = 'No',
  pgris = 'No',
  pozo_septico = 'Sí',
  alcantarillado = null,
  ica = null,
  ica_vencimiento = null,
  invima = 'Sí',
  invima_vencimiento = '2035-10-16',
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
  fortalezas_ambiental = 'Se desarrollan acciones como implementación de sistemas agroforestales, estrategias de restauración y reforestación con especies nativas o endémicas, cercas vivas, rescate de plántulas, fertilización orgánica, entre otros.  No se utilizan materiales peligrosos y/o tóxicos en los procesos. Se realizan acciones para reducir mensualmente el consumo de agua. No realiza vertimientos.',
  fortalezas_social = 'Contratación con enfoque diferencial. Encadenamiento comercial.',
  fortalezas_economico = 'Lleva registro de ventas en libro contable.',
  emprendimiento_verde = true,
  sello_marca = false,
  avalado = false,
  destacado = false,
  activo = true
where nombre = 'CHOCONELA';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select '444103d8-3c9d-49e0-baea-3047bb1c3e9f', 'CHOCONELA', generar_slug_unico('CHOCONELA', '444103d8-3c9d-49e0-baea-3047bb1c3e9f'), (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'), 'Lebrija', (select id from veredas where municipio = 'Lebrija' and slug = 'la-cuchilla'), 'VEREDA LA CUCHILLA FINCA TIERRA BUENA LOTE 2', 7.138333333333334, -73.29583333333333, 'Producción, transformación y comercialización de de cacao endulzado con panela en diferentes porcentajes, chocolate en barra al 100%, nibs de cacao, cacao…', 'Producción, transformación y comercialización de de cacao endulzado con panela en diferentes porcentajes, chocolate en barra al 100%, nibs de cacao, cacao en polvo, manteca de cacao y sabajon de cacao.', 'CHOCOLATE DE MESA', '3174753323', '573174753323', 'luzardila747@gmail.com', 'LUZ MERY ARDILA ORTIZ', '30203851-2', 'Natural', null, 'Cámara de comercio', 'XIMENA REYES', 'ACTIVO', 'Intermedio', 2023, '1003 msnm', '73°17''45''''', '7°8''18''''', 'Actualizó', 'Se realizo visita y se actualizo ficha de verificacion', null, 'No', 'Sí', '2028-12-19', null, null, 'No', 'No', 'Sí', null, null, null, 'Sí', '2035-10-16', null, 'No', null, null, null, null, 'No', 'Mixta', 'No', 'NO', 'Se desarrollan acciones como implementación de sistemas agroforestales, estrategias de restauración y reforestación con especies nativas o endémicas, cercas vivas, rescate de plántulas, fertilización orgánica, entre otros.  No se utilizan materiales peligrosos y/o tóxicos en los procesos. Se realizan acciones para reducir mensualmente el consumo de agua. No realiza vertimientos.', 'Contratación con enfoque diferencial. Encadenamiento comercial.', 'Lleva registro de ventas en libro contable.', true, false, false, false, true
where not exists (select 1 from negocios where nombre = 'CHOCONELA');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'CHOCONELA');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'CHOCONELA'), (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'CHOCONELA');
insert into negocios_subcategorias (negocio_id, subcategoria_id) select (select id from negocios where nombre = 'CHOCONELA'), id from subcategorias where slug = 'agroindustria-sostenible';
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'CHOCONELA');
insert into negocios_actividades (negocio_id, actividad_productiva_id) select (select id from negocios where nombre = 'CHOCONELA'), id from actividades_productivas where slug = 'agroindustrial-alimentario';
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'CHOCONELA'), 2024, 38.2 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'CHOCONELA'), 2025, 42.7 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;

-- ESTUCASA
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'pendiente-clasificar'),
  municipio = 'Floridablanca',
  vereda_id = null,
  direccion = 'Puente sobre quebrada Aguablanca Anillo vial Giron, El caucho. FLORIDABLANCA',
  latitud = 7.063027777777777,
  longitud = -73.12730555555555,
  descripcion_corta = null,
  descripcion = null,
  producto = 'PSICOLA - PECES',
  telefono = '3012428215',
  whatsapp = '573012428215',
  email = 'guanes62@gmail.com',
  representante_legal = 'MANUEL ENRIQUE PRADA',
  nit = null,
  naturaleza_juridica = null,
  delegado = null,
  rut_camara_comercio = null,
  responsable_cdmb = null,
  novedad = 'RETIRADO',
  tipo_negocio_verde = 'No aplica',
  anio_registro = 2022,
  cota_msnm = '748 msnm',
  este = '73°7''38,3''''',
  norte = '7°3''46,9''''',
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
where nombre = 'ESTUCASA';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select '517eb7df-9e06-4ef5-8940-af2c127da223', 'ESTUCASA', generar_slug_unico('ESTUCASA', '517eb7df-9e06-4ef5-8940-af2c127da223'), (select id from categorias_oficiales where slug = 'pendiente-clasificar'), 'Floridablanca', null, 'Puente sobre quebrada Aguablanca Anillo vial Giron, El caucho. FLORIDABLANCA', 7.063027777777777, -73.12730555555555, null, null, 'PSICOLA - PECES', '3012428215', '573012428215', 'guanes62@gmail.com', 'MANUEL ENRIQUE PRADA', null, null, null, null, null, 'RETIRADO', 'No aplica', 2022, '748 msnm', '73°7''38,3''''', '7°3''46,9''''', null, 'NO Ingresa al programa', null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, true, false, false, false, false
where not exists (select 1 from negocios where nombre = 'ESTUCASA');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'ESTUCASA');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'ESTUCASA'), (select id from categorias_oficiales where slug = 'pendiente-clasificar');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'ESTUCASA');
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'ESTUCASA');


commit;
