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

Regenerar: ver el final de este README.

> **Todas las capas de contexto se filtran a la jurisdicción real:** solo se
> conservan las features que intersectan alguno de los 13 municipios (no basta
> con caer en el bbox rectangular). El filtro es `_toca_jurisdiccion()` en el
> generador, usando `municipios_cdmb.geojson` como máscara.

## areas_protegidas_cdmb.geojson  — **EXTERNA (RUNAP)**

**~16 áreas protegidas** que tocan la jurisdicción, del **RUNAP** (Registro
Único Nacional de Áreas Protegidas): PNR Páramo de Santurbán, PNR Bosques
Andinos Húmedos El Rasgón, PNR Cerro la Judía, PNR Bosques de Misiguay, DRMI
Bucaramanga, DCS Umpalá–Cañón del Chicamocha, y los PNR de la CAR vecina
(CORPONOR) y el DRMI Yariguíes (CAS) que rozan el borde.

- **Fuente:** ArcGIS FeatureServer de Parques Nacionales
  (`mapas.parquesnacionales.gov.co/arcgis/rest/services/pnn/runap/FeatureServer/0`).
- **Tamaño:** ~95 KB. `properties`: `nombre`, `tipo` (categoría RUNAP),
  `fuente` (`RUNAP`), `condicion` (REGISTRADA / INSCRITA / CONSTRUCCION),
  `administra` (`CDMB` / `CAS` / `CORPONOR` / `PNN`), `url` (ficha en
  runap.parquesnacionales.gov.co), `hectareas`.

## paramos_cdmb.geojson  — **EXTERNA (MADS)**

**Páramos delimitados** que tocan la jurisdicción (2): complejo
**Jurisdicciones – Santurbán – Berlín** (Res. 2090 de 2014) y **Almorzadero**
(Res. 152 de 2018). Los fragmentos de Yariguíes quedaban en el bbox pero
fuera de los 13 municipios → el filtro los descarta.

- **Fuente:** Feature Service público de **Datos Abiertos MADS** (Ministerio
  de Ambiente y Desarrollo Sostenible) en ArcGIS Online:
  `services6.arcgis.com/hxAwRYAu9QHliJ8T/arcgis/rest/services/Páramos_Delimitados/FeatureServer/0`.
- **Tamaño:** ~75 KB. `properties`: `nombre`, `tipo` (`páramo`), `fuente`
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

## aicas_cdmb.geojson  — **EXTERNA (Instituto Humboldt)**

**Áreas de Importancia para la Conservación de las Aves (AICA)** que tocan
la jurisdicción (3): **Serranía de Yariguíes** (CO073), **Cerro La Judía**
(CO171, en Floridablanca/Piedecuesta) y **Bosques secos del valle del río
Chicamocha** (CO074). Relevante para el aviturismo, uno de los segmentos
fuertes de negocios verdes en Santander.

- **Fuente:** capa `AICAS_20240315` del org de Datos Abiertos del MADS en
  ArcGIS Online (`services6.arcgis.com/hxAwRYAu9QHliJ8T`). El programa AICA
  lo coordina el **Instituto Humboldt** (con Asociación Calidris / BirdLife).
- **Tamaño:** ~7 KB. `properties`: `nombre`, `tipo` (`aica`), `fuente`
  (`Humboldt`), `codigo` (código BirdLife).
- Capa **opt-in**.

## bosque_seco_cdmb.geojson  — **EXTERNA (MADS)**

Ecosistema estratégico **Bosque Seco Tropical** (fragmento del cañón del
Chicamocha–Sogamoso que entra en Girón, Piedecuesta, Rionegro y Lebrija).
Base para negocios verdes de zona seca: aviturismo, apicultura, productos de
sábila/cactáceas, restauración.

- **Fuente:** `Ecosistemas_Estratégicos_Bosque_Seco_Tropical` del org de
  Datos Abiertos del MADS (`services6.arcgis.com/hxAwRYAu9QHliJ8T`).
- **Recorte + simplificación:** clip al bbox CDMB + Douglas-Peucker
  (`maxAllowableOffset` del servidor no aplica en esta capa). ~86 KB.
- `properties`: `nombre`, `tipo` (`bosque-seco`), `fuente` (`MADS`),
  `region`.
- Capa **opt-in**.

## hidrografia_cdmb.geojson  — **EXTERNA (IDEAM)**

