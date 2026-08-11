-- 0010_seed_admin.sql
-- ESTA MIGRACIÓN NO ES AUTOCONTENIDA — requiere un paso manual PREVIO.
-- No se puede crear un usuario de Auth con contraseña real solo por SQL
-- (un INSERT crudo en auth.users no es seguro ni soportado).
--
-- Paso 1 (manual, en el Dashboard de Supabase):
--   Authentication → Users → Add user / Invite user
--   Crea el usuario con el correo del primer administrador CDMB. Esto
--   dispara el trigger on_auth_user_created (ver 0002) y crea
--   automáticamente su fila en "perfiles" con is_admin = false.
--
-- Paso 2 (este archivo): correr el UPDATE de abajo para promoverlo a admin.
-- Cambia el correo si vas a usar uno distinto para el primer administrador.

update perfiles
set is_admin = true
where email = 'luislozanocamacho@gmail.com';
