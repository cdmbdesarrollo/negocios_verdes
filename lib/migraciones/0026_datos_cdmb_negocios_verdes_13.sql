begin;

-- Generado por lib/migraciones/generar_0026.py desde BASE_ACTUALIZADA_NV_ka.xlsx — no editar a mano.
-- Uno de varios archivos partidos (ver README.md) — correr TODOS, en cualquier orden, cada uno es su propia transacción.

-- Parte 13 de 17.

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

-- DAVINCCI
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'ecoproductos-industriales'),
  municipio = 'Bucaramanga',
  vereda_id = (select id from veredas where municipio = 'Bucaramanga' and slug = 'perimetro-urbano'),
  direccion = 'CARRERA 23 # 32 - 46',
  latitud = 7.128888888888889,
  longitud = null,
  descripcion_corta = 'Diseño impresión 3d elaborados en fabricadis en materia pla(acido politatoco) botellas pet',
  descripcion = 'Diseño impresión 3d elaborados en fabricadis en materia pla(acido politatoco) botellas pet',
  producto = 'DISEÑOS EN IMPRESIÓN 3D MAQUETAS,ROBOTS,TROFEOS,FIGURAS DE COLECCIÓN',
  telefono = '3246559212',
  whatsapp = '573246559212',
  email = 'davincci.3d@gmail.com',
  representante_legal = 'MIGUEL ANGEL VARGAS',
  nit = '1005163160',
  naturaleza_juridica = 'Natural',
  delegado = null,
  rut_camara_comercio = 'Cámara de comercio',
  responsable_cdmb = 'SUJEY DÍAZ',
  novedad = 'ACTIVO',
  tipo_negocio_verde = 'Satisfactorio',
  anio_registro = 2024,
  cota_msnm = '1004.9',
  este = '73°7''214''''',
  norte = '7°7''44''''',
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
  fortalezas_ambiental = 'Se cambia el uso de plástico derivados del petróleo por polímeros  extraídos del maíz, los desechos son utilizados en nuevas piezas en macetas.  Aprovechamiento de las botellas plásticas para uso de materia prima, embalaje bolsa de papel',
  fortalezas_social = 'Se dan capacitaciones en el uso de nuevas tecnologias    a estudiantes sobre el aprovechamiento de los recursos renovables , capacitaciones en colegiosy universidades, encadenamiento comercial con la universidad Santo Tomas',
  fortalezas_economico = 'Es novedoso en el mercado , generan buenos ingresos  , estan en proceso de apertura de un local .',
  emprendimiento_verde = false,
  sello_marca = false,
  avalado = true,
  destacado = false,
  activo = true
where nombre = 'DAVINCCI';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select '30547188-9392-43ec-a86e-fd682c698a8f', 'DAVINCCI', generar_slug_unico('DAVINCCI', '30547188-9392-43ec-a86e-fd682c698a8f'), (select id from categorias_oficiales where slug = 'ecoproductos-industriales'), 'Bucaramanga', (select id from veredas where municipio = 'Bucaramanga' and slug = 'perimetro-urbano'), 'CARRERA 23 # 32 - 46', 7.128888888888889, null, 'Diseño impresión 3d elaborados en fabricadis en materia pla(acido politatoco) botellas pet', 'Diseño impresión 3d elaborados en fabricadis en materia pla(acido politatoco) botellas pet', 'DISEÑOS EN IMPRESIÓN 3D MAQUETAS,ROBOTS,TROFEOS,FIGURAS DE COLECCIÓN', '3246559212', '573246559212', 'davincci.3d@gmail.com', 'MIGUEL ANGEL VARGAS', '1005163160', 'Natural', null, 'Cámara de comercio', 'SUJEY DÍAZ', 'ACTIVO', 'Satisfactorio', 2024, '1004.9', '73°7''214''''', '7°7''44''''', 'Actualizó', 'Se realizo visita y se actualizo ficha de verificacion', null, null, 'Acueducto', null, null, null, 'No', 'No', null, 'Sí', null, null, null, null, null, null, null, null, null, null, 'No', 'B2C', 'No', 'NO', 'Se cambia el uso de plástico derivados del petróleo por polímeros  extraídos del maíz, los desechos son utilizados en nuevas piezas en macetas.  Aprovechamiento de las botellas plásticas para uso de materia prima, embalaje bolsa de papel', 'Se dan capacitaciones en el uso de nuevas tecnologias    a estudiantes sobre el aprovechamiento de los recursos renovables , capacitaciones en colegiosy universidades, encadenamiento comercial con la universidad Santo Tomas', 'Es novedoso en el mercado , generan buenos ingresos  , estan en proceso de apertura de un local .', false, false, true, false, true
where not exists (select 1 from negocios where nombre = 'DAVINCCI');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'DAVINCCI');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'DAVINCCI'), (select id from categorias_oficiales where slug = 'ecoproductos-industriales');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'DAVINCCI');
insert into negocios_subcategorias (negocio_id, subcategoria_id) select (select id from negocios where nombre = 'DAVINCCI'), id from subcategorias where slug = 'construccion-infraestructura-sostenible';
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'DAVINCCI');
insert into negocios_actividades (negocio_id, actividad_productiva_id) select (select id from negocios where nombre = 'DAVINCCI'), id from actividades_productivas where slug = 'biomateriales-ecomateriales-equipos-ecoeficientes';
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'DAVINCCI'), 2024, 47.2 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'DAVINCCI'), 2025, 55.5 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;

-- ALROVA
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'),
  municipio = 'Tona',
  vereda_id = (select id from veredas where municipio = 'Tona' and slug = 'perimetro-urbano'),
  direccion = 'AVENIDA 3 # 3-70 BERLIN - TONA',
  latitud = 7.186944444444444,
  longitud = -72.87638888888888,
  descripcion_corta = 'Cultivo y proceso de tranformacion de la maca y la cebolla enrama',
  descripcion = 'Cultivo y proceso de tranformacion de la maca y la cebolla enrama',
  producto = 'MACA',
  telefono = '3153268849',
  whatsapp = '573153268849',
  email = 'alfonsomaca10@hotmail.com',
  representante_legal = 'ALFONSO RODRIGUEZ VANEGAS',
  nit = '13818933-6',
  naturaleza_juridica = 'Natural',
  delegado = null,
  rut_camara_comercio = 'Cámara de comercio',
  responsable_cdmb = 'HEINER ORTIZ',
  novedad = 'ACTIVO',
  tipo_negocio_verde = 'Intermedio',
  anio_registro = 2018,
  cota_msnm = '3319',
  este = '72°52''35''''',
  norte = '7°11''13''''',
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
  huella_carbono = 'NO',
  fortalezas_ambiental = null,
  fortalezas_social = null,
  fortalezas_economico = null,
  emprendimiento_verde = true,
  sello_marca = false,
  avalado = false,
  destacado = false,
  activo = true
where nombre = 'ALROVA';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select 'd6601868-9eb2-4589-9762-5d5d2b3dfbea', 'ALROVA', generar_slug_unico('ALROVA', 'd6601868-9eb2-4589-9762-5d5d2b3dfbea'), (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'), 'Tona', (select id from veredas where municipio = 'Tona' and slug = 'perimetro-urbano'), 'AVENIDA 3 # 3-70 BERLIN - TONA', 7.186944444444444, -72.87638888888888, 'Cultivo y proceso de tranformacion de la maca y la cebolla enrama', 'Cultivo y proceso de tranformacion de la maca y la cebolla enrama', 'MACA', '3153268849', '573153268849', 'alfonsomaca10@hotmail.com', 'ALFONSO RODRIGUEZ VANEGAS', '13818933-6', 'Natural', null, 'Cámara de comercio', 'HEINER ORTIZ', 'ACTIVO', 'Intermedio', 2018, '3319', '72°52''35''''', '7°11''13''''', 'Actualizó', 'Se realizo visita y se actualizo ficha de verificacion', null, 'No', 'Acueducto', null, null, null, 'No', 'No', null, 'Sí', null, null, 'No', null, null, 'No', null, null, null, null, 'No', 'B2C', 'No', 'NO', null, null, null, true, false, false, false, true
where not exists (select 1 from negocios where nombre = 'ALROVA');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'ALROVA');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'ALROVA'), (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'ALROVA');
insert into negocios_subcategorias (negocio_id, subcategoria_id) select (select id from negocios where nombre = 'ALROVA'), id from subcategorias where slug = 'agrosistemas-sostenibles';
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'ALROVA');
insert into negocios_actividades (negocio_id, actividad_productiva_id) select (select id from negocios where nombre = 'ALROVA'), id from actividades_productivas where slug = 'agricultura-organica';
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'ALROVA'), 2020, 35.8 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'ALROVA'), 2021, 35.88 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'ALROVA'), 2022, 34.26 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'ALROVA'), 2023, 34.26 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'ALROVA'), 2024, 23.8 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'ALROVA'), 2025, 23.8 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;

-- SETAS COMESTIBLES
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'),
  municipio = 'Girón',
  vereda_id = (select id from veredas where municipio = 'Girón' and slug = 'perimetro-urbano'),
  direccion = 'CALLLE 35 # 36-21 TORRE B 703 CONJ FLORIDA DEL COUNTRY',
  latitud = null,
  longitud = null,
  descripcion_corta = 'Producccion de hongos setas orellanas a base de sustratos de desechos organicos junto con  maderables o no maderables .',
  descripcion = 'Producccion de hongos setas orellanas a base de sustratos de desechos organicos junto con  maderables o no maderables .',
  producto = 'SETAS',
  telefono = '3114561756',
  whatsapp = '573114561756',
  email = 'fernandovesga31@hotmail.com',
  representante_legal = 'JOSE FERNANDO VESGA ROJAS',
  nit = '91291409-7',
  naturaleza_juridica = 'Natural',
  delegado = null,
  rut_camara_comercio = 'Sin verificar',
  responsable_cdmb = 'SUJEY DÍAZ',
  novedad = 'RETIRADO',
  tipo_negocio_verde = 'Inicial',
  anio_registro = 2023,
  cota_msnm = null,
  este = null,
  norte = null,
  aplicacion_ficha_2025 = 'No actualizó',
  observaciones = 'No se realizo visita ni actualizo ficha de verificacion',
  registro_nacional_turismo = null,
  uso_suelo = 'No',
  concesion_aguas = null,
  concesion_aguas_vencimiento = null,
  vertimientos = null,
  vertimientos_vencimiento = null,
  pueaa = 'No',
  pgris = 'No',
  pozo_septico = 'No',
  alcantarillado = 'No',
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
  canal_venta = null,
  exportacion = null,
  huella_carbono = null,
  fortalezas_ambiental = 'Al finalizar la cosecha de los hongos en los tobulares  son utilizados como abono orgánico para la tierra',
  fortalezas_social = 'Realiza charlas  familiares y amigos  sobre el reino fungui , cultura ambiental y social.',
  fortalezas_economico = 'Actitud de ampliar su mercado',
  emprendimiento_verde = true,
  sello_marca = false,
  avalado = false,
  destacado = false,
  activo = false
