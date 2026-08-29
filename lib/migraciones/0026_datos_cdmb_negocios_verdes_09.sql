begin;

-- Generado por lib/migraciones/generar_0026.py desde BASE_ACTUALIZADA_NV_ka.xlsx — no editar a mano.
-- Uno de varios archivos partidos (ver README.md) — correr TODOS, en cualquier orden, cada uno es su propia transacción.

-- Parte 9 de 17.

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

-- LA NIEBLA
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'),
  municipio = 'Bucaramanga',
  vereda_id = (select id from veredas where municipio = 'Bucaramanga' and slug = 'san-jose'),
  direccion = 'ALTO DE LOS PADRES VEREDA SAN JOSE- CORREGIMIENTO 3 FINCA LA NIEBLA',
  latitud = 7.12418,
  longitud = -73.07998,
  descripcion_corta = 'El restaurante la Niebla se enfoca en dar a concocer la gastronomía local a través de sus platos fuertes carnes, pescados y dentro de sus instalaciones hay…',
  descripcion = 'El restaurante la Niebla se enfoca en dar a concocer la gastronomía local a través de sus platos fuertes carnes, pescados y dentro de sus instalaciones hay un sendero llamado Bosque de Niebla el cual permite  que el visitante se pueda conectar con el medio natural llevandose una experiencia de bienestar y salud. En cuanto al tema gastronomico se están implementando huertas ecologicas de hortalizas , cafe organico entre otros para consumo del mismo restaurante. La población objetivo son familias, empresas e instituciones educativas.',
  producto = 'GASTRONÓMICO',
  telefono = '3103248309 - 3124090107',
  whatsapp = '3103248309 - 3124090107',
  email = 'jmgpuyana@hotmail.com',
  representante_legal = 'JUAN MANUEL GONZALEZ PUYANA',
  nit = '5563651-9',
  naturaleza_juridica = 'Natural',
  delegado = null,
  rut_camara_comercio = 'Cámara de comercio y RUT',
  responsable_cdmb = 'DIEGO GUTIERREZ',
  novedad = 'RETIRADO',
  tipo_negocio_verde = 'Satisfactorio',
  anio_registro = 2022,
  cota_msnm = '1.645 msnm',
  este = '73.07998',
  norte = '7.12418',
  aplicacion_ficha_2025 = 'No actualizó',
  observaciones = 'No se realizo visita ni se aplico ficha de verificacion',
  registro_nacional_turismo = 'No',
  uso_suelo = null,
  concesion_aguas = null,
  concesion_aguas_vencimiento = null,
  vertimientos = 'Requiere',
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
  sstt = 'No',
  canal_venta = 'B2B',
  exportacion = null,
  huella_carbono = null,
  fortalezas_ambiental = 'Contribuye a la biodiversidad conservando flora y fauna local en el bosque de niebla. Regulación hídrica. Mantiene la calidad y eficiencia del agua gracias a la regulación hídrica del bosque. Reduce gases de efecto invernadero con gran cantidad de árboles. Disminuye emisiones y mejora la salud con alimentos naturales de huerta propia. Sensibiliza sobre agroindustria sostenible y agroturismo.',
  fortalezas_social = 'Espacios agradables: Entorno natural que facilita un ambiente relajado para tareas diarias. Actividades lúdicas y alimentación fomentan un ambiente laboral de calidad. Promueve la economía local generando empleo para la comunidad campesina. Pagos justos y a tiempo optimizan el trabajo y satisfacción laboral.',
  fortalezas_economico = 'Decisiones rápidas en precios y promociones mejoran la eficiencia operativa. Costos operativos bajos aumentan larentabilidad  del restaurante.',
  emprendimiento_verde = true,
  sello_marca = false,
  avalado = false,
  destacado = false,
  activo = false
where nombre = 'LA NIEBLA';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select 'c16348ea-4294-4da2-a393-d40ff636f052', 'LA NIEBLA', generar_slug_unico('LA NIEBLA', 'c16348ea-4294-4da2-a393-d40ff636f052'), (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'), 'Bucaramanga', (select id from veredas where municipio = 'Bucaramanga' and slug = 'san-jose'), 'ALTO DE LOS PADRES VEREDA SAN JOSE- CORREGIMIENTO 3 FINCA LA NIEBLA', 7.12418, -73.07998, 'El restaurante la Niebla se enfoca en dar a concocer la gastronomía local a través de sus platos fuertes carnes, pescados y dentro de sus instalaciones hay…', 'El restaurante la Niebla se enfoca en dar a concocer la gastronomía local a través de sus platos fuertes carnes, pescados y dentro de sus instalaciones hay un sendero llamado Bosque de Niebla el cual permite  que el visitante se pueda conectar con el medio natural llevandose una experiencia de bienestar y salud. En cuanto al tema gastronomico se están implementando huertas ecologicas de hortalizas , cafe organico entre otros para consumo del mismo restaurante. La población objetivo son familias, empresas e instituciones educativas.', 'GASTRONÓMICO', '3103248309 - 3124090107', '3103248309 - 3124090107', 'jmgpuyana@hotmail.com', 'JUAN MANUEL GONZALEZ PUYANA', '5563651-9', 'Natural', null, 'Cámara de comercio y RUT', 'DIEGO GUTIERREZ', 'RETIRADO', 'Satisfactorio', 2022, '1.645 msnm', '73.07998', '7.12418', 'No actualizó', 'No se realizo visita ni se aplico ficha de verificacion', 'No', null, null, null, 'Requiere', null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, 'No', 'B2B', null, null, 'Contribuye a la biodiversidad conservando flora y fauna local en el bosque de niebla. Regulación hídrica. Mantiene la calidad y eficiencia del agua gracias a la regulación hídrica del bosque. Reduce gases de efecto invernadero con gran cantidad de árboles. Disminuye emisiones y mejora la salud con alimentos naturales de huerta propia. Sensibiliza sobre agroindustria sostenible y agroturismo.', 'Espacios agradables: Entorno natural que facilita un ambiente relajado para tareas diarias. Actividades lúdicas y alimentación fomentan un ambiente laboral de calidad. Promueve la economía local generando empleo para la comunidad campesina. Pagos justos y a tiempo optimizan el trabajo y satisfacción laboral.', 'Decisiones rápidas en precios y promociones mejoran la eficiencia operativa. Costos operativos bajos aumentan larentabilidad  del restaurante.', true, false, false, false, false
where not exists (select 1 from negocios where nombre = 'LA NIEBLA');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'LA NIEBLA');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'LA NIEBLA'), (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'LA NIEBLA');
insert into negocios_subcategorias (negocio_id, subcategoria_id) select (select id from negocios where nombre = 'LA NIEBLA'), id from subcategorias where slug = 'turismo-sostenible';
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'LA NIEBLA');
insert into negocios_actividades (negocio_id, actividad_productiva_id) select (select id from negocios where nombre = 'LA NIEBLA'), id from actividades_productivas where slug = 'otros-servicios-turismo-sostenible';
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'LA NIEBLA'), 2024, 0.671 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;

-- VIVERO EL DÍA TERCERO
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'calidad-ambiental'),
  municipio = 'Girón',
  vereda_id = (select id from veredas where municipio = 'Girón' and slug = 'perimetro-urbano'),
  direccion = 'CALLE 47 # 26-85 POBLADO',
  latitud = 7.075555555555555,
  longitud = -73.17,
  descripcion_corta = 'Empresa dedicada a la investigacion y el  tratamiento de semillas de especies nativas, con el fin de propagar y conservar las especies nativas de colombia,…',
  descripcion = 'Empresa dedicada a la investigacion y el  tratamiento de semillas de especies nativas, con el fin de propagar y conservar las especies nativas de colombia, con el fin de preservar principalmente aquellas especies en estado de vulnerabilidad',
  producto = 'SEMILLAS Y PLANTAS',
  telefono = '3152244441',
  whatsapp = '573152244441',
  email = 'viveroeldiatercero@gmail.com',
  representante_legal = 'LUIS EDURADO PINZON QUIÑONEZ',
  nit = '1098618790-1',
  naturaleza_juridica = 'Natural',
  delegado = null,
  rut_camara_comercio = 'Cámara de comercio',
  responsable_cdmb = 'ANDRES VALDERRAMA',
  novedad = 'ACTIVO',
  tipo_negocio_verde = 'Dinamizadoras',
  anio_registro = 2023,
  cota_msnm = '689,1 msnm',
  este = '73°10''12''''',
  norte = '7°4''32''''',
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
  canal_venta = 'B2C',
  exportacion = 'No',
  huella_carbono = 'NO',
  fortalezas_ambiental = 'Investigación permanente en reproducción de nuevas especies. Reproducción de especies nativas. Actividades sostenibles',
  fortalezas_social = 'Siembra regular de plantas en zonas verdes del municipio de Girón. Colines de plantas dispuestas para planes de reforestación',
  fortalezas_economico = 'Modelo de negocio rentable. Empresa legalmente registrada en Cámara de Comercio',
  emprendimiento_verde = true,
  sello_marca = false,
  avalado = false,
  destacado = false,
  activo = true
