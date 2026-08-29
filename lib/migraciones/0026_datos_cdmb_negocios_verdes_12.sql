begin;

-- Generado por lib/migraciones/generar_0026.py desde BASE_ACTUALIZADA_NV_ka.xlsx — no editar a mano.
-- Uno de varios archivos partidos (ver README.md) — correr TODOS, en cualquier orden, cada uno es su propia transacción.

-- Parte 12 de 17.

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

-- AGRONATUREX J'S
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'),
  municipio = 'Floridablanca',
  vereda_id = (select id from veredas where municipio = 'Floridablanca' and slug = 'perimetro-urbano'),
  direccion = 'ANILLO VIAL KM 5,5 VIA GIRON',
  latitud = 7.065555555555555,
  longitud = null,
  descripcion_corta = 'Producción y comercialización de suplementos alimenticios  para toda clase  de animales,  así como productos para aplicaciones agrícolas, pecuarias,…',
  descripcion = 'Producción y comercialización de suplementos alimenticios  para toda clase  de animales,  así como productos para aplicaciones agrícolas, pecuarias, veterinarias, forestales,   industriales  y domésticas.',
  producto = 'AGRONATUREX TERNERO',
  telefono = '3208397662',
  whatsapp = '573208397662',
  email = 'agronaturex@gmail.com',
  representante_legal = 'JOSEPH JUSCELINO BADILLO SANTODOMINGO',
  nit = '900342045-3',
  naturaleza_juridica = 'Jurídica',
  delegado = null,
  rut_camara_comercio = 'Cámara de comercio y RUT',
  responsable_cdmb = 'ANDRES VALDERRAMA',
  novedad = 'SUSPENDIDO',
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
  alcantarillado = 'No',
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
  exportacion = null,
  huella_carbono = null,
  fortalezas_ambiental = 'Reforestación en especial cerca de fuentes hídricas. Restauración de propiedades del suelo.',
  fortalezas_social = 'Charlas sobre el cuidado del medio ambiente. Grupo de HSEQ donde fomentan uso racional de recursos no renovables. Integración y personal calificado de apoyo.',
  fortalezas_economico = 'Implementación rutas de mercadeo. Empresa legalmente registrada en cámara de comercio y RUT. Actualización en facturación y normas reglamentarias.',
  emprendimiento_verde = true,
  sello_marca = false,
  avalado = false,
  destacado = false,
  activo = false
where nombre = 'AGRONATUREX J''S';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select '503c3b8b-b558-4b2e-83e4-5de82c3277ef', 'AGRONATUREX J''S', generar_slug_unico('AGRONATUREX J''S', '503c3b8b-b558-4b2e-83e4-5de82c3277ef'), (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'), 'Floridablanca', (select id from veredas where municipio = 'Floridablanca' and slug = 'perimetro-urbano'), 'ANILLO VIAL KM 5,5 VIA GIRON', 7.065555555555555, null, 'Producción y comercialización de suplementos alimenticios  para toda clase  de animales,  así como productos para aplicaciones agrícolas, pecuarias,…', 'Producción y comercialización de suplementos alimenticios  para toda clase  de animales,  así como productos para aplicaciones agrícolas, pecuarias, veterinarias, forestales,   industriales  y domésticas.', 'AGRONATUREX TERNERO', '3208397662', '573208397662', 'agronaturex@gmail.com', 'JOSEPH JUSCELINO BADILLO SANTODOMINGO', '900342045-3', 'Jurídica', null, 'Cámara de comercio y RUT', 'ANDRES VALDERRAMA', 'SUSPENDIDO', 'Dinamizadoras', 2023, null, '73°73''24"', '7°3''56"', 'Actualizó', 'Se realizo visita y se actualizo ficha de verificacion', null, 'Sí', null, null, null, null, 'No', 'No', 'No', 'No', 'No', null, null, null, null, null, null, null, null, null, 'No', 'Mixta', null, null, 'Reforestación en especial cerca de fuentes hídricas. Restauración de propiedades del suelo.', 'Charlas sobre el cuidado del medio ambiente. Grupo de HSEQ donde fomentan uso racional de recursos no renovables. Integración y personal calificado de apoyo.', 'Implementación rutas de mercadeo. Empresa legalmente registrada en cámara de comercio y RUT. Actualización en facturación y normas reglamentarias.', true, false, false, false, false
where not exists (select 1 from negocios where nombre = 'AGRONATUREX J''S');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'AGRONATUREX J''S');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'AGRONATUREX J''S'), (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'AGRONATUREX J''S');
insert into negocios_subcategorias (negocio_id, subcategoria_id) select (select id from negocios where nombre = 'AGRONATUREX J''S'), id from subcategorias where slug = 'agroindustria-sostenible';
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'AGRONATUREX J''S');
insert into negocios_actividades (negocio_id, actividad_productiva_id) select (select id from negocios where nombre = 'AGRONATUREX J''S'), id from actividades_productivas where slug = 'agroindustrial-no-alimentario';
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'AGRONATUREX J''S'), 2023, 55.88 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'AGRONATUREX J''S'), 2024, 60.4 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'AGRONATUREX J''S'), 2025, 66.9 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;

-- APICOLA SANTA LUCÍA
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'),
  municipio = 'Piedecuesta',
  vereda_id = (select id from veredas where municipio = 'Piedecuesta' and slug = 'el-duende'),
  direccion = 'VEREDA EL DUENDE PIEDECUESTA',
  latitud = null,
  longitud = null,
  descripcion_corta = 'Rescate de enjambres, polinizacion de cultivos y venta de miel',
  descripcion = 'Rescate de enjambres, polinizacion de cultivos y venta de miel',
  producto = 'MIEL DE ABEJAS',
  telefono = '3163993608',
  whatsapp = '573163993608',
  email = 'apicolasantalucia@gmail.com',
  representante_legal = 'JAIME RESTREPO DIAZ',
  nit = '1019017065-3',
  naturaleza_juridica = 'Natural',
  delegado = null,
  rut_camara_comercio = 'Cámara de comercio',
  responsable_cdmb = 'ANA RUEDA',
  novedad = 'ACTIVO',
  tipo_negocio_verde = 'Intermedio',
  anio_registro = 2023,
  cota_msnm = null,
  este = null,
  norte = null,
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
  fortalezas_ambiental = 'Rescatan enjambres de abejas que reporta la comunidad, para su conservacion y cuidado, y aportan a la polinizacion de cultivos',
  fortalezas_social = 'Realizan campañas donde promueven estilos de vida y consumo conciente, por sus redes sociales en el cuidado y conservacion de las abejas, y el consumo de la miel como endualzante natural',
  fortalezas_economico = 'Tiene detallado los costos y gastos en que incurre en la operación del negocio en un excel',
  emprendimiento_verde = true,
  sello_marca = false,
  avalado = false,
  destacado = false,
  activo = true
where nombre = 'APICOLA SANTA LUCÍA';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select '5301aee0-6f06-4050-817e-821558d4b11d', 'APICOLA SANTA LUCÍA', generar_slug_unico('APICOLA SANTA LUCÍA', '5301aee0-6f06-4050-817e-821558d4b11d'), (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'), 'Piedecuesta', (select id from veredas where municipio = 'Piedecuesta' and slug = 'el-duende'), 'VEREDA EL DUENDE PIEDECUESTA', null, null, 'Rescate de enjambres, polinizacion de cultivos y venta de miel', 'Rescate de enjambres, polinizacion de cultivos y venta de miel', 'MIEL DE ABEJAS', '3163993608', '573163993608', 'apicolasantalucia@gmail.com', 'JAIME RESTREPO DIAZ', '1019017065-3', 'Natural', null, 'Cámara de comercio', 'ANA RUEDA', 'ACTIVO', 'Intermedio', 2023, null, null, null, 'Actualizó', 'Se realizo visita y se actualizo ficha de verificacion', null, 'No', 'No', null, null, null, 'No', 'No', 'No', null, null, null, 'No', null, null, null, 'No', 'No', null, null, 'No', 'B2C', 'No', null, 'Rescatan enjambres de abejas que reporta la comunidad, para su conservacion y cuidado, y aportan a la polinizacion de cultivos', 'Realizan campañas donde promueven estilos de vida y consumo conciente, por sus redes sociales en el cuidado y conservacion de las abejas, y el consumo de la miel como endualzante natural', 'Tiene detallado los costos y gastos en que incurre en la operación del negocio en un excel', true, false, false, false, true
where not exists (select 1 from negocios where nombre = 'APICOLA SANTA LUCÍA');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'APICOLA SANTA LUCÍA');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'APICOLA SANTA LUCÍA'), (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'APICOLA SANTA LUCÍA');
insert into negocios_subcategorias (negocio_id, subcategoria_id) select (select id from negocios where nombre = 'APICOLA SANTA LUCÍA'), id from subcategorias where slug = 'agroindustria-sostenible';
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'APICOLA SANTA LUCÍA');
insert into negocios_actividades (negocio_id, actividad_productiva_id) select (select id from negocios where nombre = 'APICOLA SANTA LUCÍA'), id from actividades_productivas where slug = 'agroindustrial-alimentario';
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'APICOLA SANTA LUCÍA'), 2025, 35.5 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;

