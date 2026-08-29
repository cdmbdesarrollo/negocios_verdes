begin;

-- Generado por lib/migraciones/generar_0026.py desde BASE_ACTUALIZADA_NV_ka.xlsx — no editar a mano.
-- Uno de varios archivos partidos (ver README.md) — correr TODOS, en cualquier orden, cada uno es su propia transacción.

-- Parte 4 de 17.

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

-- TESORO DEL ROMERAL S.A.S
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'),
  municipio = 'Vetas',
  vereda_id = (select id from veredas where municipio = 'Vetas' and slug = 'el-salado'),
  direccion = 'FINCA EL ROMERAL, VEREDA EL SALADO',
  latitud = 7.331944444444444,
  longitud = -72.85416666666666,
  descripcion_corta = 'Finca el Romeral de propiedad familiar, ubicada en la vereda el Salado del Municipio de Vetas - Santander, dado al potencial ambiental por estar ubicada en…',
  descripcion = 'Finca el Romeral de propiedad familiar, ubicada en la vereda el Salado del Municipio de Vetas - Santander, dado al potencial ambiental por estar ubicada en ecosistema estratégico del Páramo de Santurban, inciaron con recorridos en la finca dando a concer los recursos que ofrece la región por medio de educación ambiental fomentando la conservación de dichos ecosistemas. Hoy día, se realizan recorridos con guias turisticos por la finca.',
  producto = 'TURISMO DE NATURALEZA',
  telefono = '3209995996',
  whatsapp = '573209995996',
  email = 'tesorodelromeral@gmail.com',
  representante_legal = 'JUDITH RODRÍGUEZ BAUTISTA',
  nit = '901797147-2',
  naturaleza_juridica = 'Jurídica',
  delegado = null,
  rut_camara_comercio = 'Cámara de comercio',
  responsable_cdmb = 'KAREN CAMACHO',
  novedad = 'ACTIVO',
  tipo_negocio_verde = 'Satisfactorio',
  anio_registro = 2021,
  cota_msnm = '3571 msnm',
  este = '72°51''15"',
  norte = '7°19''55"',
  aplicacion_ficha_2025 = 'Actualizó',
  observaciones = 'Se realizo visita y se actualizo ficha de verificacion',
  registro_nacional_turismo = 'Sí',
  uso_suelo = 'Sí',
  concesion_aguas = 'Sí',
  concesion_aguas_vencimiento = '2033-10-17',
  vertimientos = null,
  vertimientos_vencimiento = null,
  pueaa = 'Sí',
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
  sstt = 'No',
  canal_venta = 'Mixta',
  exportacion = 'No',
  huella_carbono = 'NO',
  fortalezas_ambiental = 'Protección y conservación de fauna y flora',
  fortalezas_social = 'Educación ambiental',
  fortalezas_economico = 'Buena oferta económica',
  emprendimiento_verde = false,
  sello_marca = false,
  avalado = true,
  destacado = false,
  activo = true
where nombre = 'TESORO DEL ROMERAL S.A.S';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select 'c2b9d2b0-cf5d-44d6-ac0c-fe042e23b440', 'TESORO DEL ROMERAL S.A.S', generar_slug_unico('TESORO DEL ROMERAL S.A.S', 'c2b9d2b0-cf5d-44d6-ac0c-fe042e23b440'), (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'), 'Vetas', (select id from veredas where municipio = 'Vetas' and slug = 'el-salado'), 'FINCA EL ROMERAL, VEREDA EL SALADO', 7.331944444444444, -72.85416666666666, 'Finca el Romeral de propiedad familiar, ubicada en la vereda el Salado del Municipio de Vetas - Santander, dado al potencial ambiental por estar ubicada en…', 'Finca el Romeral de propiedad familiar, ubicada en la vereda el Salado del Municipio de Vetas - Santander, dado al potencial ambiental por estar ubicada en ecosistema estratégico del Páramo de Santurban, inciaron con recorridos en la finca dando a concer los recursos que ofrece la región por medio de educación ambiental fomentando la conservación de dichos ecosistemas. Hoy día, se realizan recorridos con guias turisticos por la finca.', 'TURISMO DE NATURALEZA', '3209995996', '573209995996', 'tesorodelromeral@gmail.com', 'JUDITH RODRÍGUEZ BAUTISTA', '901797147-2', 'Jurídica', null, 'Cámara de comercio', 'KAREN CAMACHO', 'ACTIVO', 'Satisfactorio', 2021, '3571 msnm', '72°51''15"', '7°19''55"', 'Actualizó', 'Se realizo visita y se actualizo ficha de verificacion', 'Sí', 'Sí', 'Sí', '2033-10-17', null, null, 'Sí', 'Sí', 'Sí', null, null, null, null, null, null, null, null, null, null, 'No', 'No', 'Mixta', 'No', 'NO', 'Protección y conservación de fauna y flora', 'Educación ambiental', 'Buena oferta económica', false, false, true, false, true
where not exists (select 1 from negocios where nombre = 'TESORO DEL ROMERAL S.A.S');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'TESORO DEL ROMERAL S.A.S');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'TESORO DEL ROMERAL S.A.S'), (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'TESORO DEL ROMERAL S.A.S');
insert into negocios_subcategorias (negocio_id, subcategoria_id) select (select id from negocios where nombre = 'TESORO DEL ROMERAL S.A.S'), id from subcategorias where slug = 'turismo-sostenible';
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'TESORO DEL ROMERAL S.A.S');
insert into negocios_actividades (negocio_id, actividad_productiva_id) select (select id from negocios where nombre = 'TESORO DEL ROMERAL S.A.S'), id from actividades_productivas where slug = 'servicios-turismo-naturaleza';
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'TESORO DEL ROMERAL S.A.S'), 2021, 54.4 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'TESORO DEL ROMERAL S.A.S'), 2022, 62.71 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'TESORO DEL ROMERAL S.A.S'), 2023, 67.03 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'TESORO DEL ROMERAL S.A.S'), 2024, 62.5 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'TESORO DEL ROMERAL S.A.S'), 2025, 70.6 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;

-- RESERVA NATURAL MANANTIAL DE LA AURORA
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'),
  municipio = 'Lebrija',
  vereda_id = (select id from veredas where municipio = 'Lebrija' and slug = 'perimetro-urbano'),
  direccion = 'VEREDA CERRO DE LA AURORA FINCA MANANTIAL DE LA AURORA',
  latitud = 7.114028888888889,
  longitud = -73.10329972222222,
  descripcion_corta = 'Realizar actividades de guias de turismo, de promociòn turistica; El Servicio se ofrece en la Reserva El Manantial, vereda Cerro de la Aurora, del municipio…',
  descripcion = 'Realizar actividades de guias de turismo, de promociòn turistica; El Servicio se ofrece en la Reserva El Manantial, vereda Cerro de la Aurora, del municipio de Lebrija, Santander, en donde se ofrece un paquete que integra: recorrido por la reserva, avistamiento de aves, alojamiento, alimentación, educación ambiental y cultural/musical, entre otros. Los principales canales de comercialización son las redes sociales, la página web y el voz a voz, a través de los cuales se da a conocer la propuesta de valor en torno al ecoturismo. Para el desarrollo del modelo de negocio, CONCULTURA integra a las comunidades aledañas a través de la adquisición de insumos para el servicio de alimentación, procurando la creación de una apuesta de turismo comunitario en la región.',
  producto = 'ECOTURISMO (AVIFAUNA)',
  telefono = '3174019931',
  whatsapp = '573174019931',
  email = 'punoardilagmail.com',
  representante_legal = 'PUNO ARDILA AMAYA',
  nit = '91102168-8',
  naturaleza_juridica = 'Jurídica',
  delegado = null,
  rut_camara_comercio = 'Cámara de comercio y RUT',
  responsable_cdmb = 'NATALY RAMIREZ',
  novedad = 'SUSPENDIDO',
  tipo_negocio_verde = null,
  anio_registro = 2021,
  cota_msnm = '762 msnm',
  este = '73°6''11.879"',
  norte = '7°6''50.504"',
  aplicacion_ficha_2025 = 'Actualizó',
  observaciones = 'Se realizo visita y se aplico ficha de verificacion',
  registro_nacional_turismo = 'Sí',
  uso_suelo = 'Sí',
  concesion_aguas = 'Sí',
  concesion_aguas_vencimiento = '2031-09-02',
  vertimientos = 'No',
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
  capacidad_carga = 'No',
  sstt = 'No',
  canal_venta = 'Mixta',
  exportacion = null,
  huella_carbono = null,
  fortalezas_ambiental = 'Conservación activa del entorno mediante recorridos guiados. Sensibilización ecológica que puede inspirar cambios en hábitos de los visitantes.',
  fortalezas_social = 'Promoción de la identidad cultural a través de la música y la educación. Fomento del conocimiento ambiental y cultural entre los visitantes.',
  fortalezas_economico = 'Alto valor agregado. Diversificación de ingresos.',
  emprendimiento_verde = false,
  sello_marca = false,
  avalado = true,
  destacado = false,
  activo = false
