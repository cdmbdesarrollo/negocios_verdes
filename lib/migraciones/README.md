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
    0026 y ninguno con foto todavía, exigirla los habría dejado a todos
    sin poder activarse. Mientras no tenga foto, la ficha pública/tarjetas
    muestran el logo de Negocios Verdes en su lugar (ver
    `assets/images/iconografia/logo_negocios_verdes.png`). **Correr ANTES
    de 0026** — si no, el insert de los negocios `activo = true` falla
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
    un `drop function` explícito. **Correr ANTES de 0026** (usa estas
    columnas).
25. `0025_ficha_tecnica_catalogos.sql` — dos correcciones sobre feedback
    directo del admin en vivo. (1) Borra 12 columnas de `negocios`
    agregadas en 0022 que resultaron ser lectura de columnas **ocultas**
    del Excel de CDMB — confirmado con `openpyxl`
    (`column_dimensions[...].hidden`), no adivinado: `tiempo_constitucion`,
    `codigo_marca`, `fortalecimiento_tecnico/academico/financiero`,
    `internacionalizacion` (distinta de `exportacion`, que sí es visible),
    `certificaciones`, `posicionamiento_marca`,
    `debilidades_ambiental/social/financiera`, `beneficios_ventanilla`.
    (2) Crea `opciones_campo`, catálogo genérico (una tabla sirve para
    ~25 campos, no una tabla por campo) que reemplaza el texto libre en
    los campos categóricos de la ficha técnica (permisos SI/NO/PENDIENTE/
    N-A y similares, más `responsable_cdmb`/`delegado` — mismo problema,
    mismo catálogo) — semilla con las opciones reales encontradas
    analizando el Excel (no inventadas), más una RPC
    `guardar_opcion_campo` para que el admin agregue una opción nueva sin
    salir del formulario. `novedad` gana un CHECK de exactamente 4
    valores (`ACTIVO`/`INACTIVO`/`RETIRADO`/`SUSPENDIDO`). Reemplaza la
    firma de `guardar_ficha_tecnica_negocio` (pierde los 12 parámetros de
    las columnas borradas) — **correr ANTES de desplegar**, mismo motivo
    que las anteriores.
