import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/actividad_productiva.dart';

class ActividadProductivaService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<List<ActividadProductiva>> listarTodas({String? subcategoriaId}) async {
    try {
      var query = _supabase.from('actividades_productivas').select();
      if (subcategoriaId != null) {
        query = query.eq('subcategoria_id', subcategoriaId);
      }
      final data = await query.order('orden', ascending: true);
      return (data as List)
          .map((e) => ActividadProductiva.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('No se pudieron cargar las actividades productivas: $e');
    }
  }

  Future<void> crear({
    required String subcategoriaId,
    required String nombre,
    required String slug,
    String? descripcion,
    String? icono,
    String? iconoUrl,
    String? iconoPath,
    int orden = 0,
  }) async {
    try {
      await _supabase.from('actividades_productivas').insert({
        'subcategoria_id': subcategoriaId,
        'nombre': nombre,
        'slug': slug,
        'descripcion': descripcion,
        'icono': icono,
        'icono_url': iconoUrl,
        'icono_path': iconoPath,
        'orden': orden,
      });
    } catch (e) {
      throw Exception('No se pudo crear la actividad productiva: $e');
    }
  }

  Future<void> actualizar({
    required String id,
    required String subcategoriaId,
    required String nombre,
    required String slug,
    String? descripcion,
    String? icono,
    String? iconoUrl,
    String? iconoPath,
    int orden = 0,
  }) async {
    try {
      await _supabase.from('actividades_productivas').update({
        'subcategoria_id': subcategoriaId,
        'nombre': nombre,
        'slug': slug,
        'descripcion': descripcion,
        'icono': icono,
        'icono_url': iconoUrl,
        'icono_path': iconoPath,
        'orden': orden,
      }).eq('id', id);
    } catch (e) {
      throw Exception('No se pudo actualizar la actividad productiva: $e');
    }
  }

  Future<void> alternarActivo(String id, bool activo) async {
    try {
      await _supabase
          .from('actividades_productivas')
          .update({'activo': activo}).eq('id', id);
    } catch (e) {
      throw Exception('No se pudo cambiar el estado de la actividad productiva: $e');
    }
  }

  /// Ver comentario en CategoriaService.contarDependientes — mismo criterio:
  /// avisar con un número real antes de intentar, no solo después de que
  /// falle.
  Future<int> contarNegocios(String actividadId) async {
    final negocios = await _supabase
        .from('negocios_actividades')
        .select('negocio_id')
        .eq('actividad_productiva_id', actividadId);
    return (negocios as List).length;
  }

  Future<void> eliminar(String id) async {
    try {
      await _supabase.from('actividades_productivas').delete().eq('id', id);
    } catch (e) {
      throw Exception(
          'No se pudo eliminar la actividad productiva (puede que algún negocio todavía la use): $e');
    }
  }
}
