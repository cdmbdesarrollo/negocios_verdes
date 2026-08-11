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
