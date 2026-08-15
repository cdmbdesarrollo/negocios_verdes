import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'responsive.dart';
import 'widgets/logo_negocios_verdes.dart';
import '../services/auth_service.dart';
import '../services/roles_service.dart';
import '../theme/nv_colors.dart';

class EnlaceAdmin {
  final String titulo;
  final String ruta;
  final IconData icono;
  const EnlaceAdmin(this.titulo, this.ruta, this.icono);
}

const List<EnlaceAdmin> enlacesAdmin = [
  EnlaceAdmin('Panel', '/admin', Icons.dashboard_outlined),
  EnlaceAdmin('Negocios', '/admin/negocios', Icons.storefront_outlined),
  EnlaceAdmin('Categorías', '/admin/categorias', Icons.category_outlined),
  EnlaceAdmin('Subcategorías', '/admin/subcategorias', Icons.label_outline),
  EnlaceAdmin('Actividades productivas', '/admin/actividades', Icons.eco_outlined),
  EnlaceAdmin('Apariencia', '/admin/apariencia', Icons.palette_outlined),
  EnlaceAdmin('Auditoría', '/admin/logs', Icons.history),
];

/// Un enlace está "activo" si la ruta actual es exactamente la suya, o cae
/// dentro de ella (p. ej. /admin/negocios/nuevo debe resaltar "Negocios") —
/// excepto para el propio /admin, donde un match por prefijo resaltaría
/// "Panel" en cualquier otra sección.
bool _enlaceActivo(String rutaActual, EnlaceAdmin enlace) {
  if (enlace.ruta == '/admin') return rutaActual == '/admin';
  return rutaActual == enlace.ruta || rutaActual.startsWith('${enlace.ruta}/');
}

String _tituloSeccion(String rutaActual) {
  for (final enlace in enlacesAdmin) {
    if (_enlaceActivo(rutaActual, enlace)) return enlace.titulo;
  }
  return 'Panel administrativo';
}

/// Shell del panel administrativo. En pantalla ancha, barra lateral fija
/// (sin drawer que abrir/cerrar en cada navegación — el patrón anterior de
/// drawer-siempre era fricción real para un panel de uso diario); en
/// pantalla angosta, vuelve al patrón de AppBar + drawer. Envuelve
/// /admin/* (excepto /admin/login) vía ShellRoute en main.dart. Este shell
/// solo da la navegación — la verificación real de rol la hace
/// exigirAdmin() (admin_guard.dart) en cada página hija, y el límite de
/// seguridad de verdad son las políticas RLS, no este widget.
class AdminShellPage extends StatelessWidget {
  final Widget child;

  const AdminShellPage({super.key, required this.child});

  Future<void> _cerrarSesion(BuildContext context) async {
    await AuthService().logout();
    RolesService.invalidarCache();
    if (context.mounted) context.go('/admin/login');
  }

  @override
  Widget build(BuildContext context) {
    final rutaActual = GoRouterState.of(context).matchedLocation;

    if (esPantallaAncha(context)) {
      return Scaffold(
        body: Row(
          children: [
            _BarraLateral(rutaActual: rutaActual, onLogout: () => _cerrarSesion(context)),
            Expanded(
              child: Column(
                children: [
                  _EncabezadoSuperior(titulo: _tituloSeccion(rutaActual)),
                  Expanded(child: child),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: NVColors.primaryDark,
        foregroundColor: Colors.white,
        title: Text(_tituloSeccion(rutaActual)),
        actions: [
          IconButton(
            tooltip: 'Cerrar sesión',
            icon: const Icon(Icons.logout),
            onPressed: () => _cerrarSesion(context),
          ),
        ],
      ),
      drawer: Drawer(
        child: SafeArea(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(color: NVColors.primaryDark),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      LogoNegociosVerdes(altura: 26),
                      SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          'Negocios Verdes CDMB',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              for (final enlace in enlacesAdmin)
                ListTile(
                  leading: Icon(enlace.icono),
                  title: Text(enlace.titulo),
                  selected: _enlaceActivo(rutaActual, enlace),
                  selectedColor: NVColors.primary,
                  onTap: () {
                    Navigator.of(context).pop();
                    context.go(enlace.ruta);
                  },
                ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.public),
                title: const Text('Ver sitio público'),
                onTap: () {
                  Navigator.of(context).pop();
                  context.go('/');
                },
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(child: child),
    );
  }
}

class _BarraLateral extends StatelessWidget {
  final String rutaActual;
  final VoidCallback onLogout;

  const _BarraLateral({required this.rutaActual, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      color: NVColors.primaryDark,
      child: SafeArea(
        right: false,
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 24, 20, 20),
              child: Row(
                children: [
                  LogoNegociosVerdes(altura: 30),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Negocios Verdes CDMB',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                children: [
                  for (final enlace in enlacesAdmin)
                    _itemBarra(
                      context,
                      icono: enlace.icono,
                      titulo: enlace.titulo,
                      activo: _enlaceActivo(rutaActual, enlace),
                      onTap: () => context.go(enlace.ruta),
                    ),
                ],
              ),
            ),
            const Divider(color: Colors.white24, height: 1),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  _itemBarra(
                    context,
                    icono: Icons.public,
                    titulo: 'Ver sitio público',
                    activo: false,
                    onTap: () => context.go('/'),
                  ),
                  _itemBarra(
                    context,
                    icono: Icons.logout,
                    titulo: 'Cerrar sesión',
                    activo: false,
                    onTap: onLogout,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _itemBarra(
    BuildContext context, {
    required IconData icono,
    required String titulo,
    required bool activo,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Material(
        // Relleno completo de verdeVivo en el ítem activo (no solo un
        // tinte) -- pedido explícito. Ícono/texto pasan de blanco a
        // textoPrincipal SOLO en el activo (los inactivos se quedan
        // blancos, siguen sobre el fondo oscuro de siempre): blanco sobre
        // verdeVivo da ~2.5:1, muy poco para leer bien; textoPrincipal
        // sobre verdeVivo da ~6:1.
        color: activo ? NVColors.verdeVivo : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                Icon(icono,
                    color: activo
                        ? NVColors.textoPrincipal
                        : Colors.white70,
                    size: 20),
                const SizedBox(width: 12),
                Text(
                  titulo,
                  style: TextStyle(
                    color: activo ? NVColors.textoPrincipal : Colors.white70,
                    fontWeight: activo ? FontWeight.w600 : FontWeight.normal,
                    fontSize: 13.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EncabezadoSuperior extends StatelessWidget {
  final String titulo;

  const _EncabezadoSuperior({required this.titulo});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: NVColors.superficie,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: NVColors.borde)),
      ),
      child: Text(
        titulo,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
      ),
    );
  }
}
