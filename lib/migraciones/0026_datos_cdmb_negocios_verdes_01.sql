begin;

-- Generado por lib/migraciones/generar_0026.py desde BASE_ACTUALIZADA_NV_ka.xlsx — no editar a mano.
-- Uno de varios archivos partidos (ver README.md) — correr TODOS, en cualquier orden, cada uno es su propia transacción.

-- Parte 1 de 17.

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

-- COOPERATIVA DE TRABAJO ASOCIADO RECICLAJE Y SERVICIOS - COOPRESER
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'pendiente-clasificar'),
  municipio = 'Bucaramanga',
  vereda_id = null,
  direccion = 'Calle 19 # 20-46 Bucaramanga',
  latitud = null,
  longitud = null,
  descripcion_corta = null,
  descripcion = null,
  producto = 'RECICLAJE DE PLASTICO',
  telefono = '3158512363',
  whatsapp = '573158512363',
  email = 'coopreser@telebucaramanga.net.com',
  representante_legal = 'ELSA MARIA DE LA TORRE',
  nit = '800013252-8',
  naturaleza_juridica = null,
  delegado = null,
  rut_camara_comercio = null,
  responsable_cdmb = 'PIER FRATALLI',
  novedad = 'RETIRADO',
  tipo_negocio_verde = null,
  anio_registro = 2018,
  cota_msnm = null,
  este = null,
  norte = null,
  aplicacion_ficha_2025 = null,
  observaciones = 'Posible retiro',
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
where nombre = 'COOPERATIVA DE TRABAJO ASOCIADO RECICLAJE Y SERVICIOS - COOPRESER';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select 'e4e2c179-7726-4cd2-9a54-7469c4414703', 'COOPERATIVA DE TRABAJO ASOCIADO RECICLAJE Y SERVICIOS - COOPRESER', generar_slug_unico('COOPERATIVA DE TRABAJO ASOCIADO RECICLAJE Y SERVICIOS - COOPRESER', 'e4e2c179-7726-4cd2-9a54-7469c4414703'), (select id from categorias_oficiales where slug = 'pendiente-clasificar'), 'Bucaramanga', null, 'Calle 19 # 20-46 Bucaramanga', null, null, null, null, 'RECICLAJE DE PLASTICO', '3158512363', '573158512363', 'coopreser@telebucaramanga.net.com', 'ELSA MARIA DE LA TORRE', '800013252-8', null, null, null, 'PIER FRATALLI', 'RETIRADO', null, 2018, null, null, null, null, 'Posible retiro', null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, true, false, false, false, false
where not exists (select 1 from negocios where nombre = 'COOPERATIVA DE TRABAJO ASOCIADO RECICLAJE Y SERVICIOS - COOPRESER');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'COOPERATIVA DE TRABAJO ASOCIADO RECICLAJE Y SERVICIOS - COOPRESER');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'COOPERATIVA DE TRABAJO ASOCIADO RECICLAJE Y SERVICIOS - COOPRESER'), (select id from categorias_oficiales where slug = 'pendiente-clasificar');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'COOPERATIVA DE TRABAJO ASOCIADO RECICLAJE Y SERVICIOS - COOPRESER');
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'COOPERATIVA DE TRABAJO ASOCIADO RECICLAJE Y SERVICIOS - COOPRESER');

-- INVERSIONES ECOAGUAS S.A.S
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'),
  municipio = 'Suratá',
  vereda_id = (select id from veredas where municipio = 'Suratá' and slug = 'vereda-porvenir'),
  direccion = 'VEREDA PORVENIR FINCA LOS ANDES, SURATA',
  latitud = 7.383901111111111,
  longitud = -72.97686111111112,
  descripcion_corta = 'La empresa se especializa en la comercialización sostenible de agua, garantizando la calidad del recurso, la responsabilidad ambiental y la eficiencia en su…',
  descripcion = 'La empresa se especializa en la comercialización sostenible de agua, garantizando la calidad del recurso, la responsabilidad ambiental y la eficiencia en su uso. Implementa buenas prácticas en todas las etapas del proceso, priorizando la reducción de desperdicios, la optimización del consumo y la preservación de las fuentes hídricas. Su compromiso es ofrecer un servicio confiable que contribuya al bienestar de las comunidades y al equilibrio ambiental.',
  producto = 'AGUA NATURAL 300 CC',
  telefono = '3043628459',
  whatsapp = '573043628459',
  email = 'ing.quimico@jsservipetrol.com',
  representante_legal = 'JOSEPH JUSCELINO BADILLO SANTO DOMINGO',
  nit = '900882299-3',
  naturaleza_juridica = 'Jurídica',
  delegado = 'VLADIMIR LEON',
  rut_camara_comercio = 'Cámara de comercio',
  responsable_cdmb = 'HEINER ORTIZ',
  novedad = 'ACTIVO',
  tipo_negocio_verde = 'Satisfactorio',
  anio_registro = 2023,
  cota_msnm = '999 msnm',
  este = '72°58''36.700"',
  norte = '7°23''2.044"',
  aplicacion_ficha_2025 = 'Actualizó',
  observaciones = 'Se realizo visita y se actualizo ficha de verificacion',
  registro_nacional_turismo = null,
  uso_suelo = 'No',
  concesion_aguas = 'Sí',
  concesion_aguas_vencimiento = '2026-07-08',
  vertimientos = null,
  vertimientos_vencimiento = null,
  pueaa = 'No',
  pgris = 'No',
  pozo_septico = 'Sí',
  alcantarillado = null,
  ica = null,
  ica_vencimiento = null,
  invima = 'Sí',
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
  fortalezas_ambiental = 'Promueve acceso a agua potable',
  fortalezas_social = 'Impacto en salud pública positiva',
  fortalezas_economico = 'Producto de alta demanda',
  emprendimiento_verde = true,
  sello_marca = false,
  avalado = false,
  destacado = false,
  activo = true
where nombre = 'INVERSIONES ECOAGUAS S.A.S';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select '47c50d57-5c86-40c5-ad5c-c1f5154812b2', 'INVERSIONES ECOAGUAS S.A.S', generar_slug_unico('INVERSIONES ECOAGUAS S.A.S', '47c50d57-5c86-40c5-ad5c-c1f5154812b2'), (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'), 'Suratá', (select id from veredas where municipio = 'Suratá' and slug = 'vereda-porvenir'), 'VEREDA PORVENIR FINCA LOS ANDES, SURATA', 7.383901111111111, -72.97686111111112, 'La empresa se especializa en la comercialización sostenible de agua, garantizando la calidad del recurso, la responsabilidad ambiental y la eficiencia en su…', 'La empresa se especializa en la comercialización sostenible de agua, garantizando la calidad del recurso, la responsabilidad ambiental y la eficiencia en su uso. Implementa buenas prácticas en todas las etapas del proceso, priorizando la reducción de desperdicios, la optimización del consumo y la preservación de las fuentes hídricas. Su compromiso es ofrecer un servicio confiable que contribuya al bienestar de las comunidades y al equilibrio ambiental.', 'AGUA NATURAL 300 CC', '3043628459', '573043628459', 'ing.quimico@jsservipetrol.com', 'JOSEPH JUSCELINO BADILLO SANTO DOMINGO', '900882299-3', 'Jurídica', 'VLADIMIR LEON', 'Cámara de comercio', 'HEINER ORTIZ', 'ACTIVO', 'Satisfactorio', 2023, '999 msnm', '72°58''36.700"', '7°23''2.044"', 'Actualizó', 'Se realizo visita y se actualizo ficha de verificacion', null, 'No', 'Sí', '2026-07-08', null, null, 'No', 'No', 'Sí', null, null, null, 'Sí', null, null, null, null, null, null, null, 'Sí', 'Mixta', 'No', 'NO', 'Promueve acceso a agua potable', 'Impacto en salud pública positiva', 'Producto de alta demanda', true, false, false, false, true
where not exists (select 1 from negocios where nombre = 'INVERSIONES ECOAGUAS S.A.S');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'INVERSIONES ECOAGUAS S.A.S');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'INVERSIONES ECOAGUAS S.A.S'), (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'INVERSIONES ECOAGUAS S.A.S');
insert into negocios_subcategorias (negocio_id, subcategoria_id) select (select id from negocios where nombre = 'INVERSIONES ECOAGUAS S.A.S'), id from subcategorias where slug = 'agroindustria-sostenible';
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'INVERSIONES ECOAGUAS S.A.S');
insert into negocios_actividades (negocio_id, actividad_productiva_id) select (select id from negocios where nombre = 'INVERSIONES ECOAGUAS S.A.S'), id from actividades_productivas where slug = 'agroindustrial-alimentario';
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'INVERSIONES ECOAGUAS S.A.S'), 2023, 65.22 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'INVERSIONES ECOAGUAS S.A.S'), 2024, 71.0 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'INVERSIONES ECOAGUAS S.A.S'), 2025, 55.6 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;

-- SERVICENTRO DEPRISA
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'calidad-ambiental'),
  municipio = 'Bucaramanga',
  vereda_id = (select id from veredas where municipio = 'Bucaramanga' and slug = 'perimetro-urbano'),
  direccion = 'CR 13 #17 - 55  BARRIO GAITAN',
  latitud = 7.129819166666667,
  longitud = -73.13155666666665,
  descripcion_corta = 'Presta el servicio de lavado de vehiculos usando tecnologia para el recirculación de las aguas residuales.  comercializa al detalle lubricantes, aditivos y…',
  descripcion = 'Presta el servicio de lavado de vehiculos usando tecnologia para el recirculación de las aguas residuales.  comercializa al detalle lubricantes, aditivos y productos de limpieza.',
  producto = 'ECOLAVADO DE VEHÍCULOS',
  telefono = '3118138101',
  whatsapp = '573118138101',
  email = 'deprisa.ger74@gmail.com',
  representante_legal = 'LUIS GERMAN GONZALEZ GUZMAN',
  nit = '79707463-1',
  naturaleza_juridica = 'Natural',
  delegado = null,
  rut_camara_comercio = 'Cámara de comercio',
  responsable_cdmb = 'SEBASTIAN BONNET',
  novedad = 'ACTIVO',
  tipo_negocio_verde = 'Dinamizadoras',
  anio_registro = 2018,
  cota_msnm = '946 msnm',
  este = '73°7''53.604''''',
  norte = '7°7''47.349''''',
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
  canal_venta = 'Mixta',
  exportacion = 'No',
  huella_carbono = 'NO',
  fortalezas_ambiental = 'Buenas practicas Ambientales como tener paneles solares , la recirculación de agua que realiza la empresa en el momento de prestar su servicio.',
  fortalezas_social = 'Generación de empleo local y fortalecimiento del tejido comunitario',
  fortalezas_economico = 'Alto valor agregado. Diversificación de ingresos.',
  emprendimiento_verde = false,
  sello_marca = true,
  avalado = true,
  destacado = false,
  activo = true