where nombre = 'SETAS COMESTIBLES';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select '2dc25a7b-42ce-40fa-a144-0d3f2587583a', 'SETAS COMESTIBLES', generar_slug_unico('SETAS COMESTIBLES', '2dc25a7b-42ce-40fa-a144-0d3f2587583a'), (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'), 'Girón', (select id from veredas where municipio = 'Girón' and slug = 'perimetro-urbano'), 'CALLLE 35 # 36-21 TORRE B 703 CONJ FLORIDA DEL COUNTRY', null, null, 'Producccion de hongos setas orellanas a base de sustratos de desechos organicos junto con  maderables o no maderables .', 'Producccion de hongos setas orellanas a base de sustratos de desechos organicos junto con  maderables o no maderables .', 'SETAS', '3114561756', '573114561756', 'fernandovesga31@hotmail.com', 'JOSE FERNANDO VESGA ROJAS', '91291409-7', 'Natural', null, 'Sin verificar', 'SUJEY DÍAZ', 'RETIRADO', 'Inicial', 2023, null, null, null, 'No actualizó', 'No se realizo visita ni actualizo ficha de verificacion', null, 'No', null, null, null, null, 'No', 'No', 'No', 'No', null, null, null, null, null, 'No', null, null, null, null, 'No', null, null, null, 'Al finalizar la cosecha de los hongos en los tobulares  son utilizados como abono orgánico para la tierra', 'Realiza charlas  familiares y amigos  sobre el reino fungui , cultura ambiental y social.', 'Actitud de ampliar su mercado', true, false, false, false, false
where not exists (select 1 from negocios where nombre = 'SETAS COMESTIBLES');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'SETAS COMESTIBLES');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'SETAS COMESTIBLES'), (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'SETAS COMESTIBLES');
insert into negocios_subcategorias (negocio_id, subcategoria_id) select (select id from negocios where nombre = 'SETAS COMESTIBLES'), id from subcategorias where slug = 'agroindustria-sostenible';
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'SETAS COMESTIBLES');
insert into negocios_actividades (negocio_id, actividad_productiva_id) select (select id from negocios where nombre = 'SETAS COMESTIBLES'), id from actividades_productivas where slug = 'agroindustrial-alimentario';
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'SETAS COMESTIBLES'), 2024, 41.6 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;

-- CHOCOLATE CASERO HOREB
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'),
  municipio = 'Lebrija',
  vereda_id = (select id from veredas where municipio = 'Lebrija' and slug = 'lisboa'),
  direccion = 'FINCA BRISAS, VEREDA LISBOA',
  latitud = 7.149552777777778,
  longitud = -73.29869444444444,
  descripcion_corta = 'Empresa dedicada a la producción, transformación y comercialización de productos derivados del cultivo de cacao con prácticas naturales, certificada con…',
  descripcion = 'Empresa dedicada a la producción, transformación y comercialización de productos derivados del cultivo de cacao con prácticas naturales, certificada con buenas prácticas agrícolas, con políticas de conservación y preservación del medio ambiente a través de campañas de educación ambiental.',
  producto = 'CHOCOLATE SIN AZUCAR',
  telefono = '3023720078',
  whatsapp = '573023720078',
  email = 'banderaalcira@gmail.com',
  representante_legal = 'ALCIRA BANDERA DE GARCIA',
  nit = '28403921-0',
  naturaleza_juridica = 'Natural',
  delegado = null,
  rut_camara_comercio = 'Cámara de comercio',
  responsable_cdmb = 'NATALY RAMIREZ',
  novedad = 'ACTIVO',
  tipo_negocio_verde = null,
  anio_registro = 2023,
  cota_msnm = '840 msnm',
  este = '73°17''55,30"',
  norte = '7°8''58,39"',
  aplicacion_ficha_2025 = 'Actualizó',
  observaciones = 'Se realizo visita y se aplico ficha de verificacion',
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
  invima = 'Sí',
  invima_vencimiento = '2034-09-20',
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
  fortalezas_ambiental = 'Cultivo de manejo Agroecológico con sistema agroforestal. Buenas prácticas hídricas (uso de aguas lluvias)',
  fortalezas_social = 'Buenas prácticas en la cadena de valor (encadenamiento comercial)',
  fortalezas_economico = 'Diversificación de productos',
  emprendimiento_verde = false,
  sello_marca = false,
  avalado = true,
  destacado = false,
  activo = true
where nombre = 'CHOCOLATE CASERO HOREB';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select 'a0a2794f-56a3-4abb-821f-2fbbd2928f9a', 'CHOCOLATE CASERO HOREB', generar_slug_unico('CHOCOLATE CASERO HOREB', 'a0a2794f-56a3-4abb-821f-2fbbd2928f9a'), (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'), 'Lebrija', (select id from veredas where municipio = 'Lebrija' and slug = 'lisboa'), 'FINCA BRISAS, VEREDA LISBOA', 7.149552777777778, -73.29869444444444, 'Empresa dedicada a la producción, transformación y comercialización de productos derivados del cultivo de cacao con prácticas naturales, certificada con…', 'Empresa dedicada a la producción, transformación y comercialización de productos derivados del cultivo de cacao con prácticas naturales, certificada con buenas prácticas agrícolas, con políticas de conservación y preservación del medio ambiente a través de campañas de educación ambiental.', 'CHOCOLATE SIN AZUCAR', '3023720078', '573023720078', 'banderaalcira@gmail.com', 'ALCIRA BANDERA DE GARCIA', '28403921-0', 'Natural', null, 'Cámara de comercio', 'NATALY RAMIREZ', 'ACTIVO', null, 2023, '840 msnm', '73°17''55,30"', '7°8''58,39"', 'Actualizó', 'Se realizo visita y se aplico ficha de verificacion', 'Sí', 'Sí', 'Acueducto veredal', null, null, null, 'No', 'No', 'Sí', null, null, null, 'Sí', '2034-09-20', null, 'Sí', null, null, null, 'No', 'No', 'B2C', 'No', 'NO', 'Cultivo de manejo Agroecológico con sistema agroforestal. Buenas prácticas hídricas (uso de aguas lluvias)', 'Buenas prácticas en la cadena de valor (encadenamiento comercial)', 'Diversificación de productos', false, false, true, false, true
where not exists (select 1 from negocios where nombre = 'CHOCOLATE CASERO HOREB');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'CHOCOLATE CASERO HOREB');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'CHOCOLATE CASERO HOREB'), (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'CHOCOLATE CASERO HOREB');
insert into negocios_subcategorias (negocio_id, subcategoria_id) select (select id from negocios where nombre = 'CHOCOLATE CASERO HOREB'), id from subcategorias where slug = 'agroindustria-sostenible';
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'CHOCOLATE CASERO HOREB');
insert into negocios_actividades (negocio_id, actividad_productiva_id) select (select id from negocios where nombre = 'CHOCOLATE CASERO HOREB'), id from actividades_productivas where slug = 'agroindustrial-alimentario';
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'CHOCOLATE CASERO HOREB'), 2023, 59.31 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'CHOCOLATE CASERO HOREB'), 2024, 53.8 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'CHOCOLATE CASERO HOREB'), 2025, 59.0 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;

-- SEA & SEAMS
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'ecoproductos-industriales'),
  municipio = 'Bucaramanga',
  vereda_id = (select id from veredas where municipio = 'Bucaramanga' and slug = 'perimetro-urbano'),
  direccion = 'CARRERA 23 # 54 - 75 LOCAL 102 EDIFICIO HUNZAA, BOLARQUI',
  latitud = 7.110305555555555,
  longitud = -73.11526666666666,
  descripcion_corta = 'En Sea & Seams, nos dedicamos a crear experiencias únicas a través de la moda sostenible ofreciendo alternativas de consumo en moda responsables y…',
  descripcion = 'En Sea & Seams, nos dedicamos a crear experiencias únicas a través de la moda sostenible ofreciendo alternativas de consumo en moda responsables y soluciones acordes a las necesidades actuales de las personas. Tienda de moda Circular.',
  producto = 'COLECCIONES UPCYCLING',
  telefono = '3508648893',
  whatsapp = '573508648893',
  email = 'seaams.co@gmail.com',
  representante_legal = 'DANIELA ANDREA GOMEZ RODRIGUEZ',
  nit = '1095940672-9',
  naturaleza_juridica = 'Natural',
  delegado = null,
  rut_camara_comercio = 'Cámara de comercio y RUT',
  responsable_cdmb = 'CRISTAL VILLAREAL',
  novedad = 'RETIRADO',
  tipo_negocio_verde = null,
  anio_registro = 2024,
  cota_msnm = '969,5 msnm',
  este = '73°6''54,96"',
  norte = '7°6''37,10"',
  aplicacion_ficha_2025 = 'No actualizó',
  observaciones = 'No realizo visita ni se aplico ficha de verificacion',
  registro_nacional_turismo = null,
  uso_suelo = 'No',
  concesion_aguas = null,
  concesion_aguas_vencimiento = null,
  vertimientos = null,
  vertimientos_vencimiento = null,
  pueaa = 'No',
  pgris = 'No',
  pozo_septico = 'No',
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
  fortalezas_ambiental = 'Reduce la cantidad residuos textiles que terminan en los vertederos. Economía Circular',
  fortalezas_social = 'Acceso a moda asequible. Promueve un estilo de vida menos consumista',
  fortalezas_economico = 'Ventaja competitiva clara. Enfoque en nichos con potencial.',
  emprendimiento_verde = true,
  sello_marca = false,
  avalado = false,
  destacado = false,
  activo = false
