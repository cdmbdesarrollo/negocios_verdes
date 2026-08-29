begin;

-- Generado por lib/migraciones/generar_0026.py desde BASE_ACTUALIZADA_NV_ka.xlsx — no editar a mano.
-- Uno de varios archivos partidos (ver README.md) — correr TODOS, en cualquier orden, cada uno es su propia transacción.

-- Parte 6 de 17.

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

-- CULTIVANDO VIDA
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'),
  municipio = 'Bucaramanga',
  vereda_id = (select id from veredas where municipio = 'Bucaramanga' and slug = 'perimetro-urbano'),
  direccion = 'CARRERA 56 N° 54-52 APTO 201 BARRIO TERRAZAS',
  latitud = 7.111296666666666,
  longitud = -73.10551638888889,
  descripcion_corta = 'Es una empresa Santandereana que promueve la agricultura orgánica, cuyo principal objetivo es la conservación de los recursos naturales y el fortalecimiento…',
  descripcion = 'Es una empresa Santandereana que promueve la agricultura orgánica, cuyo principal objetivo es la conservación de los recursos naturales y el fortalecimiento de la seguridad alimentaria del país, actividad que busca su perfeccionamiento por medio de talleres, charlas y capacitaciones en temas de Producción Mas Limpia, manejo adecuado de residuos y aplicación de principios de agricultura ecológica y tradicional, resaltando los cultivos ancestrales, las semillas nativas y promoviendo el desarrollo de cultivos en espacios reducidos.',
  producto = 'ACTIVIDADES DE APOYO A LA EDUCACIÓN',
  telefono = '3204469762',
  whatsapp = '573204469762',
  email = 'huertasorganicascv@gmail.com',
  representante_legal = 'YULLY STELLA FORERO PEDRAZA',
  nit = '1097303230-2',
  naturaleza_juridica = 'Natural',
  delegado = null,
  rut_camara_comercio = 'Cámara de comercio',
  responsable_cdmb = 'SILVIA VALDIVIESO',
  novedad = 'ACTIVO',
  tipo_negocio_verde = 'Avanzado',
  anio_registro = 2019,
  cota_msnm = '956 msnm',
  este = '73°6''19.859''''',
  norte = '7°6''40.668''''',
  aplicacion_ficha_2025 = 'Actualizó',
  observaciones = 'Se realizo visita y se actualizo ficha de verificacion',
  registro_nacional_turismo = null,
  uso_suelo = null,
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
  fortalezas_ambiental = 'Educación ambiental',
  fortalezas_social = 'Educación ambiental por medio de vinculación a proyectos desde los territorios',
  fortalezas_economico = 'Buena oferta económica',
  emprendimiento_verde = false,
  sello_marca = false,
  avalado = true,
  destacado = false,
  activo = true
where nombre = 'CULTIVANDO VIDA';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select '6d76660b-5756-4c1f-ae47-d91fe9dec2ad', 'CULTIVANDO VIDA', generar_slug_unico('CULTIVANDO VIDA', '6d76660b-5756-4c1f-ae47-d91fe9dec2ad'), (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'), 'Bucaramanga', (select id from veredas where municipio = 'Bucaramanga' and slug = 'perimetro-urbano'), 'CARRERA 56 N° 54-52 APTO 201 BARRIO TERRAZAS', 7.111296666666666, -73.10551638888889, 'Es una empresa Santandereana que promueve la agricultura orgánica, cuyo principal objetivo es la conservación de los recursos naturales y el fortalecimiento…', 'Es una empresa Santandereana que promueve la agricultura orgánica, cuyo principal objetivo es la conservación de los recursos naturales y el fortalecimiento de la seguridad alimentaria del país, actividad que busca su perfeccionamiento por medio de talleres, charlas y capacitaciones en temas de Producción Mas Limpia, manejo adecuado de residuos y aplicación de principios de agricultura ecológica y tradicional, resaltando los cultivos ancestrales, las semillas nativas y promoviendo el desarrollo de cultivos en espacios reducidos.', 'ACTIVIDADES DE APOYO A LA EDUCACIÓN', '3204469762', '573204469762', 'huertasorganicascv@gmail.com', 'YULLY STELLA FORERO PEDRAZA', '1097303230-2', 'Natural', null, 'Cámara de comercio', 'SILVIA VALDIVIESO', 'ACTIVO', 'Avanzado', 2019, '956 msnm', '73°6''19.859''''', '7°6''40.668''''', 'Actualizó', 'Se realizo visita y se actualizo ficha de verificacion', null, null, 'Acueducto', null, null, null, 'Sí', 'Sí', null, 'Sí', null, null, null, null, null, null, null, null, null, null, 'No', 'Mixta', 'No', 'NO', 'Educación ambiental', 'Educación ambiental por medio de vinculación a proyectos desde los territorios', 'Buena oferta económica', false, false, true, false, true
where not exists (select 1 from negocios where nombre = 'CULTIVANDO VIDA');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'CULTIVANDO VIDA');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'CULTIVANDO VIDA'), (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'CULTIVANDO VIDA');
insert into negocios_subcategorias (negocio_id, subcategoria_id) select (select id from negocios where nombre = 'CULTIVANDO VIDA'), id from subcategorias where slug = 'agroindustria-sostenible';
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'CULTIVANDO VIDA');
insert into negocios_actividades (negocio_id, actividad_productiva_id) select (select id from negocios where nombre = 'CULTIVANDO VIDA'), id from actividades_productivas where slug = 'agroindustrial-no-alimentario';
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'CULTIVANDO VIDA'), 2020, 54.39 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'CULTIVANDO VIDA'), 2021, 57.48 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'CULTIVANDO VIDA'), 2022, 57.36 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'CULTIVANDO VIDA'), 2023, 59.31 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'CULTIVANDO VIDA'), 2024, 76.5 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'CULTIVANDO VIDA'), 2025, 72.6 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;

-- TRADE CENTRAL
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'ecoproductos-industriales'),
  municipio = 'El Playón',
  vereda_id = (select id from veredas where municipio = 'El Playón' and slug = 'perimetro-urbano'),
  direccion = 'CALLE 4 Nº 6 - 71 BARRRIIO LOS NARANJOS, EL PLAYÓN, SANTANDER',
  latitud = 7.466752777777778,
  longitud = -73.20129722222222,
  descripcion_corta = 'Genera impactos ambientales positivos a través del proceso de economía circular que desarrolla en el municipio del Playón. Actualmente recoge al mes…',
  descripcion = 'Genera impactos ambientales positivos a través del proceso de economía circular que desarrolla en el municipio del Playón. Actualmente recoge al mes alrededor de 170 toneladas de residuos de las cuales el 72% se destina a la producción de una enmienda orgánica, el 6% a procesos de reciclaje y el 22% va a relleno sanitario como disposición final. En este sentido, la empresa contribuye a reducir los niveles de contaminación, mitigar el cambio climático, promueve la educación ambiental en los usuarios del municipio, y a su vez, aporta en la reducción de la presión sobre los recursos naturales.',
  producto = 'ENMIENDA ORGANICA',
  telefono = '3235738738',
  whatsapp = '573235738738',
  email = 'tradecentral.elplayon@gmail.com',
  representante_legal = 'ROSA VALERIA GRANADOS APONTE',
  nit = '901096355-1',
  naturaleza_juridica = 'Jurídica',
  delegado = null,
  rut_camara_comercio = 'Cámara de comercio y RUT',
  responsable_cdmb = 'CLAUDIA SANCHEZ',
  novedad = 'SUSPENDIDO',
  tipo_negocio_verde = 'Satisfactorio',
  anio_registro = 2021,
  cota_msnm = '457 msnm',
  este = '73°12''4,67''''',
  norte = '7°28''0,31''''',
  aplicacion_ficha_2025 = 'Actualizó',
  observaciones = 'Se realizo visita y se actualizo ficha de verificacion',
  registro_nacional_turismo = null,
  uso_suelo = 'Sí',
  concesion_aguas = null,
  concesion_aguas_vencimiento = null,
  vertimientos = null,
  vertimientos_vencimiento = null,
  pueaa = null,
  pgris = 'Sí',
  pozo_septico = 'No',
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
  sstt = 'Sí',
  canal_venta = 'B2C',
  exportacion = null,
  huella_carbono = null,
  fortalezas_ambiental = 'Reutilizacion de empaques de un solo uso, y aproveechamiento de residuos organicos del municipio',
  fortalezas_social = 'Tienen contratado un profesional en SSST, encargada de la implementacion y cumplimiento del SSST',
  fortalezas_economico = 'Registran Estados Financieros y la contadora utiliza un sistema contable (Word Office). Los Estados Financieros reflejan otros servicios que presta la empresa.',
  emprendimiento_verde = true,
  sello_marca = false,
  avalado = false,
  destacado = false,
  activo = false
