#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Genera los GeoJSON de capas de contexto EXTERNAS del geovisor:

  - paramos_cdmb.geojson       -> Páramos delimitados (MADS)
  - veredas_cdmb.geojson        -> Veredas (DANE, espejo Esri Colombia)
  - aicas_cdmb.geojson          -> Áreas de conservación de aves / AICA (Humboldt)
  - bosque_seco_cdmb.geojson    -> Bosque seco tropical (MADS)
  - reserva_ley2_cdmb.geojson   -> Reserva Forestal de Ley 2ª de 1959 (MADS)

Recorta a la jurisdicción CDMB (13 municipios de Santander): clip al bbox
(_clip_bbox) + simplificación (maxAllowableOffset del servidor y/o
Douglas-Peucker _simplify_geom) + coords a 5 decimales. No se ejecuta sola:
correr a mano cuando la fuente se actualice y sobreescribir los assets.
Ver README.md.

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


_XMIN, _YMIN, _XMAX, _YMAX = (float(v) for v in BBOX.split(","))


def _clip_ring(ring, edge):
    """Sutherland–Hodgman: recorta un anillo contra una recta del bbox.
    edge: ('xmin'|'xmax'|'ymin'|'ymax')."""
    def inside(p):
        if edge == "xmin": return p[0] >= _XMIN
        if edge == "xmax": return p[0] <= _XMAX
        if edge == "ymin": return p[1] >= _YMIN
        return p[1] <= _YMAX

    def isect(a, b):
        (x1, y1), (x2, y2) = a, b
        if edge in ("xmin", "xmax"):
            x = _XMIN if edge == "xmin" else _XMAX
            t = (x - x1) / (x2 - x1) if x2 != x1 else 0.0
            return [x, y1 + t * (y2 - y1)]
        y = _YMIN if edge == "ymin" else _YMAX
        t = (y - y1) / (y2 - y1) if y2 != y1 else 0.0
        return [x1 + t * (x2 - x1), y]

    out = []
    n = len(ring)
    for i in range(n):
        cur, prv = ring[i], ring[i - 1]
        ci, pi = inside(cur), inside(prv)
        if ci:
            if not pi:
                out.append(isect(prv, cur))
            out.append(list(cur))
        elif pi:
            out.append(isect(prv, cur))
    return out


def _clip_poly(rings):
    clipped = []
    for ring in rings:
        r = [list(p) for p in ring]
        for edge in ("xmin", "xmax", "ymin", "ymax"):
            if not r:
                break
            r = _clip_ring(r, edge)
        if len(r) >= 3:
            if r[0] != r[-1]:
                r.append(list(r[0]))
            clipped.append(r)
    return clipped


def _clip_bbox(geom):
    """Recorta una geometría GeoJSON al bbox CDMB. Devuelve None si queda vacía."""
    t = geom["type"]
    if t == "Polygon":
        rings = _clip_poly(geom["coordinates"])
        return {"type": "Polygon", "coordinates": rings} if rings else None
    if t == "MultiPolygon":
        polys = [p for p in (_clip_poly(poly) for poly in geom["coordinates"]) if p]
        return {"type": "MultiPolygon", "coordinates": polys} if polys else None
    return geom


def _dp(pts, tol):
    """Douglas–Peucker sobre un anillo (grados). tol ~0.001 = ~110 m."""
    if len(pts) < 3:
        return pts
    ax, ay = pts[0]
    bx, by = pts[-1]
    dx, dy = bx - ax, by - ay
    dd = dx * dx + dy * dy
    idx, dmax = 0, -1.0
    for i in range(1, len(pts) - 1):
        px, py = pts[i]
        if dd == 0:
            d = (px - ax) ** 2 + (py - ay) ** 2
        else:
            t = ((px - ax) * dx + (py - ay) * dy) / dd
            t = max(0.0, min(1.0, t))
            cx, cy = ax + t * dx, ay + t * dy
            d = (px - cx) ** 2 + (py - cy) ** 2
        if d > dmax:
            idx, dmax = i, d
    if dmax > tol * tol:
        return _dp(pts[:idx + 1], tol)[:-1] + _dp(pts[idx:], tol)
    return [pts[0], pts[-1]]