where nombre = 'SEA & SEAMS';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select 'd4911b00-6e01-4035-becb-e0a00753c8cd', 'SEA & SEAMS', generar_slug_unico('SEA & SEAMS', 'd4911b00-6e01-4035-becb-e0a00753c8cd'), (select id from categorias_oficiales where slug = 'ecoproductos-industriales'), 'Bucaramanga', (select id from veredas where municipio = 'Bucaramanga' and slug = 'perimetro-urbano'), 'CARRERA 23 # 54 - 75 LOCAL 102 EDIFICIO HUNZAA, BOLARQUI', 7.110305555555555, -73.11526666666666, 'En Sea & Seams, nos dedicamos a crear experiencias únicas a través de la moda sostenible ofreciendo alternativas de consumo en moda responsables y…', 'En Sea & Seams, nos dedicamos a crear experiencias únicas a través de la moda sostenible ofreciendo alternativas de consumo en moda responsables y soluciones acordes a las necesidades actuales de las personas. Tienda de moda Circular.', 'COLECCIONES UPCYCLING', '3508648893', '573508648893', 'seaams.co@gmail.com', 'DANIELA ANDREA GOMEZ RODRIGUEZ', '1095940672-9', 'Natural', null, 'Cámara de comercio y RUT', 'CRISTAL VILLAREAL', 'RETIRADO', null, 2024, '969,5 msnm', '73°6''54,96"', '7°6''37,10"', 'No actualizó', 'No realizo visita ni se aplico ficha de verificacion', null, 'No', null, null, null, null, 'No', 'No', 'No', 'Sí', null, null, null, null, null, null, null, null, null, null, 'No', 'B2C', null, null, 'Reduce la cantidad residuos textiles que terminan en los vertederos. Economía Circular', 'Acceso a moda asequible. Promueve un estilo de vida menos consumista', 'Ventaja competitiva clara. Enfoque en nichos con potencial.', true, false, false, false, false
where not exists (select 1 from negocios where nombre = 'SEA & SEAMS');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'SEA & SEAMS');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'SEA & SEAMS'), (select id from categorias_oficiales where slug = 'ecoproductos-industriales');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'SEA & SEAMS');
insert into negocios_subcategorias (negocio_id, subcategoria_id) select (select id from negocios where nombre = 'SEA & SEAMS'), id from subcategorias where slug = 'moda-sostenible';
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'SEA & SEAMS');
insert into negocios_actividades (negocio_id, actividad_productiva_id) select (select id from negocios where nombre = 'SEA & SEAMS'), id from actividades_productivas where slug = 'confeccion-manufactura';
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'SEA & SEAMS'), 2024, 75.5 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;

-- GREEN TEAM INGENIERIA SAS
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'ecoproductos-industriales'),
  municipio = 'Rionegro',
  vereda_id = (select id from veredas where municipio = 'Rionegro' and slug = 'perimetro-urbano'),
  direccion = 'AV LA ROSITA No. 18-80 OFICINA 302 EDIFICIO ROSITA',
  latitud = 73.55035,
  longitud = -7.616174999999999,
  descripcion_corta = 'Green Team es una empresa dedicada a la descarbonizacion de diversas industrias a partir de la utilización de la pirólisis para procesar residuos…',
  descripcion = 'Green Team es una empresa dedicada a la descarbonizacion de diversas industrias a partir de la utilización de la pirólisis para procesar residuos agroindustriales y urbanos.Producen Biochar, vinagre de madera también llamado ácido piroleñoso y aceite piroleñoso. Se especializan también en el montaje de proyectos de generación de créditos de carbono a partir de Biochar usando la tecnología de pirólisis',
  producto = 'BIOCHAR',
  telefono = '3212139080',
  whatsapp = '573212139080',
  email = 'greenteamingenieria@gmail.com',
  representante_legal = 'GONZALO ANDRES JAIMES PRADA',
  nit = '901265544-0',
  naturaleza_juridica = 'Jurídica',
  delegado = null,
  rut_camara_comercio = 'Cámara de comercio y RUT',
  responsable_cdmb = 'LAURA RUIZ',
  novedad = 'RETIRADO',
  tipo_negocio_verde = null,
  anio_registro = 2024,
  cota_msnm = null,
  este = '7°36''58,23"',
  norte = '73°33''1,26"',
  aplicacion_ficha_2025 = 'No actualizó',
  observaciones = 'No realizo visita ni se aplico ficha de verificacion',
  registro_nacional_turismo = null,
  uso_suelo = 'No',
  concesion_aguas = null,
  concesion_aguas_vencimiento = null,
  vertimientos = null,
  vertimientos_vencimiento = null,
  pueaa = null,
  pgris = 'No',
  pozo_septico = null,
  alcantarillado = null,
  ica = 'Sí',
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
  exportacion = null,
  huella_carbono = null,
  fortalezas_ambiental = 'Reducción de gases efecto invernadero. Aprovechamiento de residuos. Mejora de suelos (aumenta la retención de agua y nutrientes)',
  fortalezas_social = 'Desarrollo local y regional. Generación de empleo verde',
  fortalezas_economico = 'Demanda creciente en mercados verdes. Valor agregado a residuos. Generación de créditos de carbono',
  emprendimiento_verde = true,
  sello_marca = false,
  avalado = false,
  destacado = false,
  activo = false
where nombre = 'GREEN TEAM INGENIERIA SAS';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select 'ffd4852f-b56a-4761-b745-bcad4b144b8a', 'GREEN TEAM INGENIERIA SAS', generar_slug_unico('GREEN TEAM INGENIERIA SAS', 'ffd4852f-b56a-4761-b745-bcad4b144b8a'), (select id from categorias_oficiales where slug = 'ecoproductos-industriales'), 'Rionegro', (select id from veredas where municipio = 'Rionegro' and slug = 'perimetro-urbano'), 'AV LA ROSITA No. 18-80 OFICINA 302 EDIFICIO ROSITA', 73.55035, -7.616174999999999, 'Green Team es una empresa dedicada a la descarbonizacion de diversas industrias a partir de la utilización de la pirólisis para procesar residuos…', 'Green Team es una empresa dedicada a la descarbonizacion de diversas industrias a partir de la utilización de la pirólisis para procesar residuos agroindustriales y urbanos.Producen Biochar, vinagre de madera también llamado ácido piroleñoso y aceite piroleñoso. Se especializan también en el montaje de proyectos de generación de créditos de carbono a partir de Biochar usando la tecnología de pirólisis', 'BIOCHAR', '3212139080', '573212139080', 'greenteamingenieria@gmail.com', 'GONZALO ANDRES JAIMES PRADA', '901265544-0', 'Jurídica', null, 'Cámara de comercio y RUT', 'LAURA RUIZ', 'RETIRADO', null, 2024, null, '7°36''58,23"', '73°33''1,26"', 'No actualizó', 'No realizo visita ni se aplico ficha de verificacion', null, 'No', null, null, null, null, null, 'No', null, null, 'Sí', null, null, null, null, null, null, null, null, null, 'No', 'Mixta', null, null, 'Reducción de gases efecto invernadero. Aprovechamiento de residuos. Mejora de suelos (aumenta la retención de agua y nutrientes)', 'Desarrollo local y regional. Generación de empleo verde', 'Demanda creciente en mercados verdes. Valor agregado a residuos. Generación de créditos de carbono', true, false, false, false, false
where not exists (select 1 from negocios where nombre = 'GREEN TEAM INGENIERIA SAS');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'GREEN TEAM INGENIERIA SAS');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'GREEN TEAM INGENIERIA SAS'), (select id from categorias_oficiales where slug = 'ecoproductos-industriales');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'GREEN TEAM INGENIERIA SAS');
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'GREEN TEAM INGENIERIA SAS');
insert into negocios_actividades (negocio_id, actividad_productiva_id) select (select id from negocios where nombre = 'GREEN TEAM INGENIERIA SAS'), id from actividades_productivas where slug = 'aprovechamiento-residuos-organicos';
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'GREEN TEAM INGENIERIA SAS'), 2024, 71.7 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;

-- BETTAS MAS ARTE
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'),
  municipio = 'Floridablanca',
  vereda_id = (select id from veredas where municipio = 'Floridablanca' and slug = 'perimetro-urbano'),
  direccion = 'CALLE 29 # 12 -54 BARRIO LAGOS I',
  latitud = 7.072125,
  longitud = -73.10527777777777,
  descripcion_corta = 'Diseño y Creación de Acuarios Naturales o plantados con una variedad de plantas acuáticas naturales, que aporten un ecosistema saludable para peces y otros…',
  descripcion = 'Diseño y Creación de Acuarios Naturales o plantados con una variedad de plantas acuáticas naturales, que aporten un ecosistema saludable para peces y otros organismos acuáticos, incluye un diseño personalizado, la preparación del sustrato adecuado, el uso de equipos de filtración y la iluminación necesaria para el crecimiento de las plantas, además asesoría para clientes interesados en personalizar sus acuarios con plantas naturales y diferentes especies de peces. Esto puede incluir la selección de plantas, consejos sobre el tipo de sustrato, luz y parámetros de agua adecuados. Producción y Venta de Alimento Vivo.',
  producto = 'ACUARIOS PLANTADOS (NATURALES)',
  telefono = '3005528452',
  whatsapp = '573005528452',
  email = 'bettasmasarte@gmail.com',
  representante_legal = 'JORGE ALFREDO GÓMEZ BUITRAGO',
  nit = '91293384-0',
  naturaleza_juridica = 'Natural',
  delegado = null,
  rut_camara_comercio = 'Cámara de comercio',
  responsable_cdmb = 'LILIANA CACERES',
  novedad = 'ACTIVO',
  tipo_negocio_verde = 'Satisfactorio',
  anio_registro = 2024,
  cota_msnm = '855.2 msnm',
  este = '73°6''19,00"',
  norte = '7°4''19,65"',
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
  canal_venta = 'Mixta',
  exportacion = 'No',
  huella_carbono = 'NO',
  fortalezas_ambiental = 'Promueve ecosistemas acuáticos saludables.',
  fortalezas_social = 'Educa a clientes en cuidado ambiental y biodiversidad.',
  fortalezas_economico = 'Nicho de mercado creciente',
  emprendimiento_verde = false,
  sello_marca = false,
  avalado = true,
  destacado = false,
  activo = true
