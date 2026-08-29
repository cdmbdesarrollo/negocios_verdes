-- 0037_fix_coordenadas_invertidas.sql
--
-- Corrección de datos (no de esquema). Cinco negocios tenían la latitud y
-- la longitud invertidas o con basura, heredado de la carga del Excel
-- (0026). El promedio de todos los puntos mandaba el mapa del buscador a
-- mitad de camino a Mérida (Venezuela) al "ver todos los negocios".
--
-- Fuente de verdad: los campos de texto `este` / `norte` (grados-minutos-
-- segundos) que sí quedaron bien en la carga. `este` = latitud, `norte` =
-- longitud (oeste, negativa).
--
--   GREEN TEAM INGENIERIA SAS (Rionegro)  7°36'58,23"  / 73°33'1,26"
--   ELIZA COSTURA CREATIVA (Girón)        7°0'32,064"   / 73°8'8,646"
--   EL PORVENIR CACAO (Lebrija)           7°11'58,92"   / 73°11'58,038"
--   ALL NATURAL (Bucaramanga)             7°04'31.936"  / 7°5'54.215"  (al norte le falta un dígito: era 73°)
--   HOTEL "LA MANSIÓN DEL MONO" (Piedecuesta)  este/norte = "11.11703"/"12.56671" -> basura irrecuperable
--
-- Los primeros 4 se recalculan; el hotel se deja sin coordenadas (mejor
-- sin pin que con un pin equivocado) para que CDMB lo recapture a mano.
--
-- Defensa a futuro (en Dart, no acá): `Negocio.tieneUbicacion` ahora exige
-- que lat/lng caigan dentro de la región de la CDMB, y el mapa del
-- buscador encuadra con `CameraFit` sobre los puntos reales en vez de
-- promediar coordenadas.

update negocios set latitud = 7.616175,  longitud = -73.55035
 where id = 'f1934b43-a2a2-4292-8943-0cf85ea0f015';  -- GREEN TEAM

update negocios set latitud = 7.0089067, longitud = -73.135735
 where id = '58aaee27-e84a-43ac-8202-5be1e4e49b65';  -- ELIZA

update negocios set latitud = 7.1997,    longitud = -73.199455
 where id = '9399ade1-1ccd-4c4c-9d1f-01425f532455';  -- EL PORVENIR

update negocios set latitud = 7.0755378, longitud = -73.098393
 where id = '57fe709f-bb6a-4527-94d0-373fbf51fe0e';  -- ALL NATURAL

update negocios set latitud = null,      longitud = null
 where id = '5870aa8f-d1c0-4d16-b0f4-55fa46b3ec8c';  -- HOTEL LA MANSIÓN