-- VELASKA
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'),
  municipio = 'Floridablanca',
  vereda_id = (select id from veredas where municipio = 'Floridablanca' and slug = 'perimetro-urbano'),
  direccion = 'CARRERA 22 # 57 -  145',
  latitud = 7.0714,
  longitud = -73.11132222222221,
  descripcion_corta = 'Producción y comercialización de velas a base de cera de soya, con esencias orgánicas y sin colorantes.',
  descripcion = 'Producción y comercialización de velas a base de cera de soya, con esencias orgánicas y sin colorantes.',
  producto = 'VELAS AROMÁTICAS DE CERA DE SOYA',
  telefono = '3125225585',
  whatsapp = '573125225585',
  email = 'karolay2.6@hotmail.com',
  representante_legal = 'KAROLAY CORZO RAMIREZ',
  nit = '1098804427-1',
  naturaleza_juridica = 'Natural',
  delegado = null,
  rut_camara_comercio = 'Cámara de comercio y RUT',
  responsable_cdmb = 'CRISTAL VILLAREAL',
  novedad = 'ACTIVO',
  tipo_negocio_verde = null,
  anio_registro = 2023,
  cota_msnm = '861 msnm',
  este = '73°6''40,76"',
  norte = '7°4''17,04"',
  aplicacion_ficha_2025 = 'Actualizó',
  observaciones = 'Se realizo visita y se aplico ficha de verificacion',
  registro_nacional_turismo = null,
  uso_suelo = null,
  concesion_aguas = 'Acueducto',
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
  canal_venta = 'Mixta',
  exportacion = null,
  huella_carbono = null,
  fortalezas_ambiental = 'Producto biodegradable no tóxico. Reducción de residuos – economía circular',
  fortalezas_social = 'Educación del consumidor.',
  fortalezas_economico = 'Ventaja competitiva clara. Reducción de costos a largo plazo.',
  emprendimiento_verde = false,
  sello_marca = false,
  avalado = true,
  destacado = false,
  activo = true
where nombre = 'VELASKA';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select 'b615daf5-3a89-4669-bf5c-7fb980dce2ea', 'VELASKA', generar_slug_unico('VELASKA', 'b615daf5-3a89-4669-bf5c-7fb980dce2ea'), (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'), 'Floridablanca', (select id from veredas where municipio = 'Floridablanca' and slug = 'perimetro-urbano'), 'CARRERA 22 # 57 -  145', 7.0714, -73.11132222222221, 'Producción y comercialización de velas a base de cera de soya, con esencias orgánicas y sin colorantes.', 'Producción y comercialización de velas a base de cera de soya, con esencias orgánicas y sin colorantes.', 'VELAS AROMÁTICAS DE CERA DE SOYA', '3125225585', '573125225585', 'karolay2.6@hotmail.com', 'KAROLAY CORZO RAMIREZ', '1098804427-1', 'Natural', null, 'Cámara de comercio y RUT', 'CRISTAL VILLAREAL', 'ACTIVO', null, 2023, '861 msnm', '73°6''40,76"', '7°4''17,04"', 'Actualizó', 'Se realizo visita y se aplico ficha de verificacion', null, null, 'Acueducto', null, null, null, 'No', 'No', 'No', 'Sí', null, null, null, null, null, null, null, null, null, null, 'No', 'Mixta', null, null, 'Producto biodegradable no tóxico. Reducción de residuos – economía circular', 'Educación del consumidor.', 'Ventaja competitiva clara. Reducción de costos a largo plazo.', false, false, true, false, true
where not exists (select 1 from negocios where nombre = 'VELASKA');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'VELASKA');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'VELASKA'), (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'VELASKA');
insert into negocios_subcategorias (negocio_id, subcategoria_id) select (select id from negocios where nombre = 'VELASKA'), id from subcategorias where slug = 'agroindustria-sostenible';
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'VELASKA');
insert into negocios_actividades (negocio_id, actividad_productiva_id) select (select id from negocios where nombre = 'VELASKA'), id from actividades_productivas where slug = 'agroindustrial-no-alimentario';
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'VELASKA'), 2024, 53.4 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'VELASKA'), 2025, 53.0 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;

-- AGRO CULTIVOS LA COLINA
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'),
  municipio = 'Rionegro',
  vereda_id = (select id from veredas where municipio = 'Rionegro' and slug = 'portachuelo'),
  direccion = 'FINCA LA COLINA ("BALNEARIO EL PORTAL)',
  latitud = 7.3357383333333335,
  longitud = -73.16161333333334,
  descripcion_corta = 'Cultivo de cacao ecológico y elaboración de chocolate de mesa en bola de manera artesanal',
  descripcion = 'Cultivo de cacao ecológico y elaboración de chocolate de mesa en bola de manera artesanal',
  producto = 'CHOCOLATE DE MESA EN BOLA DE MANERA ARTESANAL',
  telefono = '3213728507',
  whatsapp = '573213728507',
  email = 'puntoagroambiental@gmail.com',
  representante_legal = 'JOHAN  MANUEL LATORRE RUIZ',
  nit = '1098721869-4',
  naturaleza_juridica = 'Natural',
  delegado = 'OSCAR ORTIZ BALLESTEROS',
  rut_camara_comercio = 'Cámara de comercio',
  responsable_cdmb = 'KAREN CAMACHO',
  novedad = 'ACTIVO',
  tipo_negocio_verde = 'Dinamizadoras',
  anio_registro = 2024,
  cota_msnm = '814.9 msnm',
  este = '(-)73°9''41.808"',
  norte = '7°20''8.658"',
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
  pozo_septico = null,
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
  fortalezas_ambiental = 'SI,Sistemas agroforestales, cercas vivas, fertilización orgánica, proceso artesanal, entre otros.
- No se utilizan materiales peligrosos y/o tóxicos en los procesos
- Los sacos de fique se reutilizan.
-20 lámparas solares',
  fortalezas_social = 'Generación de empleos - campesinos de la zona (Bonos extras).
-Proveedor verde –abonos Abimbra LTDA',
  fortalezas_economico = 'Al producto consideran el total de los costos y gastos del negocio',
  emprendimiento_verde = true,
  sello_marca = false,
  avalado = false,
  destacado = false,
  activo = true
where nombre = 'AGRO CULTIVOS LA COLINA';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select '75a40dd6-7daa-4826-a05b-5cc3b5025e29', 'AGRO CULTIVOS LA COLINA', generar_slug_unico('AGRO CULTIVOS LA COLINA', '75a40dd6-7daa-4826-a05b-5cc3b5025e29'), (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'), 'Rionegro', (select id from veredas where municipio = 'Rionegro' and slug = 'portachuelo'), 'FINCA LA COLINA ("BALNEARIO EL PORTAL)', 7.3357383333333335, -73.16161333333334, 'Cultivo de cacao ecológico y elaboración de chocolate de mesa en bola de manera artesanal', 'Cultivo de cacao ecológico y elaboración de chocolate de mesa en bola de manera artesanal', 'CHOCOLATE DE MESA EN BOLA DE MANERA ARTESANAL', '3213728507', '573213728507', 'puntoagroambiental@gmail.com', 'JOHAN  MANUEL LATORRE RUIZ', '1098721869-4', 'Natural', 'OSCAR ORTIZ BALLESTEROS', 'Cámara de comercio', 'KAREN CAMACHO', 'ACTIVO', 'Dinamizadoras', 2024, '814.9 msnm', '(-)73°9''41.808"', '7°20''8.658"', 'Actualizó', 'Se realizo visita y se aplico ficha de verificacion', null, 'No', 'Acueducto veredal', null, null, null, 'No', 'No', null, null, null, null, 'No', null, null, 'No', null, null, null, null, 'No', 'B2C', 'No', 'NO', 'SI,Sistemas agroforestales, cercas vivas, fertilización orgánica, proceso artesanal, entre otros.
- No se utilizan materiales peligrosos y/o tóxicos en los procesos
- Los sacos de fique se reutilizan.
-20 lámparas solares', 'Generación de empleos - campesinos de la zona (Bonos extras).
-Proveedor verde –abonos Abimbra LTDA', 'Al producto consideran el total de los costos y gastos del negocio', true, false, false, false, true
where not exists (select 1 from negocios where nombre = 'AGRO CULTIVOS LA COLINA');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'AGRO CULTIVOS LA COLINA');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'AGRO CULTIVOS LA COLINA'), (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'AGRO CULTIVOS LA COLINA');
insert into negocios_subcategorias (negocio_id, subcategoria_id) select (select id from negocios where nombre = 'AGRO CULTIVOS LA COLINA'), id from subcategorias where slug = 'agroindustria-sostenible';
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'AGRO CULTIVOS LA COLINA');
insert into negocios_actividades (negocio_id, actividad_productiva_id) select (select id from negocios where nombre = 'AGRO CULTIVOS LA COLINA'), id from actividades_productivas where slug = 'agroindustrial-alimentario';
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'AGRO CULTIVOS LA COLINA'), 2024, 48.9 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'AGRO CULTIVOS LA COLINA'), 2025, 48.9 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;

