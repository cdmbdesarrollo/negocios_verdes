-- 0014_iconos_imagen_categorias.sql
-- Categorías y subcategorías solo tenían un campo de texto para el ícono
-- (un emoji). Se agrega un ícono de IMAGEN opcional (PNG/SVG subido a
-- Storage desde el admin) que, cuando existe, se usa en vez del emoji —
-- para un set de íconos con estilo consistente en vez de emojis sueltos
-- del sistema operativo de cada admin. El campo de emoji se conserva como
-- alternativa liviana (sigue funcionando si nadie sube una imagen).

alter table categorias_oficiales
  add column if not exists icono_url text,
  add column if not exists icono_path text;

alter table subcategorias
  add column if not exists icono_url text,
  add column if not exists icono_path text;
