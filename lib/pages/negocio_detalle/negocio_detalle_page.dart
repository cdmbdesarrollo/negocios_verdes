import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../catalogos.dart';
import '../../core/seo_tags.dart';
import '../../core/widgets/badge_nivel.dart';
import '../../core/widgets/boton_whatsapp.dart';
import '../../core/widgets/pie_pagina.dart';
import '../../core/widgets/aval_confianza_badge.dart';
import '../../core/widgets/pin_negocio_mapa.dart';
import '../../core/widgets/sello_marca_badge.dart';
import '../../models/negocio.dart';
import '../../services/negocio_service.dart';
import '../../theme/nv_colors.dart';
import '../estaticas/no_encontrado_page.dart';

class NegocioDetallePage extends StatefulWidget {
  final String slug;

  const NegocioDetallePage({super.key, required this.slug});

  @override
  State<NegocioDetallePage> createState() => _NegocioDetallePageState();
}

class _NegocioDetallePageState extends State<NegocioDetallePage> {
  final _service = NegocioService();
  Negocio? _negocio;
  bool _cargando = true;
  bool _noEncontrado = false;
  bool _descripcionExpandida = false;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  @override
  void didUpdateWidget(covariant NegocioDetallePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.slug != widget.slug) {
      setState(() {
        _cargando = true;
        _noEncontrado = false;
        _negocio = null;
      });
      _cargar();
    }
  }

  Future<void> _cargar() async {
    try {
      final negocio = await _service.obtenerPorSlug(widget.slug);
      if (!mounted) return;
      if (negocio == null) {
        setState(() {
          _noEncontrado = true;
          _cargando = false;
        });
        return;
      }
      establecerSeo(
        titulo: '${negocio.nombre} — Negocios Verdes CDMB',
        descripcion: negocio.descripcionCorta,
        imagenUrl: negocio.fotoPortadaUrl,
      );
      setState(() {
        _negocio = negocio;
        _cargando = false;
      });
    } catch (_) {
      if (mounted) {
        setState(() {
          _noEncontrado = true;
          _cargando = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_cargando) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_noEncontrado || _negocio == null) {
      return const NoEncontradoPage();
    }

    final negocio = _negocio!;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _portada(negocio),
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 900),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        BadgeNivel(nivel: negocio.nivelDesarrollo),
                        if (negocio.selloMarca) const SelloMarcaBadge(),
                        if (negocio.avalConfianza) const AvalConfianzaBadge(),
                        if (negocio.categoriasOficiales.isNotEmpty)
                          for (final cat in negocio.categoriasOficiales)
                            _chip('${cat.iconoOTexto} ${cat.nombre}')
                        else if (negocio.categoriaOficial != null)
                          _chip(
                            '${negocio.categoriaOficial!.iconoOTexto} '
                            '${negocio.categoriaOficial!.nombre}',
                          ),
                        for (final sub in negocio.subcategorias)
                          _chip('${sub.iconoOTexto} ${sub.nombre}'),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      negocio.nombre,
                      style: const TextStyle(
                          fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.place_outlined,
                            size: 16, color: NVColors.textoSecundario),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            negocio.direccion != null &&
                                    negocio.direccion!.isNotEmpty
                                ? '${negocio.direccion} · ${negocio.municipio}'
                                : negocio.municipio,
                            style:
                                const TextStyle(color: NVColors.textoSecundario),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        BotonWhatsapp(
                          numeroWhatsapp: negocio.whatsapp,
                          mensaje:
                              mensajeWhatsappPredeterminado(negocio.nombre),
                        ),
                        if (negocio.telefono != null &&
                            negocio.telefono!.isNotEmpty)
                          OutlinedButton.icon(
                            onPressed: () => _llamar(negocio.telefono!),
                            icon: const Icon(Icons.call_outlined),
                            label: Text(negocio.telefono!),
                          ),
                        if (negocio.facebookUrl != null &&
                            negocio.facebookUrl!.isNotEmpty)
                          OutlinedButton.icon(
                            onPressed: () => _abrir(negocio.facebookUrl!),
                            icon: const Icon(Icons.facebook),
                            label: const Text('Facebook'),
                          ),
                        if (negocio.instagramUrl != null &&
                            negocio.instagramUrl!.isNotEmpty)
                          OutlinedButton.icon(
                            onPressed: () => _abrir(negocio.instagramUrl!),
                            icon: const Icon(Icons.camera_alt_outlined),
                            label: const Text('Instagram'),
                          ),
                        if (negocio.sitioWeb != null &&
                            negocio.sitioWeb!.isNotEmpty)
                          OutlinedButton.icon(
                            onPressed: () => _abrir(negocio.sitioWeb!),
                            icon: const Icon(Icons.language),
                            label: const Text('Sitio web'),
                          ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _infoContacto(negocio),
                    const SizedBox(height: 24),
                    _descripcion(negocio.descripcion),
                    if (negocio.fotos.isNotEmpty) ...[
                      const SizedBox(height: 24),
                      const Text('Galería',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 12),
                      _galeria(negocio),
                    ],
                    if (negocio.tieneUbicacion) ...[
                      const SizedBox(height: 24),
                      const Text('Ubicación',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 12),
                      _miniMapa(negocio),
                    ],
                  ],
                ),
              ),
            ),
          ),
          const PiePagina(),
        ],
      ),
    );
  }

  /// BoxFit.contain (no cover) a propósito — muchos negocios solo tienen a
  /// mano su logo, no una foto ancha de portada, y recortarlo/estirarlo a
  /// la fuerza para llenar un banner se veía borroso y mal encuadrado.
  /// Así se ve completo tanto un logo como una foto real.
  Widget _portada(Negocio negocio) {
    // Blanco, no verde: casi todos los logos ya traen su propio fondo
    // blanco — un tinte verde detrás se veía como un recuadro desencajado
    // en vez de integrarse. Padding chico (antes 20) para que el logo
    // ocupe casi todo el espacio en vez de verse pequeño en el centro.
    return Container(
      width: double.infinity,
      height: 280,
      color: Colors.white,
      padding: const EdgeInsets.all(8),
      alignment: Alignment.center,
      child: negocio.fotoPortadaUrl != null && negocio.fotoPortadaUrl!.isNotEmpty
          ? CachedNetworkImage(
              imageUrl: negocio.fotoPortadaUrl!, fit: BoxFit.contain)
          : const Icon(Icons.storefront, size: 64, color: NVColors.primary),
    );
  }

  Widget _galeria(Negocio negocio) {
    return SizedBox(
      height: 110,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: negocio.fotos.length,
        separatorBuilder: (_, _) => const SizedBox(width: 10),
        itemBuilder: (context, i) => InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => _abrirVisor(context, negocio, i),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: CachedNetworkImage(
              imageUrl: negocio.fotos[i].url,
              width: 110,
              height: 110,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }

  void _abrirVisor(BuildContext context, Negocio negocio, int indiceInicial) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.92),
      builder: (_) => _VisorGaleria(
        urls: [for (final f in negocio.fotos) f.url],
        indiceInicial: indiceInicial,
      ),
    );
  }

  Widget _miniMapa(Negocio negocio) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        height: 220,
        child: FlutterMap(
          options: MapOptions(
            initialCenter: LatLng(negocio.latitud!, negocio.longitud!),
            initialZoom: 15,
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'co.gov.cdmb.negocios_verdes_cdmb',
            ),
            MarkerLayer(markers: [
              Marker(
                point: LatLng(negocio.latitud!, negocio.longitud!),
                width: 46,
                height: 46,
                child: PinNegocioMapa(
                  fotoPortadaUrl: negocio.fotoPortadaUrl,
                  destacado: true,
                  tamano: 44,
                ),
              ),
            ]),
          ],
        ),
      ),
    );
  }

  /// Los botones de arriba (WhatsApp, Llamar, redes) son para actuar; este
  /// bloque es para LEER — con SelectableText, para que se pueda copiar un
  /// correo o número a mano sin depender de que el link funcione.
  Widget _infoContacto(Negocio negocio) {
    final filas = [
      if (negocio.direccion != null && negocio.direccion!.isNotEmpty)
        (Icons.place_outlined, '${negocio.direccion}, ${negocio.municipio}'),
      (Icons.chat_bubble_outline, '+${negocio.whatsapp} (WhatsApp)'),
      if (negocio.telefono != null && negocio.telefono!.isNotEmpty)
        (Icons.call_outlined, negocio.telefono!),
      if (negocio.email != null && negocio.email!.isNotEmpty)
        (Icons.email_outlined, negocio.email!),
    ];
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: NVColors.primaryLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Información de contacto',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 12),
          for (final (icono, valor) in filas) _filaContacto(icono, valor),
        ],
      ),
    );
  }

  Widget _filaContacto(IconData icono, String valor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icono, size: 18, color: NVColors.primaryDark),
          const SizedBox(width: 10),
          Expanded(
            child: SelectableText(valor, style: const TextStyle(fontSize: 14)),
          ),
        ],
      ),
    );
  }

  /// Descripciones largas se ven "muy largas" a simple vista — se recorta a
  /// 5 líneas con un botón "Leer más" en vez de bajarle el límite de
  /// caracteres en el formulario (eso perdería contenido real que el
  /// negocio sí quiere mostrar, solo que no todo de una).
  Widget _descripcion(String texto) {
    const umbralExpandir = 280;
    final esLarga = texto.length > umbralExpandir;
    final expandida = !esLarga || _descripcionExpandida;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          texto,
          textAlign: TextAlign.justify,
          maxLines: expandida ? null : 5,
          overflow: expandida ? TextOverflow.visible : TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 15, height: 1.5),
        ),
        if (esLarga)
          TextButton(
            style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: const Size(0, 36),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap),
            onPressed: () => setState(
                () => _descripcionExpandida = !_descripcionExpandida),
            child: Text(_descripcionExpandida ? 'Leer menos' : 'Leer más'),
          ),
      ],
    );
  }

  Widget _chip(String texto) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: NVColors.primaryLight,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(texto, style: const TextStyle(fontSize: 12)),
    );
  }

  Future<void> _abrir(String url) async {
    final uri = Uri.tryParse(url.startsWith('http') ? url : 'https://$url');
    if (uri == null) return;
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  Future<void> _llamar(String telefono) async {
    await launchUrl(Uri(scheme: 'tel', path: telefono));
  }
}

