import 'package:flutter/material.dart';

import '../../theme/nv_colors.dart';

class SectionHeader extends StatelessWidget {
  final String titulo;
  final String? subtitulo;
  final Widget? accion;

  const SectionHeader({
    super.key,
    required this.titulo,
    this.subtitulo,
    this.accion,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                titulo,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: NVColors.textoPrincipal,
                ),
              ),
              if (subtitulo != null) ...[
                const SizedBox(height: 4),
                Text(
                  subtitulo!,
                  style: const TextStyle(color: NVColors.textoSecundario),
                ),
              ],
            ],
          ),
        ),
        if (accion != null) accion!,
      ],
    );
  }
}
