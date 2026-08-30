import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../models/configuracion_sitio.dart';
import '../services/configuracion_sitio_service.dart';
import '../theme/nv_colors.dart';
import 'responsive.dart';
import 'widgets/logo_negocios_verdes.dart';

class EnlaceNav {
  final String titulo;
  final String ruta;
  const EnlaceNav(this.titulo, this.ruta);
}

const List<EnlaceNav> enlacesNavPublicos = [
  EnlaceNav('Inicio', '/'),
  EnlaceNav('Buscar', '/buscar'),
  EnlaceNav('Geovisor Negocios Verdes', '/geovisor'),
  EnlaceNav('¿Qué son los Negocios Verdes?', '/nosotros'),
  EnlaceNav('Plan Nacional', '/plan-nacional'),
  EnlaceNav('Contacto', '/contacto'),
];

/// Shell público: franja GOV.CO + header + nav, sin login. Envuelve todas
/// las rutas públicas vía ShellRoute en main.dart. El pie de página NO vive
/// aquí — es PiePagina (lib/core/widgets/pie_pagina.dart), que cada página
/// agrega como último elemento de su propio scroll (evita el error clásico
/// de anidar un SingleChildScrollView de shell alrededor de páginas que ya
/// traen sus propias listas/mapas con scroll interno).
///
/// Estructura calcada de la Sede Electrónica de la CDMB
/// (micolombiadigital.gov.co) de la que este sitio es micrositio: franja
/// azul GOV.CO arriba, header blanco con logo+nombre+buscador, barra de
/// navegación con el ítem activo resaltado en verde institucional, línea
/// verde divisoria. Los datos de contacto/redes sí se replican (mismos de
/// la Sede Electrónica) en PiePagina y en /contacto — ver catalogos.dart.
class SiteShell extends StatefulWidget {
  final Widget child;

  const SiteShell({super.key, required this.child});

  @override
  State<SiteShell> createState() => _SiteShellState();
}

class _SiteShellState extends State<SiteShell> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final ancha = esPantallaAncha(context);
    final rutaActual = GoRouterState.of(context).matchedLocation;

    return Scaffold(
      key: _scaffoldKey,
      endDrawer: ancha ? null : const _MenuMovil(),
      body: Column(
        children: [
          SafeArea(
            bottom: false,
            child: Column(
              children: [
                const _FranjaGovCo(),
                _encabezado(context, ancha, rutaActual),
                // Franja puramente decorativa, sin texto encima -- parte del
                // menú, usa verdeMenu (el verde específico para menús).
                Container(height: 3, color: NVColors.verdeMenu),
              ],
            ),
          ),
          Expanded(child: widget.child),
        ],
      ),
    );
  }

  Widget _encabezado(BuildContext context, bool ancha, String rutaActual) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 4),
      child: Column(
        // Explícito porque el default de Column es center: el Row de
        // logo/buscador no lo notaba (tiene un Expanded que lo fuerza a
        // ancho completo igual), pero el SingleChildScrollView de los
        // enlaces de navegación sí — sin esto quedaba centrado en vez de
        // pegado al borde izquierdo como el resto del sitio.
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () => context.go('/'),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const LogoNegociosVerdes(altura: 36),
                      const SizedBox(width: 10),
                      const Flexible(
                        child: Text(
                          'Negocios Verdes CDMB',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: NVColors.textoPrincipal,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              IconButton(
                tooltip: 'Buscar',
                icon: const Icon(Icons.search, color: NVColors.textoPrincipal),
                onPressed: () => context.go('/buscar'),
              ),
              if (!ancha)
                IconButton(
                  tooltip: 'Abrir menú',
                  icon: const Icon(Icons.menu, color: NVColors.textoPrincipal),
                  onPressed: () => _scaffoldKey.currentState?.openEndDrawer(),
                )
              else
                IconButton(
                  tooltip: 'Acceso administrativo',
                  onPressed: () => context.go('/admin/login'),
                  icon: const Icon(Icons.lock_outline,
                      color: NVColors.textoSecundario),
                ),
            ],
          ),
          if (ancha) ...[
            const SizedBox(height: 4),
            // Scroll horizontal como red de seguridad: con 5 enlaces (uno
            // largo, "¿Qué son los Negocios Verdes?") la fila puede no
            // caber justo cerca del punto de quiebre de 900px — así nunca
            // se desborda, en vez de recortarse en silencio.
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (final enlace in enlacesNavPublicos)
                    _itemNav(context, enlace, rutaActual == enlace.ruta),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _itemNav(BuildContext context, EnlaceNav enlace, bool activo) {
    // Semantics(selected:) además del color: sin esto, un lector de
    // pantalla no tiene forma de saber cuál de los enlaces es la página
    // actual — el color de fondo solo lo comunica visualmente.
    return Semantics(
      selected: activo,
      button: true,
      child: Padding(
        padding: const EdgeInsets.only(right: 4, bottom: 6),
        child: Material(
          // verdeMenu (el verde específico confirmado para menús, distinto
          // de verdeVivo que cubre el resto del sitio) como relleno
          // completo. El texto es textoPrincipal (oscuro): blanco encima
          // de un verde tan claro sería casi ilegible.
          color: activo ? NVColors.verdeMenu : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
          child: InkWell(
            borderRadius: BorderRadius.circular(6),
            onTap: () => context.go(enlace.ruta),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              child: Text(
                enlace.titulo,
                style: TextStyle(
                  color: NVColors.textoPrincipal,
                  fontWeight: activo ? FontWeight.w600 : FontWeight.normal,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Franja institucional obligatoria de GOV.CO — solo aparece si ya se subió
/// el sello desde /admin/apariencia (mismo que se usa en el pie de
/// página); mientras no exista, no se muestra nada, nunca una franja vacía.
class _FranjaGovCo extends StatelessWidget {
  const _FranjaGovCo();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ConfiguracionSitio>(
      future: ConfiguracionSitioCache.obtener(),
      builder: (context, snapshot) {
        final url = snapshot.data?.logoGovcoUrl;
        if (url == null || url.isEmpty) return const SizedBox.shrink();
        return Container(
          width: double.infinity,
          color: NVColors.govCoAzul,
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: CachedNetworkImage(imageUrl: url, height: 20),
        );
      },
    );
  }
}

class _MenuMovil extends StatelessWidget {
  const _MenuMovil();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: NVColors.primaryDark),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  'Negocios Verdes CDMB',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            for (final enlace in enlacesNavPublicos)
              ListTile(
                title: Text(enlace.titulo),
                onTap: () {
                  Navigator.of(context).pop();
                  context.go(enlace.ruta);
                },
              ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.lock_outline),
              title: const Text('Acceso administrativo'),
              onTap: () {
                Navigator.of(context).pop();
                context.go('/admin/login');
              },
            ),
          ],
        ),
      ),
    );
  }
}
