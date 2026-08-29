-- 0029_personas_responsable_delegado_representante.sql
--
-- Convierte tres campos de texto libre de `negocios` en bases de datos de
-- personas, buscables y editables desde el formulario admin, CON TRAZA:
--
--   negocios.responsable_cdmb   → tabla responsables_cdmb  (personal CDMB)
--   negocios.delegado           → tabla delegados          (delegado del negocio)
--   negocios.representante_legal → tabla representantes     (+ NIT y naturaleza
--                                  jurídica POR NEGOCIO: una misma persona puede
--                                  representar varios negocios, cada uno con su
--                                  NIT o como persona natural)
--
-- La asignación de cada uno a un negocio vive en una tabla puente con
-- historial: nunca se borra una fila, se cierra (`vigente_hasta`) y se abre
-- otra. Así "cambiar de responsable en cualquier momento" queda registrado
-- (quién, cuándo, y una nota opcional).
--
-- Las columnas de texto en `negocios` NO se eliminan: se mantienen como
-- copia denormalizada del valor VIGENTE (nombre completo / nit / naturaleza)
-- para que el `select` público y todo el código que ya lee
-- `negocio.representanteLegal` sigan funcionando sin joins. Las RPC de
-- asignación mantienen esa copia sincronizada.
--
-- Idempotente: `if not exists`, inserts de backfill con guarda, y
-- `create or replace` en las funciones. Sin dependencias de orden fuera de
-- que `negocios` exista.

-- ===================================================================
-- 1. Tablas maestras de personas
-- ===================================================================
create table if not exists responsables_cdmb (
  id uuid primary key default gen_random_uuid(),
  nombres text not null,
  apellidos text,
  documento text,
  telefono text,
  correo text,
  activo boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz
);

create table if not exists delegados (
  id uuid primary key default gen_random_uuid(),
  nombres text not null,
  apellidos text,
  documento text,
  telefono text,
  correo text,
  activo boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz
);

create table if not exists representantes (
  id uuid primary key default gen_random_uuid(),
  nombres text not null,
  apellidos text,
  documento text,
  telefono text,
  correo text,
  created_at timestamptz not null default now(),
  updated_at timestamptz
);

-- ===================================================================
-- 2. Asignaciones con historial (traza). vigente_hasta null = actual.
-- ===================================================================
create table if not exists negocio_responsable (
  id uuid primary key default gen_random_uuid(),
  negocio_id uuid not null references negocios(id) on delete cascade,
  responsable_id uuid not null references responsables_cdmb(id) on delete restrict,
  vigente_desde timestamptz not null default now(),
  vigente_hasta timestamptz,
  asignado_por uuid,
  nota text,
  created_at timestamptz not null default now()
);
create unique index if not exists negocio_responsable_vigente_uniq
  on negocio_responsable (negocio_id) where vigente_hasta is null;
create index if not exists negocio_responsable_negocio_idx
  on negocio_responsable (negocio_id);

create table if not exists negocio_delegado (
  id uuid primary key default gen_random_uuid(),
  negocio_id uuid not null references negocios(id) on delete cascade,
  delegado_id uuid not null references delegados(id) on delete restrict,
  vigente_desde timestamptz not null default now(),
  vigente_hasta timestamptz,
  asignado_por uuid,
  nota text,
  created_at timestamptz not null default now()
);
create unique index if not exists negocio_delegado_vigente_uniq
  on negocio_delegado (negocio_id) where vigente_hasta is null;
create index if not exists negocio_delegado_negocio_idx
  on negocio_delegado (negocio_id);

create table if not exists negocio_representante (
  id uuid primary key default gen_random_uuid(),
  negocio_id uuid not null references negocios(id) on delete cascade,
  representante_id uuid not null references representantes(id) on delete restrict,
  nit text,
  naturaleza_juridica text,
  vigente_desde timestamptz not null default now(),
  vigente_hasta timestamptz,
  asignado_por uuid,
  nota text,
  created_at timestamptz not null default now()
);
create unique index if not exists negocio_representante_vigente_uniq
  on negocio_representante (negocio_id) where vigente_hasta is null;
create index if not exists negocio_representante_negocio_idx
  on negocio_representante (negocio_id);
create index if not exists negocio_representante_persona_idx
  on negocio_representante (representante_id);

