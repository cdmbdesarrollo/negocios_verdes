import 'dart:convert';

import 'package:latlong2/latlong.dart';

import '../../models/negocio.dart';

/// Funciones puras para las descargas del geovisor (GeoJSON / CSV / reporte
/// HTML). Separadas del widget para poder probarlas con `flutter test`.

String _cat(Negocio n) => n.categoriaOficial?.slug == 'pendiente-clasificar'
    ? ''
    : (n.categoriaOficial?.nombre ?? '');

Map<String, dynamic> _featureNegocio(Negocio n, String origen) => {
      'type': 'Feature',
      'properties': {
        'nombre': n.nombre,
        'categoria': _cat(n).isEmpty ? null : _cat(n),
        'municipio': n.municipio,
        'vereda': n.vereda?.nombre,
        'emprendimiento_verde': n.emprendimientoVerde,
        'sello_marca': n.selloMarca,
        'avalado': n.avalado,
        'ficha': '$origen/negocio/${n.slug}',
      },
      'geometry': {
        'type': 'Point',
        'coordinates': [n.longitud, n.latitud],
      },
    };

/// FeatureCollection con los [negocios] como puntos. Si se pasa [zona]
/// (polígono), se agrega como primer Feature con su área/perímetro.
String geoJsonNegocios(
  List<Negocio> negocios, {
  List<LatLng>? zona,
  double? areaKm2,
  double? perimetroKm,
  required String origen,
}) {
  final feats = <Map<String, dynamic>>[];
  if (zona != null && zona.length >= 3) {
    feats.add({
      'type': 'Feature',
      'properties': {
        'tipo': 'zona_seleccionada',
        if (areaKm2 != null)
          'area_km2': double.parse(areaKm2.toStringAsFixed(3)),
        if (perimetroKm != null)
          'perimetro_km': double.parse(perimetroKm.toStringAsFixed(3)),
        'negocios_verdes': negocios.length,
        'generado': DateTime.now().toIso8601String().substring(0, 19),
        'fuente': 'Geovisor Negocios Verdes CDMB — $origen',
      },
      'geometry': {
        'type': 'Polygon',
        'coordinates': [
          [
            for (final p in zona) [p.longitude, p.latitude],
            [zona.first.longitude, zona.first.latitude],
          ]
        ],
      },
    });
  }
  for (final n in negocios) {
    feats.add(_featureNegocio(n, origen));
  }
  return const JsonEncoder.withIndent('  ').convert({
    'type': 'FeatureCollection',
    'name': 'geovisor_negocios_verdes',
    'crs': {
      'type': 'name',
      'properties': {'name': 'urn:ogc:def:crs:OGC:1.3:CRS84'}
    },
    'features': feats,
  });
}

String _csvCampo(String? v) {
  final s = v ?? '';
  return (s.contains(',') || s.contains('"') || s.contains('\n'))
      ? '"${s.replaceAll('"', '""')}"'
      : s;
}

String csvNegocios(List<Negocio> negocios, {required String origen}) {
  final b = StringBuffer()
    ..writeln('nombre,categoria,municipio,vereda,latitud,longitud,'
        'emprendimiento_verde,sello_marca,avalado,ficha');
  for (final n in negocios) {
    b.writeln([
      _csvCampo(n.nombre),
      _csvCampo(_cat(n)),
      _csvCampo(n.municipio),
      _csvCampo(n.vereda?.nombre),
      n.latitud?.toStringAsFixed(6) ?? '',
      n.longitud?.toStringAsFixed(6) ?? '',
      n.emprendimientoVerde ? 'sí' : 'no',
      n.selloMarca ? 'sí' : 'no',
      n.avalado ? 'sí' : 'no',
      '$origen/negocio/${n.slug}',
    ].join(','));
  }
  return b.toString();
}

String _esc(String s) => s
    .replaceAll('&', '&amp;')
    .replaceAll('<', '&lt;')
    .replaceAll('>', '&gt;');