where nombre = 'BETTAS MAS ARTE';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select '0e2fec39-2045-4ed5-ac1a-020ac5f59efc', 'BETTAS MAS ARTE', generar_slug_unico('BETTAS MAS ARTE', '0e2fec39-2045-4ed5-ac1a-020ac5f59efc'), (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'), 'Floridablanca', (select id from veredas where municipio = 'Floridablanca' and slug = 'perimetro-urbano'), 'CALLE 29 # 12 -54 BARRIO LAGOS I', 7.072125, -73.10527777777777, 'Diseño y Creación de Acuarios Naturales o plantados con una variedad de plantas acuáticas naturales, que aporten un ecosistema saludable para peces y otros…', 'Diseño y Creación de Acuarios Naturales o plantados con una variedad de plantas acuáticas naturales, que aporten un ecosistema saludable para peces y otros organismos acuáticos, incluye un diseño personalizado, la preparación del sustrato adecuado, el uso de equipos de filtración y la iluminación necesaria para el crecimiento de las plantas, además asesoría para clientes interesados en personalizar sus acuarios con plantas naturales y diferentes especies de peces. Esto puede incluir la selección de plantas, consejos sobre el tipo de sustrato, luz y parámetros de agua adecuados. Producción y Venta de Alimento Vivo.', 'ACUARIOS PLANTADOS (NATURALES)', '3005528452', '573005528452', 'bettasmasarte@gmail.com', 'JORGE ALFREDO GÓMEZ BUITRAGO', '91293384-0', 'Natural', null, 'Cámara de comercio', 'LILIANA CACERES', 'ACTIVO', 'Satisfactorio', 2024, '855.2 msnm', '73°6''19,00"', '7°4''19,65"', 'Actualizó', 'Se realizo visita y se actualizo ficha de verificacion', null, null, 'Acueducto', null, null, null, 'No', 'No', null, 'Sí', null, null, null, null, null, null, null, null, null, null, 'No', 'Mixta', 'No', 'NO', 'Promueve ecosistemas acuáticos saludables.', 'Educa a clientes en cuidado ambiental y biodiversidad.', 'Nicho de mercado creciente', false, false, true, false, true
where not exists (select 1 from negocios where nombre = 'BETTAS MAS ARTE');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'BETTAS MAS ARTE');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'BETTAS MAS ARTE'), (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'BETTAS MAS ARTE');
insert into negocios_subcategorias (negocio_id, subcategoria_id) select (select id from negocios where nombre = 'BETTAS MAS ARTE'), id from subcategorias where slug = 'biocomercio';
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'BETTAS MAS ARTE');
insert into negocios_actividades (negocio_id, actividad_productiva_id) select (select id from negocios where nombre = 'BETTAS MAS ARTE'), id from actividades_productivas where slug = 'productos-fauna-silvestre';
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'BETTAS MAS ARTE'), 2024, 51.8 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'BETTAS MAS ARTE'), 2025, 55.1 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;

-- TOPICO
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'),
  municipio = 'Bucaramanga',
  vereda_id = (select id from veredas where municipio = 'Bucaramanga' and slug = 'perimetro-urbano'),
  direccion = 'CRA 17 B1 # 57-70 BARRIO RICAUTE',
  latitud = 7.106574999999999,
  longitud = -73.11783888888888,
  descripcion_corta = 'Es la producción y distribución de productos fitoterapéuticos. Estos se obtienen de plantas medicinales, asociaciones de estas o extractos con fines…',
  descripcion = 'Es la producción y distribución de productos fitoterapéuticos. Estos se obtienen de plantas medicinales, asociaciones de estas o extractos con fines terapéuticos.',
  producto = 'KIT BIENESTAR PRODUCTOS FITOTERAPEUTICOS',
  telefono = '3163528683',
  whatsapp = '573163528683',
  email = 'topicobga@gmail.com',
  representante_legal = 'LAURA ANDREA ROJAS PALOMINO',
  nit = '1098192540-0',
  naturaleza_juridica = 'Natural',
  delegado = null,
  rut_camara_comercio = 'Cámara de comercio y RUT',
  responsable_cdmb = 'DIEGO GUTIERREZ',
  novedad = 'RETIRADO',
  tipo_negocio_verde = null,
  anio_registro = 2024,
  cota_msnm = '839 msnm',
  este = '73°7''4,22"',
  norte = '7°6''23,67"',
  aplicacion_ficha_2025 = 'No actualizó',
  observaciones = 'No realizo visita ni se aplico ficha de verificacion',
  registro_nacional_turismo = null,
  uso_suelo = 'No',
  concesion_aguas = null,
  concesion_aguas_vencimiento = null,
  vertimientos = null,
  vertimientos_vencimiento = null,
  pueaa = 'No',
  pgris = 'No',
  pozo_septico = 'No',
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
  fortalezas_ambiental = 'Reducción de impactos químicos (medicamentos sintéticos)',
  fortalezas_social = 'Rescate de saberes ancestrales. Otras alternativas de bienestar (salud comunitaria)',
  fortalezas_economico = 'Acceso a un mercado en crecimiento (productos naturales, Fitoterapéuticos). Alto valor agregado',
  emprendimiento_verde = true,
  sello_marca = false,
  avalado = false,
  destacado = false,
  activo = false
where nombre = 'TOPICO';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select 'cc789538-6022-4e3c-b0a0-17c3822c2a49', 'TOPICO', generar_slug_unico('TOPICO', 'cc789538-6022-4e3c-b0a0-17c3822c2a49'), (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'), 'Bucaramanga', (select id from veredas where municipio = 'Bucaramanga' and slug = 'perimetro-urbano'), 'CRA 17 B1 # 57-70 BARRIO RICAUTE', 7.106574999999999, -73.11783888888888, 'Es la producción y distribución de productos fitoterapéuticos. Estos se obtienen de plantas medicinales, asociaciones de estas o extractos con fines…', 'Es la producción y distribución de productos fitoterapéuticos. Estos se obtienen de plantas medicinales, asociaciones de estas o extractos con fines terapéuticos.', 'KIT BIENESTAR PRODUCTOS FITOTERAPEUTICOS', '3163528683', '573163528683', 'topicobga@gmail.com', 'LAURA ANDREA ROJAS PALOMINO', '1098192540-0', 'Natural', null, 'Cámara de comercio y RUT', 'DIEGO GUTIERREZ', 'RETIRADO', null, 2024, '839 msnm', '73°7''4,22"', '7°6''23,67"', 'No actualizó', 'No realizo visita ni se aplico ficha de verificacion', null, 'No', null, null, null, null, 'No', 'No', 'No', 'Sí', null, null, 'No', null, null, null, null, null, null, null, 'No', 'B2C', null, null, 'Reducción de impactos químicos (medicamentos sintéticos)', 'Rescate de saberes ancestrales. Otras alternativas de bienestar (salud comunitaria)', 'Acceso a un mercado en crecimiento (productos naturales, Fitoterapéuticos). Alto valor agregado', true, false, false, false, false
where not exists (select 1 from negocios where nombre = 'TOPICO');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'TOPICO');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'TOPICO'), (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'TOPICO');
insert into negocios_subcategorias (negocio_id, subcategoria_id) select (select id from negocios where nombre = 'TOPICO'), id from subcategorias where slug = 'agroindustria-sostenible';
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'TOPICO');
insert into negocios_actividades (negocio_id, actividad_productiva_id) select (select id from negocios where nombre = 'TOPICO'), id from actividades_productivas where slug = 'agroindustrial-no-alimentario';
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'TOPICO'), 2024, 56.0 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;

-- ORQUÍDEAS Y PLANTAS ORNAMENTALES MANANTIAL
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'),
  municipio = 'Lebrija',
  vereda_id = (select id from veredas where municipio = 'Lebrija' and slug = 'san-nicolas-alto'),
  direccion = 'VEREDA SAN NICOLAS ALTO - FINCA EL MANANTIAL',
  latitud = 7.142326111111111,
  longitud = -73.24567611111111,
  descripcion_corta = 'Se compran las especies y con las matas madres se realiza el proceso de reproducciòn por hijos, reproducciòn de orquideas y plantas ornamentales',
  descripcion = 'Se compran las especies y con las matas madres se realiza el proceso de reproducciòn por hijos, reproducciòn de orquideas y plantas ornamentales',
  producto = 'PRODUCCIÒN Y VENTA DE ORQUIDEAS Y PLANTAS ORNAMENTALES',
  telefono = '3157542994',
  whatsapp = '573157542994',
  email = 'jeannethem07@gmail.com',
  representante_legal = 'JEANNETHE MENJURA CALLEJAS',
  nit = '37626191-0',
  naturaleza_juridica = 'Natural',
  delegado = null,
  rut_camara_comercio = 'Cámara de comercio',
  responsable_cdmb = 'HEINER ORTIZ',
  novedad = 'ACTIVO',
  tipo_negocio_verde = 'Intermedio',
  anio_registro = 2021,
  cota_msnm = '1.0600 msnm',
  este = '73°14''44.434"',
  norte = '7°8''32.374"',
  aplicacion_ficha_2025 = 'Actualizó',
  observaciones = 'Se realizo visita y se actualizo ficha de verificacion',
  registro_nacional_turismo = null,
  uso_suelo = 'No',
  concesion_aguas = 'Sí',
  concesion_aguas_vencimiento = null,
  vertimientos = 'No',
  vertimientos_vencimiento = null,
  pueaa = 'No',
  pgris = 'No',
  pozo_septico = 'No',
  alcantarillado = null,
  ica = 'No',
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
  canal_venta = 'B2B',
  exportacion = 'No',
  huella_carbono = 'NO',
  fortalezas_ambiental = 'Realizan  reproducción de material vegetal     para la educación de poder cuidar   y mantener el ecosistema con productos orgánicos y mantenimientos naturales. Utilizan insumos naturales , la madera se recicla  , realizan reforestación con la CDMB , en la misma producción de material se utiliza para otros cultivos.',
  fortalezas_social = 'Hacen parte de la asociación "Hecho en Lebrija", se da a conocer como mujer rural  y enseña a  mas mujeres  dar su impacto positivo, comparte su producto y proceso productivo',
  fortalezas_economico = 'Participación en los eventos , ferias locales',
  emprendimiento_verde = true,
  sello_marca = false,
  avalado = false,
  destacado = false,
  activo = true
