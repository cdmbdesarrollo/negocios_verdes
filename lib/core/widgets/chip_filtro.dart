import 'package:flutter/material.dart';

import '../../theme/nv_colors.dart';

class ChipFiltro extends StatelessWidget {
  final String etiqueta;
  final bool seleccionado;
  final VoidCallback onTap;
  final String? icono;

  const ChipFiltro({
    super.key,
    required this.etiqueta,
    required this.seleccionado,
    required this.onTap,
    this.icono,
  });

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(icono != null ? '$icono $etiqueta' : etiqueta),
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
