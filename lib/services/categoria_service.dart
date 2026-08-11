import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/categoria_oficial.dart';

class CategoriaService {
  final SupabaseClient _supabase = Supabase.instance.client;

  /// Trae todas (activas e inactivas) — "activo" solo oculta del formulario
  /// de creación, no de la visibilidad pública, así que no se filtra aquí.
  Future<List<CategoriaOficial>> listarTodas() async {
    try {
      final data = await _supabase
          .from('categorias_oficiales')
          .select()
          .order('orden', ascending: true);
      return (data as List)
          .map((e) => CategoriaOficial.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('No se pudieron cargar las categorías: $e');
    }
  }

  Future<void> crear({
    required String nombre,
    required String slug,
    String? descripcion,
    String? icono,
    String? iconoUrl,
    String? iconoPath,
    String? categoriaNacional,
    int orden = 0,
  }) async {
    try {
      await _supabase.from('categorias_oficiales').insert({
        'nombre': nombre,
        'slug': slug,
        'descripcion': descripcion,
        'icono': icono,
        'icono_url': iconoUrl,
        'icono_path': iconoPath,
        'categoria_nacional': categoriaNacional,
        'orden': orden,
      });
    } catch (e) {
      throw Exception('No se pudo crear la categoría: $e');
    }
  }

  Future<void> actualizar({
    required String id,
    required String nombre,
    required String slug,
    String? descripcion,
    String? icono,
    String? iconoUrl,
    String? iconoPath,
    String? categoriaNacional,
    int orden = 0,
  }) async {
    try {
      await _supabase.from('categorias_oficiales').update({
        'nombre': nombre,
        'slug': slug,
        'descripcion': descripcion,
        'icono': icono,
        'icono_url': iconoUrl,
        'icono_path': iconoPath,
        'categoria_nacional': categoriaNacional,
        'orden': orden,
      }).eq('id', id);
    } catch (e) {
      throw Exception('No se pudo actualizar la categoría: $e');
    }
  }

  Future<void> alternarActivo(String id, bool activo) async {
    try {
      await _supabase
          .from('categorias_oficiales')
          .update({'activo': activo}).eq('id', id);
    } catch (e) {
      throw Exception('No se pudo cambiar el estado de la categoría: $e');
    }
  }

  /// Falla con el mensaje del FK "on delete restrict" si algún negocio
  /// todavía usa esta categoría — mensaje se deja pasar tal cual, ya es
  /// suficientemente claro ("violates foreign key constraint").
  Future<void> eliminar(String id) async {
    try {
      await _supabase.from('categorias_oficiales').delete().eq('id', id);
    } catch (e) {
      throw Exception(
          'No se pudo eliminar la categoría (puede que algún negocio todavía la use): $e');
    }
  }
}
