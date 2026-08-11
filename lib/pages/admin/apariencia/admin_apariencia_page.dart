import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../core/admin_guard.dart';
import '../../../core/selector_imagen.dart';
import '../../../core/widgets/nv_card.dart';
import '../../../models/banner_sitio.dart';
import '../../../models/configuracion_sitio.dart';
import '../../../services/banner_service.dart';
import '../../../services/configuracion_sitio_service.dart';
import '../../../services/storage_service.dart';
import '../../../theme/nv_colors.dart';

class AdminAparienciaPage extends StatefulWidget {
  const AdminAparienciaPage({super.key});

  @override
  State<AdminAparienciaPage> createState() => _AdminAparienciaPageState();
}

class _AdminAparienciaPageState extends State<AdminAparienciaPage> {
  final _configService = ConfiguracionSitioService();
  final _bannerService = BannerService();
  final _storage = StorageService();

  ConfiguracionSitio? _configuracion;
  List<BannerSitio> _banners = [];
  bool _cargando = true;
  String? _error;

  /// Cuál de los 3 slots de imagen está subiendo ahora mismo (o ninguno) —
  /// evita tener tres banderas booleanas sueltas para lo mismo.
  _SlotImagenConfig? _subiendo;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => exigirAdmin(context));
    _cargar();
  }

  Future<void> _cargar() async {
    try {
      final resultados = await Future.wait([
        _configService.obtener(),
        _bannerService.listarTodos(),
      ]);
      if (!mounted) return;
      setState(() {
        _configuracion = resultados[0] as ConfiguracionSitio;
        _banners = resultados[1] as List<BannerSitio>;
        _cargando = false;
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString().replaceFirst('Exception: ', '');
          _cargando = false;
        });
      }
    }
  }

  void _avisar(String mensaje) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(mensaje)));
  }

  Future<void> _cambiarImagen(_SlotImagenConfig slot) async {
    final elegida = await elegirImagenValidada(onError: _avisar);
    if (elegida == null) return;
    setState(() => _subiendo = slot);
    try {
      final subida = await _storage.subirImagen(
        bytes: elegida.bytes,
        bucket: kBucketSitioAssets,
        carpeta: slot.carpeta,
        extension: elegida.extension,
      );
      final pathAnterior = slot.pathActual(_configuracion);
      await slot.guardar(_configService, subida.url, subida.path);
      if (pathAnterior != null && pathAnterior.isNotEmpty) {
        // Sin bloquear la UI por esto — si falla el borrado de la imagen
        // vieja no es grave, solo queda un archivo huérfano en Storage.
        _storage
            .eliminarImagen(bucket: kBucketSitioAssets, path: pathAnterior)
            .catchError((_) {});
      }
      ConfiguracionSitioCache.invalidar();
      if (mounted) {
        setState(() {
          _configuracion =
              slot.aplicar(_configuracion ?? const ConfiguracionSitio(),
                  subida.url, subida.path);
        });
      }
      _avisar('${slot.nombre} actualizado.');
    } catch (e) {
      _avisar(e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _subiendo = null);
    }
  }

  Future<void> _agregarBanner() async {
    final guardado = await showDialog<bool>(
      context: context,
      builder: (_) => _DialogoBanner(nuevoOrden: _banners.length),
    );
    if (guardado == true) _cargar();
  }

  Future<void> _editarBanner(BannerSitio banner) async {
    final guardado = await showDialog<bool>(
      context: context,
      builder: (_) => _DialogoBanner(banner: banner, nuevoOrden: banner.orden),
    );
    if (guardado == true) _cargar();
  }

  Future<void> _mover(int indice, int direccion) async {
    final destino = indice + direccion;
    if (destino < 0 || destino >= _banners.length) return;
    final actual = _banners[indice];
    final otro = _banners[destino];
    try {
      await _bannerService.actualizar(
        id: actual.id,
        urlDestino: actual.urlDestino,
        abrirEnPestanaNueva: actual.abrirEnPestanaNueva,
        orden: otro.orden,
      );
      await _bannerService.actualizar(
        id: otro.id,
        urlDestino: otro.urlDestino,
        abrirEnPestanaNueva: otro.abrirEnPestanaNueva,
        orden: actual.orden,
      );
      _cargar();
    } catch (e) {
      _avisar(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  Future<void> _alternarActivo(BannerSitio banner) async {
    try {
      await _bannerService.alternarActivo(banner.id, !banner.activo);
      _cargar();
    } catch (e) {
      _avisar(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  Future<void> _eliminarBanner(BannerSitio banner) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('¿Eliminar banner?'),
        content: const Text('Esta acción no se puede deshacer.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar')),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Eliminar')),
        ],
      ),
    );
    if (confirmar != true) return;
    try {
      await _bannerService.eliminar(banner.id);
      // No bloquear la UI por esto (mismo motivo que en _cambiarImagen): si
      // falla el borrado en Storage después de que el registro ya se borró
      // de la base de datos, antes esto se reportaba como si el borrado
      // completo hubiera fallado y la lista no se refrescaba, aunque el
      // banner ya no existiera — parecía "no me deja borrar" sin serlo.
      _storage
          .eliminarImagen(bucket: kBucketSitioAssets, path: banner.imagenPath)
          .catchError((_) {});
      _cargar();
    } catch (e) {
      _avisar(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) return Center(child: Text(_error!));
    if (_cargando) return const Center(child: CircularProgressIndicator());

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text('Apariencia del sitio',
            style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 20),
        _seccionLogo(),
        const SizedBox(height: 32),
        _seccionBanners(),
      ],
    );
  }

  Widget _seccionLogo() {
    return NVCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Logo e identidad institucional',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 4),
          const Text(
            'Negocios Verdes es un micrositio de la Sede Electrónica de la '
            'CDMB — estos sellos aparecen en el pie de página igual que en '
            'esa página. Usa PNG con fondo transparente si es posible.',
            style: TextStyle(color: NVColors.textoSecundario, fontSize: 12),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 24,
            runSpacing: 16,
            children: [
              _filaImagen(
                slot: _SlotImagenConfig.logo,
                url: _configuracion?.logoUrl,
                etiqueta: 'Logo principal',
                ayuda:
                    'Barra superior, inicio, login admin y menú admin.',
              ),
              _filaImagen(
                slot: _SlotImagenConfig.colombia,
                url: _configuracion?.logoColombiaUrl,
                etiqueta: 'Sello Colombia',
                ayuda: 'Pie de página, junto al sello GOV.CO.',
              ),
              _filaImagen(
                slot: _SlotImagenConfig.potencia,
                url: _configuracion?.logoPotenciaUrl,
                etiqueta: 'Sello Colombia Potencia de la Vida',
                ayuda: 'Pie de página, a la derecha del sello de Colombia.',
              ),
              _filaImagen(
                slot: _SlotImagenConfig.govco,
                url: _configuracion?.logoGovcoUrl,
                etiqueta: 'Sello GOV.CO',
                ayuda: 'Pie de página. Usa la versión blanca — el fondo '
                    'es verde oscuro.',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _filaImagen({
    required _SlotImagenConfig slot,
    required String? url,
    required String etiqueta,
    required String ayuda,
  }) {
    final subiendoEste = _subiendo == slot;
    final tieneImagen = url != null && url.isNotEmpty;
    return SizedBox(
      width: 200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(etiqueta, style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          Row(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: NVColors.primaryLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: subiendoEste
                    ? const Padding(
                        padding: EdgeInsets.all(16),
                        child: CircularProgressIndicator(strokeWidth: 2))
                    : (tieneImagen
                        ? Padding(
                            padding: const EdgeInsets.all(8),
                            child: CachedNetworkImage(
                                imageUrl: url, fit: BoxFit.contain),
                          )
                        : const Icon(Icons.image_outlined,
                            size: 28, color: NVColors.primary)),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextButton(
                  onPressed:
                      subiendoEste ? null : () => _cambiarImagen(slot),
                  child: Text(tieneImagen ? 'Cambiar' : 'Subir'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(ayuda,
              style:
                  const TextStyle(color: NVColors.textoSecundario, fontSize: 11)),
        ],
      ),
    );
  }

  Widget _seccionBanners() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Banners del inicio',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ElevatedButton.icon(
              onPressed: _agregarBanner,
              icon: const Icon(Icons.add),
              label: const Text('Agregar banner'),
            ),
          ],
        ),
        const SizedBox(height: 4),
        const Text(
          'Imágenes tipo banner (sin texto encima — si hace falta texto, '
          'va dentro de la propia imagen) que rotan arriba del inicio. Si '
          'no hay ninguno activo, se muestran 4 diapositivas genéricas por '
          'defecto.',
          style: TextStyle(color: NVColors.textoSecundario, fontSize: 12),
        ),
        const SizedBox(height: 16),
        if (_banners.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Center(
              child: Text(
                'Todavía no hay banners — se están mostrando las '
                'diapositivas por defecto.',
                style: TextStyle(color: NVColors.textoSecundario),
              ),
            ),
          )
        else
          for (var i = 0; i < _banners.length; i++) _tarjetaBanner(i),
      ],
    );
  }

  Widget _tarjetaBanner(int indice) {
    final banner = _banners[indice];
    final tieneDestino =
        banner.urlDestino != null && banner.urlDestino!.isNotEmpty;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: NVCard(
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl: banner.imagenUrl,
                width: 80,
                height: 50,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tieneDestino ? banner.urlDestino! : 'Sin destino (decorativo)',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 13),
                  ),
                  if (tieneDestino)
                    Text(
                      banner.abrirEnPestanaNueva
                          ? 'Pestaña nueva'
                          : 'Misma pestaña',
                      style: const TextStyle(
                          color: NVColors.textoSecundario, fontSize: 11),
                    ),
                ],
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_upward),
                  visualDensity: VisualDensity.compact,
                  onPressed: indice > 0 ? () => _mover(indice, -1) : null,
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_downward),
                  visualDensity: VisualDensity.compact,
                  onPressed: indice < _banners.length - 1
                      ? () => _mover(indice, 1)
                      : null,
                ),
              ],
            ),
            Switch(
                value: banner.activo, onChanged: (_) => _alternarActivo(banner)),
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              onPressed: () => _editarBanner(banner),
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () => _eliminarBanner(banner),
            ),
          ],
        ),
      ),
    );
  }
}

