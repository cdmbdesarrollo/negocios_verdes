begin;

-- Generado por lib/migraciones/generar_0026.py desde BASE_ACTUALIZADA_NV_ka.xlsx — no editar a mano.
-- Uno de varios archivos partidos (ver README.md) — correr TODOS, en cualquier orden, cada uno es su propia transacción.

-- Parte 10 de 17.

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

-- HOTEL TURISTICO "LA MANSIÓN DEL MONO"
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'),
  municipio = 'Piedecuesta',
  vereda_id = (select id from veredas where municipio = 'Piedecuesta' and slug = 'perimetro-urbano'),
  direccion = 'CALLE 67 # 26-15 EDIFICIO PARQUE CENTRAL',
  latitud = 12.56671,
  longitud = -11.11703,
  descripcion_corta = 'Iniciativa de negocio verde, donde se busca brindar al visitante una experiencia de naturaleza con la flora silvestre y bosque natural',
  descripcion = 'Iniciativa de negocio verde, donde se busca brindar al visitante una experiencia de naturaleza con la flora silvestre y bosque natural',
  producto = 'TURISMO',
  telefono = '3163031024',
  whatsapp = '573163031024',
  email = null,
  representante_legal = 'ANGEL GONZALO MANCILlA',
  nit = null,
  naturaleza_juridica = null,
  delegado = null,
  rut_camara_comercio = null,
  responsable_cdmb = 'DIEGO GUTIERREZ',
  novedad = 'RETIRADO',
  tipo_negocio_verde = 'Inicial',
  anio_registro = 2023,
  cota_msnm = '1580 msnm',
  este = '11.11703',
  norte = '12.56671',
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
  fortalezas_ambiental = null,
  fortalezas_social = null,
  fortalezas_economico = null,
  emprendimiento_verde = true,
  sello_marca = false,
  avalado = false,
  destacado = false,
  activo = false
where nombre = 'HOTEL TURISTICO "LA MANSIÓN DEL MONO"';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select 'dcb2db85-9423-430b-9d59-afae1baaa5b3', 'HOTEL TURISTICO "LA MANSIÓN DEL MONO"', generar_slug_unico('HOTEL TURISTICO "LA MANSIÓN DEL MONO"', 'dcb2db85-9423-430b-9d59-afae1baaa5b3'), (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'), 'Piedecuesta', (select id from veredas where municipio = 'Piedecuesta' and slug = 'perimetro-urbano'), 'CALLE 67 # 26-15 EDIFICIO PARQUE CENTRAL', 12.56671, -11.11703, 'Iniciativa de negocio verde, donde se busca brindar al visitante una experiencia de naturaleza con la flora silvestre y bosque natural', 'Iniciativa de negocio verde, donde se busca brindar al visitante una experiencia de naturaleza con la flora silvestre y bosque natural', 'TURISMO', '3163031024', '573163031024', null, 'ANGEL GONZALO MANCILlA', null, null, null, null, 'DIEGO GUTIERREZ', 'RETIRADO', 'Inicial', 2023, '1580 msnm', '11.11703', '12.56671', 'No actualizó', 'No se realizo visita ni se aplico ficha de verificacion', 'No', null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, 'B2B', null, null, null, null, null, true, false, false, false, false
where not exists (select 1 from negocios where nombre = 'HOTEL TURISTICO "LA MANSIÓN DEL MONO"');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'HOTEL TURISTICO "LA MANSIÓN DEL MONO"');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'HOTEL TURISTICO "LA MANSIÓN DEL MONO"'), (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'HOTEL TURISTICO "LA MANSIÓN DEL MONO"');
insert into negocios_subcategorias (negocio_id, subcategoria_id) select (select id from negocios where nombre = 'HOTEL TURISTICO "LA MANSIÓN DEL MONO"'), id from subcategorias where slug = 'turismo-sostenible';
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'HOTEL TURISTICO "LA MANSIÓN DEL MONO"');
insert into negocios_actividades (negocio_id, actividad_productiva_id) select (select id from negocios where nombre = 'HOTEL TURISTICO "LA MANSIÓN DEL MONO"'), id from actividades_productivas where slug = 'otros-servicios-turismo-sostenible';

-- CHOCOLATERIA FORTUNA
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'),
  municipio = 'Rionegro',
  vereda_id = (select id from veredas where municipio = 'Rionegro' and slug = 'popas'),
  direccion = 'FINCA MI FORTUNA VEREDA POPAS - LLANO DE PALMAS - RIONEGRO',
  latitud = 7.278288888888889,
  longitud = -73.19865833333334,
  descripcion_corta = 'Empresa cultivadora y transformadora de cacao - Confiteria de chocolate',
  descripcion = 'Empresa cultivadora y transformadora de cacao - Confiteria de chocolate',
  producto = 'TABLETA DE CHOCOLATINA',
  telefono = '32033371571',
  whatsapp = '32033371571',
  email = 'esauacevedo@gmail.com',
  representante_legal = 'ESAU ACEVEDO SANCHEZ',
  nit = '91253469-7',
  naturaleza_juridica = 'Natural',
  delegado = null,
  rut_camara_comercio = 'Cámara de comercio y RUT',
  responsable_cdmb = 'CRISTAL VILLAREAL',
  novedad = 'ACTIVO',
  tipo_negocio_verde = 'Dinamizadoras',
  anio_registro = 2023,
  cota_msnm = '983 msnm',
  este = '73°11''55,17"',
  norte = '7°16''41,84"',
  aplicacion_ficha_2025 = 'Actualizó',
  observaciones = 'Se realizo visita y se actualizo ficha de verificacion',
  registro_nacional_turismo = null,
  uso_suelo = 'No',
  concesion_aguas = 'No',
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
  buenas_practicas_agricolas = 'No',
  buenas_practicas_apicolas = null,
  registro_apicola = null,
  intervencion_cauce = null,
  capacidad_carga = null,
  sstt = 'No',
  canal_venta = 'Mixta',
  exportacion = null,
  huella_carbono = null,
  fortalezas_ambiental = 'Paneles solares',
  fortalezas_social = 'Generan empleo en la zona aledaña',
  fortalezas_economico = 'Variedad de productos y posicionamiento de su linea premiun',
  emprendimiento_verde = true,
  sello_marca = false,
  avalado = false,
  destacado = false,
  activo = true
where nombre = 'CHOCOLATERIA FORTUNA';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select 'ec13953b-c96f-498a-a81e-236cce2c95fd', 'CHOCOLATERIA FORTUNA', generar_slug_unico('CHOCOLATERIA FORTUNA', 'ec13953b-c96f-498a-a81e-236cce2c95fd'), (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'), 'Rionegro', (select id from veredas where municipio = 'Rionegro' and slug = 'popas'), 'FINCA MI FORTUNA VEREDA POPAS - LLANO DE PALMAS - RIONEGRO', 7.278288888888889, -73.19865833333334, 'Empresa cultivadora y transformadora de cacao - Confiteria de chocolate', 'Empresa cultivadora y transformadora de cacao - Confiteria de chocolate', 'TABLETA DE CHOCOLATINA', '32033371571', '32033371571', 'esauacevedo@gmail.com', 'ESAU ACEVEDO SANCHEZ', '91253469-7', 'Natural', null, 'Cámara de comercio y RUT', 'CRISTAL VILLAREAL', 'ACTIVO', 'Dinamizadoras', 2023, '983 msnm', '73°11''55,17"', '7°16''41,84"', 'Actualizó', 'Se realizo visita y se actualizo ficha de verificacion', null, 'No', 'No', null, null, null, 'No', 'No', 'No', 'Sí', null, null, 'No', null, null, 'No', null, null, null, null, 'No', 'Mixta', null, null, 'Paneles solares', 'Generan empleo en la zona aledaña', 'Variedad de productos y posicionamiento de su linea premiun', true, false, false, false, true
where not exists (select 1 from negocios where nombre = 'CHOCOLATERIA FORTUNA');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'CHOCOLATERIA FORTUNA');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'CHOCOLATERIA FORTUNA'), (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'CHOCOLATERIA FORTUNA');
insert into negocios_subcategorias (negocio_id, subcategoria_id) select (select id from negocios where nombre = 'CHOCOLATERIA FORTUNA'), id from subcategorias where slug = 'agroindustria-sostenible';
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'CHOCOLATERIA FORTUNA');
insert into negocios_actividades (negocio_id, actividad_productiva_id) select (select id from negocios where nombre = 'CHOCOLATERIA FORTUNA'), id from actividades_productivas where slug = 'agroindustrial-alimentario';
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'CHOCOLATERIA FORTUNA'), 2024, 75.2 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'CHOCOLATERIA FORTUNA'), 2025, 65.1 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;

