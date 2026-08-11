-- 0011_sitio_configuracion_y_banners.sql
-- Logo y banners del carrusel de inicio administrables desde /admin/apariencia
-- (antes el logo era un asset empaquetado en el build; ahora vive en Storage
-- y se puede cambiar sin recompilar la app).

-- Tabla "singleton": el CHECK (id = 'singleton') garantiza que nunca pueda
-- existir más de una fila — ni por INSERT con otro id (viola el CHECK) ni
-- por INSERT duplicado (viola la PK). Evita tener que gestionar "cuál fila
-- es la de verdad" en el código.
create table if not exists configuracion_sitio (
  id text primary key default 'singleton' check (id = 'singleton'),
  logo_url text,
  logo_path text,
  updated_at timestamptz not null default now()
);

insert into configuracion_sitio (id) values ('singleton') on conflict (id) do nothing;

create trigger configuracion_sitio_set_updated_at
  before update on configuracion_sitio
  for each row execute function set_updated_at();

alter table configuracion_sitio enable row level security;

create policy "configuracion_sitio_select_publico"
  on configuracion_sitio for select
  to anon, authenticated
  using (true);

create policy "configuracion_sitio_admin_todo"
  on configuracion_sitio for all
  to authenticated
  using (es_admin())
  with check (es_admin());


create table if not exists banners (
  id uuid primary key default gen_random_uuid(),
  imagen_url text not null,
  imagen_path text not null,
  -- Ruta interna ("/buscar?categoria=...") o URL externa (https://...).
  -- Nula = banner puramente decorativo, sin acción al tocarlo.
  url_destino text,
  -- Solo aplica a URLs externas — una ruta interna nunca abre pestaña
  -- nueva, sería una experiencia rara dentro de la misma app.
  abrir_en_pestana_nueva boolean not null default true,
  orden smallint not null default 0,
  activo boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index if not exists idx_banners_orden on banners(orden);

create trigger banners_set_updated_at
  before update on banners
  for each row execute function set_updated_at();

alter table banners enable row level security;

create policy "banners_select_publico"
  on banners for select
  to anon, authenticated
  using (activo = true);

create policy "banners_admin_todo"
  on banners for all
  to authenticated
  using (es_admin())
  with check (es_admin());


-- Bucket separado de "negocios-fotos": esto es apariencia/marca del sitio,
-- no fotos de negocios — mismo patrón de policies que 0008.
insert into storage.buckets (id, name, public)
values ('sitio-assets', 'sitio-assets', true)
on conflict (id) do nothing;

create policy "sitio_assets_storage_select_publico"
  on storage.objects for select
  to anon, authenticated
  using (bucket_id = 'sitio-assets');

create policy "sitio_assets_storage_admin_insert"
  on storage.objects for insert
  to authenticated
  with check (bucket_id = 'sitio-assets' and es_admin());

create policy "sitio_assets_storage_admin_update"
  on storage.objects for update
  to authenticated
  using (bucket_id = 'sitio-assets' and es_admin())
  with check (bucket_id = 'sitio-assets' and es_admin());

create policy "sitio_assets_storage_admin_delete"
  on storage.objects for delete
  to authenticated
  using (bucket_id = 'sitio-assets' and es_admin());
