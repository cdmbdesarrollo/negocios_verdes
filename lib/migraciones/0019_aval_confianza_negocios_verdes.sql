-- 0019_aval_confianza_negocios_verdes.sql
--
-- "Aval de Confianza" es el término que la propia CDMB usa en sus
-- comunicados de prensa (Galardón Verde 2025: "78 Negocios Verdes que
-- obtuvieron el Aval de Confianza") para el reconocimiento base, distinto
-- del término genérico "Verificado" que ya usa nivel_desarrollo en este
-- sitio. No sabemos todavía si CDMB los usa como sinónimos exactos o como
-- dos cosas distintas en la práctica — en vez de decidirlo por adivinanza
-- y arriesgar tener que deshacer un cambio a nivel_desarrollo (que es un
-- enum central, usado en filtros, RLS-adyacente y en toda la UI), se
-- agrega como columna booleana independiente, exactamente el mismo
-- patrón que sello_marca en 0018. Si con el tiempo se confirma que es
-- redundante con "Verificado", se borra esta sola columna sin haber
-- tocado nada más — mucho más barato que lo contrario.
alter table negocios add column if not exists aval_confianza boolean not null default false;

-- guardar_negocio gana un parámetro más: p_aval_confianza boolean. Mismo
-- motivo que 0015/0016/0018 para borrar la firma anterior explícita.
drop function if exists guardar_negocio(
  uuid, text, uuid[], text, text, double precision, double precision,
  text, text, text, text, text, text, text, text, text, text, text,
  boolean, boolean, uuid[], uuid[], boolean
);

create or replace function guardar_negocio(
  p_id uuid,
  p_nombre text,
  p_categoria_oficial_ids uuid[],
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
  p_subcategoria_ids uuid[],
  p_actividad_ids uuid[],
  p_sello_marca boolean,
  p_aval_confianza boolean
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
      id, nombre, slug, categoria_oficial_id, municipio, direccion,
      latitud, longitud, descripcion_corta, descripcion, telefono, whatsapp,
      email, sitio_web, facebook_url, instagram_url,
      foto_portada_url, foto_portada_path, nivel_desarrollo, destacado, activo,
      sello_marca, aval_confianza, created_by
    ) values (
      v_id, p_nombre, v_slug, v_categoria_principal, p_municipio, p_direccion,
      p_latitud, p_longitud, p_descripcion_corta, p_descripcion, p_telefono, p_whatsapp,
      p_email, p_sitio_web, p_facebook_url, p_instagram_url,
      p_foto_portada_url, p_foto_portada_path, p_nivel_desarrollo, p_destacado, p_activo,
      p_sello_marca, p_aval_confianza, auth.uid()
    );
  else
    v_accion := 'editar_negocio';

    update negocios set
      nombre = p_nombre,
      slug = v_slug,
      categoria_oficial_id = v_categoria_principal,
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
      activo = p_activo,
      sello_marca = p_sello_marca,
      aval_confianza = p_aval_confianza
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