where nombre = 'SERVICENTRO DEPRISA';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select '2fa19e45-ce3e-4d09-bdfb-3751a2bdf5e7', 'SERVICENTRO DEPRISA', generar_slug_unico('SERVICENTRO DEPRISA', '2fa19e45-ce3e-4d09-bdfb-3751a2bdf5e7'), (select id from categorias_oficiales where slug = 'calidad-ambiental'), 'Bucaramanga', (select id from veredas where municipio = 'Bucaramanga' and slug = 'perimetro-urbano'), 'CR 13 #17 - 55  BARRIO GAITAN', 7.129819166666667, -73.13155666666665, 'Presta el servicio de lavado de vehiculos usando tecnologia para el recirculación de las aguas residuales.  comercializa al detalle lubricantes, aditivos y…', 'Presta el servicio de lavado de vehiculos usando tecnologia para el recirculación de las aguas residuales.  comercializa al detalle lubricantes, aditivos y productos de limpieza.', 'ECOLAVADO DE VEHÍCULOS', '3118138101', '573118138101', 'deprisa.ger74@gmail.com', 'LUIS GERMAN GONZALEZ GUZMAN', '79707463-1', 'Natural', null, 'Cámara de comercio', 'SEBASTIAN BONNET', 'ACTIVO', 'Dinamizadoras', 2018, '946 msnm', '73°7''53.604''''', '7°7''47.349''''', 'Actualizó', 'Se realizo visita y se aplico ficha de verificacion', null, 'Sí', 'Acueducto', null, null, null, 'No', 'Sí', null, 'Sí', null, null, null, null, null, null, null, null, null, null, 'Sí', 'Mixta', 'No', 'NO', 'Buenas practicas Ambientales como tener paneles solares , la recirculación de agua que realiza la empresa en el momento de prestar su servicio.', 'Generación de empleo local y fortalecimiento del tejido comunitario', 'Alto valor agregado. Diversificación de ingresos.', false, true, true, false, true
where not exists (select 1 from negocios where nombre = 'SERVICENTRO DEPRISA');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'SERVICENTRO DEPRISA');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'SERVICENTRO DEPRISA'), (select id from categorias_oficiales where slug = 'calidad-ambiental');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'SERVICENTRO DEPRISA');
insert into negocios_subcategorias (negocio_id, subcategoria_id) select (select id from negocios where nombre = 'SERVICENTRO DEPRISA'), id from subcategorias where slug = 'tecnologias-verdes';
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'SERVICENTRO DEPRISA');
insert into negocios_actividades (negocio_id, actividad_productiva_id) select (select id from negocios where nombre = 'SERVICENTRO DEPRISA'), id from actividades_productivas where slug = 'tecnologias-informacion-ambiental';
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'SERVICENTRO DEPRISA'), 2020, 55.48 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'SERVICENTRO DEPRISA'), 2021, 56.08 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'SERVICENTRO DEPRISA'), 2022, 70.06 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'SERVICENTRO DEPRISA'), 2023, 74.49 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'SERVICENTRO DEPRISA'), 2024, 92.3 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'SERVICENTRO DEPRISA'), 2025, 91.1 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;

-- CIUDAD BELLA
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'pendiente-clasificar'),
  municipio = 'Piedecuesta',
  vereda_id = null,
  direccion = 'CALLE 7 # 7 -39 PIEDECUESTA',
  latitud = 7.088888888888889,
  longitud = -73.15805555555556,
  descripcion_corta = null,
  descripcion = null,
  producto = 'RECICLAJE DE PLASTICO',
  telefono = '3183066325',
  whatsapp = '573183066325',
  email = 'monica.chinchilla@gmail.com',
  representante_legal = 'MÓNICA CHINCHILLA',
  nit = '900262472',
  naturaleza_juridica = null,
  delegado = null,
  rut_camara_comercio = null,
  responsable_cdmb = 'PIER FRATALLI',
  novedad = 'RETIRADO',
  tipo_negocio_verde = null,
  anio_registro = 2016,
  cota_msnm = '732 msnm',
  este = '73°9''29''''',
  norte = '7°5''20''''',
  aplicacion_ficha_2025 = null,
  observaciones = 'Posible retiro',
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
where nombre = 'CIUDAD BELLA';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select 'acf214af-76db-4e01-937a-13ba858c2df7', 'CIUDAD BELLA', generar_slug_unico('CIUDAD BELLA', 'acf214af-76db-4e01-937a-13ba858c2df7'), (select id from categorias_oficiales where slug = 'pendiente-clasificar'), 'Piedecuesta', null, 'CALLE 7 # 7 -39 PIEDECUESTA', 7.088888888888889, -73.15805555555556, null, null, 'RECICLAJE DE PLASTICO', '3183066325', '573183066325', 'monica.chinchilla@gmail.com', 'MÓNICA CHINCHILLA', '900262472', null, null, null, 'PIER FRATALLI', 'RETIRADO', null, 2016, '732 msnm', '73°9''29''''', '7°5''20''''', null, 'Posible retiro', null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, true, false, false, false, false
where not exists (select 1 from negocios where nombre = 'CIUDAD BELLA');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'CIUDAD BELLA');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'CIUDAD BELLA'), (select id from categorias_oficiales where slug = 'pendiente-clasificar');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'CIUDAD BELLA');
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'CIUDAD BELLA');

-- REPLASANDER S.A.S.
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'ecoproductos-industriales'),
  municipio = 'Girón',
  vereda_id = (select id from veredas where municipio = 'Girón' and slug = 'perimetro-urbano'),
  direccion = 'CRA 14 # 57-139 KM 7 VÍA GIRÓN',
  latitud = 7.0841666666666665,
  longitud = -73.16305555555556,
  descripcion_corta = 'Recicla plástico y lo transforma como materia prima para la industria plástica nacional e internacional',
  descripcion = 'Recicla plástico y lo transforma como materia prima para la industria plástica nacional e internacional',
  producto = 'PET POLIPROPILENO, POLIETILENO, POLIESTIRENO',
  telefono = '3168338448 - 3124312197',
  whatsapp = '3168338448 - 3124312197',
  email = 'replasanderltda@hotmail.com, replasander.ambiental@gmail.com',
  representante_legal = 'JAIME ENRIQUE HENAO HOYOS',
  nit = '890211496-4',
  naturaleza_juridica = 'Jurídica',
  delegado = null,
  rut_camara_comercio = 'Cámara de comercio',
  responsable_cdmb = 'CLAUDIA SANCHEZ',
  novedad = 'ACTIVO',
  tipo_negocio_verde = 'Dinamizadoras',
  anio_registro = 2018,
  cota_msnm = '709.3 msnm',
  este = '73°9''47''''',
  norte = '7°5''3''''',
  aplicacion_ficha_2025 = 'Actualizó',
  observaciones = 'Se realizo visita y se actualizo ficha de verificacion',
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
  huella_carbono = 'SI',
  fortalezas_ambiental = 'Paneles solares,tratamiento de aguas',
  fortalezas_social = 'Promueven la educación y conciencia sobre la importancia del reciclaje y la sostenibilidad.',
  fortalezas_economico = 'tienen capacidad para transformar 150 toneladas de material reciclable al mes',
  emprendimiento_verde = false,
  sello_marca = true,
  avalado = true,
  destacado = false,
  activo = true
where nombre = 'REPLASANDER S.A.S.';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select '3ce7fc12-5305-4ec2-abcb-e0f9def78d6e', 'REPLASANDER S.A.S.', generar_slug_unico('REPLASANDER S.A.S.', '3ce7fc12-5305-4ec2-abcb-e0f9def78d6e'), (select id from categorias_oficiales where slug = 'ecoproductos-industriales'), 'Girón', (select id from veredas where municipio = 'Girón' and slug = 'perimetro-urbano'), 'CRA 14 # 57-139 KM 7 VÍA GIRÓN', 7.0841666666666665, -73.16305555555556, 'Recicla plástico y lo transforma como materia prima para la industria plástica nacional e internacional', 'Recicla plástico y lo transforma como materia prima para la industria plástica nacional e internacional', 'PET POLIPROPILENO, POLIETILENO, POLIESTIRENO', '3168338448 - 3124312197', '3168338448 - 3124312197', 'replasanderltda@hotmail.com, replasander.ambiental@gmail.com', 'JAIME ENRIQUE HENAO HOYOS', '890211496-4', 'Jurídica', null, 'Cámara de comercio', 'CLAUDIA SANCHEZ', 'ACTIVO', 'Dinamizadoras', 2018, '709.3 msnm', '73°9''47''''', '7°5''3''''', 'Actualizó', 'Se realizo visita y se actualizo ficha de verificacion', null, 'Sí', 'Acueducto', null, null, null, 'No', 'Sí', null, 'Sí', null, null, null, null, null, null, null, null, null, null, 'Sí', 'B2B', 'No', 'SI', 'Paneles solares,tratamiento de aguas', 'Promueven la educación y conciencia sobre la importancia del reciclaje y la sostenibilidad.', 'tienen capacidad para transformar 150 toneladas de material reciclable al mes', false, true, true, false, true
where not exists (select 1 from negocios where nombre = 'REPLASANDER S.A.S.');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'REPLASANDER S.A.S.');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'REPLASANDER S.A.S.'), (select id from categorias_oficiales where slug = 'ecoproductos-industriales');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'REPLASANDER S.A.S.');
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'REPLASANDER S.A.S.');
insert into negocios_actividades (negocio_id, actividad_productiva_id) select (select id from negocios where nombre = 'REPLASANDER S.A.S.'), id from actividades_productivas where slug = 'aprovechamiento-residuos-inorganicos';
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'REPLASANDER S.A.S.'), 2020, 57.87 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'REPLASANDER S.A.S.'), 2021, 68.11 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'REPLASANDER S.A.S.'), 2022, 70.14 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'REPLASANDER S.A.S.'), 2023, 71.03 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'REPLASANDER S.A.S.'), 2024, 68.9 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'REPLASANDER S.A.S.'), 2025, 73.1 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;