-- DES AMB & ART - WILDER MEJIA LASCARO
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'pendiente-clasificar'),
  municipio = 'Rionegro',
  vereda_id = null,
  direccion = 'LA GRACIA DE DIOS, SECTOR EL PLAN CASA 37',
  latitud = 7.155,
  longitud = -73.30388888888889,
  descripcion_corta = null,
  descripcion = null,
  producto = 'RECICLAJE DE PLASTICO',
  telefono = '3105714848',
  whatsapp = '573105714848',
  email = null,
  representante_legal = 'WILDER MEJIA LASCARO',
  nit = '88257615',
  naturaleza_juridica = null,
  delegado = null,
  rut_camara_comercio = null,
  responsable_cdmb = 'SILVIA GARCIA',
  novedad = 'SUSPENDIDO',
  tipo_negocio_verde = 'Inicial',
  anio_registro = 2023,
  cota_msnm = '818 msnm',
  este = '73°18''14"',
  norte = '7°09''18"',
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
where nombre = 'DES AMB & ART - WILDER MEJIA LASCARO';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select '88c11759-48b3-4ca7-99c9-c559bcd2dfbc', 'DES AMB & ART - WILDER MEJIA LASCARO', generar_slug_unico('DES AMB & ART - WILDER MEJIA LASCARO', '88c11759-48b3-4ca7-99c9-c559bcd2dfbc'), (select id from categorias_oficiales where slug = 'pendiente-clasificar'), 'Rionegro', null, 'LA GRACIA DE DIOS, SECTOR EL PLAN CASA 37', 7.155, -73.30388888888889, null, null, 'RECICLAJE DE PLASTICO', '3105714848', '573105714848', null, 'WILDER MEJIA LASCARO', '88257615', null, null, null, 'SILVIA GARCIA', 'SUSPENDIDO', 'Inicial', 2023, '818 msnm', '73°18''14"', '7°09''18"', null, 'ingresa al programa', null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, true, false, false, false, false
where not exists (select 1 from negocios where nombre = 'DES AMB & ART - WILDER MEJIA LASCARO');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'DES AMB & ART - WILDER MEJIA LASCARO');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'DES AMB & ART - WILDER MEJIA LASCARO'), (select id from categorias_oficiales where slug = 'pendiente-clasificar');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'DES AMB & ART - WILDER MEJIA LASCARO');
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'DES AMB & ART - WILDER MEJIA LASCARO');

-- PAÑALES ECOLÓGICOS BBCÓ
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'ecoproductos-industriales'),
  municipio = 'Bucaramanga',
  vereda_id = (select id from veredas where municipio = 'Bucaramanga' and slug = 'perimetro-urbano'),
  direccion = 'AVENIDA LOS BUCAROS # 3 - 155 CONJUNTO RESIDENCIAL MARSELLA REAL TORRE 8 APTO 305-CIUDADELA REAL DE MINAS',
  latitud = null,
  longitud = null,
  descripcion_corta = 'Fabricación de pañales ecológicos de tela reutilizables e insertos absorbentes que minimizan el daño ambiental y aportar a la salud infantil.',
  descripcion = 'Fabricación de pañales ecológicos de tela reutilizables e insertos absorbentes que minimizan el daño ambiental y aportar a la salud infantil.',
  producto = 'PAÑALES ECOLÓGICOS DE TELA REUTILIZABLES',
  telefono = '3186382761',
  whatsapp = '573186382761',
  email = 'bbcoame@outlook.es',
  representante_legal = 'CLAUDIA PATRICIA GARCIA MOYANO',
  nit = '1098633127',
  naturaleza_juridica = 'Natural',
  delegado = null,
  rut_camara_comercio = 'Cámara de comercio y RUT',
  responsable_cdmb = 'CRISTAL VILLAREAL',
  novedad = 'ACTIVO',
  tipo_negocio_verde = 'Dinamizadoras',
  anio_registro = 2023,
  cota_msnm = '969.7 msnm',
  este = '73°12760614',
  norte = '7°10453228',
  aplicacion_ficha_2025 = 'Actualizó',
  observaciones = 'Se realizo visita y se aplico ficha de verificacion',
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
  canal_venta = 'Mixta',
  exportacion = null,
  huella_carbono = null,
  fortalezas_ambiental = 'SI, Sustituye al pañal desechable plástico que afecta los rellenos sanitarios, fuentes hídricas y se complementa con insertos absorbentes de bambú.
-No se utilizan materiales peligrosos y/o tóxicos en los procesos.',
  fortalezas_social = 'Campañas de consumo consciente y en armonía con la naturaleza por medio de las redes sociales.
- Trabajo comunitario ya que la mamá de la representante legal es Edil de la com 7 Bga
- Concientización en ferias  a madres lactantes.',
  fortalezas_economico = 'Tiene claro algunos costos y gastos pero no la totalidad de operación del negocio.
-Excel – Registros financieros
- 3era Feria R de negocios verdes CDMB 2024',
  emprendimiento_verde = true,
  sello_marca = false,
  avalado = false,
  destacado = false,
  activo = true
where nombre = 'PAÑALES ECOLÓGICOS BBCÓ';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select '1252bf6d-b1c0-4c29-b7c5-1aa20a31b798', 'PAÑALES ECOLÓGICOS BBCÓ', generar_slug_unico('PAÑALES ECOLÓGICOS BBCÓ', '1252bf6d-b1c0-4c29-b7c5-1aa20a31b798'), (select id from categorias_oficiales where slug = 'ecoproductos-industriales'), 'Bucaramanga', (select id from veredas where municipio = 'Bucaramanga' and slug = 'perimetro-urbano'), 'AVENIDA LOS BUCAROS # 3 - 155 CONJUNTO RESIDENCIAL MARSELLA REAL TORRE 8 APTO 305-CIUDADELA REAL DE MINAS', null, null, 'Fabricación de pañales ecológicos de tela reutilizables e insertos absorbentes que minimizan el daño ambiental y aportar a la salud infantil.', 'Fabricación de pañales ecológicos de tela reutilizables e insertos absorbentes que minimizan el daño ambiental y aportar a la salud infantil.', 'PAÑALES ECOLÓGICOS DE TELA REUTILIZABLES', '3186382761', '573186382761', 'bbcoame@outlook.es', 'CLAUDIA PATRICIA GARCIA MOYANO', '1098633127', 'Natural', null, 'Cámara de comercio y RUT', 'CRISTAL VILLAREAL', 'ACTIVO', 'Dinamizadoras', 2023, '969.7 msnm', '73°12760614', '7°10453228', 'Actualizó', 'Se realizo visita y se aplico ficha de verificacion', null, 'No', 'Acueducto', null, null, null, 'No', 'No', null, 'Sí', null, null, null, null, null, null, null, null, null, null, 'No', 'Mixta', null, null, 'SI, Sustituye al pañal desechable plástico que afecta los rellenos sanitarios, fuentes hídricas y se complementa con insertos absorbentes de bambú.
-No se utilizan materiales peligrosos y/o tóxicos en los procesos.', 'Campañas de consumo consciente y en armonía con la naturaleza por medio de las redes sociales.
- Trabajo comunitario ya que la mamá de la representante legal es Edil de la com 7 Bga
- Concientización en ferias  a madres lactantes.', 'Tiene claro algunos costos y gastos pero no la totalidad de operación del negocio.
-Excel – Registros financieros
- 3era Feria R de negocios verdes CDMB 2024', true, false, false, false, true
where not exists (select 1 from negocios where nombre = 'PAÑALES ECOLÓGICOS BBCÓ');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'PAÑALES ECOLÓGICOS BBCÓ');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'PAÑALES ECOLÓGICOS BBCÓ'), (select id from categorias_oficiales where slug = 'ecoproductos-industriales');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'PAÑALES ECOLÓGICOS BBCÓ');
insert into negocios_subcategorias (negocio_id, subcategoria_id) select (select id from negocios where nombre = 'PAÑALES ECOLÓGICOS BBCÓ'), id from subcategorias where slug = 'moda-sostenible';
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'PAÑALES ECOLÓGICOS BBCÓ');
insert into negocios_actividades (negocio_id, actividad_productiva_id) select (select id from negocios where nombre = 'PAÑALES ECOLÓGICOS BBCÓ'), id from actividades_productivas where slug = 'confeccion-manufactura';
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'PAÑALES ECOLÓGICOS BBCÓ'), 2024, 41.0 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'PAÑALES ECOLÓGICOS BBCÓ'), 2025, 51.9 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;

-- RESERVA LOS ABUELOS
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'),
  municipio = 'Bucaramanga',
  vereda_id = (select id from veredas where municipio = 'Bucaramanga' and slug = 'perimetro-urbano'),
  direccion = 'CARRERA 66 # 20-18 BARRIO BUENAVISTA',
  latitud = null,
  longitud = null,
  descripcion_corta = 'Elaboración de bebidas fermentadas a base de frutas  de manera artesanal como es el vino de naranja.',
  descripcion = 'Elaboración de bebidas fermentadas a base de frutas  de manera artesanal como es el vino de naranja.',
  producto = 'VINO DE NARANJA',
  telefono = '3015055965',
  whatsapp = '573015055965',
  email = 'losabuelosreserva.info@gmail.com',
  representante_legal = 'STIVEN AMADO CASTILLO',
  nit = '1095766561-1',
  naturaleza_juridica = 'Natural',
  delegado = null,
  rut_camara_comercio = 'Cámara de comercio',
  responsable_cdmb = 'DIEGO GUTIERREZ',
  novedad = 'ACTIVO',
  tipo_negocio_verde = 'Dinamizadoras',
  anio_registro = 2023,
  cota_msnm = '895.8 msnm',
  este = '7311005148"',
  norte = '7°08597369',
  aplicacion_ficha_2025 = 'Actualizó',
  observaciones = 'Se realizo visita y se aplico ficha de verificacion',
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
  buenas_practicas_agricolas = null,
  buenas_practicas_apicolas = null,
  registro_apicola = null,
  intervencion_cauce = null,
  capacidad_carga = null,
  sstt = 'No',
  canal_venta = 'B2C',
  exportacion = 'No',
  huella_carbono = 'NO',
  fortalezas_ambiental = 'SI, No se utilizan materiales peligrosos y/o tóxicos en los procesos, proceso artesanal.
-Para el proceso de producción se   reutilizan las botellas de vidrio – Esterilizándolas.',
  fortalezas_social = 'Campañas de consumo consciente y en armonía con la naturaleza por medio de las redes sociales.
-Donaciones al asilo San Antonio',
  fortalezas_economico = 'Tiene claro algunos costos y gastos pero no la totalidad de operación del negocio.
