-- 0004_negocios.sql
-- Tabla principal del directorio. municipio está restringido por CHECK a los
-- 13 municipios de la jurisdicción CDMB — deben coincidir carácter por
-- carácter (con tildes) con kMunicipios en lib/catalogos.dart.

create table if not exists negocios (
  id uuid primary key default gen_random_uuid(),
  nombre text not null,
  slug text not null unique,
  categoria_oficial_id uuid not null references categorias_oficiales(id) on delete restrict,
  municipio text not null check (municipio in (
    'Bucaramanga','Floridablanca','Girón','Piedecuesta','Vetas','California',
    'Suratá','Matanza','Charta','Tona','El Playón','Rionegro','Lebrija'
  )),
  direccion text,
  -- Opcionales: un negocio sin coordenadas sigue apareciendo en la lista,
  -- solo no tiene pin en el mapa (ver BuscarPage).
  latitud double precision,
  longitud double precision,
  descripcion_corta text not null,
  descripcion text not null,
  telefono text,
  -- Único contacto realmente obligatorio: muchos negocios rurales solo
  -- tienen WhatsApp. Se guarda como dígitos con indicativo ("573001234567"),
  -- el link wa.me se arma en Dart al mostrarlo.
  whatsapp text not null,
  email text,
  sitio_web text,
  facebook_url text,
  instagram_url text,
  foto_portada_url text,
  foto_portada_path text,
  nivel_desarrollo text not null default 'en_verificacion'
    check (nivel_desarrollo in ('en_verificacion','verificado','negocio_ancla')),
  destacado boolean not null default false,
  activo boolean not null default false,
  busqueda tsvector generated always as (
    to_tsvector('spanish', immutable_unaccent(
      coalesce(nombre, '') || ' ' ||
      coalesce(descripcion_corta, '') || ' ' ||
      coalesce(descripcion, '')
    ))
  ) stored,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  created_by uuid references auth.users(id) on delete set null,
  -- Un admin no puede publicar un negocio sin foto de portada.
  constraint negocios_publicado_necesita_foto
    check (activo = false or foto_portada_url is not null)
);

create index if not exists idx_negocios_busqueda on negocios using gin(busqueda);
create index if not exists idx_negocios_categoria on negocios(categoria_oficial_id);
create index if not exists idx_negocios_municipio on negocios(municipio);
create index if not exists idx_negocios_activo on negocios(activo);

create trigger negocios_set_updated_at
  before update on negocios
  for each row execute function set_updated_at();

alter table negocios enable row level security;

create policy "negocios_select_publico"
  on negocios for select
  to anon, authenticated
  using (activo = true);

-- FOR ALL ya cubre select/insert/update/delete para admins (incluye ver
-- borradores inactivos en /admin/negocios).
create policy "negocios_admin_todo"
  on negocios for all
  to authenticated
  using (es_admin())
  with check (es_admin());
