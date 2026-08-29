-- 0022_ficha_ampliada_negocios.sql
--
-- IMPORTANTE — reconciliación con 0020_avalado_y_emprendimiento_verde.sql
-- (otra sesión de Claude Code, corrida en producción el 25 de agosto,
-- ANTES de que esta migración se escribiera): ese archivo ya reemplazó
-- nivel_desarrollo por avalado/emprendimiento_verde, pero con una decisión
-- distinta a la de CDMB confirmada acá — hizo emprendimiento_verde
-- admin-only (nunca público). CDMB confirmó directamente (captura del
-- filtro real: "EMPRENDIMIENTO VERDE / NEGOCIO VERDE - SELLO MARCA /
-- NEGOCIO VERDE AVALADO", sin "Aval de Confianza") que las 3 son públicas
-- por igual y que aval_confianza no debía existir como categoría — este
-- archivo corrige eso. El DROP FUNCTION de abajo usa la firma EXACTA que
-- 0020 dejó en producción (verificada por lectura directa contra la base
-- real, no adivinada) para reemplazarla de verdad en vez de crear un
-- segundo guardar_negocio sobrecargado que dejaría a PostgREST sin poder
-- elegir cuál usar.
-- Negocios Verdes CDMB pasa de vitrina liviana a sistema de información
-- real: CDMB entregó su base de datos completa (304 negocios, 73 columnas)
-- y pidió que quedara "alguna información solo se verá públicamente, otra
-- para la gestión del administrador". Este archivo es la parte estructural
-- (columnas + RPCs); los datos reales se cargan en
-- 0026_datos_cdmb_negocios_verdes.sql (generado desde el Excel, no a
-- mano). El campo por campo de qué es público quedó documentado en cada
-- columna de abajo — regla general acordada con CDMB: nada de lo nuevo es
-- público salvo vereda_id, representante_legal y producto (ver negocio_service.dart,
-- que ahora usa un SELECT explícito para el público en vez de "*", así
-- estas columnas ni siquiera viajan en la respuesta a un visitante
-- anónimo, no solo se ocultan en la UI).

-- 1) Reconocimientos: nivel_desarrollo (enum de 3 valores excluyentes) y
--    aval_confianza (booleano aparte, agregado en 0019 "por si acaso" sin
--    saber todavía si era sinónimo de nivel_desarrollo='verificado") se
--    reemplazan por las 3 categorías reales que CDMB maneja en su base:
--    Emprendimiento Verde / Negocio Verde - Sello Marca / Negocio Verde
--    Avalado. Los datos reales confirman que NO son excluyentes (29 de 304
--    negocios tienen a la vez AVAL='SI' y SELLO MARCA='SI'), así que se
--    modelan como 3 booleanos independientes — mismo patrón que ya tenía
--    sello_marca desde 0018, ahora extendido a los otros dos.
alter table negocios add column if not exists emprendimiento_verde boolean not null default false;
alter table negocios add column if not exists avalado boolean not null default false;
-- sello_marca ya existe desde 0018, no se toca.

alter table negocios drop column if exists nivel_desarrollo;
alter table negocios drop column if exists aval_confianza;

-- 2) whatsapp/descripcion_corta/descripcion eran NOT NULL — correcto para
--    un negocio nuevo capturado desde el formulario admin (que sigue
--    exigiéndolos ahí, ver admin_negocio_form_page.dart), pero la base real
--    de CDMB tiene negocios sin WhatsApp capturado todavía (se llena
--    después, pedido explícito) y sin descripción (64 de 304). Relajar acá
--    es lo correcto: nunca hay que inventar un dato que no existe para
--    cumplir un NOT NULL.
alter table negocios alter column whatsapp drop not null;
alter table negocios alter column descripcion_corta drop not null;
alter table negocios alter column descripcion drop not null;

-- 3) Identificación — PÚBLICOS: representante_legal (pedido explícito) y
--    producto (qué vende el negocio — mismo nivel de sensibilidad que
--    descripcion, ya pública). nit/naturaleza_juridica quedan admin-only a
--    propósito: para una persona NATURAL el NIT suele ser su número de
--    cédula, un dato personal sensible (habeas data, Ley 1581/2012) —
--    decisión explícita de CDMB de no publicarlo nunca, ni siquiera para
--    negocios Jurídica.
alter table negocios add column if not exists representante_legal text;
alter table negocios add column if not exists producto text;
alter table negocios add column if not exists nit text;
alter table negocios add column if not exists naturaleza_juridica text
  check (naturaleza_juridica is null or naturaleza_juridica in ('Natural', 'Jurídica'));