where nombre = 'VIVERO EL DÍA TERCERO';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select 'd318136f-0a5b-4775-b4c8-7935ba593072', 'VIVERO EL DÍA TERCERO', generar_slug_unico('VIVERO EL DÍA TERCERO', 'd318136f-0a5b-4775-b4c8-7935ba593072'), (select id from categorias_oficiales where slug = 'calidad-ambiental'), 'Girón', (select id from veredas where municipio = 'Girón' and slug = 'perimetro-urbano'), 'CALLE 47 # 26-85 POBLADO', 7.075555555555555, -73.17, 'Empresa dedicada a la investigacion y el  tratamiento de semillas de especies nativas, con el fin de propagar y conservar las especies nativas de colombia,…', 'Empresa dedicada a la investigacion y el  tratamiento de semillas de especies nativas, con el fin de propagar y conservar las especies nativas de colombia, con el fin de preservar principalmente aquellas especies en estado de vulnerabilidad', 'SEMILLAS Y PLANTAS', '3152244441', '573152244441', 'viveroeldiatercero@gmail.com', 'LUIS EDURADO PINZON QUIÑONEZ', '1098618790-1', 'Natural', null, 'Cámara de comercio', 'ANDRES VALDERRAMA', 'ACTIVO', 'Dinamizadoras', 2023, '689,1 msnm', '73°10''12''''', '7°4''32''''', 'Actualizó', 'Se realizo visita y se actualizo ficha de verificacion', null, null, 'Acueducto', null, null, null, 'No', 'No', null, 'Sí', 'No', null, null, null, null, null, null, null, null, null, 'No', 'B2C', 'No', 'NO', 'Investigación permanente en reproducción de nuevas especies. Reproducción de especies nativas. Actividades sostenibles', 'Siembra regular de plantas en zonas verdes del municipio de Girón. Colines de plantas dispuestas para planes de reforestación', 'Modelo de negocio rentable. Empresa legalmente registrada en Cámara de Comercio', true, false, false, false, true
where not exists (select 1 from negocios where nombre = 'VIVERO EL DÍA TERCERO');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'VIVERO EL DÍA TERCERO');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'VIVERO EL DÍA TERCERO'), (select id from categorias_oficiales where slug = 'calidad-ambiental');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'VIVERO EL DÍA TERCERO');
insert into negocios_subcategorias (negocio_id, subcategoria_id) select (select id from negocios where nombre = 'VIVERO EL DÍA TERCERO'), id from subcategorias where slug = 'preservacion-restauracion-ecosistemas';
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'VIVERO EL DÍA TERCERO');
insert into negocios_actividades (negocio_id, actividad_productiva_id) select (select id from negocios where nombre = 'VIVERO EL DÍA TERCERO'), id from actividades_productivas where slug = 'restauracion';
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'VIVERO EL DÍA TERCERO'), 2023, 51.5 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'VIVERO EL DÍA TERCERO'), 2024, 65.9 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'VIVERO EL DÍA TERCERO'), 2025, 67.7 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;

-- HABIOTICO HABITAT VIVO
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'pendiente-clasificar'),
  municipio = 'Piedecuesta',
  vereda_id = null,
  direccion = 'CALLE 01 # 6-65 PIEDECUESTA',
  latitud = null,
  longitud = null,
  descripcion_corta = null,
  descripcion = null,
  producto = 'PAISAJISMO Y RESTAURACION',
  telefono = '30030096479',
  whatsapp = '30030096479',
  email = null,
  representante_legal = 'LISETH NATALIA DELGADO BARAJAS',
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
where nombre = 'HABIOTICO HABITAT VIVO';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select 'b53d7325-74ad-4ec3-a698-4586c9fd2042', 'HABIOTICO HABITAT VIVO', generar_slug_unico('HABIOTICO HABITAT VIVO', 'b53d7325-74ad-4ec3-a698-4586c9fd2042'), (select id from categorias_oficiales where slug = 'pendiente-clasificar'), 'Piedecuesta', null, 'CALLE 01 # 6-65 PIEDECUESTA', null, null, null, null, 'PAISAJISMO Y RESTAURACION', '30030096479', '30030096479', null, 'LISETH NATALIA DELGADO BARAJAS', null, null, null, null, null, 'RETIRADO', 'No aplica', 2023, null, null, null, null, 'No cumplimiento de requisitos', null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, true, false, false, false, false
where not exists (select 1 from negocios where nombre = 'HABIOTICO HABITAT VIVO');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'HABIOTICO HABITAT VIVO');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'HABIOTICO HABITAT VIVO'), (select id from categorias_oficiales where slug = 'pendiente-clasificar');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'HABIOTICO HABITAT VIVO');
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'HABIOTICO HABITAT VIVO');

-- FIBRAS DE LEBRIJA, PAPEL Y EMPAQUES BIODEGRADABLES DE FIBRAS DE PIÑA S.A.S - FIBRENSE  S.A.S
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'pendiente-clasificar'),
  municipio = 'Lebrija',
  vereda_id = null,
  direccion = 'CARRER 8 # 10-40 APTO 303 LEBRIJA',
  latitud = 7.151219444444445,
  longitud = -73.23055555555555,
  descripcion_corta = null,
  descripcion = null,
  producto = 'PAPEL Y EMPAQUES',
  telefono = '3008655880',
  whatsapp = '573008655880',
  email = 'fibrense@gmail.com',
  representante_legal = 'RAMÓN EDUARDO DÍAZ HERNÁNDEZ',
  nit = '901588674-6',
  naturaleza_juridica = null,
  delegado = null,
  rut_camara_comercio = null,
  responsable_cdmb = 'ALVARO ALFEREZ',
  novedad = 'SUSPENDIDO',
  tipo_negocio_verde = 'Inicial',
  anio_registro = 2023,
  cota_msnm = '1.075 msnm',
  este = '73°13''50''''',
  norte = '7°9''4,39''''',
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
where nombre = 'FIBRAS DE LEBRIJA, PAPEL Y EMPAQUES BIODEGRADABLES DE FIBRAS DE PIÑA S.A.S - FIBRENSE  S.A.S';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select '56791cf6-0288-4395-8448-e06abad8badf', 'FIBRAS DE LEBRIJA, PAPEL Y EMPAQUES BIODEGRADABLES DE FIBRAS DE PIÑA S.A.S - FIBRENSE  S.A.S', generar_slug_unico('FIBRAS DE LEBRIJA, PAPEL Y EMPAQUES BIODEGRADABLES DE FIBRAS DE PIÑA S.A.S - FIBRENSE  S.A.S', '56791cf6-0288-4395-8448-e06abad8badf'), (select id from categorias_oficiales where slug = 'pendiente-clasificar'), 'Lebrija', null, 'CARRER 8 # 10-40 APTO 303 LEBRIJA', 7.151219444444445, -73.23055555555555, null, null, 'PAPEL Y EMPAQUES', '3008655880', '573008655880', 'fibrense@gmail.com', 'RAMÓN EDUARDO DÍAZ HERNÁNDEZ', '901588674-6', null, null, null, 'ALVARO ALFEREZ', 'SUSPENDIDO', 'Inicial', 2023, '1.075 msnm', '73°13''50''''', '7°9''4,39''''', null, 'Ingresa al programa', null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, true, false, false, false, false
where not exists (select 1 from negocios where nombre = 'FIBRAS DE LEBRIJA, PAPEL Y EMPAQUES BIODEGRADABLES DE FIBRAS DE PIÑA S.A.S - FIBRENSE  S.A.S');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'FIBRAS DE LEBRIJA, PAPEL Y EMPAQUES BIODEGRADABLES DE FIBRAS DE PIÑA S.A.S - FIBRENSE  S.A.S');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'FIBRAS DE LEBRIJA, PAPEL Y EMPAQUES BIODEGRADABLES DE FIBRAS DE PIÑA S.A.S - FIBRENSE  S.A.S'), (select id from categorias_oficiales where slug = 'pendiente-clasificar');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'FIBRAS DE LEBRIJA, PAPEL Y EMPAQUES BIODEGRADABLES DE FIBRAS DE PIÑA S.A.S - FIBRENSE  S.A.S');
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'FIBRAS DE LEBRIJA, PAPEL Y EMPAQUES BIODEGRADABLES DE FIBRAS DE PIÑA S.A.S - FIBRENSE  S.A.S');

-- SACHACOL S.A.S.
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'),
  municipio = 'Piedecuesta',
  vereda_id = (select id from veredas where municipio = 'Piedecuesta' and slug = 'perimetro-urbano'),
  direccion = 'CALLE 6 # 7-89 OFICINA 101',
  latitud = 7.000277777777778,
  longitud = -73.05638888888889,
  descripcion_corta = 'Empresa dedicada a la Producción de cultivo de Sacha Inchi de forma orgánica, mantenimiento, y limpieza de cultivos, con procesos que no generan…',
  descripcion = 'Empresa dedicada a la Producción de cultivo de Sacha Inchi de forma orgánica, mantenimiento, y limpieza de cultivos, con procesos que no generan contaminación al ambiente, y en la parte de transformación se realiza de forma limpia sin adictivos ni conservantes, es un producto ecológico y limpio.',
  producto = 'ACEITE DE SACHA INCHI',
  telefono = '3155383680',
  whatsapp = '573155383680',
  email = 'gerencia@sachacol.com',
  representante_legal = 'SERGIO ANDRES TORRES CEDIEL',
  nit = '900992488-0',
  naturaleza_juridica = 'Jurídica',
  delegado = null,
  rut_camara_comercio = 'Cámara de comercio',
  responsable_cdmb = 'SEBASTIAN BONNET',
  novedad = 'ACTIVO',
  tipo_negocio_verde = 'Dinamizadoras',
  anio_registro = 2022,
  cota_msnm = '1018 msnm',
  este = '73°03''23"',
  norte = '7°00''01"',
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
  invima = 'Sí',
  invima_vencimiento = '2031-07-26',
  certificado_tenencia_animales = null,
  buenas_practicas_agricolas = 'Sí',
  buenas_practicas_apicolas = null,
  registro_apicola = null,
  intervencion_cauce = null,
  capacidad_carga = null,
  sstt = 'Sí',
  canal_venta = 'Mixta',
  exportacion = 'Sí',
  huella_carbono = 'NO',
  fortalezas_ambiental = 'ELABORACION DE GRASAS Y ACEITES VEGETALES , MEDIANTE CULTIVO , LA TRASNFORMACION DE LA NUEZ DE SACHA INCHI',
  fortalezas_social = 'Esta Empresa tiene unos enfoques sociales muy fuertes en el momento de contratar con un enfoque diferencial',
  fortalezas_economico = 'Desde el componente económico una empresa muy solida y una excelente organización dentro de ella misma',
  emprendimiento_verde = false,
  sello_marca = true,
  avalado = true,
  destacado = false,
  activo = true
