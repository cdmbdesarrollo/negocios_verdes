import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/badge_nivel.dart';
import '../../../models/negocio.dart';
import '../../../theme/nv_colors.dart';

/// Tarjeta de negocio reusada en BuscarPage (lista de resultados) y en el
/// carrusel de destacados de InicioPage.
class NegocioCard extends StatelessWidget {
  final Negocio negocio;
  final bool seleccionado;
  final VoidCallback? onVerEnMapa;

  const NegocioCard({
    super.key,
    required this.negocio,
    this.seleccionado = false,
    this.onVerEnMapa,
  });

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(16);
    return Material(
      color: NVColors.superficie,
      elevation: 2,
      shadowColor: Colors.black.withValues(alpha: 0.14),
      borderRadius: borderRadius,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.go('/negocio/${negocio.slug}'),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            border: Border.all(
              color: seleccionado ? NVColors.accent : NVColors.borde,
              width: seleccionado ? 2 : 1,
            ),
          ),
          child: Row(
            // Nota: NO usar IntrinsicHeight aquí para igualar la altura de
            // la imagen con el texto — IntrinsicHeight + stretch rompe el
            // hit-testing en desktop quando envuelve algo con InkWell (bug
            // real ya documentado en el CLAUDE.md de HuellaQR). Se usa una
            // altura fija en su lugar.
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 100,
                height: 128,
                child: negocio.fotoPortadaUrl != null &&
                        negocio.fotoPortadaUrl!.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: negocio.fotoPortadaUrl!, fit: BoxFit.cover)
                    : Container(
                        color: NVColors.primaryLight,
                        child: const Icon(Icons.storefront,
                            color: NVColors.primary, size: 32),
                      ),
              ),
              Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                negocio.nombre,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                            ),
                            if (onVerEnMapa != null && negocio.tieneUbicacion)
                              IconButton(
                                visualDensity: VisualDensity.compact,
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                                icon: const Icon(Icons.place_outlined,
                                    size: 20, color: NVColors.primary),
                                tooltip: 'Ver en el mapa',
                                onPressed: onVerEnMapa,
                              ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${negocio.categoriaOficial?.iconoOTexto ?? ''} '
                          '${negocio.categoriaOficial?.nombre ?? ''} · ${negocio.municipio}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              color: NVColors.textoSecundario, fontSize: 12),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          negocio.descripcionCorta,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 13),
                        ),
                        const SizedBox(height: 6),
                        Wrap(
                          spacing: 6,
                          runSpacing: 4,
                          children: [
                            BadgeNivel(
                                nivel: negocio.nivelDesarrollo, tamanoFuente: 10),
                            if (!negocio.tieneUbicacion)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: NVColors.borde,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Text(
                                  'Sin ubicación en el mapa',
                                  style: TextStyle(
                                      fontSize: 10,
                                      color: NVColors.textoSecundario),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
  }
}