-- INGENIERÍA Y TRANSFORMACIÓN DE RESIDUOS PLÁSTICOS SAS - INGECOPLAST SAS
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'ecoproductos-industriales'),
  municipio = 'Floridablanca',
  vereda_id = (select id from veredas where municipio = 'Floridablanca' and slug = 'perimetro-urbano'),
  direccion = 'KM 1 VIA PIEDECUESTA - SECTOR LA SIDRA POR LA ENTRADA DEL ESTADIO DE FLORIDABLANCA',
  latitud = null,
  longitud = null,
  descripcion_corta = 'Recolección, almacenamiento y transformación de residuos aprovechables como plástico y pets para fabricar madera plástica',
  descripcion = 'Recolección, almacenamiento y transformación de residuos aprovechables como plástico y pets para fabricar madera plástica',
  producto = 'MADERA PLÁSTICA',
  telefono = '3125052744-3138179496',
  whatsapp = '3125052744-3138179496',
  email = 'ingecoplast@gmail.com',
  representante_legal = 'NICOLAS TORRES TURMEQUÉ',
  nit = '901754943-4',
  naturaleza_juridica = 'Jurídica',
  delegado = 'MARIO CASTAÑEDA',
  rut_camara_comercio = 'Cámara de comercio',
  responsable_cdmb = 'CLAUDIA SANCHEZ',
  novedad = 'ACTIVO',
  tipo_negocio_verde = 'Dinamizadoras',
  anio_registro = 2024,
  cota_msnm = '944.0 msnm',
  este = '73°0803748',
  norte = '7°04997069',
  aplicacion_ficha_2025 = 'Actualizó',
  observaciones = 'Se realizo visita y se aplico ficha de verificacion',
  registro_nacional_turismo = null,
  uso_suelo = null,
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
  fortalezas_ambiental = 'SI, Con la actividad económica ejercida se evitan que los residuos de plásticos contaminen las fuentes hídricas y afecte la fauna. -Promoviendo la vida útil - economía circular',
  fortalezas_social = 'Generación de empleo local a madres cabezas de hogar y hombres en condición de desempleo. -Promueve el reciclaje  en armonía con la naturaleza: UTS y Col Agustiniano  y centro comercial 4ta etapa-Proveedor verde GVR',
  fortalezas_economico = 'Cuenta con estados financieros o sistema contable y los utiliza para análisis y toma de decisiones.- 3era Feria R de negocios verdes CDMB 2024',
  emprendimiento_verde = false,
  sello_marca = false,
  avalado = true,
  destacado = false,
  activo = true
where nombre = 'INGENIERÍA Y TRANSFORMACIÓN DE RESIDUOS PLÁSTICOS SAS - INGECOPLAST SAS';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select 'faed136c-002a-4ad6-b324-8924821e5b39', 'INGENIERÍA Y TRANSFORMACIÓN DE RESIDUOS PLÁSTICOS SAS - INGECOPLAST SAS', generar_slug_unico('INGENIERÍA Y TRANSFORMACIÓN DE RESIDUOS PLÁSTICOS SAS - INGECOPLAST SAS', 'faed136c-002a-4ad6-b324-8924821e5b39'), (select id from categorias_oficiales where slug = 'ecoproductos-industriales'), 'Floridablanca', (select id from veredas where municipio = 'Floridablanca' and slug = 'perimetro-urbano'), 'KM 1 VIA PIEDECUESTA - SECTOR LA SIDRA POR LA ENTRADA DEL ESTADIO DE FLORIDABLANCA', null, null, 'Recolección, almacenamiento y transformación de residuos aprovechables como plástico y pets para fabricar madera plástica', 'Recolección, almacenamiento y transformación de residuos aprovechables como plástico y pets para fabricar madera plástica', 'MADERA PLÁSTICA', '3125052744-3138179496', '3125052744-3138179496', 'ingecoplast@gmail.com', 'NICOLAS TORRES TURMEQUÉ', '901754943-4', 'Jurídica', 'MARIO CASTAÑEDA', 'Cámara de comercio', 'CLAUDIA SANCHEZ', 'ACTIVO', 'Dinamizadoras', 2024, '944.0 msnm', '73°0803748', '7°04997069', 'Actualizó', 'Se realizo visita y se aplico ficha de verificacion', null, null, 'Acueducto', null, null, null, 'No', 'Sí', null, 'Sí', null, null, null, null, null, null, null, null, null, null, 'Sí', 'B2B', 'No', 'NO', 'SI, Con la actividad económica ejercida se evitan que los residuos de plásticos contaminen las fuentes hídricas y afecte la fauna. -Promoviendo la vida útil - economía circular', 'Generación de empleo local a madres cabezas de hogar y hombres en condición de desempleo. -Promueve el reciclaje  en armonía con la naturaleza: UTS y Col Agustiniano  y centro comercial 4ta etapa-Proveedor verde GVR', 'Cuenta con estados financieros o sistema contable y los utiliza para análisis y toma de decisiones.- 3era Feria R de negocios verdes CDMB 2024', false, false, true, false, true
where not exists (select 1 from negocios where nombre = 'INGENIERÍA Y TRANSFORMACIÓN DE RESIDUOS PLÁSTICOS SAS - INGECOPLAST SAS');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'INGENIERÍA Y TRANSFORMACIÓN DE RESIDUOS PLÁSTICOS SAS - INGECOPLAST SAS');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'INGENIERÍA Y TRANSFORMACIÓN DE RESIDUOS PLÁSTICOS SAS - INGECOPLAST SAS'), (select id from categorias_oficiales where slug = 'ecoproductos-industriales');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'INGENIERÍA Y TRANSFORMACIÓN DE RESIDUOS PLÁSTICOS SAS - INGECOPLAST SAS');
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'INGENIERÍA Y TRANSFORMACIÓN DE RESIDUOS PLÁSTICOS SAS - INGECOPLAST SAS');
insert into negocios_actividades (negocio_id, actividad_productiva_id) select (select id from negocios where nombre = 'INGENIERÍA Y TRANSFORMACIÓN DE RESIDUOS PLÁSTICOS SAS - INGECOPLAST SAS'), id from actividades_productivas where slug = 'aprovechamiento-residuos-inorganicos';
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'INGENIERÍA Y TRANSFORMACIÓN DE RESIDUOS PLÁSTICOS SAS - INGECOPLAST SAS'), 2024, 53.4 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'INGENIERÍA Y TRANSFORMACIÓN DE RESIDUOS PLÁSTICOS SAS - INGECOPLAST SAS'), 2025, 74.2 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;

-- IZHE
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'pendiente-clasificar'),
  municipio = 'Bucaramanga',
  vereda_id = (select id from veredas where municipio = 'Bucaramanga' and slug = 'perimetro-urbano'),
  direccion = null,
  latitud = null,
  longitud = null,
  descripcion_corta = null,
  descripcion = null,
  producto = 'JABONES ARTESANALES',
  telefono = '3103160352',
  whatsapp = '573103160352',
  email = 'milef4_2@hotmail.com',
  representante_legal = 'ANA MILENA MEDINA SUÁREZ',
  nit = null,
  naturaleza_juridica = null,
  delegado = null,
  rut_camara_comercio = null,
  responsable_cdmb = 'XIMENA REYES',
  novedad = 'SUSPENDIDO',
  tipo_negocio_verde = 'Inicial',
  anio_registro = 2024,
  cota_msnm = null,
  este = null,
  norte = null,
  aplicacion_ficha_2025 = 'No actualizó',
  observaciones = 'No se realizo visita ni se aplico ficha de verificacion',
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
where nombre = 'IZHE';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select '0e9ad6b5-2776-48b4-90a3-60b49edb9b65', 'IZHE', generar_slug_unico('IZHE', '0e9ad6b5-2776-48b4-90a3-60b49edb9b65'), (select id from categorias_oficiales where slug = 'pendiente-clasificar'), 'Bucaramanga', (select id from veredas where municipio = 'Bucaramanga' and slug = 'perimetro-urbano'), null, null, null, null, null, 'JABONES ARTESANALES', '3103160352', '573103160352', 'milef4_2@hotmail.com', 'ANA MILENA MEDINA SUÁREZ', null, null, null, null, 'XIMENA REYES', 'SUSPENDIDO', 'Inicial', 2024, null, null, null, 'No actualizó', 'No se realizo visita ni se aplico ficha de verificacion', null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, true, false, false, false, false
where not exists (select 1 from negocios where nombre = 'IZHE');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'IZHE');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'IZHE'), (select id from categorias_oficiales where slug = 'pendiente-clasificar');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'IZHE');
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'IZHE');
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'IZHE'), 2025, 0.0 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;

-- TEVIVO KOMBUCHA (INVERSIONES SALCAD 2026)
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'),
  municipio = 'Floridablanca',
  vereda_id = (select id from veredas where municipio = 'Floridablanca' and slug = 'perimetro-urbano'),
  direccion = 'LAB. DE BURBUJAS FELICES: ANILLO VIAL A GIRÓN 23-41 (SECTOR MAKELO MECÁNICOS)',
  latitud = null,
  longitud = null,
  descripcion_corta = 'Elaboración de bebida no pasteurizada, fermentada a base de té por medio de una colonia simbiótica de bacterias y levaduras (SCOBY).',
  descripcion = 'Elaboración de bebida no pasteurizada, fermentada a base de té por medio de una colonia simbiótica de bacterias y levaduras (SCOBY).',
  producto = 'BEBIDA DE TÉ FUNCIONAL FERMENTADA',
  telefono = '3012697720-3013714714',
  whatsapp = '3012697720-3013714714',
  email = 'info@tevivokombucha.com',
  representante_legal = 'PEDRO ALEJANDRO SALDAÑA',
  nit = '13740478-9',
  naturaleza_juridica = 'Natural',
  delegado = 'LORENA CADAVID VALENCIA',
  rut_camara_comercio = 'Cámara de comercio',
  responsable_cdmb = 'XIMENA REYES',
  novedad = 'ACTIVO',
  tipo_negocio_verde = 'Dinamizadoras',
  anio_registro = 2024,
  cota_msnm = '825.4 msnm',
  este = '73°1047232"',
  norte = '7°06346459"',
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
  invima = 'Sí',
  invima_vencimiento = '2030-09-18',
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
  fortalezas_ambiental = 'SI, Articulación con la academia para incentivar la preservación de los servicios eco sistémico por medio del consumo sostenible y economía circular.- Residuos inorgánicos se entregan a la fundación SANAR y ecorecuperadora naranja y el residuo orgánico se dona para realizar compost- Cuenta con un plan para reutilizar los envases de vidrio mediante la esterilización- Mezcladoras  especializadas optimizar el agua, purificador del aire, filtros del agua ultra filtrada (carbono) y tecnología invertir