-- BIORECYCLE DE COLOMBIA S.A.S
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'pendiente-clasificar'),
  municipio = 'Girón',
  vereda_id = null,
  direccion = 'VIA GIRON KILOMETRO 7 CARRERA 13 # 70 - 106',
  latitud = 7.139722222222223,
  longitud = -73.23777777777778,
  descripcion_corta = 'La empresa desarrolla un impacto ambiental positivo al hacer parte de la cadena de valor que integra los procesos de reciclaje, tratamiento, aprovechamiento…',
  descripcion = 'La empresa desarrolla un impacto ambiental positivo al hacer parte de la cadena de valor que integra los procesos de reciclaje, tratamiento, aprovechamiento y valoración de residuos inorgánicos, buscando su reintegración al ciclo productivo y ampliando la vida útil de estos materiales. La empresa aporta en la reducción de la contaminación dado que se ha especializado en el tratamiento de los residuos como el polietileno, polipropileno y poliestileno, además del PET, desarrollando una cadena de suministro que integra alianzas con las organizaciones de recicladores de oficio, así como comercialización con empresas que aportan en la agregación de valor de los productos.',
  producto = 'RECICLAJE DE PLASTICO',
  telefono = '3134535704',
  whatsapp = '573134535704',
  email = 'biorecycledecolombia@hotmail.com',
  representante_legal = 'Arelis del Carmen Chavez Bohorquez',
  nit = '901089288-5',
  naturaleza_juridica = null,
  delegado = null,
  rut_camara_comercio = null,
  responsable_cdmb = 'SILVIA GARCIA',
  novedad = 'INACTIVO',
  tipo_negocio_verde = 'Inicial',
  anio_registro = 2021,
  cota_msnm = '1.007 msnm',
  este = '73°14''16''''',
  norte = '7°08''23''''',
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
where nombre = 'BIORECYCLE DE COLOMBIA S.A.S';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select '6c4b2df8-d91d-4949-a154-cda24839c2f8', 'BIORECYCLE DE COLOMBIA S.A.S', generar_slug_unico('BIORECYCLE DE COLOMBIA S.A.S', '6c4b2df8-d91d-4949-a154-cda24839c2f8'), (select id from categorias_oficiales where slug = 'pendiente-clasificar'), 'Girón', null, 'VIA GIRON KILOMETRO 7 CARRERA 13 # 70 - 106', 7.139722222222223, -73.23777777777778, 'La empresa desarrolla un impacto ambiental positivo al hacer parte de la cadena de valor que integra los procesos de reciclaje, tratamiento, aprovechamiento…', 'La empresa desarrolla un impacto ambiental positivo al hacer parte de la cadena de valor que integra los procesos de reciclaje, tratamiento, aprovechamiento y valoración de residuos inorgánicos, buscando su reintegración al ciclo productivo y ampliando la vida útil de estos materiales. La empresa aporta en la reducción de la contaminación dado que se ha especializado en el tratamiento de los residuos como el polietileno, polipropileno y poliestileno, además del PET, desarrollando una cadena de suministro que integra alianzas con las organizaciones de recicladores de oficio, así como comercialización con empresas que aportan en la agregación de valor de los productos.', 'RECICLAJE DE PLASTICO', '3134535704', '573134535704', 'biorecycledecolombia@hotmail.com', 'Arelis del Carmen Chavez Bohorquez', '901089288-5', null, null, null, 'SILVIA GARCIA', 'INACTIVO', 'Inicial', 2021, '1.007 msnm', '73°14''16''''', '7°08''23''''', null, 'Continua en el programa', null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, false, false, true, false, false
where not exists (select 1 from negocios where nombre = 'BIORECYCLE DE COLOMBIA S.A.S');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'BIORECYCLE DE COLOMBIA S.A.S');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'BIORECYCLE DE COLOMBIA S.A.S'), (select id from categorias_oficiales where slug = 'pendiente-clasificar');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'BIORECYCLE DE COLOMBIA S.A.S');
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'BIORECYCLE DE COLOMBIA S.A.S');
insert into negocios_actividades (negocio_id, actividad_productiva_id) select (select id from negocios where nombre = 'BIORECYCLE DE COLOMBIA S.A.S'), id from actividades_productivas where slug = 'productos-biotecnologia';
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'BIORECYCLE DE COLOMBIA S.A.S'), 2021, 67.11 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'BIORECYCLE DE COLOMBIA S.A.S'), 2022, 73.62 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'BIORECYCLE DE COLOMBIA S.A.S'), 2023, 75.05 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;

-- BIOFLY S.A.S BIC
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'ecoproductos-industriales'),
  municipio = 'Lebrija',
  vereda_id = (select id from veredas where municipio = 'Lebrija' and slug = 'perimetro-urbano'),
  direccion = 'CALLE 12 # 23 - 235 PREDIO LAS BRISAS LEBRIJA',
  latitud = 7.124227222222221,
  longitud = -73.23654277777779,
  descripcion_corta = 'Biofly colombia es una empresa creada en Santander, Colombia, sin embargo, desarrolla el proceso productivo y comercial también en México (Mérida, Yucatán).…',
  descripcion = 'Biofly colombia es una empresa creada en Santander, Colombia, sin embargo, desarrolla el proceso productivo y comercial también en México (Mérida, Yucatán). La empresa cuenta con tres líneas de producción biológica generadas a partir de la Hermetia Illucens (Mosca Soldado Negro); proteina de Insecto, Biofertilizante/bioestimulante y el servicio de valorización de residuos orgánicos. El esquema de comercialización se desarrolla a través del voz a voz, redes sociales y representante comercial en México y colombia .  Igualmente, atienden público en general aunque no con ventas continuas (piscicultores, avicultores, entre otros) aumento en valorizacion de residuos con aliados estrategicos como postobon , alpina , fraskaleche  , tambien se transforma materia de residuos de las tiendas oxxo',
  producto = 'PROTEÍNA DE INSECTO',
  telefono = '3046336421',
  whatsapp = '573046336421',
  email = 'info@residua.bio',
  representante_legal = 'CARLOS FERNANDEZ DE LA PRADILLA MARTINEZ',
  nit = '901653010-4',
  naturaleza_juridica = 'Jurídica',
  delegado = 'DIEGO VILLAMIL',
  rut_camara_comercio = 'Cámara de comercio',
  responsable_cdmb = 'DIANA NAVARRO',
  novedad = 'ACTIVO',
  tipo_negocio_verde = 'Dinamizadoras',
  anio_registro = 2021,
  cota_msnm = '969 msnm',
  este = '73°14''11,554',
  norte = '7°7''27,218''''',
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
  pozo_septico = null,
  alcantarillado = 'Sí',
  ica = 'No',
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
  canal_venta = 'B2B',
  exportacion = 'No',
  huella_carbono = 'NO',
  fortalezas_ambiental = 'Disminicion de contaminacion en los rellenos sanitarios',
  fortalezas_social = 'Generación de empleo local y fortalecimiento del tejido comunitario',
  fortalezas_economico = 'Es una empresa que tiene una excelente organización en el componente económico además es una empresa muy solida en el mercado',
  emprendimiento_verde = false,
  sello_marca = true,
  avalado = true,
  destacado = false,
  activo = true
where nombre = 'BIOFLY S.A.S BIC';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select 'e08320d2-565d-4047-8e51-6b732ffe45ec', 'BIOFLY S.A.S BIC', generar_slug_unico('BIOFLY S.A.S BIC', 'e08320d2-565d-4047-8e51-6b732ffe45ec'), (select id from categorias_oficiales where slug = 'ecoproductos-industriales'), 'Lebrija', (select id from veredas where municipio = 'Lebrija' and slug = 'perimetro-urbano'), 'CALLE 12 # 23 - 235 PREDIO LAS BRISAS LEBRIJA', 7.124227222222221, -73.23654277777779, 'Biofly colombia es una empresa creada en Santander, Colombia, sin embargo, desarrolla el proceso productivo y comercial también en México (Mérida, Yucatán).…', 'Biofly colombia es una empresa creada en Santander, Colombia, sin embargo, desarrolla el proceso productivo y comercial también en México (Mérida, Yucatán). La empresa cuenta con tres líneas de producción biológica generadas a partir de la Hermetia Illucens (Mosca Soldado Negro); proteina de Insecto, Biofertilizante/bioestimulante y el servicio de valorización de residuos orgánicos. El esquema de comercialización se desarrolla a través del voz a voz, redes sociales y representante comercial en México y colombia .  Igualmente, atienden público en general aunque no con ventas continuas (piscicultores, avicultores, entre otros) aumento en valorizacion de residuos con aliados estrategicos como postobon , alpina , fraskaleche  , tambien se transforma materia de residuos de las tiendas oxxo', 'PROTEÍNA DE INSECTO', '3046336421', '573046336421', 'info@residua.bio', 'CARLOS FERNANDEZ DE LA PRADILLA MARTINEZ', '901653010-4', 'Jurídica', 'DIEGO VILLAMIL', 'Cámara de comercio', 'DIANA NAVARRO', 'ACTIVO', 'Dinamizadoras', 2021, '969 msnm', '73°14''11,554', '7°7''27,218''''', 'Actualizó', 'Se realizo visita y se aplico ficha de verificacion', null, 'Sí', 'Acueducto veredal', null, null, null, 'No', 'No', null, 'Sí', 'No', null, null, null, null, null, null, null, null, null, 'No', 'B2B', 'No', 'NO', 'Disminicion de contaminacion en los rellenos sanitarios', 'Generación de empleo local y fortalecimiento del tejido comunitario', 'Es una empresa que tiene una excelente organización en el componente económico además es una empresa muy solida en el mercado', false, true, true, false, true
where not exists (select 1 from negocios where nombre = 'BIOFLY S.A.S BIC');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'BIOFLY S.A.S BIC');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'BIOFLY S.A.S BIC'), (select id from categorias_oficiales where slug = 'ecoproductos-industriales');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'BIOFLY S.A.S BIC');
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'BIOFLY S.A.S BIC');
insert into negocios_actividades (negocio_id, actividad_productiva_id) select (select id from negocios where nombre = 'BIOFLY S.A.S BIC'), id from actividades_productivas where slug = 'aprovechamiento-residuos-organicos';
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'BIOFLY S.A.S BIC'), 2021, 74.4 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'BIOFLY S.A.S BIC'), 2022, 82.31 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'BIOFLY S.A.S BIC'), 2023, 83.72 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'BIOFLY S.A.S BIC'), 2024, 84.4 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'BIOFLY S.A.S BIC'), 2025, 87.2 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;