where nombre = 'RESERVA NATURAL MANANTIAL DE LA AURORA';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select '19eb6f02-70f4-40ba-80cd-6811d60f7e93', 'RESERVA NATURAL MANANTIAL DE LA AURORA', generar_slug_unico('RESERVA NATURAL MANANTIAL DE LA AURORA', '19eb6f02-70f4-40ba-80cd-6811d60f7e93'), (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'), 'Lebrija', (select id from veredas where municipio = 'Lebrija' and slug = 'perimetro-urbano'), 'VEREDA CERRO DE LA AURORA FINCA MANANTIAL DE LA AURORA', 7.114028888888889, -73.10329972222222, 'Realizar actividades de guias de turismo, de promociòn turistica; El Servicio se ofrece en la Reserva El Manantial, vereda Cerro de la Aurora, del municipio…', 'Realizar actividades de guias de turismo, de promociòn turistica; El Servicio se ofrece en la Reserva El Manantial, vereda Cerro de la Aurora, del municipio de Lebrija, Santander, en donde se ofrece un paquete que integra: recorrido por la reserva, avistamiento de aves, alojamiento, alimentación, educación ambiental y cultural/musical, entre otros. Los principales canales de comercialización son las redes sociales, la página web y el voz a voz, a través de los cuales se da a conocer la propuesta de valor en torno al ecoturismo. Para el desarrollo del modelo de negocio, CONCULTURA integra a las comunidades aledañas a través de la adquisición de insumos para el servicio de alimentación, procurando la creación de una apuesta de turismo comunitario en la región.', 'ECOTURISMO (AVIFAUNA)', '3174019931', '573174019931', 'punoardilagmail.com', 'PUNO ARDILA AMAYA', '91102168-8', 'Jurídica', null, 'Cámara de comercio y RUT', 'NATALY RAMIREZ', 'SUSPENDIDO', null, 2021, '762 msnm', '73°6''11.879"', '7°6''50.504"', 'Actualizó', 'Se realizo visita y se aplico ficha de verificacion', 'Sí', 'Sí', 'Sí', '2031-09-02', 'No', null, 'No', 'No', 'Sí', 'No', null, null, null, null, null, null, null, null, null, 'No', 'No', 'Mixta', null, null, 'Conservación activa del entorno mediante recorridos guiados. Sensibilización ecológica que puede inspirar cambios en hábitos de los visitantes.', 'Promoción de la identidad cultural a través de la música y la educación. Fomento del conocimiento ambiental y cultural entre los visitantes.', 'Alto valor agregado. Diversificación de ingresos.', false, false, true, false, false
where not exists (select 1 from negocios where nombre = 'RESERVA NATURAL MANANTIAL DE LA AURORA');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'RESERVA NATURAL MANANTIAL DE LA AURORA');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'RESERVA NATURAL MANANTIAL DE LA AURORA'), (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'RESERVA NATURAL MANANTIAL DE LA AURORA');
insert into negocios_subcategorias (negocio_id, subcategoria_id) select (select id from negocios where nombre = 'RESERVA NATURAL MANANTIAL DE LA AURORA'), id from subcategorias where slug = 'turismo-sostenible';
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'RESERVA NATURAL MANANTIAL DE LA AURORA');
insert into negocios_actividades (negocio_id, actividad_productiva_id) select (select id from negocios where nombre = 'RESERVA NATURAL MANANTIAL DE LA AURORA'), id from actividades_productivas where slug = 'servicios-turismo-naturaleza';
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'RESERVA NATURAL MANANTIAL DE LA AURORA'), 2021, 73.54 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'RESERVA NATURAL MANANTIAL DE LA AURORA'), 2022, 86.39 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'RESERVA NATURAL MANANTIAL DE LA AURORA'), 2023, 84.75 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'RESERVA NATURAL MANANTIAL DE LA AURORA'), 2024, 89.3 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'RESERVA NATURAL MANANTIAL DE LA AURORA'), 2025, 78.7 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;

-- FINCA CINCO ESTRELLAS
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'),
  municipio = 'Lebrija',
  vereda_id = (select id from veredas where municipio = 'Lebrija' and slug = 'panorama'),
  direccion = 'FINCA 5 ESTRELLAS VEREDA PANORAMA',
  latitud = 7.136666666666667,
  longitud = -73.30722222222222,
  descripcion_corta = 'Mediante la prestacion de diferentes servicios del turismo de naturaleza se busca fomentar la educacion ambiental con actividad de aviturismo involucrando a…',
  descripcion = 'Mediante la prestacion de diferentes servicios del turismo de naturaleza se busca fomentar la educacion ambiental con actividad de aviturismo involucrando a los niños y a los visitantes a la conservacion del medio ambiente,',
  producto = 'TURISMO DE NATURALEZA',
  telefono = '3188475949',
  whatsapp = '573188475949',
  email = 'arbey20091@hotmail.com',
  representante_legal = 'ARBEY YORDID SILVA PINZON',
  nit = '1099369439-5',
  naturaleza_juridica = 'Natural',
  delegado = null,
  rut_camara_comercio = 'Cámara de comercio',
  responsable_cdmb = 'NATALY RAMIREZ',
  novedad = 'ACTIVO',
  tipo_negocio_verde = 'Dinamizadoras',
  anio_registro = 2021,
  cota_msnm = '618.3 msnm',
  este = '73°18''26"',
  norte = '7°8''12"',
  aplicacion_ficha_2025 = 'Actualizó',
  observaciones = 'Se realizo visita y se actualizo ficha de verificacion',
  registro_nacional_turismo = 'Sí',
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
  invima = null,
  invima_vencimiento = null,
  certificado_tenencia_animales = null,
  buenas_practicas_agricolas = null,
  buenas_practicas_apicolas = null,
  registro_apicola = null,
  intervencion_cauce = null,
  capacidad_carga = 'Sí',
  sstt = 'No',
  canal_venta = 'B2C',
  exportacion = 'No',
  huella_carbono = 'NO',
  fortalezas_ambiental = 'Sensibilización ecológica que puede inspirar cambios en hábitos de los visitantes.',
  fortalezas_social = 'Participación comunitaria en actividades de la finca. -Talleres educativos con niños de la vereda',
  fortalezas_economico = 'Modelo de negocio en crecimiento. -Empresa legalmente registrada en Cámara de Comercio y RNT',
  emprendimiento_verde = false,
  sello_marca = false,
  avalado = true,
  destacado = false,
  activo = true
where nombre = 'FINCA CINCO ESTRELLAS';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select 'e1263e9e-0bac-4760-af86-894554865c24', 'FINCA CINCO ESTRELLAS', generar_slug_unico('FINCA CINCO ESTRELLAS', 'e1263e9e-0bac-4760-af86-894554865c24'), (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'), 'Lebrija', (select id from veredas where municipio = 'Lebrija' and slug = 'panorama'), 'FINCA 5 ESTRELLAS VEREDA PANORAMA', 7.136666666666667, -73.30722222222222, 'Mediante la prestacion de diferentes servicios del turismo de naturaleza se busca fomentar la educacion ambiental con actividad de aviturismo involucrando a…', 'Mediante la prestacion de diferentes servicios del turismo de naturaleza se busca fomentar la educacion ambiental con actividad de aviturismo involucrando a los niños y a los visitantes a la conservacion del medio ambiente,', 'TURISMO DE NATURALEZA', '3188475949', '573188475949', 'arbey20091@hotmail.com', 'ARBEY YORDID SILVA PINZON', '1099369439-5', 'Natural', null, 'Cámara de comercio', 'NATALY RAMIREZ', 'ACTIVO', 'Dinamizadoras', 2021, '618.3 msnm', '73°18''26"', '7°8''12"', 'Actualizó', 'Se realizo visita y se actualizo ficha de verificacion', 'Sí', 'No', 'No', null, 'No', null, 'No', 'No', 'Sí', null, null, null, null, null, null, null, null, null, null, 'Sí', 'No', 'B2C', 'No', 'NO', 'Sensibilización ecológica que puede inspirar cambios en hábitos de los visitantes.', 'Participación comunitaria en actividades de la finca. -Talleres educativos con niños de la vereda', 'Modelo de negocio en crecimiento. -Empresa legalmente registrada en Cámara de Comercio y RNT', false, false, true, false, true
where not exists (select 1 from negocios where nombre = 'FINCA CINCO ESTRELLAS');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'FINCA CINCO ESTRELLAS');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'FINCA CINCO ESTRELLAS'), (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'FINCA CINCO ESTRELLAS');
insert into negocios_subcategorias (negocio_id, subcategoria_id) select (select id from negocios where nombre = 'FINCA CINCO ESTRELLAS'), id from subcategorias where slug = 'turismo-sostenible';
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'FINCA CINCO ESTRELLAS');
insert into negocios_actividades (negocio_id, actividad_productiva_id) select (select id from negocios where nombre = 'FINCA CINCO ESTRELLAS'), id from actividades_productivas where slug = 'servicios-turismo-naturaleza';
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'FINCA CINCO ESTRELLAS'), 2021, 46.33 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'FINCA CINCO ESTRELLAS'), 2022, 46.63 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'FINCA CINCO ESTRELLAS'), 2023, 46.63 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'FINCA CINCO ESTRELLAS'), 2024, 64.3 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'FINCA CINCO ESTRELLAS'), 2025, 66.7 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;

