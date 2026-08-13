import 'package:flutter/material.dart';

import '../../theme/nv_colors.dart';

/// Envoltorio genérico de tarjeta (borde, radio, tap opcional) reusado por
/// NegocioCard, tiles de categoría, etc. — un solo lugar para el look de
/// "tarjeta" de todo el sitio.
class NVCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;

  const NVCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(16),
  });

  @override
  Widget build(BuildContext context) {
    // Antes era un Container con solo borde (sin sombra) — se veía plano.
    // Material con elevation dibuja sombra real por fuera del borde sin
    // que el clip del InkWell se la coma, y sigue funcionando igual si
    // onTap es null (el InkWell simplemente no responde al toque).
    return Material(
      color: NVColors.superficie,
      elevation: 2,
      shadowColor: Colors.black.withValues(alpha: 0.14),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: NVColors.borde),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(padding: padding, child: child),
      ),
    );
  }
}