where nombre = 'TRADE CENTRAL';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select '6b17086a-d760-4008-bec2-67ef7bdf9200', 'TRADE CENTRAL', generar_slug_unico('TRADE CENTRAL', '6b17086a-d760-4008-bec2-67ef7bdf9200'), (select id from categorias_oficiales where slug = 'ecoproductos-industriales'), 'El Playón', (select id from veredas where municipio = 'El Playón' and slug = 'perimetro-urbano'), 'CALLE 4 Nº 6 - 71 BARRRIIO LOS NARANJOS, EL PLAYÓN, SANTANDER', 7.466752777777778, -73.20129722222222, 'Genera impactos ambientales positivos a través del proceso de economía circular que desarrolla en el municipio del Playón. Actualmente recoge al mes…', 'Genera impactos ambientales positivos a través del proceso de economía circular que desarrolla en el municipio del Playón. Actualmente recoge al mes alrededor de 170 toneladas de residuos de las cuales el 72% se destina a la producción de una enmienda orgánica, el 6% a procesos de reciclaje y el 22% va a relleno sanitario como disposición final. En este sentido, la empresa contribuye a reducir los niveles de contaminación, mitigar el cambio climático, promueve la educación ambiental en los usuarios del municipio, y a su vez, aporta en la reducción de la presión sobre los recursos naturales.', 'ENMIENDA ORGANICA', '3235738738', '573235738738', 'tradecentral.elplayon@gmail.com', 'ROSA VALERIA GRANADOS APONTE', '901096355-1', 'Jurídica', null, 'Cámara de comercio y RUT', 'CLAUDIA SANCHEZ', 'SUSPENDIDO', 'Satisfactorio', 2021, '457 msnm', '73°12''4,67''''', '7°28''0,31''''', 'Actualizó', 'Se realizo visita y se actualizo ficha de verificacion', null, 'Sí', null, null, null, null, null, 'Sí', 'No', 'Sí', 'No', null, null, null, null, null, null, null, null, null, 'Sí', 'B2C', null, null, 'Reutilizacion de empaques de un solo uso, y aproveechamiento de residuos organicos del municipio', 'Tienen contratado un profesional en SSST, encargada de la implementacion y cumplimiento del SSST', 'Registran Estados Financieros y la contadora utiliza un sistema contable (Word Office). Los Estados Financieros reflejan otros servicios que presta la empresa.', true, false, false, false, false
where not exists (select 1 from negocios where nombre = 'TRADE CENTRAL');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'TRADE CENTRAL');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'TRADE CENTRAL'), (select id from categorias_oficiales where slug = 'ecoproductos-industriales');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'TRADE CENTRAL');
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'TRADE CENTRAL');
insert into negocios_actividades (negocio_id, actividad_productiva_id) select (select id from negocios where nombre = 'TRADE CENTRAL'), id from actividades_productivas where slug = 'aprovechamiento-residuos-organicos';
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'TRADE CENTRAL'), 2021, 53.68 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'TRADE CENTRAL'), 2022, 56.33 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'TRADE CENTRAL'), 2023, 57.62 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'TRADE CENTRAL'), 2025, 55.3 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;

-- SOCIEDAD SUPELANO PRADA S.A.S.
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'),
  municipio = 'Bucaramanga',
  vereda_id = (select id from veredas where municipio = 'Bucaramanga' and slug = 'perimetro-urbano'),
  direccion = 'CALLE 8 # 19-65 BARRIO COMUNEROS',
  latitud = 7.138348888888889,
  longitud = -73.12746277777777,
  descripcion_corta = 'Empresa en actividad  hace 20 años con experiencia en producción  de micorrizas que funcionan como biofertilizantes del suelo para toda clase de cultivo de…',
  descripcion = 'Empresa en actividad  hace 20 años con experiencia en producción  de micorrizas que funcionan como biofertilizantes del suelo para toda clase de cultivo de producción',
  producto = 'BIOFERTILIZANTES MICORRIZAS',
  telefono = '3187912019',
  whatsapp = '573187912019',
  email = 'ventas@suppracolombia.com',
  representante_legal = 'SOLANGEL PRADA TORRES',
  nit = '900099172-9',
  naturaleza_juridica = 'Jurídica',
  delegado = 'ANDREA SUPELANO PRADA',
  rut_camara_comercio = 'Cámara de comercio',
  responsable_cdmb = 'SEBASTIAN BONNET',
  novedad = 'ACTIVO',
  tipo_negocio_verde = 'Dinamizadoras',
  anio_registro = 2018,
  cota_msnm = '962.8 msnm',
  este = '73°7''38.866"',
  norte = '7°8''18.056"',
  aplicacion_ficha_2025 = 'Actualizó',
  observaciones = 'Se realizo visita y se aplico ficha de verificacion',
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
  exportacion = 'Sí',
  huella_carbono = 'NO',
  fortalezas_ambiental = 'PRODUCCION  DE MICORRIZAS QUE FUNCIONAN COMO BIOFERTILIZANTES DEL SUELO PARA TODA CLASE DE CULTIVO DE PRODUCCIÓN ALIMENTARIA. EMPRESA DE BIOTECNOLOGIA QUE CUENTA CON SU PROPIO BANCO DE GERMOPLASMA DE CEPAS NATIVAS',
  fortalezas_social = 'La forma de contratar su personal con un enfoque diferencial , con equidad de genero además tiene su propio Banco de Germoplasma de Micorrizas.',
  fortalezas_economico = 'La empresa cuenta con un componente económico estable – requiere de mayor acompañamiento para incrementar cada día mas sus ingresos',
  emprendimiento_verde = false,
  sello_marca = true,
  avalado = true,
  destacado = false,
  activo = true
where nombre = 'SOCIEDAD SUPELANO PRADA S.A.S.';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select 'c853b283-c621-4b0c-a017-3854b540d689', 'SOCIEDAD SUPELANO PRADA S.A.S.', generar_slug_unico('SOCIEDAD SUPELANO PRADA S.A.S.', 'c853b283-c621-4b0c-a017-3854b540d689'), (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'), 'Bucaramanga', (select id from veredas where municipio = 'Bucaramanga' and slug = 'perimetro-urbano'), 'CALLE 8 # 19-65 BARRIO COMUNEROS', 7.138348888888889, -73.12746277777777, 'Empresa en actividad  hace 20 años con experiencia en producción  de micorrizas que funcionan como biofertilizantes del suelo para toda clase de cultivo de…', 'Empresa en actividad  hace 20 años con experiencia en producción  de micorrizas que funcionan como biofertilizantes del suelo para toda clase de cultivo de producción', 'BIOFERTILIZANTES MICORRIZAS', '3187912019', '573187912019', 'ventas@suppracolombia.com', 'SOLANGEL PRADA TORRES', '900099172-9', 'Jurídica', 'ANDREA SUPELANO PRADA', 'Cámara de comercio', 'SEBASTIAN BONNET', 'ACTIVO', 'Dinamizadoras', 2018, '962.8 msnm', '73°7''38.866"', '7°8''18.056"', 'Actualizó', 'Se realizo visita y se aplico ficha de verificacion', null, 'Sí', 'Acueducto', null, null, null, 'Sí', 'Sí', null, 'Sí', 'Sí', null, null, null, null, null, null, null, null, null, 'Sí', 'Mixta', 'Sí', 'NO', 'PRODUCCION  DE MICORRIZAS QUE FUNCIONAN COMO BIOFERTILIZANTES DEL SUELO PARA TODA CLASE DE CULTIVO DE PRODUCCIÓN ALIMENTARIA. EMPRESA DE BIOTECNOLOGIA QUE CUENTA CON SU PROPIO BANCO DE GERMOPLASMA DE CEPAS NATIVAS', 'La forma de contratar su personal con un enfoque diferencial , con equidad de genero además tiene su propio Banco de Germoplasma de Micorrizas.', 'La empresa cuenta con un componente económico estable – requiere de mayor acompañamiento para incrementar cada día mas sus ingresos', false, true, true, false, true
where not exists (select 1 from negocios where nombre = 'SOCIEDAD SUPELANO PRADA S.A.S.');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'SOCIEDAD SUPELANO PRADA S.A.S.');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'SOCIEDAD SUPELANO PRADA S.A.S.'), (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'SOCIEDAD SUPELANO PRADA S.A.S.');
insert into negocios_subcategorias (negocio_id, subcategoria_id) select (select id from negocios where nombre = 'SOCIEDAD SUPELANO PRADA S.A.S.'), id from subcategorias where slug = 'biotecnologia';
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'SOCIEDAD SUPELANO PRADA S.A.S.');
insert into negocios_actividades (negocio_id, actividad_productiva_id) select (select id from negocios where nombre = 'SOCIEDAD SUPELANO PRADA S.A.S.'), id from actividades_productivas where slug = 'productos-biotecnologia';
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'SOCIEDAD SUPELANO PRADA S.A.S.'), 2020, 51.1 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'SOCIEDAD SUPELANO PRADA S.A.S.'), 2021, 75.26 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'SOCIEDAD SUPELANO PRADA S.A.S.'), 2022, 62.84 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'SOCIEDAD SUPELANO PRADA S.A.S.'), 2023, 74.79 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'SOCIEDAD SUPELANO PRADA S.A.S.'), 2024, 87.4 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'SOCIEDAD SUPELANO PRADA S.A.S.'), 2025, 85.9 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;

