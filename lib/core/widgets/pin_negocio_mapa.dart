import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../theme/nv_colors.dart';

/// Pin circular con la foto/logo del negocio, en vez de un ícono de
/// ubicación genérico — así cualquier mapa que muestre negocios se
/// identifica de un vistazo. Compartido entre el mapa de resultados de
/// /buscar (varios negocios, con estado "seleccionado") y el mini-mapa de
/// la ficha individual (un solo negocio, siempre "destacado"). Cae de
/// vuelta a un ícono de tienda si el negocio no tiene foto de portada.
class PinNegocioMapa extends StatelessWidget {
  final String? fotoPortadaUrl;
  final bool destacado;
  final double tamano;

  const PinNegocioMapa({
    super.key,
    required this.fotoPortadaUrl,
    this.destacado = false,
    this.tamano = 36,
  });

  @override
  Widget build(BuildContext context) {
    final color = destacado ? NVColors.accent : NVColors.primary;
    final tieneFoto = fotoPortadaUrl != null && fotoPortadaUrl!.isNotEmpty;
    return Container(
      width: tamano,
      height: tamano,
      padding: const EdgeInsets.all(2.5),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        border: Border.all(color: color, width: 2.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipOval(
        child: tieneFoto
            ? CachedNetworkImage(imageUrl: fotoPortadaUrl!, fit: BoxFit.cover)
            : Container(
                color: NVColors.primaryLight,
                alignment: Alignment.center,
                child: Icon(Icons.storefront,
                    size: tamano * 0.5, color: NVColors.primary),
              ),
      ),
    );
  }
}
