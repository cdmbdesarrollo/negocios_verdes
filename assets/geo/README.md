# assets/geo

## municipios_cdmb.geojson

Límites de los **13 municipios de la jurisdicción de la CDMB** (Bucaramanga,
Floridablanca, Girón, Piedecuesta, Lebrija, Rionegro, El Playón, California,
Charta, Matanza, Suratá, Tona, Vetas), para las capas del **geovisor**
(`lib/pages/geovisor/geovisor_page.dart`).

- **Fuente:** OpenStreetMap, vía la API de Nominatim
  (`search?...&polygon_geojson=1`), un municipio por consulta.
- **Simplificación:** Douglas-Peucker con tolerancia ~0,0018° (≈ 200 m) y
  coordenadas redondeadas a 5 decimales. Alcanza para dibujar los límites a
  zoom de departamento/ciudad; **no** es cartografía oficial ni sirve para
  cálculos de área/linderos.
- **Tamaño:** ~22 KB. `FeatureCollection` de 13 `Polygon`, cada uno con
  `properties.nombre` y `properties.osm_id`.
- **Licencia:** © OpenStreetMap contributors, ODbL 1.0
  (https://osm.org/copyright).

### Regenerar

El script está en el scratchpad de la sesión que lo creó
(`gen_municipios.py`): descarga los 13, simplifica y sobrescribe este
archivo. Si algún día CDMB consigue el shapefile oficial del MGN del DANE,
reemplazar este archivo por esa versión (mismo formato: `nombre` en
`properties`).
