begin;

-- Generado por lib/migraciones/generar_0026.py desde BASE_ACTUALIZADA_NV_ka.xlsx — no editar a mano.
-- Uno de varios archivos partidos (ver README.md) — correr TODOS, en cualquier orden, cada uno es su propia transacción.

-- Parte 5 de 17.

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

-- COCOA KING
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'),
  municipio = 'Bucaramanga',
  vereda_id = (select id from veredas where municipio = 'Bucaramanga' and slug = 'san-pedro-bajo'),
  direccion = 'VEREDA SAN PEDRO FINCA MI CABAÑA',
  latitud = null,
  longitud = -73.12235472222221,
  descripcion_corta = 'Cocoa King es una empresa familiar que se dedica  a la producción, transformación y comercialización de cacao de manera sostenible, aplicando buenas…',
  descripcion = 'Cocoa King es una empresa familiar que se dedica  a la producción, transformación y comercialización de cacao de manera sostenible, aplicando buenas prácticas de cultivo donde no usa ningún tipo de agroquímicos, realizando el reciclaje de nutrientes del residuo del cacao (cacota) y la gallinaza para ser usado como materia orgánica en el suelo. La transformación del grano de cacao en chocolate de mesa artesanal la realiza en sus propias instalaciones. Los productos son elaborados sin ningún preservante lo que le otorga una calidad única y natural a sus productos, que comercializa en tiendas saludables de Bucaramanga, AMA CAFE con las cuales se tienen acuerdos verbales de comercialización de los productos; de igual forma, realizan entregas al público en conjuntos cerrados en Bucaramanga y su área metropolitana, usando como medio de promoción sus redes sociales (Instagram, y WhatsApp) y por medio del voz a voz. La empresa realiza acciones como la conservación de la biodiversidad mediante el manejo del cultivo de cacao en modelo agroforestal con el asocio de árboles maderables de sombrío y plátano, realiza prácticas de conservación del suelo dejando de lado el uso de agroquímicos, aplicando materia orgánica y realizando el reciclaje de nutrientes con la reincorporación de la cacota del cacao, las podas del cultivo y la gallinaza de los animales para elaborar abono orgánico que aplica en el cultivo, se hace preservación rondas hídricas dejando áreas de conservación. De igual forma, utiliza para el empaque de sus productos materiales biodegradables. Así mismo, realiza el aprovechamiento de productos y residuos vegetales de la finca (cacota de cacao, plátano, yuca, bore)',
  producto = 'CHOCOLATE DE MESA',
  telefono = '3157308159',
  whatsapp = '573157308159',
  email = 'mariaca9610@gmail.com',
  representante_legal = 'JOAQUIN CONTRERAS MENDOZA',
  nit = '91219330-9',
  naturaleza_juridica = 'Natural',
  delegado = null,
  rut_camara_comercio = 'Cámara de comercio',
  responsable_cdmb = 'NATALY RAMIREZ',
  novedad = 'ACTIVO',
  tipo_negocio_verde = 'Dinamizadoras',
  anio_registro = 2021,
  cota_msnm = '1.112 msnm',
  este = '73°7''20.477''''',
  norte = '7°12''31872''''',
  aplicacion_ficha_2025 = 'Actualizó',
  observaciones = null,
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
  invima = 'Sí',
  invima_vencimiento = '2035-09-12',
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
  fortalezas_ambiental = 'Cultivan su propio cacao orgánico, sin uso de agroquímicos.
 • Controlan toda la cadena de valor (desde la siembra hasta el producto final).
 • Promueven la agricultura sostenible y la conservación del suelo.
 • Producción artesanal con bajo impacto ambiental.
 • Fomento del consumo local, reduciendo la huella de transporte y emisiones.',
  fortalezas_social = 'Liderado por adultos mayores con gran experiencia, compromiso y saber tradicional.
 • Transmisión de conocimientos sobre el cultivo del cacao y la elaboración artesanal.
 • Genera empleo familiar y mantiene viva la cultura cacaotera local.
 • Participan activamente en ferias locales y regionales, compartiendo su historia y producto.',
  fortalezas_economico = 'Cuentan con registro INVIMA, lo que respalda su formalización y calidad sanitaria.
 • Producen y transforman su propio cacao, lo que reduce costos de materia prima.
 • Hacen presencia en ferias que fortalecen el contacto con clientes.
 • Producto con alto potencial en el mercado de cacao orgánico y artesanal.',
  emprendimiento_verde = false,
  sello_marca = false,
  avalado = true,
  destacado = false,
  activo = true
where nombre = 'COCOA KING';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select 'a88278ee-5b3a-4064-b15d-3b388e45f4f9', 'COCOA KING', generar_slug_unico('COCOA KING', 'a88278ee-5b3a-4064-b15d-3b388e45f4f9'), (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'), 'Bucaramanga', (select id from veredas where municipio = 'Bucaramanga' and slug = 'san-pedro-bajo'), 'VEREDA SAN PEDRO FINCA MI CABAÑA', null, -73.12235472222221, 'Cocoa King es una empresa familiar que se dedica  a la producción, transformación y comercialización de cacao de manera sostenible, aplicando buenas…', 'Cocoa King es una empresa familiar que se dedica  a la producción, transformación y comercialización de cacao de manera sostenible, aplicando buenas prácticas de cultivo donde no usa ningún tipo de agroquímicos, realizando el reciclaje de nutrientes del residuo del cacao (cacota) y la gallinaza para ser usado como materia orgánica en el suelo. La transformación del grano de cacao en chocolate de mesa artesanal la realiza en sus propias instalaciones. Los productos son elaborados sin ningún preservante lo que le otorga una calidad única y natural a sus productos, que comercializa en tiendas saludables de Bucaramanga, AMA CAFE con las cuales se tienen acuerdos verbales de comercialización de los productos; de igual forma, realizan entregas al público en conjuntos cerrados en Bucaramanga y su área metropolitana, usando como medio de promoción sus redes sociales (Instagram, y WhatsApp) y por medio del voz a voz. La empresa realiza acciones como la conservación de la biodiversidad mediante el manejo del cultivo de cacao en modelo agroforestal con el asocio de árboles maderables de sombrío y plátano, realiza prácticas de conservación del suelo dejando de lado el uso de agroquímicos, aplicando materia orgánica y realizando el reciclaje de nutrientes con la reincorporación de la cacota del cacao, las podas del cultivo y la gallinaza de los animales para elaborar abono orgánico que aplica en el cultivo, se hace preservación rondas hídricas dejando áreas de conservación. De igual forma, utiliza para el empaque de sus productos materiales biodegradables. Así mismo, realiza el aprovechamiento de productos y residuos vegetales de la finca (cacota de cacao, plátano, yuca, bore)', 'CHOCOLATE DE MESA', '3157308159', '573157308159', 'mariaca9610@gmail.com', 'JOAQUIN CONTRERAS MENDOZA', '91219330-9', 'Natural', null, 'Cámara de comercio', 'NATALY RAMIREZ', 'ACTIVO', 'Dinamizadoras', 2021, '1.112 msnm', '73°7''20.477''''', '7°12''31872''''', 'Actualizó', null, null, 'Sí', 'Acueducto veredal', null, null, null, 'No', 'No', 'Sí', null, null, null, 'Sí', '2035-09-12', null, 'No', null, null, null, null, 'No', 'B2C', 'No', 'NO', 'Cultivan su propio cacao orgánico, sin uso de agroquímicos.
 • Controlan toda la cadena de valor (desde la siembra hasta el producto final).
 • Promueven la agricultura sostenible y la conservación del suelo.
 • Producción artesanal con bajo impacto ambiental.
 • Fomento del consumo local, reduciendo la huella de transporte y emisiones.', 'Liderado por adultos mayores con gran experiencia, compromiso y saber tradicional.
 • Transmisión de conocimientos sobre el cultivo del cacao y la elaboración artesanal.
 • Genera empleo familiar y mantiene viva la cultura cacaotera local.
 • Participan activamente en ferias locales y regionales, compartiendo su historia y producto.', 'Cuentan con registro INVIMA, lo que respalda su formalización y calidad sanitaria.
 • Producen y transforman su propio cacao, lo que reduce costos de materia prima.
 • Hacen presencia en ferias que fortalecen el contacto con clientes.
 • Producto con alto potencial en el mercado de cacao orgánico y artesanal.', false, false, true, false, true
where not exists (select 1 from negocios where nombre = 'COCOA KING');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'COCOA KING');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'COCOA KING'), (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'COCOA KING');
insert into negocios_subcategorias (negocio_id, subcategoria_id) select (select id from negocios where nombre = 'COCOA KING'), id from subcategorias where slug = 'agrosistemas-sostenibles';
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'COCOA KING');
insert into negocios_actividades (negocio_id, actividad_productiva_id) select (select id from negocios where nombre = 'COCOA KING'), id from actividades_productivas where slug = 'agroindustrial-alimentario';
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'COCOA KING'), 2022, 45.56 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'COCOA KING'), 2023, 45.56 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'COCOA KING'), 2024, 53.9 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'COCOA KING'), 2025, 54.1 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;

