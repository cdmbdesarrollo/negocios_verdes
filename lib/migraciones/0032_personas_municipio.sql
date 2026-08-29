-- 0032_personas_municipio.sql
--
-- Las 3 bases de personas (ver 0029/0031) ganan `municipio` — para
-- parecerse a la lista de solicitantes de trámites CDMB, que filtra y
-- muestra por municipio. Las 3 RPC `guardar_*` suman `p_municipio` al final
-- (se borran y recrean, patrón de 0028/0031). Las vistas `v_*` (0030) usan
-- `select *`, así que recogen la columna sola. Idempotente. Depende de 0031.

alter table responsables_cdmb add column if not exists municipio text;
alter table delegados add column if not exists municipio text;
alter table representantes add column if not exists municipio text;

do $$
declare
  r record;
begin
  for r in
    select p.oid::regprocedure as firma
    from pg_proc p join pg_namespace n on n.oid = p.pronamespace
    where n.nspname = 'public'
      and p.proname in ('guardar_responsable','guardar_delegado','guardar_representante')
  loop
    execute format('drop function %s', r.firma);
  end loop;
end $$;

create function guardar_responsable(
  p_id uuid, p_nombres text, p_apellidos text,
  p_documento text, p_tipo_documento text,
  p_telefono text, p_correo text, p_cargo text, p_direccion text,
  p_municipio text
) returns uuid
language plpgsql security definer set search_path = public as $$
declare v_id uuid := coalesce(p_id, gen_random_uuid());
begin
  if not es_admin() then
    raise exception 'No autorizado: se requiere una cuenta administradora de CDMB.';
  end if;
  if p_nombres is null or trim(p_nombres) = '' then
    raise exception 'El nombre es obligatorio.';
  end if;
  insert into responsables_cdmb
    (id, nombres, apellidos, documento, tipo_documento, telefono, correo,
     cargo, direccion, municipio)
  values (v_id, trim(p_nombres), p_apellidos, p_documento, p_tipo_documento,
          p_telefono, p_correo, p_cargo, p_direccion, p_municipio)
  on conflict (id) do update set
    nombres = excluded.nombres, apellidos = excluded.apellidos,
    documento = excluded.documento, tipo_documento = excluded.tipo_documento,
    telefono = excluded.telefono, correo = excluded.correo,
    cargo = excluded.cargo, direccion = excluded.direccion,
    municipio = excluded.municipio, updated_at = now();
  return v_id;
end $$;

create function guardar_delegado(
  p_id uuid, p_nombres text, p_apellidos text,
  p_documento text, p_tipo_documento text,
  p_telefono text, p_correo text, p_cargo text, p_direccion text,
  p_municipio text
) returns uuid
language plpgsql security definer set search_path = public as $$
declare v_id uuid := coalesce(p_id, gen_random_uuid());
begin
  if not es_admin() then
    raise exception 'No autorizado: se requiere una cuenta administradora de CDMB.';
  end if;
  if p_nombres is null or trim(p_nombres) = '' then
    raise exception 'El nombre es obligatorio.';
  end if;
  insert into delegados
    (id, nombres, apellidos, documento, tipo_documento, telefono, correo,
     cargo, direccion, municipio)
  values (v_id, trim(p_nombres), p_apellidos, p_documento, p_tipo_documento,
          p_telefono, p_correo, p_cargo, p_direccion, p_municipio)
  on conflict (id) do update set
    nombres = excluded.nombres, apellidos = excluded.apellidos,
    documento = excluded.documento, tipo_documento = excluded.tipo_documento,
    telefono = excluded.telefono, correo = excluded.correo,
    cargo = excluded.cargo, direccion = excluded.direccion,
    municipio = excluded.municipio, updated_at = now();
  return v_id;
end $$;

create function guardar_representante(
  p_id uuid, p_nombres text, p_apellidos text,
  p_razon_social text, p_naturaleza_juridica text,
  p_documento text, p_tipo_documento text,
  p_telefono text, p_correo text, p_direccion text,
  p_municipio text
) returns uuid
language plpgsql security definer set search_path = public as $$
declare v_id uuid := coalesce(p_id, gen_random_uuid());
begin
  if not es_admin() then
    raise exception 'No autorizado: se requiere una cuenta administradora de CDMB.';
  end if;
  if (p_nombres is null or trim(p_nombres) = '')
     and (p_razon_social is null or trim(p_razon_social) = '') then
    raise exception 'Pon el nombre (persona natural) o la razón social (jurídica).';
  end if;
  insert into representantes
    (id, nombres, apellidos, razon_social, naturaleza_juridica,
     documento, tipo_documento, telefono, correo, direccion, municipio)
  values (v_id, nullif(trim(coalesce(p_nombres,'')), ''), p_apellidos,
          nullif(trim(coalesce(p_razon_social,'')), ''), p_naturaleza_juridica,
          p_documento, p_tipo_documento, p_telefono, p_correo, p_direccion,
          p_municipio)
  on conflict (id) do update set
    nombres = excluded.nombres, apellidos = excluded.apellidos,
    razon_social = excluded.razon_social,
    naturaleza_juridica = excluded.naturaleza_juridica,
    documento = excluded.documento, tipo_documento = excluded.tipo_documento,
    telefono = excluded.telefono, correo = excluded.correo,
    direccion = excluded.direccion, municipio = excluded.municipio,
    updated_at = now();
  return v_id;
end $$;

do $$
declare f text;
begin
  foreach f in array array[
    'guardar_responsable(uuid,text,text,text,text,text,text,text,text,text)',
    'guardar_delegado(uuid,text,text,text,text,text,text,text,text,text)',
    'guardar_representante(uuid,text,text,text,text,text,text,text,text,text,text)'
  ]
  loop
    execute format('revoke all on function %s from public', f);
    execute format('grant execute on function %s to authenticated', f);
  end loop;
end $$;
