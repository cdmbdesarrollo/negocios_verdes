import 'package:supabase_flutter/supabase_flutter.dart';

/// Cache estático en memoria — evita re-consultar "perfiles" en cada guard
/// de página. Fail-closed: cualquier error o falta de sesión = sin permiso.
/// El enforcement real vive en las políticas RLS de cada tabla; esto es
/// solo para decidir qué mostrar en la UI.
///
/// Dos niveles (ver 0039): `esAdmin` (gestiona negocios/personas) y
/// `esSuperAdmin` (además, cuentas de usuario + taxonomía + apariencia).
/// Un súper admin es siempre admin.
class RolesService {
  static bool? _esAdminCache;
  static bool? _esSuperAdminCache;
  static String? _usuarioIdCache;

  static Future<void> _cargar() async {
    final supabase = Supabase.instance.client;
    final usuario = supabase.auth.currentUser;
    if (usuario == null) {
      invalidarCache();
      return;
    }
    if (_usuarioIdCache == usuario.id && _esAdminCache != null) return;

    try {
      final data = await supabase
          .from('perfiles')
          .select('is_admin, es_super_admin, activo')
          .eq('id', usuario.id)
          .maybeSingle();

      final activo = data?['activo'] as bool? ?? false;
      final esSuper = activo && (data?['es_super_admin'] as bool? ?? false);
      final esAdmin =
          activo && (esSuper || (data?['is_admin'] as bool? ?? false));
      _esSuperAdminCache = esSuper;
      _esAdminCache = esAdmin;
      _usuarioIdCache = usuario.id;
    } catch (_) {
      _esAdminCache = false;
      _esSuperAdminCache = false;
      _usuarioIdCache = usuario.id;
    }
  }

  static Future<bool> esAdmin() async {
    await _cargar();
    return _esAdminCache ?? false;
  }

  static Future<bool> esSuperAdmin() async {
    await _cargar();
    return _esSuperAdminCache ?? false;
  }

  static void invalidarCache() {
    _esAdminCache = null;
    _esSuperAdminCache = null;
    _usuarioIdCache = null;
  }
}