where nombre = 'ORQUÍDEAS Y PLANTAS ORNAMENTALES MANANTIAL';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select '11e4a9c6-02a4-4752-ac74-55af0dd705e3', 'ORQUÍDEAS Y PLANTAS ORNAMENTALES MANANTIAL', generar_slug_unico('ORQUÍDEAS Y PLANTAS ORNAMENTALES MANANTIAL', '11e4a9c6-02a4-4752-ac74-55af0dd705e3'), (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'), 'Lebrija', (select id from veredas where municipio = 'Lebrija' and slug = 'san-nicolas-alto'), 'VEREDA SAN NICOLAS ALTO - FINCA EL MANANTIAL', 7.142326111111111, -73.24567611111111, 'Se compran las especies y con las matas madres se realiza el proceso de reproducciòn por hijos, reproducciòn de orquideas y plantas ornamentales', 'Se compran las especies y con las matas madres se realiza el proceso de reproducciòn por hijos, reproducciòn de orquideas y plantas ornamentales', 'PRODUCCIÒN Y VENTA DE ORQUIDEAS Y PLANTAS ORNAMENTALES', '3157542994', '573157542994', 'jeannethem07@gmail.com', 'JEANNETHE MENJURA CALLEJAS', '37626191-0', 'Natural', null, 'Cámara de comercio', 'HEINER ORTIZ', 'ACTIVO', 'Intermedio', 2021, '1.0600 msnm', '73°14''44.434"', '7°8''32.374"', 'Actualizó', 'Se realizo visita y se actualizo ficha de verificacion', null, 'No', 'Sí', null, 'No', null, 'No', 'No', 'No', null, 'No', null, null, null, null, 'No', null, null, null, null, 'No', 'B2B', 'No', 'NO', 'Realizan  reproducción de material vegetal     para la educación de poder cuidar   y mantener el ecosistema con productos orgánicos y mantenimientos naturales. Utilizan insumos naturales , la madera se recicla  , realizan reforestación con la CDMB , en la misma producción de material se utiliza para otros cultivos.', 'Hacen parte de la asociación "Hecho en Lebrija", se da a conocer como mujer rural  y enseña a  mas mujeres  dar su impacto positivo, comparte su producto y proceso productivo', 'Participación en los eventos , ferias locales', true, false, false, false, true
where not exists (select 1 from negocios where nombre = 'ORQUÍDEAS Y PLANTAS ORNAMENTALES MANANTIAL');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'ORQUÍDEAS Y PLANTAS ORNAMENTALES MANANTIAL');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'ORQUÍDEAS Y PLANTAS ORNAMENTALES MANANTIAL'), (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'ORQUÍDEAS Y PLANTAS ORNAMENTALES MANANTIAL');
insert into negocios_subcategorias (negocio_id, subcategoria_id) select (select id from negocios where nombre = 'ORQUÍDEAS Y PLANTAS ORNAMENTALES MANANTIAL'), id from subcategorias where slug = 'biocomercio';
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'ORQUÍDEAS Y PLANTAS ORNAMENTALES MANANTIAL');
insert into negocios_actividades (negocio_id, actividad_productiva_id) select (select id from negocios where nombre = 'ORQUÍDEAS Y PLANTAS ORNAMENTALES MANANTIAL'), id from actividades_productivas where slug = 'productos-fauna-silvestre';
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'ORQUÍDEAS Y PLANTAS ORNAMENTALES MANANTIAL'), 2024, 38.6 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'ORQUÍDEAS Y PLANTAS ORNAMENTALES MANANTIAL'), 2025, 41.1 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;

-- EL VELERO
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'),
  municipio = 'Lebrija',
  vereda_id = (select id from veredas where municipio = 'Lebrija' and slug = 'perimetro-urbano'),
  direccion = 'CALLE 105 #17-176 TORRE 2 APTO 2008 - CONDOMINIO CLUB PROVENZA',
  latitud = null,
  longitud = null,
  descripcion_corta = 'Iniciativa de negocio verde, donde se busca brindar al visitante una experiencia de naturaleza con la flora silvestre y bosque natural',
  descripcion = 'Iniciativa de negocio verde, donde se busca brindar al visitante una experiencia de naturaleza con la flora silvestre y bosque natural',
  producto = 'PARADOR TURISTICO',
  telefono = '3133717151',
  whatsapp = '573133717151',
  email = null,
  representante_legal = 'NESTOR JACINTO LEON',
  nit = '91040650-1',
  naturaleza_juridica = 'Natural',
  delegado = null,
  rut_camara_comercio = null,
  responsable_cdmb = 'DIEGO GUTIERREZ',
  novedad = 'RETIRADO',
  tipo_negocio_verde = null,
  anio_registro = 2023,
  cota_msnm = '73°18''19,4"',
  este = null,
  norte = null,
  aplicacion_ficha_2025 = 'No actualizó',
  observaciones = 'No se realizo visita ni se aplico ficha de verificacion',
  registro_nacional_turismo = 'No',
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
  canal_venta = 'B2B',
  exportacion = null,
  huella_carbono = null,
  fortalezas_ambiental = 'Espacio dedicado a la conservación de fauna y flora para turismo sostenible. Recolección de aguas lluvias y actividades de reciclaje en el parador. Implementación de paneles solares para energías más limpias.',
  fortalezas_social = 'Ofrecer salarios justos atrae y retiene talento local. Priorizar la contratación local fortalece la comunidad y reduce costos. Un ambiente laboral seguro mejora la productividad y el bienestar del personal. Las oportunidades de formación aumentan las habilidades y la motivación del equipo. Los espacios de esparcimiento fomentan la creatividad y el trabajo en equipo.',
  fortalezas_economico = 'Agilidad para ajustar gastos y optimizar operaciones en fase inicial.',
  emprendimiento_verde = true,
  sello_marca = false,
  avalado = false,
  destacado = false,
  activo = false
where nombre = 'EL VELERO';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select 'bafcb670-25a6-410e-b73b-74557c8f6b1a', 'EL VELERO', generar_slug_unico('EL VELERO', 'bafcb670-25a6-410e-b73b-74557c8f6b1a'), (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'), 'Lebrija', (select id from veredas where municipio = 'Lebrija' and slug = 'perimetro-urbano'), 'CALLE 105 #17-176 TORRE 2 APTO 2008 - CONDOMINIO CLUB PROVENZA', null, null, 'Iniciativa de negocio verde, donde se busca brindar al visitante una experiencia de naturaleza con la flora silvestre y bosque natural', 'Iniciativa de negocio verde, donde se busca brindar al visitante una experiencia de naturaleza con la flora silvestre y bosque natural', 'PARADOR TURISTICO', '3133717151', '573133717151', null, 'NESTOR JACINTO LEON', '91040650-1', 'Natural', null, null, 'DIEGO GUTIERREZ', 'RETIRADO', null, 2023, '73°18''19,4"', null, null, 'No actualizó', 'No se realizo visita ni se aplico ficha de verificacion', 'No', null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, 'B2B', null, null, 'Espacio dedicado a la conservación de fauna y flora para turismo sostenible. Recolección de aguas lluvias y actividades de reciclaje en el parador. Implementación de paneles solares para energías más limpias.', 'Ofrecer salarios justos atrae y retiene talento local. Priorizar la contratación local fortalece la comunidad y reduce costos. Un ambiente laboral seguro mejora la productividad y el bienestar del personal. Las oportunidades de formación aumentan las habilidades y la motivación del equipo. Los espacios de esparcimiento fomentan la creatividad y el trabajo en equipo.', 'Agilidad para ajustar gastos y optimizar operaciones en fase inicial.', true, false, false, false, false
where not exists (select 1 from negocios where nombre = 'EL VELERO');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'EL VELERO');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'EL VELERO'), (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'EL VELERO');
insert into negocios_subcategorias (negocio_id, subcategoria_id) select (select id from negocios where nombre = 'EL VELERO'), id from subcategorias where slug = 'turismo-sostenible';
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'EL VELERO');
insert into negocios_actividades (negocio_id, actividad_productiva_id) select (select id from negocios where nombre = 'EL VELERO'), id from actividades_productivas where slug = 'otros-servicios-turismo-sostenible';
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'EL VELERO'), 2024, 27.7 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;

-- LIMPIEZA URBANA S.A.S ESP
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'ecoproductos-industriales'),
  municipio = 'Bucaramanga',
  vereda_id = (select id from veredas where municipio = 'Bucaramanga' and slug = 'perimetro-urbano'),
  direccion = 'CARRERA 19 # 34 -64',
  latitud = 6.974987777777778,
  longitud = -73.09429666666666,
  descripcion_corta = 'Recoleccion y transformación de residuos de poda y tala derivados de las actividades clus de la empresa generando un acondicionador de suelos',
  descripcion = 'Recoleccion y transformación de residuos de poda y tala derivados de las actividades clus de la empresa generando un acondicionador de suelos',
  producto = 'PODA DE ÁRBOLES - ACTIVIDADES DE LIMPIEZA URBANA',
  telefono = '3045904380 - 3112485155',
  whatsapp = '3045904380 - 3112485155',
  email = 'gerencia@limpiezaurbana.com.co',
  representante_legal = 'SHADIA GOMEZ HERNANDEZ',
  nit = '900028989-5',
  naturaleza_juridica = 'Jurídica',
  delegado = 'ANDREA JULIANA MORENO - CRISTIAN SALGUERO',
  rut_camara_comercio = 'Cámara de comercio',
  responsable_cdmb = 'SILVIA VALDIVIESO',
  novedad = 'ACTIVO',
  tipo_negocio_verde = 'Dinamizadoras',
  anio_registro = 2024,
  cota_msnm = '879.1 msnm',
  este = '73°5''39.468"',
  norte = '6°58''29.956"',
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
  ica = 'Sí',
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
  fortalezas_ambiental = 'TRANFORMACION DE RESIDUOS VERDES A BASE DE LAS ACTIVIDADES CLUS DE LA EMPRESA LIMPIEZA URBANA SAS ESP DERIVADO DEL COMPORTAMIENTO DE TRASNFORMACION',
  fortalezas_social = 'La forma de contratar su personal con un enfoque diferencial',
  fortalezas_economico = 'La empresa cuenta con un componente económico alto , sus ingresos son estables y generan una estabilidad comercial',
  emprendimiento_verde = false,
  sello_marca = false,
  avalado = true,
  destacado = false,
  activo = true
