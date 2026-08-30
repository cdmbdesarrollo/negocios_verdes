import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:negocios_verdes_cdmb/models/negocio.dart';
import 'package:negocios_verdes_cdmb/pages/geovisor/geovisor_exportar.dart';

void main() {
  final n = Negocio(
    id: '1',
    nombre: 'Café, Verde "S.A.S"',
    slug: 'cafe-verde',
    categoriaOficialId: '',
    municipio: 'Bucaramanga',
    latitud: 7.12,
    longitud: -73.12,
    emprendimientoVerde: true,
    avalado: true,
    activo: true,
  );

  group('zonaAParam / parseZonaParam', () {
    test('round-trip conserva los puntos (5 decimales)', () {
      final z = [
        const LatLng(7.10001, -73.20002),
        const LatLng(7.20003, -73.10004),
        const LatLng(7.15005, -73.05006),
      ];
      final s = zonaAParam(z)!;
      final vuelta = parseZonaParam(s);
      expect(vuelta.length, 3);
      expect(vuelta[0].latitude, closeTo(7.10001, 1e-9));
      expect(vuelta[1].longitude, closeTo(-73.10004, 1e-9));
    });

    test('menos de 3 puntos -> null', () {
      expect(zonaAParam([const LatLng(7, -73), const LatLng(7.1, -73)]), null);
    });

    test('texto basura -> lista vacía', () {
      expect(parseZonaParam('abc;;7,'), isEmpty);
    });
  });

  group('geoJsonNegocios', () {
    test('FeatureCollection válido con un negocio', () {
      final fc = json.decode(geoJsonNegocios([n], origen: 'https://x.co'))
          as Map<String, dynamic>;
      expect(fc['type'], 'FeatureCollection');
      final feats = fc['features'] as List;
      expect(feats.length, 1);
      final props = feats[0]['properties'] as Map;
      expect(props['municipio'], 'Bucaramanga');
      expect(props['ficha'], 'https://x.co/negocio/cafe-verde');
      expect((feats[0]['geometry']['coordinates'] as List), [-73.12, 7.12]);
    });

    test('con zona agrega el polígono como primer feature', () {
      final z = [
        const LatLng(7.0, -73.2),
        const LatLng(7.2, -73.2),
        const LatLng(7.2, -73.0),
      ];
      final fc = json.decode(geoJsonNegocios([n],
          zona: z, areaKm2: 1.234, perimetroKm: 5.6, origen: 'https://x.co')) as Map;
      final feats = fc['features'] as List;
      expect(feats.length, 2);
      expect(feats[0]['properties']['tipo'], 'zona_seleccionada');
      expect(feats[0]['properties']['area_km2'], 1.234);
      // anillo cerrado
      final ring = feats[0]['geometry']['coordinates'][0] as List;
      expect(ring.first, ring.last);
    });
  });

  test('csvNegocios escapa comas y comillas', () {
    final csv = csvNegocios([n], origen: 'https://x.co');
    final lineas = csv.trim().split('\n');
    expect(lineas.first.startsWith('nombre,categoria'), isTrue);
    expect(lineas[1].contains('"Café, Verde ""S.A.S"""'), isTrue);
    expect(lineas[1].contains('sí,no,sí'), isTrue);
  });

  test('htmlReporte incluye título, conteo y filas', () {
    final h = htmlReporte(
        titulo: 'Zona X', negocios: [n], origen: 'https://x.co');
    expect(h.contains('<title>Zona X'), isTrue);
    expect(h.contains('1</b>negocios verdes'), isTrue);
    expect(h.contains('Caf&eacute;, Verde') || h.contains('Café, Verde'), isTrue);
    expect(h.contains('window.print()'), isTrue);
  });
}