-- VINO VILLA DON REY
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'),
  municipio = 'Suratá',
  vereda_id = (select id from veredas where municipio = 'Suratá' and slug = 'bachiga'),
  direccion = 'FINCA VILLA SARITA, SURATA VERDE BACHIGA',
  latitud = 7.370792499999999,
  longitud = -72.98573833333333,
  descripcion_corta = 'Elaboración de  bebidas fermentadas como vinos de  agras, mora, uva y naranja. Finca que además presta servicios de posada "Villa Sarita"  con una flora…',
  descripcion = 'Elaboración de  bebidas fermentadas como vinos de  agras, mora, uva y naranja. Finca que además presta servicios de posada "Villa Sarita"  con una flora nativa de la región haciendo que sea un lugar auténtico y de descanso.',
  producto = 'ELABORACIÓN DE VINOS: MORA, UVAS, AGRAS Y NARANJA',
  telefono = '3132439099',
  whatsapp = '573132439099',
  email = 'reinaldo.jerez@hotmail.com',
  representante_legal = 'REINALDO JEREZ',
  nit = '91342009-4',
  naturaleza_juridica = 'Natural',
  delegado = null,
  rut_camara_comercio = 'Cámara de comercio',
  responsable_cdmb = 'KAREN CAMACHO',
  novedad = 'ACTIVO',
  tipo_negocio_verde = 'Dinamizadoras',
  anio_registro = 2021,
  cota_msnm = '1851.6msnm',
  este = '72°59''8.658"',
  norte = '7°22''14.853"',
  aplicacion_ficha_2025 = 'Actualizó',
  observaciones = 'Se realizo visita y se aplico ficha de verificacion',
  registro_nacional_turismo = null,
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
  fortalezas_ambiental = 'SI, No se utilizan materiales peligrosos y/o tóxicos en los procesos.
-Para el proceso de producción se  reutilizan las botellas de vidrio – Esterilizándolas.',
  fortalezas_social = 'Campañas de consumo consciente y en armonía con la naturaleza en la escuela de la vereda.',
  fortalezas_economico = 'Tiene claro algunos costos y gastos pero no la totalidad de operación del negocio.',
  emprendimiento_verde = true,
  sello_marca = false,
  avalado = false,
  destacado = false,
  activo = true
where nombre = 'VINO VILLA DON REY';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select '308718f0-da2d-4976-b4d0-3157f9882825', 'VINO VILLA DON REY', generar_slug_unico('VINO VILLA DON REY', '308718f0-da2d-4976-b4d0-3157f9882825'), (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'), 'Suratá', (select id from veredas where municipio = 'Suratá' and slug = 'bachiga'), 'FINCA VILLA SARITA, SURATA VERDE BACHIGA', 7.370792499999999, -72.98573833333333, 'Elaboración de  bebidas fermentadas como vinos de  agras, mora, uva y naranja. Finca que además presta servicios de posada "Villa Sarita"  con una flora…', 'Elaboración de  bebidas fermentadas como vinos de  agras, mora, uva y naranja. Finca que además presta servicios de posada "Villa Sarita"  con una flora nativa de la región haciendo que sea un lugar auténtico y de descanso.', 'ELABORACIÓN DE VINOS: MORA, UVAS, AGRAS Y NARANJA', '3132439099', '573132439099', 'reinaldo.jerez@hotmail.com', 'REINALDO JEREZ', '91342009-4', 'Natural', null, 'Cámara de comercio', 'KAREN CAMACHO', 'ACTIVO', 'Dinamizadoras', 2021, '1851.6msnm', '72°59''8.658"', '7°22''14.853"', 'Actualizó', 'Se realizo visita y se aplico ficha de verificacion', null, 'No', 'No', null, null, null, 'No', 'No', 'Sí', null, null, null, 'No', null, null, 'No', null, null, null, null, 'No', 'B2C', 'No', 'NO', 'SI, No se utilizan materiales peligrosos y/o tóxicos en los procesos.
-Para el proceso de producción se  reutilizan las botellas de vidrio – Esterilizándolas.', 'Campañas de consumo consciente y en armonía con la naturaleza en la escuela de la vereda.', 'Tiene claro algunos costos y gastos pero no la totalidad de operación del negocio.', true, false, false, false, true
where not exists (select 1 from negocios where nombre = 'VINO VILLA DON REY');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'VINO VILLA DON REY');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'VINO VILLA DON REY'), (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'VINO VILLA DON REY');
insert into negocios_subcategorias (negocio_id, subcategoria_id) select (select id from negocios where nombre = 'VINO VILLA DON REY'), id from subcategorias where slug = 'agroindustria-sostenible';
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'VINO VILLA DON REY');
insert into negocios_actividades (negocio_id, actividad_productiva_id) select (select id from negocios where nombre = 'VINO VILLA DON REY'), id from actividades_productivas where slug = 'agroindustrial-alimentario';
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'VINO VILLA DON REY'), 2021, 58.01 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'VINO VILLA DON REY'), 2022, 58.01 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'VINO VILLA DON REY'), 2023, 58.01 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'VINO VILLA DON REY'), 2024, 55.5 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'VINO VILLA DON REY'), 2025, 57.0 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;

-- ASOCIACION DE  MUJERES  UNIDAS CONSTRUYENDO FUTURO ASOMUCOF
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'pendiente-clasificar'),
  municipio = 'Matanza',
  vereda_id = null,
  direccion = 'Carrera 6 N. 3 – 24 Barrio Santa Cruz de la colina',
  latitud = 7.065555555555555,
  longitud = null,
  descripcion_corta = null,
  descripcion = null,
  producto = 'FRUTAS Y HORTALIZAS',
  telefono = '3042134867',
  whatsapp = '573042134867',
  email = 'asomucof@gmail.com',
  representante_legal = 'KATERINE RODRIGUEZ GUERRERO',
  nit = '900030208- 8',
  naturaleza_juridica = null,
  delegado = null,
  rut_camara_comercio = null,
  responsable_cdmb = null,
  novedad = 'RETIRADO',
  tipo_negocio_verde = 'Satisfactorio',
  anio_registro = 2018,
  cota_msnm = null,
  este = '73°73''24"',
  norte = '7°3''56"',
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
where nombre = 'ASOCIACION DE  MUJERES  UNIDAS CONSTRUYENDO FUTURO ASOMUCOF';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select '8491e36d-5e39-4493-8ca1-d7e7fd524be6', 'ASOCIACION DE  MUJERES  UNIDAS CONSTRUYENDO FUTURO ASOMUCOF', generar_slug_unico('ASOCIACION DE  MUJERES  UNIDAS CONSTRUYENDO FUTURO ASOMUCOF', '8491e36d-5e39-4493-8ca1-d7e7fd524be6'), (select id from categorias_oficiales where slug = 'pendiente-clasificar'), 'Matanza', null, 'Carrera 6 N. 3 – 24 Barrio Santa Cruz de la colina', 7.065555555555555, null, null, null, 'FRUTAS Y HORTALIZAS', '3042134867', '573042134867', 'asomucof@gmail.com', 'KATERINE RODRIGUEZ GUERRERO', '900030208- 8', null, null, null, null, 'RETIRADO', 'Satisfactorio', 2018, null, '73°73''24"', '7°3''56"', null, 'Continua en el programa', null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, true, false, false, false, false
where not exists (select 1 from negocios where nombre = 'ASOCIACION DE  MUJERES  UNIDAS CONSTRUYENDO FUTURO ASOMUCOF');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'ASOCIACION DE  MUJERES  UNIDAS CONSTRUYENDO FUTURO ASOMUCOF');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'ASOCIACION DE  MUJERES  UNIDAS CONSTRUYENDO FUTURO ASOMUCOF'), (select id from categorias_oficiales where slug = 'pendiente-clasificar');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'ASOCIACION DE  MUJERES  UNIDAS CONSTRUYENDO FUTURO ASOMUCOF');
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'ASOCIACION DE  MUJERES  UNIDAS CONSTRUYENDO FUTURO ASOMUCOF');
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'ASOCIACION DE  MUJERES  UNIDAS CONSTRUYENDO FUTURO ASOMUCOF'), 2021, 58.09 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'ASOCIACION DE  MUJERES  UNIDAS CONSTRUYENDO FUTURO ASOMUCOF'), 2022, 58.44 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;

