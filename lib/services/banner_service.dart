import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/banner_sitio.dart';

class BannerService {
  final SupabaseClient _supabase = Supabase.instance.client;

  /// Público — solo banners activos, en el orden configurado.
  Future<List<BannerSitio>> listarActivos() async {
    try {
      final data = await _supabase
          .from('banners')
          .select()
          .eq('activo', true)
          .order('orden', ascending: true);
      return (data as List)
          .map((e) => BannerSitio.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('No se pudieron cargar los banners: $e');
    }
  }

  /// Admin — todos, activos e inactivos.
  Future<List<BannerSitio>> listarTodos() async {
    try {
      final data = await _supabase
          .from('banners')
          .select()
          .order('orden', ascending: true);
      return (data as List)
          .map((e) => BannerSitio.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('No se pudieron cargar los banners: $e');
    }
  }

  Future<void> crear({
    required String imagenUrl,
    required String imagenPath,
    String? urlDestino,
    required bool abrirEnPestanaNueva,
    required int orden,
  }) async {
    try {
      await _supabase.from('banners').insert({
        'imagen_url': imagenUrl,
        'imagen_path': imagenPath,
        'url_destino': urlDestino,
        'abrir_en_pestana_nueva': abrirEnPestanaNueva,
        'orden': orden,
      });
    } catch (e) {
      throw Exception('No se pudo crear el banner: $e');
    }
  }

  Future<void> actualizar({
    required String id,
    String? urlDestino,
    required bool abrirEnPestanaNueva,
    required int orden,
  }) async {
    try {
      await _supabase.from('banners').update({
        'url_destino': urlDestino,
        'abrir_en_pestana_nueva': abrirEnPestanaNueva,
        'orden': orden,
      }).eq('id', id);
    } catch (e) {
      throw Exception('No se pudo actualizar el banner: $e');
    }
  }

  Future<void> alternarActivo(String id, bool activo) async {
    try {
      await _supabase.from('banners').update({'activo': activo}).eq('id', id);
    } catch (e) {
      throw Exception('No se pudo cambiar el estado del banner: $e');
    }
  }

  Future<void> eliminar(String id) async {
    try {
      await _supabase.from('banners').delete().eq('id', id);
    } catch (e) {
      throw Exception('No se pudo eliminar el banner: $e');
    }
  }
}