-Excel – Registros financieros
- 3era Feria R de negocios verdes CDMB 2024',
  emprendimiento_verde = true,
  sello_marca = false,
  avalado = false,
  destacado = false,
  activo = true
where nombre = 'RESERVA LOS ABUELOS';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select '343c4117-3387-4cb6-be96-f70f0ac8fc88', 'RESERVA LOS ABUELOS', generar_slug_unico('RESERVA LOS ABUELOS', '343c4117-3387-4cb6-be96-f70f0ac8fc88'), (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'), 'Bucaramanga', (select id from veredas where municipio = 'Bucaramanga' and slug = 'perimetro-urbano'), 'CARRERA 66 # 20-18 BARRIO BUENAVISTA', null, null, 'Elaboración de bebidas fermentadas a base de frutas  de manera artesanal como es el vino de naranja.', 'Elaboración de bebidas fermentadas a base de frutas  de manera artesanal como es el vino de naranja.', 'VINO DE NARANJA', '3015055965', '573015055965', 'losabuelosreserva.info@gmail.com', 'STIVEN AMADO CASTILLO', '1095766561-1', 'Natural', null, 'Cámara de comercio', 'DIEGO GUTIERREZ', 'ACTIVO', 'Dinamizadoras', 2023, '895.8 msnm', '7311005148"', '7°08597369', 'Actualizó', 'Se realizo visita y se aplico ficha de verificacion', null, 'No', 'Acueducto', null, null, null, 'No', 'No', null, 'Sí', null, null, 'No', null, null, null, null, null, null, null, 'No', 'B2C', 'No', 'NO', 'SI, No se utilizan materiales peligrosos y/o tóxicos en los procesos, proceso artesanal.
-Para el proceso de producción se   reutilizan las botellas de vidrio – Esterilizándolas.', 'Campañas de consumo consciente y en armonía con la naturaleza por medio de las redes sociales.
-Donaciones al asilo San Antonio', 'Tiene claro algunos costos y gastos pero no la totalidad de operación del negocio.
-Excel – Registros financieros
- 3era Feria R de negocios verdes CDMB 2024', true, false, false, false, true
where not exists (select 1 from negocios where nombre = 'RESERVA LOS ABUELOS');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'RESERVA LOS ABUELOS');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'RESERVA LOS ABUELOS'), (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'RESERVA LOS ABUELOS');
insert into negocios_subcategorias (negocio_id, subcategoria_id) select (select id from negocios where nombre = 'RESERVA LOS ABUELOS'), id from subcategorias where slug = 'agroindustria-sostenible';
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'RESERVA LOS ABUELOS');
insert into negocios_actividades (negocio_id, actividad_productiva_id) select (select id from negocios where nombre = 'RESERVA LOS ABUELOS'), id from actividades_productivas where slug = 'agroindustrial-alimentario';
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'RESERVA LOS ABUELOS'), 2024, 53.6 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'RESERVA LOS ABUELOS'), 2025, 54.0 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;

-- AUVIMER S.A.S.
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'pendiente-clasificar'),
  municipio = 'Bucaramanga',
  vereda_id = null,
  direccion = 'Calle 17 # 28-34 San Alonso',
  latitud = 7.132222222222222,
  longitud = -73.11861111111111,
  descripcion_corta = null,
  descripcion = null,
  producto = 'EDUCACION AMBIENTAL',
  telefono = '6855100 - 3026699330',
  whatsapp = '6855100 - 3026699330',
  email = null,
  representante_legal = 'RAFAEL GALEANO BALLESTEROS',
  nit = '79468347',
  naturaleza_juridica = null,
  delegado = null,
  rut_camara_comercio = null,
  responsable_cdmb = 'ALEXANDER FLOREZ',
  novedad = 'RETIRADO',
  tipo_negocio_verde = null,
  anio_registro = 2023,
  cota_msnm = '1013 msnm',
  este = '73°07''07"',
  norte = '7°07''56"',
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
where nombre = 'AUVIMER S.A.S.';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select '25315318-1fbb-4fb2-8db0-5f6433d4829f', 'AUVIMER S.A.S.', generar_slug_unico('AUVIMER S.A.S.', '25315318-1fbb-4fb2-8db0-5f6433d4829f'), (select id from categorias_oficiales where slug = 'pendiente-clasificar'), 'Bucaramanga', null, 'Calle 17 # 28-34 San Alonso', 7.132222222222222, -73.11861111111111, null, null, 'EDUCACION AMBIENTAL', '6855100 - 3026699330', '6855100 - 3026699330', null, 'RAFAEL GALEANO BALLESTEROS', '79468347', null, null, null, 'ALEXANDER FLOREZ', 'RETIRADO', null, 2023, '1013 msnm', '73°07''07"', '7°07''56"', null, 'ingresa al programa', null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, true, false, false, false, false
where not exists (select 1 from negocios where nombre = 'AUVIMER S.A.S.');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'AUVIMER S.A.S.');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'AUVIMER S.A.S.'), (select id from categorias_oficiales where slug = 'pendiente-clasificar');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'AUVIMER S.A.S.');
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'AUVIMER S.A.S.');

-- BIONATURE COLOMBIA
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'),
  municipio = 'Girón',
  vereda_id = (select id from veredas where municipio = 'Girón' and slug = 'perimetro-urbano'),
  direccion = 'CALLE 15 C # 15-57 VILLAS DE DON JUAN ETAPA I',
  latitud = 7.060277777777777,
  longitud = -73.16194444444444,
  descripcion_corta = 'Elaboración de productos naturales , colageno a base de escamas de pescado',
  descripcion = 'Elaboración de productos naturales , colageno a base de escamas de pescado',
  producto = 'COLAGENO NATURAL DE COLPEZ',
  telefono = '3166167310',
  whatsapp = '573166167310',
  email = 'contactobionaturecolombia@gmail.com',
  representante_legal = 'CRISTIAN MEDINA REYES',
  nit = '79124738-7',
  naturaleza_juridica = 'Natural',
  delegado = null,
  rut_camara_comercio = 'Cámara de comercio',
  responsable_cdmb = 'SUJEY DÍAZ',
  novedad = 'ACTIVO',
  tipo_negocio_verde = null,
  anio_registro = 2023,
  cota_msnm = '703 msnm',
  este = '73°09''43"',
  norte = '7°03''37"',
  aplicacion_ficha_2025 = 'No actualizó',
  observaciones = 'No realizo visita ni se aplico ficha de verificacion',
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
  buenas_practicas_agricolas = null,
  buenas_practicas_apicolas = null,
  registro_apicola = null,
  intervencion_cauce = null,
  capacidad_carga = null,
  sstt = 'No',
  canal_venta = 'Mixta',
  exportacion = 'No',
  huella_carbono = 'NO',
  fortalezas_ambiental = 'Producción mas limpia sin aditivos químicos. Economía circular (escamas de pescado)',
  fortalezas_social = 'Fomenta hábitos saludables (educación nutricional)',
  fortalezas_economico = 'Reducción de costos de materia prima y genera valor agregado. Ventaja competitiva (natural) – mercado de salud y belleza.',
  emprendimiento_verde = true,
  sello_marca = false,
  avalado = false,
  destacado = false,
  activo = true
where nombre = 'BIONATURE COLOMBIA';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select 'c7b0bd15-ed36-406e-b4ed-e39eaf7e150c', 'BIONATURE COLOMBIA', generar_slug_unico('BIONATURE COLOMBIA', 'c7b0bd15-ed36-406e-b4ed-e39eaf7e150c'), (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'), 'Girón', (select id from veredas where municipio = 'Girón' and slug = 'perimetro-urbano'), 'CALLE 15 C # 15-57 VILLAS DE DON JUAN ETAPA I', 7.060277777777777, -73.16194444444444, 'Elaboración de productos naturales , colageno a base de escamas de pescado', 'Elaboración de productos naturales , colageno a base de escamas de pescado', 'COLAGENO NATURAL DE COLPEZ', '3166167310', '573166167310', 'contactobionaturecolombia@gmail.com', 'CRISTIAN MEDINA REYES', '79124738-7', 'Natural', null, 'Cámara de comercio', 'SUJEY DÍAZ', 'ACTIVO', null, 2023, '703 msnm', '73°09''43"', '7°03''37"', 'No actualizó', 'No realizo visita ni se aplico ficha de verificacion', null, 'No', 'Acueducto', null, null, null, 'No', 'No', null, 'Sí', null, null, 'No', null, null, null, null, null, null, null, 'No', 'Mixta', 'No', 'NO', 'Producción mas limpia sin aditivos químicos. Economía circular (escamas de pescado)', 'Fomenta hábitos saludables (educación nutricional)', 'Reducción de costos de materia prima y genera valor agregado. Ventaja competitiva (natural) – mercado de salud y belleza.', true, false, false, false, true
where not exists (select 1 from negocios where nombre = 'BIONATURE COLOMBIA');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'BIONATURE COLOMBIA');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'BIONATURE COLOMBIA'), (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'BIONATURE COLOMBIA');
insert into negocios_subcategorias (negocio_id, subcategoria_id) select (select id from negocios where nombre = 'BIONATURE COLOMBIA'), id from subcategorias where slug = 'agroindustria-sostenible';
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'BIONATURE COLOMBIA');
insert into negocios_actividades (negocio_id, actividad_productiva_id) select (select id from negocios where nombre = 'BIONATURE COLOMBIA'), id from actividades_productivas where slug = 'agroindustrial-alimentario';
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'BIONATURE COLOMBIA'), 2024, 68.1 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;

