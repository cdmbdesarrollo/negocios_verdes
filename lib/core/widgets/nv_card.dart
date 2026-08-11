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
    final borderRadius = BorderRadius.circular(16);
    final contenido = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: NVColors.superficie,
        border: Border.all(color: NVColors.borde),
        borderRadius: borderRadius,
      ),
      child: child,
    );

    if (onTap == null) return contenido;

    return Material(
      color: Colors.transparent,
      borderRadius: borderRadius,
      clipBehavior: Clip.antiAlias,
      child: InkWell(onTap: onTap, child: contenido),
    );
  }
}
