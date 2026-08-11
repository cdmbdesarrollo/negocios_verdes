import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:latlong2/latlong.dart';

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
                  child: _PinNegocio(
                    negocio: negocio,
                    seleccionado: negocio.id == negocioSeleccionadoId,
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

/// Muestra la foto/logo del negocio en un pin circular en vez de un ícono
/// de ubicación genérico — así el mapa se identifica por negocio de un
/// vistazo, igual que HuellaQR muestra la foto de la mascota en su mapa.
/// Cae de vuelta a un ícono de tienda si el negocio todavía no tiene foto
/// de portada cargada.
class _PinNegocio extends StatelessWidget {
  final Negocio negocio;
  final bool seleccionado;

  const _PinNegocio({required this.negocio, required this.seleccionado});

  @override
  Widget build(BuildContext context) {
    final tamano = seleccionado ? 46.0 : 36.0;
    final color = seleccionado ? NVColors.accent : NVColors.primary;
    final fotoUrl = negocio.fotoPortadaUrl;
    return Container(
      width: tamano,
      height: tamano,
      padding: const EdgeInsets.all(2.5),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        border: Border.all(color: color, width: 2.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipOval(
        child: fotoUrl != null && fotoUrl.isNotEmpty
            ? CachedNetworkImage(imageUrl: fotoUrl, fit: BoxFit.cover)
            : Container(
                color: NVColors.primaryLight,
                alignment: Alignment.center,
                child: Icon(Icons.storefront,
                    size: tamano * 0.5, color: NVColors.primary),
              ),
      ),
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
