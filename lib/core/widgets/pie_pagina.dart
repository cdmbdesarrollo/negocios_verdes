import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../models/configuracion_sitio.dart';
import '../../services/configuracion_sitio_service.dart';
import '../../theme/nv_colors.dart';

/// Pie de página institucional. Se agrega como ÚLTIMO elemento del scroll
/// propio de cada página pública (no vive en SiteShell — ver ese archivo
/// para el porqué). Úsalo en páginas de contenido (inicio, nosotros,
/// contacto, ficha de negocio); en pantallas tipo buscador se omite a
/// propósito para no robarle espacio vertical a resultados/mapa.
///
/// Fondo verde institucional (mismo color que la franja inferior del
/// footer de la Sede Electrónica de la CDMB, sedecdmb.micolombiadigital.gov.co
/// — Negocios Verdes es un micrositio de esa página) y, si el admin ya los
/// subió desde /admin/apariencia, los sellos de Colombia y GOV.CO al final,
/// igual que en esa página. Si todavía no los subió, esa fila simplemente
/// no aparece — nunca se inventan los sellos ni se rompe el layout.
class PiePagina extends StatelessWidget {
  const PiePagina({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: NVColors.primaryDark,
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
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
          const SizedBox(height: 16),
          const Divider(color: Colors.white24, height: 1),
          _franjaSellos(),
        ],
      ),
    );
  }

  Widget _franjaSellos() {
    return FutureBuilder<ConfiguracionSitio>(
      future: ConfiguracionSitioCache.obtener(),
      builder: (context, snapshot) {
        final config = snapshot.data;
        final sellos = <Widget>[
          if (config?.logoColombiaUrl != null &&
              config!.logoColombiaUrl!.isNotEmpty)
            CachedNetworkImage(imageUrl: config.logoColombiaUrl!, height: 28),
          if (config?.logoGovcoUrl != null && config!.logoGovcoUrl!.isNotEmpty)
            CachedNetworkImage(imageUrl: config.logoGovcoUrl!, height: 28),
        ];
        if (sellos.isEmpty) return const SizedBox(height: 16);
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Wrap(spacing: 20, runSpacing: 8, children: sellos),
        );
      },
    );
  }
}
