import 'package:flutter/material.dart';

import '../../catalogos.dart';
import '../../theme/nv_colors.dart';

/// Insignia de negocios.nivel_desarrollo (en_verificacion/verificado/
/// negocio_ancla) — señal de confianza que las páginas de referencia no
/// tienen.
class BadgeNivel extends StatelessWidget {
  final String nivel;
  final double tamanoFuente;

  const BadgeNivel({super.key, required this.nivel, this.tamanoFuente = 12});

  @override
  Widget build(BuildContext context) {
    final color = _color(nivel);
    final etiqueta = kNivelesDesarrolloEtiqueta[nivel] ?? nivel;

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
          Icon(_icono(nivel), size: tamanoFuente + 2, color: color),
          const SizedBox(width: 4),
          Text(
            etiqueta,
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

  Color _color(String nivel) {
    switch (nivel) {
      case 'verificado':
        return NVColors.nivelVerificado;
      case 'negocio_ancla':
        return NVColors.nivelAncla;
      default:
        return NVColors.nivelEnVerificacion;
    }
  }

  IconData _icono(String nivel) {
    switch (nivel) {
      case 'verificado':
        return Icons.verified;
      case 'negocio_ancla':
        return Icons.workspace_premium;
      default:
        return Icons.hourglass_top;
    }
  }
}