-- REPOSTERÍA Y CHOCOLATERÍA/CHOCO MAU
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'),
  municipio = 'Rionegro',
  vereda_id = (select id from veredas where municipio = 'Rionegro' and slug = 'honduras-cana-brava'),
  direccion = 'FINCA EL COCO, VEREDA HONDURAS CAÑA BRAVA',
  latitud = 7.282443333333333,
  longitud = -73.12123833333332,
  descripcion_corta = 'Cultivo agroelógico de cacao donde se elabora chocolate de mesa en bola,  postres y tortas de chocolate.',
  descripcion = 'Cultivo agroelógico de cacao donde se elabora chocolate de mesa en bola,  postres y tortas de chocolate.',
  producto = 'CHOCOLATE DE MESA',
  telefono = '3046084459',
  whatsapp = '573046084459',
  email = 'leonlozanoluzstella@gmail.com',
  representante_legal = 'LUZ STELLA LEÓN LOZANO',
  nit = '5726116-0',
  naturaleza_juridica = 'Natural',
  delegado = null,
  rut_camara_comercio = 'Cámara de comercio',
  responsable_cdmb = 'HEINER ORTIZ',
  novedad = 'ACTIVO',
  tipo_negocio_verde = 'Dinamizadoras',
  anio_registro = 2021,
  cota_msnm = '1.266.1 msnm',
  este = '(-)73°7''16,458''''',
  norte = '7°16''56,796''''',
  aplicacion_ficha_2025 = 'Actualizó',
  observaciones = 'Se realizo visita y se aplico ficha de verificacion',
  registro_nacional_turismo = null,
  uso_suelo = 'Sí',
  concesion_aguas = 'Sí',
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
  fortalezas_ambiental = 'SI, Sistemas agroforestales, estrategias de restauración y reforestación con especies nativas o endémicas, cercas vivas, fertilización orgánica, entre otros.
- No se utilizan materiales peligrosos y/o tóxicos en los procesos
- Por medio de la Federación de cafeteros asómbrate -capacitaciones para recibir bono de carbono.
- Los sacos de fique se reutilizan y bolsas en papel craff.',
  fortalezas_social = 'Generación de empleos - Mujeres campesinas de la zona.
-Proveedor verde –abonos Abimbra LTDA
- Generación educación ambiental con la JAC veredal (promueven estilos de vida y prácticas de consumo consciente y en armonía con la naturaleza, economía circular).',
  fortalezas_economico = 'Al producto consideran el total de los costos y gastos del negocio',
  emprendimiento_verde = true,
  sello_marca = false,
  avalado = false,
  destacado = false,
  activo = true
where nombre = 'REPOSTERÍA Y CHOCOLATERÍA/CHOCO MAU';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select 'faaf81af-9f5f-452b-89d5-5a47186da88a', 'REPOSTERÍA Y CHOCOLATERÍA/CHOCO MAU', generar_slug_unico('REPOSTERÍA Y CHOCOLATERÍA/CHOCO MAU', 'faaf81af-9f5f-452b-89d5-5a47186da88a'), (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'), 'Rionegro', (select id from veredas where municipio = 'Rionegro' and slug = 'honduras-cana-brava'), 'FINCA EL COCO, VEREDA HONDURAS CAÑA BRAVA', 7.282443333333333, -73.12123833333332, 'Cultivo agroelógico de cacao donde se elabora chocolate de mesa en bola,  postres y tortas de chocolate.', 'Cultivo agroelógico de cacao donde se elabora chocolate de mesa en bola,  postres y tortas de chocolate.', 'CHOCOLATE DE MESA', '3046084459', '573046084459', 'leonlozanoluzstella@gmail.com', 'LUZ STELLA LEÓN LOZANO', '5726116-0', 'Natural', null, 'Cámara de comercio', 'HEINER ORTIZ', 'ACTIVO', 'Dinamizadoras', 2021, '1.266.1 msnm', '(-)73°7''16,458''''', '7°16''56,796''''', 'Actualizó', 'Se realizo visita y se aplico ficha de verificacion', null, 'Sí', 'Sí', null, null, null, 'No', 'No', 'Sí', null, null, null, 'No', null, null, 'No', null, null, null, null, 'No', 'B2C', 'No', 'NO', 'SI, Sistemas agroforestales, estrategias de restauración y reforestación con especies nativas o endémicas, cercas vivas, fertilización orgánica, entre otros.
- No se utilizan materiales peligrosos y/o tóxicos en los procesos
- Por medio de la Federación de cafeteros asómbrate -capacitaciones para recibir bono de carbono.
- Los sacos de fique se reutilizan y bolsas en papel craff.', 'Generación de empleos - Mujeres campesinas de la zona.
-Proveedor verde –abonos Abimbra LTDA
- Generación educación ambiental con la JAC veredal (promueven estilos de vida y prácticas de consumo consciente y en armonía con la naturaleza, economía circular).', 'Al producto consideran el total de los costos y gastos del negocio', true, false, false, false, true
where not exists (select 1 from negocios where nombre = 'REPOSTERÍA Y CHOCOLATERÍA/CHOCO MAU');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'REPOSTERÍA Y CHOCOLATERÍA/CHOCO MAU');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'REPOSTERÍA Y CHOCOLATERÍA/CHOCO MAU'), (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'REPOSTERÍA Y CHOCOLATERÍA/CHOCO MAU');
insert into negocios_subcategorias (negocio_id, subcategoria_id) select (select id from negocios where nombre = 'REPOSTERÍA Y CHOCOLATERÍA/CHOCO MAU'), id from subcategorias where slug = 'agrosistemas-sostenibles';
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'REPOSTERÍA Y CHOCOLATERÍA/CHOCO MAU');
insert into negocios_actividades (negocio_id, actividad_productiva_id) select (select id from negocios where nombre = 'REPOSTERÍA Y CHOCOLATERÍA/CHOCO MAU'), id from actividades_productivas where slug = 'agroecologia';
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'REPOSTERÍA Y CHOCOLATERÍA/CHOCO MAU'), 2024, 56.2 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'REPOSTERÍA Y CHOCOLATERÍA/CHOCO MAU'), 2025, 56.2 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;

-- TECNOLOGIA AMBIENTAL NOW S.A.S.
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'ecoproductos-industriales'),
  municipio = 'Bucaramanga',
  vereda_id = (select id from veredas where municipio = 'Bucaramanga' and slug = 'perimetro-urbano'),
  direccion = 'CALLE 128 A # 20 - 16 CRISTAL BAJO',
  latitud = 7.098333333333333,
  longitud = -73.11,
  descripcion_corta = 'Fabricación y comercialización de absorbente now para derrames de hidrocarburos en el suelo y en el agua. ademas se brinda asesoria técnica de manera…',
  descripcion = 'Fabricación y comercialización de absorbente now para derrames de hidrocarburos en el suelo y en el agua. ademas se brinda asesoria técnica de manera virtual para proteger el agua, no genrar residuos peligroso y rescatar recursos. y rescatar recursos.',
  producto = 'ABSORBENTE NOW PARA DERRAMES DE HIDROCARBUROS',
  telefono = '3103132582',
  whatsapp = '573103132582',
  email = 'tecnowsas@gmail.com / tecnowambiental@gmail.com',
  representante_legal = 'CARLOS FELIPE FORERO MONSALVE',
  nit = '900475086-6',
  naturaleza_juridica = 'Jurídica',
  delegado = null,
  rut_camara_comercio = 'Cámara de comercio',
  responsable_cdmb = 'SEBASTIAN BONNET',
  novedad = 'ACTIVO',
  tipo_negocio_verde = 'Dinamizadoras',
  anio_registro = 2018,
  cota_msnm = '1.400 msnm',
  este = '73°6''36''''',
  norte = '7°5''54''''',
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
  fortalezas_ambiental = 'Cuidado Recurso Hidrico',
  fortalezas_social = 'Generación de empleo local y fortalecimiento del tejido comunitario',
  fortalezas_economico = 'La empresa cuenta con un componente económico estable – requiere de mayor acompañamiento para incrementar cada día mas sus ingresos',
  emprendimiento_verde = false,
  sello_marca = false,
  avalado = true,
  destacado = false,
  activo = true
where nombre = 'TECNOLOGIA AMBIENTAL NOW S.A.S.';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select '3a3863ac-0dfb-419e-922d-368c9e8d1e36', 'TECNOLOGIA AMBIENTAL NOW S.A.S.', generar_slug_unico('TECNOLOGIA AMBIENTAL NOW S.A.S.', '3a3863ac-0dfb-419e-922d-368c9e8d1e36'), (select id from categorias_oficiales where slug = 'ecoproductos-industriales'), 'Bucaramanga', (select id from veredas where municipio = 'Bucaramanga' and slug = 'perimetro-urbano'), 'CALLE 128 A # 20 - 16 CRISTAL BAJO', 7.098333333333333, -73.11, 'Fabricación y comercialización de absorbente now para derrames de hidrocarburos en el suelo y en el agua. ademas se brinda asesoria técnica de manera…', 'Fabricación y comercialización de absorbente now para derrames de hidrocarburos en el suelo y en el agua. ademas se brinda asesoria técnica de manera virtual para proteger el agua, no genrar residuos peligroso y rescatar recursos. y rescatar recursos.', 'ABSORBENTE NOW PARA DERRAMES DE HIDROCARBUROS', '3103132582', '573103132582', 'tecnowsas@gmail.com / tecnowambiental@gmail.com', 'CARLOS FELIPE FORERO MONSALVE', '900475086-6', 'Jurídica', null, 'Cámara de comercio', 'SEBASTIAN BONNET', 'ACTIVO', 'Dinamizadoras', 2018, '1.400 msnm', '73°6''36''''', '7°5''54''''', 'Actualizó', 'Se realizo visita y se aplico ficha de verificacion', null, 'No', 'Acueducto', null, null, null, 'No', 'No', null, 'Sí', null, null, null, null, null, null, null, null, null, null, 'No', 'Mixta', 'No', 'NO', 'Cuidado Recurso Hidrico', 'Generación de empleo local y fortalecimiento del tejido comunitario', 'La empresa cuenta con un componente económico estable – requiere de mayor acompañamiento para incrementar cada día mas sus ingresos', false, false, true, false, true
where not exists (select 1 from negocios where nombre = 'TECNOLOGIA AMBIENTAL NOW S.A.S.');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'TECNOLOGIA AMBIENTAL NOW S.A.S.');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'TECNOLOGIA AMBIENTAL NOW S.A.S.'), (select id from categorias_oficiales where slug = 'ecoproductos-industriales');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'TECNOLOGIA AMBIENTAL NOW S.A.S.');
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'TECNOLOGIA AMBIENTAL NOW S.A.S.');
insert into negocios_actividades (negocio_id, actividad_productiva_id) select (select id from negocios where nombre = 'TECNOLOGIA AMBIENTAL NOW S.A.S.'), id from actividades_productivas where slug = 'aprovechamiento-residuos-inorganicos';
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'TECNOLOGIA AMBIENTAL NOW S.A.S.'), 2020, 53.3 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'TECNOLOGIA AMBIENTAL NOW S.A.S.'), 2021, 54.11 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'TECNOLOGIA AMBIENTAL NOW S.A.S.'), 2022, 69.3 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'TECNOLOGIA AMBIENTAL NOW S.A.S.'), 2023, 64.41 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'TECNOLOGIA AMBIENTAL NOW S.A.S.'), 2024, 73.4 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'TECNOLOGIA AMBIENTAL NOW S.A.S.'), 2025, 64.9 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;