-- CAFÉ CON-SIENTE
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'),
  municipio = 'Matanza',
  vereda_id = (select id from veredas where municipio = 'Matanza' and slug = 'el-filo'),
  direccion = 'VDA EL FILO FCA SAN PEDRO VILLA NUEVA CORREG SANTA CRUZ DE LA COLINA MATANZA',
  latitud = 7.362777777777778,
  longitud = -73.09222222222222,
  descripcion_corta = 'Recoleccion y fabricacion de café  de origen , tostion realizada en bucaramanga tienen otros cultivos de banano y platano arton',
  descripcion = 'Recoleccion y fabricacion de café  de origen , tostion realizada en bucaramanga tienen otros cultivos de banano y platano arton',
  producto = 'CAFÉ',
  telefono = '3046705960 - 3144706712',
  whatsapp = '3046705960 - 3144706712',
  email = 'gladyssortiz1710@gmail.com',
  representante_legal = 'GLADYS ORTIZ GOMEZ',
  nit = '28336810-4',
  naturaleza_juridica = 'Natural',
  delegado = 'ADRIANA BUENO',
  rut_camara_comercio = 'Cámara de comercio',
  responsable_cdmb = 'SUJEY DÍAZ',
  novedad = 'ACTIVO',
  tipo_negocio_verde = 'Intermedio',
  anio_registro = 2023,
  cota_msnm = '1490 msnm',
  este = '73°05''32"',
  norte = '7°21''46"',
  aplicacion_ficha_2025 = 'Actualizó',
  observaciones = 'Se realizo visita y se actualizo ficha de verificacion',
  registro_nacional_turismo = null,
  uso_suelo = 'No',
  concesion_aguas = 'No',
  concesion_aguas_vencimiento = null,
  vertimientos = null,
  vertimientos_vencimiento = null,
  pueaa = 'No',
  pgris = 'No',
  pozo_septico = 'No',
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
  fortalezas_ambiental = 'Cuidado con los bosques nativos,dejan alimentación a varias especies animales  con los vecinos cuidan el nacimiento del agua , siembra de árboles, cuidan  de flora y fauna, se usan quimicos pero no toxicos.     Todos los residuos son reutlizados   para abonos del cafe y otras siembras de banano , hacen recoleccion de agua de lluvias.',
  fortalezas_social = 'Se contratan personas  campesinas de la zona  , empresa rural familiar , excelente relación con los vecinos .',
  fortalezas_economico = 'Venden el café lavado en pergamino a la federación obteniendo buenos ingresos cuando hay cosecha .',
  emprendimiento_verde = true,
  sello_marca = false,
  avalado = false,
  destacado = false,
  activo = true
where nombre = 'CAFÉ CON-SIENTE';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select 'acb0b774-f849-46b4-90fa-d4b53287dd58', 'CAFÉ CON-SIENTE', generar_slug_unico('CAFÉ CON-SIENTE', 'acb0b774-f849-46b4-90fa-d4b53287dd58'), (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'), 'Matanza', (select id from veredas where municipio = 'Matanza' and slug = 'el-filo'), 'VDA EL FILO FCA SAN PEDRO VILLA NUEVA CORREG SANTA CRUZ DE LA COLINA MATANZA', 7.362777777777778, -73.09222222222222, 'Recoleccion y fabricacion de café  de origen , tostion realizada en bucaramanga tienen otros cultivos de banano y platano arton', 'Recoleccion y fabricacion de café  de origen , tostion realizada en bucaramanga tienen otros cultivos de banano y platano arton', 'CAFÉ', '3046705960 - 3144706712', '3046705960 - 3144706712', 'gladyssortiz1710@gmail.com', 'GLADYS ORTIZ GOMEZ', '28336810-4', 'Natural', 'ADRIANA BUENO', 'Cámara de comercio', 'SUJEY DÍAZ', 'ACTIVO', 'Intermedio', 2023, '1490 msnm', '73°05''32"', '7°21''46"', 'Actualizó', 'Se realizo visita y se actualizo ficha de verificacion', null, 'No', 'No', null, null, null, 'No', 'No', 'No', null, null, null, 'Sí', '2028-12-03', null, 'No', null, null, null, null, 'No', 'Mixta', 'No', 'NO', 'Cuidado con los bosques nativos,dejan alimentación a varias especies animales  con los vecinos cuidan el nacimiento del agua , siembra de árboles, cuidan  de flora y fauna, se usan quimicos pero no toxicos.     Todos los residuos son reutlizados   para abonos del cafe y otras siembras de banano , hacen recoleccion de agua de lluvias.', 'Se contratan personas  campesinas de la zona  , empresa rural familiar , excelente relación con los vecinos .', 'Venden el café lavado en pergamino a la federación obteniendo buenos ingresos cuando hay cosecha .', true, false, false, false, true
where not exists (select 1 from negocios where nombre = 'CAFÉ CON-SIENTE');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'CAFÉ CON-SIENTE');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'CAFÉ CON-SIENTE'), (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'CAFÉ CON-SIENTE');
insert into negocios_subcategorias (negocio_id, subcategoria_id) select (select id from negocios where nombre = 'CAFÉ CON-SIENTE'), id from subcategorias where slug = 'agroindustria-sostenible';
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'CAFÉ CON-SIENTE');
insert into negocios_actividades (negocio_id, actividad_productiva_id) select (select id from negocios where nombre = 'CAFÉ CON-SIENTE'), id from actividades_productivas where slug = 'agroindustrial-alimentario';
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'CAFÉ CON-SIENTE'), 2024, 50.1 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'CAFÉ CON-SIENTE'), 2025, 46.2 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;

-- CHOCOLATE PIEDECUESTANO JS
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'),
  municipio = 'Piedecuesta',
  vereda_id = (select id from veredas where municipio = 'Piedecuesta' and slug = 'perimetro-urbano'),
  direccion = 'CALLE 10A # 2-42 BARRIO LA FERIA',
  latitud = 6.983333333333333,
  longitud = -73.05361111111111,
  descripcion_corta = null,
  descripcion = null,
  producto = 'CHOCOLATE',
  telefono = '3228325474',
  whatsapp = '573228325474',
  email = 'jonathansuarez_95@hotmail.com',
  representante_legal = 'JONATHAN FERNEY SUAREZ MANRIQUE',
  nit = '1102377899',
  naturaleza_juridica = 'Natural',
  delegado = null,
  rut_camara_comercio = 'Sin verificar',
  responsable_cdmb = 'SUJEY DÍAZ',
  novedad = 'SUSPENDIDO',
  tipo_negocio_verde = 'Inicial',
  anio_registro = 2023,
  cota_msnm = '988 msnm',
  este = '73°03''13"',
  norte = '6°59''00"',
  aplicacion_ficha_2025 = 'No actualizó',
  observaciones = 'No se realizo visita ni actualizo ficha de verificacion',
  registro_nacional_turismo = null,
  uso_suelo = 'No',
  concesion_aguas = 'No',
  concesion_aguas_vencimiento = null,
  vertimientos = 'No',
  vertimientos_vencimiento = null,
  pueaa = 'No',
  pgris = 'No',
  pozo_septico = 'No',
  alcantarillado = 'No',
  ica = 'No',
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
  fortalezas_ambiental = 'Adelantan procesos de educación ambiental   cuando desarrollan capacitaciones para la recolección del cacao',
  fortalezas_social = 'Socializan con la comunidad el uso del no plástico.',
  fortalezas_economico = 'Estan en proceso de apertura de su local',
  emprendimiento_verde = true,
  sello_marca = false,
  avalado = false,
  destacado = false,
  activo = false
where nombre = 'CHOCOLATE PIEDECUESTANO JS';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select 'b46a45d2-f993-43fa-b439-3f0e6d14fa91', 'CHOCOLATE PIEDECUESTANO JS', generar_slug_unico('CHOCOLATE PIEDECUESTANO JS', 'b46a45d2-f993-43fa-b439-3f0e6d14fa91'), (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'), 'Piedecuesta', (select id from veredas where municipio = 'Piedecuesta' and slug = 'perimetro-urbano'), 'CALLE 10A # 2-42 BARRIO LA FERIA', 6.983333333333333, -73.05361111111111, null, null, 'CHOCOLATE', '3228325474', '573228325474', 'jonathansuarez_95@hotmail.com', 'JONATHAN FERNEY SUAREZ MANRIQUE', '1102377899', 'Natural', null, 'Sin verificar', 'SUJEY DÍAZ', 'SUSPENDIDO', 'Inicial', 2023, '988 msnm', '73°03''13"', '6°59''00"', 'No actualizó', 'No se realizo visita ni actualizo ficha de verificacion', null, 'No', 'No', null, 'No', null, 'No', 'No', 'No', 'No', 'No', null, 'No', null, null, 'No', null, null, null, null, 'No', 'B2C', null, null, 'Adelantan procesos de educación ambiental   cuando desarrollan capacitaciones para la recolección del cacao', 'Socializan con la comunidad el uso del no plástico.', 'Estan en proceso de apertura de su local', true, false, false, false, false
where not exists (select 1 from negocios where nombre = 'CHOCOLATE PIEDECUESTANO JS');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'CHOCOLATE PIEDECUESTANO JS');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'CHOCOLATE PIEDECUESTANO JS'), (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'CHOCOLATE PIEDECUESTANO JS');
insert into negocios_subcategorias (negocio_id, subcategoria_id) select (select id from negocios where nombre = 'CHOCOLATE PIEDECUESTANO JS'), id from subcategorias where slug = 'agroindustria-sostenible';
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'CHOCOLATE PIEDECUESTANO JS');
insert into negocios_actividades (negocio_id, actividad_productiva_id) select (select id from negocios where nombre = 'CHOCOLATE PIEDECUESTANO JS'), id from actividades_productivas where slug = 'agroindustrial-alimentario';