-- ===================================================================
-- 3. RLS — internas, solo admin. Nunca expuestas a anon.
-- ===================================================================
do $$
declare
  t text;
begin
  foreach t in array array[
    'responsables_cdmb','delegados','representantes',
    'negocio_responsable','negocio_delegado','negocio_representante'
  ]
  loop
    execute format('alter table %I enable row level security', t);
    execute format('revoke all on table %I from anon', t);
    execute format('grant select on table %I to authenticated', t);
    -- create policy no acepta "if not exists" en PG15 → drop + create.
    execute format('drop policy if exists admin_todo on %I', t);
    execute format(
      'create policy admin_todo on %I for all to authenticated '
      'using (es_admin()) with check (es_admin())', t);
  end loop;
end $$;

-- ===================================================================
-- 4. Backfill desde los textos actuales de negocios
-- ===================================================================
-- Nota: separar "nombres" de "apellidos" en un texto libre no es fiable
-- ("MARÍA ISABEL ZAPATA" ¿dónde corta?), así que todo el nombre va a
-- `nombres` y `apellidos` queda null — el admin lo separa al editar.
-- Igual que el resto del proyecto: no se inventa un dato a medias.

insert into responsables_cdmb (nombres)
select distinct trim(n.responsable_cdmb)
from negocios n
where n.responsable_cdmb is not null and trim(n.responsable_cdmb) <> ''
  and not exists (
    select 1 from responsables_cdmb r where r.nombres = trim(n.responsable_cdmb)
  );

insert into negocio_responsable (negocio_id, responsable_id, vigente_desde)
select n.id, r.id, coalesce(n.created_at, now())
from negocios n
join responsables_cdmb r on r.nombres = trim(n.responsable_cdmb)
where n.responsable_cdmb is not null and trim(n.responsable_cdmb) <> ''
  and not exists (
    select 1 from negocio_responsable nr
    where nr.negocio_id = n.id and nr.vigente_hasta is null
  );

insert into delegados (nombres)
select distinct trim(n.delegado)
from negocios n
where n.delegado is not null and trim(n.delegado) <> ''
  and not exists (select 1 from delegados d where d.nombres = trim(n.delegado));

insert into negocio_delegado (negocio_id, delegado_id, vigente_desde)
select n.id, d.id, coalesce(n.created_at, now())
from negocios n
join delegados d on d.nombres = trim(n.delegado)
where n.delegado is not null and trim(n.delegado) <> ''
  and not exists (
    select 1 from negocio_delegado nd
    where nd.negocio_id = n.id and nd.vigente_hasta is null
  );

insert into representantes (nombres)
select distinct trim(n.representante_legal)
from negocios n
where n.representante_legal is not null and trim(n.representante_legal) <> ''
  and not exists (
    select 1 from representantes p where p.nombres = trim(n.representante_legal)
  );

insert into negocio_representante
  (negocio_id, representante_id, nit, naturaleza_juridica, vigente_desde)
select n.id, p.id, n.nit, n.naturaleza_juridica, coalesce(n.created_at, now())
from negocios n
join representantes p on p.nombres = trim(n.representante_legal)
where n.representante_legal is not null and trim(n.representante_legal) <> ''
  and not exists (
    select 1 from negocio_representante nr
    where nr.negocio_id = n.id and nr.vigente_hasta is null
  );