-- PROASESORÍAS AMBIENTALES SAS
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'pendiente-clasificar'),
  municipio = 'Bucaramanga',
  vereda_id = null,
  direccion = 'Carrera 22 n 36-60 Apto 305 Condominio Parque 22',
  latitud = 7.086173333333333,
  longitud = -73.16496666666667,
  descripcion_corta = null,
  descripcion = null,
  producto = 'RECICLAJE DE PLASTICO',
  telefono = '3202305505',
  whatsapp = '573202305505',
  email = 'admonproasesorias@hotmail.com',
  representante_legal = 'EMILSE VERA VERA',
  nit = '901509014-8',
  naturaleza_juridica = null,
  delegado = null,
  rut_camara_comercio = null,
  responsable_cdmb = 'JUAN SEBASTIAN',
  novedad = 'INACTIVO',
  tipo_negocio_verde = 'Satisfactorio',
  anio_registro = 2021,
  cota_msnm = null,
  este = '73°9''53,88''''',
  norte = '7°5''10,224''''',
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
where nombre = 'PROASESORÍAS AMBIENTALES SAS';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select 'ecb68322-7278-4e71-a39b-62473afcdeb3', 'PROASESORÍAS AMBIENTALES SAS', generar_slug_unico('PROASESORÍAS AMBIENTALES SAS', 'ecb68322-7278-4e71-a39b-62473afcdeb3'), (select id from categorias_oficiales where slug = 'pendiente-clasificar'), 'Bucaramanga', null, 'Carrera 22 n 36-60 Apto 305 Condominio Parque 22', 7.086173333333333, -73.16496666666667, null, null, 'RECICLAJE DE PLASTICO', '3202305505', '573202305505', 'admonproasesorias@hotmail.com', 'EMILSE VERA VERA', '901509014-8', null, null, null, 'JUAN SEBASTIAN', 'INACTIVO', 'Satisfactorio', 2021, null, '73°9''53,88''''', '7°5''10,224''''', null, 'Posible retiro', null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, true, false, false, false, false
where not exists (select 1 from negocios where nombre = 'PROASESORÍAS AMBIENTALES SAS');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'PROASESORÍAS AMBIENTALES SAS');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'PROASESORÍAS AMBIENTALES SAS'), (select id from categorias_oficiales where slug = 'pendiente-clasificar');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'PROASESORÍAS AMBIENTALES SAS');
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'PROASESORÍAS AMBIENTALES SAS');
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'PROASESORÍAS AMBIENTALES SAS'), 2022, 60.47 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;

-- NANOMAC S.A.S. BIC
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'calidad-ambiental'),
  municipio = 'Bucaramanga',
  vereda_id = (select id from veredas where municipio = 'Bucaramanga' and slug = 'perimetro-urbano'),
  direccion = 'CRA 17 # 59 - 144 BODEGAS PASCAL BARRIO RICAURTE',
  latitud = 7.083444444444444,
  longitud = -73.16169444444445,
  descripcion_corta = 'Investigación, producción, desarrollo, almacenamiento y comercialización de nuevas tecnologias y productos amigables con el medio ambiente, tales como…',
  descripcion = 'Investigación, producción, desarrollo, almacenamiento y comercialización de nuevas tecnologias y productos amigables con el medio ambiente, tales como nanofluidos, nanomac, bioaditivos nano estructurados para combustibles, que ayudan a reducir la contaminación ambiental y los gases toxicos emitidos por la combustion incompleta de las fuentes moviles y fijas.',
  producto = 'BIOADITIVO NANOMAC PARA GASOLINA Y DIESEL',
  telefono = '3165062222',
  whatsapp = '573165062222',
  email = 'comercializadora.nanomac@gmail.com',
  representante_legal = 'ALEX ANTONIO NAVARRO ORTEGA',
  nit = '901069589-1',
  naturaleza_juridica = 'Jurídica',
  delegado = null,
  rut_camara_comercio = 'Cámara de comercio',
  responsable_cdmb = 'SEBASTIAN BONNET',
  novedad = 'ACTIVO',
  tipo_negocio_verde = 'Dinamizadoras',
  anio_registro = 2019,
  cota_msnm = null,
  este = '73°09''42,1''''',
  norte = '7°05''00,4''''',
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
  canal_venta = 'Mixta',
  exportacion = 'Sí',
  huella_carbono = 'NO',
  fortalezas_ambiental = 'Carbono neutralidad',
  fortalezas_social = 'Capacitaciones a los empleados',
  fortalezas_economico = 'Ahorro del combustible lo que permite mejorar la economía de sus clientes',
  emprendimiento_verde = false,
  sello_marca = false,
  avalado = true,
  destacado = false,
  activo = true
where nombre = 'NANOMAC S.A.S. BIC';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select 'd3837765-88fb-4f88-a92c-456e668319f5', 'NANOMAC S.A.S. BIC', generar_slug_unico('NANOMAC S.A.S. BIC', 'd3837765-88fb-4f88-a92c-456e668319f5'), (select id from categorias_oficiales where slug = 'calidad-ambiental'), 'Bucaramanga', (select id from veredas where municipio = 'Bucaramanga' and slug = 'perimetro-urbano'), 'CRA 17 # 59 - 144 BODEGAS PASCAL BARRIO RICAURTE', 7.083444444444444, -73.16169444444445, 'Investigación, producción, desarrollo, almacenamiento y comercialización de nuevas tecnologias y productos amigables con el medio ambiente, tales como…', 'Investigación, producción, desarrollo, almacenamiento y comercialización de nuevas tecnologias y productos amigables con el medio ambiente, tales como nanofluidos, nanomac, bioaditivos nano estructurados para combustibles, que ayudan a reducir la contaminación ambiental y los gases toxicos emitidos por la combustion incompleta de las fuentes moviles y fijas.', 'BIOADITIVO NANOMAC PARA GASOLINA Y DIESEL', '3165062222', '573165062222', 'comercializadora.nanomac@gmail.com', 'ALEX ANTONIO NAVARRO ORTEGA', '901069589-1', 'Jurídica', null, 'Cámara de comercio', 'SEBASTIAN BONNET', 'ACTIVO', 'Dinamizadoras', 2019, null, '73°09''42,1''''', '7°05''00,4''''', 'Actualizó', 'Se realizo visita y se actualizo ficha de verificacion', null, 'Sí', 'Acueducto', null, null, null, 'No', 'No', null, 'Sí', null, null, null, null, null, null, null, null, null, null, 'No', 'Mixta', 'Sí', 'NO', 'Carbono neutralidad', 'Capacitaciones a los empleados', 'Ahorro del combustible lo que permite mejorar la economía de sus clientes', false, false, true, false, true
where not exists (select 1 from negocios where nombre = 'NANOMAC S.A.S. BIC');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'NANOMAC S.A.S. BIC');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'NANOMAC S.A.S. BIC'), (select id from categorias_oficiales where slug = 'calidad-ambiental');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'NANOMAC S.A.S. BIC');
insert into negocios_subcategorias (negocio_id, subcategoria_id) select (select id from negocios where nombre = 'NANOMAC S.A.S. BIC'), id from subcategorias where slug = 'tecnologias-verdes';
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'NANOMAC S.A.S. BIC');
insert into negocios_actividades (negocio_id, actividad_productiva_id) select (select id from negocios where nombre = 'NANOMAC S.A.S. BIC'), id from actividades_productivas where slug = 'tecnologias-informacion-ambiental';
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'NANOMAC S.A.S. BIC'), 2020, 55.36 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'NANOMAC S.A.S. BIC'), 2021, 53.95 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'NANOMAC S.A.S. BIC'), 2022, 76.67 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'NANOMAC S.A.S. BIC'), 2023, 68.08 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'NANOMAC S.A.S. BIC'), 2024, 83.1 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'NANOMAC S.A.S. BIC'), 2025, 83.1 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;

