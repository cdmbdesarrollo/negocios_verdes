import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../catalogos.dart';

/// Íconos de redes sociales institucionales de la CDMB — mismos enlaces que
/// en su Sede Electrónica (ver constantes kCdmb* en catalogos.dart).
///
/// Material Icons no trae íconos de marca para X/Twitter ni YouTube (solo
/// tiene el de Facebook) — se usan íconos genéricos razonablemente
/// asociados en vez de sumar una dependencia nueva solo para 2 glifos.
class RedesSocialesCdmb extends StatelessWidget {
  final Color color;
  final double tamano;

  const RedesSocialesCdmb({super.key, required this.color, this.tamano = 22});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _boton(Icons.facebook, kCdmbFacebookUrl, 'Facebook'),
        _boton(Icons.alternate_email, kCdmbTwitterUrl, 'Twitter / X'),
        _boton(Icons.smart_display_outlined, kCdmbYoutubeUrl, 'YouTube'),
        _boton(Icons.camera_alt_outlined, kCdmbInstagramUrl, 'Instagram'),
      ],
    );
  }

  Widget _boton(IconData icono, String url, String etiqueta) {
    return IconButton(
      tooltip: etiqueta,
      icon: Icon(icono, color: color, size: tamano),
      onPressed: () async {
        final uri = Uri.tryParse(url);
        if (uri == null) return;
        await launchUrl(uri, webOnlyWindowName: '_blank');
      },
    );
  }
}
