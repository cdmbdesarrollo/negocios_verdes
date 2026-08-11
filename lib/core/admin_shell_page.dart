import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../services/auth_service.dart';
import '../services/roles_service.dart';
import '../theme/nv_colors.dart';
import 'widgets/logo_negocios_verdes.dart';

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
  EnlaceAdmin('Apariencia', '/admin/apariencia', Icons.palette_outlined),
  EnlaceAdmin('Auditoría', '/admin/logs', Icons.history),
];

/// Shell del panel administrativo: drawer + AppBar propia. Envuelve
/// /admin/* (excepto /admin/login) vía ShellRoute en main.dart. Este shell
/// solo da la navegación — la verificación real de rol la hace
/// exigirAdmin() (admin_guard.dart) en cada página hija, y el límite de
/// seguridad de verdad son las políticas RLS, no este widget.
class AdminShellPage extends StatelessWidget {
  final Widget child;

  const AdminShellPage({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final rutaActual = GoRouterState.of(context).matchedLocation;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: NVColors.primaryDark,
        foregroundColor: Colors.white,
        title: const Text('Panel administrativo'),
        actions: [
          IconButton(
            tooltip: 'Cerrar sesión',
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await AuthService().logout();
              RolesService.invalidarCache();
              if (context.mounted) context.go('/admin/login');
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: SafeArea(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(color: NVColors.primaryDark),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const LogoNegociosVerdes(altura: 26),
                      const SizedBox(width: 8),
                      const Flexible(
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
                  selected: rutaActual == enlace.ruta,
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