-- BIO FÀCIL GRAS S.A.S
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'ecoproductos-industriales'),
  municipio = 'Rionegro',
  vereda_id = (select id from veredas where municipio = 'Rionegro' and slug = 'la-ceiba'),
  direccion = 'VEREDA LA CEIBA PARCELA VILLA GRACIA',
  latitud = 7.441166666666667,
  longitud = -73.19572333333333,
  descripcion_corta = 'Una vez se recepcióna el sebo en la planta de producción pasa al área de molido se dispone el material al alimentador del molino, este va transportado por…',
  descripcion = 'Una vez se recepcióna el sebo en la planta de producción pasa al área de molido se dispone el material al alimentador del molino, este va transportado por el sifin del molino, el cual pasa por una transformación de prensado y cortado por una cuchilla, el cual sale expulsado por la bocilla de molino y cae directamente a una paila la cual tiene una capacidad de 400 kg de grasa molida. Esta carga require de una cocción de 120 minutos a 170 grados la cual se realiza por combustion directa, posteriormente la materia prima sufre un proceso de transformación físico químico (solido a liquido) en esta parte de proceso   se observa una viscosidad amarillenta; pasamos a la parte final de proceso cual consta de 60 minutos donde se llega a su transformación final de aspecto transparente y las partículas que no se descompusieron en su totalidad se denominan proteína carne una particularidad es que flotan ; terminada esta etapa del proceso se abre la llave de paso de vaciado por la cual el aceite sale expulsado con su proteína  y es atrapado por un colador industrial ; este material es evacuado por baches  de expulsion de aceite depositados en un recipiente metálico, para su enfriamiento  es llevado al área de empace el cual se realiza en cónstales  de polipropileno los caules tienen una capacidad de 40 kilos.',
  producto = 'RECOLECCION Y TRATAMIENTO FISICO DE ACEITES DE COCINA DE UN SOLO USO',
  telefono = '3227891306',
  whatsapp = '573227891306',
  email = 'biofacilgras@gmail.com',
  representante_legal = 'YOANA ALCIRA GIL QUINTERO',
  nit = '901322670-5',
  naturaleza_juridica = 'Jurídica',
  delegado = null,
  rut_camara_comercio = 'Cámara de comercio',
  responsable_cdmb = 'DIANA NAVARRO',
  novedad = 'ACTIVO',
  tipo_negocio_verde = 'Dinamizadoras',
  anio_registro = 2022,
  cota_msnm = '464.7',
  este = '(-)73°11''44,604"',
  norte = '7°26''28,2''''',
  aplicacion_ficha_2025 = 'Actualizó',
  observaciones = 'Se realizo visita y se actualizo ficha de verificacion',
  registro_nacional_turismo = null,
  uso_suelo = 'Sí',
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
  capacidad_carga = null,
  sstt = 'No',
  canal_venta = 'Mixta',
  exportacion = 'No',
  huella_carbono = 'NO',
  fortalezas_ambiental = 'Procesos limpios. -Disposición final de nuestros residuos. -Recuperadores de material biológico (expendios de carne), cuya recolección se hace En canastillas plásticas y su trasporte vehículo Tipo furgón. -Contamos con el GSA (sistema de gestión ambiental). -Combustión con cascarilla de palma. -Frecuencia de recolección diaria lo cual evita los olores contaminan el medio ambiente, minimiza el lixiviado. -Botellas de amor. -Dia sin bolsa.',
  fortalezas_social = 'Talento humano Idóneo. -Articulación institucional. -Mejoras de las unidades productivas locativas “Fritaderos”. -Mejora continua de los procesos” entrega de molinos, -Canecas, bolsas plásticas, guantes. -Capacitación Continua. -Facilidades de pago. -Sentido de partencia en la actividad Económica. -Interacción permanente con los clientes. -Programa emprendedor. -Mejoramiento en la calidad de vida (educativo)',
  fortalezas_economico = 'Pagos contra entrega. -Aprobación oportuna de avances solicitados -Adelantos a cero intereses. -No castiga el precio por avance económico. -Facilidades de pago en maquinaria. -Cumplimiento en la frecuencia de recolección. -Actualización de precios de acuerdo al comportamiento Del mercado. -Sensibilización acerca de la economía circular',
  emprendimiento_verde = false,
  sello_marca = false,
  avalado = true,
  destacado = false,
  activo = true
where nombre = 'BIO FÀCIL GRAS S.A.S';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select '6727ae94-e40f-4a8b-853e-9d4bd784aec0', 'BIO FÀCIL GRAS S.A.S', generar_slug_unico('BIO FÀCIL GRAS S.A.S', '6727ae94-e40f-4a8b-853e-9d4bd784aec0'), (select id from categorias_oficiales where slug = 'ecoproductos-industriales'), 'Rionegro', (select id from veredas where municipio = 'Rionegro' and slug = 'la-ceiba'), 'VEREDA LA CEIBA PARCELA VILLA GRACIA', 7.441166666666667, -73.19572333333333, 'Una vez se recepcióna el sebo en la planta de producción pasa al área de molido se dispone el material al alimentador del molino, este va transportado por…', 'Una vez se recepcióna el sebo en la planta de producción pasa al área de molido se dispone el material al alimentador del molino, este va transportado por el sifin del molino, el cual pasa por una transformación de prensado y cortado por una cuchilla, el cual sale expulsado por la bocilla de molino y cae directamente a una paila la cual tiene una capacidad de 400 kg de grasa molida. Esta carga require de una cocción de 120 minutos a 170 grados la cual se realiza por combustion directa, posteriormente la materia prima sufre un proceso de transformación físico químico (solido a liquido) en esta parte de proceso   se observa una viscosidad amarillenta; pasamos a la parte final de proceso cual consta de 60 minutos donde se llega a su transformación final de aspecto transparente y las partículas que no se descompusieron en su totalidad se denominan proteína carne una particularidad es que flotan ; terminada esta etapa del proceso se abre la llave de paso de vaciado por la cual el aceite sale expulsado con su proteína  y es atrapado por un colador industrial ; este material es evacuado por baches  de expulsion de aceite depositados en un recipiente metálico, para su enfriamiento  es llevado al área de empace el cual se realiza en cónstales  de polipropileno los caules tienen una capacidad de 40 kilos.', 'RECOLECCION Y TRATAMIENTO FISICO DE ACEITES DE COCINA DE UN SOLO USO', '3227891306', '573227891306', 'biofacilgras@gmail.com', 'YOANA ALCIRA GIL QUINTERO', '901322670-5', 'Jurídica', null, 'Cámara de comercio', 'DIANA NAVARRO', 'ACTIVO', 'Dinamizadoras', 2022, '464.7', '(-)73°11''44,604"', '7°26''28,2''''', 'Actualizó', 'Se realizo visita y se actualizo ficha de verificacion', null, 'Sí', 'No', null, 'No', null, 'No', 'No', 'Sí', null, null, null, null, null, null, null, null, null, null, null, 'No', 'Mixta', 'No', 'NO', 'Procesos limpios. -Disposición final de nuestros residuos. -Recuperadores de material biológico (expendios de carne), cuya recolección se hace En canastillas plásticas y su trasporte vehículo Tipo furgón. -Contamos con el GSA (sistema de gestión ambiental). -Combustión con cascarilla de palma. -Frecuencia de recolección diaria lo cual evita los olores contaminan el medio ambiente, minimiza el lixiviado. -Botellas de amor. -Dia sin bolsa.', 'Talento humano Idóneo. -Articulación institucional. -Mejoras de las unidades productivas locativas “Fritaderos”. -Mejora continua de los procesos” entrega de molinos, -Canecas, bolsas plásticas, guantes. -Capacitación Continua. -Facilidades de pago. -Sentido de partencia en la actividad Económica. -Interacción permanente con los clientes. -Programa emprendedor. -Mejoramiento en la calidad de vida (educativo)', 'Pagos contra entrega. -Aprobación oportuna de avances solicitados -Adelantos a cero intereses. -No castiga el precio por avance económico. -Facilidades de pago en maquinaria. -Cumplimiento en la frecuencia de recolección. -Actualización de precios de acuerdo al comportamiento Del mercado. -Sensibilización acerca de la economía circular', false, false, true, false, true
where not exists (select 1 from negocios where nombre = 'BIO FÀCIL GRAS S.A.S');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'BIO FÀCIL GRAS S.A.S');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'BIO FÀCIL GRAS S.A.S'), (select id from categorias_oficiales where slug = 'ecoproductos-industriales');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'BIO FÀCIL GRAS S.A.S');
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'BIO FÀCIL GRAS S.A.S');
insert into negocios_actividades (negocio_id, actividad_productiva_id) select (select id from negocios where nombre = 'BIO FÀCIL GRAS S.A.S'), id from actividades_productivas where slug = 'aprovechamiento-residuos-inorganicos';
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'BIO FÀCIL GRAS S.A.S'), 2022, 36.24 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'BIO FÀCIL GRAS S.A.S'), 2023, 36.24 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'BIO FÀCIL GRAS S.A.S'), 2024, 61.2 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'BIO FÀCIL GRAS S.A.S'), 2025, 76.4 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;