-- HARINAGRO S.A.S.
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'ecoproductos-industriales'),
  municipio = 'Bucaramanga',
  vereda_id = (select id from veredas where municipio = 'Bucaramanga' and slug = 'perimetro-urbano'),
  direccion = 'KM 6,5 VIA PALENQUE CAFÉ MADRID',
  latitud = 7.1375,
  longitud = -73.15166666666667,
  descripcion_corta = 'Producción y comercialización de harinas, grasas y aceites de origen animal, que hace parte de la economia circular a partir de residuos de la industria de…',
  descripcion = 'Producción y comercialización de harinas, grasas y aceites de origen animal, que hace parte de la economia circular a partir de residuos de la industria de beneficio avicola y bovino.',
  producto = 'HARINAS',
  telefono = '3005457990',
  whatsapp = '573005457990',
  email = 'edwinmurcia@harinagro.com',
  representante_legal = 'JAIME HERNANDEZ FERNANDEZ',
  nit = '804016124-1',
  naturaleza_juridica = 'Jurídica',
  delegado = 'EDWIN YESID MURCIA DIAZ',
  rut_camara_comercio = 'Cámara de comercio',
  responsable_cdmb = 'SILVIA VALDIVIESO',
  novedad = 'ACTIVO',
  tipo_negocio_verde = 'Satisfactorio',
  anio_registro = 2023,
  cota_msnm = '657 msnm',
  este = '73°09''06"',
  norte = '7°08''15"',
  aplicacion_ficha_2025 = 'No actualizó',
  observaciones = 'No se realizo visita ni se actualizo ficha de verificacion',
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
  canal_venta = 'B2B',
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
where nombre = 'HARINAGRO S.A.S.';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select 'aae2626d-9be6-4980-9c4d-6901b1bbf75f', 'HARINAGRO S.A.S.', generar_slug_unico('HARINAGRO S.A.S.', 'aae2626d-9be6-4980-9c4d-6901b1bbf75f'), (select id from categorias_oficiales where slug = 'ecoproductos-industriales'), 'Bucaramanga', (select id from veredas where municipio = 'Bucaramanga' and slug = 'perimetro-urbano'), 'KM 6,5 VIA PALENQUE CAFÉ MADRID', 7.1375, -73.15166666666667, 'Producción y comercialización de harinas, grasas y aceites de origen animal, que hace parte de la economia circular a partir de residuos de la industria de…', 'Producción y comercialización de harinas, grasas y aceites de origen animal, que hace parte de la economia circular a partir de residuos de la industria de beneficio avicola y bovino.', 'HARINAS', '3005457990', '573005457990', 'edwinmurcia@harinagro.com', 'JAIME HERNANDEZ FERNANDEZ', '804016124-1', 'Jurídica', 'EDWIN YESID MURCIA DIAZ', 'Cámara de comercio', 'SILVIA VALDIVIESO', 'ACTIVO', 'Satisfactorio', 2023, '657 msnm', '73°09''06"', '7°08''15"', 'No actualizó', 'No se realizo visita ni se actualizo ficha de verificacion', null, 'Sí', 'Acueducto', null, null, null, 'No', 'Sí', null, 'Sí', 'Sí', null, null, null, null, null, null, null, null, null, 'Sí', 'B2B', 'No', 'NO', null, null, null, true, false, false, false, true
where not exists (select 1 from negocios where nombre = 'HARINAGRO S.A.S.');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'HARINAGRO S.A.S.');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'HARINAGRO S.A.S.'), (select id from categorias_oficiales where slug = 'ecoproductos-industriales');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'HARINAGRO S.A.S.');
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'HARINAGRO S.A.S.');
insert into negocios_actividades (negocio_id, actividad_productiva_id) select (select id from negocios where nombre = 'HARINAGRO S.A.S.'), id from actividades_productivas where slug = 'aprovechamiento-residuos-organicos';
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'HARINAGRO S.A.S.'), 2023, 64.5 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;

-- ORIGEN FIT S.A.S
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'),
  municipio = 'Bucaramanga',
  vereda_id = (select id from veredas where municipio = 'Bucaramanga' and slug = 'perimetro-urbano'),
  direccion = 'CARRERA 20 NO 18-23',
  latitud = 7.129722222222222,
  longitud = -73.12527777777777,
  descripcion_corta = 'Es una empresa que vende fiulamentos , hace capacitaciones y talleres a niños y jovenes en economica circular, hace impresiones en 3d con plasticos…',
  descripcion = 'Es una empresa que vende fiulamentos , hace capacitaciones y talleres a niños y jovenes en economica circular, hace impresiones en 3d con plasticos recuperados',
  producto = 'TE DE KOMBUCHA',
  telefono = '3118865187',
  whatsapp = '573118865187',
  email = 'origenfitj@gmail.com',
  representante_legal = 'JULIAN DAVID PINILLA BONILLA',
  nit = '901559356-5',
  naturaleza_juridica = 'Jurídica',
  delegado = null,
  rut_camara_comercio = 'Cámara de comercio',
  responsable_cdmb = 'CARINE GARCIA',
  novedad = 'ACTIVO',
  tipo_negocio_verde = 'Dinamizadoras',
  anio_registro = 2023,
  cota_msnm = '969 msnm',
  este = '73°07''31"',
  norte = '7°07''47"',
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
  invima = 'Sí',
  invima_vencimiento = '2033-06-16',
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
  fortalezas_ambiental = 'El producto principal (té kombucha) es natural, orgánico y saludable, alineado con prácticas de consumo sostenible.
 • Cuenta con aval de Negocio Verde, lo que certifica su compromiso ambiental.
 • Uso de ingredientes naturales y procesos de fermentación amigables con el medio ambiente.
 • Contribuye a la reducción del uso de bebidas ultraprocesadas y promueve hábitos saludables.
El producto principal (té kombucha) es natural, orgánico y saludable, alineado con prácticas de consumo sostenible.
 • Cuenta con aval de Negocio Verde, lo que certifica su compromiso ambiental.
 • Uso de ingredientes naturales y procesos de fermentación amigables con el medio ambiente.
 • Contribuye a la reducción del uso de bebidas ultraprocesadas y promueve hábitos saludables.',
  fortalezas_social = '• Emprendimiento liderado por un joven con visión ambiental, que promueve estilos de vida saludables.
 • Genera conciencia sobre el bienestar y la alimentación consciente en su comunidad.
 • Puede servir como referente para otros jóvenes emprendedores sostenibles.
 • La producción artesanal genera empleo local y rescata prácticas tradicionales.',
  fortalezas_economico = '• Producto con registro INVIMA, lo que permite comercialización formal y confianza del consumidor.
 • Aval de Negocio Verde que aumenta la credibilidad y acceso a ferias o convocatorias.
 • Producto con alta demanda en mercados saludables y sostenibles.
 • Posibilidad de diversificar productos a futuro (otros fermentados, sabores, etc.).',
  emprendimiento_verde = false,
  sello_marca = false,
  avalado = true,
  destacado = false,
  activo = true
where nombre = 'ORIGEN FIT S.A.S';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select '449c5336-cd2e-4ed4-8c96-1259710200a8', 'ORIGEN FIT S.A.S', generar_slug_unico('ORIGEN FIT S.A.S', '449c5336-cd2e-4ed4-8c96-1259710200a8'), (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'), 'Bucaramanga', (select id from veredas where municipio = 'Bucaramanga' and slug = 'perimetro-urbano'), 'CARRERA 20 NO 18-23', 7.129722222222222, -73.12527777777777, 'Es una empresa que vende fiulamentos , hace capacitaciones y talleres a niños y jovenes en economica circular, hace impresiones en 3d con plasticos…', 'Es una empresa que vende fiulamentos , hace capacitaciones y talleres a niños y jovenes en economica circular, hace impresiones en 3d con plasticos recuperados', 'TE DE KOMBUCHA', '3118865187', '573118865187', 'origenfitj@gmail.com', 'JULIAN DAVID PINILLA BONILLA', '901559356-5', 'Jurídica', null, 'Cámara de comercio', 'CARINE GARCIA', 'ACTIVO', 'Dinamizadoras', 2023, '969 msnm', '73°07''31"', '7°07''47"', 'Actualizó', null, null, 'Sí', 'Acueducto', null, null, null, 'No', 'No', null, 'Sí', null, null, 'Sí', '2033-06-16', null, 'No', null, null, null, null, 'No', 'Mixta', 'No', 'NO', 'El producto principal (té kombucha) es natural, orgánico y saludable, alineado con prácticas de consumo sostenible.
 • Cuenta con aval de Negocio Verde, lo que certifica su compromiso ambiental.
 • Uso de ingredientes naturales y procesos de fermentación amigables con el medio ambiente.
 • Contribuye a la reducción del uso de bebidas ultraprocesadas y promueve hábitos saludables.
El producto principal (té kombucha) es natural, orgánico y saludable, alineado con prácticas de consumo sostenible.
 • Cuenta con aval de Negocio Verde, lo que certifica su compromiso ambiental.
 • Uso de ingredientes naturales y procesos de fermentación amigables con el medio ambiente.
 • Contribuye a la reducción del uso de bebidas ultraprocesadas y promueve hábitos saludables.', '• Emprendimiento liderado por un joven con visión ambiental, que promueve estilos de vida saludables.
 • Genera conciencia sobre el bienestar y la alimentación consciente en su comunidad.
 • Puede servir como referente para otros jóvenes emprendedores sostenibles.
 • La producción artesanal genera empleo local y rescata prácticas tradicionales.', '• Producto con registro INVIMA, lo que permite comercialización formal y confianza del consumidor.
 • Aval de Negocio Verde que aumenta la credibilidad y acceso a ferias o convocatorias.
 • Producto con alta demanda en mercados saludables y sostenibles.
 • Posibilidad de diversificar productos a futuro (otros fermentados, sabores, etc.).', false, false, true, false, true
where not exists (select 1 from negocios where nombre = 'ORIGEN FIT S.A.S');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'ORIGEN FIT S.A.S');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'ORIGEN FIT S.A.S'), (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'ORIGEN FIT S.A.S');
insert into negocios_subcategorias (negocio_id, subcategoria_id) select (select id from negocios where nombre = 'ORIGEN FIT S.A.S'), id from subcategorias where slug = 'agroindustria-sostenible';
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'ORIGEN FIT S.A.S');
insert into negocios_actividades (negocio_id, actividad_productiva_id) select (select id from negocios where nombre = 'ORIGEN FIT S.A.S'), id from actividades_productivas where slug = 'agroindustrial-alimentario';
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'ORIGEN FIT S.A.S'), 2024, 72.9 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'ORIGEN FIT S.A.S'), 2025, 63.8 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;