- No se utilizan materiales peligrosos y/o tóxicos en los procesos',
  fortalezas_social = 'Generación de empleo local a adultas mayores. -Proveedores Agrícola Himalaya SA  quien patrocina la zona media de la microcuenca Bitac  y mayaguez certificados  del valle del cauca-Campañas de consumo sostenible y economía circular en la universidad UNAB y colegio gimnasio Jaibana',
  fortalezas_economico = 'Cuenta con estados financieros o sistema contable y los utiliza para análisis y toma de decisiones',
  emprendimiento_verde = false,
  sello_marca = true,
  avalado = true,
  destacado = false,
  activo = true
where nombre = 'TEVIVO KOMBUCHA (INVERSIONES SALCAD 2026)';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select '8b99681a-cfe3-410b-90a9-6cf7d82e89de', 'TEVIVO KOMBUCHA (INVERSIONES SALCAD 2026)', generar_slug_unico('TEVIVO KOMBUCHA (INVERSIONES SALCAD 2026)', '8b99681a-cfe3-410b-90a9-6cf7d82e89de'), (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'), 'Floridablanca', (select id from veredas where municipio = 'Floridablanca' and slug = 'perimetro-urbano'), 'LAB. DE BURBUJAS FELICES: ANILLO VIAL A GIRÓN 23-41 (SECTOR MAKELO MECÁNICOS)', null, null, 'Elaboración de bebida no pasteurizada, fermentada a base de té por medio de una colonia simbiótica de bacterias y levaduras (SCOBY).', 'Elaboración de bebida no pasteurizada, fermentada a base de té por medio de una colonia simbiótica de bacterias y levaduras (SCOBY).', 'BEBIDA DE TÉ FUNCIONAL FERMENTADA', '3012697720-3013714714', '3012697720-3013714714', 'info@tevivokombucha.com', 'PEDRO ALEJANDRO SALDAÑA', '13740478-9', 'Natural', 'LORENA CADAVID VALENCIA', 'Cámara de comercio', 'XIMENA REYES', 'ACTIVO', 'Dinamizadoras', 2024, '825.4 msnm', '73°1047232"', '7°06346459"', 'Actualizó', 'Se realizo visita y se aplico ficha de verificacion', null, 'Sí', null, null, null, null, 'No', 'Sí', null, 'Sí', null, null, 'Sí', '2030-09-18', null, null, null, null, null, null, 'Sí', 'Mixta', 'No', 'NO', 'SI, Articulación con la academia para incentivar la preservación de los servicios eco sistémico por medio del consumo sostenible y economía circular.- Residuos inorgánicos se entregan a la fundación SANAR y ecorecuperadora naranja y el residuo orgánico se dona para realizar compost- Cuenta con un plan para reutilizar los envases de vidrio mediante la esterilización- Mezcladoras  especializadas optimizar el agua, purificador del aire, filtros del agua ultra filtrada (carbono) y tecnología invertir
- No se utilizan materiales peligrosos y/o tóxicos en los procesos', 'Generación de empleo local a adultas mayores. -Proveedores Agrícola Himalaya SA  quien patrocina la zona media de la microcuenca Bitac  y mayaguez certificados  del valle del cauca-Campañas de consumo sostenible y economía circular en la universidad UNAB y colegio gimnasio Jaibana', 'Cuenta con estados financieros o sistema contable y los utiliza para análisis y toma de decisiones', false, true, true, false, true
where not exists (select 1 from negocios where nombre = 'TEVIVO KOMBUCHA (INVERSIONES SALCAD 2026)');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'TEVIVO KOMBUCHA (INVERSIONES SALCAD 2026)');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'TEVIVO KOMBUCHA (INVERSIONES SALCAD 2026)'), (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'TEVIVO KOMBUCHA (INVERSIONES SALCAD 2026)');
insert into negocios_subcategorias (negocio_id, subcategoria_id) select (select id from negocios where nombre = 'TEVIVO KOMBUCHA (INVERSIONES SALCAD 2026)'), id from subcategorias where slug = 'agroindustria-sostenible';
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'TEVIVO KOMBUCHA (INVERSIONES SALCAD 2026)');
insert into negocios_actividades (negocio_id, actividad_productiva_id) select (select id from negocios where nombre = 'TEVIVO KOMBUCHA (INVERSIONES SALCAD 2026)'), id from actividades_productivas where slug = 'agroindustrial-alimentario';
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'TEVIVO KOMBUCHA (INVERSIONES SALCAD 2026)'), 2024, 74.0 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'TEVIVO KOMBUCHA (INVERSIONES SALCAD 2026)'), 2025, 82.7 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;

-- ORGANICOS Y MINERALES DE COLOMBIA “ORGAMINC S.A.S”
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'),
  municipio = 'Girón',
  vereda_id = (select id from veredas where municipio = 'Girón' and slug = 'llano-grande'),
  direccion = 'VDA LLANO GRANDE FINCA ALCAZAR',
  latitud = 7.017777777777778,
  longitud = -73.16916666666667,
  descripcion_corta = 'Produccion de abono organico mineralizado a travez de gallinaza,caprinaza,bovinaza,humos,polialita,rocafosforica y azufre',
  descripcion = 'Produccion de abono organico mineralizado a travez de gallinaza,caprinaza,bovinaza,humos,polialita,rocafosforica y azufre',
  producto = 'ABONO ORGANICO MINERALES',
  telefono = '3162228189',
  whatsapp = '573162228189',
  email = 'abonosorganicosminerales@gmail.com',
  representante_legal = 'ISAIAS MORENO RIVERA',
  nit = '900416364-7',
  naturaleza_juridica = 'Jurídica',
  delegado = null,
  rut_camara_comercio = 'Cámara de comercio',
  responsable_cdmb = 'SILVIA VALDIVIESO',
  novedad = 'ACTIVO',
  tipo_negocio_verde = 'Dinamizadoras',
  anio_registro = 2024,
  cota_msnm = '752.5',
  este = '73°10''9''''',
  norte = '7°1''4''''',
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
  canal_venta = 'Mixta',
  exportacion = 'No',
  huella_carbono = 'NO',
  fortalezas_ambiental = 'Educación en el manejo ambiental. Conservación y preservación de los ecosistemas. Cuenta con ficha técnica',
  fortalezas_social = 'Capacitación a los empleados con respeto al abono. Obsequia abono a los colegios para la siembra de arboles. Ayuda a la comunidad para proyectos o eventos',
  fortalezas_economico = 'Modelo de negocio rentable. Paga a sus empleados todo lo de ley',
  emprendimiento_verde = false,
  sello_marca = false,
  avalado = true,
  destacado = false,
  activo = true
where nombre = 'ORGANICOS Y MINERALES DE COLOMBIA “ORGAMINC S.A.S”';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select 'd73888bf-58da-4c26-b11c-5c996abfddd6', 'ORGANICOS Y MINERALES DE COLOMBIA “ORGAMINC S.A.S”', generar_slug_unico('ORGANICOS Y MINERALES DE COLOMBIA “ORGAMINC S.A.S”', 'd73888bf-58da-4c26-b11c-5c996abfddd6'), (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'), 'Girón', (select id from veredas where municipio = 'Girón' and slug = 'llano-grande'), 'VDA LLANO GRANDE FINCA ALCAZAR', 7.017777777777778, -73.16916666666667, 'Produccion de abono organico mineralizado a travez de gallinaza,caprinaza,bovinaza,humos,polialita,rocafosforica y azufre', 'Produccion de abono organico mineralizado a travez de gallinaza,caprinaza,bovinaza,humos,polialita,rocafosforica y azufre', 'ABONO ORGANICO MINERALES', '3162228189', '573162228189', 'abonosorganicosminerales@gmail.com', 'ISAIAS MORENO RIVERA', '900416364-7', 'Jurídica', null, 'Cámara de comercio', 'SILVIA VALDIVIESO', 'ACTIVO', 'Dinamizadoras', 2024, '752.5', '73°10''9''''', '7°1''4''''', 'Actualizó', 'Se realizo visita y se actualizo ficha de verificacion', null, 'Sí', 'Acueducto veredal', null, null, null, 'No', 'No', 'Sí', null, 'Sí', null, null, null, null, 'No', null, null, null, null, 'Sí', 'Mixta', 'No', 'NO', 'Educación en el manejo ambiental. Conservación y preservación de los ecosistemas. Cuenta con ficha técnica', 'Capacitación a los empleados con respeto al abono. Obsequia abono a los colegios para la siembra de arboles. Ayuda a la comunidad para proyectos o eventos', 'Modelo de negocio rentable. Paga a sus empleados todo lo de ley', false, false, true, false, true
where not exists (select 1 from negocios where nombre = 'ORGANICOS Y MINERALES DE COLOMBIA “ORGAMINC S.A.S”');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'ORGANICOS Y MINERALES DE COLOMBIA “ORGAMINC S.A.S”');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'ORGANICOS Y MINERALES DE COLOMBIA “ORGAMINC S.A.S”'), (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'ORGANICOS Y MINERALES DE COLOMBIA “ORGAMINC S.A.S”');
insert into negocios_subcategorias (negocio_id, subcategoria_id) select (select id from negocios where nombre = 'ORGANICOS Y MINERALES DE COLOMBIA “ORGAMINC S.A.S”'), id from subcategorias where slug = 'agroindustria-sostenible';
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'ORGANICOS Y MINERALES DE COLOMBIA “ORGAMINC S.A.S”');
insert into negocios_actividades (negocio_id, actividad_productiva_id) select (select id from negocios where nombre = 'ORGANICOS Y MINERALES DE COLOMBIA “ORGAMINC S.A.S”'), id from actividades_productivas where slug = 'agroindustrial-no-alimentario';
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'ORGANICOS Y MINERALES DE COLOMBIA “ORGAMINC S.A.S”'), 2024, 59.1 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'ORGANICOS Y MINERALES DE COLOMBIA “ORGAMINC S.A.S”'), 2025, 70.6 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;