-- EVS SOLUCIONES AMBIENTALES
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'ecoproductos-industriales'),
  municipio = 'Piedecuesta',
  vereda_id = (select id from veredas where municipio = 'Piedecuesta' and slug = 'barrio-blanco'),
  direccion = 'VEREDA BARRO BLANCO FINCA VILLA PAULINA',
  latitud = 6.980555555555556,
  longitud = -73.08027777777778,
  descripcion_corta = 'Recepcion y transformacion de residuos orgánicos insutriales y agricolas mediante lombricultura y compostaje.',
  descripcion = 'Recepcion y transformacion de residuos orgánicos insutriales y agricolas mediante lombricultura y compostaje.',
  producto = 'ACTIVIDADES DE SANAMIENTO AMBIENTAL APROVECHAMIENTO TRATAMIENTO Y TRANFORMACION DE DESECHOS NO PELIGROSO',
  telefono = '3183627116',
  whatsapp = '573183627116',
  email = 'solucionesambientalesevs@gmail.com',
  representante_legal = 'JHON SEBASTIAN QUIÑONEZ PICO',
  nit = '1098808086-1',
  naturaleza_juridica = null,
  delegado = null,
  rut_camara_comercio = null,
  responsable_cdmb = 'ANDRES VALDERRAMA',
  novedad = 'SUSPENDIDO',
  tipo_negocio_verde = 'Dinamizadoras',
  anio_registro = 2017,
  cota_msnm = '896.6 msnm',
  este = '73°4''49''''',
  norte = '6°58''50''''',
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
  buenas_practicas_agricolas = null,
  buenas_practicas_apicolas = null,
  registro_apicola = null,
  intervencion_cauce = null,
  capacidad_carga = null,
  sstt = 'No',
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
where nombre = 'EVS SOLUCIONES AMBIENTALES';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select '47eedecf-fb25-4930-ae47-dc33b9471676', 'EVS SOLUCIONES AMBIENTALES', generar_slug_unico('EVS SOLUCIONES AMBIENTALES', '47eedecf-fb25-4930-ae47-dc33b9471676'), (select id from categorias_oficiales where slug = 'ecoproductos-industriales'), 'Piedecuesta', (select id from veredas where municipio = 'Piedecuesta' and slug = 'barrio-blanco'), 'VEREDA BARRO BLANCO FINCA VILLA PAULINA', 6.980555555555556, -73.08027777777778, 'Recepcion y transformacion de residuos orgánicos insutriales y agricolas mediante lombricultura y compostaje.', 'Recepcion y transformacion de residuos orgánicos insutriales y agricolas mediante lombricultura y compostaje.', 'ACTIVIDADES DE SANAMIENTO AMBIENTAL APROVECHAMIENTO TRATAMIENTO Y TRANFORMACION DE DESECHOS NO PELIGROSO', '3183627116', '573183627116', 'solucionesambientalesevs@gmail.com', 'JHON SEBASTIAN QUIÑONEZ PICO', '1098808086-1', null, null, null, 'ANDRES VALDERRAMA', 'SUSPENDIDO', 'Dinamizadoras', 2017, '896.6 msnm', '73°4''49''''', '6°58''50''''', 'No actualizó', 'No se realizo visita ni actualizo ficha de verificacion', null, 'No', null, null, null, null, 'No', 'No', 'No', 'No', null, null, null, null, null, null, null, null, null, null, 'No', null, null, null, null, null, null, true, false, false, false, false
where not exists (select 1 from negocios where nombre = 'EVS SOLUCIONES AMBIENTALES');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'EVS SOLUCIONES AMBIENTALES');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'EVS SOLUCIONES AMBIENTALES'), (select id from categorias_oficiales where slug = 'ecoproductos-industriales');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'EVS SOLUCIONES AMBIENTALES');
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'EVS SOLUCIONES AMBIENTALES');
insert into negocios_actividades (negocio_id, actividad_productiva_id) select (select id from negocios where nombre = 'EVS SOLUCIONES AMBIENTALES'), id from actividades_productivas where slug = 'aprovechamiento-residuos-organicos';
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'EVS SOLUCIONES AMBIENTALES'), 2020, 51.45 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'EVS SOLUCIONES AMBIENTALES'), 2021, 56.11 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'EVS SOLUCIONES AMBIENTALES'), 2022, 64.44 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'EVS SOLUCIONES AMBIENTALES'), 2023, 64.44 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'EVS SOLUCIONES AMBIENTALES'), 2024, 66.9 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;

-- E-COFFEE
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'),
  municipio = 'Girón',
  vereda_id = (select id from veredas where municipio = 'Girón' and slug = 'el-cedro'),
  direccion = 'FINCA EL PARAISO VEREDA EL CEDRO - GIRON',
  latitud = null,
  longitud = null,
  descripcion_corta = 'Cultivo, transformación y comercialización de café. artificiales, los desechos del café se aprovechan para realizar el compostaje para aplicarlo al cultivo,…',
  descripcion = 'Cultivo, transformación y comercialización de café. artificiales, los desechos del café se aprovechan para realizar el compostaje para aplicarlo al cultivo, con este procedimiento se busca darle un valor agregado al producto para venderlo a un mercado especializado y generar empleo en la region.',
  producto = 'CAFÉ ECOLÓGICO',
  telefono = '3212195328',
  whatsapp = '573212195328',
  email = 'pablo01elparaiso@gmail.com',
  representante_legal = 'PABLO CHACON ROJAS',
  nit = '1098748053-9',
  naturaleza_juridica = 'Natural',
  delegado = null,
  rut_camara_comercio = 'Cámara de comercio',
  responsable_cdmb = 'ANDRES VALDERRAMA',
  novedad = 'ACTIVO',
  tipo_negocio_verde = 'Dinamizadoras',
  anio_registro = 2019,
  cota_msnm = '1.142 msnm',
  este = '1087567',
  norte = '1266240',
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
  exportacion = 'No',
  huella_carbono = 'NO',
  fortalezas_ambiental = 'Café  orgánico libre de químicos',
  fortalezas_social = 'Generan empleo en la zona aledaña',
  fortalezas_economico = 'No se compran abonos quimicos sino que realizan su propio compostaje',
  emprendimiento_verde = true,
  sello_marca = false,
  avalado = false,
  destacado = false,
  activo = true
where nombre = 'E-COFFEE';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select '87f24035-72ce-43db-9568-3fad72eef8be', 'E-COFFEE', generar_slug_unico('E-COFFEE', '87f24035-72ce-43db-9568-3fad72eef8be'), (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'), 'Girón', (select id from veredas where municipio = 'Girón' and slug = 'el-cedro'), 'FINCA EL PARAISO VEREDA EL CEDRO - GIRON', null, null, 'Cultivo, transformación y comercialización de café. artificiales, los desechos del café se aprovechan para realizar el compostaje para aplicarlo al cultivo,…', 'Cultivo, transformación y comercialización de café. artificiales, los desechos del café se aprovechan para realizar el compostaje para aplicarlo al cultivo, con este procedimiento se busca darle un valor agregado al producto para venderlo a un mercado especializado y generar empleo en la region.', 'CAFÉ ECOLÓGICO', '3212195328', '573212195328', 'pablo01elparaiso@gmail.com', 'PABLO CHACON ROJAS', '1098748053-9', 'Natural', null, 'Cámara de comercio', 'ANDRES VALDERRAMA', 'ACTIVO', 'Dinamizadoras', 2019, '1.142 msnm', '1087567', '1266240', 'Actualizó', 'Se realizo visita y se actualizo ficha de verificacion', null, 'No', 'Acueducto veredal', null, null, null, 'No', 'No', 'No', 'Sí', null, null, 'No', null, null, 'No', null, null, null, null, 'No', 'Mixta', 'No', 'NO', 'Café  orgánico libre de químicos', 'Generan empleo en la zona aledaña', 'No se compran abonos quimicos sino que realizan su propio compostaje', true, false, false, false, true
where not exists (select 1 from negocios where nombre = 'E-COFFEE');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'E-COFFEE');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'E-COFFEE'), (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'E-COFFEE');
insert into negocios_subcategorias (negocio_id, subcategoria_id) select (select id from negocios where nombre = 'E-COFFEE'), id from subcategorias where slug = 'agrosistemas-sostenibles';
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'E-COFFEE');
insert into negocios_actividades (negocio_id, actividad_productiva_id) select (select id from negocios where nombre = 'E-COFFEE'), id from actividades_productivas where slug = 'agroecologia';
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'E-COFFEE'), 2021, 45.1 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'E-COFFEE'), 2022, 56.62 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'E-COFFEE'), 2023, 56.03 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'E-COFFEE'), 2024, 66.4 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'E-COFFEE'), 2025, 66.4 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;

-- CHOCOLATE ARTESANAL ALNATURAL
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'),
  municipio = 'Floridablanca',
  vereda_id = (select id from veredas where municipio = 'Floridablanca' and slug = 'vericute'),
  direccion = 'KM 1, FINCAR EL PORVENIR, VEREDA VERICUTE',
  latitud = 7.086523888888888,
  longitud = -73.0761111111111,
  descripcion_corta = 'La empresa Chocolate Artesanal Alnatural nace de la coyuntura por la que atravesaron los cultivos de cacao en la region,
 ya que los precios de venta no…',
  descripcion = 'La empresa Chocolate Artesanal Alnatural nace de la coyuntura por la que atravesaron los cultivos de cacao en la region,
 ya que los precios de venta no cubrian los gastos de mantenimiento de los cultivos hacia el año 2014. Se tuvo la iniciativa 