/// Los 3 slots de imagen de configuracion_sitio (logo, sello GOV.CO, sello
/// Colombia) comparten exactamente el mismo flujo de subida — esto evita
/// triplicar el método _cambiarImagen para cada uno.
class _SlotImagenConfig {
  final String nombre;
  final String carpeta;
  final String? Function(ConfiguracionSitio?) pathActual;
  final Future<void> Function(ConfiguracionSitioService, String url, String path)
      guardar;
  final ConfiguracionSitio Function(
      ConfiguracionSitio actual, String url, String path) aplicar;

  _SlotImagenConfig({
    required this.nombre,
    required this.carpeta,
    required this.pathActual,
    required this.guardar,
    required this.aplicar,
  });

  static final logo = _SlotImagenConfig(
    nombre: 'Logo',
    carpeta: 'logo',
    pathActual: (c) => c?.logoPath,
    guardar: (s, url, path) => s.actualizarLogo(logoUrl: url, logoPath: path),
    aplicar: (c, url, path) => c.copyWith(logoUrl: url, logoPath: path),
  );

  static final govco = _SlotImagenConfig(
    nombre: 'Sello GOV.CO',
    carpeta: 'sello-govco',
    pathActual: (c) => c?.logoGovcoPath,
    guardar: (s, url, path) => s.actualizarLogoGovco(url: url, path: path),
    aplicar: (c, url, path) =>
        c.copyWith(logoGovcoUrl: url, logoGovcoPath: path),
  );

