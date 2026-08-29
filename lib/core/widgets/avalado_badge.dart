import 'package:flutter/material.dart';

import '../../theme/nv_colors.dart';

/// Insignia de negocios.avalado ("Negocio Verde Avalado") — reemplaza a la
/// antigua AvalConfianzaBadge (aval_confianza) y absorbe también lo que
/// antes cubría nivel_desarrollo='verificado'/'negocio_ancla': CDMB
/// confirmó que en la práctica son las mismas 3 categorías
/// (Emprendimiento Verde / Sello Marca / Avalado), independientes entre sí.
/// A propósito NO usa el mismo tratamiento premium (degradado + sombra) que
/// SelloMarcaBadge: son dos reconocimientos independientes, deben leerse
/// como cosas distintas, no como "el mismo tipo de insignia en otro color".
class AvaladoBadge extends StatelessWidget {
  final double tamanoFuente;

  const AvaladoBadge({super.key, this.tamanoFuente = 12});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: NVColors.avaladoAzul.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: NVColors.avaladoAzul.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.verified_outlined,
              size: tamanoFuente + 2, color: NVColors.avaladoAzul),
          const SizedBox(width: 4),
          Text(
            'Negocio Verde Avalado',
            style: TextStyle(
              fontSize: tamanoFuente,
              fontWeight: FontWeight.w600,
              color: NVColors.avaladoAzul,
            ),
          ),
        ],
      ),
    );
  }
}