-- AROSANTURBAN - ASOCIACION DE AROMATICAS SANTURBAN
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'ecoproductos-industriales'),
  municipio = 'Vetas',
  vereda_id = null,
  direccion = 'FINCA BUENOS AIRES, VEREDA EL MORTIÑO',
  latitud = 7.311388888888889,
  longitud = -72.87083333333332,
  descripcion_corta = 'Somos un emprendimiento que se encarga de producir plantas aromáticas de manera orgánica para transformarlo en infusión, de esta manera generamos empleo en…',
  descripcion = 'Somos un emprendimiento que se encarga de producir plantas aromáticas de manera orgánica para transformarlo en infusión, de esta manera generamos empleo en nuestra región y queremos dar a conocer el producto a nivel nacional',
  producto = 'AROMÁTICAS',
  telefono = '3214949808',
  whatsapp = '573214949808',
  email = 'asociaciondearomaticas@outlook.com / yulimoreno80@gmail.com',
  representante_legal = 'OMAIRA SUAREZ SUAREZ',
  nit = '900915839-4',
  naturaleza_juridica = null,
  delegado = null,
  rut_camara_comercio = null,
  responsable_cdmb = 'SILVIA GARCIA',
  novedad = 'RETIRADO',
  tipo_negocio_verde = 'Inicial',
  anio_registro = 2019,
  cota_msnm = '3.629 msnm',
  este = '72°52''15''''',
  norte = '7°18''41''''',
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
where nombre = 'AROSANTURBAN - ASOCIACION DE AROMATICAS SANTURBAN';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select '71445637-d018-4fa5-9bf0-558b88b36733', 'AROSANTURBAN - ASOCIACION DE AROMATICAS SANTURBAN', generar_slug_unico('AROSANTURBAN - ASOCIACION DE AROMATICAS SANTURBAN', '71445637-d018-4fa5-9bf0-558b88b36733'), (select id from categorias_oficiales where slug = 'ecoproductos-industriales'), 'Vetas', null, 'FINCA BUENOS AIRES, VEREDA EL MORTIÑO', 7.311388888888889, -72.87083333333332, 'Somos un emprendimiento que se encarga de producir plantas aromáticas de manera orgánica para transformarlo en infusión, de esta manera generamos empleo en…', 'Somos un emprendimiento que se encarga de producir plantas aromáticas de manera orgánica para transformarlo en infusión, de esta manera generamos empleo en nuestra región y queremos dar a conocer el producto a nivel nacional', 'AROMÁTICAS', '3214949808', '573214949808', 'asociaciondearomaticas@outlook.com / yulimoreno80@gmail.com', 'OMAIRA SUAREZ SUAREZ', '900915839-4', null, null, null, 'SILVIA GARCIA', 'RETIRADO', 'Inicial', 2019, '3.629 msnm', '72°52''15''''', '7°18''41''''', null, 'Continua en el programa', null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, true, false, false, false, false
where not exists (select 1 from negocios where nombre = 'AROSANTURBAN - ASOCIACION DE AROMATICAS SANTURBAN');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'AROSANTURBAN - ASOCIACION DE AROMATICAS SANTURBAN');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'AROSANTURBAN - ASOCIACION DE AROMATICAS SANTURBAN'), (select id from categorias_oficiales where slug = 'ecoproductos-industriales');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'AROSANTURBAN - ASOCIACION DE AROMATICAS SANTURBAN');
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'AROSANTURBAN - ASOCIACION DE AROMATICAS SANTURBAN');
insert into negocios_actividades (negocio_id, actividad_productiva_id) select (select id from negocios where nombre = 'AROSANTURBAN - ASOCIACION DE AROMATICAS SANTURBAN'), id from actividades_productivas where slug = 'aprovechamiento-residuos-organicos';
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'AROSANTURBAN - ASOCIACION DE AROMATICAS SANTURBAN'), 2021, 22.22 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'AROSANTURBAN - ASOCIACION DE AROMATICAS SANTURBAN'), 2022, 30.88 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'AROSANTURBAN - ASOCIACION DE AROMATICAS SANTURBAN'), 2023, 36.1 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;

-- AGRO FERTIL REY S.A.S.
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'),
  municipio = 'Bucaramanga',
  vereda_id = (select id from veredas where municipio = 'Bucaramanga' and slug = 'vijagual'),
  direccion = 'CRA 34 # 35-29 APTO 605 BARRIO EL PRADO',
  latitud = 7.194444444444445,
  longitud = -73.1286111111111,
  descripcion_corta = 'e implementa un modelo de economia circular, mediante  la recoleccion  de residuos organicos (pollinaza), que a traves de un proceso de transformacion es…',
  descripcion = 'e implementa un modelo de economia circular, mediante  la recoleccion  de residuos organicos (pollinaza), que a traves de un proceso de transformacion es convertido en fertilizante organico mineral, aportando  nutrientes para una mejor produccion, mejorando las caracteristicas quimicas, fisicas, biologicas, y activando la actividad microbiana de la tierra. De esta manera,  se aporta a brindar un espacio libre de contaminacion, a la reutilizacion de materiales, y a una produccion limpia.',
  producto = 'FERTILIZANTE ORGANICO',
  telefono = '6300842 - 3118262750',
  whatsapp = '6300842 - 3118262750',
  email = 'fertilrey@hotmail.com',
  representante_legal = 'REINALDO GÓMEZ NAVAS',
  nit = '901617740-0',
  naturaleza_juridica = null,
  delegado = null,
  rut_camara_comercio = null,
  responsable_cdmb = 'ALEXANDRA SOTOMONTE',
  novedad = 'SUSPENDIDO',
  tipo_negocio_verde = 'Inicial',
  anio_registro = 2019,
  cota_msnm = null,
  este = '73°07''43''''',
  norte = '7°11''40''''',
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
where nombre = 'AGRO FERTIL REY S.A.S.';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select 'ab83c847-71d5-4712-beba-dd650757e657', 'AGRO FERTIL REY S.A.S.', generar_slug_unico('AGRO FERTIL REY S.A.S.', 'ab83c847-71d5-4712-beba-dd650757e657'), (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'), 'Bucaramanga', (select id from veredas where municipio = 'Bucaramanga' and slug = 'vijagual'), 'CRA 34 # 35-29 APTO 605 BARRIO EL PRADO', 7.194444444444445, -73.1286111111111, 'e implementa un modelo de economia circular, mediante  la recoleccion  de residuos organicos (pollinaza), que a traves de un proceso de transformacion es…', 'e implementa un modelo de economia circular, mediante  la recoleccion  de residuos organicos (pollinaza), que a traves de un proceso de transformacion es convertido en fertilizante organico mineral, aportando  nutrientes para una mejor produccion, mejorando las caracteristicas quimicas, fisicas, biologicas, y activando la actividad microbiana de la tierra. De esta manera,  se aporta a brindar un espacio libre de contaminacion, a la reutilizacion de materiales, y a una produccion limpia.', 'FERTILIZANTE ORGANICO', '6300842 - 3118262750', '6300842 - 3118262750', 'fertilrey@hotmail.com', 'REINALDO GÓMEZ NAVAS', '901617740-0', null, null, null, 'ALEXANDRA SOTOMONTE', 'SUSPENDIDO', 'Inicial', 2019, null, '73°07''43''''', '7°11''40''''', null, 'Continua en el programa', null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, false, false, true, false, false
where not exists (select 1 from negocios where nombre = 'AGRO FERTIL REY S.A.S.');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'AGRO FERTIL REY S.A.S.');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'AGRO FERTIL REY S.A.S.'), (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'AGRO FERTIL REY S.A.S.');
insert into negocios_subcategorias (negocio_id, subcategoria_id) select (select id from negocios where nombre = 'AGRO FERTIL REY S.A.S.'), id from subcategorias where slug = 'agrosistemas-sostenibles';
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'AGRO FERTIL REY S.A.S.');
insert into negocios_actividades (negocio_id, actividad_productiva_id) select (select id from negocios where nombre = 'AGRO FERTIL REY S.A.S.'), id from actividades_productivas where slug = 'agricultura-organica';
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'AGRO FERTIL REY S.A.S.'), 2022, 48.8 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'AGRO FERTIL REY S.A.S.'), 2023, 51.57 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;