-- ESE LATINO
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'ecoproductos-industriales'),
  municipio = 'Floridablanca',
  vereda_id = null,
  direccion = 'Finca Villalupe vereda Casiano Sector La Cidra',
  latitud = 7.118888888888889,
  longitud = -73.11749999999999,
  descripcion_corta = 'Genera un impacto ambiental positivo al reducir la contaminación mediante la agregación de valor a un material como el vidrio, desarrollando un producto de…',
  descripcion = 'Genera un impacto ambiental positivo al reducir la contaminación mediante la agregación de valor a un material como el vidrio, desarrollando un producto de uso práctico con un componente estético e innovador. El vidrio proviene de fuentes recuperadas, a través de un proceso de recolección -cooperación Recicling-.  La empresa se articula a la estrategia de economía circular al dar valoración a los residuos, optimizar su aprovechamiento y promover una gestión ambiental eficiente.',
  producto = 'PRODUCTOS DE VIDRIO RECICLADO',
  telefono = '318 7906909',
  whatsapp = '318 7906909',
  email = 'eselatino@gmail.com',
  representante_legal = 'WILLIAM  OMAR ARIAS CORREA',
  nit = '13514624-1',
  naturaleza_juridica = null,
  delegado = null,
  rut_camara_comercio = null,
  responsable_cdmb = 'ALVARO ALFEREZ',
  novedad = 'SUSPENDIDO',
  tipo_negocio_verde = 'Inicial',
  anio_registro = 2021,
  cota_msnm = '1014 msnm',
  este = '73°07''03"',
  norte = '7°07''08"',
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
where nombre = 'ESE LATINO';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select '50621f9a-3fff-453c-a194-ffee3faf3496', 'ESE LATINO', generar_slug_unico('ESE LATINO', '50621f9a-3fff-453c-a194-ffee3faf3496'), (select id from categorias_oficiales where slug = 'ecoproductos-industriales'), 'Floridablanca', null, 'Finca Villalupe vereda Casiano Sector La Cidra', 7.118888888888889, -73.11749999999999, 'Genera un impacto ambiental positivo al reducir la contaminación mediante la agregación de valor a un material como el vidrio, desarrollando un producto de…', 'Genera un impacto ambiental positivo al reducir la contaminación mediante la agregación de valor a un material como el vidrio, desarrollando un producto de uso práctico con un componente estético e innovador. El vidrio proviene de fuentes recuperadas, a través de un proceso de recolección -cooperación Recicling-.  La empresa se articula a la estrategia de economía circular al dar valoración a los residuos, optimizar su aprovechamiento y promover una gestión ambiental eficiente.', 'PRODUCTOS DE VIDRIO RECICLADO', '318 7906909', '318 7906909', 'eselatino@gmail.com', 'WILLIAM  OMAR ARIAS CORREA', '13514624-1', null, null, null, 'ALVARO ALFEREZ', 'SUSPENDIDO', 'Inicial', 2021, '1014 msnm', '73°07''03"', '7°07''08"', null, 'Continua en el programa', null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, false, false, true, false, false
where not exists (select 1 from negocios where nombre = 'ESE LATINO');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'ESE LATINO');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'ESE LATINO'), (select id from categorias_oficiales where slug = 'ecoproductos-industriales');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'ESE LATINO');
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'ESE LATINO');
insert into negocios_actividades (negocio_id, actividad_productiva_id) select (select id from negocios where nombre = 'ESE LATINO'), id from actividades_productivas where slug = 'aprovechamiento-residuos-inorganicos';
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'ESE LATINO'), 2021, 53.92 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'ESE LATINO'), 2022, 59.29 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'ESE LATINO'), 2023, 64.74 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;

-- COOPSEREC
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'ecoproductos-industriales'),
  municipio = 'Bucaramanga',
  vereda_id = (select id from veredas where municipio = 'Bucaramanga' and slug = 'perimetro-urbano'),
  direccion = 'CARRERA 9 #36N 30',
  latitud = null,
  longitud = -73.13815000000001,
  descripcion_corta = 'La cooperativa tiene como objetivo reciclar  materiales aprovechables y brindar capacitación orientada a la comunidad en general.',
  descripcion = 'La cooperativa tiene como objetivo reciclar  materiales aprovechables y brindar capacitación orientada a la comunidad en general.',
  producto = 'RECICLAJE, TRANSFORMACIÓN Y COMERCIO DE PLÁSTICO',
  telefono = '3227724885',
  whatsapp = '573227724885',
  email = 'gerencia.coopserec@gmail.com',
  representante_legal = 'JOSE LUIS BADILLO ALVARADO',
  nit = '901380946-1',
  naturaleza_juridica = 'Jurídica',
  delegado = null,
  rut_camara_comercio = 'Cámara de comercio y RUT',
  responsable_cdmb = 'CLAUDIA SANCHEZ',
  novedad = 'SUSPENDIDO',
  tipo_negocio_verde = 'Dinamizadoras',
  anio_registro = 2021,
  cota_msnm = '624.9 msnm',
  este = '73°8''17.340"',
  norte = '7°9''53669"',
  aplicacion_ficha_2025 = 'Actualizó',
  observaciones = 'Se realizo visita y se aplico ficha de verificacion',
  registro_nacional_turismo = null,
  uso_suelo = 'Sí',
  concesion_aguas = null,
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
  exportacion = null,
  huella_carbono = null,
  fortalezas_ambiental = 'La cooperativa tiene como objetivo reciclar  materiales aprovechables y brindar capacitaciòn orientada a la comunidad en general.',
  fortalezas_social = 'Es una empresa con un componente social muy alto , capacita a su personal , a las familias de sus empleados también son capacitados en el enfoque ambiental , y maneja una contratación con enfoque diferencial.',
  fortalezas_economico = 'la cooperativa se encuentra actualmente con buenos ingresos y se encuentra buscando como seguir ampliando el mercado local.',
  emprendimiento_verde = false,
  sello_marca = true,
  avalado = true,
  destacado = false,
  activo = false
where nombre = 'COOPSEREC';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select 'bf52ea8f-8916-4a93-8f1b-7d53648e3313', 'COOPSEREC', generar_slug_unico('COOPSEREC', 'bf52ea8f-8916-4a93-8f1b-7d53648e3313'), (select id from categorias_oficiales where slug = 'ecoproductos-industriales'), 'Bucaramanga', (select id from veredas where municipio = 'Bucaramanga' and slug = 'perimetro-urbano'), 'CARRERA 9 #36N 30', null, -73.13815000000001, 'La cooperativa tiene como objetivo reciclar  materiales aprovechables y brindar capacitación orientada a la comunidad en general.', 'La cooperativa tiene como objetivo reciclar  materiales aprovechables y brindar capacitación orientada a la comunidad en general.', 'RECICLAJE, TRANSFORMACIÓN Y COMERCIO DE PLÁSTICO', '3227724885', '573227724885', 'gerencia.coopserec@gmail.com', 'JOSE LUIS BADILLO ALVARADO', '901380946-1', 'Jurídica', null, 'Cámara de comercio y RUT', 'CLAUDIA SANCHEZ', 'SUSPENDIDO', 'Dinamizadoras', 2021, '624.9 msnm', '73°8''17.340"', '7°9''53669"', 'Actualizó', 'Se realizo visita y se aplico ficha de verificacion', null, 'Sí', null, null, null, null, 'No', 'Sí', null, 'Sí', null, null, null, null, null, null, null, null, null, null, 'Sí', 'B2B', null, null, 'La cooperativa tiene como objetivo reciclar  materiales aprovechables y brindar capacitaciòn orientada a la comunidad en general.', 'Es una empresa con un componente social muy alto , capacita a su personal , a las familias de sus empleados también son capacitados en el enfoque ambiental , y maneja una contratación con enfoque diferencial.', 'la cooperativa se encuentra actualmente con buenos ingresos y se encuentra buscando como seguir ampliando el mercado local.', false, true, true, false, false
where not exists (select 1 from negocios where nombre = 'COOPSEREC');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'COOPSEREC');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'COOPSEREC'), (select id from categorias_oficiales where slug = 'ecoproductos-industriales');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'COOPSEREC');
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'COOPSEREC');
insert into negocios_actividades (negocio_id, actividad_productiva_id) select (select id from negocios where nombre = 'COOPSEREC'), id from actividades_productivas where slug = 'aprovechamiento-residuos-inorganicos';
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'COOPSEREC'), 2022, 61.11 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'COOPSEREC'), 2023, 66.11 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'COOPSEREC'), 2024, 86.0 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'COOPSEREC'), 2025, 84.4 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;