de comenzar a emprender con la transformacion del cacao y sacar al mercado el chocolate de mesa con azucar. Cuentan 
con cultivos propios, con manejo agroecologico, libre de aqroquimicos y plaguicidas, dedicandose a la  recoleccion y 
transformacion de cacao en chocolate de mesa y chocolateria.',
  producto = 'CHOCOLATE DE MESA',
  telefono = '3212963939- 3108789207',
  whatsapp = '3212963939- 3108789207',
  email = 'choco.alnatural@gmail.com',
  representante_legal = 'ABIGAIL JAIMES VILLAMIZAR',
  nit = '63361946-1',
  naturaleza_juridica = 'Natural',
  delegado = 'RICARDO CENTENO',
  rut_camara_comercio = 'Cámara de comercio',
  responsable_cdmb = 'CARINE GARCIA',
  novedad = 'ACTIVO',
  tipo_negocio_verde = 'Dinamizadoras',
  anio_registro = 2018,
  cota_msnm = '1.120 msnm',
  este = '73°4''34''127',
  norte = '7°5''11,486''''',
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
  invima_vencimiento = '2031-10-21',
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
  fortalezas_ambiental = 'Cultivan su propio cacao orgánico, sin uso de agroquímicos.
 , Controlan toda la cadena de valor (desde la siembra hasta el producto final).
 • Promueven la agricultura sostenible y la conservación del suelo.
 • Producción artesanal con bajo impacto ambiental.
 • Aprovechamiento completo del fruto en distintos productos (chocolate, untable, trufas).
 • Fomento del consumo local, reduciendo la huella de transporte y emisiones.',
  fortalezas_social = 'Liderado por adultos mayores con gran experiencia, compromiso y saber tradicional.
 • Transmisión de conocimientos sobre el cultivo del cacao y la elaboración artesanal.
 • Genera empleo familiar y mantiene viva la cultura cacaotera local.
 • Participan activamente en ferias locales y regionales, compartiendo su historia y producto.
 • El punto de venta en el santisimo crea un espacio de encuentro y convivencia comunitaria.',
  fortalezas_economico = 'Cuentan con registro INVIMA, lo que respalda su formalización y calidad sanitaria.
 • Producen y transforman su propio cacao, lo que reduce costos de materia prima.
 • Ofrecen diversificación de productos: chocolate de mesa, untable “Chocoinchi”, trufas.
 • Tienen punto de venta propio y presencia en ferias que fortalecen el contacto con clientes.
 • Producto con alto potencial en el mercado de cacao orgánico y artesanal.
Cuentan con registro INVIMA, lo que respalda su formalización y calidad sanitaria.
 • Producen y transforman su propio cacao, lo que reduce costos de materia prima.
 • Ofrecen diversificación de productos: chocolate de mesa, untable “Chocoinchi”, trufas.
 • Tienen punto de venta propio y presencia en ferias que fortalecen el contacto con clientes.
 • Producto con alto potencial en el mercado de cacao orgánico y artesanal.
Cuentan con registro INVIMA, lo que respalda su formalización y calidad sanitaria.
 • Producen y transforman su propio cacao, lo que reduce costos de materia prima.
 • Ofrecen diversificación de productos: chocolate de mesa, untable “Chocoinchi”, trufas.
 • Tienen punto de venta propio y presencia en ferias que fortalecen el contacto con clientes.
 • Producto con alto potencial en el mercado de cacao orgánico y artesanal.
Cuentan con registro INVIMA, lo que respalda su formalización y calidad sanitaria.
 • Producen y transforman su propio cacao, lo que reduce costos de materia prima.
 • Ofrecen diversificación de productos: chocolate de mesa, untable “Chocoinchi”, trufas.
 • Tienen punto de venta propio y presencia en ferias que fortalecen el contacto con clientes.
 • Producto con alto potencial en el mercado de cacao orgánico y artesanal.
Cuentan con registro INVIMA, lo que respalda su formalización y calidad sanitaria.
 • Producen y transforman su propio cacao, lo que reduce costos de materia prima.
 • Ofrecen diversificación de productos: chocolate de mesa, untable “Chocoinchi”, trufas.
 • Tienen punto de venta propio y presencia en ferias que fortalecen el contacto con clientes.
 • Producto con alto potencial en el mercado de cacao orgánico y artesanal.',
  emprendimiento_verde = false,
  sello_marca = false,
  avalado = true,
  destacado = false,
  activo = true
where nombre = 'CHOCOLATE ARTESANAL ALNATURAL';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select '7dc06c09-7473-4c14-af64-44d3ea44920f', 'CHOCOLATE ARTESANAL ALNATURAL', generar_slug_unico('CHOCOLATE ARTESANAL ALNATURAL', '7dc06c09-7473-4c14-af64-44d3ea44920f'), (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'), 'Floridablanca', (select id from veredas where municipio = 'Floridablanca' and slug = 'vericute'), 'KM 1, FINCAR EL PORVENIR, VEREDA VERICUTE', 7.086523888888888, -73.0761111111111, 'La empresa Chocolate Artesanal Alnatural nace de la coyuntura por la que atravesaron los cultivos de cacao en la region,
 ya que los precios de venta no…', 'La empresa Chocolate Artesanal Alnatural nace de la coyuntura por la que atravesaron los cultivos de cacao en la region,
 ya que los precios de venta no cubrian los gastos de mantenimiento de los cultivos hacia el año 2014. Se tuvo la iniciativa 
de comenzar a emprender con la transformacion del cacao y sacar al mercado el chocolate de mesa con azucar. Cuentan 
con cultivos propios, con manejo agroecologico, libre de aqroquimicos y plaguicidas, dedicandose a la  recoleccion y 
transformacion de cacao en chocolate de mesa y chocolateria.', 'CHOCOLATE DE MESA', '3212963939- 3108789207', '3212963939- 3108789207', 'choco.alnatural@gmail.com', 'ABIGAIL JAIMES VILLAMIZAR', '63361946-1', 'Natural', 'RICARDO CENTENO', 'Cámara de comercio', 'CARINE GARCIA', 'ACTIVO', 'Dinamizadoras', 2018, '1.120 msnm', '73°4''34''127', '7°5''11,486''''', 'Actualizó', null, null, 'No', 'Acueducto veredal', null, null, null, 'No', 'No', 'Sí', null, null, null, 'Sí', '2031-10-21', null, 'No', null, null, null, null, 'No', 'B2C', 'No', 'NO', 'Cultivan su propio cacao orgánico, sin uso de agroquímicos.
 , Controlan toda la cadena de valor (desde la siembra hasta el producto final).
 • Promueven la agricultura sostenible y la conservación del suelo.
 • Producción artesanal con bajo impacto ambiental.
 • Aprovechamiento completo del fruto en distintos productos (chocolate, untable, trufas).
 • Fomento del consumo local, reduciendo la huella de transporte y emisiones.', 'Liderado por adultos mayores con gran experiencia, compromiso y saber tradicional.
 • Transmisión de conocimientos sobre el cultivo del cacao y la elaboración artesanal.
 • Genera empleo familiar y mantiene viva la cultura cacaotera local.
 • Participan activamente en ferias locales y regionales, compartiendo su historia y producto.
 • El punto de venta en el santisimo crea un espacio de encuentro y convivencia comunitaria.', 'Cuentan con registro INVIMA, lo que respalda su formalización y calidad sanitaria.
 • Producen y transforman su propio cacao, lo que reduce costos de materia prima.
 • Ofrecen diversificación de productos: chocolate de mesa, untable “Chocoinchi”, trufas.
 • Tienen punto de venta propio y presencia en ferias que fortalecen el contacto con clientes.
 • Producto con alto potencial en el mercado de cacao orgánico y artesanal.
Cuentan con registro INVIMA, lo que respalda su formalización y calidad sanitaria.
 • Producen y transforman su propio cacao, lo que reduce costos de materia prima.
 • Ofrecen diversificación de productos: chocolate de mesa, untable “Chocoinchi”, trufas.
 • Tienen punto de venta propio y presencia en ferias que fortalecen el contacto con clientes.
 • Producto con alto potencial en el mercado de cacao orgánico y artesanal.
Cuentan con registro INVIMA, lo que respalda su formalización y calidad sanitaria.
 • Producen y transforman su propio cacao, lo que reduce costos de materia prima.
 • Ofrecen diversificación de productos: chocolate de mesa, untable “Chocoinchi”, trufas.
 • Tienen punto de venta propio y presencia en ferias que fortalecen el contacto con clientes.
 • Producto con alto potencial en el mercado de cacao orgánico y artesanal.
Cuentan con registro INVIMA, lo que respalda su formalización y calidad sanitaria.
 • Producen y transforman su propio cacao, lo que reduce costos de materia prima.
 • Ofrecen diversificación de productos: chocolate de mesa, untable “Chocoinchi”, trufas.
 • Tienen punto de venta propio y presencia en ferias que fortalecen el contacto con clientes.
 • Producto con alto potencial en el mercado de cacao orgánico y artesanal.
Cuentan con registro INVIMA, lo que respalda su formalización y calidad sanitaria.
 • Producen y transforman su propio cacao, lo que reduce costos de materia prima.
 • Ofrecen diversificación de productos: chocolate de mesa, untable “Chocoinchi”, trufas.
 • Tienen punto de venta propio y presencia en ferias que fortalecen el contacto con clientes.
 • Producto con alto potencial en el mercado de cacao orgánico y artesanal.', false, false, true, false, true
