-- 0039_roles_super_admin_y_usuarios.sql
--
-- Dos niveles de cuenta administradora (antes había uno solo):
--
--   * SÚPER ADMINISTRADOR (`perfiles.es_super_admin = true`): puede todo,
--     incluido crear/desactivar otras cuentas administradoras y editar la
--     taxonomía (categorías, subcategorías, actividades productivas) y la
--     apariencia del sitio.
--   * ADMINISTRADOR normal (`perfiles.is_admin = true`, `es_super_admin`
--     falso): gestiona negocios, personas y ve la auditoría, pero NO entra
--     a categorías / subcategorías / actividades productivas / apariencia
--     (pedido explícito: "los usuarios nuevos administradores no podrán
--     ingresar a categorías, subcategorías, actividades productivas y
--     apariencia; a las demás sí").
--
-- El único súper admin de arranque es luislozanocamacho@gmail.com (el
-- mismo correo de 0010_seed_admin.sql). Desde /admin/usuarios ese usuario
-- crea los demás — la creación real de la cuenta de Auth pasa por la Edge
-- Function `admin-usuarios` (usa la service_role, que NUNCA puede vivir en
-- el cliente Flutter; ver supabase/functions/admin-usuarios/). Esta
-- migración solo prepara el esquema y las políticas.
--
-- El cambio de contraseña propio de cada admin (pantalla "Mi cuenta") no
-- necesita nada de SQL: el cliente llama a supabase.auth.updateUser() con
-- su propia sesión.
--
-- Sin dependencias de orden más allá de que existan `perfiles` y
-- `es_admin()` (0002). Idempotente en lo que se puede (add column if not
-- exists); las policies se recrean con drop + create.

-- ---------------------------------------------------------------------------
-- 1) Columnas nuevas en perfiles
-- ---------------------------------------------------------------------------
alter table perfiles add column if not exists es_super_admin boolean not null default false;
alter table perfiles add column if not exists activo boolean not null default true;
alter table perfiles add column if not exists nombre text;

comment on column perfiles.es_super_admin is
  'Súper administrador: además de todo lo de un admin normal, gestiona '
  'cuentas (/admin/usuarios) y la taxonomía + apariencia del sitio.';
comment on column perfiles.activo is
  'Cuenta deshabilitada sin borrarla. es_admin()/es_super_admin() '
  'devuelven false para un perfil con activo = false.';

-- ---------------------------------------------------------------------------
-- 2) es_admin() ahora cubre a los súper admin y respeta `activo`
--    Un súper admin es siempre admin, aunque a alguien se le olvide marcar
--    también is_admin. Y un perfil desactivado deja de ser admin al vuelo,
--    sin tener que tocar auth.users.
-- ---------------------------------------------------------------------------
create or replace function es_admin()
returns boolean
language sql
security definer
set search_path = public
stable
as $$
  select coalesce(
    (select (is_admin or es_super_admin) and activo
       from perfiles where id = auth.uid()),
    false
  );
$$;

-- Espejo de es_admin() para el nivel súper. Mismo motivo de SECURITY
-- DEFINER + search_path fijo que es_admin() (ver 0002): la usan las
-- policies de varias tablas y no puede quedar atrapada por la RLS de
-- perfiles.
create or replace function es_super_admin()
returns boolean
language sql
security definer
set search_path = public
stable
as $$
  select coalesce(
    (select es_super_admin and activo from perfiles where id = auth.uid()),
    false
  );
$$;

-- ---------------------------------------------------------------------------
-- 3) Semilla: promover al primer súper admin
--    (mismo correo que 0010; cámbialo si el primer súper admin es otro)
-- ---------------------------------------------------------------------------
update perfiles
set es_super_admin = true,
    is_admin = true,
    activo = true
where email = 'luislozanocamacho@gmail.com';

