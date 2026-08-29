import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';

import '../../core/widgets/botones_zoom_mapa.dart';
import '../../core/widgets/pie_pagina.dart';
import '../../core/widgets/pin_negocio_mapa.dart';
import '../../models/categoria_oficial.dart';
import '../../models/filtro_busqueda.dart';
import '../../models/municipio_geo.dart';
import '../../models/negocio.dart';
import '../../services/categoria_service.dart';
import '../../services/negocio_service.dart';
import '../../theme/nv_colors.dart';

/// "Geovisor de Negocios Verdes": mapa a pantalla completa con un panel de
/// CAPAS al estilo de un visor SIG (ArcGIS) — límites de los 13 municipios
/// de la jurisdicción CDMB (de OpenStreetMap, ver assets/geo/), los
/// negocios verdes agrupados, y filtros por categoría / reconocimiento /
/// municipio. Todo lo que ya tenemos (flutter_map + OSM), sin depender de
/// ArcGIS ni de un tile server propio.
class GeovisorPage extends StatefulWidget {
  const GeovisorPage({super.key});

  @override
  State<GeovisorPage> createState() => _GeovisorPageState();
}

class _GeovisorPageState extends State<GeovisorPage> {
  final _negocioService = NegocioService();
  final _categoriaService = CategoriaService();
  final _mapController = MapController();

  List<MunicipioGeo>? _municipios;
  List<Negocio>? _negocios;
  List<CategoriaOficial> _categorias = [];
  String? _error;

  // Capas / filtros.
  bool _capaMunicipios = true;
  bool _capaEtiquetas = true;
  bool _capaNegocios = true;
  final Set<String> _categoriasOcultas = {}; // slugs
  String? _recon; // null | 'ev' | 'sm' | 'av'
  String? _municipioSel; // nombre
  bool _panelAbierto = true;

  Negocio? _negocioSel;