-- ASOMOREROS
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'pendiente-clasificar'),
  municipio = 'Piedecuesta',
  vereda_id = null,
  direccion = 'Avenida 5 N # 19-24 Interior 75 Altos Planadas',
  latitud = null,
  longitud = null,
  descripcion_corta = null,
  descripcion = null,
  producto = 'ABONOS ORGÁNICOS PARA JARDINERIA',
  telefono = '6550659',
  whatsapp = '6550659',
  email = null,
  representante_legal = null,
  nit = '804014961',
  naturaleza_juridica = null,
  delegado = null,
  rut_camara_comercio = null,
  responsable_cdmb = null,
  novedad = 'RETIRADO',
  tipo_negocio_verde = null,
  anio_registro = 2016,
  cota_msnm = null,
  este = null,
  norte = null,
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
  fortalezas_ambiental = null,
  fortalezas_social = null,
  fortalezas_economico = null,
  emprendimiento_verde = true,
  sello_marca = false,
  avalado = false,
  destacado = false,
  activo = false
where nombre = 'ASOMOREROS';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select '2b76f3dc-5009-4d87-ac5d-61e0371b980d', 'ASOMOREROS', generar_slug_unico('ASOMOREROS', '2b76f3dc-5009-4d87-ac5d-61e0371b980d'), (select id from categorias_oficiales where slug = 'pendiente-clasificar'), 'Piedecuesta', null, 'Avenida 5 N # 19-24 Interior 75 Altos Planadas', null, null, null, null, 'ABONOS ORGÁNICOS PARA JARDINERIA', '6550659', '6550659', null, null, '804014961', null, null, null, null, 'RETIRADO', null, 2016, null, null, null, null, 'Retirado', null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, true, false, false, false, false
where not exists (select 1 from negocios where nombre = 'ASOMOREROS');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'ASOMOREROS');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'ASOMOREROS'), (select id from categorias_oficiales where slug = 'pendiente-clasificar');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'ASOMOREROS');
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'ASOMOREROS');

-- ASOCIACION FRUTAL DELICIAS
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'),
  municipio = 'Charta',
  vereda_id = (select id from veredas where municipio = 'Charta' and slug = 'centro-trincheras-parte-baja'),
  direccion = 'FINCA EL NARANJITO -SECTOR EL TAVOR',
  latitud = null,
  longitud = null,
  descripcion_corta = 'Cultivos de mora orgánica donde se elaboran  vinos de mora, naranja y dulces de mora. Además realizan sus propios empaques ecológicos con fibras de las…',
  descripcion = 'Cultivos de mora orgánica donde se elaboran  vinos de mora, naranja y dulces de mora. Además realizan sus propios empaques ecológicos con fibras de las hojas de plátano de manera artesanal.',
  producto = 'VINO DE MORA,  ARANJA Y DULCE DE MORA',
  telefono = '3143711623-3134077267',
  whatsapp = '3143711623-3134077267',
  email = 'frudeli79@gmail.com / asociacionfrutaldelicias@hotmail.com',
  representante_legal = 'OLGA GELVEZ HERNANDEZ',
  nit = '900810699-8',
  naturaleza_juridica = 'Jurídica',
  delegado = null,
  rut_camara_comercio = 'Cámara de comercio y RUT',
  responsable_cdmb = 'LILIANA CACERES',
  novedad = 'RETIRADO',
  tipo_negocio_verde = 'Dinamizadoras',
  anio_registro = 2018,
  cota_msnm = '2025.4 msnm',
  este = '72°96658121''''',
  norte = '7°27938377''''',
  aplicacion_ficha_2025 = 'Actualizó',
  observaciones = 'Se realizo visita y se aplico ficha de verificacion',
  registro_nacional_turismo = null,
  uso_suelo = 'No',
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
- En los ecomercados campesinos se realizan campañas de consumo sostenible. 
-Envase de vidrio y caja de presentación biodegradable a partir de la corteza deshidratada  del plátano. 
-No se utilizan materiales peligrosos y/o tóxicos en los procesos.',
  fortalezas_social = 'Generación de empleos informales - Mujeres campesinas de la zona.',
  fortalezas_economico = 'Libro contable',
  emprendimiento_verde = true,
  sello_marca = false,
  avalado = false,
  destacado = false,
  activo = false
where nombre = 'ASOCIACION FRUTAL DELICIAS';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select 'd6a0fa0c-c80f-49f4-853e-04579eca969b', 'ASOCIACION FRUTAL DELICIAS', generar_slug_unico('ASOCIACION FRUTAL DELICIAS', 'd6a0fa0c-c80f-49f4-853e-04579eca969b'), (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'), 'Charta', (select id from veredas where municipio = 'Charta' and slug = 'centro-trincheras-parte-baja'), 'FINCA EL NARANJITO -SECTOR EL TAVOR', null, null, 'Cultivos de mora orgánica donde se elaboran  vinos de mora, naranja y dulces de mora. Además realizan sus propios empaques ecológicos con fibras de las…', 'Cultivos de mora orgánica donde se elaboran  vinos de mora, naranja y dulces de mora. Además realizan sus propios empaques ecológicos con fibras de las hojas de plátano de manera artesanal.', 'VINO DE MORA,  ARANJA Y DULCE DE MORA', '3143711623-3134077267', '3143711623-3134077267', 'frudeli79@gmail.com / asociacionfrutaldelicias@hotmail.com', 'OLGA GELVEZ HERNANDEZ', '900810699-8', 'Jurídica', null, 'Cámara de comercio y RUT', 'LILIANA CACERES', 'RETIRADO', 'Dinamizadoras', 2018, '2025.4 msnm', '72°96658121''''', '7°27938377''''', 'Actualizó', 'Se realizo visita y se aplico ficha de verificacion', null, 'No', null, null, null, null, 'No', 'No', 'Sí', null, null, null, 'No', null, null, null, null, null, null, null, 'No', 'B2C', null, null, 'SI, Sistemas agroforestales o silvopastoriles, estrategias de restauración y reforestación con especies nativas o endémicas, cercas vivas, rescate de plántulas, fertilización orgánica, entre otros.
- En los ecomercados campesinos se realizan campañas de consumo sostenible. 
-Envase de vidrio y caja de presentación biodegradable a partir de la corteza deshidratada  del plátano. 
-No se utilizan materiales peligrosos y/o tóxicos en los procesos.', 'Generación de empleos informales - Mujeres campesinas de la zona.', 'Libro contable', true, false, false, false, false
where not exists (select 1 from negocios where nombre = 'ASOCIACION FRUTAL DELICIAS');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'ASOCIACION FRUTAL DELICIAS');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'ASOCIACION FRUTAL DELICIAS'), (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'ASOCIACION FRUTAL DELICIAS');
insert into negocios_subcategorias (negocio_id, subcategoria_id) select (select id from negocios where nombre = 'ASOCIACION FRUTAL DELICIAS'), id from subcategorias where slug = 'agroindustria-sostenible';
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'ASOCIACION FRUTAL DELICIAS');
insert into negocios_actividades (negocio_id, actividad_productiva_id) select (select id from negocios where nombre = 'ASOCIACION FRUTAL DELICIAS'), id from actividades_productivas where slug = 'agroindustrial-alimentario';
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'ASOCIACION FRUTAL DELICIAS'), 2020, 31.45 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'ASOCIACION FRUTAL DELICIAS'), 2021, 49.49 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'ASOCIACION FRUTAL DELICIAS'), 2024, 58.2 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'ASOCIACION FRUTAL DELICIAS'), 2025, 57.4 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;