where nombre = 'LIMPIEZA URBANA S.A.S ESP';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select 'e6d929c8-c534-4c5f-9ef0-243c3ddd9f09', 'LIMPIEZA URBANA S.A.S ESP', generar_slug_unico('LIMPIEZA URBANA S.A.S ESP', 'e6d929c8-c534-4c5f-9ef0-243c3ddd9f09'), (select id from categorias_oficiales where slug = 'ecoproductos-industriales'), 'Bucaramanga', (select id from veredas where municipio = 'Bucaramanga' and slug = 'perimetro-urbano'), 'CARRERA 19 # 34 -64', 6.974987777777778, -73.09429666666666, 'Recoleccion y transformación de residuos de poda y tala derivados de las actividades clus de la empresa generando un acondicionador de suelos', 'Recoleccion y transformación de residuos de poda y tala derivados de las actividades clus de la empresa generando un acondicionador de suelos', 'PODA DE ÁRBOLES - ACTIVIDADES DE LIMPIEZA URBANA', '3045904380 - 3112485155', '3045904380 - 3112485155', 'gerencia@limpiezaurbana.com.co', 'SHADIA GOMEZ HERNANDEZ', '900028989-5', 'Jurídica', 'ANDREA JULIANA MORENO - CRISTIAN SALGUERO', 'Cámara de comercio', 'SILVIA VALDIVIESO', 'ACTIVO', 'Dinamizadoras', 2024, '879.1 msnm', '73°5''39.468"', '6°58''29.956"', 'Actualizó', 'Se realizo visita y se aplico ficha de verificacion', null, 'Sí', 'Acueducto', null, null, null, 'No', 'Sí', null, 'Sí', 'Sí', null, null, null, null, null, null, null, null, null, 'Sí', 'Mixta', 'No', 'NO', 'TRANFORMACION DE RESIDUOS VERDES A BASE DE LAS ACTIVIDADES CLUS DE LA EMPRESA LIMPIEZA URBANA SAS ESP DERIVADO DEL COMPORTAMIENTO DE TRASNFORMACION', 'La forma de contratar su personal con un enfoque diferencial', 'La empresa cuenta con un componente económico alto , sus ingresos son estables y generan una estabilidad comercial', false, false, true, false, true
where not exists (select 1 from negocios where nombre = 'LIMPIEZA URBANA S.A.S ESP');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'LIMPIEZA URBANA S.A.S ESP');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'LIMPIEZA URBANA S.A.S ESP'), (select id from categorias_oficiales where slug = 'ecoproductos-industriales');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'LIMPIEZA URBANA S.A.S ESP');
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'LIMPIEZA URBANA S.A.S ESP');
insert into negocios_actividades (negocio_id, actividad_productiva_id) select (select id from negocios where nombre = 'LIMPIEZA URBANA S.A.S ESP'), id from actividades_productivas where slug = 'aprovechamiento-residuos-organicos';
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'LIMPIEZA URBANA S.A.S ESP'), 2024, 88.4 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'LIMPIEZA URBANA S.A.S ESP'), 2025, 76.3 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;

-- LEBRIJENSE
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'),
  municipio = 'Lebrija',
  vereda_id = (select id from veredas where municipio = 'Lebrija' and slug = 'perimetro-urbano'),
  direccion = 'CARRERA 7 #10-05',
  latitud = 7.112777777777778,
  longitud = -73.21666666666667,
  descripcion_corta = 'Transformación de la piña para la producción de licor de piña',
  descripcion = 'Transformación de la piña para la producción de licor de piña',
  producto = 'LICOR DE PIÑA',
  telefono = '3123124350',
  whatsapp = '573123124350',
  email = 'claudialrm23@gmail.com',
  representante_legal = 'HARID STIWEN JACOME ABUCHAIBE',
  nit = '1006555021',
  naturaleza_juridica = 'Natural',
  delegado = 'CLAUDIA LORENA RUEDA',
  rut_camara_comercio = 'RUT',
  responsable_cdmb = 'SUJEY DÍAZ',
  novedad = 'ACTIVO',
  tipo_negocio_verde = 'Satisfactorio',
  anio_registro = 2024,
  cota_msnm = '1015.9',
  este = '73°13''0"',
  norte = '7°6''46"',
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
  fortalezas_ambiental = 'El proceso de fermentación es tradicional ,  hacen uso eficiente del agua, las botellas de vidrio que utilizan son reutilizables.',
  fortalezas_social = 'Apoyo institucional a proyectos con impacto social y ambiental.',
  fortalezas_economico = 'Identidad territorial producto hecho 100% en la región, turismo regional como canal de promoción y venta del producto.',
  emprendimiento_verde = true,
  sello_marca = false,
  avalado = false,
  destacado = false,
  activo = true
where nombre = 'LEBRIJENSE';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select '4cf7bdd0-49fe-4b1a-b777-731f1412b91c', 'LEBRIJENSE', generar_slug_unico('LEBRIJENSE', '4cf7bdd0-49fe-4b1a-b777-731f1412b91c'), (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'), 'Lebrija', (select id from veredas where municipio = 'Lebrija' and slug = 'perimetro-urbano'), 'CARRERA 7 #10-05', 7.112777777777778, -73.21666666666667, 'Transformación de la piña para la producción de licor de piña', 'Transformación de la piña para la producción de licor de piña', 'LICOR DE PIÑA', '3123124350', '573123124350', 'claudialrm23@gmail.com', 'HARID STIWEN JACOME ABUCHAIBE', '1006555021', 'Natural', 'CLAUDIA LORENA RUEDA', 'RUT', 'SUJEY DÍAZ', 'ACTIVO', 'Satisfactorio', 2024, '1015.9', '73°13''0"', '7°6''46"', 'Actualizó', 'Se realizo visita y se actualizo ficha de verificacion', null, null, 'Acueducto', null, null, null, 'No', 'No', null, 'Sí', null, null, 'No', null, null, null, null, null, null, null, 'No', 'B2C', 'No', 'NO', 'El proceso de fermentación es tradicional ,  hacen uso eficiente del agua, las botellas de vidrio que utilizan son reutilizables.', 'Apoyo institucional a proyectos con impacto social y ambiental.', 'Identidad territorial producto hecho 100% en la región, turismo regional como canal de promoción y venta del producto.', true, false, false, false, true
where not exists (select 1 from negocios where nombre = 'LEBRIJENSE');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'LEBRIJENSE');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'LEBRIJENSE'), (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'LEBRIJENSE');
insert into negocios_subcategorias (negocio_id, subcategoria_id) select (select id from negocios where nombre = 'LEBRIJENSE'), id from subcategorias where slug = 'agroindustria-sostenible';
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'LEBRIJENSE');
insert into negocios_actividades (negocio_id, actividad_productiva_id) select (select id from negocios where nombre = 'LEBRIJENSE'), id from actividades_productivas where slug = 'agroindustrial-alimentario';
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'LEBRIJENSE'), 2024, 46.4 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'LEBRIJENSE'), 2025, 52.6 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;

-- SABER ANCESTRAL S.A.S
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'ecoproductos-industriales'),
  municipio = 'Rionegro',
  vereda_id = (select id from veredas where municipio = 'Rionegro' and slug = 'portachuelo'),
  direccion = 'KM 24 VÍA AL MAR PARCELA 26 PORTAL PARAISO NATURAL, VDA PUERTACHUELO',
  latitud = 7.3325,
  longitud = -73.16361111111112,
  descripcion_corta = 'Especializarse en tinturado natural, estampación botánica y serigrafía en textiles de fibra natural empleando plantas, semillas y minerales para lograr…',
  descripcion = 'Especializarse en tinturado natural, estampación botánica y serigrafía en textiles de fibra natural empleando plantas, semillas y minerales para lograr creaciones que fusionen el arte con la naturaleza',
  producto = 'PRENDAS ECÓLOGICAS',
  telefono = '3164425062',
  whatsapp = '573164425062',
  email = 'saberancestral2022@gmail.com',
  representante_legal = 'LAURA LILIANA QUINTERO MARIN',
  nit = '901810309-4',
  naturaleza_juridica = 'Jurídica',
  delegado = null,
  rut_camara_comercio = 'Cámara de comercio',
  responsable_cdmb = 'CARINE GARCIA',
  novedad = 'ACTIVO',
  tipo_negocio_verde = 'Satisfactorio',
  anio_registro = 2024,
  cota_msnm = '590 msnm',
  este = '73°9''49"',
  norte = '7°19''57"',
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
  canal_venta = 'Mixta',
  exportacion = 'No',
  huella_carbono = 'NO',
  fortalezas_ambiental = 'Prendas y tintes biodegradables',
  fortalezas_social = 'Vinculación con escuelas y fundaciones',
  fortalezas_economico = 'Buena oferta económica',
  emprendimiento_verde = false,
  sello_marca = false,
  avalado = true,
  destacado = false,
  activo = true
