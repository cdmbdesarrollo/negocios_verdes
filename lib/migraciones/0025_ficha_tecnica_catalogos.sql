-- 0025_ficha_tecnica_catalogos.sql
--
-- Dos correcciones sobre feedback directo del admin en vivo:
--
-- 1) 12 columnas de negocios (agregadas en 0022) resultaron ser lectura de
--    columnas OCULTAS del Excel de CDMB — confirmado programáticamente
--    (openpyxl reporta cada columna oculta o no, no es una suposición):
--    tiempo_constitucion, codigo_marca, fortalecimiento_tecnico,
--    fortalecimiento_academico, fortalecimiento_financiero,
--    internacionalizacion (columna aparte de "exportacion", que SÍ es
--    visible), certificaciones, posicionamiento_marca,
--    debilidades_ambiental, debilidades_social, debilidades_financiera,
--    beneficios_ventanilla. CDMB no las usa activamente (por eso las
--    tiene ocultas en su propio archivo) — se borran en vez de dejarlas
--    sin usar. fortalezas_ambiental/social/economico SÍ son columnas
--    visibles, se quedan.
--
-- 2) "no este harckoreada": los ~25 campos restantes que en la práctica
--    son categóricos (SI/NO/PENDIENTE/N/A y similares — confirmado
--    analizando los valores reales del Excel, no adivinado) pasan a
--    elegirse de un catálogo editable en la base de datos en vez de
--    texto libre, para que un admin no pueda escribir un valor
--    ligeramente distinto cada vez y volver el dato inútil para
--    análisis futuro. opciones_campo es genérica (una tabla sirve para
--    los ~25 campos, no una tabla por campo) y también sirve para los 2
--    campos que son nombres de personas (responsable_cdmb, delegado):
--    mismo problema (evitar que alguien escriba mal un nombre), misma
--    solución (elegir de una lista existente o agregar una nueva).

-- 1) Borra las 12 columnas de columnas ocultas del Excel.
alter table negocios drop column if exists tiempo_constitucion;
alter table negocios drop column if exists codigo_marca;
alter table negocios drop column if exists fortalecimiento_tecnico;
alter table negocios drop column if exists fortalecimiento_academico;
alter table negocios drop column if exists fortalecimiento_financiero;
alter table negocios drop column if exists internacionalizacion;
alter table negocios drop column if exists certificaciones;
alter table negocios drop column if exists posicionamiento_marca;
alter table negocios drop column if exists debilidades_ambiental;
alter table negocios drop column if exists debilidades_social;
alter table negocios drop column if exists debilidades_financiera;
alter table negocios drop column if exists beneficios_ventanilla;

-- 2) novedad: estandarizado a exactamente 4 valores (antes tenía variantes
--    como "ACTIVO (RETIRADO)"/"ACTIVO (RETIRADO) P"/"ACTIVO (SUSPENDIDO)"
--    que en la práctica son "RETIRADO"/"RETIRADO"/"SUSPENDIDO" — pedido
--    explícito de estandarizarlas). El CHECK es la garantía real de que
--    no vuelva a haber una quinta variante suelta.
alter table negocios add constraint negocios_novedad_valida
  check (novedad is null or novedad in ('ACTIVO', 'INACTIVO', 'RETIRADO', 'SUSPENDIDO'));

-- 3) Catálogo genérico de opciones por campo — reemplaza el texto libre en
--    los campos categóricos de la ficha técnica. select público sin
--    restricción (mismo patrón que categorias_oficiales/veredas: son
--    catálogos, no datos de negocios individuales) porque el formulario
--    admin los necesita cargar; nada sensible viaja acá.
create table if not exists opciones_campo (
  id uuid primary key default gen_random_uuid(),
  campo text not null,
  valor text not null,
  orden smallint not null default 0,
  created_at timestamptz not null default now(),
  constraint opciones_campo_unico unique (campo, valor)
);

create index if not exists idx_opciones_campo_campo on opciones_campo(campo);

alter table opciones_campo enable row level security;

create policy "opciones_campo_select_publico"
  on opciones_campo for select
  to anon, authenticated
  using (true);

create policy "opciones_campo_admin_todo"
  on opciones_campo for all
  to authenticated
  using (es_admin())
  with check (es_admin());

