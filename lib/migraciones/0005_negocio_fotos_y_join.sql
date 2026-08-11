-- 0005_negocio_fotos_y_join.sql
-- Galería de fotos (4-5 por negocio) y relación N:M con subcategorías.

create table if not exists negocio_fotos (
  id uuid primary key default gen_random_uuid(),
  negocio_id uuid not null references negocios(id) on delete cascade,
  url text not null,
  -- Ruta del objeto en Storage (necesaria para poder borrarlo; la url
  -- pública sola no alcanza).
  storage_path text not null,
  orden smallint not null default 0,
  created_at timestamptz not null default now()
);

create index if not exists idx_negocio_fotos_negocio on negocio_fotos(negocio_id);

alter table negocio_fotos enable row level security;

-- La visibilidad depende de "negocios.activo" del padre, NO de esta tabla:
-- un "using (true)" aquí filtraría (mal) la galería de negocios sin publicar.
create policy "negocio_fotos_select_publico"
  on negocio_fotos for select
  to anon, authenticated
  using (
    exists (
      select 1 from negocios
      where negocios.id = negocio_fotos.negocio_id
        and negocios.activo = true
    )
  );

create policy "negocio_fotos_admin_todo"
  on negocio_fotos for all
  to authenticated
  using (es_admin())
  with check (es_admin());


create table if not exists negocios_subcategorias (
  negocio_id uuid not null references negocios(id) on delete cascade,
  subcategoria_id uuid not null references subcategorias(id) on delete cascade,
  primary key (negocio_id, subcategoria_id)
);

-- La PK compuesta ya cubre "subcategorías de este negocio"; este índice
-- cubre la dirección inversa, "negocios de esta subcategoría" (filtros).
create index if not exists idx_negocios_subcategorias_sub on negocios_subcategorias(subcategoria_id);

alter table negocios_subcategorias enable row level security;

-- Mismo razonamiento que negocio_fotos_select_publico arriba.
create policy "negocios_subcategorias_select_publico"
  on negocios_subcategorias for select
  to anon, authenticated
  using (
    exists (
      select 1 from negocios
      where negocios.id = negocios_subcategorias.negocio_id
        and negocios.activo = true
    )
  );

create policy "negocios_subcategorias_admin_todo"
  on negocios_subcategorias for all
  to authenticated
  using (es_admin())
  with check (es_admin());