def _simplify_geom(geom, tol=0.0009, min_ring_deg2=1e-7):
    """DP + descarta anillos minúsculos. Devuelve None si no queda nada."""
    def _rings(rs):
        out = []
        for r in rs:
            s = _dp([list(p) for p in r], tol)
            if len(s) < 4:
                continue
            # área aprox del anillo (shoelace) para descartar migajas
            a = abs(sum(s[i][0] * s[i + 1][1] - s[i + 1][0] * s[i][1]
                        for i in range(len(s) - 1))) / 2
            if a >= min_ring_deg2:
                out.append(s)
        return out

    t = geom["type"]
    if t == "Polygon":
        rs = _rings(geom["coordinates"])
        return {"type": "Polygon", "coordinates": rs} if rs else None
    if t == "MultiPolygon":
        ps = [p for p in (_rings(poly) for poly in geom["coordinates"]) if p]
        return {"type": "MultiPolygon", "coordinates": ps} if ps else None
    return geom


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


# ------------------------------------------------ MADS: capas de ecosistema
def _gen_mads(svc, fname, name, tipo, fuente, mapfn, mao="0.0009"):
    """Genérico para las capas del org de datos abiertos del MADS
    (services6.arcgis.com/hxAwRYAu9QHliJ8T)."""
    url = ("https://services6.arcgis.com/hxAwRYAu9QHliJ8T/arcgis/rest/"
           f"services/{urllib.parse.quote(svc)}/FeatureServer/0/query")
    raw = _fetch_paged(url, "1=1", {"outFields": "*", "maxAllowableOffset": mao})
    out = []
    for f in raw:
        g = f.get("geometry")
        if not g:
            continue
        g = _clip_bbox(g)          # recorta el polígono al área CDMB
        if g:
            g = _simplify_geom(g)  # DP + descarta fragmentos minúsculos
        if not g:
            continue
        props = {"tipo": tipo, "fuente": fuente}
        props.update(mapfn(f.get("properties", {})))
        out.append({
            "type": "Feature",
            "properties": props,
            "geometry": _round_geom(g),
        })
    _write(fname, name, out)


def gen_aicas():
    # Áreas de Importancia para la Conservación de las Aves (AICAS) — programa
    # IAvH / Asociación Calidris / BirdLife. Aviturismo.
    _gen_mads(
        "AICAS_20240315", "aicas_cdmb.geojson", "aicas_cdmb", "aica", "Humboldt",
        lambda p: {"nombre": (p.get("AICA") or "").strip(),
                   "codigo": (p.get("CODIGO_BLI") or "").strip()},
    )


def gen_bosque_seco():
    # Ecosistema estratégico Bosque Seco Tropical (cañón del Chicamocha).
    _gen_mads(
        "Ecosistemas_Estratégicos_Bosque_Seco_Tropical",
        "bosque_seco_cdmb.geojson", "bosque_seco_tropical_cdmb",
        "bosque-seco", "MADS",
        lambda p: {"nombre": "Bosque seco tropical",
                   "region": (p.get("Region") or "").strip()},
        mao="0.0025",   # ~275 m: capa de contexto, no de precisión
    )


def gen_reserva_ley2():
    # Reservas Forestales de Ley 2ª de 1959 (p. ej. RF Río Magdalena).
    _gen_mads(
        "Reservas_Forestales_de_Ley_2da_de_1959_",
        "reserva_ley2_cdmb.geojson", "reserva_forestal_ley2_cdmb",
        "reserva-forestal", "MADS",
        lambda p: {"nombre": (p.get("nom_ley2") or "").strip(),
                   "acto": (p.get("res_zoni") or "").strip()},
    )


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
    print("AICAS - aves (Humboldt)...")
    gen_aicas()
    print("Bosque seco tropical (MADS)...")
    gen_bosque_seco()
    print("Reserva Forestal Ley 2a (MADS)...")
    gen_reserva_ley2()
    print("listo.")
