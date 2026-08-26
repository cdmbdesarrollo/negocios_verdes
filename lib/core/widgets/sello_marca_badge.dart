import 'package:flutter/material.dart';

import '../../theme/nv_colors.dart';

/// Insignia de negocios.sello_marca — deliberadamente distinta de
/// AvaladoBadge/AvalConfianzaBadge (degradado verde + sombra en vez del
/// pill plano con borde alfa): es un reconocimiento aparte, no debe leerse
/// como "otro valor de la misma lista" al lado de las otras insignias.
/// Verde (no dorado, pedido explícito) para acercarse al color del sello
/// oficial "Sello Ambiental Colombiano / Negocios Verdes".
class SelloMarcaBadge extends StatelessWidget {
  final double tamanoFuente;

  const SelloMarcaBadge({super.key, this.tamanoFuente = 12});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: tamanoFuente, vertical: tamanoFuente * 0.35),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [NVColors.selloMarcaVerde, Color(0xFF6FD88A)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: NVColors.selloMarcaVerde.withValues(alpha: 0.35),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.military_tech, size: tamanoFuente + 2, color: Colors.white),
          const SizedBox(width: 4),
          Text(
            'Sello Marca',
            style: TextStyle(
              fontSize: tamanoFuente,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}
