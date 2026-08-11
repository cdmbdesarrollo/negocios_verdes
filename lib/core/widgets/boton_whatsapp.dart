import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../theme/nv_colors.dart';

/// Botón de contacto por WhatsApp. [numeroWhatsapp] debe venir en dígitos
/// con indicativo (ej. "573001234567", ver negocios.whatsapp en el modelo
/// Negocio) — nunca con espacios/guiones, o el link wa.me queda roto.
class BotonWhatsapp extends StatelessWidget {
  final String numeroWhatsapp;
  final String mensaje;
  final bool expandido;

  const BotonWhatsapp({
    super.key,
    required this.numeroWhatsapp,
    required this.mensaje,
    this.expandido = false,
  });

  @override
  Widget build(BuildContext context) {
    final boton = ElevatedButton.icon(
      onPressed: () => _abrirWhatsapp(context),
      style: ElevatedButton.styleFrom(
        backgroundColor: NVColors.whatsapp,
        foregroundColor: Colors.white,
      ),
      icon: const Icon(Icons.chat_bubble),
      label: const Text('Escribir por WhatsApp'),
    );
    return expandido ? SizedBox(width: double.infinity, child: boton) : boton;
  }

  Future<void> _abrirWhatsapp(BuildContext context) async {
    final uri = Uri.parse(
      'https://wa.me/$numeroWhatsapp?text=${Uri.encodeComponent(mensaje)}',
    );
    final abierto = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!abierto && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo abrir WhatsApp.')),
      );
    }
  }
}