-- INDUSTRIAS PARBER
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'calidad-ambiental'),
  municipio = 'Floridablanca',
  vereda_id = (select id from veredas where municipio = 'Floridablanca' and slug = 'perimetro-urbano'),
  direccion = 'CARRERA 6 # 44-19 CAÑAVERAL',
  latitud = 7.067941666666666,
  longitud = -73.09641111111111,
  descripcion_corta = 'Prestar asesorías especializadas y/o implementación de estrategias para agregar valor empresarial, aplicación de metodologías integrales avanzadas y…',
  descripcion = 'Prestar asesorías especializadas y/o implementación de estrategias para agregar valor empresarial, aplicación de metodologías integrales avanzadas y soluciones tecnológicas que incluyen módulos de eficiencia energética y medio ambiente.',
  producto = 'METODOLOGÍAS PARA EL TRATAMIENTO, APROVECHAMIENTO Y AHORRO DE AGUA RESIDUAL NO DOMÉSTICA Y DOMÉSTICA, INCLUYENDO LA INSTALACIÓN Y PUESTA EN MARCHA DE PLANTAS DE TRATAMIENTO DENOMINADA ELECTROFLOI',
  telefono = '3212164079',
  whatsapp = '573212164079',
  email = 'luigarcir@gmail.com',
  representante_legal = 'LUIS EDUARDO GARCIA RODRIGUEZ',
  nit = '900218177-7',
  naturaleza_juridica = 'Jurídica',
  delegado = null,
  rut_camara_comercio = 'Cámara de comercio',
  responsable_cdmb = 'ANDRES VALDERRAMA',
  novedad = 'ACTIVO',
  tipo_negocio_verde = null,
  anio_registro = 2024,
  cota_msnm = '906 msnm',
  este = '73°5''47,08"',
  norte = '7°4''4,59"',
  aplicacion_ficha_2025 = 'Actualizó',
  observaciones = 'Se realizo visita y se aplico ficha de verificacion',
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
  fortalezas_ambiental = 'Desarrollo de tecnología para tratamiento de aguas residuales y cálculo de huella hídrica.
Banco del Recurso Hídrico como herramienta de monitoreo y gestión ambiental participativa.',
  fortalezas_social = 'Genera empleo calificado en áreas de tecnología e ingeniería.
Promueve una cultura de conciencia ambiental y tecnológica.',
  fortalezas_economico = 'Generación de valor agregado a través de servicios especializados de alto nivel.',
  emprendimiento_verde = false,
  sello_marca = false,
  avalado = true,
  destacado = false,
  activo = true
where nombre = 'INDUSTRIAS PARBER';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select 'e7cf66e9-4489-413e-a4c5-16193b9bfb1c', 'INDUSTRIAS PARBER', generar_slug_unico('INDUSTRIAS PARBER', 'e7cf66e9-4489-413e-a4c5-16193b9bfb1c'), (select id from categorias_oficiales where slug = 'calidad-ambiental'), 'Floridablanca', (select id from veredas where municipio = 'Floridablanca' and slug = 'perimetro-urbano'), 'CARRERA 6 # 44-19 CAÑAVERAL', 7.067941666666666, -73.09641111111111, 'Prestar asesorías especializadas y/o implementación de estrategias para agregar valor empresarial, aplicación de metodologías integrales avanzadas y…', 'Prestar asesorías especializadas y/o implementación de estrategias para agregar valor empresarial, aplicación de metodologías integrales avanzadas y soluciones tecnológicas que incluyen módulos de eficiencia energética y medio ambiente.', 'METODOLOGÍAS PARA EL TRATAMIENTO, APROVECHAMIENTO Y AHORRO DE AGUA RESIDUAL NO DOMÉSTICA Y DOMÉSTICA, INCLUYENDO LA INSTALACIÓN Y PUESTA EN MARCHA DE PLANTAS DE TRATAMIENTO DENOMINADA ELECTROFLOI', '3212164079', '573212164079', 'luigarcir@gmail.com', 'LUIS EDUARDO GARCIA RODRIGUEZ', '900218177-7', 'Jurídica', null, 'Cámara de comercio', 'ANDRES VALDERRAMA', 'ACTIVO', null, 2024, '906 msnm', '73°5''47,08"', '7°4''4,59"', 'Actualizó', 'Se realizo visita y se aplico ficha de verificacion', null, null, 'Acueducto', null, null, null, 'No', 'No', null, 'Sí', null, null, null, null, null, null, null, null, null, null, 'No', 'B2C', 'No', 'NO', 'Desarrollo de tecnología para tratamiento de aguas residuales y cálculo de huella hídrica.
Banco del Recurso Hídrico como herramienta de monitoreo y gestión ambiental participativa.', 'Genera empleo calificado en áreas de tecnología e ingeniería.
Promueve una cultura de conciencia ambiental y tecnológica.', 'Generación de valor agregado a través de servicios especializados de alto nivel.', false, false, true, false, true
where not exists (select 1 from negocios where nombre = 'INDUSTRIAS PARBER');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'INDUSTRIAS PARBER');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'INDUSTRIAS PARBER'), (select id from categorias_oficiales where slug = 'calidad-ambiental');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'INDUSTRIAS PARBER');
insert into negocios_subcategorias (negocio_id, subcategoria_id) select (select id from negocios where nombre = 'INDUSTRIAS PARBER'), id from subcategorias where slug = 'tecnologias-verdes';
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'INDUSTRIAS PARBER');
insert into negocios_actividades (negocio_id, actividad_productiva_id) select (select id from negocios where nombre = 'INDUSTRIAS PARBER'), id from actividades_productivas where slug = 'tecnologias-informacion-ambiental';
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'INDUSTRIAS PARBER'), 2024, 58.9 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'INDUSTRIAS PARBER'), 2025, 66.5 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;

-- TU NEGOCIO VERDE S.A.S.
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'calidad-ambiental'),
  municipio = 'Bucaramanga',
  vereda_id = (select id from veredas where municipio = 'Bucaramanga' and slug = 'perimetro-urbano'),
  direccion = 'CALLE 157 # 154-237 RESERVA CAÑAVERAL LOCAL 3',
  latitud = 7.111296666666666,
  longitud = -73.10551638888889,
  descripcion_corta = 'Tu Negocio Verde es un Marketplace enfocado exclusivamente a la promocion de Negocios Verdes que ofrezcan bienes y servicios que generen impactos…',
  descripcion = 'Tu Negocio Verde es un Marketplace enfocado exclusivamente a la promocion de Negocios Verdes que ofrezcan bienes y servicios que generen impactos ambientales positivos, facilitando la conexxión entre vendedores y compradores desde cualquier lugar a través de una plataforma segura y eficiente, proporcionando un valor añadido a través de servicios complementarios y una experiencia de usuario superior.',
  producto = 'MARKETPLACE',
  telefono = '3212164079',
  whatsapp = '573212164079',
  email = 'tunegocioverdeadm@gmail.com',
  representante_legal = 'PIER ANTONIO FRATTALLI SALCEDO',
  nit = '901832582-3',
  naturaleza_juridica = 'Jurídica',
  delegado = null,
  rut_camara_comercio = 'Cámara de comercio',
  responsable_cdmb = 'DIEGO GUTIERREZ',
  novedad = 'ACTIVO',
  tipo_negocio_verde = 'Satisfactorio',
  anio_registro = 2024,
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
  exportacion = 'No',
  huella_carbono = 'NO',
  fortalezas_ambiental = 'Áreas de conservación',
  fortalezas_social = 'Economía solidaria y vinculación con negocios verdes',
  fortalezas_economico = null,
  emprendimiento_verde = true,
  sello_marca = false,
  avalado = false,
  destacado = false,
  activo = true
where nombre = 'TU NEGOCIO VERDE S.A.S.';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select 'df90dfe6-ee5d-4bcb-a8f8-c2c005966c76', 'TU NEGOCIO VERDE S.A.S.', generar_slug_unico('TU NEGOCIO VERDE S.A.S.', 'df90dfe6-ee5d-4bcb-a8f8-c2c005966c76'), (select id from categorias_oficiales where slug = 'calidad-ambiental'), 'Bucaramanga', (select id from veredas where municipio = 'Bucaramanga' and slug = 'perimetro-urbano'), 'CALLE 157 # 154-237 RESERVA CAÑAVERAL LOCAL 3', 7.111296666666666, -73.10551638888889, 'Tu Negocio Verde es un Marketplace enfocado exclusivamente a la promocion de Negocios Verdes que ofrezcan bienes y servicios que generen impactos…', 'Tu Negocio Verde es un Marketplace enfocado exclusivamente a la promocion de Negocios Verdes que ofrezcan bienes y servicios que generen impactos ambientales positivos, facilitando la conexxión entre vendedores y compradores desde cualquier lugar a través de una plataforma segura y eficiente, proporcionando un valor añadido a través de servicios complementarios y una experiencia de usuario superior.', 'MARKETPLACE', '3212164079', '573212164079', 'tunegocioverdeadm@gmail.com', 'PIER ANTONIO FRATTALLI SALCEDO', '901832582-3', 'Jurídica', null, 'Cámara de comercio', 'DIEGO GUTIERREZ', 'ACTIVO', 'Satisfactorio', 2024, '956 msnm', '73°6''19.859''''', '7°6''40.668''''', 'Actualizó', 'Se realizo visita y se actualizo ficha de verificacion', null, null, 'Acueducto', null, null, null, 'No', 'No', null, 'Sí', null, null, null, null, null, null, null, null, null, null, 'No', 'B2B', 'No', 'NO', 'Áreas de conservación', 'Economía solidaria y vinculación con negocios verdes', null, true, false, false, false, true
where not exists (select 1 from negocios where nombre = 'TU NEGOCIO VERDE S.A.S.');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'TU NEGOCIO VERDE S.A.S.');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'TU NEGOCIO VERDE S.A.S.'), (select id from categorias_oficiales where slug = 'calidad-ambiental');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'TU NEGOCIO VERDE S.A.S.');
insert into negocios_subcategorias (negocio_id, subcategoria_id) select (select id from negocios where nombre = 'TU NEGOCIO VERDE S.A.S.'), id from subcategorias where slug = 'tecnologias-verdes';
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'TU NEGOCIO VERDE S.A.S.');
insert into negocios_actividades (negocio_id, actividad_productiva_id) select (select id from negocios where nombre = 'TU NEGOCIO VERDE S.A.S.'), id from actividades_productivas where slug = 'tecnologias-informacion-ambiental';
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'TU NEGOCIO VERDE S.A.S.'), 2024, 80.8 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'TU NEGOCIO VERDE S.A.S.'), 2025, 0.0 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;