-- ===================================================================
-- 5. RPC — upsert de cada persona (SECURITY DEFINER + es_admin interno)
-- ===================================================================
create or replace function guardar_responsable(
  p_id uuid, p_nombres text, p_apellidos text,
  p_documento text, p_telefono text, p_correo text
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
  insert into responsables_cdmb (id, nombres, apellidos, documento, telefono, correo)
  values (v_id, trim(p_nombres), p_apellidos, p_documento, p_telefono, p_correo)
  on conflict (id) do update set
    nombres = excluded.nombres, apellidos = excluded.apellidos,
    documento = excluded.documento, telefono = excluded.telefono,
    correo = excluded.correo, updated_at = now();
  return v_id;
end $$;

create or replace function guardar_delegado(
  p_id uuid, p_nombres text, p_apellidos text,
  p_documento text, p_telefono text, p_correo text
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
  insert into delegados (id, nombres, apellidos, documento, telefono, correo)
  values (v_id, trim(p_nombres), p_apellidos, p_documento, p_telefono, p_correo)
  on conflict (id) do update set
    nombres = excluded.nombres, apellidos = excluded.apellidos,
    documento = excluded.documento, telefono = excluded.telefono,
    correo = excluded.correo, updated_at = now();
  return v_id;
end $$;

create or replace function guardar_representante(
  p_id uuid, p_nombres text, p_apellidos text,
  p_documento text, p_telefono text, p_correo text
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
  insert into representantes (id, nombres, apellidos, documento, telefono, correo)
  values (v_id, trim(p_nombres), p_apellidos, p_documento, p_telefono, p_correo)
  on conflict (id) do update set
    nombres = excluded.nombres, apellidos = excluded.apellidos,
    documento = excluded.documento, telefono = excluded.telefono,
    correo = excluded.correo, updated_at = now();
  return v_id;
end $$;

-- ===================================================================
-- 6. RPC — asignar / quitar (cierra el vigente, abre el nuevo, sincroniza
--    la copia denormalizada en negocios, loguea en admin_logs)
-- ===================================================================
create or replace function _nombre_completo(p_nombres text, p_apellidos text)
returns text language sql immutable set search_path = public as $$
  select nullif(trim(coalesce(p_nombres,'') || ' ' || coalesce(p_apellidos,'')), '')
$$;

create or replace function asignar_responsable_negocio(
  p_negocio_id uuid, p_responsable_id uuid, p_nota text default null
) returns void
language plpgsql security definer set search_path = public as $$
begin
  if not es_admin() then
    raise exception 'No autorizado: se requiere una cuenta administradora de CDMB.';
  end if;
  if exists (
    select 1 from negocio_responsable
    where negocio_id = p_negocio_id and responsable_id = p_responsable_id
      and vigente_hasta is null
  ) then
    return;
  end if;
  update negocio_responsable set vigente_hasta = now()
  where negocio_id = p_negocio_id and vigente_hasta is null;
  insert into negocio_responsable (negocio_id, responsable_id, asignado_por, nota)
  values (p_negocio_id, p_responsable_id, auth.uid(), p_nota);
  update negocios set responsable_cdmb = (
    select _nombre_completo(nombres, apellidos)
    from responsables_cdmb where id = p_responsable_id
  ) where id = p_negocio_id;
  insert into admin_logs (admin_id, accion, entidad, entidad_id, detalle)
  values (auth.uid(), 'asignar_responsable', 'negocios', p_negocio_id,
          jsonb_build_object('responsable_id', p_responsable_id, 'nota', p_nota));
end $$;

create or replace function quitar_responsable_negocio(
  p_negocio_id uuid, p_nota text default null
) returns void
language plpgsql security definer set search_path = public as $$
begin
  if not es_admin() then
    raise exception 'No autorizado: se requiere una cuenta administradora de CDMB.';
  end if;
  update negocio_responsable set vigente_hasta = now()
  where negocio_id = p_negocio_id and vigente_hasta is null;
  update negocios set responsable_cdmb = null where id = p_negocio_id;
  insert into admin_logs (admin_id, accion, entidad, entidad_id, detalle)
  values (auth.uid(), 'quitar_responsable', 'negocios', p_negocio_id,
          jsonb_build_object('nota', p_nota));
end $$;

create or replace function asignar_delegado_negocio(
  p_negocio_id uuid, p_delegado_id uuid, p_nota text default null
) returns void
language plpgsql security definer set search_path = public as $$
begin
  if not es_admin() then
    raise exception 'No autorizado: se requiere una cuenta administradora de CDMB.';
  end if;
  if exists (
    select 1 from negocio_delegado
    where negocio_id = p_negocio_id and delegado_id = p_delegado_id
      and vigente_hasta is null
  ) then
    return;
  end if;
  update negocio_delegado set vigente_hasta = now()
  where negocio_id = p_negocio_id and vigente_hasta is null;
  insert into negocio_delegado (negocio_id, delegado_id, asignado_por, nota)
  values (p_negocio_id, p_delegado_id, auth.uid(), p_nota);
  update negocios set delegado = (
    select _nombre_completo(nombres, apellidos)
    from delegados where id = p_delegado_id
  ) where id = p_negocio_id;
  insert into admin_logs (admin_id, accion, entidad, entidad_id, detalle)
  values (auth.uid(), 'asignar_delegado', 'negocios', p_negocio_id,
          jsonb_build_object('delegado_id', p_delegado_id, 'nota', p_nota));
end $$;

create or replace function quitar_delegado_negocio(
  p_negocio_id uuid, p_nota text default null
) returns void
language plpgsql security definer set search_path = public as $$
begin
  if not es_admin() then
    raise exception 'No autorizado: se requiere una cuenta administradora de CDMB.';
  end if;
  update negocio_delegado set vigente_hasta = now()
  where negocio_id = p_negocio_id and vigente_hasta is null;
  update negocios set delegado = null where id = p_negocio_id;
  insert into admin_logs (admin_id, accion, entidad, entidad_id, detalle)
  values (auth.uid(), 'quitar_delegado', 'negocios', p_negocio_id,
          jsonb_build_object('nota', p_nota));
end $$;

create or replace function asignar_representante_negocio(
  p_negocio_id uuid, p_representante_id uuid,
  p_nit text default null, p_naturaleza_juridica text default null,
  p_nota text default null
) returns void
language plpgsql security definer set search_path = public as $$
declare
  v_actual uuid;
  v_nit_actual text;
  v_nat_actual text;
begin
  if not es_admin() then
    raise exception 'No autorizado: se requiere una cuenta administradora de CDMB.';
  end if;
  select representante_id, nit, naturaleza_juridica
    into v_actual, v_nit_actual, v_nat_actual
  from negocio_representante
  where negocio_id = p_negocio_id and vigente_hasta is null;

  if v_actual is not distinct from p_representante_id
     and v_nit_actual is not distinct from p_nit
     and v_nat_actual is not distinct from p_naturaleza_juridica then
    return;
  end if;

  update negocio_representante set vigente_hasta = now()
  where negocio_id = p_negocio_id and vigente_hasta is null;
  insert into negocio_representante
    (negocio_id, representante_id, nit, naturaleza_juridica, asignado_por, nota)
  values (p_negocio_id, p_representante_id, p_nit, p_naturaleza_juridica,
          auth.uid(), p_nota);
  update negocios set
    representante_legal = (
      select _nombre_completo(nombres, apellidos)
      from representantes where id = p_representante_id
    ),
    nit = p_nit,
    naturaleza_juridica = p_naturaleza_juridica
  where id = p_negocio_id;
  insert into admin_logs (admin_id, accion, entidad, entidad_id, detalle)
  values (auth.uid(), 'asignar_representante', 'negocios', p_negocio_id,
          jsonb_build_object('representante_id', p_representante_id,
                             'nit', p_nit, 'naturaleza_juridica', p_naturaleza_juridica,
                             'nota', p_nota));
end $$;

create or replace function quitar_representante_negocio(
  p_negocio_id uuid, p_nota text default null
) returns void
language plpgsql security definer set search_path = public as $$
begin
  if not es_admin() then
    raise exception 'No autorizado: se requiere una cuenta administradora de CDMB.';
  end if;
  update negocio_representante set vigente_hasta = now()
  where negocio_id = p_negocio_id and vigente_hasta is null;
  update negocios set representante_legal = null, nit = null,
                      naturaleza_juridica = null
  where id = p_negocio_id;
  insert into admin_logs (admin_id, accion, entidad, entidad_id, detalle)
  values (auth.uid(), 'quitar_representante', 'negocios', p_negocio_id,
          jsonb_build_object('nota', p_nota));
end $$;

-- ===================================================================
-- 7. Grants — todo el mundo pierde execute, solo authenticated lo tiene
--    (el chequeo real es es_admin() dentro de cada función)
-- ===================================================================
do $$
declare
  f text;
begin
  foreach f in array array[
    'guardar_responsable(uuid,text,text,text,text,text)',
    'guardar_delegado(uuid,text,text,text,text,text)',
    'guardar_representante(uuid,text,text,text,text,text)',
    'asignar_responsable_negocio(uuid,uuid,text)',
    'quitar_responsable_negocio(uuid,text)',
    'asignar_delegado_negocio(uuid,uuid,text)',
    'quitar_delegado_negocio(uuid,text)',
    'asignar_representante_negocio(uuid,uuid,text,text,text)',
    'quitar_representante_negocio(uuid,text)'
  ]
  loop
    execute format('revoke all on function %s from public', f);
    execute format('grant execute on function %s to authenticated', f);
  end loop;
end $$;
