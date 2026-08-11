import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../models/negocio_foto.dart';
import '../../../../services/storage_service.dart';
import '../../../../theme/nv_colors.dart';

const int _maxFotosGaleria = 5;
const int _maxBytesPorFoto = 8 * 1024 * 1024; // 8 MB
const Set<String> _extensionesNoSoportadas = {'heic', 'heif'};

class FotoLocal {
  final String url;
  final String storagePath;
  const FotoLocal({required this.url, required this.storagePath});
}

/// Sección de fotos del formulario de negocio: portada (obligatoria para
/// poder publicar) + galería (hasta 5). Sube cada imagen a Storage apenas se
/// selecciona (con un nombre único, ver StorageService) y avisa al
/// formulario padre del estado actual vía los callbacks — el padre solo
/// necesita el resultado final al guardar, no gestiona la subida.
///
/// Sin redimensionado/compresión automática en esta primera versión — solo
/// se valida tamaño máximo (8 MB) y se rechaza HEIC/HEIF (muchos navegadores
/// no lo decodifican, típico de fotos de iPhone).
class GaleriaEditor extends StatefulWidget {
  final String negocioId;
  final String? portadaUrlInicial;
  final String? portadaPathInicial;
  final List<NegocioFoto> galeriaInicial;
  final void Function(String? url, String? path) onPortadaCambiada;
  final void Function(List<FotoLocal> fotos) onGaleriaCambiada;

  const GaleriaEditor({
    super.key,
    required this.negocioId,
    this.portadaUrlInicial,
    this.portadaPathInicial,
    this.galeriaInicial = const [],
    required this.onPortadaCambiada,
    required this.onGaleriaCambiada,
  });

  @override
  State<GaleriaEditor> createState() => _GaleriaEditorState();
}

class _GaleriaEditorState extends State<GaleriaEditor> {
  final _storage = StorageService();
  final _picker = ImagePicker();

  String? _portadaUrl;
  String? _portadaPath;
  bool _subiendoPortada = false;

  late List<FotoLocal> _galeria;
  bool _subiendoGaleria = false;

  @override
  void initState() {
    super.initState();
    _portadaUrl = widget.portadaUrlInicial;
    _portadaPath = widget.portadaPathInicial;
    _galeria = widget.galeriaInicial
        .map((f) => FotoLocal(url: f.url, storagePath: f.storagePath))
        .toList();
  }

  Future<Uint8List?> _elegirImagen() async {
    final archivo =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 90);
    if (archivo == null) return null;

    final extension = archivo.name.split('.').last.toLowerCase();
    if (_extensionesNoSoportadas.contains(extension)) {
      _avisar(
          'Formato HEIC/HEIF no soportado — exporta la foto como JPG o PNG e intenta de nuevo.');
      return null;
    }

