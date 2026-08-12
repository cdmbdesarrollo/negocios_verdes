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