-- CARLIXPLAST S.A.S
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'pendiente-clasificar'),
  municipio = 'Bucaramanga',
  vereda_id = null,
  direccion = null,
  latitud = null,
  longitud = null,
  descripcion_corta = null,
  descripcion = null,
  producto = 'BOLSAS',
  telefono = '3043768488',
  whatsapp = '573043768488',
  email = 'ambiental@carlixplast.com',
  representante_legal = 'GERMAN ALBERTO CASTRO CALIXTO',
  nit = '890211126-4',
  naturaleza_juridica = null,
  delegado = null,
  rut_camara_comercio = null,
  responsable_cdmb = 'LAURA RUIZ',
  novedad = 'SUSPENDIDO',
  tipo_negocio_verde = 'Inicial',
  anio_registro = 2024,
  cota_msnm = null,
  este = null,
  norte = null,
  aplicacion_ficha_2025 = null,
  observaciones = null,
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
where nombre = 'CARLIXPLAST S.A.S';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select '4ccbb28f-0013-4d04-8547-5eead9ce8bb9', 'CARLIXPLAST S.A.S', generar_slug_unico('CARLIXPLAST S.A.S', '4ccbb28f-0013-4d04-8547-5eead9ce8bb9'), (select id from categorias_oficiales where slug = 'pendiente-clasificar'), 'Bucaramanga', null, null, null, null, null, null, 'BOLSAS', '3043768488', '573043768488', 'ambiental@carlixplast.com', 'GERMAN ALBERTO CASTRO CALIXTO', '890211126-4', null, null, null, 'LAURA RUIZ', 'SUSPENDIDO', 'Inicial', 2024, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, true, false, false, false, false
where not exists (select 1 from negocios where nombre = 'CARLIXPLAST S.A.S');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'CARLIXPLAST S.A.S');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'CARLIXPLAST S.A.S'), (select id from categorias_oficiales where slug = 'pendiente-clasificar');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'CARLIXPLAST S.A.S');
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'CARLIXPLAST S.A.S');

-- AGRICULTIVE S.A.S
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'calidad-ambiental'),
  municipio = 'Girón',
  vereda_id = (select id from veredas where municipio = 'Girón' and slug = 'perimetro-urbano'),
  direccion = 'CALLE 4 # 17-80 GIRON',
  latitud = 7.081777777777778,
  longitud = -73.15882777777779,
  descripcion_corta = 'Agricultive brinda soluciones tecnológicas al sector agrícola enfocadas en el buen manejo del recurso energético e hídrico, utilizando la energía solar como…',
  descripcion = 'Agricultive brinda soluciones tecnológicas al sector agrícola enfocadas en el buen manejo del recurso energético e hídrico, utilizando la energía solar como fuente principal de electricidad en estos sistemas (sistemas de riego, de bombeo, bombas para piscicultura, iluminación de los galpones), además se realiza asesoría agronómica enfocada en la eficiencia de los cultivos a través del uso de esta tecnológica en reducción de costos de estos.',
  producto = 'SISTEMAS DE RIEGO SOLAR',
  telefono = '3167510704',
  whatsapp = '573167510704',
  email = 'gerencia.agricultive@gmail.com',
  representante_legal = 'SANDRA LILIANA MORENO HERNANDEZ',
  nit = '901122548-6',
  naturaleza_juridica = 'Jurídica',
  delegado = 'SERGIO ANDRES MORENO HERNANDEZ',
  rut_camara_comercio = 'Cámara de comercio',
  responsable_cdmb = 'SUJEY DÍAZ',
  novedad = 'ACTIVO',
  tipo_negocio_verde = null,
  anio_registro = 2024,
  cota_msnm = '834 msnm',
  este = '73°9''31,78"',
  norte = '7°4''54,40"',
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
  exportacion = 'No',
  huella_carbono = 'NO',
  fortalezas_ambiental = 'Reducción de huella de carbono mediante uso de paneles solares. Disminución del consumo de agua gracias a sistemas de riego eficientes.',
  fortalezas_social = 'Impacto positivo en comunidades rurales al mejorar eficiencia hídrica y agrícola. Educación ambiental y transferencia de conocimiento a usuarios y aliados.',
  fortalezas_economico = 'Diversificación de servicios (riego solar, monitoreo ambiental, eficiencia energética). Valor agregado',
  emprendimiento_verde = false,
  sello_marca = false,
  avalado = true,
  destacado = false,
  activo = true
where nombre = 'AGRICULTIVE S.A.S';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select '046f325e-9764-4a61-869a-838125fff917', 'AGRICULTIVE S.A.S', generar_slug_unico('AGRICULTIVE S.A.S', '046f325e-9764-4a61-869a-838125fff917'), (select id from categorias_oficiales where slug = 'calidad-ambiental'), 'Girón', (select id from veredas where municipio = 'Girón' and slug = 'perimetro-urbano'), 'CALLE 4 # 17-80 GIRON', 7.081777777777778, -73.15882777777779, 'Agricultive brinda soluciones tecnológicas al sector agrícola enfocadas en el buen manejo del recurso energético e hídrico, utilizando la energía solar como…', 'Agricultive brinda soluciones tecnológicas al sector agrícola enfocadas en el buen manejo del recurso energético e hídrico, utilizando la energía solar como fuente principal de electricidad en estos sistemas (sistemas de riego, de bombeo, bombas para piscicultura, iluminación de los galpones), además se realiza asesoría agronómica enfocada en la eficiencia de los cultivos a través del uso de esta tecnológica en reducción de costos de estos.', 'SISTEMAS DE RIEGO SOLAR', '3167510704', '573167510704', 'gerencia.agricultive@gmail.com', 'SANDRA LILIANA MORENO HERNANDEZ', '901122548-6', 'Jurídica', 'SERGIO ANDRES MORENO HERNANDEZ', 'Cámara de comercio', 'SUJEY DÍAZ', 'ACTIVO', null, 2024, '834 msnm', '73°9''31,78"', '7°4''54,40"', 'Actualizó', 'Se realizo visita y se aplico ficha de verificacion', null, 'No', 'Acueducto', null, null, null, 'No', 'No', null, 'Sí', null, null, null, null, null, null, null, null, null, null, 'No', 'Mixta', 'No', 'NO', 'Reducción de huella de carbono mediante uso de paneles solares. Disminución del consumo de agua gracias a sistemas de riego eficientes.', 'Impacto positivo en comunidades rurales al mejorar eficiencia hídrica y agrícola. Educación ambiental y transferencia de conocimiento a usuarios y aliados.', 'Diversificación de servicios (riego solar, monitoreo ambiental, eficiencia energética). Valor agregado', false, false, true, false, true
where not exists (select 1 from negocios where nombre = 'AGRICULTIVE S.A.S');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'AGRICULTIVE S.A.S');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'AGRICULTIVE S.A.S'), (select id from categorias_oficiales where slug = 'calidad-ambiental');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'AGRICULTIVE S.A.S');
insert into negocios_subcategorias (negocio_id, subcategoria_id) select (select id from negocios where nombre = 'AGRICULTIVE S.A.S'), id from subcategorias where slug = 'tecnologias-verdes';
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'AGRICULTIVE S.A.S');
insert into negocios_actividades (negocio_id, actividad_productiva_id) select (select id from negocios where nombre = 'AGRICULTIVE S.A.S'), id from actividades_productivas where slug = 'tecnologias-informacion-ambiental';
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'AGRICULTIVE S.A.S'), 2024, 61.9 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'AGRICULTIVE S.A.S'), 2025, 63.8 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;

-- EL DIAMANTE
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'),
  municipio = 'Piedecuesta',
  vereda_id = (select id from veredas where municipio = 'Piedecuesta' and slug = 'cristales'),
  direccion = 'FINCA INVERNALIA PIEDECUESTA',
  latitud = null,
  longitud = null,
  descripcion_corta = 'NO HAY INFORMACIÓN',
  descripcion = 'NO HAY INFORMACIÓN',
  producto = 'GULUPA',
  telefono = '3204786226',
  whatsapp = '573204786226',
  email = 'tatoariza.9323@gmail.com',
  representante_legal = 'BERCELI ARIZA',
  nit = null,
  naturaleza_juridica = 'Natural',
  delegado = null,
  rut_camara_comercio = 'Sin verificar',
  responsable_cdmb = 'SUJEY DÍAZ',
  novedad = 'RETIRADO',
  tipo_negocio_verde = 'Inicial',
  anio_registro = 2024,
  cota_msnm = null,
  este = null,
  norte = null,
  aplicacion_ficha_2025 = 'No actualizó',
  observaciones = 'No se realizo visita ni actualizo ficha de verificacion',
  registro_nacional_turismo = null,
  uso_suelo = 'SI. Hay un certificado',
  concesion_aguas = 'No hay ficha',
  concesion_aguas_vencimiento = null,
  vertimientos = 'No hay ficha',
  vertimientos_vencimiento = null,
  pueaa = 'No hay ficha',
  pgris = 'No hay ficha',
  pozo_septico = 'No hay ficha',
  alcantarillado = 'No hay ficha',
  ica = 'No hay ficha',
  ica_vencimiento = null,
  invima = null,
  invima_vencimiento = null,
  certificado_tenencia_animales = null,
  buenas_practicas_agricolas = 'No',
  buenas_practicas_apicolas = null,
  registro_apicola = null,
  intervencion_cauce = null,
  capacidad_carga = null,
  sstt = 'No hay ficha',
  canal_venta = null,
  exportacion = null,
  huella_carbono = null,
  fortalezas_ambiental = 'NO HAY INFORMACIÓN',
  fortalezas_social = 'NO HAY INFORMACIÓN',
  fortalezas_economico = 'NO HAY INFORMACIÓN',
  emprendimiento_verde = true,
  sello_marca = false,
  avalado = false,
  destacado = false,
  activo = false