-- AGROTERRACOL
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'ecoproductos-industriales'),
  municipio = 'Girón',
  vereda_id = (select id from veredas where municipio = 'Girón' and slug = 'palmitas'),
  direccion = 'VEREDA PALMITAS FINCA EL PALMAR KM2 VIA AEROPUERTO',
  latitud = 7.0808333333333335,
  longitud = -73.18388888888889,
  descripcion_corta = 'Produce y comercializa insumos agroecológicos, enfocada en el desarrollo sostenible e innovación agrícola, ofrecemos soluciones integrales tecnológicas,…',
  descripcion = 'Produce y comercializa insumos agroecológicos, enfocada en el desarrollo sostenible e innovación agrícola, ofrecemos soluciones integrales tecnológicas, como drones para monitoreo de cultivos y maquinaria agrícola eficiente. Además, brindamos asesoría administrativa y de campo, apoyando a nuestros clientes con análisis sólidos y estrategias claras para optimizar su producción y cuidar el medio ambiente.',
  producto = 'ABONO ORGANICO MINERAL BULTO DE 45 KG',
  telefono = '3126646239',
  whatsapp = '573126646239',
  email = 'buitrago456@gmail.com',
  representante_legal = 'CAMILO ANDRES BUITRAGO SIERRA',
  nit = '1101596834',
  naturaleza_juridica = 'Natural',
  delegado = null,
  rut_camara_comercio = 'RUT',
  responsable_cdmb = 'SILVIA VALDIVIESO',
  novedad = 'ACTIVO',
  tipo_negocio_verde = 'Dinamizadoras',
  anio_registro = 2023,
  cota_msnm = '838 msnm',
  este = '73°11''02"',
  norte = '7°04''51"',
  aplicacion_ficha_2025 = 'No actualizó',
  observaciones = 'No se realizo visita ni actualizo ficha de verificacion',
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
  canal_venta = 'Mixta',
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
where nombre = 'AGROTERRACOL';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select '8eb78ea9-87b8-49db-ad3c-89ef9a0f14e0', 'AGROTERRACOL', generar_slug_unico('AGROTERRACOL', '8eb78ea9-87b8-49db-ad3c-89ef9a0f14e0'), (select id from categorias_oficiales where slug = 'ecoproductos-industriales'), 'Girón', (select id from veredas where municipio = 'Girón' and slug = 'palmitas'), 'VEREDA PALMITAS FINCA EL PALMAR KM2 VIA AEROPUERTO', 7.0808333333333335, -73.18388888888889, 'Produce y comercializa insumos agroecológicos, enfocada en el desarrollo sostenible e innovación agrícola, ofrecemos soluciones integrales tecnológicas,…', 'Produce y comercializa insumos agroecológicos, enfocada en el desarrollo sostenible e innovación agrícola, ofrecemos soluciones integrales tecnológicas, como drones para monitoreo de cultivos y maquinaria agrícola eficiente. Además, brindamos asesoría administrativa y de campo, apoyando a nuestros clientes con análisis sólidos y estrategias claras para optimizar su producción y cuidar el medio ambiente.', 'ABONO ORGANICO MINERAL BULTO DE 45 KG', '3126646239', '573126646239', 'buitrago456@gmail.com', 'CAMILO ANDRES BUITRAGO SIERRA', '1101596834', 'Natural', null, 'RUT', 'SILVIA VALDIVIESO', 'ACTIVO', 'Dinamizadoras', 2023, '838 msnm', '73°11''02"', '7°04''51"', 'No actualizó', 'No se realizo visita ni actualizo ficha de verificacion', null, 'No', 'Acueducto veredal', null, null, null, 'No', 'Sí', null, 'Sí', 'No', null, null, null, null, 'No', null, null, null, null, 'No', 'Mixta', 'No', 'NO', null, null, null, true, false, false, false, true
where not exists (select 1 from negocios where nombre = 'AGROTERRACOL');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'AGROTERRACOL');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'AGROTERRACOL'), (select id from categorias_oficiales where slug = 'ecoproductos-industriales');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'AGROTERRACOL');
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'AGROTERRACOL');
insert into negocios_actividades (negocio_id, actividad_productiva_id) select (select id from negocios where nombre = 'AGROTERRACOL'), id from actividades_productivas where slug = 'aprovechamiento-residuos-organicos';
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'AGROTERRACOL'), 2024, 53.4 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;

-- ABONO ORGANICO BOYACA S.A.S.
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'ecoproductos-industriales'),
  municipio = 'Girón',
  vereda_id = null,
  direccion = 'LT MOLANO - FRENTE URBANIZACION ALCALA',
  latitud = null,
  longitud = -73.17453444444445,
  descripcion_corta = 'producciòn, venta, distribuciòn, fabricaciòn, almacenamiento, importaciòn, exportaciòn de abono orgànico, cal agrìcola, e insumos agrìcolas, y…',
  descripcion = 'producciòn, venta, distribuciòn, fabricaciòn, almacenamiento, importaciòn, exportaciòn de abono orgànico, cal agrìcola, e insumos agrìcolas, y transformaciòn de materias orgànicas, fabricaciòn de compuestos inorgànicos nitrogenados.',
  producto = 'ABONO ORGANICO',
  telefono = '3183914106',
  whatsapp = '573183914106',
  email = 'camilo.fino@abob.co',
  representante_legal = 'CAMILO ARBEY FINO HERNANDEZ',
  nit = '820003541-1',
  naturaleza_juridica = null,
  delegado = null,
  rut_camara_comercio = null,
  responsable_cdmb = 'SILVIA GARCIA',
  novedad = 'SUSPENDIDO',
  tipo_negocio_verde = 'Dinamizadoras',
  anio_registro = 2023,
  cota_msnm = '734.2 msnm',
  este = '73°10''28.324"',
  norte = '7°4''8485"',
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
where nombre = 'ABONO ORGANICO BOYACA S.A.S.';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select 'c4eb0774-2587-429a-8df4-53b95d84ffa9', 'ABONO ORGANICO BOYACA S.A.S.', generar_slug_unico('ABONO ORGANICO BOYACA S.A.S.', 'c4eb0774-2587-429a-8df4-53b95d84ffa9'), (select id from categorias_oficiales where slug = 'ecoproductos-industriales'), 'Girón', null, 'LT MOLANO - FRENTE URBANIZACION ALCALA', null, -73.17453444444445, 'producciòn, venta, distribuciòn, fabricaciòn, almacenamiento, importaciòn, exportaciòn de abono orgànico, cal agrìcola, e insumos agrìcolas, y…', 'producciòn, venta, distribuciòn, fabricaciòn, almacenamiento, importaciòn, exportaciòn de abono orgànico, cal agrìcola, e insumos agrìcolas, y transformaciòn de materias orgànicas, fabricaciòn de compuestos inorgànicos nitrogenados.', 'ABONO ORGANICO', '3183914106', '573183914106', 'camilo.fino@abob.co', 'CAMILO ARBEY FINO HERNANDEZ', '820003541-1', null, null, null, 'SILVIA GARCIA', 'SUSPENDIDO', 'Dinamizadoras', 2023, '734.2 msnm', '73°10''28.324"', '7°4''8485"', 'Actualizó', 'Se realizo visita y se aplico ficha de verificacion', null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, true, false, false, false, false
where not exists (select 1 from negocios where nombre = 'ABONO ORGANICO BOYACA S.A.S.');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'ABONO ORGANICO BOYACA S.A.S.');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'ABONO ORGANICO BOYACA S.A.S.'), (select id from categorias_oficiales where slug = 'ecoproductos-industriales');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'ABONO ORGANICO BOYACA S.A.S.');
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'ABONO ORGANICO BOYACA S.A.S.');
insert into negocios_actividades (negocio_id, actividad_productiva_id) select (select id from negocios where nombre = 'ABONO ORGANICO BOYACA S.A.S.'), id from actividades_productivas where slug = 'aprovechamiento-residuos-organicos';
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'ABONO ORGANICO BOYACA S.A.S.'), 2023, 63.07 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'ABONO ORGANICO BOYACA S.A.S.'), 2024, 54.1 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;

