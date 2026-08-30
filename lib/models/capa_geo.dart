import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:latlong2/latlong.dart';

/// Un elemento de una capa geográfica del geovisor (área protegida, río,
/// cuerpo de agua…). Sale de un GeoJSON en `assets/geo/` bajado de
/// OpenStreetMap y simplificado — ver `assets/geo/README.md`.
class CapaGeoElemento {
  final String? nombre;
  final String? tipo;

  /// Resto de `properties` del GeoJSON tal cual (condicion, administra,
  /// url, hectareas… según la capa). `nombre` y `tipo` también están acá.
  final Map<String, dynamic> props;

  /// Anillos de polígono (áreas, cuerpos de agua). Vacío para líneas.
  final List<List<LatLng>> poligonos;

  /// Polilíneas (cauces). Vacío para áreas.
  final List<List<LatLng>> lineas;

  const CapaGeoElemento({
    this.nombre,
    this.tipo,
    this.props = const {},
    this.poligonos = const [],
    this.lineas = const [],
  });

  bool get esLinea => lineas.isNotEmpty;

  String? prop(String k) => props[k]?.toString();
}

/// Una capa completa (lista de elementos) + su carga desde el asset.
class CapaGeo {
  final List<CapaGeoElemento> elementos;
  const CapaGeo(this.elementos);

  static List<LatLng> _ring(List coords) => [
        for (final c in coords)
          LatLng((c[1] as num).toDouble(), (c[0] as num).toDouble()),
      ];

  static Future<CapaGeo> cargar(String asset) async {
    final fc = json.decode(await rootBundle.loadString(asset))
        as Map<String, dynamic>;
    final out = <CapaGeoElemento>[];
    for (final f in (fc['features'] as List)) {
      final props = (f['properties'] as Map?) ?? const {};
      final geom = f['geometry'] as Map<String, dynamic>;
      final tipo = geom['type'] as String;
      final coords = geom['coordinates'] as List;
      final polis = <List<LatLng>>[];
      final lines = <List<LatLng>>[];
      switch (tipo) {
        case 'Polygon':
          for (final ring in coords) {
            polis.add(_ring(ring as List));
          }
        case 'MultiPolygon':
          for (final poly in coords) {
            for (final ring in (poly as List)) {
              polis.add(_ring(ring as List));
            }
          }
        case 'LineString':
          lines.add(_ring(coords));
        case 'MultiLineString':
          for (final l in coords) {
            lines.add(_ring(l as List));
          }
      }
      out.add(CapaGeoElemento(
        nombre: props['nombre'] as String?,
        tipo: props['tipo'] as String?,
        props: Map<String, dynamic>.from(props),
        poligonos: polis,
        lineas: lines,
      ));
    }
    return CapaGeo(out);
  }
}