  static const _centro = LatLng(7.25, -73.15);

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    try {
      final res = await Future.wait([
        MunicipioGeo.cargar(),
        _negocioService.buscar(const FiltroBusqueda()),
        _categoriaService.listarTodas(),
      ]);
      if (!mounted) return;
      setState(() {
        _municipios = res[0] as List<MunicipioGeo>;
        _negocios = (res[1] as List<Negocio>)
            .where((n) => n.tieneUbicacion)
            .toList();
        _categorias = res[2] as List<CategoriaOficial>;
      });
    } catch (e) {
      if (mounted) {
        setState(() => _error = e.toString().replaceFirst('Exception: ', ''));
      }
    }
  }

  bool _pasaFiltros(Negocio n) {
    if (_municipioSel != null && n.municipio != _municipioSel) return false;
    final slug = n.categoriaOficial?.slug;
    if (slug != null && _categoriasOcultas.contains(slug)) return false;
    return switch (_recon) {
      'ev' => n.emprendimientoVerde,
      'sm' => n.selloMarca,
      'av' => n.avalado,
      _ => true,
    };
  }

  List<Negocio> get _negociosVisibles =>
      (_negocios ?? []).where(_pasaFiltros).toList();

  int _conteoMunicipio(String nombre) =>
      (_negocios ?? []).where((n) => n.municipio == nombre).length;

  void _enfocarMunicipio(MunicipioGeo m) {
    setState(() {
      _municipioSel = _municipioSel == m.nombre ? null : m.nombre;
      _negocioSel = null;
    });
    if (_municipioSel != null) {
      final pts = [for (final r in m.anillos) ...r];
      _mapController.fitCamera(CameraFit.coordinates(
        coordinates: pts,
        padding: const EdgeInsets.all(40),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        final ancho = c.maxWidth >= 900;
        final mapa = _mapa();
        return SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: ancho ? 640 : 560,
                child: ancho
                    ? Row(
                        children: [
                          if (_panelAbierto)
                            SizedBox(width: 300, child: _panel()),
                          Expanded(child: mapa),
                        ],
                      )
                    : Stack(
                        children: [
                          mapa,
                          if (_panelAbierto)
                            Positioned.fill(
                              child: ColoredBox(
                                color: Colors.black26,
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: SizedBox(width: 280, child: _panel()),
                                ),
                              ),
                            ),
                        ],
                      ),
              ),
              const PiePagina(),
            ],
          ),
        );
      },
    );
  }

  Widget _mapa() {
    if (_error != null) {
      return Center(child: Text(_error!));
    }
    if (_municipios == null || _negocios == null) {
      return const Center(child: CircularProgressIndicator());
    }
    final visibles = _negociosVisibles;
    return Stack(
      children: [
        FlutterMap(
          mapController: _mapController,
          options: const MapOptions(
            initialCenter: _centro,
            initialZoom: 9.2,
            minZoom: 7,
            maxZoom: 18,
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'co.gov.cdmb.negocios_verdes_cdmb',
            ),
            if (_capaMunicipios)
              PolygonLayer(
                polygons: [
                  for (final m in _municipios!)
                    Polygon(
                      points: m.anillos.isEmpty ? const [] : m.anillos.first,
                      holePointsList: m.anillos.length > 1
                          ? m.anillos.sublist(1)
                          : null,
                      borderColor: _municipioSel == m.nombre
                          ? NVColors.accent
                          : NVColors.primaryDark,
                      borderStrokeWidth: _municipioSel == m.nombre ? 3 : 1.5,
                      color: (_municipioSel == m.nombre
                              ? NVColors.accent
                              : NVColors.primary)
                          .withValues(alpha: 0.08),
                    ),
                ],
              ),
            if (_capaMunicipios && _capaEtiquetas)
              MarkerLayer(
                markers: [
                  for (final m in _municipios!)
                    Marker(
                      point: m.centro,
                      width: 110,
                      height: 20,
                      child: _EtiquetaMunicipio(
                          texto: m.nombre,
                          activo: _municipioSel == m.nombre),
                    ),
                ],
              ),
            if (_capaNegocios)
              MarkerClusterLayerWidget(
                options: MarkerClusterLayerOptions(
                  maxClusterRadius: 55,
                  size: const Size(38, 38),
                  zoomToBoundsOnClick: true,
                  markers: [
                    for (final n in visibles)
                      Marker(
                        key: ValueKey(n.id),
                        point: LatLng(n.latitud!, n.longitud!),
                        width: 44,
                        height: 44,
                        child: PinNegocioMapa(
                          fotoPortadaUrl: n.fotoPortadaUrl,
                          destacado: n.id == _negocioSel?.id,
                          tamano: n.id == _negocioSel?.id ? 42 : 34,
                        ),
                      ),
                  ],
                  builder: (context, markers) => Container(
                    decoration: const BoxDecoration(
                      color: NVColors.primaryDark,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text('${markers.length}',
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold)),
                  ),
                  onMarkerTap: (marker) {
                    final k = marker.key;
                    if (k is! ValueKey<String>) return;
                    for (final n in visibles) {
                      if (n.id == k.value) {
                        setState(() => _negocioSel = n);
                        return;
                      }
                    }
                  },
                ),
              ),
          ],
        ),
        Positioned(
          right: 12,
          top: 12,
          child: BotonesZoomMapa(controlador: _mapController),
        ),
        Positioned(
          left: 12,
          top: 12,
          child: Material(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: const BorderSide(color: NVColors.primaryDark, width: 1.5),
            ),
            child: IconButton(
              tooltip: _panelAbierto ? 'Ocultar capas' : 'Mostrar capas',
              icon: Icon(_panelAbierto ? Icons.layers_clear : Icons.layers),
              color: NVColors.primaryDark,
              onPressed: () =>
                  setState(() => _panelAbierto = !_panelAbierto),
            ),
          ),
        ),
        Positioned(
          left: 12,
          right: 12,
          bottom: 12,
          child: Align(
            alignment: Alignment.bottomLeft,
            child: _negocioSel != null
                ? _TarjetaNegocio(
                    negocio: _negocioSel!,
                    onCerrar: () => setState(() => _negocioSel = null),
                  )
                : (_municipioSel != null
                    ? _ChipMunicipio(
                        nombre: _municipioSel!,
                        conteo: _conteoMunicipio(_municipioSel!),
                        onQuitar: () =>
                            setState(() => _municipioSel = null),
                      )
                    : const SizedBox.shrink()),
          ),
        ),
      ],
    );
  }

  Widget _panel() {
    return Material(
      elevation: 2,
      color: NVColors.superficie,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 28),
        children: [
          Row(
            children: [
              const Icon(Icons.layers_outlined,
                  size: 20, color: NVColors.primaryDark),
              const SizedBox(width: 8),
              const Expanded(
                child: Text('Capas',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16)),
              ),
              IconButton(
                iconSize: 18,
                visualDensity: VisualDensity.compact,
                icon: const Icon(Icons.close),
                onPressed: () => setState(() => _panelAbierto = false),
              ),
            ],
          ),
          const Divider(),
          const _Rotulo('Mapa base'),
          const ListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.public, size: 20),
            title: Text('OpenStreetMap'),
          ),
          const SizedBox(height: 4),
          _check('Límites municipales', _capaMunicipios,
              (v) => setState(() => _capaMunicipios = v)),
          if (_capaMunicipios)
            Padding(
              padding: const EdgeInsets.only(left: 24),
              child: _check('Etiquetas de municipio', _capaEtiquetas,
                  (v) => setState(() => _capaEtiquetas = v)),
            ),
          if (_capaMunicipios && _municipios != null) ...[
            const SizedBox(height: 2),
            for (final m in _municipiosOrdenados)
              _FilaMunicipio(
                nombre: m.nombre,
                conteo: _conteoMunicipio(m.nombre),
                activo: _municipioSel == m.nombre,
                onTap: () => _enfocarMunicipio(m),
              ),
          ],
          const Divider(height: 24),
          _check(
              'Negocios verdes  (${_negociosVisibles.length})',
              _capaNegocios,
              (v) => setState(() => _capaNegocios = v)),
          if (_capaNegocios) ...[
            const SizedBox(height: 4),
            const _Rotulo('Por categoría'),
            for (final c in _categorias)
              _check(
                '${c.iconoOTexto} ${c.nombre}',
                !_categoriasOcultas.contains(c.slug),
                (v) => setState(() => v
                    ? _categoriasOcultas.remove(c.slug)
                    : _categoriasOcultas.add(c.slug)),
              ),
            const SizedBox(height: 8),
            const _Rotulo('Por reconocimiento'),
            _radioRecon('Todos', null),
            _radioRecon('🌱 Emprendimiento Verde', 'ev'),
            _radioRecon('🎖️ Sello Marca', 'sm'),
            _radioRecon('✅ Negocio Verde Avalado', 'av'),
          ],
        ],
      ),
    );
  }

  List<MunicipioGeo> get _municipiosOrdenados {
    final l = [..._municipios!];
    l.sort((a, b) =>
        _conteoMunicipio(b.nombre).compareTo(_conteoMunicipio(a.nombre)));
    return l;
  }

  Widget _check(String etiqueta, bool valor, ValueChanged<bool> onChanged) {
    return CheckboxListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      controlAffinity: ListTileControlAffinity.leading,
      value: valor,
      onChanged: (v) => onChanged(v ?? false),
      title: Text(etiqueta, style: const TextStyle(fontSize: 13)),
    );
  }

  Widget _radioRecon(String etiqueta, String? valor) {
    final sel = _recon == valor;
    return InkWell(
      onTap: () => setState(() => _recon = valor),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(
          children: [
            Icon(
                sel
                    ? Icons.radio_button_checked
                    : Icons.radio_button_unchecked,
                size: 18,
                color: sel ? NVColors.primary : NVColors.textoSecundario),
            const SizedBox(width: 8),
            Expanded(
                child:
                    Text(etiqueta, style: const TextStyle(fontSize: 13))),
          ],
        ),
      ),
    );
  }
}

