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
20. `0020_avalado_y_emprendimiento_verde.sql` — **borra el enum
    `nivel_desarrollo`** (en_verificacion/verificado/negocio_ancla, y su
    desplegable en el admin) y lo reemplaza por dos columnas booleanas
    independientes, mismo patrón que `sello_marca`/`aval_confianza`:
    `avalado` (reconocimiento público, "Negocio avalado por la CDMB",
    reemplaza a "Verificado"/"Negocio Ancla") y `emprendimiento_verde`
    (uso interno únicamente — negocios no avalados o en proceso; nunca se
    muestra en la ficha pública ni es filtrable en /buscar, a propósito).
    Hace backfill desde `nivel_desarrollo` antes de borrar la columna
    (verificado/negocio_ancla → avalado=true, en_verificacion →
    emprendimiento_verde=true). Reemplaza `p_nivel_desarrollo` por
    `p_avalado` + `p_emprendimiento_verde` en `guardar_negocio` —
    **correr ANTES de desplegar**, mismo motivo que 0015/0016/0018/0019.
