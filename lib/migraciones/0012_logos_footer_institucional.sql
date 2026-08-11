-- 0012_logos_footer_institucional.sql
-- Negocios Verdes es un micrositio de la Sede Electrónica de la CDMB
-- (micolombiadigital.gov.co) — el pie de página necesita los sellos de
-- Colombia y GOV.CO que trae esa página, administrables desde
-- /admin/apariencia igual que el logo principal. No se suben los archivos
-- reales aquí (son de la CDMB) — solo las columnas para guardar la
-- referencia una vez el admin los suba desde el panel.

alter table configuracion_sitio
  add column if not exists logo_govco_url text,
  add column if not exists logo_govco_path text,
  add column if not exists logo_colombia_url text,
  add column if not exists logo_colombia_path text;
