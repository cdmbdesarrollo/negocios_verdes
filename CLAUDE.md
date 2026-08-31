# Negocios Verdes CDMB — Contexto del proyecto para Claude Code

## Qué es esto

Directorio y buscador público de negocios verdes en los 13 municipios de la
jurisdicción de la CDMB (Corporación Autónoma Regional para la Defensa de la
**Meseta** de Bucaramanga). Flutter Web + Supabase. Hermano de HuellaQR
(`C:\Proyectos\mascotas_app`), calcado en convenciones pero proyecto e
infraestructura Supabase completamente separados.

## Alcance de Fase 1 (lo que existe hoy)

100% vitrina administrada por CDMB — **no hay cuentas públicas ni
postulación pública todavía**. Todas las cuentas son staff de CDMB (panel en
`/admin`) y hay dos niveles (ver `0039` y la sección de seguridad):
**administrador** normal (negocios, personas, auditoría) y **súper
administrador** (además: `/admin/usuarios`, categorías, subcategorías,
actividades productivas y apariencia). El público solo navega y busca, sin
login. No se vende nada desde la plataforma. Ver
`lib/migraciones/README.md` y el plan original para el detalle completo de
decisiones y lo que queda explícitamente para una Fase 2 (formulario público
de postulación con revisión interna, cuentas propias de negocios,
pre-renderizado SEO por negocio, etc.) — no construir esas cosas sin que se
pida explícitamente, ya se evaluaron y se decidió postergarlas.

## Stack

Flutter Web (CanvasKit) · `supabase_flutter` (DB + Storage) · `go_router` ·
`flutter_map` + `flutter_map_marker_cluster` + `latlong2` + `geolocator` ·
`image_picker` + `cached_network_image` · `intl` · `url_launcher` · `uuid` ·
sdk: `^3.12.0`. Sin Provider/Riverpod/Bloc — estado local en cada
`StatefulWidget`, a propósito (nunca hizo falta más).
Deploy: `git push` a `master` → GitHub Actions compila (`flutter analyze` +
`flutter build web --release`) y corre `vercel deploy --prod` directo — no
es el modelo git-connected de Vercel (Vercel no mira el repo, solo recibe
el build ya armado). `build.ps1` quedó solo para compilar local y revisar
el build de producción antes de un push, no toca git.

## Estructura

- `lib/` — código real de la app (única carpeta que compila).
- `lib/migraciones/` — historial de SQL aplicado a mano en el editor SQL del
  Dashboard de Supabase (sin CLI). Documentación, no se ejecutan solas. **NO
  borrar** archivos ya aplicados. Ver `lib/migraciones/README.md` para el
  orden y el paso manual necesario antes de `0010_seed_admin.sql`.
- `lib/catalogos.dart` — únicamente los 13 municipios fijos y los niveles de
  desarrollo (cosas que NUNCA se editan desde el admin). Categorías
  oficiales y subcategorías SÍ se editan desde `/admin/categorias` y
  `/admin/subcategorias` — viven en tablas de Supabase, no aquí.
- `lib/core/` — cruzado: `site_shell.dart` (navbar público) y
  `admin_shell_page.dart` (drawer admin) son DOS shells distintos, no uno
  solo como en HuellaQR. El pie de página (`widgets/pie_pagina.dart`) NO
  vive en `site_shell.dart` a propósito — cada página lo agrega como último
  elemento de su propio scroll (ver comentario en `site_shell.dart`).
- `supabase/functions/` — `admin-usuarios` (crear/activar/promover cuentas
  administradoras; usa la service_role, la única forma segura de crear un
  usuario de Auth). Se despliega aparte (MCP de Supabase o
  `supabase functions deploy`), NO desde el GitHub Actions de Vercel — ese
  solo compila y sube el build web. El día de la Fase 2 acá irá también el
  envío de correo de postulación pública.

## Convenciones de diseño

`NVColors` en `lib/theme/nv_colors.dart`. `primary` (verde) para
marca/navegación, `accent` (ámbar) SOLO para CTAs de conversión, `whatsapp`
(verde de marca) reservado únicamente al botón de WhatsApp — nunca se
reusa como acento genérico. Sin CTAs en mayúsculas sostenidas.

**Nunca usar `IntrinsicHeight` + `CrossAxisAlignment.stretch` envolviendo
algo con `InkWell`/gestos** — rompe el hit-testing en desktop (bug real ya
documentado en HuellaQR, evitado a propósito en `NegocioCard`).

## Seguridad — dónde vive de verdad

Los checks en Dart (`RolesService`, `exigirAdmin()` / `exigirSuperAdmin()`
en `admin_guard.dart`, el `redirect()` de sesión en `main.dart`) son solo
UX. El límite real son las políticas RLS de cada tabla (ver las
migraciones) y el re-chequeo de `es_admin()` **dentro** de la RPC
`guardar_negocio` — esa función es `SECURITY DEFINER` y bypassea RLS por
diseño, así que si algún día se toca esa RPC, el chequeo interno no es
opcional.