  static final colombia = _SlotImagenConfig(
    nombre: 'Sello de Colombia',
    carpeta: 'sello-colombia',
    pathActual: (c) => c?.logoColombiaPath,
    guardar: (s, url, path) => s.actualizarLogoColombia(url: url, path: path),
    aplicar: (c, url, path) =>
        c.copyWith(logoColombiaUrl: url, logoColombiaPath: path),
  );

  static final potencia = _SlotImagenConfig(
    nombre: 'Sello de Colombia Potencia de la Vida',
    carpeta: 'sello-potencia',
    pathActual: (c) => c?.logoPotenciaPath,
    guardar: (s, url, path) => s.actualizarLogoPotencia(url: url, path: path),
    aplicar: (c, url, path) =>
        c.copyWith(logoPotenciaUrl: url, logoPotenciaPath: path),
  );
}

class _DialogoBanner extends StatefulWidget {
  final BannerSitio? banner;
  final int nuevoOrden;

  const _DialogoBanner({this.banner, required this.nuevoOrden});

  @override
  State<_DialogoBanner> createState() => _DialogoBannerState();
}

class _DialogoBannerState extends State<_DialogoBanner> {
  final _bannerService = BannerService();
  final _storage = StorageService();
  final _urlCtrl = TextEditingController();

