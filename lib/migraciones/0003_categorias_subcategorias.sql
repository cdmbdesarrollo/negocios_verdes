-- 0003_categorias_subcategorias.sql
-- Categorías oficiales + subcategorías descriptivas (ej. Apicultura).
-- Editables desde /admin/categorias y /admin/subcategorias.

create table if not exists categorias_oficiales (
  id uuid primary key default gen_random_uuid(),
  nombre text not null,
  slug text not null unique,
  descripcion text,
  icono text,
  -- Etiqueta opcional, solo informativa, con la categoría nacional del Plan
  -- Nacional de Negocios Verdes a la que corresponde esta categoría (las 3
  -- categorías nacionales son más generales que estas 8). No participa en
  -- ningún filtro ni relación — es puro texto de contexto para el visitante.
  categoria_nacional text,
  orden smallint not null default 0,
  -- Oculta la categoría de los formularios de creación sin romper el
  -- "on delete restrict" de negocios que ya la usan.
  activo boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create trigger categorias_oficiales_set_updated_at
  before update on categorias_oficiales
  for each row execute function set_updated_at();

alter table categorias_oficiales enable row level security;

-- Visible para todos sin importar "activo": si se oculta una categoría de
-- los formularios, los negocios que ya la usan igual deben poder mostrar su
-- nombre en el sitio público. "activo" es un filtro de formulario, no de
-- visibilidad.
create policy "categorias_oficiales_select_publico"
  on categorias_oficiales for select
  to anon, authenticated
  using (true);

create policy "categorias_oficiales_admin_todo"
  on categorias_oficiales for all
  to authenticated
  using (es_admin())
  with check (es_admin());


create table if not exists subcategorias (
  id uuid primary key default gen_random_uuid(),
  categoria_oficial_id uuid not null references categorias_oficiales(id) on delete restrict,
  nombre text not null,
  slug text not null unique,
  icono text,
  orden smallint not null default 0,
  activo boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index if not exists idx_subcategorias_categoria on subcategorias(categoria_oficial_id);

create trigger subcategorias_set_updated_at
  before update on subcategorias
  for each row execute function set_updated_at();

alter table subcategorias enable row level security;

-- Mismo razonamiento que categorias_oficiales_select_publico arriba.
create policy "subcategorias_select_publico"
  on subcategorias for select
  to anon, authenticated
  using (true);

create policy "subcategorias_admin_todo"
  on subcategorias for all
  to authenticated
  using (es_admin())
  with check (es_admin());