-- COOTRASUR
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'pendiente-clasificar'),
  municipio = 'Floridablanca',
  vereda_id = null,
  direccion = 'CALLE 220 # 21-73 ANILLO VIAL',
  latitud = 7.016139,
  longitud = -73.10904,
  descripcion_corta = null,
  descripcion = null,
  producto = 'TRANSPORTE DE CARGA',
  telefono = '3183546085',
  whatsapp = '573183546085',
  email = null,
  representante_legal = 'YESSICA SÁNCHEZ',
  nit = '890200219-3',
  naturaleza_juridica = null,
  delegado = null,
  rut_camara_comercio = null,
  responsable_cdmb = null,
  novedad = 'RETIRADO',
  tipo_negocio_verde = 'No aplica',
  anio_registro = 2023,
  cota_msnm = '832,8 msnm',
  este = '73.10904',
  norte = '7.016139',
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
where nombre = 'COOTRASUR';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select '1e81b0b2-53b0-4a87-9b0b-d6d23d60418f', 'COOTRASUR', generar_slug_unico('COOTRASUR', '1e81b0b2-53b0-4a87-9b0b-d6d23d60418f'), (select id from categorias_oficiales where slug = 'pendiente-clasificar'), 'Floridablanca', null, 'CALLE 220 # 21-73 ANILLO VIAL', 7.016139, -73.10904, null, null, 'TRANSPORTE DE CARGA', '3183546085', '573183546085', null, 'YESSICA SÁNCHEZ', '890200219-3', null, null, null, null, 'RETIRADO', 'No aplica', 2023, '832,8 msnm', '73.10904', '7.016139', null, 'No cumplimiento de requisitos', null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, true, false, false, false, false
where not exists (select 1 from negocios where nombre = 'COOTRASUR');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'COOTRASUR');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'COOTRASUR'), (select id from categorias_oficiales where slug = 'pendiente-clasificar');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'COOTRASUR');
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'COOTRASUR');

-- BIO-ORGÁNICOS DEL NORTE SAS
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'ecoproductos-industriales'),
  municipio = 'Piedecuesta',
  vereda_id = (select id from veredas where municipio = 'Piedecuesta' and slug = 'san-francisco'),
  direccion = 'KM 7 VÍA CUROS (planta de producción)',
  latitud = 6.945277777777778,
  longitud = -73.02527777777777,
  descripcion_corta = 'Actividades de producción, distribución y comercialización de abonos bio-orgánicos y compuestos inorganicos nitrogenados.',
  descripcion = 'Actividades de producción, distribución y comercialización de abonos bio-orgánicos y compuestos inorganicos nitrogenados.',
  producto = 'ABONOS BIO-ORGÁNICOS, COMPUESTOS INORGÁNICOS NITROGENADOS Y FERTILIZANTE EFIBIOL',
  telefono = '3183354032',
  whatsapp = '573183354032',
  email = 'bioorganicosas@gmail.com',
  representante_legal = 'MARIA ESPERANZA SARMIENTO VILLAMIZAR',
  nit = '901292213-2',
  naturaleza_juridica = 'Jurídica',
  delegado = null,
  rut_camara_comercio = 'Cámara de comercio',
  responsable_cdmb = 'SILVIA VALDIVIESO',
  novedad = 'ACTIVO',
  tipo_negocio_verde = 'Dinamizadoras',
  anio_registro = 2023,
  cota_msnm = '1047 msnm',
  este = '73°01''31"',
  norte = '6°56''43"',
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
  fortalezas_ambiental = 'El uso de fertilizantes orgánicos disminuye las emisiones de GEI, disminuye los lixiviados de los fertilizantes sintéticos, contribuye a la conservación de especies nativas, favorece la descontaminación de las fuentes hídricas.
-La agricultura orgánica que impulsa la empresa protege los servicios ecosistemicos de polinización, control biológico, mantenimiento de la fertilidad del suelo.
-Reutilización; se ofrece a los agricultores un descuento por devolver el empaque.
- No se utilizan materiales peligrosos y/o tóxicos en los procesos
- Se utiliza el rumen de las reses recuperado del frigorífico vijagual, el materia chipeado  o flotante reciclado del rio.',
  fortalezas_social = 'si, Campojardín: Negocio Verde CDMB, acciones de compra venta de caprinaza, tierra negra.
Always Green Vivero: Negocio Verde CSB, venta de abono orgánico.
-Sostiene relaciones comerciales con clientes mujeres de la Guajira y Santa Rosa del Sur de Bolivar, región afectada por por el conflicto armado interno.
-Se han realizado campañas especiales con Asomucri (Asoc cultivadores de mora)  y Asocacao (Asoc cultivadores de cacao)',
  fortalezas_economico = 'Tiene claro algunos costos y gastos pero no la totalidad de operación del negocio
-Sistema contable SIIGO',
  emprendimiento_verde = true,
  sello_marca = false,
  avalado = false,
  destacado = false,
  activo = true
where nombre = 'BIO-ORGÁNICOS DEL NORTE SAS';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select '2c9da24c-53f7-4a82-aa58-7226dfb40ed8', 'BIO-ORGÁNICOS DEL NORTE SAS', generar_slug_unico('BIO-ORGÁNICOS DEL NORTE SAS', '2c9da24c-53f7-4a82-aa58-7226dfb40ed8'), (select id from categorias_oficiales where slug = 'ecoproductos-industriales'), 'Piedecuesta', (select id from veredas where municipio = 'Piedecuesta' and slug = 'san-francisco'), 'KM 7 VÍA CUROS (planta de producción)', 6.945277777777778, -73.02527777777777, 'Actividades de producción, distribución y comercialización de abonos bio-orgánicos y compuestos inorganicos nitrogenados.', 'Actividades de producción, distribución y comercialización de abonos bio-orgánicos y compuestos inorganicos nitrogenados.', 'ABONOS BIO-ORGÁNICOS, COMPUESTOS INORGÁNICOS NITROGENADOS Y FERTILIZANTE EFIBIOL', '3183354032', '573183354032', 'bioorganicosas@gmail.com', 'MARIA ESPERANZA SARMIENTO VILLAMIZAR', '901292213-2', 'Jurídica', null, 'Cámara de comercio', 'SILVIA VALDIVIESO', 'ACTIVO', 'Dinamizadoras', 2023, '1047 msnm', '73°01''31"', '6°56''43"', 'Actualizó', 'Se realizo visita y se aplico ficha de verificacion', null, 'Sí', 'Acueducto veredal', null, null, null, 'No', 'No', 'Sí', 'Sí', 'Sí', null, null, null, null, null, null, null, null, null, 'Sí', 'Mixta', 'No', 'NO', 'El uso de fertilizantes orgánicos disminuye las emisiones de GEI, disminuye los lixiviados de los fertilizantes sintéticos, contribuye a la conservación de especies nativas, favorece la descontaminación de las fuentes hídricas.
-La agricultura orgánica que impulsa la empresa protege los servicios ecosistemicos de polinización, control biológico, mantenimiento de la fertilidad del suelo.
-Reutilización; se ofrece a los agricultores un descuento por devolver el empaque.
- No se utilizan materiales peligrosos y/o tóxicos en los procesos
- Se utiliza el rumen de las reses recuperado del frigorífico vijagual, el materia chipeado  o flotante reciclado del rio.', 'si, Campojardín: Negocio Verde CDMB, acciones de compra venta de caprinaza, tierra negra.
Always Green Vivero: Negocio Verde CSB, venta de abono orgánico.
-Sostiene relaciones comerciales con clientes mujeres de la Guajira y Santa Rosa del Sur de Bolivar, región afectada por por el conflicto armado interno.
-Se han realizado campañas especiales con Asomucri (Asoc cultivadores de mora)  y Asocacao (Asoc cultivadores de cacao)', 'Tiene claro algunos costos y gastos pero no la totalidad de operación del negocio
-Sistema contable SIIGO', true, false, false, false, true
where not exists (select 1 from negocios where nombre = 'BIO-ORGÁNICOS DEL NORTE SAS');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'BIO-ORGÁNICOS DEL NORTE SAS');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'BIO-ORGÁNICOS DEL NORTE SAS'), (select id from categorias_oficiales where slug = 'ecoproductos-industriales');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'BIO-ORGÁNICOS DEL NORTE SAS');
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'BIO-ORGÁNICOS DEL NORTE SAS');
insert into negocios_actividades (negocio_id, actividad_productiva_id) select (select id from negocios where nombre = 'BIO-ORGÁNICOS DEL NORTE SAS'), id from actividades_productivas where slug = 'aprovechamiento-residuos-organicos';
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'BIO-ORGÁNICOS DEL NORTE SAS'), 2024, 54.8 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'BIO-ORGÁNICOS DEL NORTE SAS'), 2025, 64.7 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;

-- NOVA SCIENCIE S.A.S.
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'),
  municipio = 'Piedecuesta',
  vereda_id = (select id from veredas where municipio = 'Piedecuesta' and slug = 'casiano'),
  direccion = 'VEREDA CASIANO CONDOMINIO CAMPESTRE MONTEARROYO CASA 6',
  latitud = 7.070514166666666,
  longitud = -73.10541138888888,
  descripcion_corta = 'Cuentan con toda la cadena de valor desde la Genética , el cultivo y la transformación del Cannabis Medicinal.',
  descripcion = 'Cuentan con toda la cadena de valor desde la Genética , el cultivo y la transformación del Cannabis Medicinal.',
  producto = 'DERIVADOS DE CANNABIS',
  telefono = '3208313865',
  whatsapp = '573208313865',
  email = 'novascience.co@gmail.com',
  representante_legal = 'DIANA ROCIO SANTANDER URIBE',
  nit = '901398741-6',
  naturaleza_juridica = 'Jurídica',
  delegado = null,
  rut_camara_comercio = 'Cámara de comercio',
  responsable_cdmb = 'LILIANA CACERES',
  novedad = 'ACTIVO',
  tipo_negocio_verde = 'Dinamizadoras',
  anio_registro = 2023,
  cota_msnm = '823 msnm',
  este = '73°6''19,481"',
  norte = '7°4''13,851"',
  aplicacion_ficha_2025 = 'Actualizó',
  observaciones = 'Se realizo visita y se aplico ficha de verificacion',
  registro_nacional_turismo = null,
  uso_suelo = 'No',
  concesion_aguas = 'Acueducto veredal',
  concesion_aguas_vencimiento = null,
  vertimientos = null,
  vertimientos_vencimiento = null,
  pueaa = 'No',
  pgris = 'No',
  pozo_septico = 'No',
  alcantarillado = null,
  ica = null,
  ica_vencimiento = null,
  invima = 'Sí',
  invima_vencimiento = '2028-06-29',
  certificado_tenencia_animales = null,
  buenas_practicas_agricolas = 'No',
  buenas_practicas_apicolas = null,
  registro_apicola = null,
  intervencion_cauce = null,
  capacidad_carga = null,
  sstt = 'Sí',
  canal_venta = 'Mixta',
  exportacion = 'Sí',
  huella_carbono = 'NO',
  fortalezas_ambiental = 'APROVECHAMIENTO DE LOS BENEFICIOS Y BONDADES DE LOS INGREDIENTES NATURALES PARA EL CUIDADO DE LA PIEL TALES COMO LA APITERAPIA , EXTRACTOS Y GRASAS PROPIOS DE LA AMAZONIA COLOMBIANA Y EL CONOCIMIENTO CIENTIFICO DEL CANABBIS MEDICINAL.',
  fortalezas_social = 'Esta Empresa tiene unos enfoques sociales muy fuertes en el momento de contratar con un enfoque diferencial',
  fortalezas_economico = 'Esta Empresa tiene un componente económico muy fuerte es una de las empresas que ya se encuentra exportando  a países como Alemania, Core del sur y se encuentran en proceso con Estados Unidos',
  emprendimiento_verde = false,
  sello_marca = true,
  avalado = true,
  destacado = false,
  activo = true