-- Semilla: las opciones reales encontradas en el Excel de CDMB para cada
-- campo categórico, ya normalizadas (mayúscula/minúscula pareja, typos
-- corregidos: "N/a"→"N/A", "MIXTO"→"MIXTA", etc. — ver generar_0026.py,
-- que analiza el Excel real para armar esta lista, no se escribió a
-- mano). Los nombres de RESPONSABLE CDMB / DELEGADO se cargan en
-- 0026_datos_cdmb_negocios_verdes_*.sql junto con los negocios (dependen
-- de leer el Excel fila por fila), no acá.
insert into opciones_campo (campo, valor, orden) values
  ('registro_nacional_turismo', 'Sí', 1),
  ('registro_nacional_turismo', 'No', 2),
  ('registro_nacional_turismo', 'Pendiente', 3),
  ('registro_nacional_turismo', 'No aplica', 4),

  ('uso_suelo', 'Sí', 1),
  ('uso_suelo', 'No', 2),
  ('uso_suelo', 'Pendiente', 3),
  ('uso_suelo', 'No aplica', 4),

  ('concesion_aguas', 'Acueducto', 1),
  ('concesion_aguas', 'Acueducto veredal', 2),
  ('concesion_aguas', 'Sí', 3),
  ('concesion_aguas', 'No', 4),
  ('concesion_aguas', 'Pendiente', 5),
  ('concesion_aguas', 'No aplica', 6),
  ('concesion_aguas', 'No hay ficha', 7),

  ('vertimientos', 'Sí', 1),
  ('vertimientos', 'No', 2),
  ('vertimientos', 'Requiere', 3),
  ('vertimientos', 'Pendiente', 4),
  ('vertimientos', 'No aplica', 5),
  ('vertimientos', 'No hay ficha', 6),

  ('pueaa', 'Sí', 1),
  ('pueaa', 'No', 2),
  ('pueaa', 'Pendiente', 3),
  ('pueaa', 'No aplica', 4),
  ('pueaa', 'No hay ficha', 5),

  ('pgris', 'Sí', 1),
  ('pgris', 'No', 2),
  ('pgris', 'Pendiente', 3),
  ('pgris', 'No aplica', 4),
  ('pgris', 'No hay ficha', 5),

  ('pozo_septico', 'Sí', 1),
  ('pozo_septico', 'No', 2),
  ('pozo_septico', 'Pendiente', 3),
  ('pozo_septico', 'No aplica', 4),
  ('pozo_septico', 'No hay ficha', 5),

  ('alcantarillado', 'Sí', 1),
  ('alcantarillado', 'No', 2),
  ('alcantarillado', 'Pendiente', 3),
  ('alcantarillado', 'No aplica', 4),
  ('alcantarillado', 'No hay ficha', 5),

  ('ica', 'Sí', 1),
  ('ica', 'No', 2),
  ('ica', 'Pendiente', 3),
  ('ica', 'No aplica', 4),
  ('ica', 'No hay ficha', 5),

  ('invima', 'Sí', 1),
  ('invima', 'No', 2),
  ('invima', 'Pendiente', 3),
  ('invima', 'No aplica', 4),

  ('certificado_tenencia_animales', 'Sí', 1),
  ('certificado_tenencia_animales', 'No', 2),
  ('certificado_tenencia_animales', 'Pendiente', 3),
  ('certificado_tenencia_animales', 'No aplica', 4),

  ('buenas_practicas_agricolas', 'Sí', 1),
  ('buenas_practicas_agricolas', 'No', 2),
  ('buenas_practicas_agricolas', 'Pendiente', 3),
  ('buenas_practicas_agricolas', 'No aplica', 4),

  ('buenas_practicas_apicolas', 'Sí', 1),
  ('buenas_practicas_apicolas', 'No', 2),
  ('buenas_practicas_apicolas', 'Pendiente', 3),
  ('buenas_practicas_apicolas', 'No aplica', 4),

  ('registro_apicola', 'Sí', 1),
  ('registro_apicola', 'No', 2),
  ('registro_apicola', 'Pendiente', 3),
  ('registro_apicola', 'No aplica', 4),

  ('intervencion_cauce', 'Sí', 1),
  ('intervencion_cauce', 'No', 2),
  ('intervencion_cauce', 'Pendiente', 3),
  ('intervencion_cauce', 'No aplica', 4),

  ('capacidad_carga', 'Sí', 1),
  ('capacidad_carga', 'No', 2),
  ('capacidad_carga', 'Pendiente', 3),
  ('capacidad_carga', 'No aplica', 4),

  ('sstt', 'Sí', 1),
  ('sstt', 'No', 2),
  ('sstt', 'En implementación', 3),
  ('sstt', 'Pendiente', 4),
  ('sstt', 'No aplica', 5),
  ('sstt', 'No hay ficha', 6),

  ('canal_venta', 'B2B', 1),
  ('canal_venta', 'B2C', 2),
  ('canal_venta', 'Mixta', 3),
  ('canal_venta', 'Pendiente', 4),
  ('canal_venta', 'No aplica', 5),

  ('exportacion', 'Sí', 1),
  ('exportacion', 'No', 2),

  ('rut_camara_comercio', 'Cámara de comercio', 1),
  ('rut_camara_comercio', 'RUT', 2),
  ('rut_camara_comercio', 'Cámara de comercio y RUT', 3),
  ('rut_camara_comercio', 'Sin verificar', 4),
  ('rut_camara_comercio', 'No tiene', 5),
  ('rut_camara_comercio', 'Pendiente', 6),

  ('tipo_negocio_verde', 'Inicial', 1),
  ('tipo_negocio_verde', 'Básico', 2),
  ('tipo_negocio_verde', 'Intermedio', 3),
  ('tipo_negocio_verde', 'Dinamizadoras', 4),
  ('tipo_negocio_verde', 'Satisfactorio', 5),
  ('tipo_negocio_verde', 'Avanzado', 6),
  ('tipo_negocio_verde', 'Pendiente', 7),
  ('tipo_negocio_verde', 'No aplica', 8),

  ('aplicacion_ficha_2025', 'Actualizó', 1),
  ('aplicacion_ficha_2025', 'No actualizó', 2),
  ('aplicacion_ficha_2025', 'Pendiente', 3),
  ('aplicacion_ficha_2025', 'No aplica', 4)
