import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

import '../../../../core/widgets/botones_zoom_mapa.dart';
import '../../../../theme/nv_colors.dart';

/// Centroides aproximados de cada municipio, solo para centrar el mapa al
/// abrir el selector — NO son la ubicación real de ningún negocio, esa la
/// marca el admin tocando el mapa.
const Map<String, LatLng> _centroidesMunicipio = {
  'Bucaramanga': LatLng(7.1193, -73.1227),
  'Floridablanca': LatLng(7.0631, -73.0850),
  'Girón': LatLng(7.0678, -73.1719),
  'Piedecuesta': LatLng(6.9897, -73.0508),
  'Vetas': LatLng(7.3081, -72.8794),
  'California': LatLng(7.3467, -72.9142),
  'Suratá': LatLng(7.3672, -72.9803),
  'Matanza': LatLng(7.3072, -73.0181),
  'Charta': LatLng(7.2872, -72.9403),
  'Tona': LatLng(7.2003, -72.9822),
  'El Playón': LatLng(7.4917, -73.2011),
  'Rionegro': LatLng(7.2586, -73.1567),
  'Lebrija': LatLng(7.1214, -73.2183),
};

const LatLng _centroCdmbPorDefecto = LatLng(7.1193, -73.1227); // Bucaramanga

/// Mapa tocable para fijar la ubicación exacta del negocio (opcional — si
/// se deja sin marcar, el negocio igual aparece en la lista, solo no tiene
/// pin en /buscar). Antes solo se podía marcar tocando el mapa a mano —
/// escribir la dirección en el campo de texto no movía nada, así que en la
/// práctica casi ningún negocio terminaba con ubicación. Ahora "Buscar en
/// el mapa" geocodifica esa dirección con Nominatim (el mismo buscador de
/// OpenStreetMap, gratuito, sin API key — coherente con que las teselas
/// del mapa ya son de OSM) y mueve el pin ahí; el admin igual puede
/// ajustarlo a mano tocando el mapa si el resultado no es exacto.
class SelectorUbicacionMapa extends StatefulWidget {
  final String municipio;

  /// El controller (no un String suelto) para leer siempre el valor actual
  /// del campo de dirección al momento de buscar, sin depender de que el
  /// formulario padre se reconstruya en cada tecla escrita.
  final TextEditingController direccionController;
  final double? latitudInicial;
  final double? longitudInicial;
  final void Function(double? lat, double? lng) onCambio;

  const SelectorUbicacionMapa({
    super.key,
    required this.municipio,
    required this.direccionController,
    this.latitudInicial,
    this.longitudInicial,
    required this.onCambio,
  });

  @override
  State<SelectorUbicacionMapa> createState() => _SelectorUbicacionMapaState();
}

class _SelectorUbicacionMapaState extends State<SelectorUbicacionMapa> {
  LatLng? _punto;
  late final MapController _mapController;
  bool _buscando = false;
  String? _errorBusqueda;

