import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:latlong2/latlong.dart';

import '../../../core/widgets/pin_negocio_mapa.dart';
import '../../../models/negocio.dart';
import '../../../theme/nv_colors.dart';

const LatLng _centroCdmb = LatLng(7.15, -73.05);

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
    final centro = _centroDe(negociosConUbicacion);

    return FlutterMap(
      mapController: mapController,
      options: MapOptions(initialCenter: centro, initialZoom: 11),
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
    );
  }

  LatLng _centroDe(List<Negocio> conUbicacion) {
    if (conUbicacion.isEmpty) return _centroCdmb;
    final lat = conUbicacion.map((n) => n.latitud!).reduce((a, b) => a + b) /
        conUbicacion.length;
    final lng = conUbicacion.map((n) => n.longitud!).reduce((a, b) => a + b) /
        conUbicacion.length;
    return LatLng(lat, lng);
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
