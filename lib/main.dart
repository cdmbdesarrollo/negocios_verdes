import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'config/supabase_config.dart';
import 'core/admin_shell_page.dart';
import 'core/base_page.dart';
import 'core/site_shell.dart';
import 'pages/admin/actividades/admin_actividades_page.dart';
import 'pages/admin/apariencia/admin_apariencia_page.dart';
import 'pages/admin/categorias/admin_categorias_page.dart';
import 'pages/admin/cuenta/admin_cuenta_page.dart';
import 'pages/admin/dashboard/admin_dashboard_page.dart';
import 'pages/admin/login/admin_login_page.dart';
import 'pages/admin/logs/admin_logs_page.dart';
import 'pages/admin/negocios/admin_negocio_form_page.dart';
import 'pages/admin/negocios/admin_negocios_page.dart';
import 'pages/admin/personas/admin_personas_page.dart';
import 'pages/admin/subcategorias/admin_subcategorias_page.dart';
import 'pages/admin/usuarios/admin_usuarios_page.dart';
import 'pages/buscar/buscar_page.dart';
import 'pages/estaticas/contacto_page.dart';
import 'pages/estaticas/no_encontrado_page.dart';
import 'pages/estaticas/nosotros_page.dart';
import 'pages/estaticas/plan_nacional_page.dart';
import 'pages/geovisor/geovisor_page.dart';
import 'pages/inicio/inicio_page.dart';
import 'pages/negocio_detalle/negocio_detalle_page.dart';
import 'theme/nv_theme.dart';

late final GoRouter appRouter;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // URLs limpias (sin #) en Flutter Web.
  usePathUrlStrategy();

  // Necesario para DateFormat(patron, 'es_CO') en admin_logs_page.dart y
  // cualquier otro formateo de fecha en español — sin esto, DateFormat con
  // locale explícito lanza LocaleDataException.
  await initializeDateFormatting('es_CO');

  // Falla ruidoso en vez de dejar la app arrancar a medias sin backend.
  validarConfiguracion();

  FlutterError.onError = (details) {
    FlutterError.presentError(details);
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    debugPrint('Error no capturado: $error\n$stack');
    return true;
  };
  ErrorWidget.builder = (details) {
    return const Material(
      color: Color(0xFFFAF8F3),
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'Ocurrió un error inesperado. Por favor recarga la página.',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  };

  // publishableKey (no anonKey, deprecado desde supabase_flutter 2.17):
  // mismo valor, terminología nueva del SDK — sigue siendo seguro traerlo
  // al cliente, la protección real son las políticas RLS.
  await Supabase.initialize(url: supabaseUrl, publishableKey: supabaseAnonKey);

  appRouter = _construirRouter();

  runApp(const NegociosVerdesApp());
}

class NegociosVerdesApp extends StatelessWidget {
  const NegociosVerdesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Negocios Verdes CDMB',
      debugShowCheckedModeBanner: false,
      theme: NVTheme.light,
      routerConfig: appRouter,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('es', 'CO')],
      locale: const Locale('es', 'CO'),
    );
  }
}