-- ASOCIACIÓN DE TRABAJADORES PRODUCTORES Y COMERCIALIZADORES AGROPECUARIOS DE BERLÍN - ASOPROCAB
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'pendiente-clasificar'),
  municipio = 'Tona',
  vereda_id = null,
  direccion = 'Carrera 6 No. 4- 17',
  latitud = 7.1877099,
  longitud = -72.8746247,
  descripcion_corta = null,
  descripcion = null,
  producto = 'CEBOLLA',
  telefono = '3168560101',
  whatsapp = '573168560101',
  email = 'arnolvg11@gmail.com',
  representante_legal = 'ARNOL VILLAMIZAR GARCÍA',
  nit = '900283682-1',
  naturaleza_juridica = null,
  delegado = null,
  rut_camara_comercio = null,
  responsable_cdmb = 'JUAN JOSE',
  novedad = 'RETIRADO',
  tipo_negocio_verde = null,
  anio_registro = 2018,
  cota_msnm = '3405 msnm',
  este = '72.8746247',
  norte = '7.1877099',
  aplicacion_ficha_2025 = null,
  observaciones = 'Suspendidos',
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
where nombre = 'ASOCIACIÓN DE TRABAJADORES PRODUCTORES Y COMERCIALIZADORES AGROPECUARIOS DE BERLÍN - ASOPROCAB';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select '8286cc53-fe0a-4e8f-bd2e-219b6f51251c', 'ASOCIACIÓN DE TRABAJADORES PRODUCTORES Y COMERCIALIZADORES AGROPECUARIOS DE BERLÍN - ASOPROCAB', generar_slug_unico('ASOCIACIÓN DE TRABAJADORES PRODUCTORES Y COMERCIALIZADORES AGROPECUARIOS DE BERLÍN - ASOPROCAB', '8286cc53-fe0a-4e8f-bd2e-219b6f51251c'), (select id from categorias_oficiales where slug = 'pendiente-clasificar'), 'Tona', null, 'Carrera 6 No. 4- 17', 7.1877099, -72.8746247, null, null, 'CEBOLLA', '3168560101', '573168560101', 'arnolvg11@gmail.com', 'ARNOL VILLAMIZAR GARCÍA', '900283682-1', null, null, null, 'JUAN JOSE', 'RETIRADO', null, 2018, '3405 msnm', '72.8746247', '7.1877099', null, 'Suspendidos', null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, true, false, false, false, false
where not exists (select 1 from negocios where nombre = 'ASOCIACIÓN DE TRABAJADORES PRODUCTORES Y COMERCIALIZADORES AGROPECUARIOS DE BERLÍN - ASOPROCAB');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'ASOCIACIÓN DE TRABAJADORES PRODUCTORES Y COMERCIALIZADORES AGROPECUARIOS DE BERLÍN - ASOPROCAB');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'ASOCIACIÓN DE TRABAJADORES PRODUCTORES Y COMERCIALIZADORES AGROPECUARIOS DE BERLÍN - ASOPROCAB'), (select id from categorias_oficiales where slug = 'pendiente-clasificar');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'ASOCIACIÓN DE TRABAJADORES PRODUCTORES Y COMERCIALIZADORES AGROPECUARIOS DE BERLÍN - ASOPROCAB');
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'ASOCIACIÓN DE TRABAJADORES PRODUCTORES Y COMERCIALIZADORES AGROPECUARIOS DE BERLÍN - ASOPROCAB');

-- ABONOS INTEGRALES MI GRANJA LIMITADA ABIMGRA LTDA
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'ecoproductos-industriales'),
  municipio = 'Girón',
  vereda_id = (select id from veredas where municipio = 'Girón' and slug = 'chocoita'),
  direccion = 'KM 9 VIA GIRON - ZAPATOCA, CALLE 22 #10-37',
  latitud = 6.984166666666667,
  longitud = -73.16833333333334,
  descripcion_corta = 'Producir, comprar,  vender, representar, agenciar, distribuir abonos, insecticidas  y fungicidas,   naturales   y/o artificiales,  y   todo lo relacionado…',
  descripcion = 'Producir, comprar,  vender, representar, agenciar, distribuir abonos, insecticidas  y fungicidas,   naturales   y/o artificiales,  y   todo lo relacionado con insumos  agricolas.',
  producto = 'COMPUESTO ABIMGRA',
  telefono = '3207034764',
  whatsapp = '573207034764',
  email = 'contabilidad@abimgra.com',
  representante_legal = 'JESUS MARIA SERRANO PRADA',
  nit = '800048670-4',
  naturaleza_juridica = 'Jurídica',
  delegado = 'MILTON HERNÁNDEZ',
  rut_camara_comercio = 'Cámara de comercio',
  responsable_cdmb = 'SEBASTIAN BONNET',
  novedad = 'ACTIVO',
  tipo_negocio_verde = 'Dinamizadoras',
  anio_registro = 2016,
  cota_msnm = '826 msnm',
  este = '73°10''6''''',
  norte = '6°59''3''''',
  aplicacion_ficha_2025 = 'Actualizó',
  observaciones = 'Se realizo visita y se aplico ficha de verificacion',
  registro_nacional_turismo = null,
  uso_suelo = 'Sí',
  concesion_aguas = 'Acueducto veredal',
  concesion_aguas_vencimiento = null,
  vertimientos = null,
  vertimientos_vencimiento = null,
  pueaa = 'Sí',
  pgris = 'Sí',
  pozo_septico = 'No',
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
  fortalezas_ambiental = 'Reduccion de la contaminacion , reduccion de la presion sobre el suelo',
  fortalezas_social = 'Apoyo a comedores comunitarios - Campañas mejoramiento de vivienda',
  fortalezas_economico = 'Empresa con excelentes estados financieros , empresa con una organización solida y con una trayectoria de muchos años en el mercado',
  emprendimiento_verde = false,
  sello_marca = true,
  avalado = true,
  destacado = false,
  activo = true
where nombre = 'ABONOS INTEGRALES MI GRANJA LIMITADA ABIMGRA LTDA';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select '2b3f41cc-5632-4dc9-9c15-169f4d6db28c', 'ABONOS INTEGRALES MI GRANJA LIMITADA ABIMGRA LTDA', generar_slug_unico('ABONOS INTEGRALES MI GRANJA LIMITADA ABIMGRA LTDA', '2b3f41cc-5632-4dc9-9c15-169f4d6db28c'), (select id from categorias_oficiales where slug = 'ecoproductos-industriales'), 'Girón', (select id from veredas where municipio = 'Girón' and slug = 'chocoita'), 'KM 9 VIA GIRON - ZAPATOCA, CALLE 22 #10-37', 6.984166666666667, -73.16833333333334, 'Producir, comprar,  vender, representar, agenciar, distribuir abonos, insecticidas  y fungicidas,   naturales   y/o artificiales,  y   todo lo relacionado…', 'Producir, comprar,  vender, representar, agenciar, distribuir abonos, insecticidas  y fungicidas,   naturales   y/o artificiales,  y   todo lo relacionado con insumos  agricolas.', 'COMPUESTO ABIMGRA', '3207034764', '573207034764', 'contabilidad@abimgra.com', 'JESUS MARIA SERRANO PRADA', '800048670-4', 'Jurídica', 'MILTON HERNÁNDEZ', 'Cámara de comercio', 'SEBASTIAN BONNET', 'ACTIVO', 'Dinamizadoras', 2016, '826 msnm', '73°10''6''''', '6°59''3''''', 'Actualizó', 'Se realizo visita y se aplico ficha de verificacion', null, 'Sí', 'Acueducto veredal', null, null, null, 'Sí', 'Sí', 'No', 'Sí', 'Sí', null, null, null, null, null, null, null, null, null, 'Sí', 'Mixta', 'No', 'NO', 'Reduccion de la contaminacion , reduccion de la presion sobre el suelo', 'Apoyo a comedores comunitarios - Campañas mejoramiento de vivienda', 'Empresa con excelentes estados financieros , empresa con una organización solida y con una trayectoria de muchos años en el mercado', false, true, true, false, true
where not exists (select 1 from negocios where nombre = 'ABONOS INTEGRALES MI GRANJA LIMITADA ABIMGRA LTDA');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'ABONOS INTEGRALES MI GRANJA LIMITADA ABIMGRA LTDA');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'ABONOS INTEGRALES MI GRANJA LIMITADA ABIMGRA LTDA'), (select id from categorias_oficiales where slug = 'ecoproductos-industriales');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'ABONOS INTEGRALES MI GRANJA LIMITADA ABIMGRA LTDA');
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'ABONOS INTEGRALES MI GRANJA LIMITADA ABIMGRA LTDA');
insert into negocios_actividades (negocio_id, actividad_productiva_id) select (select id from negocios where nombre = 'ABONOS INTEGRALES MI GRANJA LIMITADA ABIMGRA LTDA'), id from actividades_productivas where slug = 'aprovechamiento-residuos-organicos';
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'ABONOS INTEGRALES MI GRANJA LIMITADA ABIMGRA LTDA'), 2020, 72.5 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'ABONOS INTEGRALES MI GRANJA LIMITADA ABIMGRA LTDA'), 2021, 72.5 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'ABONOS INTEGRALES MI GRANJA LIMITADA ABIMGRA LTDA'), 2022, 72.16 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'ABONOS INTEGRALES MI GRANJA LIMITADA ABIMGRA LTDA'), 2023, 73.45 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'ABONOS INTEGRALES MI GRANJA LIMITADA ABIMGRA LTDA'), 2024, 82.9 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'ABONOS INTEGRALES MI GRANJA LIMITADA ABIMGRA LTDA'), 2025, 88.8 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;