  bool _abrirEnPestanaNueva = true;
  String? _imagenUrl;
  String? _imagenPath;
  bool _subiendoImagen = false;
  bool _guardando = false;

  @override
  void initState() {
    super.initState();
    final b = widget.banner;
    if (b != null) {
      _urlCtrl.text = b.urlDestino ?? '';
      _abrirEnPestanaNueva = b.abrirEnPestanaNueva;
      _imagenUrl = b.imagenUrl;
      _imagenPath = b.imagenPath;
    }
  }

  @override
  void dispose() {
    _urlCtrl.dispose();
    super.dispose();
  }

  void _avisar(String mensaje) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(mensaje)));
  }

  Future<void> _elegirImagen() async {
    final elegida = await elegirImagenValidada(onError: _avisar);
    if (elegida == null) return;
    setState(() => _subiendoImagen = true);
    try {
      final subida = await _storage.subirImagen(
        bytes: elegida.bytes,
        bucket: kBucketSitioAssets,
        carpeta: 'banners',
        extension: elegida.extension,
      );
      setState(() {
        _imagenUrl = subida.url;
        _imagenPath = subida.path;
      });
    } catch (e) {
      _avisar(e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _subiendoImagen = false);
    }
  }

  Future<void> _guardar() async {
    if (_imagenUrl == null || _imagenPath == null) {
      _avisar('Sube una imagen para el banner.');
      return;
    }
    setState(() => _guardando = true);
    try {
      final destino = _urlCtrl.text.trim();
      if (widget.banner == null) {
        await _bannerService.crear(
          imagenUrl: _imagenUrl!,
          imagenPath: _imagenPath!,
          urlDestino: destino.isEmpty ? null : destino,
          abrirEnPestanaNueva: _abrirEnPestanaNueva,
          orden: widget.nuevoOrden,
        );
      } else {
        await _bannerService.actualizar(
          id: widget.banner!.id,
          urlDestino: destino.isEmpty ? null : destino,
          abrirEnPestanaNueva: _abrirEnPestanaNueva,
          orden: widget.nuevoOrden,
        );
      }
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      _avisar(e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _guardando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.banner == null ? 'Nuevo banner' : 'Editar banner'),
      content: SizedBox(
        width: 420,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _slotImagen(),
            const SizedBox(height: 16),
            TextField(
              controller: _urlCtrl,
              decoration: const InputDecoration(
                labelText: 'Destino al tocar el banner (opcional)',
                helperText: '/buscar?categoria=ecoturismo, o https://...',
              ),
            ),
            const SizedBox(height: 4),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Abrir en pestaña nueva'),
              subtitle: const Text(
                  'Solo aplica a enlaces externos (https://...).',
                  style: TextStyle(fontSize: 11)),
              value: _abrirEnPestanaNueva,
              onChanged: (v) => setState(() => _abrirEnPestanaNueva = v),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar')),
        ElevatedButton(
          onPressed: _guardando ? null : _guardar,
          child: _guardando
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2))
              : const Text('Guardar'),
        ),
      ],
    );
  }

  Widget _slotImagen() {
    return InkWell(
      onTap: _subiendoImagen ? null : _elegirImagen,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        height: 120,
        decoration: BoxDecoration(
          color: NVColors.primaryLight,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: NVColors.borde),
        ),
        clipBehavior: Clip.antiAlias,
        child: _subiendoImagen
            ? const Center(child: CircularProgressIndicator())
            : (_imagenUrl != null
                ? CachedNetworkImage(imageUrl: _imagenUrl!, fit: BoxFit.cover)
                : const Center(
                    child: Icon(Icons.add_photo_alternate_outlined,
                        size: 32, color: NVColors.primary),
                  )),
      ),
    );
  }
}
