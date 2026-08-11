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
                        if (negocio.categoriaOficial != null)
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
                    Text(negocio.descripcion,
                        style: const TextStyle(fontSize: 15, height: 1.5)),
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

  Widget _portada(Negocio negocio) {
    return SizedBox(
      width: double.infinity,
      height: 280,
      child: negocio.fotoPortadaUrl != null && negocio.fotoPortadaUrl!.isNotEmpty
          ? CachedNetworkImage(imageUrl: negocio.fotoPortadaUrl!, fit: BoxFit.cover)
          : Container(
              color: NVColors.primaryLight,
              child: const Icon(Icons.storefront,
                  size: 64, color: NVColors.primary),
            ),
    );
  }

  Widget _galeria(Negocio negocio) {
    return SizedBox(
      height: 110,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: negocio.fotos.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, i) => ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: CachedNetworkImage(
            imageUrl: negocio.fotos[i].url,
            width: 110,
            height: 110,
            fit: BoxFit.cover,
          ),
        ),
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
                width: 40,
                height: 40,
                child: const Icon(Icons.location_pin,
                    color: NVColors.accent, size: 40),
              ),
            ]),
          ],
        ),
      ),
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
}