-- CAUCHOS RECICLADOS DE COLOMBIA S.A.S.
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'ecoproductos-industriales'),
  municipio = 'Bucaramanga',
  vereda_id = (select id from veredas where municipio = 'Bucaramanga' and slug = 'perimetro-urbano'),
  direccion = 'CALLE 23 # 6A-25 BARRIO GIRARDOT',
  latitud = 7.091666666666667,
  longitud = -73.10583333333332,
  descripcion_corta = 'La sociedad podrá realizar cualquier actividad civil o comercial lícita. Y venta de suministros, equipos y herramientas industriales para las industrias…',
  descripcion = 'La sociedad podrá realizar cualquier actividad civil o comercial lícita. Y venta de suministros, equipos y herramientas industriales para las industrias petroleras, petroquìmicas, termodinámicas, electrificadoras, gaseoductos civil, minera y médica.',
  producto = 'CAUCHO RECICLADO',
  telefono = '3022387389',
  whatsapp = '573022387389',
  email = 'cauchosrecicladosdecolombia@gmail.com',
  representante_legal = 'CLAUDIA MILENA ROJAS PRADA',
  nit = '901158970-7',
  naturaleza_juridica = 'Jurídica',
  delegado = null,
  rut_camara_comercio = 'Cámara de comercio y RUT',
  responsable_cdmb = 'CLAUDIA SANCHEZ',
  novedad = 'SUSPENDIDO',
  tipo_negocio_verde = 'Dinamizadoras',
  anio_registro = 2021,
  cota_msnm = '934 msnm',
  este = '73°06''21''''',
  norte = '7°05''30''''',
  aplicacion_ficha_2025 = 'Actualizó',
  observaciones = null,
  registro_nacional_turismo = null,
  uso_suelo = 'Sí',
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
  sstt = 'No',
  canal_venta = 'B2B',
  exportacion = null,
  huella_carbono = null,
  fortalezas_ambiental = 'Contribuye significativamente al manejo y aprovechamiento de residuos peligrosos (llantas usadas). Reduce la contaminación del suelo y de fuentes hídricas al evitar quemas o acumulación de llantas,Producto final (granulado o polvo de caucho) favorece la pavimentación sostenible al mejorar la durabilidad del asfalto.
 Cuenta con sello de Marca de Negocios Verdes, lo que respalda su compromiso ambiental., Procesos de producción con bajo impacto ambiental comparado con la disposición inadecuada de llantas.',
  fortalezas_social = 'Genera empleo formal en un sector técnico y ambientalmente responsable.
 , Aporta a la conciencia ciudadana sobre reciclaje y economía circular.
, Promueve la articulación con talleres, municipios y gestores de residuos.
 Contribuye a mejorar la seguridad y estética de las comunidades al eliminar focos de llantas acumuladas.',
  fortalezas_economico = 'Posee maquinaria moderna y eficiente para el triturado y procesamiento del caucho.
 • Procesos estandarizados que garantizan calidad en el material final.
 • Tiene un producto con alta demanda potencial en proyectos de pavimentación sostenible.
Reconocimiento por su marca verde, que puede aprovecharse para contratos o licitaciones públicas.',
  emprendimiento_verde = false,
  sello_marca = true,
  avalado = true,
  destacado = false,
  activo = false
where nombre = 'CAUCHOS RECICLADOS DE COLOMBIA S.A.S.';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select '3dcdc4d5-1de5-481d-892a-5ceedf36dd2e', 'CAUCHOS RECICLADOS DE COLOMBIA S.A.S.', generar_slug_unico('CAUCHOS RECICLADOS DE COLOMBIA S.A.S.', '3dcdc4d5-1de5-481d-892a-5ceedf36dd2e'), (select id from categorias_oficiales where slug = 'ecoproductos-industriales'), 'Bucaramanga', (select id from veredas where municipio = 'Bucaramanga' and slug = 'perimetro-urbano'), 'CALLE 23 # 6A-25 BARRIO GIRARDOT', 7.091666666666667, -73.10583333333332, 'La sociedad podrá realizar cualquier actividad civil o comercial lícita. Y venta de suministros, equipos y herramientas industriales para las industrias…', 'La sociedad podrá realizar cualquier actividad civil o comercial lícita. Y venta de suministros, equipos y herramientas industriales para las industrias petroleras, petroquìmicas, termodinámicas, electrificadoras, gaseoductos civil, minera y médica.', 'CAUCHO RECICLADO', '3022387389', '573022387389', 'cauchosrecicladosdecolombia@gmail.com', 'CLAUDIA MILENA ROJAS PRADA', '901158970-7', 'Jurídica', null, 'Cámara de comercio y RUT', 'CLAUDIA SANCHEZ', 'SUSPENDIDO', 'Dinamizadoras', 2021, '934 msnm', '73°06''21''''', '7°05''30''''', 'Actualizó', null, null, 'Sí', 'Acueducto', null, null, null, null, 'Sí', null, 'Sí', null, null, null, null, null, null, null, null, null, null, 'No', 'B2B', null, null, 'Contribuye significativamente al manejo y aprovechamiento de residuos peligrosos (llantas usadas). Reduce la contaminación del suelo y de fuentes hídricas al evitar quemas o acumulación de llantas,Producto final (granulado o polvo de caucho) favorece la pavimentación sostenible al mejorar la durabilidad del asfalto.
 Cuenta con sello de Marca de Negocios Verdes, lo que respalda su compromiso ambiental., Procesos de producción con bajo impacto ambiental comparado con la disposición inadecuada de llantas.', 'Genera empleo formal en un sector técnico y ambientalmente responsable.
 , Aporta a la conciencia ciudadana sobre reciclaje y economía circular.
, Promueve la articulación con talleres, municipios y gestores de residuos.
 Contribuye a mejorar la seguridad y estética de las comunidades al eliminar focos de llantas acumuladas.', 'Posee maquinaria moderna y eficiente para el triturado y procesamiento del caucho.
 • Procesos estandarizados que garantizan calidad en el material final.
 • Tiene un producto con alta demanda potencial en proyectos de pavimentación sostenible.
Reconocimiento por su marca verde, que puede aprovecharse para contratos o licitaciones públicas.', false, true, true, false, false
where not exists (select 1 from negocios where nombre = 'CAUCHOS RECICLADOS DE COLOMBIA S.A.S.');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'CAUCHOS RECICLADOS DE COLOMBIA S.A.S.');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'CAUCHOS RECICLADOS DE COLOMBIA S.A.S.'), (select id from categorias_oficiales where slug = 'ecoproductos-industriales');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'CAUCHOS RECICLADOS DE COLOMBIA S.A.S.');
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'CAUCHOS RECICLADOS DE COLOMBIA S.A.S.');
insert into negocios_actividades (negocio_id, actividad_productiva_id) select (select id from negocios where nombre = 'CAUCHOS RECICLADOS DE COLOMBIA S.A.S.'), id from actividades_productivas where slug = 'aprovechamiento-residuos-inorganicos';
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'CAUCHOS RECICLADOS DE COLOMBIA S.A.S.'), 2022, 62.18 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'CAUCHOS RECICLADOS DE COLOMBIA S.A.S.'), 2023, 72.6 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'CAUCHOS RECICLADOS DE COLOMBIA S.A.S.'), 2024, 92.0 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'CAUCHOS RECICLADOS DE COLOMBIA S.A.S.'), 2025, 71.5 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;

-- ECOJARDINES BIO S.A.S.
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'calidad-ambiental'),
  municipio = 'Bucaramanga',
  vereda_id = (select id from veredas where municipio = 'Bucaramanga' and slug = 'perimetro-urbano'),
  direccion = 'CARRERA 18 · 4 -23 OF. 1302 B. LA LIBERTAD',
  latitud = 7.132477499999999,
  longitud = -73.10894166666667,
  descripcion_corta = 'Las actividades agricolas a cambio de una retribuciòn o por contrata, como: acondicionamiento de terrenos, plantaciòn o siembra de cultivos, plantaciòn o…',
  descripcion = 'Las actividades agricolas a cambio de una retribuciòn o por contrata, como: acondicionamiento de terrenos, plantaciòn o siembra de cultivos, plantaciòn o siembra de arboles, tratamiento de cultivos, fumigaciòn de cultivos, incluida la fumigaciòn aèrea, poda de àrboles frutales y viñas.',
  producto = 'ASESORIAS Y SERVICIO AMBIENTALES',
  telefono = '3107740515',
  whatsapp = '573107740515',
  email = 'ecojardines1@hotmail.com',
  representante_legal = 'JUAN EUSEBIO OLAYA',
  nit = '901817272-2',
  naturaleza_juridica = 'Jurídica',
  delegado = null,
  rut_camara_comercio = 'Cámara de comercio',
  responsable_cdmb = 'ANDRES VALDERRAMA',
  novedad = 'ACTIVO',
  tipo_negocio_verde = 'Dinamizadoras',
  anio_registro = 2018,
  cota_msnm = '1069',
  este = '73°6''32.190''''',
  norte = '7°7''56.919''''',
  aplicacion_ficha_2025 = 'Actualizó',
  observaciones = 'Se realizo visita y se actualizo ficha de verificacion',
  registro_nacional_turismo = null,
  uso_suelo = null,
  concesion_aguas = 'Acueducto',
  concesion_aguas_vencimiento = null,
  vertimientos = null,
  vertimientos_vencimiento = null,
  pueaa = 'No',
  pgris = 'No',
  pozo_septico = null,
  alcantarillado = 'Sí',
  ica = 'No',
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
  canal_venta = 'Mixta',
  exportacion = 'No',
  huella_carbono = 'NO',
  fortalezas_ambiental = 'El plus de trabajar de la mano con las FFMM -El buen nombre de estar apoyado por los militares -Tener el reconocimiento como Negocio Verde',
  fortalezas_social = 'Aceptación por la gran mayoría de comunidades -Apoyos socio económicos por estar trabajando de la mano con FFMM',
  fortalezas_economico = 'El ya estar facturando -El pagar impuestos -El tener todos   los requisitos legales al día',
  emprendimiento_verde = true,
  sello_marca = false,
  avalado = false,
  destacado = false,
  activo = true
