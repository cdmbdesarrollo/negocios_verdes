begin;

-- Generado por lib/migraciones/generar_0026.py desde BASE_ACTUALIZADA_NV_ka.xlsx — no editar a mano.
-- Uno de varios archivos partidos (ver README.md) — correr TODOS, en cualquier orden, cada uno es su propia transacción.

-- Parte 9 de 9.

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

-- SETAS DE LA MESA
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo) values ('53155cc1-cbc7-42a8-8fd0-5fb2df8c0f63', 'SETAS DE LA MESA', generar_slug_unico('SETAS DE LA MESA', '53155cc1-cbc7-42a8-8fd0-5fb2df8c0f63'), (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'), 'Piedecuesta', (select id from veredas where municipio = 'Piedecuesta' and slug = 'el-duende'), 'FINCA VILLA PEPA VEREDA EL DUENDE, MUNICIPIO DE PIEDECUESTA', null, null, 'Setas de la Mesa se dedica a la producción y comercialización de orellanas y derivados, incluyendo orellanas frescas, carne molida vegetal a base de hongo,…', 'Setas de la Mesa se dedica a la producción y comercialización de orellanas y derivados, incluyendo orellanas frescas, carne molida vegetal a base de hongo, hamburguesas de orellana y antipastos artesanales. Su actividad integra procesos sostenibles de cultivo y transformación para ofrecer alimentos saludables y de origen responsable.', 'ORELLANAS FRESCAS', '3144751018', '573144751018', 'albitaluci1589@gmail.com', 'ALBA LUCÍA SOLANO RÍOS', '1026261895', 'Natural', null, 'RUT', 'LILIANA CACERES', 'ACTIVO', 'Intermedio', 2025, '1722', '78°06´5713"', '6°89´3093"', 'Actualizó', 'Se realizo visita y se aplico ficha de verificacion', null, 'No', 'No', null, 'No', null, 'No', 'No', 'No', null, null, null, 'No', null, null, 'No', null, null, null, null, 'No', 'B2B', 'No', 'NO', null, null, null, true, false, false, false, true);
insert into negocios_categorias (negocio_id, categoria_oficial_id) values ('53155cc1-cbc7-42a8-8fd0-5fb2df8c0f63', (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'));
insert into negocios_subcategorias (negocio_id, subcategoria_id) select '53155cc1-cbc7-42a8-8fd0-5fb2df8c0f63', id from subcategorias where slug = 'agroindustria-sostenible';
insert into negocios_actividades (negocio_id, actividad_productiva_id) select '53155cc1-cbc7-42a8-8fd0-5fb2df8c0f63', id from actividades_productivas where slug = 'agroindustrial-alimentario';
insert into negocio_puntajes (negocio_id, anio, puntaje) values ('53155cc1-cbc7-42a8-8fd0-5fb2df8c0f63', 2025, 48.7) on conflict (negocio_id, anio) do nothing;

-- MY BEE HAPPY
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo) values ('229fff2a-dfa2-46a4-9cb6-4317bf4fbc0d', 'MY BEE HAPPY', generar_slug_unico('MY BEE HAPPY', '229fff2a-dfa2-46a4-9cb6-4317bf4fbc0d'), (select id from categorias_oficiales where slug = 'pendiente-clasificar'), 'Piedecuesta', (select id from veredas where municipio = 'Piedecuesta' and slug = 'la-colombiana'), 'CORREGIMIENTO UMPALA FINCA EL TUNA', null, null, null, null, 'MIEL Y POLEN DE ABEJAS', '3175557537', '573175557537', 'condecondewillian@gmail.com', 'WILLIAM CONDE CONDE', '91353589', null, null, null, 'HEINER ORTIZ', 'ACTIVO', null, 2025, null, null, null, null, 'No se ha realizado visita', null, 'No', 'No', null, 'No', null, 'No', 'No', 'No', null, null, null, 'No', null, null, null, 'No', 'No', null, null, 'No', 'B2C', 'No', 'NO', null, null, null, true, false, false, false, true);
insert into negocios_categorias (negocio_id, categoria_oficial_id) values ('229fff2a-dfa2-46a4-9cb6-4317bf4fbc0d', (select id from categorias_oficiales where slug = 'pendiente-clasificar'));

-- MOISSA CHOCOLATE
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo) values ('596f1394-0076-44e9-a0a6-d3987fa2b9ef', 'MOISSA CHOCOLATE', generar_slug_unico('MOISSA CHOCOLATE', '596f1394-0076-44e9-a0a6-d3987fa2b9ef'), (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'), 'Piedecuesta', (select id from veredas where municipio = 'Piedecuesta' and slug = 'umpala'), 'VEREDA UMPALA FINCA EL PUENTE - FINCA LAS BRISAS CALLEJUELA 240 VEREDA UMPALA', null, null, 'Cultivo y Producción de Cacao Orgánico:  siembra, cultivo, mantenimiento, cosecha y comercialización de granos de cacao y transformación en Chocolate de Mesa', 'Cultivo y Producción de Cacao Orgánico:  siembra, cultivo, mantenimiento, cosecha y comercialización de granos de cacao y transformación en Chocolate de Mesa', 'CHOCOLATE DE MESA', '3246647389', '573246647389', 'angelmpz9@gmail.com', 'ANGEL MAURICIO PORRAS ZABALA', '91498346-1', 'Natural', null, 'Cámara de comercio', 'NATALY RAMIREZ', 'ACTIVO', null, 2025, null, null, null, null, 'No se ha realizado visita', null, 'Sí', 'No', null, 'No', null, 'No', 'No', 'Sí', null, null, null, 'Sí', '2036-03-28', null, 'No', null, null, null, null, 'No', 'B2C', 'No', 'NO', null, null, null, true, false, false, false, true);
insert into negocios_categorias (negocio_id, categoria_oficial_id) values ('596f1394-0076-44e9-a0a6-d3987fa2b9ef', (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'));
insert into negocios_subcategorias (negocio_id, subcategoria_id) select '596f1394-0076-44e9-a0a6-d3987fa2b9ef', id from subcategorias where slug = 'agroindustria-sostenible';
insert into negocios_actividades (negocio_id, actividad_productiva_id) select '596f1394-0076-44e9-a0a6-d3987fa2b9ef', id from actividades_productivas where slug = 'agroindustrial-alimentario';

-- ASOSICACIÓN AGROSOTONORTE
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo) values ('cf3f8569-4b8f-4ba7-9650-86609bcc3d98', 'ASOSICACIÓN AGROSOTONORTE', generar_slug_unico('ASOSICACIÓN AGROSOTONORTE', 'cf3f8569-4b8f-4ba7-9650-86609bcc3d98'), (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'), 'Suratá', (select id from veredas where municipio = 'Suratá' and slug = 'el-porvenir'), 'FINCA VILLA NUEVA 2 VEREDA EL PORVENIR, SURATA', null, null, 'Producción y comercializacion de miel organica', 'Producción y comercializacion de miel organica', 'MIEL ORGANICA', '3175386172', '573175386172', 'agrosotonorte@gmail.com', 'VIDAL RAMIREZ CACUA', '901992380-8', 'Jurídica', null, 'Cámara de comercio', 'SILVIA VALDIVIESO', 'ACTIVO', 'Inicial', 2025, '2.034°', '72°58´49,5"w', '7°23´36,4" n', 'Actualizó', 'Se realizo visita y se aplico ficha de verificación', null, 'No', 'No', null, 'No', null, 'No', 'No', 'Sí', null, null, null, null, null, null, null, 'No', 'No', null, null, 'No', 'B2C', 'No', 'NO', null, null, null, true, false, false, false, true);
insert into negocios_categorias (negocio_id, categoria_oficial_id) values ('cf3f8569-4b8f-4ba7-9650-86609bcc3d98', (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'));
insert into negocios_subcategorias (negocio_id, subcategoria_id) select 'cf3f8569-4b8f-4ba7-9650-86609bcc3d98', id from subcategorias where slug = 'agrosistemas-sostenibles';
insert into negocios_actividades (negocio_id, actividad_productiva_id) select 'cf3f8569-4b8f-4ba7-9650-86609bcc3d98', id from actividades_productivas where slug = 'agricultura-sostenible';

-- CHOCOPASSION
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo) values ('bac40ec9-f985-4e45-b703-516ff9ff92f2', 'CHOCOPASSION', generar_slug_unico('CHOCOPASSION', 'bac40ec9-f985-4e45-b703-516ff9ff92f2'), (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'), 'Lebrija', (select id from veredas where municipio = 'Lebrija' and slug = 'perimetro-urbano'), 'CARRERA 5 # 28-05 BUCARAMANGA', null, null, 'Chocopassio se dedica a la transformación del cacao en productos derivados como chocolate de mesa endulzado con panela, cacao 100% y preparaciones…', 'Chocopassio se dedica a la transformación del cacao en productos derivados como chocolate de mesa endulzado con panela, cacao 100% y preparaciones artesanales basadas en subproductos del cacao, como barras de chocolate con ajonjolí y fruta deshidratada cubierta de chocolate. Su actividad incluye la compra de cacao a productores locales, el procesamiento artesanal de los granos y la elaboración de alimentos naturales y de valor agregado, enfocados en prácticas sostenibles y en el aprovechamiento integral del fruto.', 'CHOCOLATE DE MESA', '3052991276', '573052991276', 'yulygomez945@gmail.com', 'YULY VIVIANA GÓMEZ PARRA', '901967591-1', 'Jurídica', null, 'Cámara de comercio', 'DIEGO GUTIERREZ', 'ACTIVO', 'Intermedio', 2025, null, null, null, 'Actualizó', 'Se realizo visita y se aplico ficha de verificacion', null, 'No', 'Acueducto veredal', null, null, null, 'No', 'No', null, 'Sí', null, null, 'No', null, null, 'No', null, null, null, null, 'No', 'Mixta', 'No', 'NO', null, null, null, true, false, false, false, true);
insert into negocios_categorias (negocio_id, categoria_oficial_id) values ('bac40ec9-f985-4e45-b703-516ff9ff92f2', (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'));
insert into negocios_subcategorias (negocio_id, subcategoria_id) select 'bac40ec9-f985-4e45-b703-516ff9ff92f2', id from subcategorias where slug = 'agroindustria-sostenible';
insert into negocios_actividades (negocio_id, actividad_productiva_id) select 'bac40ec9-f985-4e45-b703-516ff9ff92f2', id from actividades_productivas where slug = 'agroindustrial-alimentario';
insert into negocio_puntajes (negocio_id, anio, puntaje) values ('bac40ec9-f985-4e45-b703-516ff9ff92f2', 2025, 43.3) on conflict (negocio_id, anio) do nothing;

-- SOLUTIONS BIOTECHNOLOGY S.A.S BIC
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo) values ('d59e5d8f-e454-407c-8f44-1d42267ff9b2', 'SOLUTIONS BIOTECHNOLOGY S.A.S BIC', generar_slug_unico('SOLUTIONS BIOTECHNOLOGY S.A.S BIC', 'd59e5d8f-e454-407c-8f44-1d42267ff9b2'), (select id from categorias_oficiales where slug = 'ecoproductos-industriales'), 'Piedecuesta', (select id from veredas where municipio = 'Piedecuesta' and slug = 'diamante'), 'VEREDA EL DIAMANTE PIEDECUESTA', null, null, 'Se dedica a la bioconversión de residuos orgánicos mediante la reproducción y cultivo de la mosca soldado negra (Hermetia illucens). La empresa transforma…', 'Se dedica a la bioconversión de residuos orgánicos mediante la reproducción y cultivo de la mosca soldado negra (Hermetia illucens). La empresa transforma materiales orgánicos en productos de valor agregado como compost, biofertilizantes y proteína de alta calidad para alimentación animal. Su actividad integra procesos de economía circular orientados a la descarbonización y al aprovechamiento de subproductos.', 'GESTION DE RESIDUOS ORGÁNICOS MEDIANTE BIOCONVERSIÓN CON MOSCA SOLDADO PARA PRODUCIR COMPOST Y PROTEÍNA SOSTENIBLE.', '3154740027', '573154740027', 'Info@solucionesbio.com', 'JOSE ARMANDO RAMIREZ RAMIREZ', '901652873-9', 'Jurídica', null, 'Cámara de comercio', 'DIANA NAVARRO', 'ACTIVO', 'Intermedio', 2025, null, null, null, 'Actualizó', 'Se realizo visita y se actualizo ficha de verificacion', null, 'No', 'No', null, 'No', null, 'No', 'Sí', 'No', null, 'No', null, null, null, null, null, null, null, null, null, 'No', 'B2B', 'No', 'NO', null, null, null, true, false, false, false, true);
insert into negocios_categorias (negocio_id, categoria_oficial_id) values ('d59e5d8f-e454-407c-8f44-1d42267ff9b2', (select id from categorias_oficiales where slug = 'ecoproductos-industriales'));
insert into negocios_actividades (negocio_id, actividad_productiva_id) select 'd59e5d8f-e454-407c-8f44-1d42267ff9b2', id from actividades_productivas where slug = 'aprovechamiento-residuos-organicos';
insert into negocio_puntajes (negocio_id, anio, puntaje) values ('d59e5d8f-e454-407c-8f44-1d42267ff9b2', 2025, 40.8) on conflict (negocio_id, anio) do nothing;

-- AUROMA VELAS Y JABONES ARTESANALES
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo) values ('f4353289-53e7-4ea7-a3e8-72031a697546', 'AUROMA VELAS Y JABONES ARTESANALES', generar_slug_unico('AUROMA VELAS Y JABONES ARTESANALES', 'f4353289-53e7-4ea7-a3e8-72031a697546'), (select id from categorias_oficiales where slug = 'pendiente-clasificar'), 'Floridablanca', (select id from veredas where municipio = 'Floridablanca' and slug = 'perimetro-urbano'), 'CRA 3 NO. 2 - 192 CASA 33', null, null, null, null, 'VELAS Y JABONES ARTESANALES', '3114823425', '573114823425', 'aurorapemo@outlook.com', 'AURORA PEDREROS', null, null, null, null, 'JENNIFER BLANCO', 'ACTIVO', null, 2026, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, true, false, false, false, true);
insert into negocios_categorias (negocio_id, categoria_oficial_id) values ('f4353289-53e7-4ea7-a3e8-72031a697546', (select id from categorias_oficiales where slug = 'pendiente-clasificar'));

-- CAFÉ LOS GUANES
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo) values ('626a44ee-d836-44a3-8ed7-0b1db2ef1eea', 'CAFÉ LOS GUANES', generar_slug_unico('CAFÉ LOS GUANES', '626a44ee-d836-44a3-8ed7-0b1db2ef1eea'), (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'), 'Piedecuesta', (select id from veredas where municipio = 'Piedecuesta' and slug = 'san-miguel'), 'VEREDA SAN MIGUEL BAJOS PARCELA LOS GUNES', null, null, 'Café Los Guanes es un emprendimiento familiar ubicado en la vereda San Miguel Bajo, Piedecuesta (Santander), dedicado al cultivo, transformación y…', 'Café Los Guanes es un emprendimiento familiar ubicado en la vereda San Miguel Bajo, Piedecuesta (Santander), dedicado al cultivo, transformación y comercialización de café artesanal. Basado en una tradición cafetera que se remonta a 1948, su modelo de negocio integra toda la cadena productiva, desde la siembra y cosecha hasta el beneficio, tueste, molienda, empaque y venta de café en grano y molido. Su propuesta de valor se centra en ofrecer un café de origen, natural y de alta calidad, destacándose por su aroma, sabor y producción artesanal bajo el lema: “Del campo al comedor, Café Los Guanes, lo mejor”.', 'CAFÉ ORGÁNICO', '3155426673', '573155426673', 'perezardilajulianleonardo@gmail.com', 'JULIAN LEONARDO PEREZ ARDILA', '1005297638-2', 'Natural', null, 'Cámara de comercio', 'SUJEY DÍAZ', 'ACTIVO', null, 2026, null, null, null, null, null, null, 'No', 'No', null, 'No', null, 'No', 'No', 'No', null, null, null, 'No', null, null, 'No', null, null, null, null, 'No', 'B2C', 'No', 'NO', null, null, null, true, false, false, false, true);
insert into negocios_categorias (negocio_id, categoria_oficial_id) values ('626a44ee-d836-44a3-8ed7-0b1db2ef1eea', (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'));
insert into negocios_subcategorias (negocio_id, subcategoria_id) select '626a44ee-d836-44a3-8ed7-0b1db2ef1eea', id from subcategorias where slug = 'agroindustria-sostenible';
insert into negocios_actividades (negocio_id, actividad_productiva_id) select '626a44ee-d836-44a3-8ed7-0b1db2ef1eea', id from actividades_productivas where slug = 'agroindustrial-alimentario';

-- NUTRATECH
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo) values ('ea52b5ed-b923-4ea8-bb2e-3f3bcf335b54', 'NUTRATECH', generar_slug_unico('NUTRATECH', 'ea52b5ed-b923-4ea8-bb2e-3f3bcf335b54'), (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'), 'Bucaramanga', (select id from veredas where municipio = 'Bucaramanga' and slug = 'perimetro-urbano'), 'CARRERA 8 # 20N-148 PARQUE INDUSTRIAL RUTA 169 Bodega 13', null, null, 'NutraTech S.A.S. es una empresa dedicada al desarrollo y comercialización de aditivos naturales para la alimentación animal, especialmente enfocados en…', 'NutraTech S.A.S. es una empresa dedicada al desarrollo y comercialización de aditivos naturales para la alimentación animal, especialmente enfocados en mejorar la pigmentación de la piel del pollo y la yema del huevo. Su producción se basa en la formulación de núcleos biotecnológicos con compuestos naturales como achiote, cascarilla de café y harina de guayaba. Está dirigida al sector avícola y productores de alimento animal, comercializando sus productos de manera directa a empresas y productores del sector pecuario.', 'PIGMENTANTE PARA LA PIEL DE POLLO Y YEMA DE HUEVO', '3167840327', '573167840327', 'gerencia@nutratech.com.co', 'HELY ARGUELLO AMADO', '901137564-1', 'Jurídica', null, 'Cámara de comercio', 'SUJEY DÍAZ', 'ACTIVO', null, 2026, null, null, null, null, null, null, 'No', 'Acueducto', null, null, null, 'No', 'Sí', null, 'Sí', 'Sí', null, null, null, null, 'No', null, null, null, null, 'No', 'B2B', 'No', 'NO', null, null, null, true, false, false, false, true);
insert into negocios_categorias (negocio_id, categoria_oficial_id) values ('ea52b5ed-b923-4ea8-bb2e-3f3bcf335b54', (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'));
insert into negocios_subcategorias (negocio_id, subcategoria_id) select 'ea52b5ed-b923-4ea8-bb2e-3f3bcf335b54', id from subcategorias where slug = 'biotecnologia';
insert into negocios_actividades (negocio_id, actividad_productiva_id) select 'ea52b5ed-b923-4ea8-bb2e-3f3bcf335b54', id from actividades_productivas where slug = 'productos-biotecnologia';

-- CROPIABONO
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo) values ('fb6a5db5-d622-4d0b-9aa3-32b4922d6062', 'CROPIABONO', generar_slug_unico('CROPIABONO', 'fb6a5db5-d622-4d0b-9aa3-32b4922d6062'), (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'), 'Piedecuesta', (select id from veredas where municipio = 'Piedecuesta' and slug = 'mesita-de-san-javier'), 'VEREDA MESITA DE SAN JAVIER FINCA TACAMA', null, null, 'Fabricación de abonos y compuestos inorgánicos nitrogenados ( materia prima: gallinaza, caprinaza, polialiyta y roca fosforica)', 'Fabricación de abonos y compuestos inorgánicos nitrogenados ( materia prima: gallinaza, caprinaza, polialiyta y roca fosforica)', 'ABONO ORGÁNICO MINERAL', '3208957298', '573208957298', 'cropiabono@gmail.com', 'JAVIER EDUARDO MANTILLA BUITAGRO', '1102374899-1', 'Natural', null, 'Cámara de comercio', 'ANDRES VALDERRAMA', 'ACTIVO', null, 2026, null, null, null, null, null, null, 'No', 'No', null, 'No', null, 'No', 'Sí', 'Sí', null, 'Sí', null, null, null, null, null, null, null, null, null, 'No', 'B2C', 'No', 'NO', null, null, null, true, false, false, false, true);
insert into negocios_categorias (negocio_id, categoria_oficial_id) values ('fb6a5db5-d622-4d0b-9aa3-32b4922d6062', (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'));
insert into negocios_subcategorias (negocio_id, subcategoria_id) select 'fb6a5db5-d622-4d0b-9aa3-32b4922d6062', id from subcategorias where slug = 'agrosistemas-sostenibles';
insert into negocios_actividades (negocio_id, actividad_productiva_id) select 'fb6a5db5-d622-4d0b-9aa3-32b4922d6062', id from actividades_productivas where slug = 'agricultura-organica';

-- DANYAN
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo) values ('8ee4d421-de98-4689-8403-2236055b7a91', 'DANYAN', generar_slug_unico('DANYAN', '8ee4d421-de98-4689-8403-2236055b7a91'), (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'), 'Bucaramanga', (select id from veredas where municipio = 'Bucaramanga' and slug = 'perimetro-urbano'), 'CRA 8W NO. 61 - 18 MUTIS CONJUNTO FUNDADORES 2', null, null, 'La empresa se dedica a la fabricación y comercialización de desodorantes artesanales y talcos exfoliantes naturales, elaborados a base de componentes…', 'La empresa se dedica a la fabricación y comercialización de desodorantes artesanales y talcos exfoliantes naturales, elaborados a base de componentes naturales, con propiedades aclarantes, ofreciendo productos asequibles y amigables con el cuidado personal y el medio ambiente.', 'DESODORANTES Y TALCOS', '3183163685 - 3208944061', '3183163685 - 3208944061', 'danyan.sostenible@gmail.com', 'DANIEL SANTIAGO LINARES TEJEDOR', '1098612330-1', 'Natural', 'LYAN PIERRE FELIPE GALVIS GIL', 'Cámara de comercio', 'SUJEY DÍAZ', 'ACTIVO', null, 2026, null, null, null, null, null, null, null, 'Acueducto', null, null, null, 'No', 'No', null, 'Sí', null, null, 'No', null, null, null, null, null, null, null, 'No', 'B2C', 'No', 'NO', null, null, null, true, false, false, false, true);
insert into negocios_categorias (negocio_id, categoria_oficial_id) values ('8ee4d421-de98-4689-8403-2236055b7a91', (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'));
insert into negocios_subcategorias (negocio_id, subcategoria_id) select '8ee4d421-de98-4689-8403-2236055b7a91', id from subcategorias where slug = 'agroindustria-sostenible';
insert into negocios_actividades (negocio_id, actividad_productiva_id) select '8ee4d421-de98-4689-8403-2236055b7a91', id from actividades_productivas where slug = 'agroindustrial-no-alimentario';

-- MIEL AMELITA
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo) values ('e115f665-4999-4dd0-a640-173e711a7747', 'MIEL AMELITA', generar_slug_unico('MIEL AMELITA', 'e115f665-4999-4dd0-a640-173e711a7747'), (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'), 'Suratá', (select id from veredas where municipio = 'Suratá' and slug = 'el-porvenir'), 'VEREDA EL PORVENIR, FINCA VILLANUEVA SURATA', null, null, 'Producción de miel, hidromiel, balsamo de labios sin conservantes ni quimicos', 'Producción de miel, hidromiel, balsamo de labios sin conservantes ni quimicos', 'HIDROMIEL', '3154023352', '573154023352', 'yanethmendozav@yahoo.es', 'SANTOS YANETH MENDOZA VILLABONA', '63318649', null, null, 'RUT', 'LUZ ANDREA ISAZA', 'ACTIVO', null, 2026, null, null, null, null, null, null, 'No', 'No', null, null, null, 'No', 'No', 'Sí', null, null, null, 'No', null, null, null, 'No', 'No', null, null, 'No', 'B2C', 'No', 'NO', null, null, null, true, false, false, false, true);
insert into negocios_categorias (negocio_id, categoria_oficial_id) values ('e115f665-4999-4dd0-a640-173e711a7747', (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'));
insert into negocios_subcategorias (negocio_id, subcategoria_id) select 'e115f665-4999-4dd0-a640-173e711a7747', id from subcategorias where slug = 'agroindustria-sostenible';
insert into negocios_actividades (negocio_id, actividad_productiva_id) select 'e115f665-4999-4dd0-a640-173e711a7747', id from actividades_productivas where slug = 'agroindustrial-alimentario';

-- WAYPA
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo) values ('7546e796-2153-478b-88cb-fa1aba4bedf1', 'WAYPA', generar_slug_unico('WAYPA', '7546e796-2153-478b-88cb-fa1aba4bedf1'), (select id from categorias_oficiales where slug = 'pendiente-clasificar'), 'Bucaramanga', (select id from veredas where municipio = 'Bucaramanga' and slug = 'perimetro-urbano'), 'CRA 25 # 6 - 10', null, null, null, null, 'ZAPATOS ARTESANALES', '3195305438', '573195305438', 'walterjesus94@gmail.com', 'WALTER JESUS RIVERA MORADO', '1102864130', null, null, 'RUT', 'SARY YULITZA HIDALGO', 'ACTIVO', null, 2026, null, null, null, null, null, null, null, 'Acueducto', null, null, null, 'No', 'No', null, 'Sí', null, null, null, null, null, null, null, null, null, null, 'No', 'B2B', 'No', 'NO', null, null, null, true, false, false, false, true);
insert into negocios_categorias (negocio_id, categoria_oficial_id) values ('7546e796-2153-478b-88cb-fa1aba4bedf1', (select id from categorias_oficiales where slug = 'pendiente-clasificar'));

-- MIRADOR DEL SHADDAI
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo) values ('f7cbad80-ba39-4677-92fe-a4cb7dd37191', 'MIRADOR DEL SHADDAI', generar_slug_unico('MIRADOR DEL SHADDAI', 'f7cbad80-ba39-4677-92fe-a4cb7dd37191'), (select id from categorias_oficiales where slug = 'pendiente-clasificar'), 'Matanza', (select id from veredas where municipio = 'Matanza' and slug = 'santa-ana'), 'CORREGIMIENTO SANTA CRUZ DE LA COLINA', null, null, null, null, 'CAFÉ ORGÁNICO', '3003256712', '573003256712', 'yanipar@hotmail.com', 'YANETH IBAÑEZ', null, null, null, null, 'IAN CARLOS RUIZ', 'ACTIVO', null, 2026, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, true, false, false, false, true);
insert into negocios_categorias (negocio_id, categoria_oficial_id) values ('f7cbad80-ba39-4677-92fe-a4cb7dd37191', (select id from categorias_oficiales where slug = 'pendiente-clasificar'));

-- M963
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo) values ('1d8a3619-1779-495e-adf7-9dd285acc7f4', 'M963', generar_slug_unico('M963', '1d8a3619-1779-495e-adf7-9dd285acc7f4'), (select id from categorias_oficiales where slug = 'ecoproductos-industriales'), 'Lebrija', (select id from veredas where municipio = 'Lebrija' and slug = 'santa-rosa'), 'CONDOMINIO JJ 3 KM DESPUÉS DEL AEROPUERTO', null, null, 'Productos de joyeria en plata y materiales de origen reciclado tales como cuero, bambu, vinculandose a la economia circular y moda sostenibles', 'Productos de joyeria en plata y materiales de origen reciclado tales como cuero, bambu, vinculandose a la economia circular y moda sostenibles', 'ACCESORIOS DE JOYERIA EN PLATA', '3167272103', '573167272103', 'barragan.marco.2022@gmail.com', 'MARCO BARRAGAN GÓMEZ', '91492323', null, null, null, 'VIVIANA ANDREA BARAJAS', 'ACTIVO', null, 2026, null, null, null, null, null, null, 'No', 'Acueducto veredal', null, null, null, 'No', 'No', 'Sí', null, null, null, null, null, null, null, null, null, null, null, 'No', 'B2C', 'No', 'NO', null, null, null, true, false, false, false, true);
insert into negocios_categorias (negocio_id, categoria_oficial_id) values ('1d8a3619-1779-495e-adf7-9dd285acc7f4', (select id from categorias_oficiales where slug = 'ecoproductos-industriales'));
insert into negocios_subcategorias (negocio_id, subcategoria_id) select '1d8a3619-1779-495e-adf7-9dd285acc7f4', id from subcategorias where slug = 'moda-sostenible';

-- CAFÉ LA GUACHARACA
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo) values ('ae0208fa-9bd9-46f6-a962-c417cfde0a52', 'CAFÉ LA GUACHARACA', generar_slug_unico('CAFÉ LA GUACHARACA', 'ae0208fa-9bd9-46f6-a962-c417cfde0a52'), (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'), 'Piedecuesta', (select id from veredas where municipio = 'Piedecuesta' and slug = 'via-curos'), 'FINCA SAN FELIPE DEL OCASO, VEREDA VIA CUROS, MESA DE LOS SANTOS KM7', null, null, 'Cultivo de café, comercialización de café empacado o en grano', 'Cultivo de café, comercialización de café empacado o en grano', 'CAFÉ', '3138026724', '573138026724', 'au.bau91@gmail.com', 'AURA LILIANA BAUTISTA VALBUENA', '1098703297-5', 'Natural', null, 'Cámara de comercio', 'LAURA CAROLINA RODRIGUEZ', 'ACTIVO', null, 2026, null, null, null, null, null, null, 'No', 'No', null, null, null, 'Sí', 'No', 'Sí', null, null, null, 'Sí', null, null, 'No', null, null, null, null, 'No', 'B2C', 'No', 'SI', null, null, null, true, false, false, false, true);
insert into negocios_categorias (negocio_id, categoria_oficial_id) values ('ae0208fa-9bd9-46f6-a962-c417cfde0a52', (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'));
insert into negocios_subcategorias (negocio_id, subcategoria_id) select 'ae0208fa-9bd9-46f6-a962-c417cfde0a52', id from subcategorias where slug = 'agroindustria-sostenible';
insert into negocios_actividades (negocio_id, actividad_productiva_id) select 'ae0208fa-9bd9-46f6-a962-c417cfde0a52', id from actividades_productivas where slug = 'agroindustrial-alimentario';

-- SAJUPLATS S.A.S
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo) values ('591eaa47-7eaf-4e92-afd6-489eaa8209e4', 'SAJUPLATS S.A.S', generar_slug_unico('SAJUPLATS S.A.S', '591eaa47-7eaf-4e92-afd6-489eaa8209e4'), (select id from categorias_oficiales where slug = 'ecoproductos-industriales'), 'Girón', (select id from veredas where municipio = 'Girón' and slug = 'perimetro-urbano'), 'CRA 0 #3 - 36 LOTE A CHIMITA', null, null, 'Es una empresa sas que se dedica a la recuperacion, transformacion y comercializacion de materias primas plasticas flexibles, mediante un proceso productivo…', 'Es una empresa sas que se dedica a la recuperacion, transformacion y comercializacion de materias primas plasticas flexibles, mediante un proceso productivo (clasificacion y aglutinada) para venderle a empresas que fabrican articulos plasticos (inyeccion y extrusion) con materia prima reciclada el cual se comercializa por venta directa al por mayor', 'RECUPERACIÓN DE MATERIA PRIMA PLASTICA FLEXIBLE', '3228345953', '573228345953', 'sajuplast@gmail.com', 'JUAN JOSÉ OROZCO NAVARRETE', '901948834-3', 'Jurídica', null, 'Cámara de comercio', 'SIOMAR FLOREZ', 'ACTIVO', null, 2026, null, null, null, null, null, null, 'No', 'Acueducto', null, null, null, 'No', 'No', null, 'Sí', null, null, null, null, null, null, null, null, null, null, 'No', 'B2B', 'No', 'NO', null, null, null, true, false, false, false, true);
insert into negocios_categorias (negocio_id, categoria_oficial_id) values ('591eaa47-7eaf-4e92-afd6-489eaa8209e4', (select id from categorias_oficiales where slug = 'ecoproductos-industriales'));
insert into negocios_actividades (negocio_id, actividad_productiva_id) select '591eaa47-7eaf-4e92-afd6-489eaa8209e4', id from actividades_productivas where slug = 'aprovechamiento-residuos-inorganicos';

-- PASIÓN DE HOGAR
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo) values ('7b2fbb59-ee12-4728-9361-69d69f25cc0e', 'PASIÓN DE HOGAR', generar_slug_unico('PASIÓN DE HOGAR', '7b2fbb59-ee12-4728-9361-69d69f25cc0e'), (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'), 'Rionegro', (select id from veredas where municipio = 'Rionegro' and slug = 'valparaiso'), 'VEREDA VALPARAISO, FINCA EL JAZMÍN', null, null, 'Agricultora, transformadora y comercializadora de productos de cacao, dentro de los caules se encuentra artesanias de cacao…, artesanal no hay equipos…,…', 'Agricultora, transformadora y comercializadora de productos de cacao, dentro de los caules se encuentra artesanias de cacao…, artesanal no hay equipos…, familias dado que venden productos naturales de cacao, turrones, etc., y artesania. Vende en ferias y con apoyo de Fedecacao, y bajo pedidos dado los productos publicados en las redes sociales de Facebook e Instagram...', 'VENTA DE CACAO Y CHUCULA', '3184958022', '573184958022', 'pasiondehogar@gmail.com - sunialexis76@gmail.com', 'SUNY SANTAMARIA GALEANO', '63252922-6', 'Natural', null, 'Cámara de comercio', 'YEINNI PAOLA CRISTANCHO', 'ACTIVO', null, 2026, null, null, null, null, null, null, 'No', 'Sí', '2032-09-18', 'Sí', null, 'No', 'No', 'Sí', null, null, null, 'No', null, null, 'No', null, null, null, null, 'No', 'B2C', 'No', 'NO', null, null, null, true, false, false, false, true);
insert into negocios_categorias (negocio_id, categoria_oficial_id) values ('7b2fbb59-ee12-4728-9361-69d69f25cc0e', (select id from categorias_oficiales where slug = 'bioproductos-servicios-sostenibles'));
insert into negocios_subcategorias (negocio_id, subcategoria_id) select '7b2fbb59-ee12-4728-9361-69d69f25cc0e', id from subcategorias where slug = 'agrosistemas-sostenibles';
insert into negocios_actividades (negocio_id, actividad_productiva_id) select '7b2fbb59-ee12-4728-9361-69d69f25cc0e', id from actividades_productivas where slug = 'agroindustrial-alimentario';

-- ABRIGO DE FLORA
insert into negocios (id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion, latitud, longitud, descripcion_corta, descripcion, producto, telefono, whatsapp, email, representante_legal, nit, naturaleza_juridica, delegado, rut_camara_comercio, responsable_cdmb, novedad, tipo_negocio_verde, anio_registro, cota_msnm, este, norte, aplicacion_ficha_2025, observaciones, registro_nacional_turismo, uso_suelo, concesion_aguas, concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, invima, invima_vencimiento, certificado_tenencia_animales, buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, huella_carbono, fortalezas_ambiental, fortalezas_social, fortalezas_economico, emprendimiento_verde, sello_marca, avalado, destacado, activo) values ('c58f2e69-79a9-4fd1-89a2-d06591a00c06', 'ABRIGO DE FLORA', generar_slug_unico('ABRIGO DE FLORA', 'c58f2e69-79a9-4fd1-89a2-d06591a00c06'), (select id from categorias_oficiales where slug = 'pendiente-clasificar'), 'Piedecuesta', (select id from veredas where municipio = 'Piedecuesta' and slug = 'sevilla'), 'VEREDA SEVILLA FINCA MADRIGAL SECTOR EL MANZANO', null, null, null, null, 'COSMÉTICA BOTÁNICA NATURAL', '3174876930', '573174876930', 'abrigodeflorase@gmail.com', 'ERIKA FERNANDA DURAN GOMEZ', '37619813', null, null, 'RUT', 'GENNY JULIANA FERREIRA', 'ACTIVO', null, 2026, null, null, null, null, null, null, 'No', 'Acueducto veredal', null, null, null, 'No', 'No', null, null, null, null, 'No', null, null, null, null, null, null, null, 'No', 'B2C', 'No', 'NO', null, null, null, true, false, false, false, true);
insert into negocios_categorias (negocio_id, categoria_oficial_id) values ('c58f2e69-79a9-4fd1-89a2-d06591a00c06', (select id from categorias_oficiales where slug = 'pendiente-clasificar'));


commit;