where nombre = 'EL DIAMANTE';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select '6d5d1acb-a51e-414d-b9ba-0c3bf3388a53', 'EL DIAMANTE', generar_slug_unico('EL DIAMANTE', '6d5d1acb-a51e-414d-b9ba-0c3bf3388a53'), (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'), 'Piedecuesta', (select id from veredas where municipio = 'Piedecuesta' and slug = 'cristales'), 'FINCA INVERNALIA PIEDECUESTA', null, null, 'NO HAY INFORMACIÓN', 'NO HAY INFORMACIÓN', 'GULUPA', '3204786226', '573204786226', 'tatoariza.9323@gmail.com', 'BERCELI ARIZA', null, 'Natural', null, 'Sin verificar', 'SUJEY DÍAZ', 'RETIRADO', 'Inicial', 2024, null, null, null, 'No actualizó', 'No se realizo visita ni actualizo ficha de verificacion', null, 'SI. Hay un certificado', 'No hay ficha', null, 'No hay ficha', null, 'No hay ficha', 'No hay ficha', 'No hay ficha', 'No hay ficha', 'No hay ficha', null, null, null, null, 'No', null, null, null, null, 'No hay ficha', null, null, null, 'NO HAY INFORMACIÓN', 'NO HAY INFORMACIÓN', 'NO HAY INFORMACIÓN', true, false, false, false, false
where not exists (select 1 from negocios where nombre = 'EL DIAMANTE');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'EL DIAMANTE');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'EL DIAMANTE'), (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'EL DIAMANTE');
insert into negocios_subcategorias (negocio_id, subcategoria_id) select (select id from negocios where nombre = 'EL DIAMANTE'), id from subcategorias where slug = 'agroindustria-sostenible';
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'EL DIAMANTE');
insert into negocios_actividades (negocio_id, actividad_productiva_id) select (select id from negocios where nombre = 'EL DIAMANTE'), id from actividades_productivas where slug = 'agroindustrial-alimentario';

-- DIAMANTE AMARILLO
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'ecoproductos-industriales'),
  municipio = 'Bucaramanga',
  vereda_id = (select id from veredas where municipio = 'Bucaramanga' and slug = 'perimetro-urbano'),
  direccion = 'CALLE 42 # 17-19 EDIFICIO TORRE CENTRAL 42',
  latitud = null,
  longitud = null,
  descripcion_corta = 'Emprendimiento que se dedica a la elaboración de platos biodegradables con diferentes materias prims naturales , contiene semillas , características de los…',
  descripcion = 'Emprendimiento que se dedica a la elaboración de platos biodegradables con diferentes materias prims naturales , contiene semillas , características de los pisos térmicos de Colombia.',
  producto = 'PLATOS BIODEGRADABLES, SEMBRABLES',
  telefono = '3103116324',
  whatsapp = '573103116324',
  email = 'porsiempreaguila1@hotmail.com',
  representante_legal = 'VIANEY IBARRA HERRERA',
  nit = '26861723-5',
  naturaleza_juridica = 'Natural',
  delegado = null,
  rut_camara_comercio = 'Cámara de comercio',
  responsable_cdmb = 'SUJEY DÍAZ',
  novedad = 'ACTIVO',
  tipo_negocio_verde = 'Dinamizadoras',
  anio_registro = 2023,
  cota_msnm = null,
  este = null,
  norte = null,
  aplicacion_ficha_2025 = 'Actualizó',
  observaciones = 'Se realizo visita y se aplico ficha de verificacion',
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
  fortalezas_ambiental = 'EMPRENDIMIENTO QUE SE DEDICA A LA ELABORACION DE PLATOS BIODEGRADABLES CON DIFERENTES MATERIAS PRIMAS NATURALES , CONTIENE SEMILLAS , CARACTERISTICAS DE LOS PISOS TERMICOS DE COLOMBIA.',
  fortalezas_social = 'La forma de contratar su personal con un enfoque diferencial',
  fortalezas_economico = 'negocio rentable',
  emprendimiento_verde = false,
  sello_marca = false,
  avalado = true,
  destacado = false,
  activo = true
where nombre = 'DIAMANTE AMARILLO';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select '0021bfb6-c410-4a06-be73-94e5f8114212', 'DIAMANTE AMARILLO', generar_slug_unico('DIAMANTE AMARILLO', '0021bfb6-c410-4a06-be73-94e5f8114212'), (select id from categorias_oficiales where slug = 'ecoproductos-industriales'), 'Bucaramanga', (select id from veredas where municipio = 'Bucaramanga' and slug = 'perimetro-urbano'), 'CALLE 42 # 17-19 EDIFICIO TORRE CENTRAL 42', null, null, 'Emprendimiento que se dedica a la elaboración de platos biodegradables con diferentes materias prims naturales , contiene semillas , características de los…', 'Emprendimiento que se dedica a la elaboración de platos biodegradables con diferentes materias prims naturales , contiene semillas , características de los pisos térmicos de Colombia.', 'PLATOS BIODEGRADABLES, SEMBRABLES', '3103116324', '573103116324', 'porsiempreaguila1@hotmail.com', 'VIANEY IBARRA HERRERA', '26861723-5', 'Natural', null, 'Cámara de comercio', 'SUJEY DÍAZ', 'ACTIVO', 'Dinamizadoras', 2023, null, null, null, 'Actualizó', 'Se realizo visita y se aplico ficha de verificacion', null, null, 'Acueducto', null, null, null, 'No', 'No', null, 'Sí', null, null, null, null, null, null, null, null, null, null, 'No', 'Mixta', 'No', 'NO', 'EMPRENDIMIENTO QUE SE DEDICA A LA ELABORACION DE PLATOS BIODEGRADABLES CON DIFERENTES MATERIAS PRIMAS NATURALES , CONTIENE SEMILLAS , CARACTERISTICAS DE LOS PISOS TERMICOS DE COLOMBIA.', 'La forma de contratar su personal con un enfoque diferencial', 'negocio rentable', false, false, true, false, true
where not exists (select 1 from negocios where nombre = 'DIAMANTE AMARILLO');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'DIAMANTE AMARILLO');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'DIAMANTE AMARILLO'), (select id from categorias_oficiales where slug = 'ecoproductos-industriales');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'DIAMANTE AMARILLO');
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'DIAMANTE AMARILLO');
insert into negocios_actividades (negocio_id, actividad_productiva_id) select (select id from negocios where nombre = 'DIAMANTE AMARILLO'), id from actividades_productivas where slug = 'aprovechamiento-residuos-organicos';
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'DIAMANTE AMARILLO'), 2024, 46.4 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'DIAMANTE AMARILLO'), 2025, 52.6 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;

-- APIARIO LA ABUNDANCIA
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'),
  municipio = 'Rionegro',
  vereda_id = (select id from veredas where municipio = 'Rionegro' and slug = 'la-paz'),
  direccion = 'FINCA OLLA RICA VEREDA LA PAZ',
  latitud = null,
  longitud = null,
  descripcion_corta = 'Extracción de miel de manera artesanal  de las 8 colmenas de abejas  que contribuyen a la preservación de la biodiversidad a través de la polinización,…',
  descripcion = 'Extracción de miel de manera artesanal  de las 8 colmenas de abejas  que contribuyen a la preservación de la biodiversidad a través de la polinización, realiza manejo de residuos para compost de lombrinaza, sistema agroforestal, cuidado fuente hídrica y  finca certificada en BPA para citricos.',
  producto = 'MIEL DE ABEJAS',
  telefono = '3112371502',
  whatsapp = '573112371502',
  email = 'cirvies@yahoo.es',
  representante_legal = 'CIRO VILLAMIZAR ESPINOZA',
  nit = '88151659',
  naturaleza_juridica = null,
  delegado = null,
  rut_camara_comercio = 'RUT',
  responsable_cdmb = 'ANA RUEDA',
  novedad = 'ACTIVO',
  tipo_negocio_verde = null,
  anio_registro = 2023,
  cota_msnm = '1101.8',
  este = '73.182°071°1w',
  norte = '7.33791518N',
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
  pozo_septico = 'No',
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
  fortalezas_ambiental = 'SI, No se utilizan materiales peligrosos y/o tóxicos en los procesos, proceso artesanal.
-Envase de vidrio.
-Se desarrollan acciones como estrategias de restauración y reforestación con especies nativas.',
  fortalezas_social = 'Sensibilización sobre el cuidado y peligro de exponer sin los elementos de protección ante  enjambres a vecinos aledaños. 
-Genera empleo local a campesinos',
  fortalezas_economico = 'Tiene claro algunos costos y gastos pero no la totalidad de operación del negocio.',
  emprendimiento_verde = true,
  sello_marca = false,
  avalado = false,
  destacado = false,
  activo = true