where nombre = 'SACHACOL S.A.S.';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select '1508df46-21e9-46d1-8bba-61f8bc419211', 'SACHACOL S.A.S.', generar_slug_unico('SACHACOL S.A.S.', '1508df46-21e9-46d1-8bba-61f8bc419211'), (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'), 'Piedecuesta', (select id from veredas where municipio = 'Piedecuesta' and slug = 'perimetro-urbano'), 'CALLE 6 # 7-89 OFICINA 101', 7.000277777777778, -73.05638888888889, 'Empresa dedicada a la Producción de cultivo de Sacha Inchi de forma orgánica, mantenimiento, y limpieza de cultivos, con procesos que no generan…', 'Empresa dedicada a la Producción de cultivo de Sacha Inchi de forma orgánica, mantenimiento, y limpieza de cultivos, con procesos que no generan contaminación al ambiente, y en la parte de transformación se realiza de forma limpia sin adictivos ni conservantes, es un producto ecológico y limpio.', 'ACEITE DE SACHA INCHI', '3155383680', '573155383680', 'gerencia@sachacol.com', 'SERGIO ANDRES TORRES CEDIEL', '900992488-0', 'Jurídica', null, 'Cámara de comercio', 'SEBASTIAN BONNET', 'ACTIVO', 'Dinamizadoras', 2022, '1018 msnm', '73°03''23"', '7°00''01"', 'Actualizó', 'Se realizo visita y se aplico ficha de verificacion', null, 'Sí', 'Acueducto', null, null, null, 'No', 'Sí', null, 'Sí', null, null, 'Sí', '2031-07-26', null, 'Sí', null, null, null, null, 'Sí', 'Mixta', 'Sí', 'NO', 'ELABORACION DE GRASAS Y ACEITES VEGETALES , MEDIANTE CULTIVO , LA TRASNFORMACION DE LA NUEZ DE SACHA INCHI', 'Esta Empresa tiene unos enfoques sociales muy fuertes en el momento de contratar con un enfoque diferencial', 'Desde el componente económico una empresa muy solida y una excelente organización dentro de ella misma', false, true, true, false, true
where not exists (select 1 from negocios where nombre = 'SACHACOL S.A.S.');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'SACHACOL S.A.S.');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'SACHACOL S.A.S.'), (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'SACHACOL S.A.S.');
insert into negocios_subcategorias (negocio_id, subcategoria_id) select (select id from negocios where nombre = 'SACHACOL S.A.S.'), id from subcategorias where slug = 'agroindustria-sostenible';
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'SACHACOL S.A.S.');
insert into negocios_actividades (negocio_id, actividad_productiva_id) select (select id from negocios where nombre = 'SACHACOL S.A.S.'), id from actividades_productivas where slug = 'agroindustrial-alimentario';
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'SACHACOL S.A.S.'), 2021, 63.9 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'SACHACOL S.A.S.'), 2022, 67.25 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'SACHACOL S.A.S.'), 2023, 70.28 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'SACHACOL S.A.S.'), 2024, 75.4 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'SACHACOL S.A.S.'), 2025, 74.4 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;

-- ABONOS ORGANICOS DE SANTANDER
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'pendiente-clasificar'),
  municipio = 'Piedecuesta',
  vereda_id = null,
  direccion = 'LOTE 3 SECTOR EL MANCITO VEREDA EL VOLADOR',
  latitud = 6.948722222222222,
  longitud = -73.02655555555556,
  descripcion_corta = null,
  descripcion = null,
  producto = 'ABONOS ORGÁNICOS',
  telefono = '3163790137',
  whatsapp = '573163790137',
  email = 'william.ruedav2016@upb.edu.co',
  representante_legal = 'WILLIAM VARGAS RUEDA',
  nit = '1102370744-9',
  naturaleza_juridica = null,
  delegado = null,
  rut_camara_comercio = null,
  responsable_cdmb = 'EDITH GARCÍA',
  novedad = 'SUSPENDIDO',
  tipo_negocio_verde = 'Inicial',
  anio_registro = 2022,
  cota_msnm = '1032 msnm',
  este = '73°1''35,6''''',
  norte = '6°56''55,4''''',
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
where nombre = 'ABONOS ORGANICOS DE SANTANDER';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select '94fe46f0-4362-4b2f-b5e8-a47bca1e9f5e', 'ABONOS ORGANICOS DE SANTANDER', generar_slug_unico('ABONOS ORGANICOS DE SANTANDER', '94fe46f0-4362-4b2f-b5e8-a47bca1e9f5e'), (select id from categorias_oficiales where slug = 'pendiente-clasificar'), 'Piedecuesta', null, 'LOTE 3 SECTOR EL MANCITO VEREDA EL VOLADOR', 6.948722222222222, -73.02655555555556, null, null, 'ABONOS ORGÁNICOS', '3163790137', '573163790137', 'william.ruedav2016@upb.edu.co', 'WILLIAM VARGAS RUEDA', '1102370744-9', null, null, null, 'EDITH GARCÍA', 'SUSPENDIDO', 'Inicial', 2022, '1032 msnm', '73°1''35,6''''', '6°56''55,4''''', null, 'Continua en el programa', null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, true, false, false, false, false
where not exists (select 1 from negocios where nombre = 'ABONOS ORGANICOS DE SANTANDER');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'ABONOS ORGANICOS DE SANTANDER');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'ABONOS ORGANICOS DE SANTANDER'), (select id from categorias_oficiales where slug = 'pendiente-clasificar');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'ABONOS ORGANICOS DE SANTANDER');
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'ABONOS ORGANICOS DE SANTANDER');

-- ABONOS AGROCOL LTDA
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'ecoproductos-industriales'),
  municipio = 'Girón',
  vereda_id = (select id from veredas where municipio = 'Girón' and slug = 'perimetro-urbano'),
  direccion = 'KM 5,5 VIA GIRON-BUCARAMANGA',
  latitud = 7.065555555555555,
  longitud = null,
  descripcion_corta = 'Produccion, industrializacion y comercializacion de los productos y subproductos agricolas y pecuarios, asi como del abono biocompost, investigacion…',
  descripcion = 'Produccion, industrializacion y comercializacion de los productos y subproductos agricolas y pecuarios, asi como del abono biocompost, investigacion cientificay tecnica par-sic.su',
  producto = 'ABONO ORGANICO BULTO 50 KG',
  telefono = '3118954769',
  whatsapp = '573118954769',
  email = 'desarrollo.negocios@agronaturex.com',
  representante_legal = 'JUSCELINO BADILLO LUNA',
  nit = '804004485-3',
  naturaleza_juridica = 'Jurídica',
  delegado = 'JORGE BLANCO',
  rut_camara_comercio = 'Cámara de comercio',
  responsable_cdmb = 'SILVIA VALDIVIESO',
  novedad = 'ACTIVO',
  tipo_negocio_verde = 'Dinamizadoras',
  anio_registro = 2023,
  cota_msnm = null,
  este = '73°73''24"',
  norte = '7°3''56"',
  aplicacion_ficha_2025 = 'Actualizó',
  observaciones = 'Se realizo visita y se actualizo ficha de verificacion',
  registro_nacional_turismo = null,
  uso_suelo = 'Sí',
  concesion_aguas = null,
  concesion_aguas_vencimiento = null,
  vertimientos = null,
  vertimientos_vencimiento = null,
  pueaa = 'No',
  pgris = 'No',
  pozo_septico = 'No',
  alcantarillado = null,
  ica = 'Sí',
  ica_vencimiento = null,
  invima = null,
  invima_vencimiento = null,
  certificado_tenencia_animales = null,
  buenas_practicas_agricolas = 'No',
  buenas_practicas_apicolas = null,
  registro_apicola = null,
  intervencion_cauce = null,
  capacidad_carga = null,
  sstt = 'Sí',
  canal_venta = 'B2C',
  exportacion = 'No',
  huella_carbono = 'NO',
  fortalezas_ambiental = 'Reforestación en especial cerca de fuentes hídricas. Restauración de propiedades del suelo. Recuperación de los microorganismos.',
  fortalezas_social = 'Charlas sobre el cuidado del medio ambiente. Grupo de HSEQ donde fomentan uso racional de recursos no renovables. Integración y personal calificado de apoyo.',
  fortalezas_economico = 'Implementación rutas de mercadeo. Empresa legalmente registrada en cámara de comercio y RUT. Actualización en facturación y normas reglamentarias.',
  emprendimiento_verde = true,
  sello_marca = false,
  avalado = false,
  destacado = false,
  activo = true
