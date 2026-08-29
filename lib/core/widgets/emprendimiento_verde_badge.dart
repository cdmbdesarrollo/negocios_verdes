import 'package:flutter/material.dart';

import '../../theme/nv_colors.dart';

/// Insignia de negocios.emprendimiento_verde — una de las 3 categorías de
/// reconocimiento independientes entre sí (ver
/// 0022_ficha_ampliada_negocios.sql), reemplaza a la antigua BadgeNivel
/// (nivel_desarrollo, un enum de 3 valores excluyentes que no reflejaba los
/// datos reales de CDMB: un negocio puede tener esta insignia Y Sello Marca
/// Y Avalado al mismo tiempo). Pill con borde, mismo tratamiento visual que
/// AvaladoBadge, con su propio color e ícono.
class EmprendimientoVerdeBadge extends StatelessWidget {
  final double tamanoFuente;

  const EmprendimientoVerdeBadge({super.key, this.tamanoFuente = 12});

  @override
  Widget build(BuildContext context) {
    const color = NVColors.emprendimientoVerdeGris;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.eco_outlined, size: tamanoFuente + 2, color: color),
          const SizedBox(width: 4),
          Text(
            'Emprendimiento Verde',
            style: TextStyle(
              fontSize: tamanoFuente,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