-- ARTEMISA
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'pendiente-clasificar'),
  municipio = 'Lebrija',
  vereda_id = null,
  direccion = 'Altos de Cataluña T4 Apto 504',
  latitud = null,
  longitud = null,
  descripcion_corta = null,
  descripcion = null,
  producto = 'ARTESANÍAS',
  telefono = '317 4703565',
  whatsapp = '317 4703565',
  email = 'kmichelamaya21@gmail.com',
  representante_legal = 'KAREN MICHEL AMAYA FRANCO',
  nit = null,
  naturaleza_juridica = null,
  delegado = null,
  rut_camara_comercio = null,
  responsable_cdmb = null,
  novedad = 'INACTIVO',
  tipo_negocio_verde = null,
  anio_registro = 2022,
  cota_msnm = null,
  este = null,
  norte = null,
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
where nombre = 'ARTEMISA';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select '49fdca50-d23b-4f9b-8770-747fdcc85635', 'ARTEMISA', generar_slug_unico('ARTEMISA', '49fdca50-d23b-4f9b-8770-747fdcc85635'), (select id from categorias_oficiales where slug = 'pendiente-clasificar'), 'Lebrija', null, 'Altos de Cataluña T4 Apto 504', null, null, null, null, 'ARTESANÍAS', '317 4703565', '317 4703565', 'kmichelamaya21@gmail.com', 'KAREN MICHEL AMAYA FRANCO', null, null, null, null, null, 'INACTIVO', null, 2022, null, null, null, null, 'Revisión si aplica retiro', null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, true, false, false, false, false
where not exists (select 1 from negocios where nombre = 'ARTEMISA');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'ARTEMISA');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'ARTEMISA'), (select id from categorias_oficiales where slug = 'pendiente-clasificar');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'ARTEMISA');
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'ARTEMISA');

-- ASOCIACIÓN MUNICIPAL DE MUJERES CAMPESINAS DE VETAS AMUCAVE
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'),
  municipio = 'Vetas',
  vereda_id = (select id from veredas where municipio = 'Vetas' and slug = 'la-chorrera'),
  direccion = 'FINCA LA LOMITA VEREDA LA CHORRERA MUNICIPIO DE VETAS',
  latitud = 7.3213888888888885,
  longitud = -72.90305555555557,
  descripcion_corta = 'Crianza de la abeja miellitius para la producción de miel de abeja en ecosistema de paramo de alta montaña. La miel es envasada y dispuesta para…',
  descripcion = 'Crianza de la abeja miellitius para la producción de miel de abeja en ecosistema de paramo de alta montaña. La miel es envasada y dispuesta para comercialización a nivel regional.',
  producto = 'MIEL DE ABEJAS',
  telefono = '313 4927707',
  whatsapp = '313 4927707',
  email = 'rosmaria1.@hotmail.es / Asociacionamucave@gmail.com',
  representante_legal = 'DIANA ABIGAIL LANDAZABAL GALVIS',
  nit = '804010044-3',
  naturaleza_juridica = 'Jurídica',
  delegado = null,
  rut_camara_comercio = 'Cámara de comercio y RUT',
  responsable_cdmb = null,
  novedad = 'ACTIVO',
  tipo_negocio_verde = 'Intermedio',
  anio_registro = 2019,
  cota_msnm = '2.657 msnm',
  este = '72°54''11''''',
  norte = '7°19''17''''',
  aplicacion_ficha_2025 = 'No actualizó',
  observaciones = 'No se realizo visita ni se actualizo ficha de verificacion',
  registro_nacional_turismo = null,
  uso_suelo = 'No',
  concesion_aguas = null,
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
  buenas_practicas_apicolas = 'No',
  registro_apicola = 'No',
  intervencion_cauce = null,
  capacidad_carga = null,
  sstt = 'No',
  canal_venta = 'B2C',
  exportacion = null,
  huella_carbono = null,
  fortalezas_ambiental = 'Protección y conservación de las abejas como eje fundamental de ecosistemas',
  fortalezas_social = 'Asociación de mujeres campesinas',
  fortalezas_economico = null,
  emprendimiento_verde = true,
  sello_marca = false,
  avalado = false,
  destacado = false,
  activo = true
where nombre = 'ASOCIACIÓN MUNICIPAL DE MUJERES CAMPESINAS DE VETAS AMUCAVE';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select 'd9a7bf1b-9a18-49b9-93e0-45154ee230cd', 'ASOCIACIÓN MUNICIPAL DE MUJERES CAMPESINAS DE VETAS AMUCAVE', generar_slug_unico('ASOCIACIÓN MUNICIPAL DE MUJERES CAMPESINAS DE VETAS AMUCAVE', 'd9a7bf1b-9a18-49b9-93e0-45154ee230cd'), (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'), 'Vetas', (select id from veredas where municipio = 'Vetas' and slug = 'la-chorrera'), 'FINCA LA LOMITA VEREDA LA CHORRERA MUNICIPIO DE VETAS', 7.3213888888888885, -72.90305555555557, 'Crianza de la abeja miellitius para la producción de miel de abeja en ecosistema de paramo de alta montaña. La miel es envasada y dispuesta para…', 'Crianza de la abeja miellitius para la producción de miel de abeja en ecosistema de paramo de alta montaña. La miel es envasada y dispuesta para comercialización a nivel regional.', 'MIEL DE ABEJAS', '313 4927707', '313 4927707', 'rosmaria1.@hotmail.es / Asociacionamucave@gmail.com', 'DIANA ABIGAIL LANDAZABAL GALVIS', '804010044-3', 'Jurídica', null, 'Cámara de comercio y RUT', null, 'ACTIVO', 'Intermedio', 2019, '2.657 msnm', '72°54''11''''', '7°19''17''''', 'No actualizó', 'No se realizo visita ni se actualizo ficha de verificacion', null, 'No', null, null, null, null, 'No', 'No', null, 'Sí', null, null, null, null, null, null, 'No', 'No', null, null, 'No', 'B2C', null, null, 'Protección y conservación de las abejas como eje fundamental de ecosistemas', 'Asociación de mujeres campesinas', null, true, false, false, false, true
where not exists (select 1 from negocios where nombre = 'ASOCIACIÓN MUNICIPAL DE MUJERES CAMPESINAS DE VETAS AMUCAVE');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'ASOCIACIÓN MUNICIPAL DE MUJERES CAMPESINAS DE VETAS AMUCAVE');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'ASOCIACIÓN MUNICIPAL DE MUJERES CAMPESINAS DE VETAS AMUCAVE'), (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'ASOCIACIÓN MUNICIPAL DE MUJERES CAMPESINAS DE VETAS AMUCAVE');
insert into negocios_subcategorias (negocio_id, subcategoria_id) select (select id from negocios where nombre = 'ASOCIACIÓN MUNICIPAL DE MUJERES CAMPESINAS DE VETAS AMUCAVE'), id from subcategorias where slug = 'biocomercio';
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'ASOCIACIÓN MUNICIPAL DE MUJERES CAMPESINAS DE VETAS AMUCAVE');
insert into negocios_actividades (negocio_id, actividad_productiva_id) select (select id from negocios where nombre = 'ASOCIACIÓN MUNICIPAL DE MUJERES CAMPESINAS DE VETAS AMUCAVE'), id from actividades_productivas where slug = 'productos-fauna-silvestre';
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'ASOCIACIÓN MUNICIPAL DE MUJERES CAMPESINAS DE VETAS AMUCAVE'), 2020, 49.39 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'ASOCIACIÓN MUNICIPAL DE MUJERES CAMPESINAS DE VETAS AMUCAVE'), 2021, 54.0 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'ASOCIACIÓN MUNICIPAL DE MUJERES CAMPESINAS DE VETAS AMUCAVE'), 2022, 53.88 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'ASOCIACIÓN MUNICIPAL DE MUJERES CAMPESINAS DE VETAS AMUCAVE'), 2023, 53.88 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'ASOCIACIÓN MUNICIPAL DE MUJERES CAMPESINAS DE VETAS AMUCAVE'), 2024, 49.6 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;