/// Reporte HTML autónomo (se abre en el navegador y se puede "Imprimir →
/// Guardar como PDF"). Sin dependencias externas.
String htmlReporte({
  required String titulo,
  required List<Negocio> negocios,
  double? areaKm2,
  double? perimetroKm,
  List<String> areasProtegidas = const [],
  required String origen,
}) {
  final hoy = DateTime.now().toIso8601String().substring(0, 10);
  final porMun = <String, int>{};
  for (final n in negocios) {
    porMun[n.municipio] = (porMun[n.municipio] ?? 0) + 1;
  }
  final munOrd = porMun.entries.toList()
    ..sort((a, b) => b.value.compareTo(a.value));

  final filas = StringBuffer();
  final ordenados = [...negocios]
    ..sort((a, b) => a.nombre.toLowerCase().compareTo(b.nombre.toLowerCase()));
  for (final n in ordenados) {
    final rec = [
      if (n.emprendimientoVerde) 'Emprendimiento Verde',
      if (n.selloMarca) 'Sello Marca',
      if (n.avalado) 'Avalado',
    ].join(', ');
    filas.writeln('<tr><td>${_esc(n.nombre)}</td>'
        '<td>${_esc(_cat(n))}</td>'
        '<td>${_esc(n.municipio)}</td>'
        '<td>${_esc(n.vereda?.nombre ?? '')}</td>'
        '<td>${_esc(rec)}</td>'
        '<td><a href="$origen/negocio/${n.slug}">ver ficha</a></td></tr>');
  }

  return '''<!doctype html><html lang="es"><head><meta charset="utf-8">
<title>${_esc(titulo)} — Negocios Verdes CDMB</title>
<style>
  body{font:14px/1.5 system-ui,Segoe UI,Roboto,sans-serif;color:#1a1a1a;max-width:900px;margin:24px auto;padding:0 16px}
  h1{font-size:20px;margin:0 0 4px} .sub{color:#666;margin:0 0 20px}
  .kpis{display:flex;flex-wrap:wrap;gap:12px;margin:16px 0}
  .kpi{border:1px solid #ddd;border-radius:8px;padding:10px 14px;min-width:120px}
  .kpi b{display:block;font-size:20px;color:#038f67}
  table{border-collapse:collapse;width:100%;margin-top:12px;font-size:12.5px}
  th,td{border:1px solid #e2e2e2;padding:6px 8px;text-align:left;vertical-align:top}
  th{background:#f2f7f4}
  h2{font-size:15px;margin:22px 0 6px;border-bottom:2px solid #038f67;padding-bottom:2px}
  ul{margin:6px 0 0 18px}
  .pie{color:#888;font-size:11px;margin-top:28px;border-top:1px solid #ddd;padding-top:8px}
  @media print{a{color:inherit;text-decoration:none}}
</style></head><body>
<h1>${_esc(titulo)}</h1>
<p class="sub">Geovisor Negocios Verdes — CDMB · generado el $hoy</p>
<div class="kpis">
  <div class="kpi"><b>${negocios.length}</b>negocios verdes</div>
  <div class="kpi"><b>${munOrd.length}</b>municipios</div>
${areaKm2 != null ? '  <div class="kpi"><b>${areaKm2.toStringAsFixed(2)}</b>km² de área</div>' : ''}
${perimetroKm != null ? '  <div class="kpi"><b>${perimetroKm.toStringAsFixed(2)}</b>km de perímetro</div>' : ''}
</div>
${munOrd.isEmpty ? '' : '<h2>Por municipio</h2><ul>${munOrd.map((e) => '<li>${_esc(e.key)}: ${e.value}</li>').join()}</ul>'}
${areasProtegidas.isEmpty ? '' : '<h2>Áreas protegidas que toca la zona</h2><ul>${areasProtegidas.map((a) => '<li>${_esc(a)}</li>').join()}</ul>'}
<h2>Negocios verdes (${negocios.length})</h2>
<table><thead><tr><th>Nombre</th><th>Categoría</th><th>Municipio</th><th>Vereda</th><th>Reconocimientos</th><th></th></tr></thead>
<tbody>
$filas
</tbody></table>
<p class="pie">Fuente: Geovisor Negocios Verdes de la CDMB ($origen). Cartografía base © OpenStreetMap. Áreas protegidas: RUNAP. Hidrografía: IDEAM. Este reporte es informativo y no constituye cartografía oficial.</p>
<script>try{window.print()}catch(e){}</script>
</body></html>''';
}

/// El polígono de la zona como texto para la URL:
/// `lat,lng;lat,lng;...` con 5 decimales.
String? zonaAParam(List<LatLng> zona) {
  if (zona.length < 3) return null;
  return zona
      .map((p) =>
          '${p.latitude.toStringAsFixed(5)},${p.longitude.toStringAsFixed(5)}')
      .join(';');
}

List<LatLng> parseZonaParam(String? s) {
  if (s == null || s.isEmpty) return const [];
  final out = <LatLng>[];
  for (final par in s.split(';')) {
    final xy = par.split(',');
    if (xy.length != 2) continue;
    final lat = double.tryParse(xy[0]);
    final lng = double.tryParse(xy[1]);
    if (lat == null || lng == null) continue;
    out.add(LatLng(lat, lng));
  }
  return out;
}
