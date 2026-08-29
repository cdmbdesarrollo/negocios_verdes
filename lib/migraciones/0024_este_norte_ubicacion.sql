-- 0024_este_norte_ubicacion.sql
--
-- Pedido explícito: guardar Este/Norte tal cual los escribe CDMB (el
-- formato original de su base, no solo el resultado ya convertido a
-- latitud/longitud) — admin-only, de referencia y para poder corregir a
-- mano el valor de origen si la conversión automática no da bien. Cota ya
-- tenía su columna (cota_msnm, ver 0022). latitud/longitud (ya existentes
-- desde 0004) siguen siendo las que de verdad usa el mapa — el admin
-- puede escribir Este/Norte y pedirle al formulario que calcule
-- latitud/longitud a partir de ahí, o seguir marcando el punto directo en
-- el mapa como hasta ahora; ambos caminos conviven.
alter table negocios add column if not exists este text;
alter table negocios add column if not exists norte text;

-- guardar_ficha_tecnica_negocio gana 2 parámetros al final, con default
-- null — a diferencia de los cambios de firma anteriores (0015/0016/0018/
-- 0019/0020/0022), agregar parámetros nuevos SOLO al final y con default
-- no rompe la firma existente ante Postgres, así que no hace falta un
-- DROP FUNCTION explícito esta vez.
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
  p_debilidades_financiera text,
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
    debilidades_financiera = p_debilidades_financiera,
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