GoRouter _construirRouter() {
  return GoRouter(
    initialLocation: '/',
    refreshListenable: _GoRouterRefreshStream(
      Supabase.instance.client.auth.onAuthStateChange,
    ),
    redirect: (context, state) {
      final haySesion = Supabase.instance.client.auth.currentSession != null;
      final vaAdmin = state.matchedLocation.startsWith('/admin');
      final esLogin = state.matchedLocation == '/admin/login';

      // Router-level: solo presencia de sesión. El rol is_admin puntual lo
      // valida cada página admin con exigirAdmin() — la seguridad real de
      // todas formas vive en las políticas RLS, no en este redirect.
      if (vaAdmin && !esLogin && !haySesion) {
        return '/admin/login';
      }
      if (esLogin && haySesion) {
        return '/admin';
      }
      return null;
    },
    errorBuilder: (context, state) => const NoEncontradoPage(),
    routes: [
      ShellRoute(
        builder: (context, state, child) => SiteShell(child: child),
        routes: [
          GoRoute(path: '/', builder: (context, state) => const InicioPage()),
          GoRoute(
            path: '/buscar',
            builder: (context, state) => const BuscarPage(),
          ),
          GoRoute(
            path: '/geovisor',
            builder: (context, state) => GeovisorPage(
              municipioInicial: state.uri.queryParameters['mun'],
              reconInicial: state.uri.queryParameters['rec'],
              sinCategoriasInicial: state.uri.queryParameters['sincat'],
              zonaInicial: state.uri.queryParameters['zona'],
              anioInicial: state.uri.queryParameters['anio'],
            ),
          ),
          GoRoute(
            path: '/negocio/:slug',
            builder: (context, state) => NegocioDetallePage(
              slug: state.pathParameters['slug']!,
            ),
          ),
          GoRoute(
            path: '/nosotros',
            builder: (context, state) => const NosotrosPage(),
          ),
          GoRoute(
            path: '/plan-nacional',
            builder: (context, state) => const PlanNacionalPage(),
          ),
          GoRoute(
            path: '/contacto',
            builder: (context, state) => const ContactoPage(),
          ),
        ],
      ),
      // Geovisor incrustable — sin navbar ni pie, para <iframe> en otra web.
      GoRoute(
        path: '/geovisor/embed',
        builder: (context, state) => Scaffold(
          body: GeovisorPage(
            embed: true,
            municipioInicial: state.uri.queryParameters['mun'],
            reconInicial: state.uri.queryParameters['rec'],
            sinCategoriasInicial: state.uri.queryParameters['sincat'],
            zonaInicial: state.uri.queryParameters['zona'],
            anioInicial: state.uri.queryParameters['anio'],
          ),
        ),
      ),
      GoRoute(
        path: '/admin/login',
        builder: (context, state) => const BasePage(
          titulo: 'Acceso administrador',
          child: AdminLoginPage(),
        ),
      ),
      ShellRoute(
        builder: (context, state, child) => AdminShellPage(child: child),
        routes: [
          GoRoute(
            path: '/admin',
            builder: (context, state) => const AdminDashboardPage(),
          ),
          GoRoute(
            path: '/admin/negocios',
            builder: (context, state) => const AdminNegociosPage(),
          ),
          GoRoute(
            path: '/admin/negocios/nuevo',
            builder: (context, state) => const AdminNegocioFormPage(),
          ),
          GoRoute(
            path: '/admin/negocios/:id/editar',
            builder: (context, state) => AdminNegocioFormPage(
              negocioId: state.pathParameters['id'],
            ),
          ),
          GoRoute(
            path: '/admin/personas',
            builder: (context, state) => const AdminPersonasPage(),
          ),
          GoRoute(
            path: '/admin/categorias',
            builder: (context, state) => const AdminCategoriasPage(),
          ),
          GoRoute(
            path: '/admin/subcategorias',
            builder: (context, state) => const AdminSubcategoriasPage(),
          ),
          GoRoute(
            path: '/admin/actividades',
            builder: (context, state) => const AdminActividadesPage(),
          ),
          GoRoute(
            path: '/admin/apariencia',
            builder: (context, state) => const AdminAparienciaPage(),
          ),
          GoRoute(
            path: '/admin/usuarios',
            builder: (context, state) => const AdminUsuariosPage(),
          ),
          GoRoute(
            path: '/admin/cuenta',
            builder: (context, state) => const AdminCuentaPage(),
          ),
          GoRoute(
            path: '/admin/logs',
            builder: (context, state) => const AdminLogsPage(),
          ),
        ],
      ),
    ],
  );
}

/// Hace que GoRouter reevalúe redirect() cuando cambia el estado de auth
/// (login/logout) sin depender de que cada botón navegue manualmente.
class _GoRouterRefreshStream extends ChangeNotifier {
  _GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