-- SANTANDER BIKE RIDES
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'),
  municipio = 'Bucaramanga',
  vereda_id = null,
  direccion = 'CARRERA 8 NÚMERO 25-16 PISO 2 LAGOS I',
  latitud = null,
  longitud = null,
  descripcion_corta = null,
  descripcion = null,
  producto = 'VIVERO',
  telefono = '300 7872298',
  whatsapp = '300 7872298',
  email = 'santanderbikerides@gmail.com',
  representante_legal = 'RICHARD BECERRA',
  nit = null,
  naturaleza_juridica = null,
  delegado = null,
  rut_camara_comercio = null,
  responsable_cdmb = 'SILVIA GARCIA',
  novedad = 'SUSPENDIDO',
  tipo_negocio_verde = 'Inicial',
  anio_registro = 2020,
  cota_msnm = null,
  este = null,
  norte = null,
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
where nombre = 'SANTANDER BIKE RIDES';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select '30f2ffc4-755d-4d06-9b9e-b0369e1aeae1', 'SANTANDER BIKE RIDES', generar_slug_unico('SANTANDER BIKE RIDES', '30f2ffc4-755d-4d06-9b9e-b0369e1aeae1'), (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'), 'Bucaramanga', null, 'CARRERA 8 NÚMERO 25-16 PISO 2 LAGOS I', null, null, null, null, 'VIVERO', '300 7872298', '300 7872298', 'santanderbikerides@gmail.com', 'RICHARD BECERRA', null, null, null, null, 'SILVIA GARCIA', 'SUSPENDIDO', 'Inicial', 2020, null, null, null, null, 'Emprendimiento', null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, true, false, false, false, false
where not exists (select 1 from negocios where nombre = 'SANTANDER BIKE RIDES');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'SANTANDER BIKE RIDES');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'SANTANDER BIKE RIDES'), (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'SANTANDER BIKE RIDES');
insert into negocios_subcategorias (negocio_id, subcategoria_id) select (select id from negocios where nombre = 'SANTANDER BIKE RIDES'), id from subcategorias where slug = 'agrosistemas-sostenibles';
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'SANTANDER BIKE RIDES');
insert into negocios_actividades (negocio_id, actividad_productiva_id) select (select id from negocios where nombre = 'SANTANDER BIKE RIDES'), id from actividades_productivas where slug = 'agroecologia';

-- MARIALACITOS
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'ecoproductos-industriales'),
  municipio = 'Lebrija',
  vereda_id = (select id from veredas where municipio = 'Lebrija' and slug = 'san-gabriel'),
  direccion = 'VEREDA SAN GABRIEL LOTE 2 FINCA LA ORLANDA - LEBRIJA',
  latitud = 7.118811388888888,
  longitud = -73.1190761111111,
  descripcion_corta = 'Fárica de confección de bolsos ecológicos.',
  descripcion = 'Fárica de confección de bolsos ecológicos.',
  producto = 'ELABORACIÓN DE BOLSOS Y OTROS CON TELA ECOLÓGICA.',
  telefono = '3195509843',
  whatsapp = '573195509843',
  email = 'nidiarocioespitiajimenez@gmail.com',
  representante_legal = 'NIDIA ROCIO ESPITIA JIMENEZ',
  nit = '63351755-7',
  naturaleza_juridica = 'Natural',
  delegado = null,
  rut_camara_comercio = 'Cámara de comercio',
  responsable_cdmb = 'SUJEY DÍAZ',
  novedad = 'ACTIVO',
  tipo_negocio_verde = 'Satisfactorio',
  anio_registro = 2021,
  cota_msnm = '978.1',
  este = '73°7''8.674''''',
  norte = '7°7''7.721''''',
  aplicacion_ficha_2025 = 'Actualizó',
  observaciones = 'Se realizo visita y se actualizo ficha de verificacion',
  registro_nacional_turismo = null,
  uso_suelo = null,
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
  fortalezas_ambiental = 'Genera impacto positivo  al dar manejo adecuado  de los residuos generados de su actividad  comercial  utilizando telas amigables con el medio ambiente.',
  fortalezas_social = 'Su actividad   tiene una línea con el lema muñecos de apego , participa en diferentes eventos liderados por  el Gobierno, donde ella participa e impulsa a la mujer artesana a salir adelante.  La empresaria tiene un enfoque de mujer empoderada  y la responsabilidad social inicia con su proyecto en donde participa en diferentes  ferias, simposios, colaboración con  universidades  y ONG`s.',
  fortalezas_economico = 'Lleva documentado registros de costos y gastos, un control.',
  emprendimiento_verde = false,
  sello_marca = false,
  avalado = true,
  destacado = false,
  activo = true
where nombre = 'MARIALACITOS';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select '9b49f6aa-4f0b-4e0e-8999-c58bebd15bf2', 'MARIALACITOS', generar_slug_unico('MARIALACITOS', '9b49f6aa-4f0b-4e0e-8999-c58bebd15bf2'), (select id from categorias_oficiales where slug = 'ecoproductos-industriales'), 'Lebrija', (select id from veredas where municipio = 'Lebrija' and slug = 'san-gabriel'), 'VEREDA SAN GABRIEL LOTE 2 FINCA LA ORLANDA - LEBRIJA', 7.118811388888888, -73.1190761111111, 'Fárica de confección de bolsos ecológicos.', 'Fárica de confección de bolsos ecológicos.', 'ELABORACIÓN DE BOLSOS Y OTROS CON TELA ECOLÓGICA.', '3195509843', '573195509843', 'nidiarocioespitiajimenez@gmail.com', 'NIDIA ROCIO ESPITIA JIMENEZ', '63351755-7', 'Natural', null, 'Cámara de comercio', 'SUJEY DÍAZ', 'ACTIVO', 'Satisfactorio', 2021, '978.1', '73°7''8.674''''', '7°7''7.721''''', 'Actualizó', 'Se realizo visita y se actualizo ficha de verificacion', null, null, 'Acueducto veredal', null, null, null, 'No', 'No', null, 'Sí', null, null, null, null, null, null, null, null, null, null, 'No', 'B2C', 'No', 'NO', 'Genera impacto positivo  al dar manejo adecuado  de los residuos generados de su actividad  comercial  utilizando telas amigables con el medio ambiente.', 'Su actividad   tiene una línea con el lema muñecos de apego , participa en diferentes eventos liderados por  el Gobierno, donde ella participa e impulsa a la mujer artesana a salir adelante.  La empresaria tiene un enfoque de mujer empoderada  y la responsabilidad social inicia con su proyecto en donde participa en diferentes  ferias, simposios, colaboración con  universidades  y ONG`s.', 'Lleva documentado registros de costos y gastos, un control.', false, false, true, false, true
where not exists (select 1 from negocios where nombre = 'MARIALACITOS');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'MARIALACITOS');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'MARIALACITOS'), (select id from categorias_oficiales where slug = 'ecoproductos-industriales');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'MARIALACITOS');
insert into negocios_subcategorias (negocio_id, subcategoria_id) select (select id from negocios where nombre = 'MARIALACITOS'), id from subcategorias where slug = 'moda-sostenible';
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'MARIALACITOS');
insert into negocios_actividades (negocio_id, actividad_productiva_id) select (select id from negocios where nombre = 'MARIALACITOS'), id from actividades_productivas where slug = 'confeccion-manufactura';
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'MARIALACITOS'), 2024, 61.2 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'MARIALACITOS'), 2025, 69.3 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;