where nombre = 'ABONOS AGROCOL LTDA';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select 'f55d8384-9386-44b8-b4b2-ea0af1d01372', 'ABONOS AGROCOL LTDA', generar_slug_unico('ABONOS AGROCOL LTDA', 'f55d8384-9386-44b8-b4b2-ea0af1d01372'), (select id from categorias_oficiales where slug = 'ecoproductos-industriales'), 'Girón', (select id from veredas where municipio = 'Girón' and slug = 'perimetro-urbano'), 'KM 5,5 VIA GIRON-BUCARAMANGA', 7.065555555555555, null, 'Produccion, industrializacion y comercializacion de los productos y subproductos agricolas y pecuarios, asi como del abono biocompost, investigacion…', 'Produccion, industrializacion y comercializacion de los productos y subproductos agricolas y pecuarios, asi como del abono biocompost, investigacion cientificay tecnica par-sic.su', 'ABONO ORGANICO BULTO 50 KG', '3118954769', '573118954769', 'desarrollo.negocios@agronaturex.com', 'JUSCELINO BADILLO LUNA', '804004485-3', 'Jurídica', 'JORGE BLANCO', 'Cámara de comercio', 'SILVIA VALDIVIESO', 'ACTIVO', 'Dinamizadoras', 2023, null, '73°73''24"', '7°3''56"', 'Actualizó', 'Se realizo visita y se actualizo ficha de verificacion', null, 'Sí', null, null, null, null, 'No', 'No', 'No', null, 'Sí', null, null, null, null, 'No', null, null, null, null, 'Sí', 'B2C', 'No', 'NO', 'Reforestación en especial cerca de fuentes hídricas. Restauración de propiedades del suelo. Recuperación de los microorganismos.', 'Charlas sobre el cuidado del medio ambiente. Grupo de HSEQ donde fomentan uso racional de recursos no renovables. Integración y personal calificado de apoyo.', 'Implementación rutas de mercadeo. Empresa legalmente registrada en cámara de comercio y RUT. Actualización en facturación y normas reglamentarias.', true, false, false, false, true
where not exists (select 1 from negocios where nombre = 'ABONOS AGROCOL LTDA');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'ABONOS AGROCOL LTDA');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'ABONOS AGROCOL LTDA'), (select id from categorias_oficiales where slug = 'ecoproductos-industriales');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'ABONOS AGROCOL LTDA');
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'ABONOS AGROCOL LTDA');
insert into negocios_actividades (negocio_id, actividad_productiva_id) select (select id from negocios where nombre = 'ABONOS AGROCOL LTDA'), id from actividades_productivas where slug = 'aprovechamiento-residuos-organicos';
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'ABONOS AGROCOL LTDA'), 2023, 53.58 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'ABONOS AGROCOL LTDA'), 2024, 80.6 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'ABONOS AGROCOL LTDA'), 2025, 67.8 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;

-- SUSPAK
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'pendiente-clasificar'),
  municipio = 'Bucaramanga',
  vereda_id = null,
  direccion = 'CALLE 111 # 22B -54',
  latitud = 7.081793,
  longitud = -73.11372,
  descripcion_corta = null,
  descripcion = null,
  producto = null,
  telefono = '3144286710',
  whatsapp = '573144286710',
  email = null,
  representante_legal = 'DIANA ROCIO RUEDA CARREÑO',
  nit = null,
  naturaleza_juridica = null,
  delegado = null,
  rut_camara_comercio = null,
  responsable_cdmb = null,
  novedad = 'RETIRADO',
  tipo_negocio_verde = 'No aplica',
  anio_registro = 2023,
  cota_msnm = null,
  este = '73.11372',
  norte = '7.081793',
  aplicacion_ficha_2025 = null,
  observaciones = 'NO ingresa al programa',
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
where nombre = 'SUSPAK';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select '3060cb4b-41e5-4d47-b0db-dfd7f3c5f356', 'SUSPAK', generar_slug_unico('SUSPAK', '3060cb4b-41e5-4d47-b0db-dfd7f3c5f356'), (select id from categorias_oficiales where slug = 'pendiente-clasificar'), 'Bucaramanga', null, 'CALLE 111 # 22B -54', 7.081793, -73.11372, null, null, null, '3144286710', '573144286710', null, 'DIANA ROCIO RUEDA CARREÑO', null, null, null, null, null, 'RETIRADO', 'No aplica', 2023, null, '73.11372', '7.081793', null, 'NO ingresa al programa', null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, true, false, false, false, false
where not exists (select 1 from negocios where nombre = 'SUSPAK');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'SUSPAK');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'SUSPAK'), (select id from categorias_oficiales where slug = 'pendiente-clasificar');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'SUSPAK');
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'SUSPAK');

-- ALIVIEN BIO
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'),
  municipio = 'Girón',
  vereda_id = (select id from veredas where municipio = 'Girón' and slug = 'rio-frio'),
  direccion = 'TRASVERSAL MAL PASO-CL 105 PARCELA EL FICAL',
  latitud = null,
  longitud = null,
  descripcion_corta = 'Farmabotánica donde se elaboran productos para el bienestar de la salud y cosmético a partir de extractos de plantas medicinales provenientes de su propio…',
  descripcion = 'Farmabotánica donde se elaboran productos para el bienestar de la salud y cosmético a partir de extractos de plantas medicinales provenientes de su propio cultivo ecológico.',
  producto = 'CERO STRES FORTE (7 PLANTAS MEDICINALES) Y SÉRUM FACIAL DE BUGAMBILIAS',
  telefono = '3142536128',
  whatsapp = '573142536128',
  email = 'fundacionsayer@gmail.com, coordinacionasutall@gmail.com',
  representante_legal = 'ISABEL SOFIA GIL REY',
  nit = '900842291-4',
  naturaleza_juridica = 'Jurídica',
  delegado = 'SANDRA REY HERNANDEZ',
  rut_camara_comercio = 'Cámara de comercio',
  responsable_cdmb = 'LILIANA CACERES',
  novedad = 'ACTIVO',
  tipo_negocio_verde = 'Dinamizadoras',
  anio_registro = 2022,
  cota_msnm = '881.4 msnm',
  este = '73°13965317',
  norte = '7°07534494',
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
  huella_carbono = 'NO',
  fortalezas_ambiental = 'SI, Huerta de plantas medicinales aromáticas (sábila, orégano, romero, lavanda inglesa, limonaria y menta) conservando los polinizadores. 
-No se utilizan materiales peligrosos y/o tóxicos en los procesos.
-Envase de vidrio.
- Alianza con Corambiente-proyecto agroecológico🌳SanGil. 
- Charlas sobre armonía con la naturaleza y consumo sostenible en los colegios Birey solis y panamericano. Blog "espiritualidad y plantas medicinales. blogspot.co"',
  fortalezas_social = 'si, Proveedor verde de abono para las plantas Ecohumus. 
- Clientes potenciales del conflicto armado-victimas de minas.',
  fortalezas_economico = 'Tiene claro algunos costos y gastos pero no la totalidad de operación del negocio.',
  emprendimiento_verde = true,
  sello_marca = false,
  avalado = false,
  destacado = false,
  activo = true
where nombre = 'ALIVIEN BIO';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select 'e567ad3f-3ccc-4a46-a44b-cec68c351db7', 'ALIVIEN BIO', generar_slug_unico('ALIVIEN BIO', 'e567ad3f-3ccc-4a46-a44b-cec68c351db7'), (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'), 'Girón', (select id from veredas where municipio = 'Girón' and slug = 'rio-frio'), 'TRASVERSAL MAL PASO-CL 105 PARCELA EL FICAL', null, null, 'Farmabotánica donde se elaboran productos para el bienestar de la salud y cosmético a partir de extractos de plantas medicinales provenientes de su propio…', 'Farmabotánica donde se elaboran productos para el bienestar de la salud y cosmético a partir de extractos de plantas medicinales provenientes de su propio cultivo ecológico.', 'CERO STRES FORTE (7 PLANTAS MEDICINALES) Y SÉRUM FACIAL DE BUGAMBILIAS', '3142536128', '573142536128', 'fundacionsayer@gmail.com, coordinacionasutall@gmail.com', 'ISABEL SOFIA GIL REY', '900842291-4', 'Jurídica', 'SANDRA REY HERNANDEZ', 'Cámara de comercio', 'LILIANA CACERES', 'ACTIVO', 'Dinamizadoras', 2022, '881.4 msnm', '73°13965317', '7°07534494', 'Actualizó', 'Se realizo visita y se aplico ficha de verificacion', null, 'No', 'Acueducto veredal', null, null, null, 'No', 'No', 'Sí', null, null, null, 'No', null, null, 'No', null, null, null, null, 'No', 'B2C', 'No', 'NO', 'SI, Huerta de plantas medicinales aromáticas (sábila, orégano, romero, lavanda inglesa, limonaria y menta) conservando los polinizadores. 
-No se utilizan materiales peligrosos y/o tóxicos en los procesos.
-Envase de vidrio.
- Alianza con Corambiente-proyecto agroecológico🌳SanGil. 
- Charlas sobre armonía con la naturaleza y consumo sostenible en los colegios Birey solis y panamericano. Blog "espiritualidad y plantas medicinales. blogspot.co"', 'si, Proveedor verde de abono para las plantas Ecohumus. 
- Clientes potenciales del conflicto armado-victimas de minas.', 'Tiene claro algunos costos y gastos pero no la totalidad de operación del negocio.', true, false, false, false, true
where not exists (select 1 from negocios where nombre = 'ALIVIEN BIO');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'ALIVIEN BIO');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'ALIVIEN BIO'), (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'ALIVIEN BIO');
insert into negocios_subcategorias (negocio_id, subcategoria_id) select (select id from negocios where nombre = 'ALIVIEN BIO'), id from subcategorias where slug = 'agrosistemas-sostenibles';
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'ALIVIEN BIO');
insert into negocios_actividades (negocio_id, actividad_productiva_id) select (select id from negocios where nombre = 'ALIVIEN BIO'), id from actividades_productivas where slug = 'agroecologia';
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'ALIVIEN BIO'), 2024, 48.2 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'ALIVIEN BIO'), 2025, 48.2 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;