Hidrografía del **IDEAM** (cartografía básica IGAC 1:100.000), solo lo que
toca la jurisdicción (~79 features):
- **Ríos** — los anchos como polígono (drenaje doble: Lebrija, Chicamocha,
  Sogamoso, Sucio) **más** los ríos con nombre que solo existen como línea
  (drenaje sencillo): Río de Oro, Suratá, Tona, Frío, Charta, Vetas, Manco,
  Negro, Umpalá, Cáchira, Salamaga, Jordán…
- **Lagunas, ciénagas y embalses**.
- **NO** se traen las quebradas sin nombre (miles — el mapa base de OSM ya
  las muestra).

- **Fuente:** ArcGIS MapServer del IDEAM
  (`dhime.ideam.gov.co/server/rest/services/Cartografia_Basica/Hidrografia/MapServer`,
  capas 0 / 1 / 2 / 3 / 4).
- **Tamaño:** ~90 KB. `properties`: `nombre`, `tipo`
  (`río` / `laguna` / `ciénaga` / `embalse`), `fuente` (`IDEAM`). Geometría
  mixta: polígonos y líneas.
- Capa **opt-in**.

## subzonas_cdmb.geojson  — **EXTERNA (IDEAM)**

**Subzonas hidrográficas** (SZH homologadas 2024) que tocan la jurisdicción
(~5): Río Lebrija, Río Chicamocha, Río Sogamoso, Río Chítaga, Río Zulia.
Encaja con el eje del proyecto ADEI-22 (unidades hidrográficas).

- **Fuente:** Feature Service público
  `services.arcgis.com/wLfHepIACaM0pwj9/.../SUBZONAS_HIDROGRAFICAS_HOM_2024/FeatureServer/0`
  (IDEAM). Clip al bbox + Douglas-Peucker (es contexto, no linderos).
- **Tamaño:** ~14 KB. `properties`: `nombre`, `tipo`
  (`subzona-hidrografica`), `fuente` (`IDEAM`), `codigo` (COD_SZH).
- Capa **opt-in**, se dibuja solo el contorno.

### Regenerar

**`gen_capas_externas.py`** (en esta carpeta) genera **todas** las capas de
contexto: áreas protegidas (RUNAP), páramos + bosque seco (MADS), veredas
(DANE / espejo Esri Colombia), AICAS (Humboldt), hidrografía + subzonas
(IDEAM). `python assets/geo/gen_capas_externas.py`.

Pipeline por capa: descarga por ArcGIS REST (`f=geojson`, paginado) →
`_clip_bbox` (Sutherland-Hodgman, solo polígonos) → `_simplify_geom`
(Douglas-Peucker, descarta anillos minúsculos) → `_toca_jurisdiccion`
(descarta lo que no intersecta ninguno de los 13 municipios) → redondeo a
5 decimales.

Bounding box común: `-73.95,6.6,-72.65,7.95`. Retiró a `gen_oficial.py`
(RUNAP + IDEAM) y consolidó todo aquí.

**Regla:** las capas propias del **GeoServer de la CDMB** (POMCAS, uso del
suelo, amenazas locales, cartografía 25k, DEM) NO se consumen en vivo — es
infraestructura inestable. Si alguna hace falta, se pide el export
(shapefile / GeoPackage) y se hace un snapshot local, igual que estas.

### municipios_cdmb.geojson — regenerar

Sigue en el scratchpad de la sesión que lo creó (`gen_municipios.py`, desde
OSM/Nominatim). Si CDMB consigue el shapefile oficial del MGN del DANE,
reemplazar por esa versión (mismo formato: `nombre` en `properties`).

## Otras fuentes que valdría sumar (mismo patrón)

- **Frontera agrícola nacional (UPRA)** — para negocios agro. Su servicio
  (`geoservicios.upra.gov.co/.../ordenamiento_productivo/frontera_agricola`)
  estaba caído (`service not started`); sumar con `gen_capas_externas.py`
  cuando responda.
- **Coberturas de la tierra / Corine Land Cover 2018 (MADS `Cobertura_2018`)**
  — contexto de bosque/ecosistema; capa pesada, exige DP agresivo.
- **Capa Nacional de Humedales (MADS)** — filtrar por tamaño.
- **Amenaza por movimientos en masa (SGC, `srvags.sgc.gov.co`)** — riesgo.
- **colombiaenmapas.gov.co** — visor/geoservicios de la ICDE (IGAC, DANE…).
