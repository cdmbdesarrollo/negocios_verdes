-- 0028_telefono_secundario.sql
--
-- Contacto telefónico, feedback directo del admin:
--   * Los celulares en Colombia son 10 dígitos que empiezan por 3
--     (ej. 3045462395). Para que el botón de WhatsApp funcione hay que
--     guardarlos con indicativo país 57 → `573045462395`. Eso lo hace el
--     formulario al guardar (no la base): si `whatsapp` va vacío y el
--     teléfono es un celular, se copia con el 57 adelante.
--   * Si el número NO es celular (fijo, 7 dígitos, etc.) se queda en
--     `telefono` y no se usa para WhatsApp.
--   * Si el negocio tiene MÁS DE UN número, el segundo va en la columna
--     nueva `telefono_secundario` (antes se pegaban los dos en `telefono`
--     con un guion, lo que rompía cualquier link `wa.me`).
--
-- Solo suma una columna y actualiza la firma de la RPC guardar_negocio
-- para recibirla. No toca datos existentes.

alter table negocios add column if not exists telefono_secundario text;

-- La RPC guardar_negocio gana un parámetro (p_telefono_secundario). Como
-- agregar un parámetro crea una FUNCIÓN NUEVA en Postgres (la vieja firma
-- de 29 args seguiría existiendo y el rpc() de supabase_flutter no sabría
-- a cuál llamar), se borran todas las versiones primero y se recrea una
-- sola — mismo patrón que 0025 usó para guardar_ficha_tecnica_negocio.
do $$
declare
  r record;
begin
  for r in
    select p.oid::regprocedure as firma
    from pg_proc p
    join pg_namespace n on n.oid = p.pronamespace
    where n.nspname = 'public' and p.proname = 'guardar_negocio'
  loop
    execute format('drop function %s', r.firma);
  end loop;
end $$;

create function guardar_negocio(
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
  p_actividad_ids uuid[],
  p_telefono_secundario text
)
returns uuid
language plpgsql
security definer
set search_path to 'public'
as $function$
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
      latitud, longitud, descripcion_corta, descripcion, telefono, telefono_secundario, whatsapp,
      email, sitio_web, facebook_url, instagram_url,
      foto_portada_url, foto_portada_path,
      representante_legal, producto, nit, naturaleza_juridica,
      emprendimiento_verde, sello_marca, avalado,
      destacado, activo, created_by
    ) values (
      v_id, p_nombre, v_slug, v_categoria_principal, p_municipio, p_vereda_id, p_direccion,
      p_latitud, p_longitud, p_descripcion_corta, p_descripcion, p_telefono, p_telefono_secundario, p_whatsapp,
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
      telefono_secundario = p_telefono_secundario,
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
$function$;

revoke all on function guardar_negocio(uuid, text, uuid[], text, uuid, text, double precision, double precision, text, text, text, text, text, text, text, text, text, text, text, text, text, text, boolean, boolean, boolean, boolean, boolean, uuid[], uuid[], text) from public;
grant execute on function guardar_negocio(uuid, text, uuid[], text, uuid, text, double precision, double precision, text, text, text, text, text, text, text, text, text, text, text, text, text, text, boolean, boolean, boolean, boolean, boolean, uuid[], uuid[], text) to authenticated;
