import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:image_picker/image_picker.dart';

/// Política compartida de qué imágenes se aceptan — un solo lugar si algún
/// día hay que subir/bajar el límite.
const int kMaxBytesImagen = 1 * 1024 * 1024; // 1 MB
/// Los banners del inicio son imágenes de ancho completo (slider) — pesan
/// más por naturaleza que un logo o un ícono, así que su tope es más alto
/// que el resto de las imágenes del sitio (pedido explícito).
const int kMaxBytesBanner = 1536 * 1024; // 1.5 MB
/// Lado más largo permitido, en píxeles reales de la imagen (no bytes) --
/// un JPEG muy comprimido puede pesar poco pero medir decenas de miles de
/// píxeles de lado. Pasó en producción: un banner de 10000x2639 px pesaba
/// 1.4 MB (pasaba el tope de bytes sin problema) pero no renderizaba en
/// varios celulares reales porque excede el tamaño máximo de textura que
/// soporta su GPU -- se veía perfecto en escritorio/emulador (GPUs más
/// potentes) y en blanco en el teléfono. 2400px cubre de sobra un banner a
/// 1200px de ancho mostrado a densidad 2x (retina) y queda bien por debajo
/// del límite de textura de prácticamente cualquier GPU real.
const int kMaxLadoPx = 2400;
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
  int maxBytes = kMaxBytesImagen,
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
  if (bytes.lengthInBytes > maxBytes) {
    onError(
        'La imagen pesa demasiado (máximo ${_formatoMb(maxBytes)}) — usa una versión más liviana.');
    return null;
  }

  final errorDimensiones = await _validarDimensiones(bytes);
  if (errorDimensiones != null) {
    onError(errorDimensiones);
    return null;
  }

  return ImagenElegida(
    bytes: bytes,
    extension: _extensionFinal(bytes, extensionOriginal),
  );
}

/// null si la imagen mide lo suficientemente poco como para mostrarse en
/// cualquier GPU real; el mensaje de error (listo para [onError]) si no.
Future<String?> _validarDimensiones(Uint8List bytes) async {
  final codec = await ui.instantiateImageCodec(bytes);
  final frame = await codec.getNextFrame();
  final ancho = frame.image.width;
  final alto = frame.image.height;
  frame.image.dispose();
  codec.dispose();
  if (ancho > kMaxLadoPx || alto > kMaxLadoPx) {
    return 'La imagen mide ${ancho}x$alto px (el máximo es ${kMaxLadoPx}px '
        'de lado) — algunos celulares no la mostrarían. Reduce el tamaño '
        'e intenta de nuevo.';
  }
  return null;
}

String _formatoMb(int bytes) {
  final mb = bytes / (1024 * 1024);
  final texto = mb == mb.roundToDouble()
      ? mb.toStringAsFixed(0)
      : mb.toStringAsFixed(1);
  return '$texto MB';
}

/// Igual que [elegirImagenValidada] pero deja elegir varios archivos de una
/// sola vez (selector nativo del navegador con selección múltiple) — para
/// la galería del negocio, que antes obligaba a repetir la acción de subir
/// una por una. Cada archivo se valida por separado (tamaño, formato); los
/// que no pasan se cuentan y se avisan juntos en un solo mensaje al final
/// en vez de interrumpir la selección de los demás. [maximo] recorta la
/// selección si el usuario elige más de los que caben (espacio restante en
/// la galería).
Future<List<ImagenElegida>> elegirImagenesValidadas({
  required void Function(String mensaje) onError,
  int? maximo,
}) async {
  final picker = ImagePicker();
  final archivos = await picker.pickMultiImage(imageQuality: 90);
  if (archivos.isEmpty) return const [];

  final excedente = maximo != null && archivos.length > maximo;
  final seleccionados = excedente ? archivos.sublist(0, maximo) : archivos;

  final validas = <ImagenElegida>[];
  var rechazadas = 0;
  for (final archivo in seleccionados) {
    final extensionOriginal = archivo.name.split('.').last.toLowerCase();
    if (_extensionesNoSoportadas.contains(extensionOriginal)) {
      rechazadas++;
      continue;
    }
    final bytes = await archivo.readAsBytes();
    if (bytes.lengthInBytes > kMaxBytesImagen) {
      rechazadas++;
      continue;
    }
    if (await _validarDimensiones(bytes) != null) {
      rechazadas++;
      continue;
    }
    validas.add(ImagenElegida(
      bytes: bytes,
      extension: _extensionFinal(bytes, extensionOriginal),
    ));
  }

  if (excedente) {
    onError('Solo caben $maximo más — se tomaron las primeras $maximo.');
  }
  if (rechazadas > 0) {
    onError(
        '$rechazadas imagen${rechazadas == 1 ? '' : 'es'} no se ${rechazadas == 1 ? 'subió' : 'subieron'} '
        '(formato HEIC/HEIF, pesa más de 1 MB, o mide más de ${kMaxLadoPx}px de lado).');
  }
  return validas;
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