-- AROMAS COLOMBIANAS S.A.S.
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'),
  municipio = 'Bucaramanga',
  vereda_id = (select id from veredas where municipio = 'Bucaramanga' and slug = 'perimetro-urbano'),
  direccion = 'CALLE 105 NO. 12-125 MALPASO',
  latitud = null,
  longitud = -73.12338944444444,
  descripcion_corta = 'Cultivo de plantas aromaticas y medicinales, transformación  y comercialización de productos botánicos medicinales  y productos botanicos de uso farmaceutico',
  descripcion = 'Cultivo de plantas aromaticas y medicinales, transformación  y comercialización de productos botánicos medicinales  y productos botanicos de uso farmaceutico',
  producto = 'ACEITES ESENCIALES',
  telefono = '3104806505 - 3227382714',
  whatsapp = '3104806505 - 3227382714',
  email = 'aromascolombianas@yahoo.com',
  representante_legal = 'EMILCEN SIERRA ALFONSO',
  nit = '901831654-0',
  naturaleza_juridica = 'Jurídica',
  delegado = 'JUAN DAVID MESA',
  rut_camara_comercio = 'Cámara de comercio',
  responsable_cdmb = 'CARINE GARCIA',
  novedad = 'ACTIVO',
  tipo_negocio_verde = 'Dinamizadoras',
  anio_registro = 2019,
  cota_msnm = '1.968 msnm',
  este = '73°7''24.202',
  norte = '7°54.026''''',
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
  buenas_practicas_agricolas = 'No',
  buenas_practicas_apicolas = null,
  registro_apicola = null,
  intervencion_cauce = null,
  capacidad_carga = null,
  sstt = 'Sí',
  canal_venta = 'Mixta',
  exportacion = 'No',
  huella_carbono = 'NO',
  fortalezas_ambiental = 'ELABORACION DE ACEITES ESENCIALES  A BASE DE AROMATICAS DE ORIGEN ORGANICOS SIN QUIMICOS Y artesanales, Uso exclusivo de materias primas naturales y orgánicas, sin químicos ni pesticidas.  Procesos artesanales que minimizan la contaminación del agua y del suelo. Contribuye a la conservación de la biodiversidad al fomentar cultivos sostenibles.
 Reducción de la huella de carbono frente a productos industriales o importados.
 Aprovechamiento responsable de los residuos vegetales (compostaje o reutilización).',
  fortalezas_social = 'Preservación de saberes tradicionales en el uso de plantas medicinales y aromáticas.
  Promueve estilos de vida saludables y el bienestar en los consumidores.
 Fortalece el tejido social mediante la producción colaborativa y el comercio justo.
Preservación de saberes tradicionales en el uso de plantas medicinales y aromáticas.
Promueve estilos de vida saludables y el bienestar en los consumidores.
 • Fortalece el tejido social mediante la producción colaborativa y el comercio justo.',
  fortalezas_economico = 'Producto con alto valor agregado y diferenciación en el mercado.
 Alta demanda en sectores de cosmética natural, aromaterapia y bienestar.
  Materias primas locales que reducen costos logísticos.
 • Posibilidad de diversificar líneas (jabones, cremas, velas, difusores, etc.).',
  emprendimiento_verde = false,
  sello_marca = true,
  avalado = true,
  destacado = false,
  activo = true
where nombre = 'AROMAS COLOMBIANAS S.A.S.';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select '9768a767-9f3f-447e-8f8e-c24b973b952d', 'AROMAS COLOMBIANAS S.A.S.', generar_slug_unico('AROMAS COLOMBIANAS S.A.S.', '9768a767-9f3f-447e-8f8e-c24b973b952d'), (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'), 'Bucaramanga', (select id from veredas where municipio = 'Bucaramanga' and slug = 'perimetro-urbano'), 'CALLE 105 NO. 12-125 MALPASO', null, -73.12338944444444, 'Cultivo de plantas aromaticas y medicinales, transformación  y comercialización de productos botánicos medicinales  y productos botanicos de uso farmaceutico', 'Cultivo de plantas aromaticas y medicinales, transformación  y comercialización de productos botánicos medicinales  y productos botanicos de uso farmaceutico', 'ACEITES ESENCIALES', '3104806505 - 3227382714', '3104806505 - 3227382714', 'aromascolombianas@yahoo.com', 'EMILCEN SIERRA ALFONSO', '901831654-0', 'Jurídica', 'JUAN DAVID MESA', 'Cámara de comercio', 'CARINE GARCIA', 'ACTIVO', 'Dinamizadoras', 2019, '1.968 msnm', '73°7''24.202', '7°54.026''''', 'Actualizó', null, null, 'Sí', 'Acueducto', null, null, null, 'No', 'No', null, 'Sí', null, null, 'No', null, null, 'No', null, null, null, null, 'Sí', 'Mixta', 'No', 'NO', 'ELABORACION DE ACEITES ESENCIALES  A BASE DE AROMATICAS DE ORIGEN ORGANICOS SIN QUIMICOS Y artesanales, Uso exclusivo de materias primas naturales y orgánicas, sin químicos ni pesticidas.  Procesos artesanales que minimizan la contaminación del agua y del suelo. Contribuye a la conservación de la biodiversidad al fomentar cultivos sostenibles.
 Reducción de la huella de carbono frente a productos industriales o importados.
 Aprovechamiento responsable de los residuos vegetales (compostaje o reutilización).', 'Preservación de saberes tradicionales en el uso de plantas medicinales y aromáticas.
  Promueve estilos de vida saludables y el bienestar en los consumidores.
 Fortalece el tejido social mediante la producción colaborativa y el comercio justo.
Preservación de saberes tradicionales en el uso de plantas medicinales y aromáticas.
Promueve estilos de vida saludables y el bienestar en los consumidores.
 • Fortalece el tejido social mediante la producción colaborativa y el comercio justo.', 'Producto con alto valor agregado y diferenciación en el mercado.
 Alta demanda en sectores de cosmética natural, aromaterapia y bienestar.
  Materias primas locales que reducen costos logísticos.
 • Posibilidad de diversificar líneas (jabones, cremas, velas, difusores, etc.).', false, true, true, false, true
where not exists (select 1 from negocios where nombre = 'AROMAS COLOMBIANAS S.A.S.');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'AROMAS COLOMBIANAS S.A.S.');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'AROMAS COLOMBIANAS S.A.S.'), (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'AROMAS COLOMBIANAS S.A.S.');
insert into negocios_subcategorias (negocio_id, subcategoria_id) select (select id from negocios where nombre = 'AROMAS COLOMBIANAS S.A.S.'), id from subcategorias where slug = 'agroindustria-sostenible';
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'AROMAS COLOMBIANAS S.A.S.');
insert into negocios_actividades (negocio_id, actividad_productiva_id) select (select id from negocios where nombre = 'AROMAS COLOMBIANAS S.A.S.'), id from actividades_productivas where slug = 'agroindustrial-no-alimentario';
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'AROMAS COLOMBIANAS S.A.S.'), 2020, 38.59 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'AROMAS COLOMBIANAS S.A.S.'), 2021, 38.59 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'AROMAS COLOMBIANAS S.A.S.'), 2022, 49.93 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'AROMAS COLOMBIANAS S.A.S.'), 2023, 57.87 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'AROMAS COLOMBIANAS S.A.S.'), 2024, 64.6 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'AROMAS COLOMBIANAS S.A.S.'), 2025, 71.0 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;

-- MANJARES VETANOS
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'pendiente-clasificar'),
  municipio = 'Vetas',
  vereda_id = null,
  direccion = 'Cra 3 # 2-39 Barrio Santisima Trinidad',
  latitud = null,
  longitud = null,
  descripcion_corta = null,
  descripcion = null,
  producto = 'CHOCOLATE EN BOLA',
  telefono = '311 2265113',
  whatsapp = '311 2265113',
  email = 'manjaresvetanos@hotmail.com',
  representante_legal = 'GABRIEL GAMBOA',
  nit = '5605284-0',
  naturaleza_juridica = null,
  delegado = null,
  rut_camara_comercio = null,
  responsable_cdmb = 'JUAN JOSE',
  novedad = 'INACTIVO',
  tipo_negocio_verde = 'Intermedio',
  anio_registro = 2021,
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
  fortalezas_social = '-Acciones de educación ambiental como talleres de huertas con las asociadas y jóvenes de las familias.',
  fortalezas_economico = null,
  emprendimiento_verde = true,
  sello_marca = false,
  avalado = false,
  destacado = false,
  activo = false
where nombre = 'MANJARES VETANOS';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select 'a5887c72-89a7-445e-b66c-8846b8311c54', 'MANJARES VETANOS', generar_slug_unico('MANJARES VETANOS', 'a5887c72-89a7-445e-b66c-8846b8311c54'), (select id from categorias_oficiales where slug = 'pendiente-clasificar'), 'Vetas', null, 'Cra 3 # 2-39 Barrio Santisima Trinidad', null, null, null, null, 'CHOCOLATE EN BOLA', '311 2265113', '311 2265113', 'manjaresvetanos@hotmail.com', 'GABRIEL GAMBOA', '5605284-0', null, null, null, 'JUAN JOSE', 'INACTIVO', 'Intermedio', 2021, null, null, null, null, 'Posible retiro', null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, '-Acciones de educación ambiental como talleres de huertas con las asociadas y jóvenes de las familias.', null, true, false, false, false, false
where not exists (select 1 from negocios where nombre = 'MANJARES VETANOS');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'MANJARES VETANOS');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'MANJARES VETANOS'), (select id from categorias_oficiales where slug = 'pendiente-clasificar');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'MANJARES VETANOS');
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'MANJARES VETANOS');
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'MANJARES VETANOS'), 2021, 38.79 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;

