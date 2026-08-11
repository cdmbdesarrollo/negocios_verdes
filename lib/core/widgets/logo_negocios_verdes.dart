import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../models/configuracion_sitio.dart';
import '../../services/configuracion_sitio_service.dart';

/// Logo de la app en un solo lugar. Se administra desde /admin/apariencia
/// (sube la imagen a Storage, sin necesidad de recompilar) — mientras no se
/// haya subido uno, cae de vuelta a assets/images/logo.png, y si hasta ese
/// asset llegara a faltar, cae al emoji 🌱. Nunca rompe la pantalla.
class LogoNegociosVerdes extends StatelessWidget {
  final double altura;

  const LogoNegociosVerdes({super.key, this.altura = 32});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ConfiguracionSitio>(
      future: ConfiguracionSitioCache.obtener(),
      builder: (context, snapshot) {
        final url = snapshot.data?.logoUrl;
        if (url != null && url.isNotEmpty) {
          return CachedNetworkImage(
            imageUrl: url,
            height: altura,
            filterQuality: FilterQuality.high,
            errorWidget: (context, url, error) => _logoPorDefecto(),
          );
        }
        return _logoPorDefecto();
      },
    );
  }

  Widget _logoPorDefecto() {
    return Image.asset(
      'assets/images/logo.png',
      height: altura,
      filterQuality: FilterQuality.high,
      errorBuilder: (context, error, stackTrace) => Text(
        '🌱',
        style: TextStyle(fontSize: altura * 0.75),
      ),
    );
  }
}