alter table negocios add column if not exists delegado text;
alter table negocios add column if not exists tiempo_constitucion text;
alter table negocios add column if not exists rut_camara_comercio text;
alter table negocios add column if not exists responsable_cdmb text;

-- 4) Estado operativo interno — ADMIN-ONLY. novedad guarda el estado
--    original de la base de CDMB (ACTIVO/RETIRADO/SUSPENDIDO/INACTIVO/...)
--    para auditoría y filtro admin, aunque negocios.activo (ya existente,
--    booleano) sigue siendo la única fuente de verdad de "se publica o
--    no": activo = true cuando novedad = 'ACTIVO' (ver 0026, que ya no
--    necesita esperar una foto de portada — ver 0023_foto_portada_opcional.sql).
--    tipo_negocio_verde es la clasificación de madurez de CDMB
--    (Dinamizadoras/Inicial/Intermedio/Avanzado/...), un eje completamente
--    distinto de los 3 reconocimientos del punto 1.
alter table negocios add column if not exists novedad text;
alter table negocios add column if not exists tipo_negocio_verde text;
alter table negocios add column if not exists codigo_marca text;
alter table negocios add column if not exists anio_registro smallint;
alter table negocios add column if not exists cota_msnm text;
alter table negocios add column if not exists aplicacion_ficha_2025 text;
alter table negocios add column if not exists observaciones text;

-- 5) Permisos, trámites y certificaciones ambientales — ADMIN-ONLY, texto
--    libre (la base de origen trae valores inconsistentes: "SI"/"NO"/"NA"/
--    "N/A"/vacío — normalizarlos a booleano hoy perdería matices reales
--    que CDMB sí puede necesitar, mejor dejarlos tal cual como referencia y
--    que el admin los edite a mano si hace falta).
alter table negocios add column if not exists registro_nacional_turismo text;
alter table negocios add column if not exists uso_suelo text;
alter table negocios add column if not exists concesion_aguas text;
alter table negocios add column if not exists concesion_aguas_vencimiento date;
alter table negocios add column if not exists vertimientos text;
alter table negocios add column if not exists vertimientos_vencimiento date;
alter table negocios add column if not exists pueaa text;
alter table negocios add column if not exists pgris text;
alter table negocios add column if not exists pozo_septico text;
alter table negocios add column if not exists alcantarillado text;
alter table negocios add column if not exists ica text;
alter table negocios add column if not exists ica_vencimiento date;
alter table negocios add column if not exists invima text;
alter table negocios add column if not exists invima_vencimiento date;
alter table negocios add column if not exists certificado_tenencia_animales text;
alter table negocios add column if not exists buenas_practicas_agricolas text;
alter table negocios add column if not exists buenas_practicas_apicolas text;
alter table negocios add column if not exists registro_apicola text;
alter table negocios add column if not exists intervencion_cauce text;
alter table negocios add column if not exists capacidad_carga text;
alter table negocios add column if not exists sstt text;

-- 6) Mercado y fortalecimiento — ADMIN-ONLY.
alter table negocios add column if not exists canal_venta text;
alter table negocios add column if not exists exportacion text;
alter table negocios add column if not exists huella_carbono text;
alter table negocios add column if not exists fortalecimiento_tecnico text;
alter table negocios add column if not exists fortalecimiento_academico text;
alter table negocios add column if not exists fortalecimiento_financiero text;
alter table negocios add column if not exists internacionalizacion text;
alter table negocios add column if not exists certificaciones text;
alter table negocios add column if not exists posicionamiento_marca text;
alter table negocios add column if not exists beneficios_ventanilla text;

-- 7) Análisis DOFA — ADMIN-ONLY.
alter table negocios add column if not exists fortalezas_ambiental text;
alter table negocios add column if not exists fortalezas_social text;
alter table negocios add column if not exists fortalezas_economico text;
alter table negocios add column if not exists debilidades_ambiental text;
alter table negocios add column if not exists debilidades_social text;
alter table negocios add column if not exists debilidades_financiera text;

