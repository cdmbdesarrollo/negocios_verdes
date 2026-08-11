import 'dart:typed_data';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

/// Fotos de negocios (portada + galería) — admin-only para escribir.
const String kBucketNegociosFotos = 'negocios-fotos';

/// Apariencia del sitio (logo + banners del carrusel) — separado de las
/// fotos de negocios porque semánticamente no es lo mismo, aunque las
/// políticas de acceso sean idénticas.
const String kBucketSitioAssets = 'sitio-assets';

const Uuid _uuid = Uuid();

class ImagenSubida {
  final String url;
  final String path;

  const ImagenSubida({required this.url, required this.path});
}

class StorageService {
  final SupabaseClient _supabase = Supabase.instance.client;

  /// Sube una imagen (ya redimensionada/comprimida por quien llama, ver
  /// galeria_editor.dart) a [bucket], dentro de [carpeta]. El nombre de
  /// archivo siempre lleva un uuid nuevo — nunca se reutiliza la misma ruta
  /// al reemplazar una imagen, porque cached_network_image (y el caché del
  /// propio navegador) seguirían mostrando la versión vieja indefinidamente
  /// si la URL no cambia.
  Future<ImagenSubida> subirImagen({
    required Uint8List bytes,
    required String bucket,
    required String carpeta,
    String extension = 'jpg',
  }) async {
    final nombreArchivo = '${_uuid.v4()}.$extension';
    final path = '$carpeta/$nombreArchivo';

    try {
      await _supabase.storage.from(bucket).uploadBinary(
            path,
            bytes,
            fileOptions: FileOptions(
              contentType: _contentTypePorExtension(extension),
              upsert: false,
            ),
          );
      final url = _supabase.storage.from(bucket).getPublicUrl(path);
      return ImagenSubida(url: url, path: path);
    } catch (e) {
      throw Exception('No se pudo subir la imagen: $e');
    }
  }

  Future<void> eliminarImagen({required String bucket, required String path}) async {
    try {
      await _supabase.storage.from(bucket).remove([path]);
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
