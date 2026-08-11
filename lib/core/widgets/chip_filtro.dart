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

  const ChipFiltro({
    super.key,
    required this.etiqueta,
    required this.seleccionado,
    required this.onTap,
    this.icono,
    this.variante = false,
  });

  @override
  Widget build(BuildContext context) {
    final texto = icono != null ? '$icono $etiqueta' : etiqueta;
    if (variante) {
      return FilterChip(
        label: Text(texto),
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
    }
    return FilterChip(
      label: Text(texto),
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
}
