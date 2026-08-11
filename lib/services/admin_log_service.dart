import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/admin_log.dart';

/// Solo lectura a propósito: los únicos inserts vienen de la RPC
/// guardar_negocio() (ver NegocioService.guardar), nunca desde el cliente.
class AdminLogService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<List<AdminLog>> listarRecientes({int limite = 100}) async {
    try {
      final data = await _supabase
          .from('admin_logs')
          .select()
          .order('created_at', ascending: false)
          .limit(limite);
      return (data as List)
          .map((e) => AdminLog.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('No se pudo cargar el registro de auditoría: $e');
    }
  }
}
