import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../core/selector_imagen.dart';
import '../../../../services/storage_service.dart';
import '../../../../theme/nv_colors.dart';

/// Foto de portada/logo del formulario de negocio. Sube la imagen a Storage
/// apenas se selecciona (con un nombre único, ver StorageService) y avisa al
/// formulario padre vía el callback — el padre solo necesita el resultado
/// final al guardar, no gestiona la subida. La galería de fotos que vivía
/// aquí se reemplazó por los 3 productos destacados (ver ProductosEditor y
/// 0040_negocio_productos.sql).
///
/// Sin redimensionado/compresión automática en esta primera versión — solo
/// se valida tamaño máximo (1 MB) y se rechaza HEIC/HEIF (muchos navegadores
/// no lo decodifican, típico de fotos de iPhone).
class GaleriaEditor extends StatefulWidget {
  final String negocioId;
  final String? portadaUrlInicial;
  final String? portadaPathInicial;
  final void Function(String? url, String? path) onPortadaCambiada;

  const GaleriaEditor({
    super.key,
    required this.negocioId,
    this.portadaUrlInicial,
    this.portadaPathInicial,
    required this.onPortadaCambiada,
  });

  @override
  State<GaleriaEditor> createState() => _GaleriaEditorState();
}

class _GaleriaEditorState extends State<GaleriaEditor> {
  final _storage = StorageService();

  String? _portadaUrl;
  String? _portadaPath;
  bool _subiendoPortada = false;

  @override
  void initState() {
    super.initState();
    _portadaUrl = widget.portadaUrlInicial;
    _portadaPath = widget.portadaPathInicial;
  }

  void _avisar(String mensaje) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(mensaje)));
  }

  Future<void> _subirPortada() async {
    final elegida = await elegirImagenValidada(onError: _avisar);
    if (elegida == null) return;
    setState(() => _subiendoPortada = true);
    try {
      final subida = await _storage.subirImagen(
        bytes: elegida.bytes,
        bucket: kBucketNegociosFotos,
        carpeta: 'negocios/${widget.negocioId}/portada',
        extension: elegida.extension,
      );
      setState(() {
        _portadaUrl = subida.url;
        _portadaPath = subida.path;
      });
      widget.onPortadaCambiada(_portadaUrl, _portadaPath);
    } catch (e) {
      _avisar(e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _subiendoPortada = false);
    }
  }

  void _quitarPortada() {
    setState(() {
      _portadaUrl = null;
      _portadaPath = null;
    });
    widget.onPortadaCambiada(null, null);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Foto de portada o logo',
            style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        const Text(
          'Obligatoria para poder publicar el negocio. Puede ser una foto '
          'real o el logo del negocio — se muestra completa, sin recortar '
          'ni estirar.',
          style: TextStyle(color: NVColors.textoSecundario, fontSize: 12),
        ),
        const SizedBox(height: 8),
        _slotPortada(),
      ],
    );
  }

  Widget _slotPortada() {
    return SizedBox(
      width: double.infinity,
      height: 180,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: BoxDecoration(
              // Blanco: así el admin ve exactamente cómo se va a ver en el
              // sitio público (mismo fondo que negocio_card.dart y
              // negocio_detalle_page.dart) — la mayoría de los logos ya
              // traen su propio fondo blanco.
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: NVColors.borde),
            ),
            clipBehavior: Clip.antiAlias,
            padding: const EdgeInsets.all(6),
            alignment: Alignment.center,
            child: _subiendoPortada
                ? const Center(child: CircularProgressIndicator())
                : (_portadaUrl != null
                    ? CachedNetworkImage(imageUrl: _portadaUrl!, fit: BoxFit.contain)
                    : const Center(
                        child: Icon(Icons.add_a_photo_outlined,
                            size: 40, color: NVColors.verdeVivo),
                      )),
          ),
          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: _subiendoPortada ? null : _subirPortada,
              ),
            ),
          ),
          if (_portadaUrl != null && !_subiendoPortada)
            Positioned(
              top: 8,
              right: 8,
              child: _botonQuitar(onPressed: _quitarPortada),
            ),
        ],
      ),
    );
  }

  Widget _botonQuitar({required VoidCallback onPressed}) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration:
            const BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
        child: const Icon(Icons.close, size: 16, color: Colors.white),
      ),
    );
  }
}