where nombre = 'APIARIO LA ABUNDANCIA';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select 'e52d9adb-37be-48cd-8594-c6fa26ec03b6', 'APIARIO LA ABUNDANCIA', generar_slug_unico('APIARIO LA ABUNDANCIA', 'e52d9adb-37be-48cd-8594-c6fa26ec03b6'), (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'), 'Rionegro', (select id from veredas where municipio = 'Rionegro' and slug = 'la-paz'), 'FINCA OLLA RICA VEREDA LA PAZ', null, null, 'Extracción de miel de manera artesanal  de las 8 colmenas de abejas  que contribuyen a la preservación de la biodiversidad a través de la polinización,…', 'Extracción de miel de manera artesanal  de las 8 colmenas de abejas  que contribuyen a la preservación de la biodiversidad a través de la polinización, realiza manejo de residuos para compost de lombrinaza, sistema agroforestal, cuidado fuente hídrica y  finca certificada en BPA para citricos.', 'MIEL DE ABEJAS', '3112371502', '573112371502', 'cirvies@yahoo.es', 'CIRO VILLAMIZAR ESPINOZA', '88151659', null, null, 'RUT', 'ANA RUEDA', 'ACTIVO', null, 2023, '1101.8', '73.182°071°1w', '7.33791518N', 'Actualizó', 'Se realizo visita y se aplico ficha de verificacion', null, 'Sí', 'No', null, null, null, 'No', 'No', 'No', null, null, null, 'No', null, null, null, 'No', 'No', null, null, 'No', 'B2C', 'No', null, 'SI, No se utilizan materiales peligrosos y/o tóxicos en los procesos, proceso artesanal.
-Envase de vidrio.
-Se desarrollan acciones como estrategias de restauración y reforestación con especies nativas.', 'Sensibilización sobre el cuidado y peligro de exponer sin los elementos de protección ante  enjambres a vecinos aledaños. 
-Genera empleo local a campesinos', 'Tiene claro algunos costos y gastos pero no la totalidad de operación del negocio.', true, false, false, false, true
where not exists (select 1 from negocios where nombre = 'APIARIO LA ABUNDANCIA');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'APIARIO LA ABUNDANCIA');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'APIARIO LA ABUNDANCIA'), (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'APIARIO LA ABUNDANCIA');
insert into negocios_subcategorias (negocio_id, subcategoria_id) select (select id from negocios where nombre = 'APIARIO LA ABUNDANCIA'), id from subcategorias where slug = 'agrosistemas-sostenibles';
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'APIARIO LA ABUNDANCIA');
insert into negocios_actividades (negocio_id, actividad_productiva_id) select (select id from negocios where nombre = 'APIARIO LA ABUNDANCIA'), id from actividades_productivas where slug = 'agricultura-sostenible';
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'APIARIO LA ABUNDANCIA'), 2024, 34.0 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'APIARIO LA ABUNDANCIA'), 2025, 41.1 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;

-- PRODUCTOS LA CHORRERA
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'),
  municipio = 'Vetas',
  vereda_id = null,
  direccion = 'VIA VETAS, VEREDA LA CHORRERA FINCA LA CHORRERA',
  latitud = null,
  longitud = null,
  descripcion_corta = null,
  descripcion = null,
  producto = 'TRUCHA',
  telefono = '3204693435',
  whatsapp = '573204693435',
  email = 'yana_801@hotmail.com',
  representante_legal = 'CLAUDIA BIBIANA RAMIREZ',
  nit = '28049333',
  naturaleza_juridica = null,
  delegado = null,
  rut_camara_comercio = null,
  responsable_cdmb = 'ANA RUEDA',
  novedad = 'SUSPENDIDO',
  tipo_negocio_verde = null,
  anio_registro = 2023,
  cota_msnm = '72.9116',
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
where nombre = 'PRODUCTOS LA CHORRERA';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select '56181377-9d81-4ae5-b51f-8d8687c35610', 'PRODUCTOS LA CHORRERA', generar_slug_unico('PRODUCTOS LA CHORRERA', '56181377-9d81-4ae5-b51f-8d8687c35610'), (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'), 'Vetas', null, 'VIA VETAS, VEREDA LA CHORRERA FINCA LA CHORRERA', null, null, null, null, 'TRUCHA', '3204693435', '573204693435', 'yana_801@hotmail.com', 'CLAUDIA BIBIANA RAMIREZ', '28049333', null, null, null, 'ANA RUEDA', 'SUSPENDIDO', null, 2023, '72.9116', null, null, null, 'Continua en el programa', null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, true, false, false, false, false
where not exists (select 1 from negocios where nombre = 'PRODUCTOS LA CHORRERA');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'PRODUCTOS LA CHORRERA');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'PRODUCTOS LA CHORRERA'), (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'PRODUCTOS LA CHORRERA');
insert into negocios_subcategorias (negocio_id, subcategoria_id) select (select id from negocios where nombre = 'PRODUCTOS LA CHORRERA'), id from subcategorias where slug = 'agroindustria-sostenible';
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'PRODUCTOS LA CHORRERA');
insert into negocios_actividades (negocio_id, actividad_productiva_id) select (select id from negocios where nombre = 'PRODUCTOS LA CHORRERA'), id from actividades_productivas where slug = 'agroindustrial-alimentario';

-- GRUPO VITALIA /FRUTIGURT
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'),
  municipio = 'Girón',
  vereda_id = (select id from veredas where municipio = 'Girón' and slug = 'perimetro-urbano'),
  direccion = 'CARRERA 29A # 23 -29 APTO 201 BARRIO RIO DE ORO GIRON',
  latitud = null,
  longitud = null,
  descripcion_corta = 'Elaboración de yogurt griego y trozos de fruta  de manera artesanal',
  descripcion = 'Elaboración de yogurt griego y trozos de fruta  de manera artesanal',
  producto = 'YOGURTH GRIEGO ARTESANAL CON FRUTA Y GRANOLA',
  telefono = '3152801921',
  whatsapp = '573152801921',
  email = 'edwinbaselider@gmail.com',
  representante_legal = 'EDWIN BUITRAGO',
  nit = '1140418485-3',
  naturaleza_juridica = 'Natural',
  delegado = null,
  rut_camara_comercio = 'Cámara de comercio',
  responsable_cdmb = 'LILIANA CACERES',
  novedad = 'ACTIVO',
  tipo_negocio_verde = null,
  anio_registro = 2024,
  cota_msnm = '719.0 msnm',
  este = '73°1568516',
  norte = '7°0590464',
  aplicacion_ficha_2025 = 'Actualizó',
  observaciones = 'Se realizo visita y se aplico ficha de verificacion',
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
  invima = 'Sí',
  invima_vencimiento = '2026-11-18',
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
  fortalezas_ambiental = 'Promueve el aprovechamiento de envases para 2do usos
¬- No se utilizan materiales peligrosos y/o tóxicos en los procesos',
  fortalezas_social = 'Generación de empleo local a adultas mayores.',
  fortalezas_economico = 'Claridad en costos y gastos de los productos.',
  emprendimiento_verde = true,
  sello_marca = false,
  avalado = false,
  destacado = false,
  activo = true
where nombre = 'GRUPO VITALIA /FRUTIGURT';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select '2529dab6-1ad6-4b53-899b-53416028c93e', 'GRUPO VITALIA /FRUTIGURT', generar_slug_unico('GRUPO VITALIA /FRUTIGURT', '2529dab6-1ad6-4b53-899b-53416028c93e'), (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'), 'Girón', (select id from veredas where municipio = 'Girón' and slug = 'perimetro-urbano'), 'CARRERA 29A # 23 -29 APTO 201 BARRIO RIO DE ORO GIRON', null, null, 'Elaboración de yogurt griego y trozos de fruta  de manera artesanal', 'Elaboración de yogurt griego y trozos de fruta  de manera artesanal', 'YOGURTH GRIEGO ARTESANAL CON FRUTA Y GRANOLA', '3152801921', '573152801921', 'edwinbaselider@gmail.com', 'EDWIN BUITRAGO', '1140418485-3', 'Natural', null, 'Cámara de comercio', 'LILIANA CACERES', 'ACTIVO', null, 2024, '719.0 msnm', '73°1568516', '7°0590464', 'Actualizó', 'Se realizo visita y se aplico ficha de verificacion', null, null, 'Acueducto', null, null, null, 'No', 'No', null, 'Sí', null, null, 'Sí', '2026-11-18', null, null, null, null, null, null, 'No', 'Mixta', 'No', 'NO', 'Promueve el aprovechamiento de envases para 2do usos
¬- No se utilizan materiales peligrosos y/o tóxicos en los procesos', 'Generación de empleo local a adultas mayores.', 'Claridad en costos y gastos de los productos.', true, false, false, false, true
where not exists (select 1 from negocios where nombre = 'GRUPO VITALIA /FRUTIGURT');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'GRUPO VITALIA /FRUTIGURT');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'GRUPO VITALIA /FRUTIGURT'), (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'GRUPO VITALIA /FRUTIGURT');
insert into negocios_subcategorias (negocio_id, subcategoria_id) select (select id from negocios where nombre = 'GRUPO VITALIA /FRUTIGURT'), id from subcategorias where slug = 'agroindustria-sostenible';
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'GRUPO VITALIA /FRUTIGURT');
insert into negocios_actividades (negocio_id, actividad_productiva_id) select (select id from negocios where nombre = 'GRUPO VITALIA /FRUTIGURT'), id from actividades_productivas where slug = 'agroindustrial-alimentario';
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'GRUPO VITALIA /FRUTIGURT'), 2024, 44.7 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'GRUPO VITALIA /FRUTIGURT'), 2025, 51.6 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;


commit;
