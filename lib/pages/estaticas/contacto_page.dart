import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/seo_tags.dart';
import '../../core/widgets/pie_pagina.dart';
import '../../theme/nv_colors.dart';

/// Nota: a propósito NO se inventaron teléfono/correo/dirección exactos de
/// la Ventanilla de Negocios Verdes — solo se muestra lo que se pudo
/// verificar (el sitio oficial de CDMB). Completar con los datos reales de
/// la Ventanilla antes de lanzar.
class ContactoPage extends StatefulWidget {
  const ContactoPage({super.key});

  @override
  State<ContactoPage> createState() => _ContactoPageState();
}

class _ContactoPageState extends State<ContactoPage> {
  @override
  void initState() {
    super.initState();
    establecerSeo(
      titulo: 'Contacto — Negocios Verdes CDMB',
      descripcion:
          'Datos de contacto de la Ventanilla de Negocios Verdes de la CDMB.',
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 640),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Contacto',
                      style:
                          TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Ventanilla de Negocios Verdes — CDMB',
                      style: TextStyle(
                          fontSize: 16, color: NVColors.textoSecundario),
                    ),
                    const SizedBox(height: 24),
                    _filaContacto(
                      icono: Icons.language,
                      texto: 'www.cdmb.gov.co',
                      onTap: () => _abrir('https://www.cdmb.gov.co'),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: NVColors.primaryLight,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'Para consultar teléfono, correo y dirección exactos '
                        'de atención, visita la página oficial de la CDMB. '
                        'Esta ficha se completará con los datos directos de '
                        'la Ventanilla de Negocios Verdes en cuanto estén '
                        'confirmados.',
                        style: TextStyle(color: NVColors.textoPrincipal),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const PiePagina(),
        ],
      ),
    );
  }

  Widget _filaContacto({
    required IconData icono,
    required String texto,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            Icon(icono, color: NVColors.primary),
            const SizedBox(width: 12),
            Text(texto, style: const TextStyle(fontSize: 15)),
          ],
        ),
      ),
    );
  }

  Future<void> _abrir(String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) return;
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}
