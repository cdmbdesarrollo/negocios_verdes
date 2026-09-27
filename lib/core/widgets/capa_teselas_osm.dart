import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

/// TileLayer de OpenStreetMap que se recupera sola del "mapa gris" de la
/// primera visita (reportado en /buscar): sin caché en el navegador, las
/// teselas de la primera carga quedaban sin pintar — o fallaban — mientras
/// el sitio todavía estaba arrancando y el mapa se reencuadraba varias
/// veces seguidas (tamaño inicial → initialCameraFit → fitCamera del
/// buscador), y flutter_map no las vuelve a pedir hasta que la cámara
/// cambia. Con zoom − y + ya se veía perfecto. Esto hace lo mismo sin que
/// el usuario tenga que tocar nada: usa el `reset` de TileLayer (descarta
/// las teselas actuales y pide de nuevo las visibles) un momento después
/// de montarse, y otra vez si alguna tesela falla (con tope de reintentos).
class CapaTeselasOsm extends StatefulWidget {
  const CapaTeselasOsm({super.key});

  @override
  State<CapaTeselasOsm> createState() => _CapaTeselasOsmState();
}

class _CapaTeselasOsmState extends State<CapaTeselasOsm> {
  static const _maxReintentosPorError = 3;

  final _reset = StreamController<void>.broadcast();
  final List<Timer> _timers = [];
  Timer? _reintento;
  int _reintentos = 0;

  @override
  void initState() {
    super.initState();
    // Dos pasadas: una apenas se asienta el reencuadre inicial y otra de
    // respaldo por si el primer pedido todavía compitió con el arranque.
    for (final ms in const [500, 2000]) {
      _timers.add(Timer(Duration(milliseconds: ms), _recargar));
    }
  }

  @override
  void dispose() {
    for (final t in _timers) {
      t.cancel();
    }
    _reintento?.cancel();
    _reset.close();
    super.dispose();
  }

  void _recargar() {
    if (mounted && !_reset.isClosed) _reset.add(null);
  }

  /// Una tesela falló: se reintenta todo lo visible una sola vez por ráfaga
  /// de errores (varias teselas suelen fallar juntas), con tope para no
  /// quedar en un bucle si el servidor de teselas está caído de verdad.
  void _alFallarTesela(TileImage tile, Object error, StackTrace? stackTrace) {
    if (_reintentos >= _maxReintentosPorError || _reintento != null) return;
    _reintento = Timer(Duration(seconds: 1 + _reintentos), () {
      _reintento = null;
      _reintentos++;
      _recargar();
    });
  }

  @override
  Widget build(BuildContext context) {
    return TileLayer(
      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
      userAgentPackageName: 'co.gov.cdmb.negocios_verdes_cdmb',
      reset: _reset.stream,
      errorTileCallback: _alFallarTesela,
    );
  }
}