-- 8) Puntajes de seguimiento por año — tabla aparte (no columnas
--    puntaje_2020..puntaje_2025 en negocios) para no tener que volver a
--    alterar la tabla cada vez que empiece un año nuevo. Sin política de
--    select público: es evaluación interna de CDMB, ni siquiera se
--    considera para la ficha pública.
create table if not exists negocio_puntajes (
  negocio_id uuid not null references negocios(id) on delete cascade,
  anio smallint not null,
  puntaje numeric(5,2) not null,
  primary key (negocio_id, anio)
);

alter table negocio_puntajes enable row level security;

create policy "negocio_puntajes_admin_todo"
  on negocio_puntajes for all
  to authenticated
  using (es_admin())
  with check (es_admin());

-- 9) guardar_negocio: gana los campos "core" de la ficha (identificación
--    pública + los 3 reconocimientos nuevos), pierde nivel_desarrollo y
--    aval_confianza. El resto de columnas nuevas (puntos 4-7 de arriba) NO
--    entran acá — son ~40 campos de seguimiento interno que se editan
--    desde una sección aparte del formulario admin ("Ficha técnica CDMB"),
--    con su propia RPC (guardar_ficha_tecnica_negocio, ver abajo) para no
--    convertir esta función en un parámetro-zoo todavía más largo de lo
--    que ya es.
drop function if exists guardar_negocio(
  uuid, text, uuid[], text, text, double precision, double precision,
  text, text, text, text, text, text, text, text, text, text,
  boolean, boolean, uuid[], uuid[], boolean, boolean, boolean, boolean
);

create or replace function guardar_negocio(
  p_id uuid,
  p_nombre text,
  p_categoria_oficial_ids uuid[],
  p_municipio text,
  p_vereda_id uuid,
  p_direccion text,
  p_latitud double precision,
  p_longitud double precision,
  p_descripcion_corta text,
  p_descripcion text,
  p_telefono text,
  p_whatsapp text,
  p_email text,
  p_sitio_web text,
  p_facebook_url text,
  p_instagram_url text,
  p_foto_portada_url text,
  p_foto_portada_path text,
  p_representante_legal text,
  p_producto text,
  p_nit text,
  p_naturaleza_juridica text,
  p_emprendimiento_verde boolean,
  p_sello_marca boolean,
  p_avalado boolean,
  p_destacado boolean,
  p_activo boolean,
  p_subcategoria_ids uuid[],
  p_actividad_ids uuid[]
)
returns uuid
language plpgsql
security definer
set search_path = public
as $$
declare
  v_id uuid := p_id;
  v_slug text;
  v_accion text;
  v_ya_existe boolean;
  v_categoria_principal uuid;
