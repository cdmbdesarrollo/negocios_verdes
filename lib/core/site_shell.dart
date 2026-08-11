import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme/nv_colors.dart';
import 'responsive.dart';

class EnlaceNav {
  final String titulo;
  final String ruta;
  const EnlaceNav(this.titulo, this.ruta);
}

const List<EnlaceNav> enlacesNavPublicos = [
  EnlaceNav('Inicio', '/'),
  EnlaceNav('Buscar', '/buscar'),
  EnlaceNav('¿Qué son los Negocios Verdes?', '/nosotros'),
  EnlaceNav('Contacto', '/contacto'),
];

/// Shell público: navbar + menú móvil, sin login. Envuelve todas las rutas
/// públicas vía ShellRoute en main.dart. El pie de página NO vive aquí — es
/// PiePagina (lib/core/widgets/pie_pagina.dart), que cada página agrega como
/// último elemento de su propio scroll (evita el error clásico de anidar un
/// SingleChildScrollView de shell alrededor de páginas que ya traen sus
/// propias listas/mapas con scroll interno).
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

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: NVColors.primaryDark,
        foregroundColor: Colors.white,
        titleSpacing: 16,
        title: InkWell(
          onTap: () => context.go('/'),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('🌱', style: TextStyle(fontSize: 22)),
              SizedBox(width: 8),
              Flexible(
                child: Text(
                  'Negocios Verdes CDMB',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
            ],
          ),
        ),
        actions: [
          if (ancha)
            for (final enlace in enlacesNavPublicos)
              TextButton(
                onPressed: () => context.go(enlace.ruta),
                style: TextButton.styleFrom(foregroundColor: Colors.white),
                child: Text(enlace.titulo),
              )
          else
            IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => _scaffoldKey.currentState?.openEndDrawer(),
            ),
          const SizedBox(width: 8),
        ],
      ),
      endDrawer: ancha ? null : const _MenuMovil(),
      body: widget.child,
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
          ],
        ),
      ),
    );
  }
}
