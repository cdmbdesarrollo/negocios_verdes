import 'dart:typed_data';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

const String _bucket = 'negocios-fotos';
const Uuid _uuid = Uuid();

class ImagenSubida {
  final String url;
  final String path;

  const ImagenSubida({required this.url, required this.path});
}

class StorageService {
  final SupabaseClient _supabase = Supabase.instance.client;

  /// Sube una imagen (ya redimensionada/comprimida por quien llama, ver
  /// galeria_editor.dart) al bucket público "negocios-fotos". El nombre de
  /// archivo siempre lleva un uuid nuevo — nunca se reutiliza la misma ruta
  /// al reemplazar una foto, porque cached_network_image (y el caché del
  /// propio navegador) seguirían mostrando la versión vieja indefinidamente
  /// si la URL no cambia.
  Future<ImagenSubida> subirImagen({
    required Uint8List bytes,
    required String negocioId,
    required String carpeta, // 'portada' o 'galeria'
    String extension = 'jpg',
  }) async {
    final nombreArchivo = '${_uuid.v4()}.$extension';
    final path = 'negocios/$negocioId/$carpeta/$nombreArchivo';

    try {
      await _supabase.storage.from(_bucket).uploadBinary(
            path,
            bytes,
            fileOptions: FileOptions(
              contentType: _contentTypePorExtension(extension),
              upsert: false,
            ),
          );
      final url = _supabase.storage.from(_bucket).getPublicUrl(path);
      return ImagenSubida(url: url, path: path);
    } catch (e) {
      throw Exception('No se pudo subir la imagen: $e');
    }
  }

  Future<void> eliminarImagen(String path) async {
    try {
      await _supabase.storage.from(_bucket).remove([path]);
    } catch (e) {
      throw Exception('No se pudo eliminar la imagen: $e');
    }
  }

  String _contentTypePorExtension(String extension) {
    switch (extension.toLowerCase()) {
      case 'png':
        return 'image/png';
      case 'webp':
        return 'image/webp';
      default:
        return 'image/jpeg';
    }
  }
}
