-- 0040_negocio_productos.sql
--
-- Productos destacados: hasta 3 por negocio, cada uno con una foto y una
-- descripción corta. Reemplazan a la galería de fotos en la ficha pública
-- (pedido explícito: "en vez de una galería de fotos tener 3 productos").
-- Solo vitrina — el visitante los ve, no puede pedir ni comprar nada.
--
-- `negocio_fotos` (0005) NO se borra: queda como historial y sin uso desde
-- la app (al aplicar esta migración no tenía ninguna fila).
--
-- Mismo patrón que negocio_fotos: la visibilidad pública depende de
-- negocios.activo del padre; el admin hace todo. El formulario admin
-- sincroniza con borrar-todo-y-reinsertar en cada guardado. Las fotos van
-- al mismo bucket `negocios-fotos` (0008), en
-- negocios/<negocio_id>/productos/.

create table if not exists negocio_productos (
  id uuid primary key default gen_random_uuid(),
  negocio_id uuid not null references negocios(id) on delete cascade,
  -- Posición 0, 1 o 2: tope de 3 productos por negocio en la propia base,
  -- no solo en la UI.
  orden smallint not null check (orden between 0 and 2),
  foto_url text,
  -- Ruta del objeto en Storage (para poder borrarlo; la url sola no alcanza).
  foto_storage_path text,
  descripcion text check (descripcion is null or char_length(descripcion) <= 300),
  created_at timestamptz not null default now(),
  unique (negocio_id, orden),
  -- Un producto vacío no tiene sentido: al menos foto o descripción.
  check (foto_url is not null or descripcion is not null)
);

-- El unique (negocio_id, orden) ya sirve de índice para el FK negocio_id.

alter table negocio_productos enable row level security;

drop policy if exists "negocio_productos_select_publico" on negocio_productos;
create policy "negocio_productos_select_publico"
  on negocio_productos for select
  to anon, authenticated
  using (
    exists (
      select 1 from negocios
      where negocios.id = negocio_productos.negocio_id
        and negocios.activo = true
    )
  );

drop policy if exists "negocio_productos_admin_todo" on negocio_productos;
create policy "negocio_productos_admin_todo"
  on negocio_productos for all
  to authenticated
  using (es_admin())
  with check (es_admin());