where nombre = 'SABER ANCESTRAL S.A.S';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select '3663d86a-5074-423a-8530-6c804ec8de3d', 'SABER ANCESTRAL S.A.S', generar_slug_unico('SABER ANCESTRAL S.A.S', '3663d86a-5074-423a-8530-6c804ec8de3d'), (select id from categorias_oficiales where slug = 'ecoproductos-industriales'), 'Rionegro', (select id from veredas where municipio = 'Rionegro' and slug = 'portachuelo'), 'KM 24 VÍA AL MAR PARCELA 26 PORTAL PARAISO NATURAL, VDA PUERTACHUELO', 7.3325, -73.16361111111112, 'Especializarse en tinturado natural, estampación botánica y serigrafía en textiles de fibra natural empleando plantas, semillas y minerales para lograr…', 'Especializarse en tinturado natural, estampación botánica y serigrafía en textiles de fibra natural empleando plantas, semillas y minerales para lograr creaciones que fusionen el arte con la naturaleza', 'PRENDAS ECÓLOGICAS', '3164425062', '573164425062', 'saberancestral2022@gmail.com', 'LAURA LILIANA QUINTERO MARIN', '901810309-4', 'Jurídica', null, 'Cámara de comercio', 'CARINE GARCIA', 'ACTIVO', 'Satisfactorio', 2024, '590 msnm', '73°9''49"', '7°19''57"', 'Actualizó', 'Se realizo visita y se actualizo ficha de verificacion', null, 'Sí', 'Acueducto veredal', null, null, null, 'No', 'No', 'Sí', null, null, null, null, null, null, null, null, null, null, null, 'No', 'Mixta', 'No', 'NO', 'Prendas y tintes biodegradables', 'Vinculación con escuelas y fundaciones', 'Buena oferta económica', false, false, true, false, true
where not exists (select 1 from negocios where nombre = 'SABER ANCESTRAL S.A.S');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'SABER ANCESTRAL S.A.S');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'SABER ANCESTRAL S.A.S'), (select id from categorias_oficiales where slug = 'ecoproductos-industriales');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'SABER ANCESTRAL S.A.S');
insert into negocios_subcategorias (negocio_id, subcategoria_id) select (select id from negocios where nombre = 'SABER ANCESTRAL S.A.S'), id from subcategorias where slug = 'moda-sostenible';
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'SABER ANCESTRAL S.A.S');
insert into negocios_actividades (negocio_id, actividad_productiva_id) select (select id from negocios where nombre = 'SABER ANCESTRAL S.A.S'), id from actividades_productivas where slug = 'textiles-sostenibles';
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'SABER ANCESTRAL S.A.S'), 2024, 69.7 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'SABER ANCESTRAL S.A.S'), 2025, 69.3 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;

-- SDROLL
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'calidad-ambiental'),
  municipio = 'Bucaramanga',
  vereda_id = (select id from veredas where municipio = 'Bucaramanga' and slug = 'perimetro-urbano'),
  direccion = 'CARRERA 22 # 35 - 35',
  latitud = 7.121944444444444,
  longitud = -73.11555555555555,
  descripcion_corta = 'Venta y reparación de patinetas, motocicletas, motopatines, patines eléctricos',
  descripcion = 'Venta y reparación de patinetas, motocicletas, motopatines, patines eléctricos',
  producto = 'VENTA Y SERVICIOS DE REPARACIÓN Y MANTENIMIENTOS DE VEHICULOS ELECTRICOS',
  telefono = '3154234916',
  whatsapp = '573154234916',
  email = 'sdroll.co@gmail.com',
  representante_legal = 'DANIEL SANCHEZ QUIROZ',
  nit = '1098702563-5',
  naturaleza_juridica = 'Natural',
  delegado = 'PAOLA ORTEGA',
  rut_camara_comercio = 'Cámara de comercio',
  responsable_cdmb = 'SEBASTIAN BONNET',
  novedad = 'ACTIVO',
  tipo_negocio_verde = 'Satisfactorio',
  anio_registro = 2024,
  cota_msnm = '980 msnm',
  este = '73°6''56"',
  norte = '7°7''19"',
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
  fortalezas_ambiental = 'Baterías de mejor calidad y mayor duración',
  fortalezas_social = 'Mejorar la movilidad de las personas',
  fortalezas_economico = 'Buena oferta económica',
  emprendimiento_verde = false,
  sello_marca = false,
  avalado = true,
  destacado = false,
  activo = true
where nombre = 'SDROLL';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select '7a17e457-7eb1-4fab-8303-adf3079f2da8', 'SDROLL', generar_slug_unico('SDROLL', '7a17e457-7eb1-4fab-8303-adf3079f2da8'), (select id from categorias_oficiales where slug = 'calidad-ambiental'), 'Bucaramanga', (select id from veredas where municipio = 'Bucaramanga' and slug = 'perimetro-urbano'), 'CARRERA 22 # 35 - 35', 7.121944444444444, -73.11555555555555, 'Venta y reparación de patinetas, motocicletas, motopatines, patines eléctricos', 'Venta y reparación de patinetas, motocicletas, motopatines, patines eléctricos', 'VENTA Y SERVICIOS DE REPARACIÓN Y MANTENIMIENTOS DE VEHICULOS ELECTRICOS', '3154234916', '573154234916', 'sdroll.co@gmail.com', 'DANIEL SANCHEZ QUIROZ', '1098702563-5', 'Natural', 'PAOLA ORTEGA', 'Cámara de comercio', 'SEBASTIAN BONNET', 'ACTIVO', 'Satisfactorio', 2024, '980 msnm', '73°6''56"', '7°7''19"', 'Actualizó', 'Se realizo visita y se actualizo ficha de verificacion', null, 'No', 'Acueducto', null, null, null, 'No', 'No', null, 'Sí', null, null, null, null, null, null, null, null, null, null, 'No', 'B2C', 'No', 'NO', 'Baterías de mejor calidad y mayor duración', 'Mejorar la movilidad de las personas', 'Buena oferta económica', false, false, true, false, true
where not exists (select 1 from negocios where nombre = 'SDROLL');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'SDROLL');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'SDROLL'), (select id from categorias_oficiales where slug = 'calidad-ambiental');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'SDROLL');
insert into negocios_subcategorias (negocio_id, subcategoria_id) select (select id from negocios where nombre = 'SDROLL'), id from subcategorias where slug = 'transporte-sostenible';
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'SDROLL');
insert into negocios_actividades (negocio_id, actividad_productiva_id) select (select id from negocios where nombre = 'SDROLL'), id from actividades_productivas where slug = 'motorizado';
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'SDROLL'), 2024, 51.5 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'SDROLL'), 2025, 58.1 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;

-- SOLUCIONES AMBIENTALES ECOAM S.A.S
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'calidad-ambiental'),
  municipio = 'California',
  vereda_id = (select id from veredas where municipio = 'California' and slug = 'perimetro-urbano'),
  direccion = 'DIAGONAL 1 #1-61 California',
  latitud = 7.347222222222222,
  longitud = -72.94777777777779,
  descripcion_corta = 'Recuperación paisajista, comercialización de productos agricolas y forestales, consultoria y asesorías en ambientales y forestales para la recuperación…',
  descripcion = 'Recuperación paisajista, comercialización de productos agricolas y forestales, consultoria y asesorías en ambientales y forestales para la recuperación morfologica y paisajista de áreas intervenidas, prestación de asesorías para la implementación de buenas prácticas agropecuarias y ambientales',
  producto = 'RECUPERACIÓN DE ECOSISTEMAS',
  telefono = '3138501405',
  whatsapp = '573138501405',
  email = 'facturacion@ecoamsa.com - leilygarcia1@gmail.com',
  representante_legal = 'LEILY VIVIANA GARCIA PARADA',
  nit = '901420061-1',
  naturaleza_juridica = 'Jurídica',
  delegado = null,
  rut_camara_comercio = 'Cámara de comercio',
  responsable_cdmb = 'SEBASTIAN BONNET',
  novedad = 'ACTIVO',
  tipo_negocio_verde = 'Avanzado',
  anio_registro = 2024,
  cota_msnm = '2.005 msnm',
  este = '72°56''52"',
  norte = '7°20''50"',
  aplicacion_ficha_2025 = 'Actualizó',
  observaciones = 'Se realizo visita y se actualizo ficha de verificacion',
  registro_nacional_turismo = null,
  uso_suelo = 'No',
  concesion_aguas = 'Acueducto veredal',
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
  fortalezas_ambiental = 'Recuperación de ecosistemas',
  fortalezas_social = 'Impacto positivo en las comunidades por medio de la recuperación de ecosisrenas y transmitiendo información a los niños y niñas',
  fortalezas_economico = 'Buena oferta económica',
  emprendimiento_verde = false,
  sello_marca = true,
  avalado = true,
  destacado = false,
  activo = true
where nombre = 'SOLUCIONES AMBIENTALES ECOAM S.A.S';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select '2289c0e2-a8ee-47ad-97ed-ca8e6caf5b27', 'SOLUCIONES AMBIENTALES ECOAM S.A.S', generar_slug_unico('SOLUCIONES AMBIENTALES ECOAM S.A.S', '2289c0e2-a8ee-47ad-97ed-ca8e6caf5b27'), (select id from categorias_oficiales where slug = 'calidad-ambiental'), 'California', (select id from veredas where municipio = 'California' and slug = 'perimetro-urbano'), 'DIAGONAL 1 #1-61 California', 7.347222222222222, -72.94777777777779, 'Recuperación paisajista, comercialización de productos agricolas y forestales, consultoria y asesorías en ambientales y forestales para la recuperación…', 'Recuperación paisajista, comercialización de productos agricolas y forestales, consultoria y asesorías en ambientales y forestales para la recuperación morfologica y paisajista de áreas intervenidas, prestación de asesorías para la implementación de buenas prácticas agropecuarias y ambientales', 'RECUPERACIÓN DE ECOSISTEMAS', '3138501405', '573138501405', 'facturacion@ecoamsa.com - leilygarcia1@gmail.com', 'LEILY VIVIANA GARCIA PARADA', '901420061-1', 'Jurídica', null, 'Cámara de comercio', 'SEBASTIAN BONNET', 'ACTIVO', 'Avanzado', 2024, '2.005 msnm', '72°56''52"', '7°20''50"', 'Actualizó', 'Se realizo visita y se actualizo ficha de verificacion', null, 'No', 'Acueducto veredal', null, null, null, 'No', 'Sí', null, 'Sí', null, null, null, null, null, null, null, null, null, null, 'Sí', 'B2B', 'No', 'NO', 'Recuperación de ecosistemas', 'Impacto positivo en las comunidades por medio de la recuperación de ecosisrenas y transmitiendo información a los niños y niñas', 'Buena oferta económica', false, true, true, false, true
where not exists (select 1 from negocios where nombre = 'SOLUCIONES AMBIENTALES ECOAM S.A.S');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'SOLUCIONES AMBIENTALES ECOAM S.A.S');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'SOLUCIONES AMBIENTALES ECOAM S.A.S'), (select id from categorias_oficiales where slug = 'calidad-ambiental');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'SOLUCIONES AMBIENTALES ECOAM S.A.S');
insert into negocios_subcategorias (negocio_id, subcategoria_id) select (select id from negocios where nombre = 'SOLUCIONES AMBIENTALES ECOAM S.A.S'), id from subcategorias where slug = 'preservacion-restauracion-ecosistemas';
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'SOLUCIONES AMBIENTALES ECOAM S.A.S');
insert into negocios_actividades (negocio_id, actividad_productiva_id) select (select id from negocios where nombre = 'SOLUCIONES AMBIENTALES ECOAM S.A.S'), id from actividades_productivas where slug = 'recuperacion-remediacion';
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'SOLUCIONES AMBIENTALES ECOAM S.A.S'), 2024, 72.2 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'SOLUCIONES AMBIENTALES ECOAM S.A.S'), 2025, 75.9 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;