begin
  if not es_admin() then
    raise exception 'No autorizado: se requiere una cuenta administradora de CDMB.';
  end if;

  if coalesce(cardinality(p_categoria_oficial_ids), 0) = 0 then
    raise exception 'Selecciona al menos una categoría oficial.';
  end if;
  if cardinality(p_categoria_oficial_ids) > 3 then
    raise exception 'Un negocio puede tener máximo 3 categorías oficiales.';
  end if;

  v_categoria_principal := p_categoria_oficial_ids[1];

  select exists(select 1 from negocios where id = v_id) into v_ya_existe;

  v_slug := generar_slug_unico(p_nombre, v_id);

  if not v_ya_existe then
    v_accion := 'crear_negocio';

    insert into negocios (
      id, nombre, slug, categoria_oficial_id, municipio, vereda_id, direccion,
      latitud, longitud, descripcion_corta, descripcion, telefono, whatsapp,
      email, sitio_web, facebook_url, instagram_url,
      foto_portada_url, foto_portada_path,
      representante_legal, producto, nit, naturaleza_juridica,
      emprendimiento_verde, sello_marca, avalado,
      destacado, activo, created_by
    ) values (
      v_id, p_nombre, v_slug, v_categoria_principal, p_municipio, p_vereda_id, p_direccion,
      p_latitud, p_longitud, p_descripcion_corta, p_descripcion, p_telefono, p_whatsapp,
      p_email, p_sitio_web, p_facebook_url, p_instagram_url,
      p_foto_portada_url, p_foto_portada_path,
      p_representante_legal, p_producto, p_nit, p_naturaleza_juridica,
      p_emprendimiento_verde, p_sello_marca, p_avalado,
      p_destacado, p_activo, auth.uid()
    );
  else
    v_accion := 'editar_negocio';

    update negocios set
      nombre = p_nombre,
      slug = v_slug,
      categoria_oficial_id = v_categoria_principal,
      municipio = p_municipio,
      vereda_id = p_vereda_id,
      direccion = p_direccion,
      latitud = p_latitud,
      longitud = p_longitud,
      descripcion_corta = p_descripcion_corta,
      descripcion = p_descripcion,
      telefono = p_telefono,
      whatsapp = p_whatsapp,
      email = p_email,
      sitio_web = p_sitio_web,
      facebook_url = p_facebook_url,
      instagram_url = p_instagram_url,
      foto_portada_url = p_foto_portada_url,
      foto_portada_path = p_foto_portada_path,
      representante_legal = p_representante_legal,
      producto = p_producto,
      nit = p_nit,
      naturaleza_juridica = p_naturaleza_juridica,
      emprendimiento_verde = p_emprendimiento_verde,
      sello_marca = p_sello_marca,
      avalado = p_avalado,
      destacado = p_destacado,
      activo = p_activo
    where id = v_id;

    if not found then
      raise exception 'El negocio % no existe.', v_id;
    end if;
  end if;

  delete from negocios_categorias where negocio_id = v_id;
  insert into negocios_categorias (negocio_id, categoria_oficial_id)
  select v_id, cat_id from unnest(p_categoria_oficial_ids) as cat_id;

  delete from negocios_subcategorias where negocio_id = v_id;
  if coalesce(cardinality(p_subcategoria_ids), 0) > 0 then
    insert into negocios_subcategorias (negocio_id, subcategoria_id)
    select v_id, sub_id from unnest(p_subcategoria_ids) as sub_id;
  end if;

  delete from negocios_actividades where negocio_id = v_id;
  if coalesce(cardinality(p_actividad_ids), 0) > 0 then
    insert into negocios_actividades (negocio_id, actividad_productiva_id)
    select v_id, act_id from unnest(p_actividad_ids) as act_id;
  end if;

  insert into admin_logs (admin_id, accion, entidad, entidad_id, detalle)
  values (
    auth.uid(),
    v_accion,
    'negocios',
    v_id,
    jsonb_build_object('nombre', p_nombre, 'slug', v_slug, 'activo', p_activo)
  );

  return v_id;
end;
$$;

revoke all on function guardar_negocio from public;
grant execute on function guardar_negocio to authenticated;