-- APICOLA EL CARBONAL
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'),
  municipio = 'Vetas',
  vereda_id = (select id from veredas where municipio = 'Vetas' and slug = 'mongora'),
  direccion = 'FINCA EL LLANO EL CARBONAL - VEREDA MONGORA',
  latitud = 7.3358066,
  longitud = -72.921023,
  descripcion_corta = 'Produccion de miel y cera de abejas , 16 colmenas dsitribuidos en area de bosque y produccion de bebidas alcoholicas no destiladas',
  descripcion = 'Produccion de miel y cera de abejas , 16 colmenas dsitribuidos en area de bosque y produccion de bebidas alcoholicas no destiladas',
  producto = 'MIEL Y CERA DE ABEJA',
  telefono = '3142172243',
  whatsapp = '573142172243',
  email = 'rafaelariasgarcia03@gmail.com',
  representante_legal = 'RAFAEL ARIAS GARCIA',
  nit = '5605103-6',
  naturaleza_juridica = 'Natural',
  delegado = null,
  rut_camara_comercio = 'Cámara de comercio',
  responsable_cdmb = 'ANA RUEDA',
  novedad = 'ACTIVO',
  tipo_negocio_verde = 'Intermedio',
  anio_registro = 2021,
  cota_msnm = '2.255 msnm',
  este = '72.921023',
  norte = '7.3358066',
  aplicacion_ficha_2025 = 'Actualizó',
  observaciones = 'Se realizo visita y se actualizo ficha de verificacion',
  registro_nacional_turismo = null,
  uso_suelo = 'Sí',
  concesion_aguas = 'Sí',
  concesion_aguas_vencimiento = '2033-05-04',
  vertimientos = null,
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
  buenas_practicas_apicolas = 'No',
  registro_apicola = 'No',
  intervencion_cauce = null,
  capacidad_carga = null,
  sstt = 'No',
  canal_venta = 'B2C',
  exportacion = 'No',
  huella_carbono = null,
  fortalezas_ambiental = 'Conservacion y aprovechamiento  del fruto silvestre arrayan de manera artesanal, conservacion del ecosistema  , produccion sostenible de la miel polinizacion de plantas y cultivos que contribuye a la seguridad alimentaria y al equilibrio de ecosistema, preservan la biodiversidad.',
  fortalezas_social = 'Beneficio a familias de la region como adultos mayores , fortalecimineto de empresas de mujeres campesinas',
  fortalezas_economico = 'Tienen definidos sus costso y gastos , buena participacion en ferias y eventos , generan buena produccion de miel intencion de ampliar las colmenas y generar mas ingress',
  emprendimiento_verde = true,
  sello_marca = false,
  avalado = false,
  destacado = false,
  activo = true
where nombre = 'APICOLA EL CARBONAL';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select '7d91a1e3-43c8-447d-a894-18cba2842307', 'APICOLA EL CARBONAL', generar_slug_unico('APICOLA EL CARBONAL', '7d91a1e3-43c8-447d-a894-18cba2842307'), (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'), 'Vetas', (select id from veredas where municipio = 'Vetas' and slug = 'mongora'), 'FINCA EL LLANO EL CARBONAL - VEREDA MONGORA', 7.3358066, -72.921023, 'Produccion de miel y cera de abejas , 16 colmenas dsitribuidos en area de bosque y produccion de bebidas alcoholicas no destiladas', 'Produccion de miel y cera de abejas , 16 colmenas dsitribuidos en area de bosque y produccion de bebidas alcoholicas no destiladas', 'MIEL Y CERA DE ABEJA', '3142172243', '573142172243', 'rafaelariasgarcia03@gmail.com', 'RAFAEL ARIAS GARCIA', '5605103-6', 'Natural', null, 'Cámara de comercio', 'ANA RUEDA', 'ACTIVO', 'Intermedio', 2021, '2.255 msnm', '72.921023', '7.3358066', 'Actualizó', 'Se realizo visita y se actualizo ficha de verificacion', null, 'Sí', 'Sí', '2033-05-04', null, null, 'No', 'No', 'No', null, null, null, 'No', null, null, 'No', 'No', 'No', null, null, 'No', 'B2C', 'No', null, 'Conservacion y aprovechamiento  del fruto silvestre arrayan de manera artesanal, conservacion del ecosistema  , produccion sostenible de la miel polinizacion de plantas y cultivos que contribuye a la seguridad alimentaria y al equilibrio de ecosistema, preservan la biodiversidad.', 'Beneficio a familias de la region como adultos mayores , fortalecimineto de empresas de mujeres campesinas', 'Tienen definidos sus costso y gastos , buena participacion en ferias y eventos , generan buena produccion de miel intencion de ampliar las colmenas y generar mas ingress', true, false, false, false, true
where not exists (select 1 from negocios where nombre = 'APICOLA EL CARBONAL');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'APICOLA EL CARBONAL');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'APICOLA EL CARBONAL'), (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'APICOLA EL CARBONAL');
insert into negocios_subcategorias (negocio_id, subcategoria_id) select (select id from negocios where nombre = 'APICOLA EL CARBONAL'), id from subcategorias where slug = 'agroindustria-sostenible';
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'APICOLA EL CARBONAL');
insert into negocios_actividades (negocio_id, actividad_productiva_id) select (select id from negocios where nombre = 'APICOLA EL CARBONAL'), id from actividades_productivas where slug = 'agroindustrial-alimentario';
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'APICOLA EL CARBONAL'), 2021, 37.04 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'APICOLA EL CARBONAL'), 2022, 37.04 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'APICOLA EL CARBONAL'), 2023, 43.42 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'APICOLA EL CARBONAL'), 2025, 42.0 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;

-- VARAS COLOMBIA SAS
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'pendiente-clasificar'),
  municipio = 'Bucaramanga',
  vereda_id = null,
  direccion = 'CALLE 41 No. 27-63 OFICINA 103',
  latitud = null,
  longitud = null,
  descripcion_corta = null,
  descripcion = null,
  producto = 'VELAS',
  telefono = '3193643449',
  whatsapp = '573193643449',
  email = 'varas.gerencia@gmail.com',
  representante_legal = 'RAFAEL HERNAN CENTENO',
  nit = '901417447-8',
  naturaleza_juridica = null,
  delegado = null,
  rut_camara_comercio = null,
  responsable_cdmb = null,
  novedad = 'RETIRADO',
  tipo_negocio_verde = null,
  anio_registro = 2022,
  cota_msnm = null,
  este = null,
  norte = null,
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
where nombre = 'VARAS COLOMBIA SAS';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select '82c67adc-09be-4e16-8839-89392828ef4c', 'VARAS COLOMBIA SAS', generar_slug_unico('VARAS COLOMBIA SAS', '82c67adc-09be-4e16-8839-89392828ef4c'), (select id from categorias_oficiales where slug = 'pendiente-clasificar'), 'Bucaramanga', null, 'CALLE 41 No. 27-63 OFICINA 103', null, null, null, null, 'VELAS', '3193643449', '573193643449', 'varas.gerencia@gmail.com', 'RAFAEL HERNAN CENTENO', '901417447-8', null, null, null, null, 'RETIRADO', null, 2022, null, null, null, null, 'Por definir', null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, true, false, false, false, false
where not exists (select 1 from negocios where nombre = 'VARAS COLOMBIA SAS');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'VARAS COLOMBIA SAS');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'VARAS COLOMBIA SAS'), (select id from categorias_oficiales where slug = 'pendiente-clasificar');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'VARAS COLOMBIA SAS');
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'VARAS COLOMBIA SAS');