**Dos niveles de admin (0039):** `es_admin()` = `is_admin OR es_super_admin`
y exige `perfiles.activo`; `es_super_admin()` es su espejo para el nivel
súper. Súper admin: `/admin/usuarios` + taxonomía (`categorias_oficiales`,
`subcategorias`, `actividades_productivas`) + apariencia
(`configuracion_sitio`, `banners`, bucket `sitio-assets`) — todas esas
policies piden `es_super_admin()`. La creación de cuentas de Auth pasa por
la Edge Function `admin-usuarios` (service_role + re-chequeo de que quien
llama sea súper admin). El cambio de contraseña propio ("Mi cuenta") es
`supabase.auth.updateUser` con la sesión del propio usuario, sin backend.
Al crear un súper admin nuevo o tocar `es_admin()`/`es_super_admin()`,
recordar que un súper admin es siempre admin.

La RPC `guardar_negocio` recibe el id **siempre**, incluso al crear: el
formulario admin lo genera con `Uuid().v4()` en Dart antes de abrir el
editor de fotos (lo necesita para las rutas de Storage de portada/galería
desde el primer momento). La función decide crear vs. actualizar
comprobando si ese id ya existe, no si es nulo.

Un negocio puede tener hasta 3 categorías oficiales (`negocios_categorias`,
la primera elegida queda también como `negocios.categoria_oficial_id`, la
"principal" — la que usa todo lo que todavía filtra/muestra por una sola
categoría). Categoría → subcategoría → actividad productiva es una cascada
real de 3 niveles (cada una con FK a la anterior); `guardar_negocio`
sincroniza las 3 tablas puente (`negocios_categorias`,
`negocios_subcategorias`, `negocios_actividades`) con el mismo patrón de
borrar-todo-y-reinsertar en cada guardado.

## Antes de que la app funcione de verdad

1. Crear un proyecto nuevo en supabase.com (separado del de HuellaQR).
2. Aplicar `lib/migraciones/*.sql` en orden desde el editor SQL del
   Dashboard (ver `lib/migraciones/README.md`).
3. Crear el primer usuario admin desde Authentication → Add user, y correr
   el `UPDATE` de `0010_seed_admin.sql` (0039 lo deja además como súper
   admin). Desde ahí, los demás usuarios se crean desde `/admin/usuarios`.
4. Desplegar la Edge Function `admin-usuarios` (MCP de Supabase o
   `supabase functions deploy admin-usuarios`) — sin ella, `/admin/usuarios`
   no puede crear cuentas. Las env vars (`SUPABASE_URL`, `SUPABASE_ANON_KEY`,
   `SUPABASE_SERVICE_ROLE_KEY`) las inyecta el runtime, no hay que
   configurarlas.
5. Crear `env.local.ps1` en la raíz (NO se sube a git) con `SUPABASE_URL` y
   `SUPABASE_ANON_KEY` para poder correr `build.ps1` o el launch config de
   `.claude/launch.json` con `--dart-define`.
6. La taxonomía activa es la oficial del Plan Nacional de Negocios Verdes
   2022-2030 (`lib/migraciones/0016_actualizacion_taxonomia_pnnv_2022_2030.sql`):
   3 categorías, 12 subcategorías, 29 actividades productivas. Reemplazó
   por completo la semilla de investigación propia de
   `0009_seed_categorias_subcategorias.sql` (obsoleta — se conserva solo
   como historial, no se ejecuta ni se referencia). Editable desde
   `/admin/categorias`, `/admin/subcategorias` y `/admin/actividades` si
   CDMB necesita ajustarla.
7. Completar los datos reales de contacto de la Ventanilla de Negocios
   Verdes en `lib/pages/estaticas/contacto_page.dart` (se dejó honesto a
   propósito, sin inventar teléfono/dirección).

## Deuda técnica conocida / Fase 2 (no construir sin que se pida)

Sin tests todavía. Sin redimensionado/compresión automática de imágenes
(solo se valida tamaño máximo 1 MB y se rechaza HEIC/HEIF client-side, ver
`galeria_editor.dart`). Sin pre-renderizado SEO por negocio (solo meta tags
en tiempo de ejecución + defaults fuertes en `web/index.html`). Sin
`sitemap.xml` real todavía (`web/robots.txt` ya apunta a `/sitemap.xml` —
agregarlo una vez haya un dominio definitivo, con URLs absolutas). Sin
formulario público de postulación, sin cuentas propias de negocios. La
gestión de cuentas administradoras SÍ existe (`/admin/usuarios`, solo súper
admin, ver 0039) pero sin correo de invitación (no hay SMTP): al crear una
cuenta se muestra la contraseña una vez para entregarla en mano. Un súper
admin no puede resetear la contraseña de otro — cada quien la cambia en
"Mi cuenta"; si alguien se bloquea, se hace desde el Dashboard de Supabase.