-- CELESTINO CO
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'ecoproductos-industriales'),
  municipio = 'Bucaramanga',
  vereda_id = (select id from veredas where municipio = 'Bucaramanga' and slug = 'perimetro-urbano'),
  direccion = 'AV QUEBRADASECA # 33 - 130 ED FAVIUS',
  latitud = 7.130552499999999,
  longitud = -73.11377194444444,
  descripcion_corta = 'Celestino es una empresa dedicada a la elaboración de bolsos y accesorios fabricados a base de fique y otros materiales naturales, incorporando semillas y…',
  descripcion = 'Celestino es una empresa dedicada a la elaboración de bolsos y accesorios fabricados a base de fique y otros materiales naturales, incorporando semillas y fibras artesanales en sus diseños. Su producción se caracteriza por el rescate de técnicas tradicionales, la promoción del trabajo local y el compromiso con la sostenibilidad ambiental. Cada pieza refleja una combinación de arte, cultura y conciencia ecológica, ofreciendo productos únicos que apoyan la economía circular y la valorización del patrimonio artesanal colombiano.',
  producto = 'MODA SOSTENIBLE',
  telefono = '3202391205',
  whatsapp = '573202391205',
  email = 'celestinocolombia@gmail.com',
  representante_legal = 'MANOLO FLOREZ CALLE',
  nit = '1088301142-0',
  naturaleza_juridica = 'Natural',
  delegado = 'DAVID MURCIA',
  rut_camara_comercio = 'Cámara de comercio',
  responsable_cdmb = 'SEBASTIAN BONNET',
  novedad = 'ACTIVO',
  tipo_negocio_verde = 'Avanzado',
  anio_registro = 2023,
  cota_msnm = '1028 msnm',
  este = '73°6''49,579"',
  norte = '7°7''49,989"',
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
  canal_venta = 'Mixta',
  exportacion = 'Sí',
  huella_carbono = 'NO',
  fortalezas_ambiental = 'Uso de materiales naturales y técnicas sostenibles.',
  fortalezas_social = 'Promueve el trabajo local y rescata tradiciones culturales.',
  fortalezas_economico = 'Productos diferenciados con valor artesanal.',
  emprendimiento_verde = false,
  sello_marca = true,
  avalado = true,
  destacado = false,
  activo = true
where nombre = 'CELESTINO CO';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select 'f289bc22-c729-438b-a021-c8c3816f21a8', 'CELESTINO CO', generar_slug_unico('CELESTINO CO', 'f289bc22-c729-438b-a021-c8c3816f21a8'), (select id from categorias_oficiales where slug = 'ecoproductos-industriales'), 'Bucaramanga', (select id from veredas where municipio = 'Bucaramanga' and slug = 'perimetro-urbano'), 'AV QUEBRADASECA # 33 - 130 ED FAVIUS', 7.130552499999999, -73.11377194444444, 'Celestino es una empresa dedicada a la elaboración de bolsos y accesorios fabricados a base de fique y otros materiales naturales, incorporando semillas y…', 'Celestino es una empresa dedicada a la elaboración de bolsos y accesorios fabricados a base de fique y otros materiales naturales, incorporando semillas y fibras artesanales en sus diseños. Su producción se caracteriza por el rescate de técnicas tradicionales, la promoción del trabajo local y el compromiso con la sostenibilidad ambiental. Cada pieza refleja una combinación de arte, cultura y conciencia ecológica, ofreciendo productos únicos que apoyan la economía circular y la valorización del patrimonio artesanal colombiano.', 'MODA SOSTENIBLE', '3202391205', '573202391205', 'celestinocolombia@gmail.com', 'MANOLO FLOREZ CALLE', '1088301142-0', 'Natural', 'DAVID MURCIA', 'Cámara de comercio', 'SEBASTIAN BONNET', 'ACTIVO', 'Avanzado', 2023, '1028 msnm', '73°6''49,579"', '7°7''49,989"', 'Actualizó', 'Se realizo visita y se actualizo ficha de verificacion', null, 'No', 'Acueducto', null, null, null, 'No', 'No', null, 'Sí', null, null, null, null, null, null, null, null, null, null, 'No', 'Mixta', 'Sí', 'NO', 'Uso de materiales naturales y técnicas sostenibles.', 'Promueve el trabajo local y rescata tradiciones culturales.', 'Productos diferenciados con valor artesanal.', false, true, true, false, true
where not exists (select 1 from negocios where nombre = 'CELESTINO CO');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'CELESTINO CO');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'CELESTINO CO'), (select id from categorias_oficiales where slug = 'ecoproductos-industriales');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'CELESTINO CO');
insert into negocios_subcategorias (negocio_id, subcategoria_id) select (select id from negocios where nombre = 'CELESTINO CO'), id from subcategorias where slug = 'moda-sostenible';
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'CELESTINO CO');
insert into negocios_actividades (negocio_id, actividad_productiva_id) select (select id from negocios where nombre = 'CELESTINO CO'), id from actividades_productivas where slug = 'confeccion-manufactura';
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'CELESTINO CO'), 2024, 69.5 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'CELESTINO CO'), 2025, 79.1 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;

-- COLOMBIANA ORIENTAL DE AMBIENTE SAS
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'pendiente-clasificar'),
  municipio = 'Bucaramanga',
  vereda_id = null,
  direccion = 'CARRERA 23 # 116 - 32 2DO PISO PROVENZA',
  latitud = null,
  longitud = null,
  descripcion_corta = null,
  descripcion = null,
  producto = null,
  telefono = '3174355677 - 3003771150',
  whatsapp = '3174355677 - 3003771150',
  email = null,
  representante_legal = 'KAREN ORTIZ CASTRO',
  nit = '1098748121',
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
  observaciones = 'NO ingresa al programa',
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
where nombre = 'COLOMBIANA ORIENTAL DE AMBIENTE SAS';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select '40bc3d67-7838-46ea-8f2f-ce9fb5100ce0', 'COLOMBIANA ORIENTAL DE AMBIENTE SAS', generar_slug_unico('COLOMBIANA ORIENTAL DE AMBIENTE SAS', '40bc3d67-7838-46ea-8f2f-ce9fb5100ce0'), (select id from categorias_oficiales where slug = 'pendiente-clasificar'), 'Bucaramanga', null, 'CARRERA 23 # 116 - 32 2DO PISO PROVENZA', null, null, null, null, null, '3174355677 - 3003771150', '3174355677 - 3003771150', null, 'KAREN ORTIZ CASTRO', '1098748121', null, null, null, null, 'RETIRADO', 'No aplica', 2023, null, null, null, null, 'NO ingresa al programa', null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, true, false, false, false, false
where not exists (select 1 from negocios where nombre = 'COLOMBIANA ORIENTAL DE AMBIENTE SAS');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'COLOMBIANA ORIENTAL DE AMBIENTE SAS');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'COLOMBIANA ORIENTAL DE AMBIENTE SAS'), (select id from categorias_oficiales where slug = 'pendiente-clasificar');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'COLOMBIANA ORIENTAL DE AMBIENTE SAS');
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'COLOMBIANA ORIENTAL DE AMBIENTE SAS');

-- CHELPA
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'pendiente-clasificar'),
  municipio = 'Bucaramanga',
  vereda_id = null,
  direccion = 'CARRERA 27 # 19 - 27 2DO PISO',
  latitud = null,
  longitud = null,
  descripcion_corta = null,
  descripcion = null,
  producto = 'CONSULTORÍA AMBIENTAL',
  telefono = '3208677489',
  whatsapp = '573208677489',
  email = null,
  representante_legal = 'EDINSON LEONARDO FRIDA RODRIGUEZ',
  nit = '13716761',
  naturaleza_juridica = null,
  delegado = null,
  rut_camara_comercio = null,
  responsable_cdmb = 'ALEXANDER FLOREZ',
  novedad = 'INACTIVO',
  tipo_negocio_verde = null,
  anio_registro = 2023,
  cota_msnm = null,
  este = null,
  norte = null,
  aplicacion_ficha_2025 = null,
  observaciones = 'ingresa al programa como aliado',
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
where nombre = 'CHELPA';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select '818a0847-dcf4-4ca5-9cf7-91f9e32a75ff', 'CHELPA', generar_slug_unico('CHELPA', '818a0847-dcf4-4ca5-9cf7-91f9e32a75ff'), (select id from categorias_oficiales where slug = 'pendiente-clasificar'), 'Bucaramanga', null, 'CARRERA 27 # 19 - 27 2DO PISO', null, null, null, null, 'CONSULTORÍA AMBIENTAL', '3208677489', '573208677489', null, 'EDINSON LEONARDO FRIDA RODRIGUEZ', '13716761', null, null, null, 'ALEXANDER FLOREZ', 'INACTIVO', null, 2023, null, null, null, null, 'ingresa al programa como aliado', null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, true, false, false, false, false
where not exists (select 1 from negocios where nombre = 'CHELPA');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'CHELPA');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'CHELPA'), (select id from categorias_oficiales where slug = 'pendiente-clasificar');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'CHELPA');
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'CHELPA');

-- GREEN GLOBAL INGENIERIA S.A.S.
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'pendiente-clasificar'),
  municipio = 'Bucaramanga',
  vereda_id = null,
  direccion = 'CALLE 68A # 10B-20 BARRIO PABLO IV',
  latitud = 7.118888888888889,
  longitud = -73.11888888888888,
  descripcion_corta = 'Es una empresa con proposito ambiental que se centra en diseñar y construir espacios naturales interiores y exteriores que fusionan la arquitectura el…',
  descripcion = 'Es una empresa con proposito ambiental que se centra en diseñar y construir espacios naturales interiores y exteriores que fusionan la arquitectura el diseño y la naturaleza para aportar a la sociedad y al ambiente más metros cuadrados de cobertura vegetal con un estilo urbano ecoamigable que mitigan y absorben los G.E.I',
  producto = 'JARDINES VERTICALES NATURALES',
  telefono = '3152022475',
  whatsapp = '573152022475',
  email = 'ingmichaelsanchez@gmail.com',
  representante_legal = 'MICHEL ANDREI SANCHEZ LEAL',
  nit = '901689457-8',
  naturaleza_juridica = null,
  delegado = null,
  rut_camara_comercio = null,
  responsable_cdmb = 'ALVARO ALFEREZ',
  novedad = 'SUSPENDIDO',
  tipo_negocio_verde = 'Inicial',
  anio_registro = 2023,
  cota_msnm = null,
  este = '73°07''08"',
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
where nombre = 'GREEN GLOBAL INGENIERIA S.A.S.';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select 'eb8dfcf9-a710-4e0f-ad55-0bf47b81c9a9', 'GREEN GLOBAL INGENIERIA S.A.S.', generar_slug_unico('GREEN GLOBAL INGENIERIA S.A.S.', 'eb8dfcf9-a710-4e0f-ad55-0bf47b81c9a9'), (select id from categorias_oficiales where slug = 'pendiente-clasificar'), 'Bucaramanga', null, 'CALLE 68A # 10B-20 BARRIO PABLO IV', 7.118888888888889, -73.11888888888888, 'Es una empresa con proposito ambiental que se centra en diseñar y construir espacios naturales interiores y exteriores que fusionan la arquitectura el…', 'Es una empresa con proposito ambiental que se centra en diseñar y construir espacios naturales interiores y exteriores que fusionan la arquitectura el diseño y la naturaleza para aportar a la sociedad y al ambiente más metros cuadrados de cobertura vegetal con un estilo urbano ecoamigable que mitigan y absorben los G.E.I', 'JARDINES VERTICALES NATURALES', '3152022475', '573152022475', 'ingmichaelsanchez@gmail.com', 'MICHEL ANDREI SANCHEZ LEAL', '901689457-8', null, null, null, 'ALVARO ALFEREZ', 'SUSPENDIDO', 'Inicial', 2023, null, '73°07''08"', '7°07''08"', null, 'Continua en el programa', null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, false, false, true, false, false
where not exists (select 1 from negocios where nombre = 'GREEN GLOBAL INGENIERIA S.A.S.');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'GREEN GLOBAL INGENIERIA S.A.S.');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'GREEN GLOBAL INGENIERIA S.A.S.'), (select id from categorias_oficiales where slug = 'pendiente-clasificar');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'GREEN GLOBAL INGENIERIA S.A.S.');
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'GREEN GLOBAL INGENIERIA S.A.S.');
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'GREEN GLOBAL INGENIERIA S.A.S.'), 2023, 54.64 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;

