import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';

/// Política compartida de qué imágenes se aceptan — un solo lugar si algún
/// día hay que subir/bajar el límite.
const int kMaxBytesImagen = 8 * 1024 * 1024; // 8 MB
const Set<String> _extensionesNoSoportadas = {'heic', 'heif'};

class ImagenElegida {
  final Uint8List bytes;
  final String extension;

  const ImagenElegida({required this.bytes, required this.extension});
}

/// Abre el selector de archivos, valida tamaño y formato, y devuelve los
/// bytes listos para subir. Sin redimensionado/compresión automática todavía
/// — solo se rechaza lo que rompería la experiencia: HEIC/HEIF (muchos
/// navegadores no lo decodifican, típico de fotos de iPhone) y archivos
/// pesados. Devuelve null si el usuario cancela o si la imagen no pasa la
/// validación (ya se avisó el motivo mediante [onError]).
Future<ImagenElegida?> elegirImagenValidada({
  required void Function(String mensaje) onError,
}) async {
  final picker = ImagePicker();
  final archivo =
      await picker.pickImage(source: ImageSource.gallery, imageQuality: 90);
  if (archivo == null) return null;

  final extensionOriginal = archivo.name.split('.').last.toLowerCase();
  if (_extensionesNoSoportadas.contains(extensionOriginal)) {
    onError(
        'Formato HEIC/HEIF no soportado — exporta la imagen como JPG o PNG e intenta de nuevo.');
    return null;
  }

  final bytes = await archivo.readAsBytes();
  if (bytes.lengthInBytes > kMaxBytesImagen) {
    onError('La imagen pesa demasiado (máximo 8 MB) — usa una versión más liviana.');
    return null;
  }

  return ImagenElegida(
    bytes: bytes,
    extension: _extensionFinal(bytes, extensionOriginal),
  );
}

String _extensionFinal(Uint8List bytes, String extensionOriginal) {
  // La firma de bytes manda sobre el nombre de archivo — un PNG renombrado
  // a .jpg sigue siendo PNG.
  if (bytes.length > 4 && bytes[0] == 0x89 && bytes[1] == 0x50) return 'png';
  const validas = {'png', 'jpg', 'jpeg', 'webp'};
  if (validas.contains(extensionOriginal)) {
    return extensionOriginal == 'jpeg' ? 'jpg' : extensionOriginal;
  }
  return 'jpg';
}