class _Rotulo extends StatelessWidget {
  final String texto;
  const _Rotulo(this.texto);
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 6, bottom: 2),
        child: Text(texto.toUpperCase(),
            style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
                color: NVColors.textoSecundario)),
      );
}

class _FilaMunicipio extends StatelessWidget {
  final String nombre;
  final int conteo;
  final bool activo;
  final VoidCallback onTap;
  const _FilaMunicipio({
    required this.nombre,
    required this.conteo,
    required this.activo,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 6),
        color: activo ? NVColors.primaryLight : null,
        child: Row(
          children: [
            Icon(activo ? Icons.place : Icons.place_outlined,
                size: 15,
                color: activo ? NVColors.accent : NVColors.textoSecundario),
            const SizedBox(width: 6),
            Expanded(
                child: Text(nombre,
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight:
                            activo ? FontWeight.w700 : FontWeight.normal))),
            Text('$conteo',
                style: const TextStyle(
                    fontSize: 12, color: NVColors.textoSecundario)),
          ],
        ),
      ),
    );
  }
}

class _EtiquetaMunicipio extends StatelessWidget {
  final String texto;
  final bool activo;
  const _EtiquetaMunicipio({required this.texto, required this.activo});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.75),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          texto,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 10,
            fontWeight: activo ? FontWeight.w800 : FontWeight.w600,
            color: activo ? NVColors.accent : NVColors.primaryDark,
          ),
        ),
      ),
    );
  }
}

class _ChipMunicipio extends StatelessWidget {
  final String nombre;
  final int conteo;
  final VoidCallback onQuitar;
  const _ChipMunicipio({
    required this.nombre,
    required this.conteo,
    required this.onQuitar,
  });
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 3,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 6, 6, 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.place, size: 16, color: NVColors.accent),
            const SizedBox(width: 6),
            Text('$nombre · $conteo negocio${conteo == 1 ? '' : 's'}',
                style: const TextStyle(
                    fontSize: 13, fontWeight: FontWeight.w600)),
            IconButton(
              iconSize: 16,
              visualDensity: VisualDensity.compact,
              icon: const Icon(Icons.close),
              onPressed: onQuitar,
            ),
          ],
        ),
      ),
    );
  }
}

class _TarjetaNegocio extends StatelessWidget {
  final Negocio negocio;
  final VoidCallback onCerrar;
  const _TarjetaNegocio({required this.negocio, required this.onCerrar});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 4,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 320,
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(negocio.nombre,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 15)),
                ),
                InkWell(
                  onTap: onCerrar,
                  child: const Icon(Icons.close, size: 18),
                ),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              [
                negocio.categoriaOficial?.nombre,
                negocio.municipio,
              ].whereType<String>().join(' · '),
              style: const TextStyle(
                  fontSize: 12, color: NVColors.textoSecundario),
            ),
            if ((negocio.descripcionCorta ?? '').isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(negocio.descripcionCorta!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12)),
            ],
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton.icon(
                onPressed: () => context.go('/negocio/${negocio.slug}'),
                icon: const Icon(Icons.open_in_new, size: 16),
                label: const Text('Ver ficha'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