-- APISER S.A.S.
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'ecoproductos-industriales'),
  municipio = 'Piedecuesta',
  vereda_id = (select id from veredas where municipio = 'Piedecuesta' and slug = 'barrio-blanco'),
  direccion = 'VEREDA LA RAYADA FINCA LOS TOTUMOS',
  latitud = 6.973333333333334,
  longitud = -73.06055555555555,
  descripcion_corta = 'Es una empresa creada en el 2020 enfocada a la implementación de procesos apícolas, producción de colmenas, instalación de apiarios y el cuidado de las…',
  descripcion = 'Es una empresa creada en el 2020 enfocada a la implementación de procesos apícolas, producción de colmenas, instalación de apiarios y el cuidado de las abejas en los municipios de Piedecuesta y Santa Bárbara en Santander con 125 colmenas que maneja. La empresa realiza la producción y comercialización de productos apícolas como miel, polen, propóleo, jabones, implementos para apicultura, cría de reinas, núcleos y elaboración de colmenas. La empresa cuenta con un mercado de sus productos a nivel local en el municipio de Piedecuesta. Para la comercialización de sus productos la empresa cuenta con una tienda en el casco urbano del municipio de Piedecuesta y realiza la promoción mediante redes sociales (Facebook, Instagram, WhatsApp). Realiza actividades de rescate de enjambres de abejas y ubicación de los panales, con estas acciones buscan generar conciencia en la protección de las abejas y sostenibilidad de estas especies. De igual forma, genera un impacto ambiental positivo importante ya que se promueve la conservación de zonas de bosque donde se instalan las colmenas para la producción fomentando las buenas prácticas apícolas y el cuidado de la flora nativa para el adecuado manejo y preservación de estas especies.',
  producto = 'MIEL',
  telefono = '3219856591',
  whatsapp = '573219856591',
  email = 'brayan25f@hotmail.com',
  representante_legal = 'BRAYAN FELIPE SILVA SERRANO',
  nit = '901380790-8',
  naturaleza_juridica = null,
  delegado = null,
  rut_camara_comercio = null,
  responsable_cdmb = 'ALEXANDRA SOTOMONTE',
  novedad = 'SUSPENDIDO',
  tipo_negocio_verde = 'Inicial',
  anio_registro = 2020,
  cota_msnm = '937 msnm',
  este = '73°3''38''''',
  norte = '6°58''24''''',
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
where nombre = 'APISER S.A.S.';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select '854e186d-cd95-4fc4-ba93-9f32ea60389f', 'APISER S.A.S.', generar_slug_unico('APISER S.A.S.', '854e186d-cd95-4fc4-ba93-9f32ea60389f'), (select id from categorias_oficiales where slug = 'ecoproductos-industriales'), 'Piedecuesta', (select id from veredas where municipio = 'Piedecuesta' and slug = 'barrio-blanco'), 'VEREDA LA RAYADA FINCA LOS TOTUMOS', 6.973333333333334, -73.06055555555555, 'Es una empresa creada en el 2020 enfocada a la implementación de procesos apícolas, producción de colmenas, instalación de apiarios y el cuidado de las…', 'Es una empresa creada en el 2020 enfocada a la implementación de procesos apícolas, producción de colmenas, instalación de apiarios y el cuidado de las abejas en los municipios de Piedecuesta y Santa Bárbara en Santander con 125 colmenas que maneja. La empresa realiza la producción y comercialización de productos apícolas como miel, polen, propóleo, jabones, implementos para apicultura, cría de reinas, núcleos y elaboración de colmenas. La empresa cuenta con un mercado de sus productos a nivel local en el municipio de Piedecuesta. Para la comercialización de sus productos la empresa cuenta con una tienda en el casco urbano del municipio de Piedecuesta y realiza la promoción mediante redes sociales (Facebook, Instagram, WhatsApp). Realiza actividades de rescate de enjambres de abejas y ubicación de los panales, con estas acciones buscan generar conciencia en la protección de las abejas y sostenibilidad de estas especies. De igual forma, genera un impacto ambiental positivo importante ya que se promueve la conservación de zonas de bosque donde se instalan las colmenas para la producción fomentando las buenas prácticas apícolas y el cuidado de la flora nativa para el adecuado manejo y preservación de estas especies.', 'MIEL', '3219856591', '573219856591', 'brayan25f@hotmail.com', 'BRAYAN FELIPE SILVA SERRANO', '901380790-8', null, null, null, 'ALEXANDRA SOTOMONTE', 'SUSPENDIDO', 'Inicial', 2020, '937 msnm', '73°3''38''''', '6°58''24''''', null, 'Continua en el programa', null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, false, false, true, false, false
where not exists (select 1 from negocios where nombre = 'APISER S.A.S.');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'APISER S.A.S.');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'APISER S.A.S.'), (select id from categorias_oficiales where slug = 'ecoproductos-industriales');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'APISER S.A.S.');
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'APISER S.A.S.');
insert into negocios_actividades (negocio_id, actividad_productiva_id) select (select id from negocios where nombre = 'APISER S.A.S.'), id from actividades_productivas where slug = 'aprovechamiento-residuos-organicos';
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'APISER S.A.S.'), 2022, 55.99 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'APISER S.A.S.'), 2023, 63.71 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;

-- SANTURBAN BIRDING
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'pendiente-clasificar'),
  municipio = 'Suratá',
  vereda_id = null,
  direccion = 'CALLE 3 # 3 - 31',
  latitud = null,
  longitud = null,
  descripcion_corta = null,
  descripcion = null,
  producto = 'ECOTURISMO',
  telefono = '3112211554',
  whatsapp = '573112211554',
  email = 'admaliz417@gmail.com',
  representante_legal = 'ADRIAN LIZCANO MALDONADO',
  nit = '79910959-1',
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
where nombre = 'SANTURBAN BIRDING';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select '023d84c7-a38c-464e-b920-e13aef184b40', 'SANTURBAN BIRDING', generar_slug_unico('SANTURBAN BIRDING', '023d84c7-a38c-464e-b920-e13aef184b40'), (select id from categorias_oficiales where slug = 'pendiente-clasificar'), 'Suratá', null, 'CALLE 3 # 3 - 31', null, null, null, null, 'ECOTURISMO', '3112211554', '573112211554', 'admaliz417@gmail.com', 'ADRIAN LIZCANO MALDONADO', '79910959-1', null, null, null, null, 'RETIRADO', 'No aplica', 2022, null, null, null, null, 'Continua en el programa', null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, true, false, false, false, false
where not exists (select 1 from negocios where nombre = 'SANTURBAN BIRDING');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'SANTURBAN BIRDING');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'SANTURBAN BIRDING'), (select id from categorias_oficiales where slug = 'pendiente-clasificar');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'SANTURBAN BIRDING');
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'SANTURBAN BIRDING');

-- SILVIFRID ORGANIC
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'pendiente-clasificar'),
  municipio = 'Floridablanca',
  vereda_id = null,
  direccion = 'CARRERA 10 # 21A-02 BARRIO GIRARDOT',
  latitud = null,
  longitud = null,
  descripcion_corta = 'Esta empresa esta dedicada a la elaboración de jabón de café entre otros, ellos compran la glicerina vegetal y tienen un contrato con un empresario que…',
  descripcion = 'Esta empresa esta dedicada a la elaboración de jabón de café entre otros, ellos compran la glicerina vegetal y tienen un contrato con un empresario que produce café, el cual les provee el pozo de café para incluirlo en su proceso de elaboración, posteriormente lo empacan y se distribuye a los clientes que reconocen la marca a través de redes sociales',
  producto = 'JABONES',
  telefono = '3197208628',
  whatsapp = '573197208628',
  email = 'julianita1487@hotmail.com',
  representante_legal = 'SILVIA JULIANA CAMACHO OBREGÓN',
  nit = '1098655992-1',
  naturaleza_juridica = null,
  delegado = null,
  rut_camara_comercio = null,
  responsable_cdmb = 'ANDRES VALDERRAMA',
  novedad = 'SUSPENDIDO',
  tipo_negocio_verde = 'Satisfactorio',
  anio_registro = 2022,
  cota_msnm = null,
  este = null,
  norte = null,
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
where nombre = 'SILVIFRID ORGANIC';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select '586492d5-3791-4a9d-a034-dc3bc0410e55', 'SILVIFRID ORGANIC', generar_slug_unico('SILVIFRID ORGANIC', '586492d5-3791-4a9d-a034-dc3bc0410e55'), (select id from categorias_oficiales where slug = 'pendiente-clasificar'), 'Floridablanca', null, 'CARRERA 10 # 21A-02 BARRIO GIRARDOT', null, null, 'Esta empresa esta dedicada a la elaboración de jabón de café entre otros, ellos compran la glicerina vegetal y tienen un contrato con un empresario que…', 'Esta empresa esta dedicada a la elaboración de jabón de café entre otros, ellos compran la glicerina vegetal y tienen un contrato con un empresario que produce café, el cual les provee el pozo de café para incluirlo en su proceso de elaboración, posteriormente lo empacan y se distribuye a los clientes que reconocen la marca a través de redes sociales', 'JABONES', '3197208628', '573197208628', 'julianita1487@hotmail.com', 'SILVIA JULIANA CAMACHO OBREGÓN', '1098655992-1', null, null, null, 'ANDRES VALDERRAMA', 'SUSPENDIDO', 'Satisfactorio', 2022, null, null, null, null, 'Continua en el programa', null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, true, false, false, false, false
where not exists (select 1 from negocios where nombre = 'SILVIFRID ORGANIC');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'SILVIFRID ORGANIC');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'SILVIFRID ORGANIC'), (select id from categorias_oficiales where slug = 'pendiente-clasificar');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'SILVIFRID ORGANIC');
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'SILVIFRID ORGANIC');
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'SILVIFRID ORGANIC'), 2022, 51.12 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'SILVIFRID ORGANIC'), 2023, 51.12 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;

