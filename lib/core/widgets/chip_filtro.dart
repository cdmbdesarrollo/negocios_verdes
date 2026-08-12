import 'package:flutter/material.dart';

import '../../theme/nv_colors.dart';

class ChipFiltro extends StatelessWidget {
  final String etiqueta;
  final bool seleccionado;
  final VoidCallback onTap;
  final String? icono;

  /// Estilo de contorno (sin relleno) en vez del relleno sólido de
  /// siempre — para filtros que dependen/anidan bajo otro (p. ej.
  /// subcategoría bajo categoría), así se distinguen a simple vista en
  /// vez de leerse como "más chips del mismo nivel".
  final bool variante;

  /// Ancho mínimo opcional — sin esto, cada chip mide justo lo que su
  /// etiqueta necesita, así que una lista con nombres muy dispares (p. ej.
  /// "Biocomercio" junto a "Aprovechamiento y valorización de residuos")
  /// se ve despareja. Es mínimo, no fijo: una etiqueta más larga que
  /// [anchoMinimo] igual crece lo que necesite, nunca se trunca.
  final double? anchoMinimo;

  const ChipFiltro({
    super.key,
    required this.etiqueta,
    required this.seleccionado,
    required this.onTap,
    this.icono,
    this.variante = false,
    this.anchoMinimo,
  });

  @override
  Widget build(BuildContext context) {
    final texto = icono != null ? '$icono $etiqueta' : etiqueta;
    final label = Center(child: Text(texto, textAlign: TextAlign.center));
    Widget chip;
    if (variante) {
      chip = FilterChip(
        label: label,
        selected: seleccionado,
        onSelected: (_) => onTap(),
        backgroundColor: Colors.transparent,
        selectedColor: NVColors.primaryLight,
        labelStyle: TextStyle(
          color: NVColors.primaryDark,
          fontWeight: seleccionado ? FontWeight.w600 : FontWeight.normal,
        ),
        side: const BorderSide(color: NVColors.primary),
        checkmarkColor: NVColors.primaryDark,
      );
    } else {
      chip = FilterChip(
        label: label,
        selected: seleccionado,
        onSelected: (_) => onTap(),
        backgroundColor: NVColors.primaryLight,
        selectedColor: NVColors.primary,
        labelStyle: TextStyle(
          color: seleccionado ? Colors.white : NVColors.textoPrincipal,
          fontWeight: seleccionado ? FontWeight.w600 : FontWeight.normal,
        ),
        side: BorderSide.none,
        checkmarkColor: Colors.white,
      );
    }
    if (anchoMinimo == null) return chip;
    return ConstrainedBox(
      constraints: BoxConstraints(minWidth: anchoMinimo!),
      child: chip,
    );
  }
}
