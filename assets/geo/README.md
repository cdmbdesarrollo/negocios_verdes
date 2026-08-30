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

## areas_protegidas_cdmb.geojson  — **OFICIAL (RUNAP)**

**~52 áreas protegidas** de la región tomadas del **RUNAP** (Registro Único
Nacional de Áreas Protegidas, de Parques Nacionales Naturales): PNR Páramo
de Santurbán, PNN Serranía de los Yariguíes, PNR Sisavita, PNR Bosques
Andinos Húmedos El Rasgón, PNR Cerro la Judía, PNR Bosques de Misiguay,
varios DRMI y DCS de la CDMB, y ~25 Reservas Naturales de la Sociedad
Civil.

- **Fuente:** ArcGIS FeatureServer de Parques Nacionales
  (`mapas.parquesnacionales.gov.co/arcgis/rest/services/pnn/runap/FeatureServer/0`),
  con `maxAllowableOffset` para simplificar en el servidor.
- **Tamaño:** ~80 KB. `properties`: `nombre`, `tipo` (categoría RUNAP),
  `condicion` (REGISTRADA / INSCRITA / CONSTRUCCION), `administra` (CDMB u
  otra CAR / PNN), `url` (ficha en runap.parquesnacionales.gov.co),
  `hectareas`.

## hidrografia_cdmb.geojson  — **OFICIAL (IDEAM)**

Hidrografía del **IDEAM** (cartografía básica IGAC 1:100.000):
- Drenajes Principales / Drenaje Doble (los ríos con ancho, ~45).
- Lagunas y ciénagas con nombre o de tamaño relevante (~215).
- **NO** se traen los "drenajes sencillos" (~9.000 en la zona — el mapa
  base de OSM ya muestra las quebradas menores).

- **Fuente:** ArcGIS MapServer del IDEAM
  (`dhime.ideam.gov.co/server/rest/services/Cartografia_Basica/Hidrografia/MapServer`,
  capas 1 / 4 / 2), simplificado en el servidor.
- **Tamaño:** ~275 KB. Todo polígonos; `properties.tipo` =
  `río` / `laguna` / `ciénaga`.
- Capa **opt-in** en el geovisor (se carga solo al encenderla).

### Regenerar (áreas + hidrografía)

`gen_oficial.py` en el scratchpad de la sesión (RUNAP + IDEAM por ArcGIS
REST). Bounding box: `-73.95,6.65,-72.65,7.9`. `gen_capas.py` era la
versión vieja desde OSM (obsoleta).

## Otras fuentes que valdría revisar

- **colombiaenmapas.gov.co** — visor/geoservicios de la ICDE (IGAC, DANE…).
- **Geoportal de la CDMB** — seguramente publica coberturas, POMCAS,
  amenazas, uso del suelo. Si aparece el WMS/REST, se enchufa igual.
- **DANE MGN** — municipios y **veredas** (nivel "sector rural").

## Veredas — pendiente

OSM **no tiene** los límites de las veredas de estos municipios (sí los
nombres, ya se usan en el panel del geovisor agrupando negocios). El
dato bueno lo tiene **CDMB** (cartografía veredal propia) o el **DANE**
(nivel "sector rural" del MGN). Cuando exista el shapefile, se convierte a
GeoJSON con `properties.nombre` + `properties.municipio` y se enchufa como
una capa más.
