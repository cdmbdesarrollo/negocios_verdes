import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../services/storage_service.dart';
import '../../theme/nv_colors.dart';
import '../selector_imagen.dart';

/// Slot de ícono de imagen para los diálogos de categoría/subcategoría —
/// sube directo a Storage al elegir el archivo, mismo patrón que el slot
/// de imagen de banners (ver _DialogoBanner en admin_apariencia_page.dart).
/// Opcional a propósito: el emoji de texto sigue funcionando si no se sube
/// nada, así que "Quitar" no rompe el ícono, solo vuelve al emoji.
class SelectorIconoImagen extends StatefulWidget {
  final String carpeta;
  final String? iconoUrlInicial;

  /// null cuando se quita la imagen (volver al emoji).
  final ValueChanged<ImagenSubida?> onCambio;

  const SelectorIconoImagen({
    super.key,
    required this.carpeta,
    required this.iconoUrlInicial,
    required this.onCambio,
  });

  @override
  State<SelectorIconoImagen> createState() => _SelectorIconoImagenState();
}

class _SelectorIconoImagenState extends State<SelectorIconoImagen> {
  final _storage = StorageService();
  String? _url;
  bool _subiendo = false;

  @override
  void initState() {
    super.initState();
    _url = widget.iconoUrlInicial;
  }

  void _avisar(String mensaje) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(mensaje)));
  }

  Future<void> _elegir() async {
    // Todo el flujo dentro del mismo try — antes elegirImagenValidada()
    // quedaba fuera, así que si el selector de archivos del navegador
    // fallaba por cualquier motivo, la excepción no la atrapaba nadie: no
    // pasaba nada visible, ni error ni subida, exactamente el síntoma
    // reportado ("elijo el archivo y no pasa nada").
    try {
      final elegida = await elegirImagenValidada(onError: _avisar);
      if (elegida == null) return;
      if (!mounted) return;
      setState(() => _subiendo = true);
      final subida = await _storage.subirImagen(
        bytes: elegida.bytes,
        bucket: kBucketSitioAssets,
        carpeta: widget.carpeta,
        extension: elegida.extension,
      );
      if (!mounted) return;
      setState(() => _url = subida.url);
      widget.onCambio(subida);
    } catch (e) {
      _avisar(e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _subiendo = false);
    }
  }

  void _quitar() {
    setState(() => _url = null);
    widget.onCambio(null);
  }

  @override
  Widget build(BuildContext context) {
    final tieneImagen = _url != null && _url!.isNotEmpty;
    return Row(
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: NVColors.primaryLight,
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          clipBehavior: Clip.antiAlias,
          child: _subiendo
              ? const Padding(
                  padding: EdgeInsets.all(13),
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : (tieneImagen
                  ? Padding(
                      padding: const EdgeInsets.all(6),
                      child:
                          CachedNetworkImage(imageUrl: _url!, fit: BoxFit.contain),
                    )
                  : const Icon(Icons.image_outlined,
                      color: NVColors.verdeVivo)),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: TextButton(
            onPressed: _subiendo ? null : _elegir,
            child: Text(tieneImagen ? 'Cambiar imagen' : 'Subir imagen (opcional)'),
          ),
        ),
        if (tieneImagen)
          IconButton(
            tooltip: 'Quitar imagen (usar el emoji)',
            icon: const Icon(Icons.close, size: 18),
            onPressed: _subiendo ? null : _quitar,
          ),
      ],
    );
  }
}
