import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../catalogos.dart';
import '../../core/seo_tags.dart';
import '../../core/widgets/pie_pagina.dart';
import '../../core/widgets/redes_sociales_cdmb.dart';
import '../../theme/nv_colors.dart';

/// Los datos de contacto son los mismos, verificados, de la Sede
/// Electrónica de la CDMB (micolombiadigital.gov.co) — ver constantes
/// kCdmb* en catalogos.dart, única fuente de verdad compartida con
/// PiePagina. No hay número/correo específico de la Ventanilla de
/// Negocios Verdes todavía, así que se usa el conmutador institucional.
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
                        icono: Icons.location_on_outlined, texto: kCdmbDireccion),
                    _filaContacto(
                        icono: Icons.schedule_outlined, texto: kCdmbHorario),
                    _filaContacto(
                      icono: Icons.call_outlined,
                      texto: 'Conmutador $kCdmbTelefonoConmutador',
                    ),
                    _filaContacto(
                      icono: Icons.phone_iphone_outlined,
                      texto: 'Celular $kCdmbTelefonoMovil',
                    ),
                    _filaContacto(
                      icono: Icons.support_agent_outlined,
                      texto: 'Línea gratuita $kCdmbLineaGratuita',
                    ),
                    _filaContacto(
                      icono: Icons.email_outlined,
                      texto: kCdmbCorreoInstitucional,
                      onTap: () => _abrir('mailto:$kCdmbCorreoInstitucional'),
                    ),
                    _filaContacto(
                      icono: Icons.language,
                      texto: 'www.cdmb.gov.co',
                      onTap: () => _abrir('https://www.cdmb.gov.co'),
                    ),
                    const SizedBox(height: 12),
                    const RedesSocialesCdmb(color: NVColors.primary),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: NVColors.primaryLight,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'Estos son los canales institucionales de la CDMB. Si '
                        'escribes por un negocio verde, menciona '
                        '"Negocios Verdes" para que te dirijan directo a la '
                        'Ventanilla.',
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icono, color: NVColors.primary, size: 20),
            const SizedBox(width: 12),
            Expanded(child: Text(texto, style: const TextStyle(fontSize: 15))),
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
