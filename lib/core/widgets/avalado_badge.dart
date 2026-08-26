import 'package:flutter/material.dart';

import '../../theme/nv_colors.dart';

/// Insignia de negocios.avalado ("Negocio avalado por la CDMB") — a
/// propósito NO usa el tratamiento premium (degradado + sombra) de
/// SelloMarcaBadge ni el color de AvalConfianzaBadge: son 3 reconocimientos
/// independientes entre sí, cada uno con su propio color e ícono para que
/// no se lean como variantes de la misma insignia.
class AvaladoBadge extends StatelessWidget {
  final double tamanoFuente;

  const AvaladoBadge({super.key, this.tamanoFuente = 12});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: NVColors.avaladoColor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: NVColors.avaladoColor.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.verified_outlined,
              size: tamanoFuente + 2, color: NVColors.avaladoColor),
          const SizedBox(width: 4),
          Text(
            'Avalado',
            style: TextStyle(
              fontSize: tamanoFuente,
              fontWeight: FontWeight.w600,
              color: NVColors.avaladoColor,
            ),
          ),
        ],
      ),
    );
  }
}
