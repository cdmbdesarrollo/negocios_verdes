import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:latlong2/latlong.dart';

import '../../../core/widgets/botones_zoom_mapa.dart';
import '../../../core/widgets/pin_negocio_mapa.dart';
import '../../../models/negocio.dart';
import '../../../theme/nv_colors.dart';

const LatLng _centroCdmb = LatLng(7.12, -73.12);

/// Cómo encuadrar el mapa para que se vean todos los negocios con
/// ubicación (o el área metropolitana de Bucaramanga si no hay ninguno).
/// Se usa en el arranque (`initialCameraFit`) y cada vez que cambian los
/// resultados (BuscarPage llama `fitCamera` con esto).
CameraFit ajusteMapaNegocios(List<Negocio> negocios) {
  final puntos = [
    for (final n in negocios)
      if (n.tieneUbicacion) LatLng(n.latitud!, n.longitud!),
  ];
  if (puntos.isEmpty) {
    // Área metropolitana de Bucaramanga.
    return CameraFit.bounds(
      bounds: LatLngBounds(
        const LatLng(7.00, -73.22),
        const LatLng(7.25, -73.00),
      ),
      padding: const EdgeInsets.all(24),
    );
  }
  return CameraFit.coordinates(
    coordinates: puntos,
    padding: const EdgeInsets.all(40),
    maxZoom: puntos.length == 1 ? 14 : 15,
  );
}

/// Mapa con clustering de los negocios filtrados que sí tienen coordenadas.
/// Recibe el MapController de afuera (no crea el suyo) para que BuscarPage
/// pueda recentrar/animar desde el botón "ver en mapa" de la lista — la
/// sincronización real en las dos direcciones vive en BuscarPage.
class ResultadosMapa extends StatelessWidget {
  final List<Negocio> negocios;
  final MapController mapController;
  final String? negocioSeleccionadoId;
  final void Function(Negocio negocio) onMarcadorTocado;

  const ResultadosMapa({
    super.key,
    required this.negocios,
    required this.mapController,
    required this.onMarcadorTocado,
    this.negocioSeleccionadoId,
  });

  List<Negocio> get _conUbicacion =>
      negocios.where((n) => n.tieneUbicacion).toList();

  @override
  Widget build(BuildContext context) {
    final negociosConUbicacion = _conUbicacion;

    return Stack(
      children: [
        FlutterMap(
      mapController: mapController,
      options: MapOptions(
        initialCenter: _centroCdmb,
        initialZoom: 11,
        initialCameraFit: ajusteMapaNegocios(negocios),
        minZoom: 3,
        maxZoom: 18,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'co.gov.cdmb.negocios_verdes_cdmb',
        ),
        MarkerClusterLayerWidget(
          options: MarkerClusterLayerOptions(
            maxClusterRadius: 65,
            size: const Size(38, 38),
            zoomToBoundsOnClick: true,
            markers: [
              for (final negocio in negociosConUbicacion)
                Marker(
                  key: ValueKey(negocio.id),
                  point: LatLng(negocio.latitud!, negocio.longitud!),
                  width: 48,
                  height: 48,
                  child: PinNegocioMapa(
                    fotoPortadaUrl: negocio.fotoPortadaUrl,
                    destacado: negocio.id == negocioSeleccionadoId,
                    tamano: negocio.id == negocioSeleccionadoId ? 46 : 36,
                  ),
                ),
            ],
            builder: (context, markers) => _PinCluster(cantidad: markers.length),
            onMarkerTap: (marker) {
              final id = marker.key;
              if (id is! ValueKey<String>) return;
              for (final negocio in negociosConUbicacion) {
                if (negocio.id == id.value) {
                  onMarcadorTocado(negocio);
                  return;
                }
              }
            },
          ),
        ),
          ],
        ),
        Positioned(
          right: 12,
          top: 12,
          child: BotonesZoomMapa(controlador: mapController),
        ),
      ],
    );
  }

}

class _PinCluster extends StatelessWidget {
  final int cantidad;

  const _PinCluster({required this.cantidad});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: NVColors.primaryDark,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        '$cantidad',
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }
}