where nombre = 'ECOJARDINES BIO S.A.S.';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select '64c56432-c607-4aac-ac9e-08f73650814d', 'ECOJARDINES BIO S.A.S.', generar_slug_unico('ECOJARDINES BIO S.A.S.', '64c56432-c607-4aac-ac9e-08f73650814d'), (select id from categorias_oficiales where slug = 'calidad-ambiental'), 'Bucaramanga', (select id from veredas where municipio = 'Bucaramanga' and slug = 'perimetro-urbano'), 'CARRERA 18 · 4 -23 OF. 1302 B. LA LIBERTAD', 7.132477499999999, -73.10894166666667, 'Las actividades agricolas a cambio de una retribuciòn o por contrata, como: acondicionamiento de terrenos, plantaciòn o siembra de cultivos, plantaciòn o…', 'Las actividades agricolas a cambio de una retribuciòn o por contrata, como: acondicionamiento de terrenos, plantaciòn o siembra de cultivos, plantaciòn o siembra de arboles, tratamiento de cultivos, fumigaciòn de cultivos, incluida la fumigaciòn aèrea, poda de àrboles frutales y viñas.', 'ASESORIAS Y SERVICIO AMBIENTALES', '3107740515', '573107740515', 'ecojardines1@hotmail.com', 'JUAN EUSEBIO OLAYA', '901817272-2', 'Jurídica', null, 'Cámara de comercio', 'ANDRES VALDERRAMA', 'ACTIVO', 'Dinamizadoras', 2018, '1069', '73°6''32.190''''', '7°7''56.919''''', 'Actualizó', 'Se realizo visita y se actualizo ficha de verificacion', null, null, 'Acueducto', null, null, null, 'No', 'No', null, 'Sí', 'No', null, null, null, null, null, null, null, null, null, 'No', 'Mixta', 'No', 'NO', 'El plus de trabajar de la mano con las FFMM -El buen nombre de estar apoyado por los militares -Tener el reconocimiento como Negocio Verde', 'Aceptación por la gran mayoría de comunidades -Apoyos socio económicos por estar trabajando de la mano con FFMM', 'El ya estar facturando -El pagar impuestos -El tener todos   los requisitos legales al día', true, false, false, false, true
where not exists (select 1 from negocios where nombre = 'ECOJARDINES BIO S.A.S.');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'ECOJARDINES BIO S.A.S.');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'ECOJARDINES BIO S.A.S.'), (select id from categorias_oficiales where slug = 'calidad-ambiental');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'ECOJARDINES BIO S.A.S.');
insert into negocios_subcategorias (negocio_id, subcategoria_id) select (select id from negocios where nombre = 'ECOJARDINES BIO S.A.S.'), id from subcategorias where slug = 'preservacion-restauracion-ecosistemas';
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'ECOJARDINES BIO S.A.S.');
insert into negocios_actividades (negocio_id, actividad_productiva_id) select (select id from negocios where nombre = 'ECOJARDINES BIO S.A.S.'), id from actividades_productivas where slug = 'restauracion';
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'ECOJARDINES BIO S.A.S.'), 2020, 48.18 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'ECOJARDINES BIO S.A.S.'), 2021, 59.85 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'ECOJARDINES BIO S.A.S.'), 2022, 46.97 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'ECOJARDINES BIO S.A.S.'), 2023, 56.89 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'ECOJARDINES BIO S.A.S.'), 2024, 59.4 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'ECOJARDINES BIO S.A.S.'), 2025, 68.3 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;

-- VINOS OVIEDO S.A.S.
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'),
  municipio = 'Bucaramanga',
  vereda_id = (select id from veredas where municipio = 'Bucaramanga' and slug = 'perimetro-urbano'),
  direccion = 'DIAGONAL 105 # 31-16 LOCAL 1003 PLAZA SATELITE',
  latitud = 7.343583333333333,
  longitud = -73.11552777777777,
  descripcion_corta = 'Producción de vinos naturales artesanales de frutas exóticas y en vía de extinción como el corozo costeño y el Agraz. Como principio fundamental tienen la…',
  descripcion = 'Producción de vinos naturales artesanales de frutas exóticas y en vía de extinción como el corozo costeño y el Agraz. Como principio fundamental tienen la asepsia en todos sus procesos para garantizar unos productos bajo los mejores estándares de salubridad y calidad.  Cuentan con Registro sanitario y Buenas prácticas de manufactura otorgado por el INVIMA.',
  producto = 'VINO DE AGRAZ',
  telefono = '3016569414',
  whatsapp = '573016569414',
  email = 'vinosoviedosas@gmail.com',
  representante_legal = 'ANA ISABEL OVIEDO GÓMEZ',
  nit = '900672879-4',
  naturaleza_juridica = 'Jurídica',
  delegado = null,
  rut_camara_comercio = 'Cámara de comercio',
  responsable_cdmb = 'XIMENA REYES',
  novedad = 'ACTIVO',
  tipo_negocio_verde = 'Dinamizadoras',
  anio_registro = 2018,
  cota_msnm = '1.300 msnm',
  este = '73°06''55,9''''',
  norte = '7°20''36,9''''',
  aplicacion_ficha_2025 = 'Actualizó',
  observaciones = 'Se realizo visita y se actualizo ficha de verificacion',
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
  invima = 'Sí',
  invima_vencimiento = '2032-09-30',
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
  fortalezas_ambiental = 'Minimo consumo de agua',
  fortalezas_social = 'Generan empleos indirectos y contribuyen con el desarrollo de la Región',
  fortalezas_economico = 'Margen de utilidad por unidad y no tienen costos fijos altos',
  emprendimiento_verde = false,
  sello_marca = false,
  avalado = true,
  destacado = false,
  activo = true
where nombre = 'VINOS OVIEDO S.A.S.';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select '330e9fcd-8a80-4b94-b240-f1e75f4d618a', 'VINOS OVIEDO S.A.S.', generar_slug_unico('VINOS OVIEDO S.A.S.', '330e9fcd-8a80-4b94-b240-f1e75f4d618a'), (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'), 'Bucaramanga', (select id from veredas where municipio = 'Bucaramanga' and slug = 'perimetro-urbano'), 'DIAGONAL 105 # 31-16 LOCAL 1003 PLAZA SATELITE', 7.343583333333333, -73.11552777777777, 'Producción de vinos naturales artesanales de frutas exóticas y en vía de extinción como el corozo costeño y el Agraz. Como principio fundamental tienen la…', 'Producción de vinos naturales artesanales de frutas exóticas y en vía de extinción como el corozo costeño y el Agraz. Como principio fundamental tienen la asepsia en todos sus procesos para garantizar unos productos bajo los mejores estándares de salubridad y calidad.  Cuentan con Registro sanitario y Buenas prácticas de manufactura otorgado por el INVIMA.', 'VINO DE AGRAZ', '3016569414', '573016569414', 'vinosoviedosas@gmail.com', 'ANA ISABEL OVIEDO GÓMEZ', '900672879-4', 'Jurídica', null, 'Cámara de comercio', 'XIMENA REYES', 'ACTIVO', 'Dinamizadoras', 2018, '1.300 msnm', '73°06''55,9''''', '7°20''36,9''''', 'Actualizó', 'Se realizo visita y se actualizo ficha de verificacion', null, 'No', 'Acueducto', null, null, null, 'No', 'No', null, 'Sí', null, null, 'Sí', '2032-09-30', null, null, null, null, null, null, 'No', 'B2C', 'No', 'NO', 'Minimo consumo de agua', 'Generan empleos indirectos y contribuyen con el desarrollo de la Región', 'Margen de utilidad por unidad y no tienen costos fijos altos', false, false, true, false, true
where not exists (select 1 from negocios where nombre = 'VINOS OVIEDO S.A.S.');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'VINOS OVIEDO S.A.S.');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'VINOS OVIEDO S.A.S.'), (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'VINOS OVIEDO S.A.S.');
insert into negocios_subcategorias (negocio_id, subcategoria_id) select (select id from negocios where nombre = 'VINOS OVIEDO S.A.S.'), id from subcategorias where slug = 'agroindustria-sostenible';
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'VINOS OVIEDO S.A.S.');
insert into negocios_actividades (negocio_id, actividad_productiva_id) select (select id from negocios where nombre = 'VINOS OVIEDO S.A.S.'), id from actividades_productivas where slug = 'agroindustrial-alimentario';
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'VINOS OVIEDO S.A.S.'), 2020, 51.76 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'VINOS OVIEDO S.A.S.'), 2021, 58.14 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'VINOS OVIEDO S.A.S.'), 2022, 64.17 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'VINOS OVIEDO S.A.S.'), 2023, 65.7 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'VINOS OVIEDO S.A.S.'), 2024, 58.4 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'VINOS OVIEDO S.A.S.'), 2025, 58.4 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;

