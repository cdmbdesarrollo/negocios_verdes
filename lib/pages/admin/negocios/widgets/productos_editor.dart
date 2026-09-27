import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../core/selector_imagen.dart';
import '../../../../models/negocio_producto.dart';
import '../../../../services/storage_service.dart';
import '../../../../theme/nv_colors.dart';

const int kMaxProductos = 3;
const int kMaxCaracteresProducto = 300;

/// Los 3 productos destacados del negocio (ver 0040_negocio_productos.sql):
/// cada uno con una foto y una descripción corta. Reemplazaron a la galería
/// de fotos. Mismo contrato que GaleriaEditor: la foto se sube a Storage
/// apenas se elige y el padre recibe el estado completo vía
/// [onProductosCambiados] — solo lo usa al guardar. Siempre entrega los 3
/// espacios; los vacíos se descartan al guardar (NegocioProductoService).
class ProductosEditor extends StatefulWidget {
  final String negocioId;
  final List<NegocioProducto> productosIniciales;
  final void Function(List<NegocioProducto> productos) onProductosCambiados;

  const ProductosEditor({
    super.key,
    required this.negocioId,
    this.productosIniciales = const [],
    required this.onProductosCambiados,
  });

  @override
  State<ProductosEditor> createState() => _ProductosEditorState();
}

class _ProductosEditorState extends State<ProductosEditor> {
  final _storage = StorageService();

  late final List<String?> _fotoUrl;
  late final List<String?> _fotoPath;
  late final List<TextEditingController> _descripcionCtrls;
  final List<bool> _subiendo = List.filled(kMaxProductos, false);

  @override
  void initState() {
    super.initState();
    final iniciales = widget.productosIniciales;
    NegocioProducto? inicial(int i) => i < iniciales.length ? iniciales[i] : null;
    _fotoUrl = [for (var i = 0; i < kMaxProductos; i++) inicial(i)?.fotoUrl];
    _fotoPath = [
      for (var i = 0; i < kMaxProductos; i++) inicial(i)?.fotoStoragePath
    ];
    _descripcionCtrls = [
      for (var i = 0; i < kMaxProductos; i++)
        TextEditingController(text: inicial(i)?.descripcion ?? '')
    ];
  }

  @override
  void dispose() {
    for (final c in _descripcionCtrls) {
      c.dispose();
    }
    super.dispose();
  }

  void _avisar(String mensaje) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(mensaje)));
  }

  void _notificar() {
    widget.onProductosCambiados([
      for (var i = 0; i < kMaxProductos; i++)
        NegocioProducto(
          fotoUrl: _fotoUrl[i],
          fotoStoragePath: _fotoPath[i],
          descripcion: _descripcionCtrls[i].text.trim().isEmpty
              ? null
              : _descripcionCtrls[i].text.trim(),
          orden: i,
        ),
    ]);
  }

  Future<void> _subirFoto(int i) async {
    final elegida = await elegirImagenValidada(onError: _avisar);
    if (elegida == null) return;
    setState(() => _subiendo[i] = true);
    try {
      final subida = await _storage.subirImagen(
        bytes: elegida.bytes,
        bucket: kBucketNegociosFotos,
        carpeta: 'negocios/${widget.negocioId}/productos',
        extension: elegida.extension,
      );
      if (!mounted) return;
      setState(() {
        _fotoUrl[i] = subida.url;
        _fotoPath[i] = subida.path;
      });
      _notificar();
    } catch (e) {
      _avisar(e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _subiendo[i] = false);
    }
  }

  void _quitarFoto(int i) {
    setState(() {
      _fotoUrl[i] = null;
      _fotoPath[i] = null;
    });
    _notificar();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Hasta 3 productos o servicios que el negocio quiere destacar, cada '
          'uno con una foto y una descripción corta. En la ficha pública se '
          'ven en fila, encima del mapa de ubicación. Los espacios vacíos no '
          'se muestran.',
          style: TextStyle(color: NVColors.textoSecundario, fontSize: 12),
        ),
        const SizedBox(height: 10),
        LayoutBuilder(
          builder: (context, c) {
            final columnas = c.maxWidth >= 640 ? kMaxProductos : 1;
            final ancho = (c.maxWidth - (columnas - 1) * 12) / columnas;
            return Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                for (var i = 0; i < kMaxProductos; i++)
                  SizedBox(width: ancho, child: _producto(i)),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _producto(int i) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: NVColors.borde),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Producto ${i + 1}',
              style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          _slotFoto(i),
          const SizedBox(height: 10),
          TextField(
            controller: _descripcionCtrls[i],
            maxLength: kMaxCaracteresProducto,
            minLines: 2,
            maxLines: 4,
            decoration: const InputDecoration(
              labelText: 'Descripción',
              hintText: 'Ej.: Café especial de origen, tostión media',
              alignLabelWithHint: true,
            ),
            onChanged: (_) => _notificar(),
          ),
        ],
      ),
    );
  }

  Widget _slotFoto(int i) {
    final url = _fotoUrl[i];
    final subiendo = _subiendo[i];
    return AspectRatio(
      aspectRatio: 4 / 3,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: BoxDecoration(
              color: NVColors.primaryLight,
              borderRadius: BorderRadius.circular(10),
            ),
            clipBehavior: Clip.antiAlias,
            child: subiendo
                ? const Center(child: CircularProgressIndicator())
                : (url != null
                    ? CachedNetworkImage(imageUrl: url, fit: BoxFit.cover)
                    : const Center(
                        child: Icon(Icons.add_a_photo_outlined,
                            size: 32, color: NVColors.verdeVivo),
                      )),
          ),
          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: subiendo ? null : () => _subirFoto(i),
              ),
            ),
          ),
          if (url != null && !subiendo)
            Positioned(
              top: 6,
              right: 6,
              child: InkWell(
                onTap: () => _quitarFoto(i),
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                      color: Colors.black54, shape: BoxShape.circle),
                  child: const Icon(Icons.close, size: 16, color: Colors.white),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
