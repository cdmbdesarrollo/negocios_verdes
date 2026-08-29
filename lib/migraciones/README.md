# Migraciones SQL

Historial de migraciones aplicadas **a mano** en el editor SQL del panel web de
Supabase (Dashboard → SQL Editor). No hay Supabase CLI en el flujo de trabajo de
este proyecto — estos archivos son documentación del orden en que se aplicó cada
cambio, no un runner automático. **No borrar** archivos ya aplicados, aunque una
migración posterior los modifique: son el historial real de lo que existe hoy en
la base de datos.

Aplicar en orden, de menor a mayor número, la primera vez que se monta el proyecto
en un Supabase nuevo:

1. `0001_extensiones_y_funciones.sql`
2. `0002_perfiles_y_roles.sql`
3. `0003_categorias_subcategorias.sql`
4. `0004_negocios.sql`
5. `0005_negocio_fotos_y_join.sql`
6. `0006_admin_logs.sql`
7. `0007_rpc_guardar_negocio.sql`
8. `0008_storage_bucket_negocios.sql`
9. `0009_seed_categorias_subcategorias.sql`
10. `0010_seed_admin.sql` — **requiere un paso manual antes** (crear el usuario
    desde Authentication → Add user en el Dashboard). Ver el comentario dentro
    del archivo.
11. `0011_sitio_configuracion_y_banners.sql` — logo y banners del carrusel de
    inicio administrables desde `/admin/apariencia` (proyectos ya montados
    antes de que existiera este archivo solo necesitan correr este, no hay
    que repetir el resto).
12. `0012_logos_footer_institucional.sql` — columnas para los sellos de
    Colombia y GOV.CO del pie de página (Negocios Verdes es un micrositio
    de la Sede Electrónica de la CDMB).
13. `0013_sello_colombia_potencia.sql` — columna para el tercer sello del
    pie de página, "Colombia Potencia de la Vida", a la derecha del sello
    de Colombia.
14. `0014_iconos_imagen_categorias.sql` — columnas para subir un ícono de
    imagen (PNG/SVG) por categoría oficial y subcategoría, alternativa al
    emoji de texto que ya existía.
15. `0015_negocios_multi_categoria.sql` — un negocio puede pertenecer hasta
    a 3 categorías oficiales (antes solo a una). Reemplaza la firma de
    `guardar_negocio` (`p_categoria_oficial_id` uuid → `p_categoria_oficial_ids`
    uuid[]) — **hay que correr esta migración ANTES de desplegar el código
    que la usa**, o el buscador público completo (no solo el admin) deja de
    cargar negocios, porque el SELECT público ya pediría el embed de
    `negocios_categorias`, que no existiría todavía.
16. `0016_actualizacion_taxonomia_pnnv_2022_2030.sql` — **reemplazo
    completo** de categorías/subcategorías (investigación propia, ver 0009)
    por la taxonomía oficial del Plan Nacional de Negocios Verdes
    2022-2030: 3 categorías, 12 subcategorías, y un nivel nuevo,
    `actividades_productivas` (29 filas), verificado contra los diagramas
    oficiales del documento (no solo el texto). Borra los negocios
    existentes (eran de prueba, confirmado con el usuario) y toda la
    taxonomía vieja — no es incremental, no hay mapeo 2014→2022. Agrega
    `p_actividad_ids` a `guardar_negocio` — **correr ANTES de desplegar**,
    mismo motivo que 0015.
17. `0017_iconos_actividades_productivas.sql` — el insert de
    actividades_productivas en 0016 se quedó sin columna `icono` (a
    diferencia de categorías/subcategorías, que sí la trajeron). Solo un
    `update` por slug, sin cambios de estructura — se puede correr en
    cualquier momento, no hace falta coordinarla con un deploy.
18. `0018_sello_marca_negocios_verdes.sql` — columna `negocios.sello_marca`
    (booleana, independiente de `nivel_desarrollo`): un negocio puede ser
    verificado o ancla Y tener el Sello Marca de Negocios Verdes a la vez,
    no es un cuarto nivel excluyente. Agrega `p_sello_marca` a
    `guardar_negocio` — **correr ANTES de desplegar**, mismo motivo que
    0015/0016.
