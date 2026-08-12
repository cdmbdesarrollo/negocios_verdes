-- 0016_actualizacion_taxonomia_pnnv_2022_2030.sql
-- Reemplaza la taxonomía completa de categorías/subcategorías (investigación
-- propia, ver 0009) por la oficial del "Plan Nacional de Negocios Verdes
-- 2022-2030" (Minambiente, actualización del PNNV 2014), verificada
-- directamente contra los diagramas "Categoría | Subcategoría | Actividad
-- productiva" del documento (Ilustraciones 14-17, páginas 94-116):
-- 3 categorías, 12 subcategorías, 29 actividades productivas — un nivel
-- nuevo (actividad productiva) que no existía antes.
--
-- Los negocios cargados hasta ahora son de prueba (confirmado con el
-- usuario) — se borran junto con la taxonomía vieja, sin intentar
-- mapearlos. Es un reemplazo completo, no incremental.

-- 1) Borra negocios de prueba primero — de lo contrario el FK restrict de
--    categorias_oficiales/subcategorias no deja borrar la taxonomía vieja
--    mientras algo la siga usando. Cascada limpia negocio_fotos,
--    negocios_subcategorias y negocios_categorias solos.
delete from negocios;

-- 2) Borra subcategorías y categorías viejas (subcategorías primero, tiene
--    FK restrict hacia categorias_oficiales).
delete from subcategorias;
delete from categorias_oficiales;

-- 3) Nueva tabla: actividades_productivas — mismo patrón exacto que
--    subcategorias (incluido soporte de ícono de imagen, ver 0014), un
--    nivel más abajo.
create table if not exists actividades_productivas (
  id uuid primary key default gen_random_uuid(),
  subcategoria_id uuid not null references subcategorias(id) on delete restrict,
  nombre text not null,
  slug text not null unique,
  descripcion text,
  icono text,
  icono_url text,
  icono_path text,
  orden smallint not null default 0,
  activo boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index if not exists idx_actividades_productivas_subcategoria on actividades_productivas(subcategoria_id);

create trigger actividades_productivas_set_updated_at
  before update on actividades_productivas
  for each row execute function set_updated_at();

alter table actividades_productivas enable row level security;

create policy "actividades_productivas_select_publico"
  on actividades_productivas for select
  to anon, authenticated
  using (true);

create policy "actividades_productivas_admin_todo"
  on actividades_productivas for all
  to authenticated
  using (es_admin())
  with check (es_admin());

-- 4) Tabla puente negocios_actividades — mismo patrón que
--    negocios_subcategorias/negocios_categorias.
create table if not exists negocios_actividades (
  negocio_id uuid not null references negocios(id) on delete cascade,
  actividad_productiva_id uuid not null references actividades_productivas(id) on delete restrict,
  primary key (negocio_id, actividad_productiva_id)
);

create index if not exists idx_negocios_actividades_actividad on negocios_actividades(actividad_productiva_id);

alter table negocios_actividades enable row level security;

create policy "negocios_actividades_select_publico"
  on negocios_actividades for select
  to anon, authenticated
  using (
    exists (
      select 1 from negocios n
      where n.id = negocio_id and n.activo = true
    )
  );

create policy "negocios_actividades_admin_todo"
  on negocios_actividades for all
  to authenticated
  using (es_admin())
  with check (es_admin());