-- SAINSA S.A.S
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'),
  municipio = 'Charta',
  vereda_id = (select id from veredas where municipio = 'Charta' and slug = 'perimetro-urbano'),
  direccion = 'CARRERA 3 # 3-31',
  latitud = 7.286388888888888,
  longitud = -73.00444444444445,
  descripcion_corta = 'Producción de cultivo de Sacha Inchi de forma orgánica, mantenimiento, y limpieza de cultivos, con procesos que no generan contaminación al ambiente, y en…',
  descripcion = 'Producción de cultivo de Sacha Inchi de forma orgánica, mantenimiento, y limpieza de cultivos, con procesos que no generan contaminación al ambiente, y en la parte de transformación se realiza de forma limpia sin adictivos ni conservantes, es un producto ecológico y limpio',
  producto = 'ACEITE DE SACHA INCHI',
  telefono = '3123602215',
  whatsapp = '573123602215',
  email = 'santandersachainchi@gmail.com',
  representante_legal = 'VICENTE LOPEZ GERENA',
  nit = '901082576-1',
  naturaleza_juridica = 'Jurídica',
  delegado = null,
  rut_camara_comercio = 'Cámara de comercio',
  responsable_cdmb = 'ANDRES VALDERRAMA',
  novedad = 'ACTIVO',
  tipo_negocio_verde = 'Dinamizadoras',
  anio_registro = 2018,
  cota_msnm = '1899.0 msnm',
  este = '73°0''16''''',
  norte = '7°17''11''''',
  aplicacion_ficha_2025 = 'Actualizó',
  observaciones = 'Se realizo visita y se actualizo ficha de verificacion',
  registro_nacional_turismo = null,
  uso_suelo = 'No',
  concesion_aguas = 'Acueducto',
  concesion_aguas_vencimiento = null,
  vertimientos = null,
  vertimientos_vencimiento = null,
  pueaa = 'No',
  pgris = 'No',
  pozo_septico = 'Sí',
  alcantarillado = 'Sí',
  ica = null,
  ica_vencimiento = null,
  invima = 'Sí',
  invima_vencimiento = '2026-08-11',
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
  fortalezas_ambiental = 'Garantizamos un proceso totalmente libre de agroquímicos -Respetamos la frontera agrícola y utilizamos labranza mínima para proteger el 
suelo y la biodiversidad. -Empleamos microorganismos eficientes para nutrir nuestros suelos',
  fortalezas_social = 'Seguridad alimentaria al incentivar el cultivo de pancoger en el cultivo de sacha 
inchi. -Fomenta empleos inclusivos para mujeres y jóvenes. -Ofrece una alternativa lícita y sostenible en regiones afectadas por cultivos 
ilícitos o economías extractivas. -Incentiva la organización de productores en asociaciones y cooperativas. -Promueve el trabajo colectivo y el fortalecimiento del tejido social. -Genera ingresos complementarios para pequeños agricultores 
➢ Reduce la dependencia de monocultivos tradicionales 
➢ Fortalece la identidad cultural en torno a productos locales y sostenibles 
➢ Ofrece oportunidades de liderazgo y emprendimiento 
➢ Estimula conocimiento ancestral en intergeneracional en prácticas agrícolas  
➢ Fomenta hábitos alimentarios saludables',
  fortalezas_economico = 'Demanda creciente por productos saludables, como aceites ricos en omega 3, 
6 y 9. -Potencial exportador hacia mercados europeos, asiáticos y norteamericanos. -Posibilidad de transformar el producto en aceite, harina, snacks, cosméticos, 
aumentando los márgenes de ganancia. -Oportunidades para el desarrollo de marcas locales y productos diferenciados. -Cosechas periódicas a lo largo del año, permitiendo un flujo de ingresos relativamente constante. Rápida entrada en producción (de 8 a 10 meses tras la siembra). -Inversión inicial moderada en infraestructura y mantenimiento. -Dinamiza la economía local mediante la creación de empleos en producción 
transformación y comercialización 
➢ Permite posicionar productos premium en nichos de mercado (alimentos 
funcionales, nutracéuticos, cosmética natural) 
➢ Promueve cadenas cortas de comercialización (ferias, mercados locales, venta 
directa)',
  emprendimiento_verde = false,
  sello_marca = false,
  avalado = true,
  destacado = false,
  activo = true
where nombre = 'SAINSA S.A.S';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select 'cdcccda3-0618-4cea-bc21-bab395c2f189', 'SAINSA S.A.S', generar_slug_unico('SAINSA S.A.S', 'cdcccda3-0618-4cea-bc21-bab395c2f189'), (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'), 'Charta', (select id from veredas where municipio = 'Charta' and slug = 'perimetro-urbano'), 'CARRERA 3 # 3-31', 7.286388888888888, -73.00444444444445, 'Producción de cultivo de Sacha Inchi de forma orgánica, mantenimiento, y limpieza de cultivos, con procesos que no generan contaminación al ambiente, y en…', 'Producción de cultivo de Sacha Inchi de forma orgánica, mantenimiento, y limpieza de cultivos, con procesos que no generan contaminación al ambiente, y en la parte de transformación se realiza de forma limpia sin adictivos ni conservantes, es un producto ecológico y limpio', 'ACEITE DE SACHA INCHI', '3123602215', '573123602215', 'santandersachainchi@gmail.com', 'VICENTE LOPEZ GERENA', '901082576-1', 'Jurídica', null, 'Cámara de comercio', 'ANDRES VALDERRAMA', 'ACTIVO', 'Dinamizadoras', 2018, '1899.0 msnm', '73°0''16''''', '7°17''11''''', 'Actualizó', 'Se realizo visita y se actualizo ficha de verificacion', null, 'No', 'Acueducto', null, null, null, 'No', 'No', 'Sí', 'Sí', null, null, 'Sí', '2026-08-11', null, 'No', null, null, null, null, 'No', 'Mixta', 'No', 'NO', 'Garantizamos un proceso totalmente libre de agroquímicos -Respetamos la frontera agrícola y utilizamos labranza mínima para proteger el 
suelo y la biodiversidad. -Empleamos microorganismos eficientes para nutrir nuestros suelos', 'Seguridad alimentaria al incentivar el cultivo de pancoger en el cultivo de sacha 
inchi. -Fomenta empleos inclusivos para mujeres y jóvenes. -Ofrece una alternativa lícita y sostenible en regiones afectadas por cultivos 
ilícitos o economías extractivas. -Incentiva la organización de productores en asociaciones y cooperativas. -Promueve el trabajo colectivo y el fortalecimiento del tejido social. -Genera ingresos complementarios para pequeños agricultores 
➢ Reduce la dependencia de monocultivos tradicionales 
➢ Fortalece la identidad cultural en torno a productos locales y sostenibles 
➢ Ofrece oportunidades de liderazgo y emprendimiento 
➢ Estimula conocimiento ancestral en intergeneracional en prácticas agrícolas  
➢ Fomenta hábitos alimentarios saludables', 'Demanda creciente por productos saludables, como aceites ricos en omega 3, 
6 y 9. -Potencial exportador hacia mercados europeos, asiáticos y norteamericanos. -Posibilidad de transformar el producto en aceite, harina, snacks, cosméticos, 
aumentando los márgenes de ganancia. -Oportunidades para el desarrollo de marcas locales y productos diferenciados. -Cosechas periódicas a lo largo del año, permitiendo un flujo de ingresos relativamente constante. Rápida entrada en producción (de 8 a 10 meses tras la siembra). -Inversión inicial moderada en infraestructura y mantenimiento. -Dinamiza la economía local mediante la creación de empleos en producción 
transformación y comercialización 
➢ Permite posicionar productos premium en nichos de mercado (alimentos 
funcionales, nutracéuticos, cosmética natural) 
➢ Promueve cadenas cortas de comercialización (ferias, mercados locales, venta 
directa)', false, false, true, false, true
where not exists (select 1 from negocios where nombre = 'SAINSA S.A.S');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'SAINSA S.A.S');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'SAINSA S.A.S'), (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'SAINSA S.A.S');
insert into negocios_subcategorias (negocio_id, subcategoria_id) select (select id from negocios where nombre = 'SAINSA S.A.S'), id from subcategorias where slug = 'agroindustria-sostenible';
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'SAINSA S.A.S');
insert into negocios_actividades (negocio_id, actividad_productiva_id) select (select id from negocios where nombre = 'SAINSA S.A.S'), id from actividades_productivas where slug = 'agroindustrial-alimentario';
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'SAINSA S.A.S'), 2020, 53.05 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'SAINSA S.A.S'), 2021, 64.83 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'SAINSA S.A.S'), 2022, 66.68 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'SAINSA S.A.S'), 2023, 66.68 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'SAINSA S.A.S'), 2024, 59.0 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'SAINSA S.A.S'), 2025, 59.0 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;

-- ASOCIACION MUNICIPAL DE  MUJERES  CAMPESINAS DE MATANZA ASOCIMUCAM
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'pendiente-clasificar'),
  municipio = 'Matanza',
  vereda_id = null,
  direccion = 'Finca Limoncito',
  latitud = null,
  longitud = null,
  descripcion_corta = null,
  descripcion = null,
  producto = 'FRUTAS Y HORTALIZAS',
  telefono = '3174854366',
  whatsapp = '573174854366',
  email = 'asocimucam2013@hotmail.com',
  representante_legal = 'ANA MERCEDES FLORES',
  nit = '804015982-1',
  naturaleza_juridica = null,
  delegado = null,
  rut_camara_comercio = null,
  responsable_cdmb = null,
  novedad = 'RETIRADO',
  tipo_negocio_verde = null,
  anio_registro = 2018,
  cota_msnm = '1.541 msnm',
  este = '1112592',
  norte = '1250103',
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
where nombre = 'ASOCIACION MUNICIPAL DE  MUJERES  CAMPESINAS DE MATANZA ASOCIMUCAM';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select 'ba4fc0f1-1696-4587-83d4-1e9fe3fa1316', 'ASOCIACION MUNICIPAL DE  MUJERES  CAMPESINAS DE MATANZA ASOCIMUCAM', generar_slug_unico('ASOCIACION MUNICIPAL DE  MUJERES  CAMPESINAS DE MATANZA ASOCIMUCAM', 'ba4fc0f1-1696-4587-83d4-1e9fe3fa1316'), (select id from categorias_oficiales where slug = 'pendiente-clasificar'), 'Matanza', null, 'Finca Limoncito', null, null, null, null, 'FRUTAS Y HORTALIZAS', '3174854366', '573174854366', 'asocimucam2013@hotmail.com', 'ANA MERCEDES FLORES', '804015982-1', null, null, null, null, 'RETIRADO', null, 2018, '1.541 msnm', '1112592', '1250103', null, 'Revisión si aplica retiro', null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, true, false, false, false, false
where not exists (select 1 from negocios where nombre = 'ASOCIACION MUNICIPAL DE  MUJERES  CAMPESINAS DE MATANZA ASOCIMUCAM');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'ASOCIACION MUNICIPAL DE  MUJERES  CAMPESINAS DE MATANZA ASOCIMUCAM');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'ASOCIACION MUNICIPAL DE  MUJERES  CAMPESINAS DE MATANZA ASOCIMUCAM'), (select id from categorias_oficiales where slug = 'pendiente-clasificar');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'ASOCIACION MUNICIPAL DE  MUJERES  CAMPESINAS DE MATANZA ASOCIMUCAM');
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'ASOCIACION MUNICIPAL DE  MUJERES  CAMPESINAS DE MATANZA ASOCIMUCAM');

