-- 0013_sello_colombia_potencia.sql
-- Tercer sello institucional del pie de página: "Colombia Potencia de la
-- Vida" (marca país vigente del Gobierno Nacional), que va justo a la
-- derecha del sello de Colombia — mismo patrón que 0012 (solo la columna;
-- el archivo real lo sube el admin desde /admin/apariencia, no se inventa
-- ni se hotlinkea aquí).

alter table configuracion_sitio
  add column if not exists logo_potencia_url text,
  add column if not exists logo_potencia_path text;