where nombre = 'NOVA SCIENCIE S.A.S.';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select '3543b378-2d32-43a4-9f2f-8603b8b348f6', 'NOVA SCIENCIE S.A.S.', generar_slug_unico('NOVA SCIENCIE S.A.S.', '3543b378-2d32-43a4-9f2f-8603b8b348f6'), (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'), 'Piedecuesta', (select id from veredas where municipio = 'Piedecuesta' and slug = 'casiano'), 'VEREDA CASIANO CONDOMINIO CAMPESTRE MONTEARROYO CASA 6', 7.070514166666666, -73.10541138888888, 'Cuentan con toda la cadena de valor desde la Genética , el cultivo y la transformación del Cannabis Medicinal.', 'Cuentan con toda la cadena de valor desde la Genética , el cultivo y la transformación del Cannabis Medicinal.', 'DERIVADOS DE CANNABIS', '3208313865', '573208313865', 'novascience.co@gmail.com', 'DIANA ROCIO SANTANDER URIBE', '901398741-6', 'Jurídica', null, 'Cámara de comercio', 'LILIANA CACERES', 'ACTIVO', 'Dinamizadoras', 2023, '823 msnm', '73°6''19,481"', '7°4''13,851"', 'Actualizó', 'Se realizo visita y se aplico ficha de verificacion', null, 'No', 'Acueducto veredal', null, null, null, 'No', 'No', 'No', null, null, null, 'Sí', '2028-06-29', null, 'No', null, null, null, null, 'Sí', 'Mixta', 'Sí', 'NO', 'APROVECHAMIENTO DE LOS BENEFICIOS Y BONDADES DE LOS INGREDIENTES NATURALES PARA EL CUIDADO DE LA PIEL TALES COMO LA APITERAPIA , EXTRACTOS Y GRASAS PROPIOS DE LA AMAZONIA COLOMBIANA Y EL CONOCIMIENTO CIENTIFICO DEL CANABBIS MEDICINAL.', 'Esta Empresa tiene unos enfoques sociales muy fuertes en el momento de contratar con un enfoque diferencial', 'Esta Empresa tiene un componente económico muy fuerte es una de las empresas que ya se encuentra exportando  a países como Alemania, Core del sur y se encuentran en proceso con Estados Unidos', false, true, true, false, true
where not exists (select 1 from negocios where nombre = 'NOVA SCIENCIE S.A.S.');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'NOVA SCIENCIE S.A.S.');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'NOVA SCIENCIE S.A.S.'), (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'NOVA SCIENCIE S.A.S.');
insert into negocios_subcategorias (negocio_id, subcategoria_id) select (select id from negocios where nombre = 'NOVA SCIENCIE S.A.S.'), id from subcategorias where slug = 'biocomercio';
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'NOVA SCIENCIE S.A.S.');
insert into negocios_actividades (negocio_id, actividad_productiva_id) select (select id from negocios where nombre = 'NOVA SCIENCIE S.A.S.'), id from actividades_productivas where slug = 'recursos-geneticos-productos-derivados';
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'NOVA SCIENCIE S.A.S.'), 2023, 76.76 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'NOVA SCIENCIE S.A.S.'), 2024, 81.0 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'NOVA SCIENCIE S.A.S.'), 2025, 76.0 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;

-- SOS ECO
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'),
  municipio = 'Girón',
  vereda_id = (select id from veredas where municipio = 'Girón' and slug = 'acapulco'),
  direccion = 'VEREDA ACAPULCO, FINCA NUEVO AMANECER, MAZ 11 LOTE 66',
  latitud = 7.121388888888888,
  longitud = -73.11861111111111,
  descripcion_corta = 'cultivos agrosostenibles',
  descripcion = 'cultivos agrosostenibles',
  producto = 'HIERVAS AROMATICAS',
  telefono = '3148417675 - 3224671431',
  whatsapp = '3148417675 - 3224671431',
  email = 'plantacionesunilda@gmail.com',
  representante_legal = 'JENIFER LILIANA QUINTERO CRISTANCHO',
  nit = '1098633942',
  naturaleza_juridica = null,
  delegado = null,
  rut_camara_comercio = null,
  responsable_cdmb = 'ANA RUEDA',
  novedad = 'SUSPENDIDO',
  tipo_negocio_verde = 'Inicial',
  anio_registro = 2023,
  cota_msnm = '989 msnm',
  este = '73°07''07"',
  norte = '7°07''17"',
  aplicacion_ficha_2025 = null,
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
where nombre = 'SOS ECO';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select '82e22ede-1430-42e6-a647-21d952f0ae30', 'SOS ECO', generar_slug_unico('SOS ECO', '82e22ede-1430-42e6-a647-21d952f0ae30'), (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'), 'Girón', (select id from veredas where municipio = 'Girón' and slug = 'acapulco'), 'VEREDA ACAPULCO, FINCA NUEVO AMANECER, MAZ 11 LOTE 66', 7.121388888888888, -73.11861111111111, 'cultivos agrosostenibles', 'cultivos agrosostenibles', 'HIERVAS AROMATICAS', '3148417675 - 3224671431', '3148417675 - 3224671431', 'plantacionesunilda@gmail.com', 'JENIFER LILIANA QUINTERO CRISTANCHO', '1098633942', null, null, null, 'ANA RUEDA', 'SUSPENDIDO', 'Inicial', 2023, '989 msnm', '73°07''07"', '7°07''17"', null, 'Se realizo visita y se aplico ficha de verificacion', null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, true, false, false, false, false
where not exists (select 1 from negocios where nombre = 'SOS ECO');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'SOS ECO');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'SOS ECO'), (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'SOS ECO');
insert into negocios_subcategorias (negocio_id, subcategoria_id) select (select id from negocios where nombre = 'SOS ECO'), id from subcategorias where slug = 'agrosistemas-sostenibles';
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'SOS ECO');
insert into negocios_actividades (negocio_id, actividad_productiva_id) select (select id from negocios where nombre = 'SOS ECO'), id from actividades_productivas where slug = 'agricultura-sostenible';

-- FERTISANDER
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'pendiente-clasificar'),
  municipio = 'Lebrija',
  vereda_id = null,
  direccion = 'FINCA EL PARAISO VEREDA LA CUCHILLA',
  latitud = 7.142777777777778,
  longitud = -73.28305555555555,
  descripcion_corta = null,
  descripcion = null,
  producto = 'ABONO ORGANICO DE LOMBRICES',
  telefono = '3166506982 - 3152352858',
  whatsapp = '3166506982 - 3152352858',
  email = null,
  representante_legal = 'FERNEY LOZANO',
  nit = '91214129',
  naturaleza_juridica = null,
  delegado = null,
  rut_camara_comercio = null,
  responsable_cdmb = 'SILVIA GARCIA',
  novedad = 'RETIRADO',
  tipo_negocio_verde = 'Inicial',
  anio_registro = 2023,
  cota_msnm = '1123 msnm',
  este = '73°16''59"',
  norte = '7°8''34"',
  aplicacion_ficha_2025 = null,
  observaciones = 'Ingresa al programa - pendiente requisitos minimos',
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
where nombre = 'FERTISANDER';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select '9ef25807-aa45-49d2-b5a8-84ee8a6ad349', 'FERTISANDER', generar_slug_unico('FERTISANDER', '9ef25807-aa45-49d2-b5a8-84ee8a6ad349'), (select id from categorias_oficiales where slug = 'pendiente-clasificar'), 'Lebrija', null, 'FINCA EL PARAISO VEREDA LA CUCHILLA', 7.142777777777778, -73.28305555555555, null, null, 'ABONO ORGANICO DE LOMBRICES', '3166506982 - 3152352858', '3166506982 - 3152352858', null, 'FERNEY LOZANO', '91214129', null, null, null, 'SILVIA GARCIA', 'RETIRADO', 'Inicial', 2023, '1123 msnm', '73°16''59"', '7°8''34"', null, 'Ingresa al programa - pendiente requisitos minimos', null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, true, false, false, false, false
where not exists (select 1 from negocios where nombre = 'FERTISANDER');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'FERTISANDER');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'FERTISANDER'), (select id from categorias_oficiales where slug = 'pendiente-clasificar');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'FERTISANDER');
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'FERTISANDER');


commit;
