-- 0002_perfiles_y_roles.sql
-- Perfiles de administradores CDMB. No hay cuentas públicas en este proyecto:
-- toda persona en auth.users es (o está pendiente de ser) staff de CDMB.

create table if not exists perfiles (
  id uuid primary key references auth.users(id) on delete cascade,
  email text not null,
  is_admin boolean not null default false,
  created_at timestamptz not null default now()
);

alter table perfiles enable row level security;

-- Función helper reutilizada por el resto de policies de todo el proyecto.
-- Debe existir ANTES de cualquier policy que la referencie (create policy
-- valida la expresión contra el catálogo al crearla, no solo al ejecutarla).
-- SECURITY DEFINER + search_path fijo: necesita leer "perfiles" sin quedar
-- atrapada por su propia RLS (evita recursión) y sin exponerse a
-- search_path hijacking.
create or replace function es_admin()
returns boolean
language sql
security definer
set search_path = public
stable
as $$
  select coalesce(
    (select is_admin from perfiles where id = auth.uid()),
    false
  );
$$;

-- Cada quien puede leer su propio perfil (lo necesita RolesService para
-- decidir si mostrar el panel admin).
create policy "perfiles_select_propio"
  on perfiles for select
  to authenticated
  using (id = auth.uid());

-- Un admin existente puede promover/degradar a otros desde el propio panel
-- (aunque en Fase 1 esto se hace a mano por SQL, se deja la policy lista).
create policy "perfiles_admin_actualiza"
  on perfiles for update
  to authenticated
  using (es_admin())
  with check (es_admin());

-- Crea automáticamente la fila de perfiles cuando alguien se crea como
-- usuario de Auth (is_admin arranca en false; se activa a mano vía
-- 0010_seed_admin.sql o desde el panel una vez haya al menos un admin).
create or replace function handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into public.perfiles (id, email)
  values (new.id, new.email)
  on conflict (id) do nothing;
  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function handle_new_user();