-- BUCARRETES S.A.S. BIC
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'ecoproductos-industriales'),
  municipio = 'Girón',
  vereda_id = (select id from veredas where municipio = 'Girón' and slug = 'lagunetas'),
  direccion = 'KM 3 FINCA VILLA TERESA VIA GIRON EL CORREGIDOR VEREDA LAGUNETAS BIA GIRON',
  latitud = 7.038055555555555,
  longitud = -73.17333333333333,
  descripcion_corta = 'Procesamiento,reciclaje y manufactura de productos en madera,secado  y/o deshidratación de maderas, frutas y plantas en general y construcciones en madera…',
  descripcion = 'Procesamiento,reciclaje y manufactura de productos en madera,secado  y/o deshidratación de maderas, frutas y plantas en general y construcciones en madera recuperadas',
  producto = 'CONSTRUCCIÓN DE EDIFICACIONES CON MATERIAL APROVECHABLE - MADERA',
  telefono = '3206935225',
  whatsapp = '573206935225',
  email = 'nancy.jaimes@bucarretes.co',
  representante_legal = 'GIOVANNY MARCELO PATIÑO LEDEZMA',
  nit = '900276049-1',
  naturaleza_juridica = 'Jurídica',
  delegado = 'NANCY JAIMES',
  rut_camara_comercio = 'Cámara de comercio',
  responsable_cdmb = 'DIANA NAVARRO',
  novedad = 'ACTIVO',
  tipo_negocio_verde = 'Dinamizadoras',
  anio_registro = 2018,
  cota_msnm = '776.7 msnm',
  este = '73°10''24''''',
  norte = '7°02''17''''',
  aplicacion_ficha_2025 = 'Actualizó',
  observaciones = 'Se realizo visita y se actualizo ficha de verificacion',
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
  fortalezas_ambiental = 'No generan gases contaminantes',
  fortalezas_social = 'Promueven la educación y conciencia sobre la importancia del reciclaje y la sostenibilidad.',
  fortalezas_economico = 'Margen de utilidad por unidad y no tienen costos fijos altos',
  emprendimiento_verde = false,
  sello_marca = true,
  avalado = true,
  destacado = false,
  activo = true
where nombre = 'BUCARRETES S.A.S. BIC';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select 'c37f2c89-0bb4-4d0d-8759-17974e1bfba1', 'BUCARRETES S.A.S. BIC', generar_slug_unico('BUCARRETES S.A.S. BIC', 'c37f2c89-0bb4-4d0d-8759-17974e1bfba1'), (select id from categorias_oficiales where slug = 'ecoproductos-industriales'), 'Girón', (select id from veredas where municipio = 'Girón' and slug = 'lagunetas'), 'KM 3 FINCA VILLA TERESA VIA GIRON EL CORREGIDOR VEREDA LAGUNETAS BIA GIRON', 7.038055555555555, -73.17333333333333, 'Procesamiento,reciclaje y manufactura de productos en madera,secado  y/o deshidratación de maderas, frutas y plantas en general y construcciones en madera…', 'Procesamiento,reciclaje y manufactura de productos en madera,secado  y/o deshidratación de maderas, frutas y plantas en general y construcciones en madera recuperadas', 'CONSTRUCCIÓN DE EDIFICACIONES CON MATERIAL APROVECHABLE - MADERA', '3206935225', '573206935225', 'nancy.jaimes@bucarretes.co', 'GIOVANNY MARCELO PATIÑO LEDEZMA', '900276049-1', 'Jurídica', 'NANCY JAIMES', 'Cámara de comercio', 'DIANA NAVARRO', 'ACTIVO', 'Dinamizadoras', 2018, '776.7 msnm', '73°10''24''''', '7°02''17''''', 'Actualizó', 'Se realizo visita y se actualizo ficha de verificacion', null, 'Sí', 'No', null, null, null, 'No', 'No', 'Sí', null, null, null, null, null, null, null, null, null, null, null, 'No', 'Mixta', 'No', 'NO', 'No generan gases contaminantes', 'Promueven la educación y conciencia sobre la importancia del reciclaje y la sostenibilidad.', 'Margen de utilidad por unidad y no tienen costos fijos altos', false, true, true, false, true
where not exists (select 1 from negocios where nombre = 'BUCARRETES S.A.S. BIC');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'BUCARRETES S.A.S. BIC');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'BUCARRETES S.A.S. BIC'), (select id from categorias_oficiales where slug = 'ecoproductos-industriales');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'BUCARRETES S.A.S. BIC');
insert into negocios_subcategorias (negocio_id, subcategoria_id) select (select id from negocios where nombre = 'BUCARRETES S.A.S. BIC'), id from subcategorias where slug = 'construccion-infraestructura-sostenible';
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'BUCARRETES S.A.S. BIC');
insert into negocios_actividades (negocio_id, actividad_productiva_id) select (select id from negocios where nombre = 'BUCARRETES S.A.S. BIC'), id from actividades_productivas where slug = 'biomateriales-ecomateriales-equipos-ecoeficientes';
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'BUCARRETES S.A.S. BIC'), 2020, 67.85 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'BUCARRETES S.A.S. BIC'), 2021, 67.85 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'BUCARRETES S.A.S. BIC'), 2022, 76.34 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'BUCARRETES S.A.S. BIC'), 2023, 76.34 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'BUCARRETES S.A.S. BIC'), 2024, 94.7 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'BUCARRETES S.A.S. BIC'), 2025, 83.1 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;

-- WABISABI GLAMPING S.A.S
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'pendiente-clasificar'),
  municipio = 'Suratá',
  vereda_id = null,
  direccion = 'FINCA VILLA MARGARITA',
  latitud = null,
  longitud = null,
  descripcion_corta = null,
  descripcion = null,
  producto = 'ECOTURISMO',
  telefono = '301 3946918',
  whatsapp = '301 3946918',
  email = 'glampingws@gmail.com',
  representante_legal = 'EDUARDO TOLOZA SUAREZ',
  nit = '901518360-1',
  naturaleza_juridica = null,
  delegado = null,
  rut_camara_comercio = null,
  responsable_cdmb = 'JUAN SEBASTIAN',
  novedad = 'INACTIVO',
  tipo_negocio_verde = null,
  anio_registro = 2022,
  cota_msnm = null,
  este = null,
  norte = null,
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
where nombre = 'WABISABI GLAMPING S.A.S';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select '970d7017-fe44-4ce1-9084-dec7b5b59068', 'WABISABI GLAMPING S.A.S', generar_slug_unico('WABISABI GLAMPING S.A.S', '970d7017-fe44-4ce1-9084-dec7b5b59068'), (select id from categorias_oficiales where slug = 'pendiente-clasificar'), 'Suratá', null, 'FINCA VILLA MARGARITA', null, null, null, null, 'ECOTURISMO', '301 3946918', '301 3946918', 'glampingws@gmail.com', 'EDUARDO TOLOZA SUAREZ', '901518360-1', null, null, null, 'JUAN SEBASTIAN', 'INACTIVO', null, 2022, null, null, null, null, 'Continua en el programa', null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, true, false, false, false, false
where not exists (select 1 from negocios where nombre = 'WABISABI GLAMPING S.A.S');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'WABISABI GLAMPING S.A.S');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'WABISABI GLAMPING S.A.S'), (select id from categorias_oficiales where slug = 'pendiente-clasificar');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'WABISABI GLAMPING S.A.S');
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'WABISABI GLAMPING S.A.S');

