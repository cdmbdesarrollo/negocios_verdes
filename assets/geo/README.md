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

## areas_protegidas_cdmb.geojson

**31 áreas protegidas** de la región (Parque Natural Regional Páramo de
Santurbán, PNN Serranía de los Yariguíes, PNR Sisavita, PNR Bosques
Húmedos Andinos, Reserva Forestal Cerro de la Judía, ~24 Reservas
Naturales de la Sociedad Civil, etc.).

- **Fuente:** OpenStreetMap, vía Overpass API (`boundary=protected_area`,
  `leisure=nature_reserve`, `boundary=national_park`, con `name`).
- **Simplificación:** Douglas-Peucker ~180 m. **No es oficial** — la
  cobertura de OSM para reservas privadas es parcial y los linderos son
  aproximados. Para el mapa oficial, RUNAP (Registro Único Nacional de
  Áreas Protegidas) publica shapefiles.
- **Tamaño:** ~20 KB. `properties.nombre` y `properties.tipo`.

## hidrografia_cdmb.geojson

**~400 elementos**: ríos (`waterway=river`), quebradas con nombre
(`waterway=stream` + `name`) y cuerpos de agua (`natural=water` + `name`).

- **Fuente:** OpenStreetMap / Overpass. Simplificado ~130 m; se descartan
  los tramos < ~1,5 km sin nombre.
- **Tamaño:** ~115 KB. Líneas con `properties.tipo` (`river`/`stream`),
  polígonos para los cuerpos de agua.
- Capa **opt-in** en el geovisor (se carga solo al encenderla).

### Regenerar (áreas + hidrografía)

`gen_capas.py` en el scratchpad de la sesión. Bounding box de la
jurisdicción: `6.79,-73.76,7.76,-72.81`.

## Veredas — pendiente

OSM **no tiene** los límites de las veredas de estos municipios (sí los
nombres, ya se usan en el panel del geovisor agrupando negocios). El
dato bueno lo tiene **CDMB** (cartografía veredal propia) o el **DANE**
(nivel "sector rural" del MGN). Cuando exista el shapefile, se convierte a
GeoJSON con `properties.nombre` + `properties.municipio` y se enchufa como
una capa más.
