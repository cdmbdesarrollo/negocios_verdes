-- 0041_nombre_productos.sql
--
-- Nombre propio para cada producto destacado (pedido explícito: en el
-- formulario decía "Producto 1/2/3" fijo y se necesita poder ponerle nombre
-- a cada uno). Se muestra en la ficha pública como título de la tarjeta,
-- entre la foto y la descripción. Opcional; un producto sigue necesitando
-- al menos algo (ahora nombre, foto o descripción). Depende de 0040.

alter table negocio_productos
  add column if not exists nombre text
  check (nombre is null or char_length(nombre) <= 80);

alter table negocio_productos drop constraint if exists negocio_productos_check;
alter table negocio_productos add constraint negocio_productos_check
  check (nombre is not null or foto_url is not null or descripcion is not null);