where not exists (select 1 from negocios where nombre = 'CHOCOLATE ARTESANAL ALNATURAL');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'CHOCOLATE ARTESANAL ALNATURAL');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'CHOCOLATE ARTESANAL ALNATURAL'), (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'CHOCOLATE ARTESANAL ALNATURAL');
insert into negocios_subcategorias (negocio_id, subcategoria_id) select (select id from negocios where nombre = 'CHOCOLATE ARTESANAL ALNATURAL'), id from subcategorias where slug = 'agroindustria-sostenible';
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'CHOCOLATE ARTESANAL ALNATURAL');
insert into negocios_actividades (negocio_id, actividad_productiva_id) select (select id from negocios where nombre = 'CHOCOLATE ARTESANAL ALNATURAL'), id from actividades_productivas where slug = 'agroindustrial-alimentario';
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'CHOCOLATE ARTESANAL ALNATURAL'), 2020, 42.76 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'CHOCOLATE ARTESANAL ALNATURAL'), 2021, 40.73 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'CHOCOLATE ARTESANAL ALNATURAL'), 2022, 49.5 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'CHOCOLATE ARTESANAL ALNATURAL'), 2023, 51.24 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'CHOCOLATE ARTESANAL ALNATURAL'), 2024, 64.2 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'CHOCOLATE ARTESANAL ALNATURAL'), 2025, 58.6 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;

-- ALIANZA PORKCOLOMBIA-FABIO SANTOS
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'pendiente-clasificar'),
  municipio = 'Rionegro',
  vereda_id = null,
  direccion = 'Finca Palermo, Vereda Piletas-Rionegro',
  latitud = null,
  longitud = null,
  descripcion_corta = null,
  descripcion = null,
  producto = 'CERDO EN PIE',
  telefono = '3134577598',
  whatsapp = '573134577598',
  email = 'fabiosr1966@hotmail.com',
  representante_legal = 'FABIO SANTOS',
  nit = '91245228',
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
where nombre = 'ALIANZA PORKCOLOMBIA-FABIO SANTOS';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select 'e77d3002-f84e-417a-8c8a-8d56fbd50c6e', 'ALIANZA PORKCOLOMBIA-FABIO SANTOS', generar_slug_unico('ALIANZA PORKCOLOMBIA-FABIO SANTOS', 'e77d3002-f84e-417a-8c8a-8d56fbd50c6e'), (select id from categorias_oficiales where slug = 'pendiente-clasificar'), 'Rionegro', null, 'Finca Palermo, Vereda Piletas-Rionegro', null, null, null, null, 'CERDO EN PIE', '3134577598', '573134577598', 'fabiosr1966@hotmail.com', 'FABIO SANTOS', '91245228', null, null, null, null, 'RETIRADO', null, 2020, null, null, null, null, 'Retirado', null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, true, false, false, false, false
where not exists (select 1 from negocios where nombre = 'ALIANZA PORKCOLOMBIA-FABIO SANTOS');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'ALIANZA PORKCOLOMBIA-FABIO SANTOS');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'ALIANZA PORKCOLOMBIA-FABIO SANTOS'), (select id from categorias_oficiales where slug = 'pendiente-clasificar');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'ALIANZA PORKCOLOMBIA-FABIO SANTOS');
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'ALIANZA PORKCOLOMBIA-FABIO SANTOS');
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'ALIANZA PORKCOLOMBIA-FABIO SANTOS'), 2020, 30.5 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;

-- FUNBIOVIDA
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'pendiente-clasificar'),
  municipio = 'Rionegro',
  vereda_id = null,
  direccion = null,
  latitud = null,
  longitud = null,
  descripcion_corta = null,
  descripcion = null,
  producto = 'ABONOS ORGÁNICOS',
  telefono = '3106999823-3163382563',
  whatsapp = '3106999823-3163382563',
  email = 'biovidalahonda@gmail.com',
  representante_legal = 'JOSE ROMERO AGUILLÓN',
  nit = null,
  naturaleza_juridica = null,
  delegado = null,
  rut_camara_comercio = null,
  responsable_cdmb = null,
  novedad = 'RETIRADO',
  tipo_negocio_verde = null,
  anio_registro = 2021,
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
where nombre = 'FUNBIOVIDA';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select '3e918c6c-c2d2-4a08-803e-167a15000aed', 'FUNBIOVIDA', generar_slug_unico('FUNBIOVIDA', '3e918c6c-c2d2-4a08-803e-167a15000aed'), (select id from categorias_oficiales where slug = 'pendiente-clasificar'), 'Rionegro', null, null, null, null, null, null, 'ABONOS ORGÁNICOS', '3106999823-3163382563', '3106999823-3163382563', 'biovidalahonda@gmail.com', 'JOSE ROMERO AGUILLÓN', null, null, null, null, null, 'RETIRADO', null, 2021, null, null, null, null, 'Revisión si aplica retiro', null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, true, false, false, false, false
where not exists (select 1 from negocios where nombre = 'FUNBIOVIDA');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'FUNBIOVIDA');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'FUNBIOVIDA'), (select id from categorias_oficiales where slug = 'pendiente-clasificar');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'FUNBIOVIDA');
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'FUNBIOVIDA');

-- AGROVIVE
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'ecoproductos-industriales'),
  municipio = 'Rionegro',
  vereda_id = (select id from veredas where municipio = 'Rionegro' and slug = 'san-jose-arevalo'),
  direccion = 'VEREDA SAN JOSÉ DE ARÉVALO FINCA LA TACHUELA',
  latitud = 7.319038888888889,
  longitud = -73.18238611111111,
  descripcion_corta = 'Realizar y promover la producción, transformación y comercialización de productos orgánicos agrícolas y pecuarios, elaboración de insumos agrícolas…',
  descripcion = 'Realizar y promover la producción, transformación y comercialización de productos orgánicos agrícolas y pecuarios, elaboración de insumos agrícolas orgánicos, principalmente fertilizantes líquidos y sólidos, de tal forma que permita consolidar a la asociación como una organización promotora de la producción agropecuaria amigable con el medio ambiente.',
  producto = 'FERTILIZANTE LIQUIDO, ACONDICIONADOR DE SUELO Y FERTILIZANTE SOLIDO',
  telefono = '3163340263-',
  whatsapp = '3163340263-',
  email = 'guiareyes@hotmail.com',
  representante_legal = 'GUILLERMO ALBERTO REYES',
  nit = '900989390-7',
  naturaleza_juridica = 'Jurídica',
  delegado = null,
  rut_camara_comercio = 'Cámara de comercio',
  responsable_cdmb = 'SILVIA VALDIVIESO',
  novedad = 'ACTIVO',
  tipo_negocio_verde = null,
  anio_registro = 2021,
  cota_msnm = '1190 msnm',
  este = '73°10''56,59"',
  norte = '7°19''8,54"',
  aplicacion_ficha_2025 = 'Actualizó',
  observaciones = 'Se realizo visita y se aplico ficha de verificacion',
  registro_nacional_turismo = null,
  uso_suelo = 'Sí',
  concesion_aguas = 'No',
  concesion_aguas_vencimiento = null,
  vertimientos = 'No',
  vertimientos_vencimiento = null,
  pueaa = 'No',
  pgris = 'No',
  pozo_septico = 'Sí',
  alcantarillado = null,
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
  fortalezas_ambiental = 'Cultivo de manejo Agroecológico con sistema agroforestal. Buenas prácticas hídricas (uso de aguas lluvias)',
  fortalezas_social = 'Trabajo asociativo, inclusión laboral (campesinos y reinsertados)',
  fortalezas_economico = 'Diversificación de productos',
  emprendimiento_verde = true,
  sello_marca = false,
  avalado = false,
  destacado = false,
  activo = true
where nombre = 'AGROVIVE';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select '5ba2d5dc-bef0-493b-89d3-da7509e07be1', 'AGROVIVE', generar_slug_unico('AGROVIVE', '5ba2d5dc-bef0-493b-89d3-da7509e07be1'), (select id from categorias_oficiales where slug = 'ecoproductos-industriales'), 'Rionegro', (select id from veredas where municipio = 'Rionegro' and slug = 'san-jose-arevalo'), 'VEREDA SAN JOSÉ DE ARÉVALO FINCA LA TACHUELA', 7.319038888888889, -73.18238611111111, 'Realizar y promover la producción, transformación y comercialización de productos orgánicos agrícolas y pecuarios, elaboración de insumos agrícolas…', 'Realizar y promover la producción, transformación y comercialización de productos orgánicos agrícolas y pecuarios, elaboración de insumos agrícolas orgánicos, principalmente fertilizantes líquidos y sólidos, de tal forma que permita consolidar a la asociación como una organización promotora de la producción agropecuaria amigable con el medio ambiente.', 'FERTILIZANTE LIQUIDO, ACONDICIONADOR DE SUELO Y FERTILIZANTE SOLIDO', '3163340263-', '3163340263-', 'guiareyes@hotmail.com', 'GUILLERMO ALBERTO REYES', '900989390-7', 'Jurídica', null, 'Cámara de comercio', 'SILVIA VALDIVIESO', 'ACTIVO', null, 2021, '1190 msnm', '73°10''56,59"', '7°19''8,54"', 'Actualizó', 'Se realizo visita y se aplico ficha de verificacion', null, 'Sí', 'No', null, 'No', null, 'No', 'No', 'Sí', null, 'No', null, null, null, null, null, null, null, null, null, 'No', 'Mixta', 'No', 'NO', 'Cultivo de manejo Agroecológico con sistema agroforestal. Buenas prácticas hídricas (uso de aguas lluvias)', 'Trabajo asociativo, inclusión laboral (campesinos y reinsertados)', 'Diversificación de productos', true, false, false, false, true
where not exists (select 1 from negocios where nombre = 'AGROVIVE');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'AGROVIVE');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'AGROVIVE'), (select id from categorias_oficiales where slug = 'ecoproductos-industriales');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'AGROVIVE');
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'AGROVIVE');
insert into negocios_actividades (negocio_id, actividad_productiva_id) select (select id from negocios where nombre = 'AGROVIVE'), id from actividades_productivas where slug = 'aprovechamiento-residuos-organicos';
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'AGROVIVE'), 2021, 34.5 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'AGROVIVE'), 2022, 36.17 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'AGROVIVE'), 2023, 36.17 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'AGROVIVE'), 2024, 55.4 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'AGROVIVE'), 2025, 55.4 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;

