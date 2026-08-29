import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:latlong2/latlong.dart';

/// Un municipio de la jurisdicción CDMB con su polígono de límites (uno o
/// varios anillos exteriores). Los datos salen de OpenStreetMap,
/// simplificados a ~200 m — ver `assets/geo/README.md`. Alcanza para
/// dibujar las capas del geovisor y para saber en qué municipio cae un
/// punto (los negocios ya traen su municipio como texto, esto es de más).
class MunicipioGeo {
  final String nombre;
  final int osmId;

  /// Cada elemento es un anillo exterior (un polígono simple). Un municipio
  /// suele tener uno; algunos con enclaves/islas traen varios.
  final List<List<LatLng>> anillos;

  const MunicipioGeo({
    required this.nombre,
    required this.osmId,
    required this.anillos,
  });

  /// Centro aproximado (promedio de los vértices del anillo más grande) —
  /// para poner la etiqueta del nombre.
  LatLng get centro {
    final ring = anillos.reduce((a, b) => a.length >= b.length ? a : b);
    var lat = 0.0, lng = 0.0;
    for (final p in ring) {
      lat += p.latitude;
      lng += p.longitude;
    }
    return LatLng(lat / ring.length, lng / ring.length);
  }

  bool contiene(LatLng p) {
    for (final ring in anillos) {
      if (_puntoEnAnillo(p, ring)) return true;
    }
    return false;
  }

  static bool _puntoEnAnillo(LatLng p, List<LatLng> ring) {
    var dentro = false;
    for (var i = 0, j = ring.length - 1; i < ring.length; j = i++) {
      final xi = ring[i].longitude, yi = ring[i].latitude;
      final xj = ring[j].longitude, yj = ring[j].latitude;
      final cruza = (yi > p.latitude) != (yj > p.latitude) &&
          p.longitude < (xj - xi) * (p.latitude - yi) / (yj - yi) + xi;
      if (cruza) dentro = !dentro;
    }
    return dentro;
  }

  static List<LatLng> _ring(List coords) => [
        for (final c in coords)
          LatLng((c[1] as num).toDouble(), (c[0] as num).toDouble()),
      ];

  /// Lee y parsea `assets/geo/municipios_cdmb.geojson` una sola vez.
  static Future<List<MunicipioGeo>> cargar() async {
    final texto =
        await rootBundle.loadString('assets/geo/municipios_cdmb.geojson');
    final fc = json.decode(texto) as Map<String, dynamic>;
    final out = <MunicipioGeo>[];
    for (final f in (fc['features'] as List)) {
      final props = f['properties'] as Map<String, dynamic>;
      final geom = f['geometry'] as Map<String, dynamic>;
      final tipo = geom['type'] as String;
      final coords = geom['coordinates'] as List;
      final anillos = <List<LatLng>>[];
      if (tipo == 'Polygon') {
        for (final ring in coords) {
          anillos.add(_ring(ring as List));
        }
      } else if (tipo == 'MultiPolygon') {
        for (final poly in coords) {
          for (final ring in (poly as List)) {
            anillos.add(_ring(ring as List));
          }
        }
      }
      out.add(MunicipioGeo(
        nombre: props['nombre'] as String,
        osmId: (props['osm_id'] as num).toInt(),
        anillos: anillos,
      ));
    }
    return out;
  }
}