19. `0019_aval_confianza_negocios_verdes.sql` — columna
    `negocios.aval_confianza` (booleana, independiente de
    `nivel_desarrollo`, mismo patrón que `sello_marca`): CDMB usa este
    término en sus propios comunicados de prensa para el reconocimiento
    base, no confirmado todavía si es sinónimo exacto de "Verificado" — se
    deja como campo aparte a propósito, más fácil de borrar después si
    resulta redundante que deshacer un cambio al enum central. Agrega
    `p_aval_confianza` a `guardar_negocio` — **correr ANTES de
    desplegar**, mismo motivo que 0015/0016/0018.
20. `0020_avalado_y_emprendimiento_verde.sql` — de otra sesión de Claude
    Code (corrida en producción el 25 de agosto): reemplaza
    `nivel_desarrollo` por `avalado`/`emprendimiento_verde` booleanos, con
    `emprendimiento_verde` admin-only (nunca público). **Corregido por
    0022** (ver abajo): CDMB confirmó directamente que las 3 categorías
    (Emprendimiento Verde / Sello Marca / Avalado) son públicas por igual y
    que `aval_confianza` no debía existir — no es un error de esta
    migración, es una decisión posterior de CDMB.
21. `0021_veredas.sql` — catálogo editable de veredas (`veredas`, con
    `negocios.vereda_id` opcional), a diferencia de los 13 municipios que
    siguen fijos en `lib/catalogos.dart`. Mismo patrón RLS que
    categorías/subcategorías/actividades (select público sin restricción,
    admin CRUD completo).
22. `0022_ficha_ampliada_negocios.sql` — CDMB entregó su base de datos real
    (304 negocios, 73 columnas) y Negocios Verdes pasa de vitrina liviana a
    sistema de información. Corrige 0020 según lo que CDMB confirmó
    directamente (captura del filtro real de su base: "EMPRENDIMIENTO
    VERDE / NEGOCIO VERDE - SELLO MARCA / NEGOCIO VERDE AVALADO", sin
    "Aval de Confianza"): `emprendimiento_verde` pasa a público y
    filtrable igual que los otros 2, y se borra `aval_confianza` (0019) —
    no es una categoría real. Las 3 quedan como booleanos independientes
    (`emprendimiento_verde`/`sello_marca`/`avalado`, los datos reales
    muestran negocios con más de uno a la vez, ej. Aval Y Sello Marca
    juntos). Agrega ~45 columnas de seguimiento interno CDMB (permisos,
    DOFA, puntajes por año en tabla aparte `negocio_puntajes`, etc.) —
    **admin-only**, salvo `vereda_id`, `representante_legal` y `producto`,
    las únicas 3 que se suman a lo público (`nit`/`naturaleza_juridica`
    quedan admin-only a propósito: el NIT de una persona Natural suele ser
    su cédula, un dato personal sensible). Relaja
    `whatsapp`/`descripcion_corta`/`descripcion` a NOT NULL opcional (se
    completan después). Reemplaza la firma de `guardar_negocio` que dejó
    0020 (el `drop function` usa esa firma exacta, verificada por lectura
    directa contra la base real, no adivinada) y agrega dos RPCs nuevas
    (`guardar_ficha_tecnica_negocio`, `guardar_puntaje_negocio`) — **correr
    ANTES de desplegar**, mismo motivo que 0015/0016/0018/0019/0020. Ver
    también `lib/services/negocio_service.dart`: el SELECT del buscador
    público dejó de usar `*` y pasó a una lista explícita de columnas, para
    que las admin-only ni siquiera viajen en la respuesta a un visitante
    anónimo.
23. `0023_foto_portada_opcional.sql` — quita el CHECK
    `negocios_publicado_necesita_foto` (0004): la foto de portada deja de
    ser obligatoria para publicar. Con los 295 negocios reales que carga
    0025 y ninguno con foto todavía, exigirla los habría dejado a todos
    sin poder activarse. Mientras no tenga foto, la ficha pública/tarjetas
    muestran el logo de Negocios Verdes en su lugar (ver
    `assets/images/iconografia/logo_negocios_verdes.png`). **Correr ANTES
    de 0025** — si no, el insert de los negocios `activo = true` falla
    contra este mismo CHECK.
