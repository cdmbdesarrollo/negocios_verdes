-- 0001_extensiones_y_funciones.sql
-- Extensiones y funciones compartidas por el resto de migraciones.

create extension if not exists pgcrypto;
create extension if not exists unaccent;

-- unaccent() no está marcada IMMUTABLE, así que no se puede usar directo
-- dentro de una columna "generated always as (...) stored" (busqueda tsvector
-- en 0004_negocios.sql exige una expresión inmutable). Esta envoltura sí lo es.
create or replace function immutable_unaccent(text)
returns text
language sql
immutable
strict
as $$
  select unaccent('unaccent', $1)
$$;

-- Trigger genérico para mantener updated_at en cualquier tabla que lo tenga.
create or replace function set_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;
