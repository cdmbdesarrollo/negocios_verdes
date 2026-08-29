-- 0021_veredas.sql
--
-- Catálogo editable de veredas, a diferencia de los 13 municipios (esos
-- siguen fijos en lib/catalogos.dart, nunca se editan desde el admin). Una
-- vereda pertenece a un único municipio — pedido explícito: "el listado de
-- veredas debe quedar también en este caso, con la posibilidad de crear
-- nuevas veredas a futuro. los municipios sí son los 13". Mismo patrón
-- exacto que categorias_oficiales/subcategorias/actividades_productivas
-- (select público sin restricción de activo, admin CRUD completo).

create table if not exists veredas (
  id uuid primary key default gen_random_uuid(),
  municipio text not null check (municipio in (
    'Bucaramanga','Floridablanca','Girón','Piedecuesta','Vetas','California',
    'Suratá','Matanza','Charta','Tona','El Playón','Rionegro','Lebrija'
  )),
  nombre text not null,
  slug text not null,
  activo boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  -- Un mismo nombre de vereda puede repetirse en dos municipios distintos
  -- (son entidades territoriales separadas) pero no dos veces dentro del
  -- mismo municipio.
  constraint veredas_municipio_slug_unico unique (municipio, slug)
);

create index if not exists idx_veredas_municipio on veredas(municipio);

create trigger veredas_set_updated_at
  before update on veredas
  for each row execute function set_updated_at();

alter table veredas enable row level security;

create policy "veredas_select_publico"
  on veredas for select
  to anon, authenticated
  using (true);

create policy "veredas_admin_todo"
  on veredas for all
  to authenticated
  using (es_admin())
  with check (es_admin());

-- negocios.vereda_id: FK opcional (muchos negocios no tienen vereda
-- registrada todavía, sobre todo los urbanos). "on delete set null": si se
-- borra una vereda del catálogo, el negocio no debe borrarse con ella, solo
-- pierde esa referencia.
alter table negocios add column if not exists vereda_id uuid
  references veredas(id) on delete set null;

create index if not exists idx_negocios_vereda on negocios(vereda_id);