-- PRODUCTORA PISCÍCOLA EMPEZAR S.A.S. - BIC
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'),
  municipio = 'Piedecuesta',
  vereda_id = (select id from veredas where municipio = 'Piedecuesta' and slug = 'monterredondo'),
  direccion = 'FINCA MIRADOR DEL VALLE, VEREDA MONTEREDONDO',
  latitud = 6.955,
  longitud = -73.09527777777777,
  descripcion_corta = 'Empresa dedicada a la produccion de tilapia roja a traves de un sistema con tecnologia simbiotica a traves de fermentos vivos',
  descripcion = 'Empresa dedicada a la produccion de tilapia roja a traves de un sistema con tecnologia simbiotica a traves de fermentos vivos',
  producto = 'TILAPIA ROJA',
  telefono = '305 3533609',
  whatsapp = '305 3533609',
  email = 'empezar.sas.bic@gmail.com',
  representante_legal = 'LUCY PEREZ CACERES',
  nit = '901586518-6',
  naturaleza_juridica = 'Jurídica',
  delegado = null,
  rut_camara_comercio = 'Cámara de comercio',
  responsable_cdmb = 'ANDRES VALDERRAMA',
  novedad = 'RETIRADO',
  tipo_negocio_verde = 'Dinamizadoras',
  anio_registro = 2020,
  cota_msnm = '1037.9 msnm',
  este = '73°5''43''''',
  norte = '6°57''18''''',
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
where nombre = 'PRODUCTORA PISCÍCOLA EMPEZAR S.A.S. - BIC';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select 'cb0dc59c-8186-495d-8d23-69878f3d1aaa', 'PRODUCTORA PISCÍCOLA EMPEZAR S.A.S. - BIC', generar_slug_unico('PRODUCTORA PISCÍCOLA EMPEZAR S.A.S. - BIC', 'cb0dc59c-8186-495d-8d23-69878f3d1aaa'), (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'), 'Piedecuesta', (select id from veredas where municipio = 'Piedecuesta' and slug = 'monterredondo'), 'FINCA MIRADOR DEL VALLE, VEREDA MONTEREDONDO', 6.955, -73.09527777777777, 'Empresa dedicada a la produccion de tilapia roja a traves de un sistema con tecnologia simbiotica a traves de fermentos vivos', 'Empresa dedicada a la produccion de tilapia roja a traves de un sistema con tecnologia simbiotica a traves de fermentos vivos', 'TILAPIA ROJA', '305 3533609', '305 3533609', 'empezar.sas.bic@gmail.com', 'LUCY PEREZ CACERES', '901586518-6', 'Jurídica', null, 'Cámara de comercio', 'ANDRES VALDERRAMA', 'RETIRADO', 'Dinamizadoras', 2020, '1037.9 msnm', '73°5''43''''', '6°57''18''''', 'No actualizó', 'No se realizo visita ni actualizo ficha de verificacion', null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, true, false, false, false, false
where not exists (select 1 from negocios where nombre = 'PRODUCTORA PISCÍCOLA EMPEZAR S.A.S. - BIC');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'PRODUCTORA PISCÍCOLA EMPEZAR S.A.S. - BIC');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'PRODUCTORA PISCÍCOLA EMPEZAR S.A.S. - BIC'), (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'PRODUCTORA PISCÍCOLA EMPEZAR S.A.S. - BIC');
insert into negocios_subcategorias (negocio_id, subcategoria_id) select (select id from negocios where nombre = 'PRODUCTORA PISCÍCOLA EMPEZAR S.A.S. - BIC'), id from subcategorias where slug = 'agroindustria-sostenible';
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'PRODUCTORA PISCÍCOLA EMPEZAR S.A.S. - BIC');
insert into negocios_actividades (negocio_id, actividad_productiva_id) select (select id from negocios where nombre = 'PRODUCTORA PISCÍCOLA EMPEZAR S.A.S. - BIC'), id from actividades_productivas where slug = 'agroindustrial-alimentario';
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'PRODUCTORA PISCÍCOLA EMPEZAR S.A.S. - BIC'), 2023, 40.02 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'PRODUCTORA PISCÍCOLA EMPEZAR S.A.S. - BIC'), 2024, 51.0 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;

-- AMUPROSEVILLA
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'pendiente-clasificar'),
  municipio = 'Girón',
  vereda_id = null,
  direccion = 'Piedecuesta',
  latitud = null,
  longitud = null,
  descripcion_corta = null,
  descripcion = null,
  producto = null,
  telefono = '3213362129',
  whatsapp = '573213362129',
  email = 'nellyortegacampos@gmail.com',
  representante_legal = 'NELLY ORTEGA',
  nit = null,
  naturaleza_juridica = null,
  delegado = null,
  rut_camara_comercio = null,
  responsable_cdmb = null,
  novedad = 'RETIRADO',
  tipo_negocio_verde = null,
  anio_registro = 2020,
  cota_msnm = null,
  este = null,
  norte = null,
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
where nombre = 'AMUPROSEVILLA';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select 'f1e50692-d366-40b4-99c6-cae3918ba207', 'AMUPROSEVILLA', generar_slug_unico('AMUPROSEVILLA', 'f1e50692-d366-40b4-99c6-cae3918ba207'), (select id from categorias_oficiales where slug = 'pendiente-clasificar'), 'Girón', null, 'Piedecuesta', null, null, null, null, null, '3213362129', '573213362129', 'nellyortegacampos@gmail.com', 'NELLY ORTEGA', null, null, null, null, null, 'RETIRADO', null, 2020, null, null, null, null, 'Revisión si aplica retiro', null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, true, false, false, false, false
where not exists (select 1 from negocios where nombre = 'AMUPROSEVILLA');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'AMUPROSEVILLA');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'AMUPROSEVILLA'), (select id from categorias_oficiales where slug = 'pendiente-clasificar');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'AMUPROSEVILLA');
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'AMUPROSEVILLA');

-- OSCAR EDUARDO TRUJILLO - FRESAS DEL PARAMO
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'),
  municipio = 'Tona',
  vereda_id = null,
  direccion = 'Carrera 8 n 61-175 Metrópolis 3 Torre 2 Interior 1 Apto 503',
  latitud = 7.117944444444444,
  longitud = -72.91419444444445,
  descripcion_corta = null,
  descripcion = null,
  producto = 'FRESAS',
  telefono = '3007450218 - 3015494574',
  whatsapp = '3007450218 - 3015494574',
  email = 'otrujillo06@yahoo.com',
  representante_legal = 'OSCAR EDUARDO TRUJILLO',
  nit = '1098721345',
  naturaleza_juridica = null,
  delegado = null,
  rut_camara_comercio = null,
  responsable_cdmb = 'ALEXANDRA SOTOMONTE',
  novedad = 'RETIRADO',
  tipo_negocio_verde = 'Inicial',
  anio_registro = 2021,
  cota_msnm = '3.423 msnm',
  este = '72°54''51,1''''',
  norte = '7°7''4,6''''',
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
where nombre = 'OSCAR EDUARDO TRUJILLO - FRESAS DEL PARAMO';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select '9fdbfb9a-fb63-4026-929d-2c5077fb6160', 'OSCAR EDUARDO TRUJILLO - FRESAS DEL PARAMO', generar_slug_unico('OSCAR EDUARDO TRUJILLO - FRESAS DEL PARAMO', '9fdbfb9a-fb63-4026-929d-2c5077fb6160'), (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'), 'Tona', null, 'Carrera 8 n 61-175 Metrópolis 3 Torre 2 Interior 1 Apto 503', 7.117944444444444, -72.91419444444445, null, null, 'FRESAS', '3007450218 - 3015494574', '3007450218 - 3015494574', 'otrujillo06@yahoo.com', 'OSCAR EDUARDO TRUJILLO', '1098721345', null, null, null, 'ALEXANDRA SOTOMONTE', 'RETIRADO', 'Inicial', 2021, '3.423 msnm', '72°54''51,1''''', '7°7''4,6''''', null, 'Continua en el programa', null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, true, false, false, false, false
where not exists (select 1 from negocios where nombre = 'OSCAR EDUARDO TRUJILLO - FRESAS DEL PARAMO');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'OSCAR EDUARDO TRUJILLO - FRESAS DEL PARAMO');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'OSCAR EDUARDO TRUJILLO - FRESAS DEL PARAMO'), (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'OSCAR EDUARDO TRUJILLO - FRESAS DEL PARAMO');
insert into negocios_subcategorias (negocio_id, subcategoria_id) select (select id from negocios where nombre = 'OSCAR EDUARDO TRUJILLO - FRESAS DEL PARAMO'), id from subcategorias where slug = 'agroindustria-sostenible';
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'OSCAR EDUARDO TRUJILLO - FRESAS DEL PARAMO');
insert into negocios_actividades (negocio_id, actividad_productiva_id) select (select id from negocios where nombre = 'OSCAR EDUARDO TRUJILLO - FRESAS DEL PARAMO'), id from actividades_productivas where slug = 'agroindustrial-no-alimentario';


commit;