    final bytes = await archivo.readAsBytes();
    if (bytes.lengthInBytes > _maxBytesPorFoto) {
      _avisar('La foto pesa demasiado (máximo 8 MB) — usa una versión más liviana.');
      return null;
    }
    return bytes;
  }

  String _extensionDe(Uint8List bytes) {
    if (bytes.length > 4 && bytes[0] == 0x89 && bytes[1] == 0x50) return 'png';
    return 'jpg';
  }

  void _avisar(String mensaje) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(mensaje)));
  }

  Future<void> _subirPortada() async {
    final bytes = await _elegirImagen();
    if (bytes == null) return;
    setState(() => _subiendoPortada = true);
    try {
      final subida = await _storage.subirImagen(
        bytes: bytes,
        negocioId: widget.negocioId,
        carpeta: 'portada',
        extension: _extensionDe(bytes),
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

  Future<void> _agregarFotoGaleria() async {
    if (_galeria.length >= _maxFotosGaleria) {
      _avisar(
          'Ya tienes $_maxFotosGaleria fotos en la galería — quita alguna para agregar otra.');
      return;
    }
    final bytes = await _elegirImagen();
    if (bytes == null) return;
    setState(() => _subiendoGaleria = true);
    try {
      final subida = await _storage.subirImagen(
        bytes: bytes,
        negocioId: widget.negocioId,
        carpeta: 'galeria',
        extension: _extensionDe(bytes),
      );
      setState(() {
        _galeria = [
          ..._galeria,
          FotoLocal(url: subida.url, storagePath: subida.path),
        ];
      });
      widget.onGaleriaCambiada(_galeria);
    } catch (e) {
      _avisar(e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _subiendoGaleria = false);
    }
  }

  void _quitarFotoGaleria(int indice) {
    setState(() {
      _galeria = List.of(_galeria)..removeAt(indice);
    });
    widget.onGaleriaCambiada(_galeria);
  }

  void _moverFoto(int indice, int direccion) {
    final destino = indice + direccion;
    if (destino < 0 || destino >= _galeria.length) return;
    setState(() {
      final copia = List.of(_galeria);
      final temp = copia[indice];
      copia[indice] = copia[destino];
      copia[destino] = temp;
      _galeria = copia;
    });
    widget.onGaleriaCambiada(_galeria);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Foto de portada', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        const Text(
          'Obligatoria para poder publicar el negocio.',
          style: TextStyle(color: NVColors.textoSecundario, fontSize: 12),
        ),
        const SizedBox(height: 8),
        _slotPortada(),
        const SizedBox(height: 24),
        const Text('Galería de fotos', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(
          'Hasta $_maxFotosGaleria fotos destacadas (${_galeria.length}/$_maxFotosGaleria).',
          style: const TextStyle(color: NVColors.textoSecundario, fontSize: 12),
        ),
        const SizedBox(height: 8),
        _grillaGaleria(),
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
              color: NVColors.primaryLight,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: NVColors.borde),
            ),
            clipBehavior: Clip.antiAlias,
            child: _subiendoPortada
                ? const Center(child: CircularProgressIndicator())
                : (_portadaUrl != null
                    ? CachedNetworkImage(imageUrl: _portadaUrl!, fit: BoxFit.cover)
                    : const Center(
                        child: Icon(Icons.add_a_photo_outlined,
                            size: 40, color: NVColors.primary),
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

  Widget _grillaGaleria() {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        for (var i = 0; i < _galeria.length; i++) _slotGaleria(i),
        if (_galeria.length < _maxFotosGaleria) _slotAgregar(),
      ],
    );
  }

  Widget _slotGaleria(int indice) {
    final foto = _galeria[indice];
    return SizedBox(
      width: 120,
      height: 120,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: NVColors.borde),
            ),
            clipBehavior: Clip.antiAlias,
            child: CachedNetworkImage(imageUrl: foto.url, fit: BoxFit.cover),
          ),
          Positioned(
            top: 4,
            right: 4,
            child: _botonQuitar(onPressed: () => _quitarFotoGaleria(indice)),
          ),
          Positioned(
            bottom: 4,
            left: 4,
            right: 4,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _botonMover(
                    Icons.chevron_left, indice > 0, () => _moverFoto(indice, -1)),
                _botonMover(Icons.chevron_right, indice < _galeria.length - 1,
                    () => _moverFoto(indice, 1)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _slotAgregar() {
    return SizedBox(
      width: 120,
      height: 120,
      child: Material(
        color: NVColors.primaryLight,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: _subiendoGaleria ? null : _agregarFotoGaleria,
          child: _subiendoGaleria
              ? const Center(child: CircularProgressIndicator())
              : const Center(
                  child: Icon(Icons.add_photo_alternate_outlined,
                      color: NVColors.primary, size: 32)),
        ),
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

  Widget _botonMover(IconData icono, bool habilitado, VoidCallback onPressed) {
    return InkWell(
      onTap: habilitado ? onPressed : null,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: habilitado ? Colors.black54 : Colors.black26,
          shape: BoxShape.circle,
        ),
        child: Icon(icono, size: 16, color: Colors.white),
      ),
    );
  }
}