-- ---------------------------------------------------------------------------
-- 4) RLS de perfiles
--    Hoy la policy de UPDATE era `es_admin()` — cualquier admin podía
--    editar cualquier perfil (incluido promoverse a sí mismo). Se cierra:
--    solo un súper admin edita perfiles. Y un súper admin puede leer todos
--    los perfiles para la lista de /admin/usuarios.
--    (La Edge Function usa la service_role y salta la RLS de todas formas;
--    estas policies son para lo que sí pueda tocar el cliente.)
-- ---------------------------------------------------------------------------
drop policy if exists "perfiles_admin_actualiza" on perfiles;

drop policy if exists "perfiles_select_super" on perfiles;
create policy "perfiles_select_super"
  on perfiles for select
  to authenticated
  using (es_super_admin());

drop policy if exists "perfiles_update_super" on perfiles;
create policy "perfiles_update_super"
  on perfiles for update
  to authenticated
  using (es_super_admin())
  with check (es_super_admin());

-- `perfiles_select_propio` (0002) se queda: cada quien lee su propia fila,
-- que es lo que necesita RolesService para decidir qué menú mostrar.

-- ---------------------------------------------------------------------------
-- 5) Taxonomía y apariencia: pasan de es_admin() a es_super_admin()
--
--    categorias_oficiales / subcategorias / actividades_productivas /
--    configuracion_sitio / banners, más el bucket de Storage `sitio-assets`
--    (los íconos de categoría/subcategoría/actividad y los assets de
--    apariencia viven todos ahí — ningún flujo de admin normal escribe en
--    ese bucket, las fotos de negocio van a `negocios-fotos`).
--
--    Las tablas puente negocios_categorias / negocios_subcategorias /
--    negocios_actividades NO se tocan: un admin normal sigue asignando la
--    taxonomía existente a cada negocio, solo no puede crear/editar los
--    catálogos en sí.
-- ---------------------------------------------------------------------------
drop policy if exists "categorias_oficiales_admin_todo" on categorias_oficiales;
create policy "categorias_oficiales_admin_todo"
  on categorias_oficiales for all
  to authenticated
  using (es_super_admin())
  with check (es_super_admin());

drop policy if exists "subcategorias_admin_todo" on subcategorias;
create policy "subcategorias_admin_todo"
  on subcategorias for all
  to authenticated
  using (es_super_admin())
  with check (es_super_admin());

drop policy if exists "actividades_productivas_admin_todo" on actividades_productivas;
create policy "actividades_productivas_admin_todo"
  on actividades_productivas for all
  to authenticated
  using (es_super_admin())
  with check (es_super_admin());

drop policy if exists "configuracion_sitio_admin_todo" on configuracion_sitio;
create policy "configuracion_sitio_admin_todo"
  on configuracion_sitio for all
  to authenticated
  using (es_super_admin())
  with check (es_super_admin());

drop policy if exists "banners_admin_todo" on banners;
create policy "banners_admin_todo"
  on banners for all
  to authenticated
  using (es_super_admin())
  with check (es_super_admin());

drop policy if exists "sitio_assets_storage_admin_insert" on storage.objects;
create policy "sitio_assets_storage_admin_insert"
  on storage.objects for insert
  to authenticated
  with check (bucket_id = 'sitio-assets' and es_super_admin());

drop policy if exists "sitio_assets_storage_admin_update" on storage.objects;
create policy "sitio_assets_storage_admin_update"
  on storage.objects for update
  to authenticated
  using (bucket_id = 'sitio-assets' and es_super_admin())
  with check (bucket_id = 'sitio-assets' and es_super_admin());

drop policy if exists "sitio_assets_storage_admin_delete" on storage.objects;
create policy "sitio_assets_storage_admin_delete"
  on storage.objects for delete
  to authenticated
  using (bucket_id = 'sitio-assets' and es_super_admin());

-- `sitio_assets_storage_select_publico` no se toca: el bucket es público
-- (los íconos y banners se ven sin login en el sitio).
