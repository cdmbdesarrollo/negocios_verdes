import 'package:flutter/material.dart';

import '../../theme/nv_colors.dart';

/// Insignia de negocios.aval_confianza — a propósito NO usa el mismo
/// tratamiento premium (degradado + sombra) que SelloMarcaBadge: son dos
/// reconocimientos independientes entre sí, así que deben leerse como
/// cosas distintas, no como "el mismo tipo de insignia en otro color".
/// Pill con borde, más parecido a AvaladoBadge, con su propio color e ícono
/// (ninguno de los dos reutilizados de otra insignia).
class AvalConfianzaBadge extends StatelessWidget {
  final double tamanoFuente;

  const AvalConfianzaBadge({super.key, this.tamanoFuente = 12});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: NVColors.avalConfianzaDorado.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: NVColors.avalConfianzaDorado.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.shield_outlined,
              size: tamanoFuente + 2, color: NVColors.avalConfianzaDorado),
          const SizedBox(width: 4),
          Text(
            'Aval de Confianza',
            style: TextStyle(
              fontSize: tamanoFuente,
              fontWeight: FontWeight.w600,
              color: NVColors.avalConfianzaDorado,
            ),
          ),
        ],
      ),
    );
  }
}
