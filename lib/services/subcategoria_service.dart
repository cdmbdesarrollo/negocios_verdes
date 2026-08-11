import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/subcategoria.dart';

class SubcategoriaService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<List<Subcategoria>> listarTodas({String? categoriaOficialId}) async {
    try {
      var query = _supabase.from('subcategorias').select();
      if (categoriaOficialId != null) {
        query = query.eq('categoria_oficial_id', categoriaOficialId);
      }
      final data = await query.order('orden', ascending: true);
      return (data as List)
          .map((e) => Subcategoria.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('No se pudieron cargar las subcategorías: $e');
    }
  }

  Future<void> crear({
    required String categoriaOficialId,
    required String nombre,
    required String slug,
    String? icono,
    int orden = 0,
  }) async {
    try {
      await _supabase.from('subcategorias').insert({
        'categoria_oficial_id': categoriaOficialId,
        'nombre': nombre,
        'slug': slug,
        'icono': icono,
        'orden': orden,
      });
    } catch (e) {
      throw Exception('No se pudo crear la subcategoría: $e');
    }
  }

  Future<void> actualizar({
    required String id,
    required String categoriaOficialId,
    required String nombre,
    required String slug,
    String? icono,
    int orden = 0,
  }) async {
    try {
      await _supabase.from('subcategorias').update({
        'categoria_oficial_id': categoriaOficialId,
        'nombre': nombre,
        'slug': slug,
        'icono': icono,
        'orden': orden,
      }).eq('id', id);
    } catch (e) {
      throw Exception('No se pudo actualizar la subcategoría: $e');
    }
  }

  Future<void> alternarActivo(String id, bool activo) async {
    try {
      await _supabase.from('subcategorias').update({'activo': activo}).eq('id', id);
    } catch (e) {
      throw Exception('No se pudo cambiar el estado de la subcategoría: $e');
    }
  }

  Future<void> eliminar(String id) async {
    try {
      await _supabase.from('subcategorias').delete().eq('id', id);
    } catch (e) {
      throw Exception(
          'No se pudo eliminar la subcategoría (puede que algún negocio todavía la use): $e');
    }
  }
}
