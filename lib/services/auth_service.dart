import 'package:supabase_flutter/supabase_flutter.dart';

/// Envoltura delgada sobre el auth de Supabase. Sin cuentas públicas en
/// este proyecto — solo entra quien ya tiene una fila en "perfiles"
/// (staff de CDMB creado desde el Dashboard, ver 0010_seed_admin.sql).
class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Session? get sesionActual => _supabase.auth.currentSession;
  User? get usuarioActual => _supabase.auth.currentUser;
  bool get haySesion => sesionActual != null;

  Stream<AuthState> get cambiosDeSesion => _supabase.auth.onAuthStateChange;

  Future<void> login(String email, String password) async {
    try {
      await _supabase.auth.signInWithPassword(email: email, password: password);
    } on AuthException catch (e) {
      throw Exception(_mensajeAmigable(e));
    } catch (e) {
      throw Exception('No se pudo iniciar sesión: $e');
    }
  }

  Future<void> logout() async {
    try {
      await _supabase.auth.signOut();
    } catch (e) {
      throw Exception('No se pudo cerrar sesión: $e');
    }
  }

  String _mensajeAmigable(AuthException e) {
    final msg = e.message.toLowerCase();
    if (msg.contains('invalid login credentials')) {
      return 'Correo o contraseña incorrectos.';
    }
    if (msg.contains('email not confirmed')) {
      return 'Este correo todavía no está confirmado.';
    }
    return e.message;
  }
}