on conflict (campo, valor) do nothing;

-- 4) guardar_ficha_tecnica_negocio: pierde los 12 parámetros de las
--    columnas borradas. Cambia el tipo de parámetros (menos), hay que
--    borrar la firma anterior explícitamente antes de crear la nueva —
--    mismo motivo de siempre (0015/0016/0018/0019/0020/0022).
drop function if exists guardar_ficha_tecnica_negocio(
  uuid, text, text, text, smallint, text, text, text, text, text, text,
  text, text, text, text, date, text, date, text, text, text, text,
  text, date, text, date, text, text, text, text, text, text, text,
  text, text, text, text, text, text, text, text, text, text, text,
  text, text, text, text, text, text, text
);

create or replace function guardar_ficha_tecnica_negocio(
  p_id uuid,
  p_novedad text,
  p_tipo_negocio_verde text,
  p_anio_registro smallint,
  p_cota_msnm text,
  p_aplicacion_ficha_2025 text,
  p_observaciones text,
  p_delegado text,
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
  p_fortalezas_ambiental text,
  p_fortalezas_social text,
  p_fortalezas_economico text,
  p_este text default null,
  p_norte text default null
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
    anio_registro = p_anio_registro,
    cota_msnm = p_cota_msnm,
    aplicacion_ficha_2025 = p_aplicacion_ficha_2025,
    observaciones = p_observaciones,
    delegado = p_delegado,
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
    fortalezas_ambiental = p_fortalezas_ambiental,
    fortalezas_social = p_fortalezas_social,
    fortalezas_economico = p_fortalezas_economico,
    este = p_este,
    norte = p_norte
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

-- 5) guardar_opcion_campo: agrega una opción nueva a un campo del catálogo
--    ("deja una opción adicional si es necesario para el administrador")
--    — insert directo también funcionaría vía la policy de arriba, pero
--    una RPC deja auditado en admin_logs quién agregó qué, igual que el
--    resto de escrituras admin de este archivo.
create or replace function guardar_opcion_campo(p_campo text, p_valor text)
returns uuid
language plpgsql
security definer
set search_path = public
as $$
declare
  v_id uuid;
begin
  if not es_admin() then
    raise exception 'No autorizado: se requiere una cuenta administradora de CDMB.';
  end if;

  insert into opciones_campo (campo, valor, orden)
  values (p_campo, p_valor, 999)
  on conflict (campo, valor) do update set valor = excluded.valor
  returning id into v_id;

  insert into admin_logs (admin_id, accion, entidad, entidad_id, detalle)
  values (
    auth.uid(), 'agregar_opcion_campo', 'opciones_campo', v_id,
    jsonb_build_object('campo', p_campo, 'valor', p_valor)
  );

  return v_id;
end;
$$;

revoke all on function guardar_opcion_campo from public;
grant execute on function guardar_opcion_campo to authenticated;