-- CEMENTERIO CATOLICO ARQUIDIOSESANO DE BUCARAMANGA
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'pendiente-clasificar'),
  municipio = 'Bucaramanga',
  vereda_id = null,
  direccion = null,
  latitud = null,
  longitud = null,
  descripcion_corta = null,
  descripcion = null,
  producto = 'CENIZARIOS BIODEGRADABLES',
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
where nombre = 'CEMENTERIO CATOLICO ARQUIDIOSESANO DE BUCARAMANGA';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select 'f12892f8-cea6-40c7-9771-26dc01906377', 'CEMENTERIO CATOLICO ARQUIDIOSESANO DE BUCARAMANGA', generar_slug_unico('CEMENTERIO CATOLICO ARQUIDIOSESANO DE BUCARAMANGA', 'f12892f8-cea6-40c7-9771-26dc01906377'), (select id from categorias_oficiales where slug = 'pendiente-clasificar'), 'Bucaramanga', null, null, null, null, null, null, 'CENIZARIOS BIODEGRADABLES', null, null, null, null, null, null, null, null, null, 'RETIRADO', 'No aplica', 2023, null, null, null, null, 'No cumplimiento de requisitos', null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, true, false, false, false, false
where not exists (select 1 from negocios where nombre = 'CEMENTERIO CATOLICO ARQUIDIOSESANO DE BUCARAMANGA');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'CEMENTERIO CATOLICO ARQUIDIOSESANO DE BUCARAMANGA');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'CEMENTERIO CATOLICO ARQUIDIOSESANO DE BUCARAMANGA'), (select id from categorias_oficiales where slug = 'pendiente-clasificar');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'CEMENTERIO CATOLICO ARQUIDIOSESANO DE BUCARAMANGA');
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'CEMENTERIO CATOLICO ARQUIDIOSESANO DE BUCARAMANGA');

-- EMPAQUES CARDENAS S.A.S.
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'ecoproductos-industriales'),
  municipio = 'Bucaramanga',
  vereda_id = (select id from veredas where municipio = 'Bucaramanga' and slug = 'perimetro-urbano'),
  direccion = 'AV QUEBRADA SECA Nº 19-41.',
  latitud = 7.123888888888889,
  longitud = -73.12444444444444,
  descripcion_corta = 'Comercializacion de sacos de fibra, fique ,yute, bolsas de papel nuevos y usados',
  descripcion = 'Comercializacion de sacos de fibra, fique ,yute, bolsas de papel nuevos y usados',
  producto = 'COMERCIALIZACIÓN DE EMPAQUES DE PRIMERO Y SEGUNDO USO',
  telefono = '3156447828 - 3160253415',
  whatsapp = '3156447828 - 3160253415',
  email = 'gerencia@empaquescardenas.com',
  representante_legal = 'GUSTAVO ADOLFO CARDENAS GUTIERREZ',
  nit = '900259885-9',
  naturaleza_juridica = 'Jurídica',
  delegado = null,
  rut_camara_comercio = 'Cámara de comercio',
  responsable_cdmb = 'DIANA NAVARRO',
  novedad = 'ACTIVO',
  tipo_negocio_verde = 'Dinamizadoras',
  anio_registro = 2023,
  cota_msnm = '970 msnm',
  este = '73°07''28"',
  norte = '7°07''26"',
  aplicacion_ficha_2025 = 'Actualizó',
  observaciones = null,
  registro_nacional_turismo = null,
  uso_suelo = 'Sí',
  concesion_aguas = 'Acueducto',
  concesion_aguas_vencimiento = null,
  vertimientos = null,
  vertimientos_vencimiento = null,
  pueaa = 'Sí',
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
  canal_venta = 'Mixta',
  exportacion = 'No',
  huella_carbono = 'NO',
  fortalezas_ambiental = '• Cuenta con una ingeniera ambiental que lidera los procesos de manejo, control y mejora continua en sostenibilidad.
 • Posee certificaciones ISO 9001, ISO 14001 y ISO 45001, que respaldan la calidad, la gestión ambiental y la seguridad laboral.
 • Tiene sello de Negocio Verde, lo que valida su compromiso con la sostenibilidad y el cumplimiento de criterios ambientales.
 • Desarrolla una actividad de economía circular, al recuperar y reutilizar sacos de fique, reduciendo residuos y consumo de materia prima.
 • El material principal (fique) es biodegradable, renovable y de bajo impacto ambiental.',
  fortalezas_social = 'Genera empleo formal y estable en la región, especialmente para mano de obra local.
 • Implementa normas de seguridad y salud en el trabajo, soportadas por la ISO 45001.
 • Posee un equipo humano capacitado y con compromiso ambiental.
 • Mantiene alianzas con productores locales de fique, fortaleciendo las economías rurales.
 • Su gestión y certificaciones fortalecen la reputación y confianza con clientes, instituciones y comunidades.',
  fortalezas_economico = 'Presenta muy buenas ventas y flujo de capital sólido, lo que le permite mantener estabilidad financiera.
 • La reutilización de sacos reduce costos y mejora la eficiencia económica del proceso.
 • El posicionamiento de marca como negocio verde le da ventaja competitiva frente a productos convencionales.
 • Capacidad de cumplir con estándares de calidad exigidos por clientes grandes (por sus certificaciones ISO).
 • Potencial de diversificación hacia nuevas líneas de productos sostenibles derivados del fique.',
  emprendimiento_verde = false,
  sello_marca = true,
  avalado = true,
  destacado = false,
  activo = true
where nombre = 'EMPAQUES CARDENAS S.A.S.';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select '2b0047b9-fe79-463e-86e4-26654d8f507f', 'EMPAQUES CARDENAS S.A.S.', generar_slug_unico('EMPAQUES CARDENAS S.A.S.', '2b0047b9-fe79-463e-86e4-26654d8f507f'), (select id from categorias_oficiales where slug = 'ecoproductos-industriales'), 'Bucaramanga', (select id from veredas where municipio = 'Bucaramanga' and slug = 'perimetro-urbano'), 'AV QUEBRADA SECA Nº 19-41.', 7.123888888888889, -73.12444444444444, 'Comercializacion de sacos de fibra, fique ,yute, bolsas de papel nuevos y usados', 'Comercializacion de sacos de fibra, fique ,yute, bolsas de papel nuevos y usados', 'COMERCIALIZACIÓN DE EMPAQUES DE PRIMERO Y SEGUNDO USO', '3156447828 - 3160253415', '3156447828 - 3160253415', 'gerencia@empaquescardenas.com', 'GUSTAVO ADOLFO CARDENAS GUTIERREZ', '900259885-9', 'Jurídica', null, 'Cámara de comercio', 'DIANA NAVARRO', 'ACTIVO', 'Dinamizadoras', 2023, '970 msnm', '73°07''28"', '7°07''26"', 'Actualizó', null, null, 'Sí', 'Acueducto', null, null, null, 'Sí', 'Sí', null, 'Sí', null, null, null, null, null, null, null, null, null, null, 'No', 'Mixta', 'No', 'NO', '• Cuenta con una ingeniera ambiental que lidera los procesos de manejo, control y mejora continua en sostenibilidad.
 • Posee certificaciones ISO 9001, ISO 14001 y ISO 45001, que respaldan la calidad, la gestión ambiental y la seguridad laboral.
 • Tiene sello de Negocio Verde, lo que valida su compromiso con la sostenibilidad y el cumplimiento de criterios ambientales.
 • Desarrolla una actividad de economía circular, al recuperar y reutilizar sacos de fique, reduciendo residuos y consumo de materia prima.
 • El material principal (fique) es biodegradable, renovable y de bajo impacto ambiental.', 'Genera empleo formal y estable en la región, especialmente para mano de obra local.
 • Implementa normas de seguridad y salud en el trabajo, soportadas por la ISO 45001.
 • Posee un equipo humano capacitado y con compromiso ambiental.
 • Mantiene alianzas con productores locales de fique, fortaleciendo las economías rurales.
 • Su gestión y certificaciones fortalecen la reputación y confianza con clientes, instituciones y comunidades.', 'Presenta muy buenas ventas y flujo de capital sólido, lo que le permite mantener estabilidad financiera.
 • La reutilización de sacos reduce costos y mejora la eficiencia económica del proceso.
 • El posicionamiento de marca como negocio verde le da ventaja competitiva frente a productos convencionales.
 • Capacidad de cumplir con estándares de calidad exigidos por clientes grandes (por sus certificaciones ISO).
 • Potencial de diversificación hacia nuevas líneas de productos sostenibles derivados del fique.', false, true, true, false, true
