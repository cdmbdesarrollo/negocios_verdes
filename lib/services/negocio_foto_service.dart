import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/negocio_foto.dart';

class NegocioFotoService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<List<NegocioFoto>> listarPorNegocio(String negocioId) async {
    try {
      final data = await _supabase
          .from('negocio_fotos')
          .select()
          .eq('negocio_id', negocioId)
          .order('orden', ascending: true);
      return (data as List)
          .map((e) => NegocioFoto.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('No se pudieron cargar las fotos: $e');
    }
  }

  Future<void> agregar({
    required String negocioId,
    required String url,
    required String storagePath,
    required int orden,
  }) async {
    try {
      await _supabase.from('negocio_fotos').insert({
        'negocio_id': negocioId,
        'url': url,
        'storage_path': storagePath,
        'orden': orden,
      });
    } catch (e) {
      throw Exception('No se pudo agregar la foto: $e');
    }
  }

  Future<void> actualizarOrden(String id, int orden) async {
    try {
      await _supabase.from('negocio_fotos').update({'orden': orden}).eq('id', id);
    } catch (e) {
      throw Exception('No se pudo reordenar la foto: $e');
    }
  }

  /// Borra la fila; borrar el objeto en Storage es responsabilidad de quien
  /// llama (necesita el storage_path, que sí viaja en el modelo NegocioFoto).
  Future<void> eliminar(String id) async {
    try {
      await _supabase.from('negocio_fotos').delete().eq('id', id);
    } catch (e) {
      throw Exception('No se pudo eliminar la foto: $e');
    }
  }
}
