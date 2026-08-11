import 'package:flutter/material.dart';

import '../../theme/nv_colors.dart';

/// Pie de página institucional. Se agrega como ÚLTIMO elemento del scroll
/// propio de cada página pública (no vive en SiteShell — ver ese archivo
/// para el porqué). Úsalo en páginas de contenido (inicio, nosotros,
/// contacto, ficha de negocio); en pantallas tipo buscador se omite a
/// propósito para no robarle espacio vertical a resultados/mapa.
class PiePagina extends StatelessWidget {
  const PiePagina({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: NVColors.primaryDark,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'CDMB — Corporación Autónoma Regional para la Defensa de la '
            'Meseta de Bucaramanga',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          const Text(
            'Ventanilla de Negocios Verdes · Directorio de negocios verdes '
            'en los 13 municipios de la jurisdicción CDMB.',
            style: TextStyle(color: Colors.white70, fontSize: 13),
          ),
          const SizedBox(height: 12),
          Text(
            '© ${DateTime.now().year} CDMB. Todos los derechos reservados.',
            style: const TextStyle(color: Colors.white54, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