-- AZRENTAME SAS
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'pendiente-clasificar'),
  municipio = 'Girón',
  vereda_id = null,
  direccion = null,
  latitud = null,
  longitud = null,
  descripcion_corta = null,
  descripcion = null,
  producto = 'ALQUILER CANCHAS DE FÚTBOL',
  telefono = null,
  whatsapp = null,
  email = null,
  representante_legal = null,
  nit = '901373677-4',
  naturaleza_juridica = null,
  delegado = null,
  rut_camara_comercio = null,
  responsable_cdmb = null,
  novedad = 'RETIRADO',
  tipo_negocio_verde = 'No aplica',
  anio_registro = 2021,
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
where nombre = 'AZRENTAME SAS';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select 'c17764b0-3002-4c65-bd65-56bd4b5339cc', 'AZRENTAME SAS', generar_slug_unico('AZRENTAME SAS', 'c17764b0-3002-4c65-bd65-56bd4b5339cc'), (select id from categorias_oficiales where slug = 'pendiente-clasificar'), 'Girón', null, null, null, null, null, null, 'ALQUILER CANCHAS DE FÚTBOL', null, null, null, null, '901373677-4', null, null, null, null, 'RETIRADO', 'No aplica', 2021, null, null, null, null, 'No cumplimiento de requisitos', null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, true, false, false, false, false
where not exists (select 1 from negocios where nombre = 'AZRENTAME SAS');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'AZRENTAME SAS');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'AZRENTAME SAS'), (select id from categorias_oficiales where slug = 'pendiente-clasificar');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'AZRENTAME SAS');
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'AZRENTAME SAS');

-- ESCOMBRERA OASIS
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'ecoproductos-industriales'),
  municipio = 'Bucaramanga',
  vereda_id = (select id from veredas where municipio = 'Bucaramanga' and slug = 'santos-bajo'),
  direccion = 'KILOMETRO 6 VIA A MATANZA',
  latitud = 7.152222222222223,
  longitud = -73.1125,
  descripcion_corta = 'Presta el servicio de disposición final de desechos de poda y tala de arboles.  autorizado por la cdmb.  aprovecha los residuos vegetales y los transforma…',
  descripcion = 'Presta el servicio de disposición final de desechos de poda y tala de arboles.  autorizado por la cdmb.  aprovecha los residuos vegetales y los transforma en mejoradores de suelo (abonos) para comercializarlo',
  producto = 'DISPOSICION FINAL DE DESECHOS DE PODA Y TALA VEGETAL',
  telefono = '3173871395',
  whatsapp = '573173871395',
  email = 'lclopezc@yahoo.es',
  representante_legal = 'LUIS CARLOS LOPEZ CELY',
  nit = '13847194-3',
  naturaleza_juridica = 'Natural',
  delegado = null,
  rut_camara_comercio = 'Cámara de comercio',
  responsable_cdmb = 'SILVIA VALDIVIESO',
  novedad = 'ACTIVO',
  tipo_negocio_verde = 'Dinamizadoras',
  anio_registro = 2016,
  cota_msnm = '744.8',
  este = '73°6''45''''',
  norte = '7°9''8''''',
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
  pozo_septico = 'No',
  alcantarillado = null,
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
  fortalezas_ambiental = 'Mejorador de suelo orgánico que lo utiliza para el vivero. Genera ingresa para otros terceros',
  fortalezas_social = 'Presta el salón para dar curso sobre el medio ambiente. Dona abono',
  fortalezas_economico = 'Modelo de negocio sostenible. Empresa legalmente registrada en Cámara de Comercio y rut',
  emprendimiento_verde = true,
  sello_marca = false,
  avalado = false,
  destacado = false,
  activo = true
where nombre = 'ESCOMBRERA OASIS';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select '434f8eae-d08a-4e0b-9211-f5ec0690cc6d', 'ESCOMBRERA OASIS', generar_slug_unico('ESCOMBRERA OASIS', '434f8eae-d08a-4e0b-9211-f5ec0690cc6d'), (select id from categorias_oficiales where slug = 'ecoproductos-industriales'), 'Bucaramanga', (select id from veredas where municipio = 'Bucaramanga' and slug = 'santos-bajo'), 'KILOMETRO 6 VIA A MATANZA', 7.152222222222223, -73.1125, 'Presta el servicio de disposición final de desechos de poda y tala de arboles.  autorizado por la cdmb.  aprovecha los residuos vegetales y los transforma…', 'Presta el servicio de disposición final de desechos de poda y tala de arboles.  autorizado por la cdmb.  aprovecha los residuos vegetales y los transforma en mejoradores de suelo (abonos) para comercializarlo', 'DISPOSICION FINAL DE DESECHOS DE PODA Y TALA VEGETAL', '3173871395', '573173871395', 'lclopezc@yahoo.es', 'LUIS CARLOS LOPEZ CELY', '13847194-3', 'Natural', null, 'Cámara de comercio', 'SILVIA VALDIVIESO', 'ACTIVO', 'Dinamizadoras', 2016, '744.8', '73°6''45''''', '7°9''8''''', 'Actualizó', 'Se realizo visita y se actualizo ficha de verificacion', null, 'Sí', 'Acueducto veredal', null, null, null, 'No', 'No', 'No', null, 'No', null, null, null, null, null, null, null, null, null, 'No', 'B2B', 'No', 'NO', 'Mejorador de suelo orgánico que lo utiliza para el vivero. Genera ingresa para otros terceros', 'Presta el salón para dar curso sobre el medio ambiente. Dona abono', 'Modelo de negocio sostenible. Empresa legalmente registrada en Cámara de Comercio y rut', true, false, false, false, true
where not exists (select 1 from negocios where nombre = 'ESCOMBRERA OASIS');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'ESCOMBRERA OASIS');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'ESCOMBRERA OASIS'), (select id from categorias_oficiales where slug = 'ecoproductos-industriales');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'ESCOMBRERA OASIS');
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'ESCOMBRERA OASIS');
insert into negocios_actividades (negocio_id, actividad_productiva_id) select (select id from negocios where nombre = 'ESCOMBRERA OASIS'), id from actividades_productivas where slug = 'aprovechamiento-residuos-organicos';
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'ESCOMBRERA OASIS'), 2020, 34.32 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'ESCOMBRERA OASIS'), 2021, 39.83 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'ESCOMBRERA OASIS'), 2022, 48.2 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'ESCOMBRERA OASIS'), 2023, 52.65 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'ESCOMBRERA OASIS'), 2024, 55.0 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
insert into negocio_puntajes (negocio_id, anio, puntaje) select (select id from negocios where nombre = 'ESCOMBRERA OASIS'), 2025, 54.7 on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;

-- EMPRENDIMIENTO APÍCOLA SANTA INÉS
update negocios set
  categoria_oficial_id = (select id from categorias_oficiales where slug = 'pendiente-clasificar'),
  municipio = 'Matanza',
  vereda_id = null,
  direccion = null,
  latitud = null,
  longitud = null,
  descripcion_corta = null,
  descripcion = null,
  producto = 'MIEL',
  telefono = '3042905111',
  whatsapp = '573042905111',
  email = 'juanhumbertobecerra@mac.com',
  representante_legal = 'JUAN HUMBERTO BECERRA',
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
where nombre = 'EMPRENDIMIENTO APÍCOLA SANTA INÉS';
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo)
select 'b2771ad1-116f-4b33-bff9-edb7545ab9b5', 'EMPRENDIMIENTO APÍCOLA SANTA INÉS', generar_slug_unico('EMPRENDIMIENTO APÍCOLA SANTA INÉS', 'b2771ad1-116f-4b33-bff9-edb7545ab9b5'), (select id from categorias_oficiales where slug = 'pendiente-clasificar'), 'Matanza', null, null, null, null, null, null, 'MIEL', '3042905111', '573042905111', 'juanhumbertobecerra@mac.com', 'JUAN HUMBERTO BECERRA', null, null, null, null, null, 'RETIRADO', null, 2020, null, null, null, null, 'Posible retiro', null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, true, false, false, false, false
where not exists (select 1 from negocios where nombre = 'EMPRENDIMIENTO APÍCOLA SANTA INÉS');
delete from negocios_categorias where negocio_id = (select id from negocios where nombre = 'EMPRENDIMIENTO APÍCOLA SANTA INÉS');
insert into negocios_categorias (negocio_id, categoria_oficial_id) select (select id from negocios where nombre = 'EMPRENDIMIENTO APÍCOLA SANTA INÉS'), (select id from categorias_oficiales where slug = 'pendiente-clasificar');
delete from negocios_subcategorias where negocio_id = (select id from negocios where nombre = 'EMPRENDIMIENTO APÍCOLA SANTA INÉS');
delete from negocios_actividades where negocio_id = (select id from negocios where nombre = 'EMPRENDIMIENTO APÍCOLA SANTA INÉS');


commit;