26. `0026_datos_cdmb_negocios_verdes_01.sql` … `_17.sql` — **generado**, no
    escrito a mano: script en `lib/migraciones/generar_0026.py` que lee el
    Excel real de CDMB (`BASE_ACTUALIZADA_NV_ka.xlsx`) y produce estos 17
    archivos (partidos porque el editor SQL del dashboard de Supabase
    truncó el archivo único de ~1 MB a mitad de una línea — limitación
    del editor web, no un error de sintaxis). **UPSERT por `nombre`, no
    INSERT ciego**: una corrida parcial de una versión vieja de este
    mismo script (antes de las correcciones de esta sesión) ya había
    dejado los 295 negocios reales cargados en producción con
    `activo = false` para todos — confirmado por el usuario
    directamente contra la base (`select count(*), novedad, activo from
    negocios group by novedad, activo` sumó exactamente 295). Pedido
    explícito: "agrupen todo sin eliminar nada" — cada negocio hace
    `update ... where nombre = X` primero (refresca whatsapp, este/norte,
    novedad ya unificado, activo, categorías, etc. sobre el que ya
    existía) y el `insert` que sigue solo entra por un
    `where not exists (...)` si de verdad es nuevo; las tablas puente
    (categorías/subcategorías/actividades) se borran y reinsertan
    apuntando al `id` que ya tenía cada negocio, nunca a uno nuevo. Corre
    igual de bien contra una base vacía o ya poblada, y repetir un
    archivo no duplica nada. Cargan entre todos 295 de los 304 negocios
    reales (borra el único negocio de prueba que había en producción),
    las veredas encontradas, y las opciones reales de cada campo
    categórico (para `opciones_campo`, ver 0025). `activo = true`
    directo para los 166 que CDMB ya marca `NOVEDAD = 'ACTIVO'` (posible
    recién con 0023, que quita la exigencia de foto); `whatsapp` se llena
    con el mismo número de `telefono` (casi todos son celular, no fijo),
    normalizado a `57` + 10 dígitos cuando el formato lo permite.
    `novedad` se estandariza a los 4 valores del CHECK de 0025
    ("RETIRADO"/"ACTIVO (RETIRADO)"/"ACTIVO (RETIRADO) P" → `RETIRADO`,
    "ACTIVO (SUSPENDIDO)" → `SUSPENDIDO`, pedido explícito — ninguna de
    esas variantes es `ACTIVO` a secas, así que esto no cambia qué se
    publica). Las 3 categorías de reconocimiento
    (`emprendimiento_verde`/`sello_marca`/`avalado`) quedan con al menos
    una en `true` siempre — CDMB confirmó que todo negocio real de su
    base tiene alguna de las 3, así que los 59 casos sin señal explícita
    de AVAL/SELLO MARCA/NV-EMP caen por defecto en `emprendimiento_verde`
    (la categoría base del programa, ningún negocio real llega a Sello
    Marca o Avalado sin pasar por ahí primero). `colidx()` (el buscador de
    columnas por nombre) pasó a exigir coincidencia exacta antes que por
    substring — el Excel tiene dos pares de encabezados donde uno contiene
    al otro como texto ("ICA (REGISTRO...)" aparecía después de
    "NATURAL - JURÍDICA" en la búsqueda por substring porque "jurídica"
    contiene "ica"; "INTERNACIONALIZACIÓN" pisaba a "EXPORTACIÓN -
    INTERNACIONALIZACIÓN (ACTUALMENTE)") — confirmado que los 73
    encabezados del Excel se leen completos, ninguno se pierde ni se cruza
    con otro. Cada archivo es ~120 KB, su propia transacción
    (`begin`/`commit`), y trae el mismo preámbulo idempotente al principio
    — **correr todos, en cualquier orden**, y repetir uno no duplica nada
    (el upsert por nombre de cada negocio es idempotente por diseño, no
    solo por el `begin`/`commit` de su archivo — aunque ese sigue
    garantizando que si algo falla a mitad, ese archivo entero se
    revierte solo, sin dejar filas a medias). Ningún
    dato se inventa: lo que el Excel no trae queda `null` (o, solo para
    categoría oficial —campo obligatorio—, en la categoría-comodín
    "Pendiente de clasificar" creada en el primer archivo). **Correr
    DESPUÉS de 0022/0023/0024/0025** (usa columnas, catálogo y el CHECK
    relajado de esas 4). Ver `reporte_import_negocios.txt` (generado
    junto con estos archivos) para la lista de los 8 negocios sin
    municipio en el Excel que quedaron fuera y necesitan completarse a
    mano, y de los ~89 que quedaron en "Pendiente de clasificar" para
    revisión manual desde `/admin/negocios`.
27. `0027_eliminar_puntaje_negocio.sql` — RPC `eliminar_puntaje_negocio`
    (mismo patrón que `guardar_puntaje_negocio`: SECURITY DEFINER +
    chequeo `es_admin()` interno) para poder quitar desde el formulario un
    año de puntaje cargado por error. Sin dependencias, correr en cualquier
    momento.
28. `0028_telefono_secundario.sql` — columna `negocios.telefono_secundario`
    (segundo número de contacto) y firma nueva de la RPC `guardar_negocio`
    (agrega `p_telefono_secundario` al final). Borra las versiones previas
    de la función y recrea una sola, igual que hizo 0025 con
    `guardar_ficha_tecnica_negocio`. El formulario reparte lo escrito entre
    WhatsApp (celular con `57` adelante), teléfono fijo y secundario.
    En este mismo commit se quitó la UI de importar CSV
    (`/admin/negocios/importar`) — la lógica de `negocios_csv.dart` y su
    test siguen; el exportar CSV ahora respeta los filtros de la lista.
29. `0029_personas_responsable_delegado_representante.sql` — convierte
    `negocios.responsable_cdmb` / `.delegado` / `.representante_legal` (texto
    libre) en tres bases de personas (`responsables_cdmb`, `delegados`,
    `representantes`: nombres, apellidos, documento, teléfono, correo) con
    asignación por negocio EN TABLAS PUENTE CON HISTORIAL
    (`negocio_responsable` / `negocio_delegado` / `negocio_representante`,
    `vigente_hasta` null = actual; `negocio_representante` además lleva `nit`
    y `naturaleza_juridica` por negocio — una persona puede representar
    varios). RLS solo-admin, RPCs `guardar_*` / `asignar_*_negocio` /
    `quitar_*_negocio` (SECURITY DEFINER + `es_admin()`). Backfill idempotente
    desde los textos actuales. Las columnas de texto en `negocios` NO se
    borran: quedan como copia denormalizada del valor vigente (las RPC de
    asignación la mantienen sincronizada) para no tocar el `select` público
    ni el modelo `Negocio`. Correr después de que exista `negocios` y
    `es_admin`; sin más dependencias de orden.
30. `0030_personas_vistas_y_eliminar.sql` — para la pantalla
    `/admin/personas`: 3 vistas `v_*` (`security_invoker`) con el conteo de
    negocios (total e vigentes) por persona, y RPCs `eliminar_responsable` /
    `eliminar_delegado` / `eliminar_representante` que solo borran si la
    persona nunca se asignó (si tiene historial se rechaza con mensaje claro).
    Depende de 0029.
31. `0031_personas_mas_campos.sql` — más columnas en las 3 bases de personas:
    todas ganan `tipo_documento` y `direccion`; responsables/delegados ganan
    `cargo`; representantes ganan `naturaleza_juridica` (Natural/Jurídica) y
    `razon_social` (el "nombre" que se muestra y se copia a
    `negocios.representante_legal` es la razón social cuando es jurídica, si
    no nombres+apellidos — función `_display_representante`). Las 3 RPC
    `guardar_*` cambian de firma (se borran y recrean, patrón de 0028);
    `asignar_representante_negocio` se recrea para usar `_display_representante`.
    Backfill: la naturaleza del representante se copia de sus negocios cuando
    todos coinciden. Depende de 0029/0030.
    **OJO:** las vistas `v_*` NO recogen las columnas nuevas solas (Postgres
    congela `select *`) — hay que recrearlas, ver 0033.
32. `0032_personas_municipio.sql` — columna `municipio` en las 3 bases de
    personas y `p_municipio` al final de las 3 RPC `guardar_*` (se borran y
    recrean otra vez, patrón de 0028/0031). Para la lista tipo trámites CDMB
    de `/admin/personas` (tabla con filtro por municipio). Depende de 0031.
    Mismo tema de las vistas que 0031 → ver 0033.
33. `0033_refrescar_vistas_personas.sql` — **hotfix**: recrea las 3 vistas
    `v_*` para que incluyan las columnas que 0031 y 0032 agregaron a las
    tablas base (`select *` no se re-expande solo). Sin esto, `/admin/personas`
    y el formulario de edición de negocios fallan con
    `column v_responsables_cdmb.tipo_documento does not exist`. Correr después
    de 0032.
34. `0034_representantes_nit_desde_negocios.sql` — el NIT/cédula de cada
    representante ya vivía en `negocio_representante.nit` (0029) pero
    `representantes.documento` estaba vacío. Backfill: para los 255
    representantes con un NIT único entre sus negocios se copia a `documento`
    (+ `tipo_documento` según naturaleza). La vista `v_representantes` gana
    `nits_negocios` (todos los NITs de sus negocios) para que el buscador
    filtre por NIT aunque `documento` siga vacío. Depende de 0031/0033.
35. `0035_representante_razon_social_por_negocio.sql` — la razón social es
    **del negocio**, no de la persona: columna `negocio_representante.razon_social`
    (backfill = nombre del negocio cuando la naturaleza es Jurídica).
    `representantes.razon_social` (0031) queda como cache del valor único.
    `asignar_representante_negocio` gana `p_razon_social` (firma nueva,
    se borra y recrea). `v_representantes` gana `razones_negocios` para el
    buscador. `negocios.representante_legal` (público) sigue siendo el
    nombre de la persona, no la razón social. Depende de 0034.
36. `0036_razon_social_es_el_negocio.sql` — **corrección de modelo**: la
    RAZÓN SOCIAL es el nombre del negocio verde (verificado: coincide en el
    100% de los vínculos jurídicos), no un dato de la persona. El
    REPRESENTANTE LEGAL es siempre la persona (`representantes.nombres`).
    Se eliminan `representantes.razon_social` (0031) y
    `negocio_representante.razon_social` (0035). `_display_representante`
    pasa a devolver solo el nombre de la persona (era el bug: prefería la
    razón social). `guardar_representante` y `asignar_representante_negocio`
    pierden `p_razon_social`. `v_representantes` cambia `razones_negocios`
    por `negocios_nombres`. Backfill de `negocios.representante_legal` con el
    nombre de la persona. Además: `search_path` fijo en `generar_slug_unico`,
    `immutable_unaccent` y `set_updated_at` (advisor). Depende de 0035.
37. `0037_fix_coordenadas_invertidas.sql` — **corrección de datos**: 5
    negocios tenían lat/lng invertidas o basura (heredado de la carga
    0026); el promedio de puntos mandaba el mapa del buscador a media
    hora de Venezuela. Se recalculan 4 desde los campos `este`/`norte`
    (DMS, que sí quedaron bien) y el 5º (basura irrecuperable) se deja sin
    coordenadas. Defensa a futuro en Dart: `Negocio.tieneUbicacion` exige
    que lat/lng caigan en la región CDMB, y el mapa encuadra con
    `CameraFit` sobre los puntos reales en vez de promediarlos.
38. `0038_indices_fk_personas.sql` — índice en `negocio_delegado.delegado_id`
    y `negocio_responsable.responsable_id` (el advisor los marcaba;
    `negocio_representante` ya lo tenía desde 0029).
39. `0039_roles_super_admin_y_usuarios.sql` — dos niveles de cuenta:
    **súper administrador** (`perfiles.es_super_admin`) y **administrador**
    normal. `perfiles` gana `es_super_admin` / `activo` / `nombre`;
    `es_admin()` pasa a `is_admin OR es_super_admin` y exige `activo`;
    nueva `es_super_admin()`. Semilla: luislozanocamacho@gmail.com queda
    como súper admin. Se cierra un hueco viejo (la policy de UPDATE de
    `perfiles` era `es_admin()` — cualquier admin podía promoverse) y las
    policies de `categorias_oficiales` / `subcategorias` /
    `actividades_productivas` / `configuracion_sitio` / `banners` + el
    bucket `sitio-assets` suben de `es_admin()` a `es_super_admin()`. La
    creación de la cuenta de Auth NO la hace esta migración: va por la
    Edge Function `admin-usuarios` (ver
    `supabase/functions/admin-usuarios/`, se despliega aparte con el MCP
    de Supabase o `supabase functions deploy`, no desde el GitHub Actions
    de Vercel). El cambio de contraseña propio de cada admin ("Mi cuenta",
    `/admin/cuenta`) es client-side (`supabase.auth.updateUser`), sin SQL.
    Sin dependencias de orden más allá de 0002.

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
