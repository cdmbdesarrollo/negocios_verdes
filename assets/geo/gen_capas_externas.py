#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Genera los GeoJSON de capas EXTERNAS del geovisor de Negocios Verdes:

  - paramos_cdmb.geojson  -> Páramos delimitados (MADS)  -- FUENTE EXTERNA
  - veredas_cdmb.geojson   -> Veredas (DANE, espejo Esri Colombia) -- EXTERNA

Recorta a la jurisdicción CDMB (13 municipios de Santander), simplifica en el
servidor (maxAllowableOffset) y redondea coordenadas. Mismo patrón que
gen_oficial.py (RUNAP + IDEAM). No se ejecuta sola: correr a mano cuando la
fuente se actualice y sobreescribir los assets. Ver README.md.

    python assets/geo/gen_capas_externas.py
"""
import json, os, urllib.parse, urllib.request, io

# Este script vive en assets/geo/ y escribe los .geojson a su lado.
OUT_DIR = os.path.dirname(os.path.abspath(__file__))

# bbox jurisdicción CDMB (igual que gen_oficial.py) -> xmin,ymin,xmax,ymax
BBOX = "-73.95,6.6,-72.65,7.95"

# DIVIPOLA de los 13 municipios de la jurisdicción CDMB (verificado contra el
# MGN del DANE, 2024). Charta=68169, Matanza=68444, Suratá=68780, Vetas=68867.
MUNIS_CDMB = {
    "68001": "Bucaramanga", "68132": "California", "68169": "Charta",
    "68255": "El Playón",   "68276": "Floridablanca", "68307": "Girón",
    "68406": "Lebrija",     "68444": "Matanza",     "68547": "Piedecuesta",
    "68615": "Rionegro",    "68780": "Suratá",      "68820": "Tona",
    "68867": "Vetas",
}


def _get(url, params):
    q = urllib.parse.urlencode(params)
    req = urllib.request.Request(url + "?" + q, headers={
        "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) "
                      "AppleWebKit/537.36 (KHTML, like Gecko) "
                      "Chrome/124.0 Safari/537.36",
        "Accept": "application/json,*/*",
    })
    with urllib.request.urlopen(req, timeout=120) as r:
        return json.loads(r.read().decode("utf-8"))


def _round_ring(ring, nd=5):
    return [[round(x, nd), round(y, nd)] for x, y in ring]


def _round_geom(g, nd=5):
    t = g["type"]
    c = g["coordinates"]
    if t == "Polygon":
        g["coordinates"] = [_round_ring(r, nd) for r in c]
    elif t == "MultiPolygon":
        g["coordinates"] = [[_round_ring(r, nd) for r in poly] for poly in c]
    return g


def _titlecase(s):
    if not s:
        return s
    s = s.strip()
    # respeta preposiciones cortas
    low = {"de", "del", "la", "las", "los", "y", "el", "en"}
    out = []
    for i, w in enumerate(s.lower().split()):
        out.append(w if (i and w in low) else w.capitalize())
    return " ".join(out)


def _fetch_paged(url, where, extra):
    """Descarga todas las features (paginando) como GeoJSON."""
    PAGE = 1000
    feats, offset = [], 0
    while True:
        d = _get(url, {
            "where": where,
            "geometry": BBOX,
            "geometryType": "esriGeometryEnvelope",
            "inSR": "4326", "outSR": "4326",
            "spatialRel": "esriSpatialRelIntersects",
            "returnGeometry": "true",
            "f": "geojson",
            "resultOffset": offset,
            "resultRecordCount": PAGE,
            **extra,
        })
        if d.get("error"):
            raise RuntimeError(d["error"])
        got = d.get("features", [])
        feats.extend(got)
        if len(got) < PAGE or offset > 50000:
            return feats
        offset += len(got)


# --------------------------------------------------------------- PÁRAMOS (MADS)
def gen_paramos():
    url = ("https://services6.arcgis.com/hxAwRYAu9QHliJ8T/arcgis/rest/services/"
           "P%C3%A1ramos_Delimitados/FeatureServer/0/query")
    raw = _fetch_paged(url, "1=1", {
        "outFields": "nombre,escala,acto_admin,area_ha",
        "maxAllowableOffset": "0.0009",   # ~100 m
    })
    out = []
    for f in raw:
        if not f.get("geometry"):
            continue
        p = f.get("properties", {})
        nom = (p.get("nombre") or "").strip()
        nom = " ".join(nom.replace("- ", " - ").replace(" -", " - ").split())
        out.append({
            "type": "Feature",
            "properties": {
                "nombre": nom,
                "tipo": "páramo",
                "fuente": "MADS",
                "acto": (p.get("acto_admin") or "").strip(),
                "escala": (p.get("escala") or "").strip(),
                "hectareas": round(p.get("area_ha") or 0, 1),
            },
            "geometry": _round_geom(f["geometry"]),
        })
    _write("paramos_cdmb.geojson", "paramos_delimitados_cdmb", out)


# ---------------------------------------------------------------- VEREDAS (DANE)
def gen_veredas():
    # La capa veredal del DANE (geoportal.dane.gov.co) NO devuelve geometría por
    # query (solo atributos). Se usa el espejo público "Veredas de Colombia" de
    # Esri Colombia Community Maps, mismos campos y códigos DIVIPOLA (DPTOMPIO),
    # cada vereda con su FUENTE (POT municipal). Vigencia 2016.
    url = ("https://ags.esri.co/arcgis/rest/services/DatosAbiertos/"
           "VEREDAS_2016/MapServer/0/query")
    codes = "'" + "','".join(MUNIS_CDMB) + "'"
    raw = _fetch_paged(url, f"DPTOMPIO IN ({codes})", {
        "outFields": "NOMBRE_VER,NOMB_MPIO,DPTOMPIO,CODIGO_VER,AREA_HA,FUENTE",
        "maxAllowableOffset": "0.0007",   # ~75 m
    })
    out = []
    for f in raw:
        p = f.get("properties", {})
        code = str(p.get("DPTOMPIO") or "")
        if code not in MUNIS_CDMB or not f.get("geometry"):
            continue
        out.append({
            "type": "Feature",
            "properties": {
                "nombre": _titlecase(p.get("NOMBRE_VER") or ""),
                "tipo": "vereda",
                "fuente": "DANE",
                "municipio": MUNIS_CDMB[code],
                "codigo": str(p.get("CODIGO_VER") or ""),
                "hectareas": round(p.get("AREA_HA") or 0, 1),
            },
            "geometry": _round_geom(f["geometry"]),
        })
    out.sort(key=lambda x: (x["properties"]["municipio"], x["properties"]["nombre"]))
    _write("veredas_cdmb.geojson", "veredas_dane_cdmb", out)


def _write(fname, name, feats):
    fc = {"type": "FeatureCollection", "name": name, "features": feats}
    path = os.path.join(OUT_DIR, fname)
    with io.open(path, "w", encoding="utf-8") as fh:
        json.dump(fc, fh, ensure_ascii=False, separators=(",", ":"))
    kb = os.path.getsize(path) / 1024
    print(f"  {fname}: {len(feats)} features, {kb:.0f} KB")


if __name__ == "__main__":
    print("Paramos delimitados (MADS)...")
    gen_paramos()
    print("Veredas (DANE, via espejo Esri Colombia)...")
    gen_veredas()
    print("listo.")
