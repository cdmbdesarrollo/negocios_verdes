import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

import '../../theme/nv_colors.dart';

/// Botones + / − para acercar y alejar un [FlutterMap]. flutter_map no trae
/// controles propios y al tocar un clúster solo acerca, nunca aleja — con
/// esto se puede volver a una vista amplia sin depender de la rueda del
/// mouse o el pellizco. Se coloca dentro del `Stack` que envuelve el mapa
/// (p. ej. abajo a la derecha).
class BotonesZoomMapa extends StatelessWidget {
  final MapController controlador;
  final double zoomMin;
  final double zoomMax;

  const BotonesZoomMapa({
    super.key,
    required this.controlador,
    this.zoomMin = 3,
    this.zoomMax = 18,
  });

  void _cambiar(double delta) {
    final camara = controlador.camera;
    final nuevo = (camara.zoom + delta).clamp(zoomMin, zoomMax);
    controlador.move(camara.center, nuevo);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _boton(Icons.add, 'Acercar', () => _cambiar(1)),
        const SizedBox(height: 6),
        _boton(Icons.remove, 'Alejar', () => _cambiar(-1)),
      ],
    );
  }

  Widget _boton(IconData icono, String tooltip, VoidCallback onTap) {
    return Material(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: NVColors.borde),
      ),
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Tooltip(
          message: tooltip,
          child: SizedBox(
            width: 36,
            height: 36,
            child: Icon(icono, size: 20, color: NVColors.primaryDark),
          ),
        ),
      ),
    );
  }
}
