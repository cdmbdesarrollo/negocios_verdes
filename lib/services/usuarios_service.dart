import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/perfil_admin.dart';

/// Cuentas administradoras de CDMB. Las lecturas van directo a `perfiles`
/// (la policy `perfiles_select_super` de 0039 deja ver todas las filas solo
/// a un súper admin). Toda escritura pasa por la Edge Function
/// `admin-usuarios`, que es la única que tiene la service_role para crear
/// usuarios de Auth y que re-verifica el rol del que llama.
class UsuariosService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<List<PerfilAdmin>> listar() async {
    final filas = await _supabase
        .from('perfiles')
        .select('id, email, nombre, is_admin, es_super_admin, activo, created_at')
        .order('created_at');
    return (filas as List)
        .map((f) => PerfilAdmin.fromMap(f as Map<String, dynamic>))
        .toList();
  }

  /// Crea la cuenta de Auth + su fila en `perfiles` en un solo paso.
  /// Devuelve el id del nuevo usuario.
  Future<String> crear({
    required String email,
    required String password,
    String? nombre,
    bool esSuperAdmin = false,
  }) async {
    final data = await _invocar({
      'accion': 'crear',
      'email': email,
      'password': password,
      if (nombre != null && nombre.isNotEmpty) 'nombre': nombre,
      'es_super_admin': esSuperAdmin,
    });
    return data['id'] as String;
  }

  Future<void> cambiarEstado({required String id, required bool activo}) =>
      _invocar({'accion': 'set_estado', 'id': id, 'activo': activo});

  Future<void> cambiarSuperAdmin({
    required String id,
    required bool esSuperAdmin,
  }) =>
      _invocar({'accion': 'set_super', 'id': id, 'es_super_admin': esSuperAdmin});

  Future<Map<String, dynamic>> _invocar(Map<String, dynamic> body) async {
    try {
      final res = await _supabase.functions.invoke('admin-usuarios', body: body);
      final data = res.data;
      if (data is Map && data['error'] != null) {
        throw Exception(data['error'].toString());
      }
      return data is Map<String, dynamic> ? data : <String, dynamic>{};
    } on FunctionException catch (e) {
      final detalle = e.details;
      final msg = detalle is Map && detalle['error'] != null
          ? detalle['error'].toString()
          : (e.reasonPhrase ?? 'No se pudo completar la operación.');
      throw Exception(msg);
    }
  }
}