where not exists (select 1 from negocios where nombre = 'EMPAQUES CARDENAS S.A.S.');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'EMPAQUES CARDENAS S.A.S.');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'EMPAQUES CARDENAS S.A.S.'), (select id from categorias_oficiales where slug = 'ecoproductos-industriales');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'EMPAQUES CARDENAS S.A.S.');
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'EMPAQUES CARDENAS S.A.S.');
insert into negocios_actividades (negocio_id, actividad_productiva_id) select (select id from negocios where nombre = 'EMPAQUES CARDENAS S.A.S.'), id from actividades_productivas where slug = 'aprovechamiento-residuos-inorganicos';
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'EMPAQUES CARDENAS S.A.S.'), 2023, 75.63 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'EMPAQUES CARDENAS S.A.S.'), 2024, 88.7 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'EMPAQUES CARDENAS S.A.S.'), 2025, 90.1 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;

-- INDUNILO S.A.S.
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'),
  municipio = 'Bucaramanga',
  vereda_id = (select id from veredas where municipio = 'Bucaramanga' and slug = 'perimetro-urbano'),
  direccion = 'CALLE 73 # 41 W - 250 LOTE 16 - 17 PARQUE INDUSTRIAL COMERCIAL PROVINCIA DE SOTO 2 BARRIO EL BUENO',
  latitud = 7.081666666666666,
  longitud = -73.14500000000001,
  descripcion_corta = 'Fabricacion o  produccion, adquisicion y venta de leche  en cualquiera de sus estados;  el  procesamiento y transformacion   de   la  leche    y  sus  …',
  descripcion = 'Fabricacion o  produccion, adquisicion y venta de leche  en cualquiera de sus estados;  el  procesamiento y transformacion   de   la  leche    y  sus   derivaciones y  su   correspondiente comercializacion.',
  producto = 'LECHE EN POLVO Y LIQUIDA',
  telefono = '3167590849',
  whatsapp = '573167590849',
  email = 'contabilidadgeneral@indunilo.com',
  representante_legal = 'JORGE EMIRO ARCINIEGAS',
  nit = '804009833-6',
  naturaleza_juridica = 'Jurídica',
  delegado = 'MAYRA ALVAREZ',
  rut_camara_comercio = 'Cámara de comercio',
  responsable_cdmb = 'XIMENA REYES',
  novedad = 'ACTIVO',
  tipo_negocio_verde = 'Dinamizadoras',
  anio_registro = 2023,
  cota_msnm = '762 msnm',
  este = '73°08''42"',
  norte = '7°04''54"',
  aplicacion_ficha_2025 = 'Actualizó',
  observaciones = null,
  registro_nacional_turismo = null,
  uso_suelo = 'Sí',
  concesion_aguas = 'Acueducto',
  concesion_aguas_vencimiento = null,
  vertimientos = null,
  vertimientos_vencimiento = null,
  pueaa = 'Sí',
  pgris = 'Sí',
  pozo_septico = null,
  alcantarillado = 'Sí',
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
  canal_venta = 'B2B',
  exportacion = 'No',
  huella_carbono = 'NO',
  fortalezas_ambiental = 'EMPRESA QUE COMRA A ASOCIACIONES DE CAMPESINOS, CERTIFICADA COMO NEGOCIO VERDE DE LA CDMB, USO DE ENERGIAS RENOVABLES, LA CUAL ABASTECE EL 60-70% DE LA ENERGIA CONSUMIDA EN LOS PROCESOS, APROVECHAMIENTO DEL 80% DE LOS RESIDUOS EVITANDO QUE LLEGUEN AL RELLENO SANITARIOS, SISTEMA DE GESTION AMBIENTAL',
  fortalezas_social = 'RECURSO HUMANO MOTIVADO Y CON SENTIDO DE PERTENENCIA,, EL EMPLEADOR CONSIDERA LAS CAPACIDADES Y COMPETENCIAS DEL TRABAJADOR, RECURSOS PARA FORMACION DE PERSONAS, APOYAN A ASOCIACIONES DE CAMPESINOS DE LA PROVINCIA GARCIA ROVIRA',
  fortalezas_economico = 'ALTA INVERSION EN LABORATORIOS QUE PERMITEN GARANTIZAR LA CALIDAD DESDE LA RECEPCION DE LA MATERIA PRIMA HASTA EL PRODUCTO TERMINADO, RECURSOS PARAFORMACION DE PERSONAL Y EMPRESA CON EXCELENTES UTILIDADES Y MUY BIEN ESTRUCTURADA',
  emprendimiento_verde = false,
  sello_marca = true,
  avalado = true,
  destacado = false,
  activo = true
where nombre = 'INDUNILO S.A.S.';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select 'af34fe1f-843e-4639-845f-a82910c951bf', 'INDUNILO S.A.S.', generar_slug_unico('INDUNILO S.A.S.', 'af34fe1f-843e-4639-845f-a82910c951bf'), (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'), 'Bucaramanga', (select id from veredas where municipio = 'Bucaramanga' and slug = 'perimetro-urbano'), 'CALLE 73 # 41 W - 250 LOTE 16 - 17 PARQUE INDUSTRIAL COMERCIAL PROVINCIA DE SOTO 2 BARRIO EL BUENO', 7.081666666666666, -73.14500000000001, 'Fabricacion o  produccion, adquisicion y venta de leche  en cualquiera de sus estados;  el  procesamiento y transformacion   de   la  leche    y  sus  …', 'Fabricacion o  produccion, adquisicion y venta de leche  en cualquiera de sus estados;  el  procesamiento y transformacion   de   la  leche    y  sus   derivaciones y  su   correspondiente comercializacion.', 'LECHE EN POLVO Y LIQUIDA', '3167590849', '573167590849', 'contabilidadgeneral@indunilo.com', 'JORGE EMIRO ARCINIEGAS', '804009833-6', 'Jurídica', 'MAYRA ALVAREZ', 'Cámara de comercio', 'XIMENA REYES', 'ACTIVO', 'Dinamizadoras', 2023, '762 msnm', '73°08''42"', '7°04''54"', 'Actualizó', null, null, 'Sí', 'Acueducto', null, null, null, 'Sí', 'Sí', null, 'Sí', null, null, 'Sí', null, null, null, null, null, null, null, 'Sí', 'B2B', 'No', 'NO', 'EMPRESA QUE COMRA A ASOCIACIONES DE CAMPESINOS, CERTIFICADA COMO NEGOCIO VERDE DE LA CDMB, USO DE ENERGIAS RENOVABLES, LA CUAL ABASTECE EL 60-70% DE LA ENERGIA CONSUMIDA EN LOS PROCESOS, APROVECHAMIENTO DEL 80% DE LOS RESIDUOS EVITANDO QUE LLEGUEN AL RELLENO SANITARIOS, SISTEMA DE GESTION AMBIENTAL', 'RECURSO HUMANO MOTIVADO Y CON SENTIDO DE PERTENENCIA,, EL EMPLEADOR CONSIDERA LAS CAPACIDADES Y COMPETENCIAS DEL TRABAJADOR, RECURSOS PARA FORMACION DE PERSONAS, APOYAN A ASOCIACIONES DE CAMPESINOS DE LA PROVINCIA GARCIA ROVIRA', 'ALTA INVERSION EN LABORATORIOS QUE PERMITEN GARANTIZAR LA CALIDAD DESDE LA RECEPCION DE LA MATERIA PRIMA HASTA EL PRODUCTO TERMINADO, RECURSOS PARAFORMACION DE PERSONAL Y EMPRESA CON EXCELENTES UTILIDADES Y MUY BIEN ESTRUCTURADA', false, true, true, false, true
where not exists (select 1 from negocios where nombre = 'INDUNILO S.A.S.');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'INDUNILO S.A.S.');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'INDUNILO S.A.S.'), (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'INDUNILO S.A.S.');
insert into negocios_subcategorias (negocio_id, subcategoria_id) select (select id from negocios where nombre = 'INDUNILO S.A.S.'), id from subcategorias where slug = 'agroindustria-sostenible';
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'INDUNILO S.A.S.');
insert into negocios_actividades (negocio_id, actividad_productiva_id) select (select id from negocios where nombre = 'INDUNILO S.A.S.'), id from actividades_productivas where slug = 'agroindustrial-alimentario';
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'INDUNILO S.A.S.'), 2023, 76.47 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'INDUNILO S.A.S.'), 2024, 81.2 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'INDUNILO S.A.S.'), 2025, 82.0 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;

