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

## paramos_cdmb.geojson  — **EXTERNA (MADS)**

**Páramos delimitados** de la jurisdicción CDMB (7 polígonos): complejo
**Jurisdicciones – Santurbán – Berlín** (Res. 2090 de 2014), **Almorzadero**
(Res. 152 de 2018) y parte de **Yariguíes** (Res. 1554 de 2016).

- **Fuente:** Feature Service público de **Datos Abiertos MADS** (Ministerio
  de Ambiente y Desarrollo Sostenible) en ArcGIS Online:
  `services6.arcgis.com/hxAwRYAu9QHliJ8T/arcgis/rest/services/Páramos_Delimitados/FeatureServer/0`.
- **Tamaño:** ~80 KB. `properties`: `nombre`, `tipo` (`páramo`), `fuente`
  (`MADS`), `acto` (acto administrativo), `escala`, `hectareas`.
- Capa **opt-in**, se carga solo al encenderla.

## veredas_cdmb.geojson  — **EXTERNA (DANE)**

**Veredas** de los 13 municipios de la jurisdicción CDMB (~384 polígonos).
Resuelve el pendiente histórico: hasta ahora solo teníamos el *nombre* de la
vereda (en el panel del geovisor), no el límite.

- **Fuente:** capa veredal de referencia del **DANE**. Su servicio propio
  (`geoportal.dane.gov.co`) **no entrega geometría** por consulta, así que se
  usa el espejo público **"Veredas de Colombia"** de Esri Colombia Community
  Maps (mismos campos y códigos DIVIPOLA `DPTOMPIO`, cada vereda con su
  `FUENTE` = POT municipal; vigencia 2016):
  `ags.esri.co/arcgis/rest/services/DatosAbiertos/VEREDAS_2016/MapServer/0`.
- **Filtro:** `DPTOMPIO IN (…)` con los 13 códigos DIVIPOLA (68001, 68132,
  68169, 68255, 68276, 68307, 68406, 68444, 68547, 68615, 68780, 68820,
  68867).
- **Tamaño:** ~290 KB. `properties`: `nombre`, `tipo` (`vereda`), `fuente`
  (`DANE`), `municipio`, `codigo` (DIVIPOLA vereda), `hectareas`.
- Capa **opt-in**, se carga solo al encenderla.

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

### Regenerar

- **`gen_capas_externas.py`** (en esta carpeta) — páramos (MADS) + veredas
  (DANE / espejo Esri Colombia). `python assets/geo/gen_capas_externas.py`:
  trae por ArcGIS REST (`f=geojson`, `maxAllowableOffset` para simplificar
  en el servidor, coords a 5 decimales), recorta al bbox y sobreescribe los
  dos assets.
- `gen_oficial.py` — áreas protegidas (RUNAP) + hidrografía (IDEAM). Vive en
  el scratchpad de la sesión que lo creó (pendiente de traerlo al repo).

Bounding box común: `-73.95,6.6,-72.65,7.95`.

**Regla:** las capas propias del **GeoServer de la CDMB** (POMCAS, uso del
suelo, amenazas locales, cartografía 25k, DEM) NO se consumen en vivo — es
infraestructura inestable. Si alguna hace falta, se pide el export
(shapefile / GeoPackage) y se hace un snapshot local, igual que estas.

## Otras fuentes que valdría sumar (mismo patrón de snapshot)

- **Frontera agrícola nacional (UPRA)** — para negocios agro. Su servicio
  (`geoservicios.upra.gov.co`) estaba caído al implementar esto; sumar con
  `gen_capas_externas.py` cuando responda.
- **Coberturas de la tierra / Corine Land Cover (IDEAM)** —
  `visualizador.ideam.gov.co/gisserver/rest/services`.
- **colombiaenmapas.gov.co** — visor/geoservicios de la ICDE (IGAC, DANE…).
