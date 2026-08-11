-- 0006_admin_logs.sql
-- Auditoría de acciones administrativas.

create table if not exists admin_logs (
  id uuid primary key default gen_random_uuid(),
  admin_id uuid references auth.users(id) on delete set null,
  accion text not null,
  entidad text,
  entidad_id uuid,
  detalle jsonb,
  created_at timestamptz not null default now()
);

create index if not exists idx_admin_logs_created on admin_logs(created_at desc);

alter table admin_logs enable row level security;

-- Solo lectura para admins. Sin policy de escritura a propósito: los únicos
-- inserts vienen de la RPC guardar_negocio() (SECURITY DEFINER, bypassea
-- RLS), nunca directo desde el cliente.
create policy "admin_logs_select_admin"
  on admin_logs for select
  to authenticated
  using (es_admin());
