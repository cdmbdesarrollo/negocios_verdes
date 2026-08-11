import 'package:supabase_flutter/supabase_flutter.dart';

/// Cache estático en memoria — evita re-consultar "perfiles" en cada guard
/// de página. Fail-closed: cualquier error o falta de sesión = no admin.
/// El enforcement real vive en las políticas RLS de cada tabla; esto es
/// solo para decidir qué mostrar en la UI.
class RolesService {
  static bool? _esAdminCache;
  static String? _usuarioIdCache;

  static Future<bool> esAdmin() async {
    final supabase = Supabase.instance.client;
    final usuario = supabase.auth.currentUser;
    if (usuario == null) {
      invalidarCache();
      return false;
    }

    if (_esAdminCache != null && _usuarioIdCache == usuario.id) {
      return _esAdminCache!;
    }

    try {
      final data = await supabase
          .from('perfiles')
          .select('is_admin')
          .eq('id', usuario.id)
          .maybeSingle();

      final esAdmin = data?['is_admin'] as bool? ?? false;
      _esAdminCache = esAdmin;
      _usuarioIdCache = usuario.id;
      return esAdmin;
    } catch (_) {
      return false;
    }
  }

  static void invalidarCache() {
    _esAdminCache = null;
    _usuarioIdCache = null;
  }
}