24. `0024_este_norte_ubicacion.sql` — columnas `negocios.este`/`negocios.norte`
    (texto, admin-only): las coordenadas tal cual las escribe CDMB, no solo
    ya convertidas a `latitud`/`longitud` (que siguen siendo las que de
    verdad usa el mapa — `cota_msnm` ya existía desde 0022). El admin
    puede escribirlas o corregirlas desde el formulario y pedirle que
    calcule el punto del mapa a partir de ahí; agrega `p_este`/`p_norte`
    a `guardar_ficha_tecnica_negocio` **como parámetros nuevos al final,
    con default `null`** — a diferencia de los cambios de firma anteriores,
    esto no rompe la firma existente ante Postgres, así que no hace falta
    un `drop function` explícito. **Correr ANTES de 0025** (usa estas
    columnas).
25. `0025_datos_cdmb_negocios_verdes_01.sql` … `_10.sql` — **generado**, no
    escrito a mano: script en `lib/migraciones/generar_0025.py` que lee el
    Excel real de CDMB (`BASE_ACTUALIZADA_NV_ka.xlsx`) y produce estos 10
    archivos (partido en varios porque el editor SQL del dashboard de
    Supabase truncó el archivo único de ~1 MB a mitad de una línea —
    limitación del editor web, no un error de sintaxis). Cargan entre
    todos 295 de los 304 negocios reales (borra el único negocio de prueba
    que había en producción), las veredas encontradas, y las
    categorías/subcategorías/actividades de cada uno. `activo = true`
    directo para los 166 que CDMB ya marca `NOVEDAD = 'ACTIVO'` (posible
    recién con 0023, que quita la exigencia de foto); `whatsapp` se llena
    con el mismo número de `telefono` (casi todos son celular, no fijo),
    normalizado a `57` + 10 dígitos cuando el formato lo permite. Cada
    archivo es ~120 KB, su propia transacción (`begin`/`commit`), y trae
    el mismo preámbulo idempotente al principio (`where not exists`/`on
    conflict do nothing`) — **correr los 10, en cualquier orden**, y
    repetir uno no duplica nada porque cada `insert into negocios` sin
    `ON CONFLICT` queda protegido por el `begin`/`commit` de su propio
    archivo (si algo falla a mitad, ese archivo entero se revierte solo,
    sin dejar filas a medias). Ningún dato se inventa: lo que el Excel no
    trae queda `null` (o, solo para categoría oficial —campo
    obligatorio—, en la categoría-comodín "Pendiente de clasificar" creada
    en el primer archivo). **Correr DESPUÉS de 0022/0023/0024** (usa
    columnas y el CHECK relajado de esas 3). Ver
    `reporte_import_negocios.txt` (generado junto con estos archivos) para
    la lista de los 8 negocios sin municipio en el Excel que quedaron
    fuera y necesitan completarse a mano, y de los ~89 que quedaron en
    "Pendiente de clasificar" para revisión manual desde
    `/admin/negocios`.

## Sobre trabajo concurrente de dos sesiones

Esta sesión y la que produjo 0020 trabajaron sobre el mismo problema
(reemplazar `nivel_desarrollo`) sin verse entre sí — la de 0020 ya estaba
en producción cuando esta empezó, sobre una copia local desactualizada. Se
detectó al intentar hacer push (permiso denegado + historial divergente) y
se resolvió leyendo el estado real de la base de datos en vivo (con la
`anon key`, de solo lectura) para que 0022 reemplace la función/columnas
que 0020 ya había dejado en producción, en vez de asumir el estado previo
a 0020. Antes de tocar el esquema de `negocios` en una sesión nueva,
conviene `git fetch`/mirar `origin/master` primero — no asumir que el
`HEAD` local sigue siendo lo último en producción.

Esa misma sesión de 0020 también dejó, en commits posteriores: los colores
verde/dorado de Sello Marca y (el ya retirado) Aval de Confianza, y el
importador/exportador CSV de `/admin/negocios/importar` (`negocios_csv.dart`,
pensado para altas futuras en lote — no se usó para la carga inicial de
los 295 negocios reales, esa fue 0023). Se fusionó vía `git merge`: el
importador se actualizó para llamar a `NegocioService.guardar()` con la
firma nueva (agrega `vereda_id`/`representante_legal`/`producto`/`nit`/
`naturaleza_juridica`, todos opcionales — un CSV viejo sin esas columnas
sigue funcionando).