-- 10) guardar_ficha_tecnica_negocio: los ~40 campos de seguimiento interno
--     (puntos 4-7). Solo UPDATE — la ficha técnica no tiene sentido sin un
--     negocio ya creado (el formulario admin siempre lo llama después de
--     guardar_negocio, nunca antes). Mismo re-chequeo de es_admin() y
--     mismo registro en admin_logs que guardar_negocio, por la razón de
--     siempre: esta función es SECURITY DEFINER y bypassea RLS por diseño.
create or replace function guardar_ficha_tecnica_negocio(
  p_id uuid,
  p_novedad text,
  p_tipo_negocio_verde text,
  p_codigo_marca text,
  p_anio_registro smallint,
  p_cota_msnm text,
  p_aplicacion_ficha_2025 text,
  p_observaciones text,
  p_delegado text,
  p_tiempo_constitucion text,
  p_rut_camara_comercio text,
  p_responsable_cdmb text,
  p_registro_nacional_turismo text,
  p_uso_suelo text,
  p_concesion_aguas text,
  p_concesion_aguas_vencimiento date,
  p_vertimientos text,
  p_vertimientos_vencimiento date,
  p_pueaa text,
  p_pgris text,
  p_pozo_septico text,
  p_alcantarillado text,
  p_ica text,
  p_ica_vencimiento date,
  p_invima text,
  p_invima_vencimiento date,
  p_certificado_tenencia_animales text,
  p_buenas_practicas_agricolas text,
  p_buenas_practicas_apicolas text,
  p_registro_apicola text,
  p_intervencion_cauce text,
  p_capacidad_carga text,
  p_sstt text,
  p_canal_venta text,
  p_exportacion text,
  p_huella_carbono text,
  p_fortalecimiento_tecnico text,
  p_fortalecimiento_academico text,
  p_fortalecimiento_financiero text,
  p_internacionalizacion text,
  p_certificaciones text,
  p_posicionamiento_marca text,
  p_beneficios_ventanilla text,
  p_fortalezas_ambiental text,
  p_fortalezas_social text,
  p_fortalezas_economico text,
  p_debilidades_ambiental text,
  p_debilidades_social text,
  p_debilidades_financiera text
)
returns void
language plpgsql
security definer
set search_path = public
as $$
begin
  if not es_admin() then
    raise exception 'No autorizado: se requiere una cuenta administradora de CDMB.';
  end if;

  update negocios set
    novedad = p_novedad,
    tipo_negocio_verde = p_tipo_negocio_verde,
    codigo_marca = p_codigo_marca,
    anio_registro = p_anio_registro,
    cota_msnm = p_cota_msnm,
    aplicacion_ficha_2025 = p_aplicacion_ficha_2025,
    observaciones = p_observaciones,
    delegado = p_delegado,
    tiempo_constitucion = p_tiempo_constitucion,
    rut_camara_comercio = p_rut_camara_comercio,
    responsable_cdmb = p_responsable_cdmb,
    registro_nacional_turismo = p_registro_nacional_turismo,
    uso_suelo = p_uso_suelo,
    concesion_aguas = p_concesion_aguas,
    concesion_aguas_vencimiento = p_concesion_aguas_vencimiento,
    vertimientos = p_vertimientos,
    vertimientos_vencimiento = p_vertimientos_vencimiento,
    pueaa = p_pueaa,
    pgris = p_pgris,
    pozo_septico = p_pozo_septico,
    alcantarillado = p_alcantarillado,
    ica = p_ica,
    ica_vencimiento = p_ica_vencimiento,
    invima = p_invima,
    invima_vencimiento = p_invima_vencimiento,
    certificado_tenencia_animales = p_certificado_tenencia_animales,
    buenas_practicas_agricolas = p_buenas_practicas_agricolas,
    buenas_practicas_apicolas = p_buenas_practicas_apicolas,
    registro_apicola = p_registro_apicola,
    intervencion_cauce = p_intervencion_cauce,
    capacidad_carga = p_capacidad_carga,
    sstt = p_sstt,
    canal_venta = p_canal_venta,
    exportacion = p_exportacion,
    huella_carbono = p_huella_carbono,
    fortalecimiento_tecnico = p_fortalecimiento_tecnico,
    fortalecimiento_academico = p_fortalecimiento_academico,
    fortalecimiento_financiero = p_fortalecimiento_financiero,
    internacionalizacion = p_internacionalizacion,
    certificaciones = p_certificaciones,
    posicionamiento_marca = p_posicionamiento_marca,
    beneficios_ventanilla = p_beneficios_ventanilla,
    fortalezas_ambiental = p_fortalezas_ambiental,
    fortalezas_social = p_fortalezas_social,
    fortalezas_economico = p_fortalezas_economico,
    debilidades_ambiental = p_debilidades_ambiental,
    debilidades_social = p_debilidades_social,
    debilidades_financiera = p_debilidades_financiera
  where id = p_id;

  if not found then
    raise exception 'El negocio % no existe.', p_id;
  end if;

  insert into admin_logs (admin_id, accion, entidad, entidad_id, detalle)
  values (
    auth.uid(), 'editar_ficha_tecnica', 'negocios', p_id,
    jsonb_build_object('novedad', p_novedad)
  );
end;
$$;

revoke all on function guardar_ficha_tecnica_negocio from public;
grant execute on function guardar_ficha_tecnica_negocio to authenticated;

-- 11) guardar_puntaje_negocio: upsert de un solo (año, puntaje) — más
--     simple que meter la sincronización de negocio_puntajes dentro de
--     guardar_ficha_tecnica_negocio (el admin edita los puntajes de a uno,
--     no los 6 años a la vez).
create or replace function guardar_puntaje_negocio(
  p_negocio_id uuid,
  p_anio smallint,
  p_puntaje numeric
)
returns void
language plpgsql
security definer
set search_path = public
as $$
begin
  if not es_admin() then
    raise exception 'No autorizado: se requiere una cuenta administradora de CDMB.';
  end if;

  insert into negocio_puntajes (negocio_id, anio, puntaje)
  values (p_negocio_id, p_anio, p_puntaje)
  on conflict (negocio_id, anio) do update set puntaje = excluded.puntaje;
end;
$$;

revoke all on function guardar_puntaje_negocio from public;
grant execute on function guardar_puntaje_negocio to authenticated;