-- CHONCHOS DE LA MONTAÑA S.A.S.
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'),
  municipio = 'Suratá',
  vereda_id = (select id from veredas where municipio = 'Suratá' and slug = 'la-violeta'),
  direccion = 'FINCA CASA DE TEJA, VEREDA LA VIOLETA, CACHIRÍ SURATA',
  latitud = 7.474166666666667,
  longitud = -72.99305555555556,
  descripcion_corta = 'Cria, ceba, producción y beneficio de ganado porcino, así como su transformación en productos carnicos y subproductos, su comercialización y distribución a…',
  descripcion = 'Cria, ceba, producción y beneficio de ganado porcino, así como su transformación en productos carnicos y subproductos, su comercialización y distribución a nivel nacional e internacional, el comercio al por menor de carnes y productos carnicos, cria del ganado porcino',
  producto = 'PORCINO EN PIE',
  telefono = '3105607016',
  whatsapp = '573105607016',
  email = 'michelldanilobautista@gmail.com',
  representante_legal = 'MICHELL DANILO BAUTISTA DIAZ',
  nit = '901817891-1',
  naturaleza_juridica = 'Jurídica',
  delegado = null,
  rut_camara_comercio = 'Cámara de comercio',
  responsable_cdmb = 'SEBASTIAN BONNET',
  novedad = 'ACTIVO',
  tipo_negocio_verde = 'Satisfactorio',
  anio_registro = 2024,
  cota_msnm = '2.118 msnm',
  este = '72°59''35"',
  norte = '7°28''27"',
  aplicacion_ficha_2025 = 'No actualizó',
  observaciones = 'No se realizo visita ni se actualizo ficha de verificacion',
  registro_nacional_turismo = null,
  uso_suelo = 'Sí',
  concesion_aguas = 'No',
  concesion_aguas_vencimiento = null,
  vertimientos = 'No',
  vertimientos_vencimiento = null,
  pueaa = 'No',
  pgris = 'No',
  pozo_septico = 'No',
  alcantarillado = null,
  ica = 'Sí',
  ica_vencimiento = null,
  invima = null,
  invima_vencimiento = null,
  certificado_tenencia_animales = 'No',
  buenas_practicas_agricolas = null,
  buenas_practicas_apicolas = null,
  registro_apicola = null,
  intervencion_cauce = 'No',
  capacidad_carga = null,
  sstt = 'No',
  canal_venta = 'B2B',
  exportacion = 'No',
  huella_carbono = 'NO',
  fortalezas_ambiental = 'Silvopastoreo',
  fortalezas_social = 'Creación de asociación con victimas del conflicto armado',
  fortalezas_economico = 'Buena oferta económica',
  emprendimiento_verde = true,
  sello_marca = false,
  avalado = false,
  destacado = false,
  activo = true
where nombre = 'CHONCHOS DE LA MONTAÑA S.A.S.';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select 'e3b8508e-f109-4331-b866-8c53e4ee94bc', 'CHONCHOS DE LA MONTAÑA S.A.S.', generar_slug_unico('CHONCHOS DE LA MONTAÑA S.A.S.', 'e3b8508e-f109-4331-b866-8c53e4ee94bc'), (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'), 'Suratá', (select id from veredas where municipio = 'Suratá' and slug = 'la-violeta'), 'FINCA CASA DE TEJA, VEREDA LA VIOLETA, CACHIRÍ SURATA', 7.474166666666667, -72.99305555555556, 'Cria, ceba, producción y beneficio de ganado porcino, así como su transformación en productos carnicos y subproductos, su comercialización y distribución a…', 'Cria, ceba, producción y beneficio de ganado porcino, así como su transformación en productos carnicos y subproductos, su comercialización y distribución a nivel nacional e internacional, el comercio al por menor de carnes y productos carnicos, cria del ganado porcino', 'PORCINO EN PIE', '3105607016', '573105607016', 'michelldanilobautista@gmail.com', 'MICHELL DANILO BAUTISTA DIAZ', '901817891-1', 'Jurídica', null, 'Cámara de comercio', 'SEBASTIAN BONNET', 'ACTIVO', 'Satisfactorio', 2024, '2.118 msnm', '72°59''35"', '7°28''27"', 'No actualizó', 'No se realizo visita ni se actualizo ficha de verificacion', null, 'Sí', 'No', null, 'No', null, 'No', 'No', 'No', null, 'Sí', null, null, null, 'No', null, null, null, 'No', null, 'No', 'B2B', 'No', 'NO', 'Silvopastoreo', 'Creación de asociación con victimas del conflicto armado', 'Buena oferta económica', true, false, false, false, true
where not exists (select 1 from negocios where nombre = 'CHONCHOS DE LA MONTAÑA S.A.S.');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'CHONCHOS DE LA MONTAÑA S.A.S.');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'CHONCHOS DE LA MONTAÑA S.A.S.'), (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'CHONCHOS DE LA MONTAÑA S.A.S.');
insert into negocios_subcategorias (negocio_id, subcategoria_id) select (select id from negocios where nombre = 'CHONCHOS DE LA MONTAÑA S.A.S.'), id from subcategorias where slug = 'agrosistemas-sostenibles';
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'CHONCHOS DE LA MONTAÑA S.A.S.');
insert into negocios_actividades (negocio_id, actividad_productiva_id) select (select id from negocios where nombre = 'CHONCHOS DE LA MONTAÑA S.A.S.'), id from actividades_productivas where slug = 'ganaderia-sostenible';
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'CHONCHOS DE LA MONTAÑA S.A.S.'), 2024, 66.1 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;

-- CALZADO SASHA SAS
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'ecoproductos-industriales'),
  municipio = 'Bucaramanga',
  vereda_id = (select id from veredas where municipio = 'Bucaramanga' and slug = 'perimetro-urbano'),
  direccion = 'CRA 27 #20-24',
  latitud = null,
  longitud = -73.11944444444444,
  descripcion_corta = 'Fabricación de calzado para dama, caballero, niño y niña, en materiales como cueros, sintéticos o textiles. Comercializar calzado a nivel nacional e…',
  descripcion = 'Fabricación de calzado para dama, caballero, niño y niña, en materiales como cueros, sintéticos o textiles. Comercializar calzado a nivel nacional e internacional',
  producto = 'ZAPATO TEXTIL',
  telefono = '3208677489',
  whatsapp = '573208677489',
  email = 'gerencia.calzadosacha@gmail.com',
  representante_legal = 'SANDRA PATRICIA OLIVEROS CASTELLANOS',
  nit = '900583203-4',
  naturaleza_juridica = 'Jurídica',
  delegado = null,
  rut_camara_comercio = 'Cámara de comercio y RUT',
  responsable_cdmb = 'CRISTAL VILLAREAL',
  novedad = 'ACTIVO',
  tipo_negocio_verde = 'Satisfactorio',
  anio_registro = 2024,
  cota_msnm = '959 msnm',
  este = '73°7''10"',
  norte = '7°7''145"',
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
  fortalezas_ambiental = null,
  fortalezas_social = null,
  fortalezas_economico = 'Buena oferta económica',
  emprendimiento_verde = true,
  sello_marca = false,
  avalado = false,
  destacado = false,
  activo = true
where nombre = 'CALZADO SASHA SAS';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select 'e8f5ca2d-b1ff-4820-9f75-762267bf987b', 'CALZADO SASHA SAS', generar_slug_unico('CALZADO SASHA SAS', 'e8f5ca2d-b1ff-4820-9f75-762267bf987b'), (select id from categorias_oficiales where slug = 'ecoproductos-industriales'), 'Bucaramanga', (select id from veredas where municipio = 'Bucaramanga' and slug = 'perimetro-urbano'), 'CRA 27 #20-24', null, -73.11944444444444, 'Fabricación de calzado para dama, caballero, niño y niña, en materiales como cueros, sintéticos o textiles. Comercializar calzado a nivel nacional e…', 'Fabricación de calzado para dama, caballero, niño y niña, en materiales como cueros, sintéticos o textiles. Comercializar calzado a nivel nacional e internacional', 'ZAPATO TEXTIL', '3208677489', '573208677489', 'gerencia.calzadosacha@gmail.com', 'SANDRA PATRICIA OLIVEROS CASTELLANOS', '900583203-4', 'Jurídica', null, 'Cámara de comercio y RUT', 'CRISTAL VILLAREAL', 'ACTIVO', 'Satisfactorio', 2024, '959 msnm', '73°7''10"', '7°7''145"', 'Actualizó', 'Se realizo visita y se actualizo ficha de verificacion', null, 'No', 'Acueducto', null, null, null, 'No', 'No', null, 'Sí', null, null, null, null, null, null, null, null, null, null, 'No', 'B2B', null, null, null, null, 'Buena oferta económica', true, false, false, false, true
where not exists (select 1 from negocios where nombre = 'CALZADO SASHA SAS');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'CALZADO SASHA SAS');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'CALZADO SASHA SAS'), (select id from categorias_oficiales where slug = 'ecoproductos-industriales');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'CALZADO SASHA SAS');
insert into negocios_subcategorias (negocio_id, subcategoria_id) select (select id from negocios where nombre = 'CALZADO SASHA SAS'), id from subcategorias where slug = 'moda-sostenible';
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'CALZADO SASHA SAS');
insert into negocios_actividades (negocio_id, actividad_productiva_id) select (select id from negocios where nombre = 'CALZADO SASHA SAS'), id from actividades_productivas where slug = 'confeccion-manufactura';
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'CALZADO SASHA SAS'), 2024, 57.2 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'CALZADO SASHA SAS'), 2025, 51.5 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;


commit;