-- PROYECTOS AGROTURISTICOS VILLA CRISTINA S.A.S.
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'),
  municipio = 'Piedecuesta',
  vereda_id = (select id from veredas where municipio = 'Piedecuesta' and slug = 'blanquiscal'),
  direccion = 'VEREDA  BLANQUISCAL PIEDECUESTA KM 4 VIA MESA DE LOS SANTOS',
  latitud = 6.939166666666667,
  longitud = -73.03777777777778,
  descripcion_corta = 'La granja hotel villa cristina es un proyecto agroturistico una granja organica dentro de las instalaciones hay sendero ecologico, avistamiento de aves,…',
  descripcion = 'La granja hotel villa cristina es un proyecto agroturistico una granja organica dentro de las instalaciones hay sendero ecologico, avistamiento de aves, interacción de  la naturaleza con animales de granja como caballos, pavos reales entre otros. Tambien ofrecen ciclo montañismo,pesca deportiva.ofrece servicio de alojamiento de 19 habitaciones con capacidad de 50 acomodaciones .',
  producto = 'TURISMO DE NATURALEZA',
  telefono = '3214337231',
  whatsapp = '573214337231',
  email = 'granjahostalvillacristina@gmail.com',
  representante_legal = 'JAIRO CORZO SALAMANCA',
  nit = '900883373-5',
  naturaleza_juridica = 'Jurídica',
  delegado = 'CARMEN EDUVIA PRADA',
  rut_camara_comercio = 'Cámara de comercio',
  responsable_cdmb = 'KAREN CAMACHO',
  novedad = 'ACTIVO',
  tipo_negocio_verde = 'Satisfactorio',
  anio_registro = 2022,
  cota_msnm = '1202 msnm',
  este = '73°2''16''''',
  norte = '6°56''21''''',
  aplicacion_ficha_2025 = 'Actualizó',
  observaciones = 'Se realizo visita y se aplico ficha de verificacion',
  registro_nacional_turismo = 'Sí',
  uso_suelo = 'Sí',
  concesion_aguas = 'Sí',
  concesion_aguas_vencimiento = '2030-12-20',
  vertimientos = 'Sí',
  vertimientos_vencimiento = null,
  pueaa = 'No',
  pgris = 'Sí',
  pozo_septico = 'Sí',
  alcantarillado = null,
  ica = null,
  ica_vencimiento = null,
  invima = null,
  invima_vencimiento = null,
  certificado_tenencia_animales = 'No',
  buenas_practicas_agricolas = 'Sí',
  buenas_practicas_apicolas = null,
  registro_apicola = null,
  intervencion_cauce = null,
  capacidad_carga = 'No',
  sstt = 'Sí',
  canal_venta = 'Mixta',
  exportacion = 'No',
  huella_carbono = 'NO',
  fortalezas_ambiental = 'Fácil acceso a la naturaleza sin alejarse de la ciudad. Promueve la sensibilización y cuidado del ecosistema local. Actividades guiadas. Potencial para programas educativos agrícolas sostenibles. Zonas de conservación y huertas ecológicas para consumo propio.',
  fortalezas_social = 'Promueve empleo local, beneficiando a jóvenes, madres y adultos mayores. Fomenta ambiente laboral positivo con actividades lúdicas y recreativas. Asegura pagos justos y puntuales, aumentando satisfacción y rendimiento. Bienestar empresarial. Rescate animal.',
  fortalezas_economico = 'Costos operativos más bajos comparados con hoteles urbanos. Mercado en crecimiento. Decisiones rápidas gracias a socios familiares. Inversión en activos para valor agregado futuro.',
  emprendimiento_verde = false,
  sello_marca = true,
  avalado = true,
  destacado = false,
  activo = true
where nombre = 'PROYECTOS AGROTURISTICOS VILLA CRISTINA S.A.S.';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select 'c750530d-acb5-4ac5-b7c7-cb9dd67cdf87', 'PROYECTOS AGROTURISTICOS VILLA CRISTINA S.A.S.', generar_slug_unico('PROYECTOS AGROTURISTICOS VILLA CRISTINA S.A.S.', 'c750530d-acb5-4ac5-b7c7-cb9dd67cdf87'), (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'), 'Piedecuesta', (select id from veredas where municipio = 'Piedecuesta' and slug = 'blanquiscal'), 'VEREDA  BLANQUISCAL PIEDECUESTA KM 4 VIA MESA DE LOS SANTOS', 6.939166666666667, -73.03777777777778, 'La granja hotel villa cristina es un proyecto agroturistico una granja organica dentro de las instalaciones hay sendero ecologico, avistamiento de aves,…', 'La granja hotel villa cristina es un proyecto agroturistico una granja organica dentro de las instalaciones hay sendero ecologico, avistamiento de aves, interacción de  la naturaleza con animales de granja como caballos, pavos reales entre otros. Tambien ofrecen ciclo montañismo,pesca deportiva.ofrece servicio de alojamiento de 19 habitaciones con capacidad de 50 acomodaciones .', 'TURISMO DE NATURALEZA', '3214337231', '573214337231', 'granjahostalvillacristina@gmail.com', 'JAIRO CORZO SALAMANCA', '900883373-5', 'Jurídica', 'CARMEN EDUVIA PRADA', 'Cámara de comercio', 'KAREN CAMACHO', 'ACTIVO', 'Satisfactorio', 2022, '1202 msnm', '73°2''16''''', '6°56''21''''', 'Actualizó', 'Se realizo visita y se aplico ficha de verificacion', 'Sí', 'Sí', 'Sí', '2030-12-20', 'Sí', null, 'No', 'Sí', 'Sí', null, null, null, null, null, 'No', 'Sí', null, null, null, 'No', 'Sí', 'Mixta', 'No', 'NO', 'Fácil acceso a la naturaleza sin alejarse de la ciudad. Promueve la sensibilización y cuidado del ecosistema local. Actividades guiadas. Potencial para programas educativos agrícolas sostenibles. Zonas de conservación y huertas ecológicas para consumo propio.', 'Promueve empleo local, beneficiando a jóvenes, madres y adultos mayores. Fomenta ambiente laboral positivo con actividades lúdicas y recreativas. Asegura pagos justos y puntuales, aumentando satisfacción y rendimiento. Bienestar empresarial. Rescate animal.', 'Costos operativos más bajos comparados con hoteles urbanos. Mercado en crecimiento. Decisiones rápidas gracias a socios familiares. Inversión en activos para valor agregado futuro.', false, true, true, false, true
where not exists (select 1 from negocios where nombre = 'PROYECTOS AGROTURISTICOS VILLA CRISTINA S.A.S.');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'PROYECTOS AGROTURISTICOS VILLA CRISTINA S.A.S.');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'PROYECTOS AGROTURISTICOS VILLA CRISTINA S.A.S.'), (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'PROYECTOS AGROTURISTICOS VILLA CRISTINA S.A.S.');
insert into negocios_subcategorias (negocio_id, subcategoria_id) select (select id from negocios where nombre = 'PROYECTOS AGROTURISTICOS VILLA CRISTINA S.A.S.'), id from subcategorias where slug = 'turismo-sostenible';
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'PROYECTOS AGROTURISTICOS VILLA CRISTINA S.A.S.');
insert into negocios_actividades (negocio_id, actividad_productiva_id) select (select id from negocios where nombre = 'PROYECTOS AGROTURISTICOS VILLA CRISTINA S.A.S.'), id from actividades_productivas where slug = 'servicios-turismo-naturaleza';
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'PROYECTOS AGROTURISTICOS VILLA CRISTINA S.A.S.'), 2022, 65.74 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'PROYECTOS AGROTURISTICOS VILLA CRISTINA S.A.S.'), 2023, 65.74 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'PROYECTOS AGROTURISTICOS VILLA CRISTINA S.A.S.'), 2024, 0.679 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'PROYECTOS AGROTURISTICOS VILLA CRISTINA S.A.S.'), 2025, 73.6 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;

-- RAIZVER
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'pendiente-clasificar'),
  municipio = 'Bucaramanga',
  vereda_id = null,
  direccion = 'CARRERA 34 # 32-10 APTO 503',
  latitud = null,
  longitud = null,
  descripcion_corta = null,
  descripcion = null,
  producto = 'PILON BIODEGRADABLE',
  telefono = '3184018757',
  whatsapp = '573184018757',
  email = 'cciltda.javier@gmail.com',
  representante_legal = 'ZULLY CASTILLO',
  nit = null,
  naturaleza_juridica = null,
  delegado = null,
  rut_camara_comercio = null,
  responsable_cdmb = 'PIER FRATALLI',
  novedad = 'RETIRADO',
  tipo_negocio_verde = null,
  anio_registro = 2022,
  cota_msnm = null,
  este = null,
  norte = null,
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
  fortalezas_ambiental = null,
  fortalezas_social = null,
  fortalezas_economico = null,
  emprendimiento_verde = true,
  sello_marca = false,
  avalado = false,
  destacado = false,
  activo = false
where nombre = 'RAIZVER';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select '0d82d6ef-b062-4792-9d1a-3e8c9dc884d1', 'RAIZVER', generar_slug_unico('RAIZVER', '0d82d6ef-b062-4792-9d1a-3e8c9dc884d1'), (select id from categorias_oficiales where slug = 'pendiente-clasificar'), 'Bucaramanga', null, 'CARRERA 34 # 32-10 APTO 503', null, null, null, null, 'PILON BIODEGRADABLE', '3184018757', '573184018757', 'cciltda.javier@gmail.com', 'ZULLY CASTILLO', null, null, null, null, 'PIER FRATALLI', 'RETIRADO', null, 2022, null, null, null, null, 'Retirado', null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, true, false, false, false, false
where not exists (select 1 from negocios where nombre = 'RAIZVER');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'RAIZVER');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'RAIZVER'), (select id from categorias_oficiales where slug = 'pendiente-clasificar');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'RAIZVER');
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'RAIZVER');


commit;