-- 5) Semilla de la taxonomía oficial: categorías → subcategorías →
--    actividades productivas, encadenado con CTEs y un slug temporal de
--    unión (no hace falta anotar UUIDs a mano).
with cat as (
  insert into categorias_oficiales (nombre, slug, descripcion, icono, orden) values
    ('Bioproductos y Servicios Sostenibles', 'bioproductos-servicios-sostenibles',
     'Actividades de negocios verdes originadas a partir de la transformación y aprovechamiento de recursos de fuente natural renovable.',
     '🌱', 1),
    ('Ecoproductos Industriales', 'ecoproductos-industriales',
     'Bienes y servicios que en su proceso productivo resultan menos contaminantes, ecoeficientes y que aprovechan ciclos extendidos de los materiales.',
     '♻️', 2),
    ('Productos por la Calidad Ambiental', 'calidad-ambiental',
     'Negocios que incorporan acciones para disminuir la contaminación del aire, el agua y el suelo, y mitigar o adaptarse al cambio climático.',
     '🌎', 3)
  returning id, slug
),
sub as (
  insert into subcategorias (categoria_oficial_id, nombre, slug, icono, orden)
  select cat.id, v.nombre, v.slug, v.icono, v.orden
  from (values
    ('bioproductos-servicios-sostenibles', 'Agrosistemas sostenibles', 'agrosistemas-sostenibles', '🌾', 1),
    ('bioproductos-servicios-sostenibles', 'Agroindustria sostenible', 'agroindustria-sostenible', '🏭', 2),
    ('bioproductos-servicios-sostenibles', 'Biocomercio', 'biocomercio', '🦋', 3),
    ('bioproductos-servicios-sostenibles', 'Biotecnología', 'biotecnologia', '🧬', 4),
    ('bioproductos-servicios-sostenibles', 'Turismo sostenible', 'turismo-sostenible', '🥾', 5),
    ('ecoproductos-industriales', 'Aprovechamiento y valorización de residuos', 'aprovechamiento-valorizacion-residuos', '♻️', 1),
    ('ecoproductos-industriales', 'Moda sostenible', 'moda-sostenible', '👕', 2),
    ('ecoproductos-industriales', 'Construcción e infraestructura sostenible', 'construccion-infraestructura-sostenible', '🏗️', 3),
    ('ecoproductos-industriales', 'Empaques y envases ecológicos', 'empaques-envases-ecologicos', '📦', 4),
    ('calidad-ambiental', 'Tecnologías verdes', 'tecnologias-verdes', '⚡', 1),
    ('calidad-ambiental', 'Negocios asociados con la preservación y restauración de ecosistemas', 'preservacion-restauracion-ecosistemas', '🌳', 2),
    ('calidad-ambiental', 'Transporte sostenible', 'transporte-sostenible', '🚲', 3)
  ) as v(cat_slug, nombre, slug, icono, orden)
  join cat on cat.slug = v.cat_slug
  returning id, slug
)
insert into actividades_productivas (subcategoria_id, nombre, slug, orden)
select sub.id, v.nombre, v.slug, v.orden
from (values
  ('agrosistemas-sostenibles', 'Agricultura orgánica', 'agricultura-organica', 1),
  ('agrosistemas-sostenibles', 'Agroecología', 'agroecologia', 2),
  ('agrosistemas-sostenibles', 'Agricultura sostenible', 'agricultura-sostenible', 3),
  ('agrosistemas-sostenibles', 'Ganadería sostenible', 'ganaderia-sostenible', 4),
  ('agrosistemas-sostenibles', 'Acuicultura y pesca sostenible', 'acuicultura-pesca-sostenible', 5),

  ('agroindustria-sostenible', 'Agroindustrial alimentario', 'agroindustrial-alimentario', 1),
  ('agroindustria-sostenible', 'Agroindustrial no alimentario', 'agroindustrial-no-alimentario', 2),

  ('biocomercio', 'Recursos genéticos y productos derivados', 'recursos-geneticos-productos-derivados', 1),
  ('biocomercio', 'Productos derivados de la fauna silvestre', 'productos-fauna-silvestre', 2),
  ('biocomercio', 'No maderables', 'no-maderables', 3),
  ('biocomercio', 'Maderables', 'maderables', 4),

  ('biotecnologia', 'Productos de la biotecnología', 'productos-biotecnologia', 1),

  ('turismo-sostenible', 'Servicios de turismo de naturaleza', 'servicios-turismo-naturaleza', 1),
  ('turismo-sostenible', 'Otros servicios de turismo sostenible', 'otros-servicios-turismo-sostenible', 2),

  ('aprovechamiento-valorizacion-residuos', 'Aprovechamiento de residuos orgánicos', 'aprovechamiento-residuos-organicos', 1),
  ('aprovechamiento-valorizacion-residuos', 'Aprovechamiento de residuos inorgánicos', 'aprovechamiento-residuos-inorganicos', 2),

  ('moda-sostenible', 'Textiles sostenibles', 'textiles-sostenibles', 1),
  ('moda-sostenible', 'Confección y manufactura', 'confeccion-manufactura', 2),
  ('moda-sostenible', 'Joyería, artesanía y bisutería', 'joyeria-artesania-bisuteria', 3),

  ('construccion-infraestructura-sostenible', 'Construcción de edificaciones e infraestructura sostenible', 'construccion-edificaciones-infraestructura', 1),
  ('construccion-infraestructura-sostenible', 'Biomateriales, eco materiales y equipos ecoeficientes', 'biomateriales-ecomateriales-equipos-ecoeficientes', 2),

  ('empaques-envases-ecologicos', 'Biopolímeros, fibras naturales, empaques y envases reciclables', 'biopolimeros-fibras-empaques-reciclables', 1),

  ('tecnologias-verdes', 'Generación y/o comercialización de energía a partir de FNCER', 'generacion-comercializacion-energia-fncer', 1),
  ('tecnologias-verdes', 'Tecnologías de información ambiental y otras tecnologías limpias', 'tecnologias-informacion-ambiental', 2),

  ('preservacion-restauracion-ecosistemas', 'Preservación', 'preservacion', 1),
  ('preservacion-restauracion-ecosistemas', 'Restauración', 'restauracion', 2),
  ('preservacion-restauracion-ecosistemas', 'Recuperación y remediación', 'recuperacion-remediacion', 3),

  ('transporte-sostenible', 'Motorizado', 'motorizado', 1),
  ('transporte-sostenible', 'No motorizado', 'no-motorizado', 2)
) as v(sub_slug, nombre, slug, orden)
join sub on sub.slug = v.sub_slug;

-- 6) guardar_negocio gana un parámetro más: p_actividad_ids uuid[]. Mismo
--    motivo que en 0015 con p_categoria_oficial_ids — cambia el tipo de
--    parámetros, hay que borrar la firma anterior explícitamente antes de
--    crear la nueva o PostgREST queda con dos versiones sobrecargadas sin
--    poder elegir cuál usar.
drop function if exists guardar_negocio(
  uuid, text, uuid[], text, text, double precision, double precision,
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
