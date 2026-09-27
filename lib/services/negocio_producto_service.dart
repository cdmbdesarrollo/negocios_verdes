import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/negocio_producto.dart';

class NegocioProductoService {
  final SupabaseClient _supabase = Supabase.instance.client;

  /// Borrar+reinsertar, mismo patrón que las tablas puente en
  /// guardar_negocio — a esta escala (3 productos) es más simple y
  /// confiable que diffear altas, bajas y cambios. Los productos vacíos
  /// (sin nombre, foto ni descripción) se descartan. Corre DESPUÉS de que el
  /// negocio ya existe (si no, negocio_id no tendría a qué apuntar).
  Future<void> reemplazar(
      String negocioId, List<NegocioProducto> productos) async {
    try {
      await _supabase
          .from('negocio_productos')
          .delete()
          .eq('negocio_id', negocioId);
      final filas = [
        for (final p in productos.where((p) => !p.estaVacio))
          {
            'negocio_id': negocioId,
            'nombre': p.tieneNombre ? p.nombre : null,
            'foto_url': p.tieneFoto ? p.fotoUrl : null,
            'foto_storage_path': p.tieneFoto ? p.fotoStoragePath : null,
            'descripcion': p.tieneDescripcion ? p.descripcion : null,
          },
      ];
      if (filas.isEmpty) return;
      await _supabase.from('negocio_productos').insert([
        for (var i = 0; i < filas.length; i++) {...filas[i], 'orden': i},
      ]);
    } catch (e) {
      throw Exception('No se pudieron guardar los productos: $e');
    }
  }
}
