import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../services/roles_service.dart';

/// Llamar desde el initState/postFrameCallback de cada página de /admin/*.
/// Es una capa de UX, no el límite de seguridad real (eso vive en las
/// políticas RLS de cada tabla) — el redirect() del router ya bloquea
/// /admin/* sin sesión; esto además verifica el rol is_admin puntual.
Future<void> exigirAdmin(BuildContext context) async {
  final esAdmin = await RolesService.esAdmin();
  if (!context.mounted) return;
  if (!esAdmin) {
    context.go('/admin/login');
  }
}

/// Para las secciones que solo puede ver un súper administrador (usuarios,
/// categorías, subcategorías, actividades productivas, apariencia). Un
/// admin normal con sesión válida no va al login — va al panel, con un
/// aviso. La RLS de esas tablas ya rechaza sus escrituras de todas formas.
Future<void> exigirSuperAdmin(BuildContext context) async {
  final esSuper = await RolesService.esSuperAdmin();
  if (!context.mounted) return;
  if (esSuper) return;

  final esAdmin = await RolesService.esAdmin();
  if (!context.mounted) return;
  if (!esAdmin) {
    context.go('/admin/login');
    return;
  }
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text('Esta sección es solo para súper administradores.'),
    ),
  );
  context.go('/admin');
}