-- SV INGENIERIA SAS
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'calidad-ambiental'),
  municipio = 'Piedecuesta',
  vereda_id = (select id from veredas where municipio = 'Piedecuesta' and slug = 'perimetro-urbano'),
  direccion = 'CALLE 7 # 7-12 IN 5 CC QUINTAS DE GUATIGUARA',
  latitud = 6.9875,
  longitud = -73.05055555555555,
  descripcion_corta = 'SV Ingeniería es una empresa de consultoría ambiental especializada en el diseño, elaboración y optimización de plantas de tratamiento de aguas residuales.…',
  descripcion = 'SV Ingeniería es una empresa de consultoría ambiental especializada en el diseño, elaboración y optimización de plantas de tratamiento de aguas residuales. Su labor se orienta al desarrollo de soluciones integrales que garantizan el cumplimiento de la normatividad ambiental vigente, la eficiencia en los procesos de depuración y la protección de los recursos hídricos. La empresa combina conocimiento técnico, innovación y compromiso ambiental para ofrecer proyectos sostenibles que contribuyen al mejoramiento de la calidad del agua y al desarrollo responsable de las actividades productivas.',
  producto = 'PLANTAS DE TRAMIENTO DE AGUAS',
  telefono = '3163309982',
  whatsapp = '573163309982',
  email = 'svingenierias@gmail.com',
  representante_legal = 'SERGIO FABIAN VIVIESCAS PEREZ',
  nit = '901075677-6',
  naturaleza_juridica = 'Jurídica',
  delegado = null,
  rut_camara_comercio = 'Cámara de comercio',
  responsable_cdmb = 'LILIANA CACERES',
  novedad = 'SUSPENDIDO',
  tipo_negocio_verde = 'Inicial',
  anio_registro = 2023,
  cota_msnm = '1009 msnm',
  este = '73°03''02"',
  norte = '6°59''15"',
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
  sstt = 'No',
  canal_venta = 'B2B',
  exportacion = null,
  huella_carbono = null,
  fortalezas_ambiental = 'Desarrolla soluciones sostenibles de tratamiento de aguas.',
  fortalezas_social = 'Aporta conocimiento técnico al desarrollo responsable.',
  fortalezas_economico = 'Servicios especializados con alta demanda.',
  emprendimiento_verde = true,
  sello_marca = false,
  avalado = false,
  destacado = false,
  activo = false
where nombre = 'SV INGENIERIA SAS';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select '37912348-d121-479f-8a09-ea8046fed9b5', 'SV INGENIERIA SAS', generar_slug_unico('SV INGENIERIA SAS', '37912348-d121-479f-8a09-ea8046fed9b5'), (select id from categorias_oficiales where slug = 'calidad-ambiental'), 'Piedecuesta', (select id from veredas where municipio = 'Piedecuesta' and slug = 'perimetro-urbano'), 'CALLE 7 # 7-12 IN 5 CC QUINTAS DE GUATIGUARA', 6.9875, -73.05055555555555, 'SV Ingeniería es una empresa de consultoría ambiental especializada en el diseño, elaboración y optimización de plantas de tratamiento de aguas residuales.…', 'SV Ingeniería es una empresa de consultoría ambiental especializada en el diseño, elaboración y optimización de plantas de tratamiento de aguas residuales. Su labor se orienta al desarrollo de soluciones integrales que garantizan el cumplimiento de la normatividad ambiental vigente, la eficiencia en los procesos de depuración y la protección de los recursos hídricos. La empresa combina conocimiento técnico, innovación y compromiso ambiental para ofrecer proyectos sostenibles que contribuyen al mejoramiento de la calidad del agua y al desarrollo responsable de las actividades productivas.', 'PLANTAS DE TRAMIENTO DE AGUAS', '3163309982', '573163309982', 'svingenierias@gmail.com', 'SERGIO FABIAN VIVIESCAS PEREZ', '901075677-6', 'Jurídica', null, 'Cámara de comercio', 'LILIANA CACERES', 'SUSPENDIDO', 'Inicial', 2023, '1009 msnm', '73°03''02"', '6°59''15"', 'Actualizó', 'Se realizo visita y se actualizo ficha de verificacion', null, 'Sí', 'Acueducto', null, null, null, 'No', 'No', null, 'Sí', null, null, null, null, null, null, null, null, null, null, 'No', 'B2B', null, null, 'Desarrolla soluciones sostenibles de tratamiento de aguas.', 'Aporta conocimiento técnico al desarrollo responsable.', 'Servicios especializados con alta demanda.', true, false, false, false, false
where not exists (select 1 from negocios where nombre = 'SV INGENIERIA SAS');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'SV INGENIERIA SAS');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'SV INGENIERIA SAS'), (select id from categorias_oficiales where slug = 'calidad-ambiental');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'SV INGENIERIA SAS');
insert into negocios_subcategorias (negocio_id, subcategoria_id) select (select id from negocios where nombre = 'SV INGENIERIA SAS'), id from subcategorias where slug = 'tecnologias-verdes';
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'SV INGENIERIA SAS');
insert into negocios_actividades (negocio_id, actividad_productiva_id) select (select id from negocios where nombre = 'SV INGENIERIA SAS'), id from actividades_productivas where slug = 'tecnologias-informacion-ambiental';
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'SV INGENIERIA SAS'), 2025, 0.0 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;

-- APICOLA SIEMPRE VIVA
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'),
  municipio = 'Lebrija',
  vereda_id = (select id from veredas where municipio = 'Lebrija' and slug = 'lisboa'),
  direccion = 'VÍA BARRANCABERMEJA KM 40.FINCA SIEMPRE VIVA',
  latitud = null,
  longitud = null,
  descripcion_corta = 'Producción pícola 139 colmenas en zona de conservación aprovechando el arte de extraer miel y polen de manera artesanal el cual son comercializados a…',
  descripcion = 'Producción pícola 139 colmenas en zona de conservación aprovechando el arte de extraer miel y polen de manera artesanal el cual son comercializados a turistas que transitan por la vía principal con la marca APÍCOLA SIEMPRE VIVA.',
  producto = 'MIEL Y POLÉN DE ABEJAS',
  telefono = '3134963281',
  whatsapp = '573134963281',
  email = 'lizcanosilvia44@gmail.com',
  representante_legal = 'SILVIA JULIANA LIZCANO CONTRERAS',
  nit = '1005345053-0',
  naturaleza_juridica = 'Natural',
  delegado = 'ISMALDO LIZCANO',
  rut_camara_comercio = 'Cámara de comercio',
  responsable_cdmb = 'ANA RUEDA',
  novedad = 'ACTIVO',
  tipo_negocio_verde = 'Dinamizadoras',
  anio_registro = 2023,
  cota_msnm = '782.7 msnm',
  este = '73°30706743',
  norte = '7°14847126',
  aplicacion_ficha_2025 = 'Actualizó',
  observaciones = 'Se realizo visita y se aplico ficha de verificacion',
  registro_nacional_turismo = null,
  uso_suelo = 'No',
  concesion_aguas = 'Acueducto veredal',
  concesion_aguas_vencimiento = null,
  vertimientos = 'No',
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
  buenas_practicas_apicolas = 'No',
  registro_apicola = 'No',
  intervencion_cauce = null,
  capacidad_carga = null,
  sstt = 'No',
  canal_venta = 'B2C',
  exportacion = 'No',
  huella_carbono = null,
  fortalezas_ambiental = 'SI, No se utilizan materiales peligrosos y/o tóxicos en los procesos.-Envase de vidrio.-Se desarrollan acciones como estrategias de restauración y reforestación con especies nativas',
  fortalezas_social = 'Sensibilización sobre el cuidado y peligro de exponer sin los elementos de protección ante  enjambres y charlas de consumo sostenible a turistas que pasan por la vía.-Genera empleo local',
  fortalezas_economico = 'Tiene claro algunos costos y gastos pero no la totalidad de operación del negocio.-Libro contable',
  emprendimiento_verde = false,
  sello_marca = false,
  avalado = true,
  destacado = false,
  activo = true
where nombre = 'APICOLA SIEMPRE VIVA';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select '44e94d4d-c06e-4d7b-aa86-7e9e89597dc6', 'APICOLA SIEMPRE VIVA', generar_slug_unico('APICOLA SIEMPRE VIVA', '44e94d4d-c06e-4d7b-aa86-7e9e89597dc6'), (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'), 'Lebrija', (select id from veredas where municipio = 'Lebrija' and slug = 'lisboa'), 'VÍA BARRANCABERMEJA KM 40.FINCA SIEMPRE VIVA', null, null, 'Producción pícola 139 colmenas en zona de conservación aprovechando el arte de extraer miel y polen de manera artesanal el cual son comercializados a…', 'Producción pícola 139 colmenas en zona de conservación aprovechando el arte de extraer miel y polen de manera artesanal el cual son comercializados a turistas que transitan por la vía principal con la marca APÍCOLA SIEMPRE VIVA.', 'MIEL Y POLÉN DE ABEJAS', '3134963281', '573134963281', 'lizcanosilvia44@gmail.com', 'SILVIA JULIANA LIZCANO CONTRERAS', '1005345053-0', 'Natural', 'ISMALDO LIZCANO', 'Cámara de comercio', 'ANA RUEDA', 'ACTIVO', 'Dinamizadoras', 2023, '782.7 msnm', '73°30706743', '7°14847126', 'Actualizó', 'Se realizo visita y se aplico ficha de verificacion', null, 'No', 'Acueducto veredal', null, 'No', null, 'No', 'No', 'Sí', null, null, null, 'No', null, null, null, 'No', 'No', null, null, 'No', 'B2C', 'No', null, 'SI, No se utilizan materiales peligrosos y/o tóxicos en los procesos.-Envase de vidrio.-Se desarrollan acciones como estrategias de restauración y reforestación con especies nativas', 'Sensibilización sobre el cuidado y peligro de exponer sin los elementos de protección ante  enjambres y charlas de consumo sostenible a turistas que pasan por la vía.-Genera empleo local', 'Tiene claro algunos costos y gastos pero no la totalidad de operación del negocio.-Libro contable', false, false, true, false, true
where not exists (select 1 from negocios where nombre = 'APICOLA SIEMPRE VIVA');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'APICOLA SIEMPRE VIVA');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'APICOLA SIEMPRE VIVA'), (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'APICOLA SIEMPRE VIVA');
insert into negocios_subcategorias (negocio_id, subcategoria_id) select (select id from negocios where nombre = 'APICOLA SIEMPRE VIVA'), id from subcategorias where slug = 'agrosistemas-sostenibles';
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'APICOLA SIEMPRE VIVA');
insert into negocios_actividades (negocio_id, actividad_productiva_id) select (select id from negocios where nombre = 'APICOLA SIEMPRE VIVA'), id from actividades_productivas where slug = 'agricultura-sostenible';
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'APICOLA SIEMPRE VIVA'), 2024, 57.1 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'APICOLA SIEMPRE VIVA'), 2025, 63.1 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;


commit;
