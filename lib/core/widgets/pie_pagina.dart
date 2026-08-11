import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../catalogos.dart';
import '../../models/configuracion_sitio.dart';
import '../../services/configuracion_sitio_service.dart';
import '../../theme/nv_colors.dart';
import 'logo_negocios_verdes.dart';
import 'redes_sociales_cdmb.dart';

/// Pie de página institucional. Se agrega como ÚLTIMO elemento del scroll
/// propio de cada página pública (no vive en SiteShell — ver ese archivo
/// para el porqué). Úsalo en páginas de contenido (inicio, nosotros,
/// contacto, ficha de negocio); en pantallas tipo buscador se omite a
/// propósito para no robarle espacio vertical a resultados/mapa.
///
/// Cuerpo único BLANCO (logo, datos de contacto y redes+copyright al
/// final, todo en la misma tarjeta) y, solo si el admin ya subió los
/// sellos desde /admin/apariencia, la franja azul gov.co (su
/// `.footer-wGovCo` en la Sede Electrónica, rgb(51,102,204) =
/// NVColors.govCoAzul) con los sellos; si no hay sellos, esa franja no
/// aparece. Antes redes+copyright vivían en una franja verde aparte —
/// generaba un bloque de color extra sin aportar nada, así que se movió
/// dentro del cuerpo blanco. Los 4 links de Políticas/Transparencia/Mapa
/// del sitio/Estadísticas de la Sede Electrónica NO se replican — son de
/// esa página, no de este micrositio.
class PiePagina extends StatelessWidget {
  const PiePagina({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _cuerpoBlanco(),
        _franjaSellos(),
      ],
    );
  }

  Widget _cuerpoBlanco() {
    return Container(
      width: double.infinity,
      color: NVColors.superficie,
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const LogoNegociosVerdes(altura: 30),
          const SizedBox(height: 14),
          const Text(
            'CDMB — Corporación Autónoma Regional para la Defensa de la '
            'Meseta de Bucaramanga',
            style: TextStyle(
              color: NVColors.textoPrincipal,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Ventanilla de Negocios Verdes · Directorio de negocios verdes '
            'en los 13 municipios de la jurisdicción CDMB.',
            style: TextStyle(color: NVColors.textoSecundario, fontSize: 13),
          ),
          const SizedBox(height: 18),
          const Divider(color: NVColors.borde, height: 1),
          const SizedBox(height: 16),
          const _FilaDato(icono: Icons.location_on_outlined, texto: kCdmbDireccion),
          const _FilaDato(icono: Icons.schedule_outlined, texto: kCdmbHorario),
          const _FilaDato(
            icono: Icons.call_outlined,
            texto: 'Conmutador $kCdmbTelefonoConmutador · Línea gratuita '
                '$kCdmbLineaGratuita',
          ),
          const _FilaDato(icono: Icons.email_outlined, texto: kCdmbCorreoInstitucional),
          const SizedBox(height: 10),
          const Divider(color: NVColors.borde, height: 1),
          const SizedBox(height: 16),
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 12,
            runSpacing: 10,
            children: [
              Text(
                '© ${DateTime.now().year} CDMB. Todos los derechos reservados.',
                style: const TextStyle(
                    color: NVColors.textoSecundario, fontSize: 12),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Síguenos',
                    style: TextStyle(
                      color: NVColors.textoPrincipal,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 2),
                  const RedesSocialesCdmb(color: NVColors.primary, tamano: 20),
                ],
              ),
            ],
          ),
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
          // Va justo a la derecha del sello de Colombia — mismo orden que
          // pide la identidad de marca país.
          if (config?.logoPotenciaUrl != null &&
              config!.logoPotenciaUrl!.isNotEmpty)
            CachedNetworkImage(imageUrl: config.logoPotenciaUrl!, height: 28),
          if (config?.logoGovcoUrl != null && config!.logoGovcoUrl!.isNotEmpty)
            CachedNetworkImage(imageUrl: config.logoGovcoUrl!, height: 28),
        ];
        if (sellos.isEmpty) return const SizedBox.shrink();
        return Container(
          width: double.infinity,
          color: NVColors.govCoAzul,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
          child: Wrap(spacing: 24, runSpacing: 10, children: sellos),
        );
      },
    );
  }
}

class _FilaDato extends StatelessWidget {
  final IconData icono;
  final String texto;

  const _FilaDato({required this.icono, required this.texto});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icono, color: NVColors.primary, size: 16),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              texto,
              style:
                  const TextStyle(color: NVColors.textoSecundario, fontSize: 12.5),
            ),
          ),
        ],
      ),
    );
  }
}