-- EMPRESA COMUNITARIA DE PRODUCTORES AGROPECUARIOS DE ALTO BRAVO-ECOBRAVO
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'),
  municipio = 'Matanza',
  vereda_id = (select id from veredas where municipio = 'Matanza' and slug = 'alto-bravo'),
  direccion = 'FINCA EL RECUERDO DE LOS ABUELOS, VEREDA ALTO BRAVO',
  latitud = 6.940277777777778,
  longitud = -73.04305555555555,
  descripcion_corta = 'Ecobravo es una empresa comunitaria conformada por 32 socios, todos son pequeños productores de café con sistema de producción agroforestal. en total tiene…',
  descripcion = 'Ecobravo es una empresa comunitaria conformada por 32 socios, todos son pequeños productores de café con sistema de producción agroforestal. en total tiene un área cultivada de 74 has distribuidas en 24 fincas, con densidad de siembra de 5.000 plantas/ha. cada uno de los asociados tiene en promedio 2 has de café cultivado, existen 2 asociados con área superior al promedio que reúnen entre los 2 un área aproximada de 10 hectáreas. los 32 asociados tienen lotes de café de diferentes edades tal como lo recomienda la federación de cafeteros. las actividades de sostenimiento y cosecha del cultivo son realizadas con mano de obra familiar principalmente. El beneficio o transformación primaria del café se hace en cada finca implementando practicas amigables con el medio ambiente. comercializada como café pergamino seco a nivel regional, nacional y con experiencia de exportación.',
  producto = 'CAFÉ ECOLOGICO EN PERGAMINO SECO',
  telefono = '3015870595',
  whatsapp = '573015870595',
  email = 'ecobravo.agropecuarios@gmail.com',
  representante_legal = 'ROBINSON FABIAN NIÑO DIAZ',
  nit = '901176151-8',
  naturaleza_juridica = 'Jurídica',
  delegado = null,
  rut_camara_comercio = 'Cámara de comercio',
  responsable_cdmb = 'ANA RUEDA',
  novedad = 'ACTIVO',
  tipo_negocio_verde = 'Dinamizadoras',
  anio_registro = 2019,
  cota_msnm = '1400 msnm',
  este = '73°2''35''''',
  norte = '6°56''25''''',
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
  invima = null,
  invima_vencimiento = null,
  certificado_tenencia_animales = null,
  buenas_practicas_agricolas = 'No',
  buenas_practicas_apicolas = null,
  registro_apicola = null,
  intervencion_cauce = null,
  capacidad_carga = null,
  sstt = 'No',
  canal_venta = 'Mixta',
  exportacion = 'No',
  huella_carbono = null,
  fortalezas_ambiental = 'Sistemas agroforestales , estrategias de restauración y reforestación con especies nativas , cercas vivas, rescate de plántulas,los residuos generados en el despulpado de café son llevados a una fosa de compostaje con lombrices para descomponer y reintegrar al cultivo,no se utilizan materiales peligrosos y/o tóxicos en los procesos, empaques ecológicos de fique y participación en el concurso Reto Clúster de calidad-2023.',
  fortalezas_social = 'Si reuniones periodicas con todos los asociados  y acciones de educación ambiental  de cómo proteger los recursos naturales en temporada de vacaciones  a niños y jóvenes de las familias de la zona.',
  fortalezas_economico = 'Tiene claro algunos costos y gastos pero no la totalidad de operación del negocio por parte de algunos asociados',
  emprendimiento_verde = true,
  sello_marca = false,
  avalado = false,
  destacado = false,
  activo = true
where nombre = 'EMPRESA COMUNITARIA DE PRODUCTORES AGROPECUARIOS DE ALTO BRAVO-ECOBRAVO';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select '71ff836b-a804-49d1-967a-7a854ef399fe', 'EMPRESA COMUNITARIA DE PRODUCTORES AGROPECUARIOS DE ALTO BRAVO-ECOBRAVO', generar_slug_unico('EMPRESA COMUNITARIA DE PRODUCTORES AGROPECUARIOS DE ALTO BRAVO-ECOBRAVO', '71ff836b-a804-49d1-967a-7a854ef399fe'), (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'), 'Matanza', (select id from veredas where municipio = 'Matanza' and slug = 'alto-bravo'), 'FINCA EL RECUERDO DE LOS ABUELOS, VEREDA ALTO BRAVO', 6.940277777777778, -73.04305555555555, 'Ecobravo es una empresa comunitaria conformada por 32 socios, todos son pequeños productores de café con sistema de producción agroforestal. en total tiene…', 'Ecobravo es una empresa comunitaria conformada por 32 socios, todos son pequeños productores de café con sistema de producción agroforestal. en total tiene un área cultivada de 74 has distribuidas en 24 fincas, con densidad de siembra de 5.000 plantas/ha. cada uno de los asociados tiene en promedio 2 has de café cultivado, existen 2 asociados con área superior al promedio que reúnen entre los 2 un área aproximada de 10 hectáreas. los 32 asociados tienen lotes de café de diferentes edades tal como lo recomienda la federación de cafeteros. las actividades de sostenimiento y cosecha del cultivo son realizadas con mano de obra familiar principalmente. El beneficio o transformación primaria del café se hace en cada finca implementando practicas amigables con el medio ambiente. comercializada como café pergamino seco a nivel regional, nacional y con experiencia de exportación.', 'CAFÉ ECOLOGICO EN PERGAMINO SECO', '3015870595', '573015870595', 'ecobravo.agropecuarios@gmail.com', 'ROBINSON FABIAN NIÑO DIAZ', '901176151-8', 'Jurídica', null, 'Cámara de comercio', 'ANA RUEDA', 'ACTIVO', 'Dinamizadoras', 2019, '1400 msnm', '73°2''35''''', '6°56''25''''', 'Actualizó', 'Se realizo visita y se aplico ficha de verificacion', null, 'Sí', 'Acueducto veredal', null, null, null, 'No', 'No', 'Sí', null, null, null, null, null, null, 'No', null, null, null, null, 'No', 'Mixta', 'No', null, 'Sistemas agroforestales , estrategias de restauración y reforestación con especies nativas , cercas vivas, rescate de plántulas,los residuos generados en el despulpado de café son llevados a una fosa de compostaje con lombrices para descomponer y reintegrar al cultivo,no se utilizan materiales peligrosos y/o tóxicos en los procesos, empaques ecológicos de fique y participación en el concurso Reto Clúster de calidad-2023.', 'Si reuniones periodicas con todos los asociados  y acciones de educación ambiental  de cómo proteger los recursos naturales en temporada de vacaciones  a niños y jóvenes de las familias de la zona.', 'Tiene claro algunos costos y gastos pero no la totalidad de operación del negocio por parte de algunos asociados', true, false, false, false, true
where not exists (select 1 from negocios where nombre = 'EMPRESA COMUNITARIA DE PRODUCTORES AGROPECUARIOS DE ALTO BRAVO-ECOBRAVO');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'EMPRESA COMUNITARIA DE PRODUCTORES AGROPECUARIOS DE ALTO BRAVO-ECOBRAVO');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'EMPRESA COMUNITARIA DE PRODUCTORES AGROPECUARIOS DE ALTO BRAVO-ECOBRAVO'), (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'EMPRESA COMUNITARIA DE PRODUCTORES AGROPECUARIOS DE ALTO BRAVO-ECOBRAVO');
insert into negocios_subcategorias (negocio_id, subcategoria_id) select (select id from negocios where nombre = 'EMPRESA COMUNITARIA DE PRODUCTORES AGROPECUARIOS DE ALTO BRAVO-ECOBRAVO'), id from subcategorias where slug = 'agrosistemas-sostenibles';
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'EMPRESA COMUNITARIA DE PRODUCTORES AGROPECUARIOS DE ALTO BRAVO-ECOBRAVO');
insert into negocios_actividades (negocio_id, actividad_productiva_id) select (select id from negocios where nombre = 'EMPRESA COMUNITARIA DE PRODUCTORES AGROPECUARIOS DE ALTO BRAVO-ECOBRAVO'), id from actividades_productivas where slug = 'agricultura-sostenible';
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'EMPRESA COMUNITARIA DE PRODUCTORES AGROPECUARIOS DE ALTO BRAVO-ECOBRAVO'), 2020, 52.51 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'EMPRESA COMUNITARIA DE PRODUCTORES AGROPECUARIOS DE ALTO BRAVO-ECOBRAVO'), 2021, 54.17 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'EMPRESA COMUNITARIA DE PRODUCTORES AGROPECUARIOS DE ALTO BRAVO-ECOBRAVO'), 2022, 71.08 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'EMPRESA COMUNITARIA DE PRODUCTORES AGROPECUARIOS DE ALTO BRAVO-ECOBRAVO'), 2023, 72.48 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'EMPRESA COMUNITARIA DE PRODUCTORES AGROPECUARIOS DE ALTO BRAVO-ECOBRAVO'), 2024, 73.4 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'EMPRESA COMUNITARIA DE PRODUCTORES AGROPECUARIOS DE ALTO BRAVO-ECOBRAVO'), 2025, 72.3 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;


commit;