  // Muchos negocios no tienen una dirección real que Nominatim pueda
  // encontrar (kilómetro X de la vía, finca sin nomenclatura) — para esos
  // casos el admin copia lat/lng directo de Google Maps (clic derecho
  // sobre el punto → clic en los números) y los pega acá. Los campos se
  // mantienen sincronizados con el punto actual sin importar cómo se haya
  // marcado (tocando el mapa, buscando dirección, o escribiéndolos aquí).
  late final TextEditingController _latCtrl;
  late final TextEditingController _lngCtrl;
  String? _errorCoordenadas;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    if (widget.latitudInicial != null && widget.longitudInicial != null) {
      _punto = LatLng(widget.latitudInicial!, widget.longitudInicial!);
    }
    _latCtrl = TextEditingController(
        text: _punto?.latitude.toStringAsFixed(6) ?? '');
    _lngCtrl = TextEditingController(
        text: _punto?.longitude.toStringAsFixed(6) ?? '');
  }

  @override
  void dispose() {
    _latCtrl.dispose();
    _lngCtrl.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant SelectorUbicacionMapa oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.municipio != widget.municipio && _punto == null) {
      _mapController.move(_centroDe(widget.municipio), 13);
    }
  }

  LatLng _centroDe(String municipio) =>
      _centroidesMunicipio[municipio] ?? _centroCdmbPorDefecto;

  void _actualizarCamposCoordenadas() {
    _latCtrl.text = _punto?.latitude.toStringAsFixed(6) ?? '';
    _lngCtrl.text = _punto?.longitude.toStringAsFixed(6) ?? '';
  }

  void _alTocar(TapPosition posicionToque, LatLng punto) {
    setState(() {
      _punto = punto;
      _errorBusqueda = null;
      _errorCoordenadas = null;
    });
    _actualizarCamposCoordenadas();
    widget.onCambio(punto.latitude, punto.longitude);
  }

  void _quitarPunto() {
    setState(() => _punto = null);
    _actualizarCamposCoordenadas();
    widget.onCambio(null, null);
  }

  void _usarCoordenadas() {
    final lat = double.tryParse(_latCtrl.text.trim().replaceAll(',', '.'));
    final lng = double.tryParse(_lngCtrl.text.trim().replaceAll(',', '.'));
    if (lat == null || lng == null) {
      setState(() => _errorCoordenadas =
          'Escribe latitud y longitud válidas (ej. 7.119300 y -73.122700).');
      return;
    }
    if (lat < -90 || lat > 90 || lng < -180 || lng > 180) {
      setState(() => _errorCoordenadas = 'Esas coordenadas no son válidas.');
      return;
    }
    final punto = LatLng(lat, lng);
    setState(() {
      _errorCoordenadas = null;
      _errorBusqueda = null;
      _punto = punto;
    });
    _mapController.move(punto, 16);
    widget.onCambio(lat, lng);
  }

  /// Reportado: un admin pegó lat/lng en los campos pero nunca tocó "Usar"
  /// antes de guardar el formulario completo — onCambio nunca se disparó,
  /// así que quedó guardado sin ubicación aunque los campos SE VEÍAN
  /// llenos. Sin mensaje de error (a diferencia de _usarCoordenadas): acá
  /// se llama en cada tecla, y mientras se escribe un número la mayoría de
  /// los estados intermedios son inválidos a propósito (ej. "7." o "-7"),
  /// no tiene sentido gritarle error al usuario por eso. Silenciosamente
  /// no hace nada hasta que ambos campos parsean a un punto válido — ahí
  /// sí actualiza el mapa y notifica al padre, sin esperar un clic aparte.
  void _aplicarCoordenadasSiValidas() {
    final lat = double.tryParse(_latCtrl.text.trim().replaceAll(',', '.'));
    final lng = double.tryParse(_lngCtrl.text.trim().replaceAll(',', '.'));
    if (lat == null || lng == null) return;
    if (lat < -90 || lat > 90 || lng < -180 || lng > 180) return;
    final punto = LatLng(lat, lng);
    if (_punto == punto) return;
    setState(() {
      _errorCoordenadas = null;
      _errorBusqueda = null;
      _punto = punto;
    });
    widget.onCambio(lat, lng);
  }

  Future<void> _buscarDireccion() async {
    final direccion = widget.direccionController.text.trim();
    if (direccion.isEmpty) {
      setState(() => _errorBusqueda =
          'Escribe una dirección arriba antes de buscarla.');
      return;
    }
    setState(() {
      _buscando = true;
      _errorBusqueda = null;
    });
    try {
      final consulta = '$direccion, ${widget.municipio}, Santander, Colombia';
      final uri = Uri.https('nominatim.openstreetmap.org', '/search', {
        'q': consulta,
        'format': 'jsonv2',
        'limit': '1',
      });
      final respuesta = await http.get(
        uri,
        // Nominatim exige un User-Agent identificable — mismo criterio que
        // ya se usa para las teselas del mapa.
        headers: {'User-Agent': 'negocios-verdes-cdmb-admin/1.0'},
      );
      if (respuesta.statusCode != 200) {
        throw Exception('El buscador de direcciones no respondió (${respuesta.statusCode}).');
      }
      final resultados = jsonDecode(respuesta.body) as List;
      if (resultados.isEmpty) {
        setState(() => _errorBusqueda =
            'No se encontró esa dirección — puedes marcarla tocando el mapa.');
        return;
      }
      final primero = resultados.first as Map<String, dynamic>;
      final lat = double.tryParse(primero['lat']?.toString() ?? '');
      final lon = double.tryParse(primero['lon']?.toString() ?? '');
      if (lat == null || lon == null) {
        setState(() => _errorBusqueda =
            'No se pudo leer la ubicación encontrada — márcala tocando el mapa.');
        return;
      }
      final punto = LatLng(lat, lon);
      setState(() => _punto = punto);
      _actualizarCamposCoordenadas();
      _mapController.move(punto, 16);
      widget.onCambio(lat, lon);
    } catch (e) {
      setState(() => _errorBusqueda =
          'No se pudo buscar la dirección — márcala tocando el mapa.');
    } finally {
      if (mounted) setState(() => _buscando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(
              child: Text(
                'Busca la dirección o toca el mapa para marcar la ubicación '
                'exacta (opcional).',
                style: TextStyle(color: NVColors.textoSecundario, fontSize: 12),
              ),
            ),
            if (_punto != null)
              TextButton(
                  onPressed: _quitarPunto, child: const Text('Quitar punto')),
          ],
        ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: _buscando ? null : _buscarDireccion,
          icon: _buscando
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2))
              : const Icon(Icons.search, size: 18),
          label: const Text('Buscar dirección en el mapa'),
        ),
        if (_errorBusqueda != null) ...[
          const SizedBox(height: 6),
          Text(_errorBusqueda!,
              style: const TextStyle(color: NVColors.error, fontSize: 12)),
        ],
        const SizedBox(height: 14),
        const Text(
          '¿Sin dirección real (kilómetro de la vía, finca)? Pega las '
          'coordenadas — en Google Maps: clic derecho sobre el punto → '
          'clic en los números para copiarlos.',
          style: TextStyle(color: NVColors.textoSecundario, fontSize: 12),
        ),
        const SizedBox(height: 6),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: TextField(
                controller: _latCtrl,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true, signed: true),
                decoration: const InputDecoration(
                  labelText: 'Latitud',
                  isDense: true,
                  hintText: 'ej. 7.119300',
                ),
                onChanged: (_) => _aplicarCoordenadasSiValidas(),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: _lngCtrl,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true, signed: true),
                decoration: const InputDecoration(
                  labelText: 'Longitud',
                  isDense: true,
                  hintText: 'ej. -73.122700',
                ),
                onChanged: (_) => _aplicarCoordenadasSiValidas(),
              ),
            ),
            const SizedBox(width: 8),
            OutlinedButton(
                onPressed: _usarCoordenadas, child: const Text('Usar')),
          ],
        ),
        if (_errorCoordenadas != null) ...[
          const SizedBox(height: 6),
          Text(_errorCoordenadas!,
              style: const TextStyle(color: NVColors.error, fontSize: 12)),
        ],
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: SizedBox(
            height: 260,
            child: Stack(
              children: [
                FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: _punto ?? _centroDe(widget.municipio),
                    initialZoom: 13,
                    onTap: _alTocar,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName:
                          'co.gov.cdmb.negocios_verdes_cdmb',
                    ),
                    if (_punto != null)
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: _punto!,
                            width: 40,
                            height: 40,
                            child: const Icon(Icons.location_pin,
                                color: NVColors.accent, size: 40),
                          ),
                        ],
                      ),
                  ],
                ),
                Positioned(
                  right: 10,
                  bottom: 10,
                  child: BotonesZoomMapa(controlador: _mapController),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