/// Visor de galería a pantalla completa — las miniaturas antes no hacían
/// nada al tocarlas. BoxFit.contain (no cover) a propósito: acá sí importa
/// ver la foto completa, no recortada.
class _VisorGaleria extends StatefulWidget {
  final List<String> urls;
  final int indiceInicial;

  const _VisorGaleria({required this.urls, required this.indiceInicial});

  @override
  State<_VisorGaleria> createState() => _VisorGaleriaState();
}

class _VisorGaleriaState extends State<_VisorGaleria> {
  late final PageController _controller;
  late int _indice;

  @override
  void initState() {
    super.initState();
    _indice = widget.indiceInicial;
    _controller = PageController(initialPage: _indice);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _ir(int destino) {
    if (destino < 0 || destino >= widget.urls.length) return;
    _controller.animateToPage(
      destino,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final variasFotos = widget.urls.length > 1;
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(12),
      child: Stack(
        alignment: Alignment.center,
        children: [
          PageView.builder(
            controller: _controller,
            itemCount: widget.urls.length,
            onPageChanged: (i) => setState(() => _indice = i),
            itemBuilder: (context, i) => InteractiveViewer(
              child: Center(
                child: CachedNetworkImage(
                  imageUrl: widget.urls[i],
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: _botonRedondo(Icons.close, () => Navigator.pop(context)),
          ),
          if (variasFotos) ...[
            Positioned(
              left: 4,
              child: _botonRedondo(
                  Icons.chevron_left, () => _ir(_indice - 1)),
            ),
            Positioned(
              right: 4,
              child: _botonRedondo(
                  Icons.chevron_right, () => _ir(_indice + 1)),
            ),
            Positioned(
              bottom: 8,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${_indice + 1} / ${widget.urls.length}',
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _botonRedondo(IconData icono, VoidCallback onTap) {
    return Material(
      color: Colors.black.withValues(alpha: 0.5),
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Icon(icono, color: Colors.white, size: 26),
        ),
      ),
    );
  }
}
