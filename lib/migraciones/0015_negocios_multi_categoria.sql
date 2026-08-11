-- 0015_negocios_multi_categoria.sql
-- Un negocio verde puede pertenecer hasta a 3 categorías oficiales (antes
-- solo a una). negocios.categoria_oficial_id se mantiene como "categoría
-- principal" (la primera que elige el admin en el formulario) — así todo
-- lo que ya filtra/muestra por una sola categoría (buscador público,
-- tarjetas, índices, enlaces del inicio) sigue funcionando sin tocarlo.
-- negocios_categorias es la fuente de verdad de "a cuáles pertenece" y de
-- qué subcategorías se ofrecen en el formulario admin (solo las de las
-- categorías ya elegidas, no todas).

create table if not exists negocios_categorias (
  negocio_id uuid not null references negocios(id) on delete cascade,
  categoria_oficial_id uuid not null references categorias_oficiales(id) on delete restrict,
  primary key (negocio_id, categoria_oficial_id)
);

create index if not exists idx_negocios_categorias_categoria on negocios_categorias(categoria_oficial_id);

alter table negocios_categorias enable row level security;

-- Mismo criterio que negocios_subcategorias_select_publico: visible solo si
-- el negocio padre está activo, para no filtrar categorías de borradores.
create policy "negocios_categorias_select_publico"
  on negocios_categorias for select
  to anon, authenticated
  using (
    exists (
      select 1 from negocios n
      where n.id = negocio_id and n.activo = true
    )
  );

create policy "negocios_categorias_admin_todo"
  on negocios_categorias for all
  to authenticated
  using (es_admin())
  with check (es_admin());

-- Backfill: cada negocio que ya existe tiene una categoria_oficial_id —
-- se vuelve su única fila aquí, sin perder nada.
insert into negocios_categorias (negocio_id, categoria_oficial_id)
select id, categoria_oficial_id from negocios
on conflict do nothing;

-- guardar_negocio cambia de firma: p_categoria_oficial_id (uuid) pasa a
-- p_categoria_oficial_ids (uuid[], 1 a 3 elementos). Postgres no reemplaza
-- una función si cambian los tipos de parámetros — "create or replace"
-- crearía una SEGUNDA función sobrecargada en vez de reemplazar la vieja,
-- y PostgREST quedaría sin poder elegir cuál usar. Por eso el drop
-- explícito de la firma anterior antes de crear la nueva.
drop function if exists guardar_negocio(
  uuid, text, uuid, text, text, double precision, double precision,
  text, text, text, text, text, text, text, text, text, text, text,
  boolean, boolean, uuid[]
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
  v_categoria_principal uuid;
begin
  -- Re-chequeo obligatorio: ver comentario original en 0007, sigue
  -- aplicando igual de literal con la firma nueva.
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
      created_by
    ) values (
      v_id, p_nombre, v_slug, v_categoria_principal, p_municipio, p_direccion,
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
      activo = p_activo
    where id = v_id;

    if not found then
      raise exception 'El negocio % no existe.', v_id;
    end if;
  end if;

  delete from negocios_categorias where negocio_id = v_id;
  insert into negocios_categorias (negocio_id, categoria_oficial_id)
  select v_id, cat_id from unnest(p_categoria_oficial_ids) as cat_id;

  -- Sincroniza subcategorías: borrar+insertar, igual que antes de este
  -- cambio (ver 0007).
  delete from negocios_subcategorias where negocio_id = v_id;
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
