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

  /// Solo visible para un súper administrador (ver 0039). Un admin normal
  /// ni ve el enlace ni puede entrar por URL — exigirSuperAdmin() lo
  /// devuelve al panel, y la RLS rechaza sus escrituras.
  final bool soloSuper;

  const EnlaceAdmin(this.titulo, this.ruta, this.icono,
      {this.soloSuper = false});
}

const List<EnlaceAdmin> enlacesAdmin = [
  EnlaceAdmin('Panel', '/admin', Icons.dashboard_outlined),
  EnlaceAdmin('Negocios', '/admin/negocios', Icons.storefront_outlined),
  EnlaceAdmin('Personas', '/admin/personas', Icons.badge_outlined),
  EnlaceAdmin('Categorías', '/admin/categorias', Icons.category_outlined,
      soloSuper: true),
  EnlaceAdmin('Subcategorías', '/admin/subcategorias', Icons.label_outline,
      soloSuper: true),
  EnlaceAdmin('Actividades productivas', '/admin/actividades',
      Icons.eco_outlined,
      soloSuper: true),
  EnlaceAdmin('Apariencia', '/admin/apariencia', Icons.palette_outlined,
      soloSuper: true),
  EnlaceAdmin('Usuarios', '/admin/usuarios', Icons.group_outlined,
      soloSuper: true),
  EnlaceAdmin('Auditoría', '/admin/logs', Icons.history),
  EnlaceAdmin('Mi cuenta', '/admin/cuenta', Icons.account_circle_outlined),
];

List<EnlaceAdmin> _enlacesVisibles(bool esSuper) =>
    enlacesAdmin.where((e) => esSuper || !e.soloSuper).toList();

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
/// exigirAdmin() / exigirSuperAdmin() (admin_guard.dart) en cada página
/// hija, y el límite de seguridad de verdad son las políticas RLS, no este
/// widget. El menú se filtra por rol solo para no mostrar puertas que igual
/// están cerradas.
class AdminShellPage extends StatefulWidget {
  final Widget child;

  const AdminShellPage({super.key, required this.child});

  @override
  State<AdminShellPage> createState() => _AdminShellPageState();
}

class _AdminShellPageState extends State<AdminShellPage> {
  // Arranca en false: si todavía no sabemos el rol, mejor ocultar las
  // secciones de súper admin que mostrarlas y esconderlas medio segundo
  // después.
  bool _esSuper = false;

  @override
  void initState() {
    super.initState();
    _cargarRol();
  }

  Future<void> _cargarRol() async {
    final esSuper = await RolesService.esSuperAdmin();
    if (mounted && esSuper != _esSuper) setState(() => _esSuper = esSuper);
  }

  Future<void> _cerrarSesion() async {
    await AuthService().logout();
    RolesService.invalidarCache();
    if (mounted) context.go('/admin/login');
  }

  @override
  Widget build(BuildContext context) {
    final rutaActual = GoRouterState.of(context).matchedLocation;
    final enlaces = _enlacesVisibles(_esSuper);

    if (esPantallaAncha(context)) {
      return Scaffold(
        body: Row(
          children: [
            _BarraLateral(
              enlaces: enlaces,
              rutaActual: rutaActual,
              onLogout: _cerrarSesion,
            ),
            Expanded(
              child: Column(
                children: [
                  _EncabezadoSuperior(titulo: _tituloSeccion(rutaActual)),
                  Expanded(child: widget.child),
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
            onPressed: _cerrarSesion,
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
              for (final enlace in enlaces)
                ListTile(
                  leading: Icon(enlace.icono),
                  title: Text(enlace.titulo),
                  selected: _enlaceActivo(rutaActual, enlace),
                  // Relleno verdeMenu + texto oscuro en el ítem activo (no
                  // solo texto primary sobre blanco) -- mismo criterio de
                  // contraste que el resto del sitio: blanco encima de un
                  // verde tan claro es difícil de leer, pero un tinte de
                  // texto verde claro sobre fondo blanco también, así que
                  // el relleno pasa a ser el indicador y el texto se queda
                  // oscuro.
                  selectedTileColor: NVColors.verdeMenu,
                  selectedColor: NVColors.textoPrincipal,
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
      body: SafeArea(child: widget.child),
    );
  }
}

class _BarraLateral extends StatelessWidget {
  final List<EnlaceAdmin> enlaces;
  final String rutaActual;
  final VoidCallback onLogout;

  const _BarraLateral({
    required this.enlaces,
    required this.rutaActual,
    required this.onLogout,
  });

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
                  for (final enlace in enlaces)
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
        // verdeMenu (el verde específico confirmado para menús) como
        // relleno completo del ítem activo. Ícono/texto pasan a
        // textoPrincipal SOLO en el activo (los inactivos se quedan
        // blancos, siguen sobre el fondo oscuro de siempre) -- blanco
        // sobre este verde tan claro sería casi ilegible.
        color: activo ? NVColors.verdeMenu : Colors.transparent,
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
