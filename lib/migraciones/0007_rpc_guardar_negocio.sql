-- 0007_rpc_guardar_negocio.sql
-- Crear/editar un negocio toca 3 tablas a la vez (negocios,
-- negocios_subcategorias, admin_logs) — exactamente el caso que se resuelve
-- con una RPC SECURITY DEFINER en vez de writes sueltos desde el cliente.
--
-- Los toggles simples (activo, destacado) y el borrado SÍ se hacen con
-- updates/deletes directos desde el cliente (permitidos por
-- negocios_admin_todo en 0004) — esta RPC es solo para el formulario de
-- crear/editar, que necesita atomicidad entre las 3 tablas.

create or replace function generar_slug_unico(p_base text, p_id uuid)
returns text
language plpgsql
as $$
declare
  v_slug text;
  v_intento int := 1;
  v_existe boolean;
begin
  v_slug := trim(both '-' from regexp_replace(
    lower(immutable_unaccent(coalesce(p_base, ''))),
    '[^a-z0-9]+', '-', 'g'
  ));
  if v_slug = '' then
    v_slug := 'negocio';
  end if;

  loop
    select exists(
      select 1 from negocios
      where slug = v_slug
        and (p_id is null or id <> p_id)
    ) into v_existe;

    exit when not v_existe;

    v_intento := v_intento + 1;
    v_slug := v_slug || '-' || v_intento;
  end loop;

  return v_slug;
end;
$$;

create or replace function guardar_negocio(
  -- SIEMPRE viene con valor: el cliente genera el uuid con Uuid().v4() al
  -- abrir el formulario (crear o editar), ANTES de llamar a esta función —
  -- necesita ese id de antemano para las rutas de Storage de portada/
  -- galería (ver GaleriaEditor). Por eso esta función decide crear vs.
  -- actualizar comprobando si el id YA EXISTE, no si es nulo.
  p_id uuid,
  p_nombre text,
  p_categoria_oficial_id uuid,
  p_municipio text,
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
  p_nivel_desarrollo text,
  p_destacado boolean,
  p_activo boolean,
  p_subcategoria_ids uuid[]
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
begin
  -- Re-chequeo obligatorio: al ser SECURITY DEFINER, esta función bypassea
  -- RLS por diseño. Sin este chequeo, cualquier autenticado (o incluso
  -- anon, si el grant fuera demasiado laxo) podría escribir negocios sin
  -- que RLS lo frene en ningún otro lado.
  if not es_admin() then
    raise exception 'No autorizado: se requiere una cuenta administradora de CDMB.';
  end if;

  select exists(select 1 from negocios where id = v_id) into v_ya_existe;

  v_slug := generar_slug_unico(p_nombre, v_id);

  if not v_ya_existe then
    v_accion := 'crear_negocio';

    insert into negocios (
      id, nombre, slug, categoria_oficial_id, municipio, direccion,
      latitud, longitud, descripcion_corta, descripcion, telefono, whatsapp,
      email, sitio_web, facebook_url, instagram_url,
      foto_portada_url, foto_portada_path, nivel_desarrollo, destacado, activo,
      created_by
    ) values (
      v_id, p_nombre, v_slug, p_categoria_oficial_id, p_municipio, p_direccion,
      p_latitud, p_longitud, p_descripcion_corta, p_descripcion, p_telefono, p_whatsapp,
      p_email, p_sitio_web, p_facebook_url, p_instagram_url,
      p_foto_portada_url, p_foto_portada_path, p_nivel_desarrollo, p_destacado, p_activo,
      auth.uid()
    );
  else
    v_accion := 'editar_negocio';

    update negocios set
      nombre = p_nombre,
      slug = v_slug,
      categoria_oficial_id = p_categoria_oficial_id,
      municipio = p_municipio,
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
      nivel_desarrollo = p_nivel_desarrollo,
      destacado = p_destacado,
      activo = p_activo
    where id = v_id;

    if not found then
      raise exception 'El negocio % no existe.', v_id;
    end if;
  end if;

  -- Sincroniza subcategorías: borrar+insertar es más simple y menos
  -- propenso a errores que calcular un diff para un multi-select pequeño.
  delete from negocios_subcategorias where negocio_id = v_id;

  -- cardinality() en vez de array_length(): array_length devuelve NULL (no 0)
  -- para un array vacío '{}', un gotcha clásico que aquí no vale la pena arriesgar.
  if coalesce(cardinality(p_subcategoria_ids), 0) > 0 then
    insert into negocios_subcategorias (negocio_id, subcategoria_id)
    select v_id, sub_id from unnest(p_subcategoria_ids) as sub_id;
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
