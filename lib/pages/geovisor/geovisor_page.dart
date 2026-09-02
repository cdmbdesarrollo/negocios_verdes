import 'dart:convert';
import 'dart:math' as math;
import 'dart:ui' show ImageByteFormat;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show RenderRepaintBoundary;
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/descargar_archivo_web.dart';
import '../../core/texto_utils.dart';
import '../../core/widgets/botones_zoom_mapa.dart';
import '../../core/widgets/pie_pagina.dart';
import '../../core/widgets/pin_negocio_mapa.dart';
import '../../models/capa_geo.dart';
import '../../models/categoria_oficial.dart';
import '../../models/filtro_busqueda.dart';
import '../../models/municipio_geo.dart';
import '../../models/negocio.dart';
import '../../services/categoria_service.dart';
import '../../services/negocio_service.dart';
import '../../theme/nv_colors.dart';
import 'geovisor_exportar.dart';

const _sinVereda = '(sin vereda registrada)';

enum _PanelTab { filtrar, capas, herramientas }

/// "Geovisor Negocios Verdes": mapa a pantalla completa con un panel de
/// CAPAS al estilo de un visor SIG — límites de los 13 municipios de la
/// jurisdicción CDMB (de OpenStreetMap, ver assets/geo/), negocios verdes
/// agrupados, filtros por categoría / municipio / vereda, buscador y
/// enlace compartible. Todo con flutter_map + OSM.
class GeovisorPage extends StatefulWidget {
  /// Estado inicial desde la URL (`/geovisor?mun=...&sincat=...`)
  /// para poder compartir una vista.
  final String? municipioInicial;
  final String? sinCategoriasInicial;
  final String? zonaInicial;
  final String? anioInicial;

  /// Modo incrustado (ruta `/geovisor/embed`): sin barra de navegación ni
  /// pie de página, mapa a toda la altura — para poner el geovisor en un
  /// iframe dentro de otra web o un informe.
  final bool embed;

  const GeovisorPage({
    super.key,
    this.municipioInicial,
    this.sinCategoriasInicial,
    this.zonaInicial,
    this.anioInicial,
    this.embed = false,
  });

  @override
  State<GeovisorPage> createState() => _GeovisorPageState();
}

class _GeovisorPageState extends State<GeovisorPage> {
  final _negocioService = NegocioService();
  final _categoriaService = CategoriaService();
  final _mapController = MapController();
  final LayerHitNotifier<String> _hitMunicipios = ValueNotifier(null);
  final _busquedaCtrl = TextEditingController();
  final _panelScroll = ScrollController();
  final _claveMapa = GlobalKey();

  List<MunicipioGeo>? _municipios;
  List<Negocio>? _negocios;
  List<CategoriaOficial> _categorias = [];
  String? _error;

  _PanelTab _panelTab = _PanelTab.filtrar;

  // Capas / filtros.
  bool _capaMunicipios = true;
  bool _capaEtiquetas = true;
  bool _capaNegocios = true;
  bool _capaCalor = false;
  int? _anioMin; // registrados desde ese año
  double _zoomActual = 9.2; // para alternar pines livianos / con foto
  bool _medirArea = true; // false = solo distancia (línea abierta)

  // Herramienta "negocios cerca de un punto".
  bool _modoCerca = false;
  LatLng? _puntoCerca;
  int _radioCerca = 1000; // metros

  // Ubicación del visitante (botón "mi ubicación").
  LatLng? _miUbicacion;
  bool _buscandoUbicacion = false;

  // Resultado de "buscar como lugar" (geocoding Nominatim).
  LatLng? _lugarMarcado;
  String? _lugarNombre;
  bool _buscandoLugar = false;

  // Capas de contexto (RUNAP / IDEAM) — se cargan la primera vez que se
  // encienden, no en el arranque.
  bool _capaAreas = false;
  bool _capaEtiquetasAreas = true;
  bool _capaHidro = false;
  CapaGeo? _areas;
  CapaGeo? _hidro;
  bool _cargandoAreas = false;
  bool _cargandoHidro = false;

  // Herramienta de medición / selección de zona. En este modo, tocar el
  // mapa agrega un vértice; con 3+ se puede descargar la zona.
  bool _modoMedir = false;
  final List<LatLng> _medida = [];
  final Set<String> _categoriasOcultas = {}; // slugs
  String? _municipioSel;
  String? _veredaSel;
  bool _panelAbierto = true;

  Negocio? _negocioSel;

  static const _centro = LatLng(7.25, -73.15);

  @override
  void initState() {
    super.initState();
    _municipioSel = widget.municipioInicial;
    if ((widget.sinCategoriasInicial ?? '').isNotEmpty) {
      _categoriasOcultas.addAll(widget.sinCategoriasInicial!.split(','));
    }
    _anioMin = int.tryParse(widget.anioInicial ?? '');
    final z = parseZonaParam(widget.zonaInicial);
    if (z.length >= 3) {
      _modoMedir = true;
      _medida.addAll(z);
    }
    _cargar();
  }

  @override
  void dispose() {
    _busquedaCtrl.dispose();
    _hitMunicipios.dispose();
    _panelScroll.dispose();
    super.dispose();
  }

  /// Categorías reales — la comodín "pendiente-clasificar" es de gestión
  /// interna, no se muestra ni se filtra en las vistas públicas.
  List<CategoriaOficial> get _categoriasPublicas =>
      _categorias.where((c) => c.slug != 'pendiente-clasificar').toList();

  Future<void> _toggleAreas(bool v) async {
    setState(() => _capaAreas = v);
    if (v && _areas == null && !_cargandoAreas) {
      setState(() => _cargandoAreas = true);
      try {
        final c = await CapaGeo.cargar('assets/geo/areas_protegidas_cdmb.geojson');
        if (mounted) setState(() => _areas = c);
      } catch (_) {}
      if (mounted) setState(() => _cargandoAreas = false);
    }
  }

  Future<void> _toggleHidro(bool v) async {
    setState(() => _capaHidro = v);
    if (v && _hidro == null && !_cargandoHidro) {
      setState(() => _cargandoHidro = true);
      try {
        final c = await CapaGeo.cargar('assets/geo/hidrografia_cdmb.geojson');
        if (mounted) setState(() => _hidro = c);
      } catch (_) {}
      if (mounted) setState(() => _cargandoHidro = false);
    }
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
      // Si venía una zona o un municipio en la URL, encuadrarlo DESPUÉS del
      // primer frame — el MapController no existe hasta que FlutterMap se
      // monta.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        if (_medida.length >= 3) {
          _encuadrar(List.of(_medida));
        } else if (_municipioSel != null) {
          final m = _municipios!.where((x) => x.nombre == _municipioSel);
          if (m.isNotEmpty) {
            _encuadrar(m.first.anillos.expand((r) => r).toList());
          }
        }
      });
    } catch (e) {
      if (mounted) {
        setState(() => _error = e.toString().replaceFirst('Exception: ', ''));
      }
    }
  }

  // ---------------------------------------------------------------- filtros

  bool _pasaFiltros(Negocio n) {
    if (_municipioSel != null && n.municipio != _municipioSel) return false;
    if (_veredaSel != null) {
      final v = n.vereda?.nombre ?? _sinVereda;
      if (v != _veredaSel) return false;
    }
    final slug = n.categoriaOficial?.slug;
    if (slug != null && _categoriasOcultas.contains(slug)) return false;
    if (_anioMin != null &&
        (n.anioRegistro == null || n.anioRegistro! < _anioMin!)) {
      return false;
    }
    return true;
  }

  List<Negocio> get _negociosVisibles =>
      (_negocios ?? []).where(_pasaFiltros).toList();

  /// A zoom bajo se dibujan puntos simples en vez de pines con foto — así
  /// no se piden 100+ imágenes de golpe.
  bool get _pinesLivianos => _zoomActual < 12;

  int _conteoMunicipio(String nombre) =>
      (_negocios ?? []).where((n) => n.municipio == nombre).length;

  /// Veredas del municipio seleccionado con su conteo de negocios.
  List<({String nombre, int conteo})> get _veredasDelMunicipio {
    if (_municipioSel == null) return const [];
    final m = <String, int>{};
    for (final n in _negocios!) {
      if (n.municipio != _municipioSel) continue;
      final v = n.vereda?.nombre ?? _sinVereda;
      m[v] = (m[v] ?? 0) + 1;
    }
    final l = m.entries.map((e) => (nombre: e.key, conteo: e.value)).toList();
    l.sort((a, b) {
      if (a.nombre == _sinVereda) return 1;
      if (b.nombre == _sinVereda) return -1;
      return b.conteo.compareTo(a.conteo);
    });
    return l;
  }

  void _encuadrar(List<LatLng> pts) {
    if (pts.isEmpty) return;
    try {
      _mapController.fitCamera(CameraFit.coordinates(
          coordinates: pts, padding: const EdgeInsets.all(40)));
    } catch (_) {
      // El mapa todavía no está montado — reintentar tras el frame.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        try {
          _mapController.fitCamera(CameraFit.coordinates(
              coordinates: pts, padding: const EdgeInsets.all(40)));
        } catch (_) {}
      });
    }
  }

  void _seleccionarMunicipio(String? nombre) {
    setState(() {
      _municipioSel = _municipioSel == nombre ? null : nombre;
      _veredaSel = null;
      _negocioSel = null;
    });
    if (_municipioSel != null) {
      final m = _municipios!.firstWhere((x) => x.nombre == _municipioSel);
      _encuadrar(m.anillos.expand((r) => r).toList());
    }
  }

  void _seleccionarVereda(String? nombre) {
    setState(() {
      _veredaSel = _veredaSel == nombre ? null : nombre;
      _negocioSel = null;
    });
    final pts = [
      for (final n in _negociosVisibles) LatLng(n.latitud!, n.longitud!),
    ];
    _encuadrar(pts);
  }

  void _irANegocio(Negocio n) {
    setState(() {
      _negocioSel = n;
      _busquedaCtrl.clear();
    });
    _mapController.move(LatLng(n.latitud!, n.longitud!), 15);
  }

  // --------------------------------------------------- mi ubicación / lugar

  Future<void> _miUbicacionAhora() async {
    setState(() => _buscandoUbicacion = true);
    try {
      var permiso = await Geolocator.checkPermission();
      if (permiso == LocationPermission.denied) {
        permiso = await Geolocator.requestPermission();
      }
      if (permiso == LocationPermission.denied ||
          permiso == LocationPermission.deniedForever) {
        _snack('No diste permiso de ubicación.');
        return;
      }
      final pos = await Geolocator.getCurrentPosition();
      final p = LatLng(pos.latitude, pos.longitude);
      setState(() => _miUbicacion = p);
      _mapController.move(p, 13);
    } catch (_) {
      _snack('No se pudo obtener tu ubicación.');
    } finally {
      if (mounted) setState(() => _buscandoUbicacion = false);
    }
  }

  Future<void> _buscarLugar(String texto) async {
    if (texto.trim().isEmpty) return;
    setState(() => _buscandoLugar = true);
    try {
      final uri = Uri.https('nominatim.openstreetmap.org', '/search', {
        'q': '$texto, Santander, Colombia',
        'format': 'jsonv2',
        'limit': '1',
        'countrycodes': 'co',
        'viewbox': '-73.95,7.9,-72.65,6.65',
        'bounded': '1',
      });
      final r = await http.get(uri,
          headers: {'User-Agent': 'negocios-verdes-cdmb/1.0'});
      final lista = jsonDecode(r.body) as List;
      if (lista.isEmpty) {
        _snack('No se encontró "$texto" en la jurisdicción.');
        return;
      }
      final m = lista.first as Map<String, dynamic>;
      final lat = double.tryParse('${m['lat']}');
      final lng = double.tryParse('${m['lon']}');
      if (lat == null || lng == null) return;
      setState(() {
        _lugarMarcado = LatLng(lat, lng);
        _lugarNombre = (m['display_name'] as String?)?.split(',').first;
        _busquedaCtrl.clear();
      });
      _mapController.move(_lugarMarcado!, 14);
    } catch (_) {
      _snack('El buscador de lugares no respondió.');
    } finally {
      if (mounted) setState(() => _buscandoLugar = false);
    }
  }

  void _snack(String s) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(s)));
  }

  /// Ayuda como hoja lateral (showGeneralDialog) — así no interfiere con el
  /// scroll de la página ni con el layout del mapa.
  void _abrirAyuda() {
    final ancho = MediaQuery.sizeOf(context).width;
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Cerrar ayuda',
      barrierColor: Colors.black26,
      transitionDuration: const Duration(milliseconds: 200),
      // `dialogCtx` es el context DEL diálogo — hay que cerrar con ese, no
      // con el de la página (que resuelve a otro Navigator y dejaba la
      // pantalla en blanco).
      pageBuilder: (dialogCtx, _, _) => Align(
        alignment: Alignment.centerRight,
        child: SizedBox(
          width: ancho < 640 ? ancho : 380,
          height: double.infinity,
          child: _PanelAyuda(
              onCerrar: () => Navigator.of(dialogCtx).pop()),
        ),
      ),
      transitionBuilder: (_, anim, _, child) => SlideTransition(
        position: Tween(begin: const Offset(1, 0), end: Offset.zero)
            .animate(CurvedAnimation(parent: anim, curve: Curves.easeOut)),
        child: child,
      ),
    );
  }

  Future<void> _descargarPng() async {
    try {
      final bordo = _claveMapa.currentContext?.findRenderObject()
          as RenderRepaintBoundary?;
      if (bordo == null) return;
      final img = await bordo.toImage(pixelRatio: 2);
      final bytes = await img.toByteData(format: ImageByteFormat.png);
      if (bytes == null) return;
      descargarArchivoBinario(
        bytes: bytes.buffer.asUint8List(),
        nombreArchivo: 'mapa_negocios_verdes_$_fechaArchivo.png',
        tipoMime: 'image/png',
      );
    } catch (_) {
      _snack('No se pudo generar la imagen (el navegador bloqueó la captura '
          'del mapa). Prueba con una captura de pantalla.');
    }
  }

  Widget _botonMapa(IconData icono, String tip, VoidCallback? onTap,
      {bool cargando = false}) {
    return Material(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: NVColors.primaryDark, width: 1.5),
      ),
      child: IconButton(
        tooltip: tip,
        icon: cargando
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2))
            : Icon(icono),
        color: NVColors.primaryDark,
        onPressed: onTap,
      ),
    );
  }

  Future<void> _copiarEnlace() async {
    final qp = <String, String>{};
    if (_municipioSel != null) qp['mun'] = _municipioSel!;
    if (_categoriasOcultas.isNotEmpty) {
      qp['sincat'] = _categoriasOcultas.join(',');
    }
    if (_anioMin != null) qp['anio'] = '$_anioMin';
    final uri = Uri.base.replace(
        path: '/geovisor', queryParameters: qp.isEmpty ? null : qp);
    await Clipboard.setData(ClipboardData(text: uri.toString()));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enlace de esta vista copiado')),
      );
    }
  }

  // ------------------------------------------------- herramienta de medición

  void _tocarMapa(LatLng p) {
    if (_modoMedir) {
      setState(() => _medida.add(p));
    } else if (_modoCerca) {
      setState(() => _puntoCerca = p);
    }
  }

  List<Negocio> get _negociosCerca {
    final c = _puntoCerca;
    if (c == null) return const [];
    return (_negocios ?? [])
        .where((n) => _dist(c, LatLng(n.latitud!, n.longitud!)) <= _radioCerca)
        .toList()
      ..sort((a, b) => _dist(c, LatLng(a.latitud!, a.longitud!))
          .compareTo(_dist(c, LatLng(b.latitud!, b.longitud!))));
  }

  /// Polígono de ~40 lados que aproxima el círculo (para el GeoJSON).
  List<LatLng> _circuloComoPoligono(LatLng c, double radioM) {
    const n = 40;
    final out = <LatLng>[];
    final latR = radioM / 111320.0;
    final lonR = radioM / (111320.0 * math.cos(_rad(c.latitude)));
    for (var i = 0; i <= n; i++) {
      final a = 2 * math.pi * i / n;
      out.add(LatLng(
          c.latitude + latR * math.sin(a), c.longitude + lonR * math.cos(a)));
    }
    return out;
  }

  void _descargarCerca() {
    final c = _puntoCerca;
    if (c == null) return;
    descargarArchivoTexto(
      contenido: geoJsonNegocios(
        _negociosCerca,
        zona: _circuloComoPoligono(c, _radioCerca.toDouble()),
        areaKm2: math.pi * math.pow(_radioCerca / 1000, 2).toDouble(),
        origen: Uri.base.origin,
      ),
      nombreArchivo: 'cerca_negocios_verdes_$_fechaArchivo.geojson',
      tipoMime: 'application/geo+json;charset=utf-8',
    );
  }

  /// Distancia en metros entre dos puntos (haversine).
  double _dist(LatLng a, LatLng b) {
    const r = 6371000.0;
    final dLat = _rad(b.latitude - a.latitude);
    final dLon = _rad(b.longitude - a.longitude);
    final h = math.pow(math.sin(dLat / 2), 2) +
        math.cos(_rad(a.latitude)) *
            math.cos(_rad(b.latitude)) *
            math.pow(math.sin(dLon / 2), 2);
    return 2 * r * math.asin(math.sqrt(h.toDouble()));
  }

  double _rad(double g) => g * math.pi / 180;

  /// Suma de los segmentos SIN cerrar — la longitud del recorrido dibujado.
  double get _distanciaLineaMetros {
    if (_medida.length < 2) return 0;
    var t = 0.0;
    for (var i = 0; i < _medida.length - 1; i++) {
      t += _dist(_medida[i], _medida[i + 1]);
    }
    return t;
  }

  /// Perímetro de la zona = recorrido + el segmento de cierre.
  double get _perimetroMetros {
    if (_medida.length < 3) return _distanciaLineaMetros;
    return _distanciaLineaMetros + _dist(_medida.last, _medida.first);
  }

  /// Área en m² de la zona dibujada (proyección equirectangular local +
  /// fórmula del cordonero — exacta a esta escala).
  double get _areaMetros2 {
    if (_medida.length < 3) return 0;
    final lat0 = _rad(_medida
            .map((p) => p.latitude)
            .reduce((a, b) => a + b) /
        _medida.length);
    const mPorGrado = 111320.0;
    double x(LatLng p) => p.longitude * mPorGrado * math.cos(lat0);
    double y(LatLng p) => p.latitude * mPorGrado;
    var s = 0.0;
    for (var i = 0; i < _medida.length; i++) {
      final a = _medida[i];
      final b = _medida[(i + 1) % _medida.length];
      s += x(a) * y(b) - x(b) * y(a);
    }
    return s.abs() / 2;
  }

  bool _puntoEnPoligono(LatLng p, List<LatLng> poly) {
    var dentro = false;
    for (var i = 0, j = poly.length - 1; i < poly.length; j = i++) {
      final xi = poly[i].longitude, yi = poly[i].latitude;
      final xj = poly[j].longitude, yj = poly[j].latitude;
      if (((yi > p.latitude) != (yj > p.latitude)) &&
          (p.longitude <
              (xj - xi) * (p.latitude - yi) / (yj - yi) + xi)) {
        dentro = !dentro;
      }
    }
    return dentro;
  }

  List<Polygon<String>> _poligonosMunicipio() => [
        for (final m in _municipios!)
          Polygon<String>(
            hitValue: m.nombre,
            points: m.anillos.isEmpty ? const [] : m.anillos.first,
            holePointsList:
                m.anillos.length > 1 ? m.anillos.sublist(1) : null,
            borderColor: _municipioSel == m.nombre
                ? NVColors.accent
                : NVColors.primaryDark,
            borderStrokeWidth: _municipioSel == m.nombre ? 3 : 1.4,
            color: (_municipioSel == m.nombre
                    ? NVColors.accent
                    : NVColors.primary)
                .withValues(alpha: 0.07),
          ),
      ];

  /// Áreas protegidas con un punto para su etiqueta (centro del anillo más
  /// grande). Solo las > 300 ha, para no saturar el mapa de rótulos.
  List<(CapaGeoElemento, LatLng)> get _areasConCentro {
    final out = <(CapaGeoElemento, LatLng)>[];
    for (final e in _areas!.elementos) {
      if (e.poligonos.isEmpty || (e.nombre ?? '').isEmpty) continue;
      if ((double.tryParse(e.prop('hectareas') ?? '0') ?? 0) < 300) continue;
      final ring = e.poligonos.reduce((a, b) => a.length >= b.length ? a : b);
      if (ring.length < 6) continue;
      var lat = 0.0, lng = 0.0;
      for (final p in ring) {
        lat += p.latitude;
        lng += p.longitude;
      }
      out.add((e, LatLng(lat / ring.length, lng / ring.length)));
    }
    return out;
  }

  List<Negocio> get _negociosEnZona => _medida.length < 3
      ? const []
      : (_negocios ?? [])
          .where((n) =>
              _puntoEnPoligono(LatLng(n.latitud!, n.longitud!), _medida))
          .toList();

  String get _fechaArchivo {
    final h = DateTime.now();
    return '${h.year}${h.month.toString().padLeft(2, '0')}'
        '${h.day.toString().padLeft(2, '0')}';
  }

  /// Nombres de las áreas protegidas cargadas que intersectan la zona
  /// dibujada (aprox: un vértice de una dentro de la otra).
  List<String> get _areasEnZona {
    if (_areas == null || _medida.length < 3) return const [];
    final out = <String>{};
    for (final e in _areas!.elementos) {
      final n = e.nombre;
      if (n == null || n.isEmpty) continue;
      for (final anillo in e.poligonos) {
        final toca = anillo.any((p) => _puntoEnPoligono(p, _medida)) ||
            _medida.any((p) => _puntoEnPoligono(p, anillo));
        if (toca) {
          out.add(n);
          break;
        }
      }
    }
    return out.toList()..sort();
  }

  void _descargarZona() {
    descargarArchivoTexto(
      contenido: geoJsonNegocios(
        _negociosEnZona,
        zona: _medida,
        areaKm2: _areaMetros2 / 1e6,
        perimetroKm: _perimetroMetros / 1000,
        origen: Uri.base.origin,
      ),
      nombreArchivo: 'zona_negocios_verdes_$_fechaArchivo.geojson',
      tipoMime: 'application/geo+json;charset=utf-8',
    );
  }

  void _descargarVisibles({required bool csv}) {
    final negs = _negociosVisibles;
    descargarArchivoTexto(
      contenido: csv
          ? csvNegocios(negs, origen: Uri.base.origin)
          : geoJsonNegocios(negs, origen: Uri.base.origin),
      nombreArchivo:
          'negocios_verdes_$_fechaArchivo.${csv ? 'csv' : 'geojson'}',
      tipoMime: csv
          ? 'text/csv;charset=utf-8'
          : 'application/geo+json;charset=utf-8',
    );
  }

  void _descargarReporte() {
    final enZona = _medida.length >= 3;
    final cerca = !enZona && _puntoCerca != null;
    final c = _puntoCerca;

    final List<Negocio> negs;
    final String titulo;
    final List<LatLng> zonaReporte;
    final double? areaKm2;
    final double? perimetroKm;
    final List<String> areasProtegidas;

    if (enZona) {
      negs = _negociosEnZona;
      titulo = 'Reporte de zona seleccionada';
      zonaReporte = List.of(_medida);
      areaKm2 = _areaMetros2 / 1e6;
      perimetroKm = _perimetroMetros / 1000;
      areasProtegidas = _areasEnZona;
    } else if (cerca && c != null) {
      negs = _negociosCerca;
      titulo = 'Negocios verdes a menos de ${_fmtDist(_radioCerca.toDouble())} '
          'de un punto';
      zonaReporte = _circuloComoPoligono(c, _radioCerca.toDouble());
      areaKm2 = math.pi * math.pow(_radioCerca / 1000, 2).toDouble();
      perimetroKm = null;
      areasProtegidas = const [];
    } else {
      negs = _negociosVisibles;
      titulo = _municipioSel != null
          ? 'Negocios verdes de ${_municipioSel!}'
          : 'Negocios verdes — vista actual';
      zonaReporte = const [];
      areaKm2 = null;
      perimetroKm = null;
      areasProtegidas = const [];
    }

    descargarArchivoTexto(
      contenido: htmlReporte(
        titulo: titulo,
        negocios: negs,
        zona: zonaReporte,
        areaKm2: areaKm2,
        perimetroKm: perimetroKm,
        areasProtegidas: areasProtegidas,
        origen: Uri.base.origin,
      ),
      nombreArchivo: 'reporte_negocios_verdes_$_fechaArchivo.html',
      tipoMime: 'text/html;charset=utf-8',
    );
  }

  Future<void> _copiarEnlaceZona() async {
    final z = zonaAParam(_medida);
    if (z == null) return;
    final uri = Uri.base
        .replace(path: '/geovisor', queryParameters: {'zona': z});
    await Clipboard.setData(ClipboardData(text: uri.toString()));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enlace de la zona copiado')),
      );
    }
  }

  // ----------------------------------------------------------------- build

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        final ancho = c.maxWidth >= 900;
        final mapaWidget = ancho
            ? Row(
                children: [
                  if (_panelAbierto)
                    SizedBox(width: 310, child: _panel()),
                  Expanded(child: _mapa()),
                ],
              )
            : Stack(
                children: [
                  _mapa(),
                  if (_panelAbierto)
                    Positioned.fill(
                      child: ColoredBox(
                        color: Colors.black26,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: SizedBox(width: 290, child: _panel()),
                        ),
                      ),
                    ),
                ],
              );

        // Modo embed: ocupa todo el alto disponible, sin scroll ni pie.
        if (widget.embed) return mapaWidget;

        // Alto atado a la ventana: así el mapa (y la tarjeta que flota
        // abajo) siempre caben en pantalla sin scroll.
        final alto = (MediaQuery.sizeOf(context).height - 200)
            .clamp(440.0, 900.0);
        return SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: alto, child: mapaWidget),
              const PiePagina(),
            ],
          ),
        );
      },
    );
  }

  Widget _mapa() {
    if (_error != null) return Center(child: Text(_error!));
    if (_municipios == null || _negocios == null) {
      return const Center(child: CircularProgressIndicator());
    }
    final visibles = _negociosVisibles;
    return Stack(
      children: [
        RepaintBoundary(
          key: _claveMapa,
          child: FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            onTap: (_, latlng) => _tocarMapa(latlng),
            onPositionChanged: (camara, _) {
              if ((camara.zoom - _zoomActual).abs() >= 1) {
                setState(() => _zoomActual = camara.zoom);
              }
            },
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
            // --- capas de contexto (debajo de municipios y negocios) ---
            if (_capaHidro && _hidro != null) ...[
              PolygonLayer(
                polygons: [
                  for (final e in _hidro!.elementos)
                    for (final anillo in e.poligonos)
                      Polygon(
                        points: anillo,
                        color: const Color(0xFF3D7EB8)
                            .withValues(alpha: e.tipo == 'río' ? 0.75 : 0.5),
                        borderColor: const Color(0xFF2E6DA4),
                        borderStrokeWidth: 0.6,
                      ),
                ],
              ),
              PolylineLayer(
                polylines: [
                  for (final e in _hidro!.elementos)
                    for (final linea in e.lineas)
                      Polyline(
                        points: linea,
                        color: const Color(0xFF3D7EB8),
                        strokeWidth: 1.5,
                      ),
                ],
              ),
            ],
            if (_capaAreas && _areas != null)
              PolygonLayer(
                polygons: [
                  for (final e in _areas!.elementos)
                    for (final anillo in e.poligonos)
                      Polygon(
                        points: anillo,
                        color: (e.prop('administra') == 'CDMB'
                                ? const Color(0xFF2E8B57)
                                : const Color(0xFF6B8E23))
                            .withValues(alpha: 0.16),
                        borderColor: e.prop('administra') == 'CDMB'
                            ? const Color(0xFF1E6B3E)
                            : const Color(0xFF556B2F),
                        borderStrokeWidth: 1.2,
                      ),
                ],
              ),
            if (_capaMunicipios) ...[
              // En modo medición no se envuelve en GestureDetector para que
              // los toques lleguen a MapOptions.onTap.
              if (_modoMedir)
                PolygonLayer(polygons: _poligonosMunicipio())
              else
                MouseRegion(
                  hitTestBehavior: HitTestBehavior.deferToChild,
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () {
                      final hit = _hitMunicipios.value;
                      if (hit != null && hit.hitValues.isNotEmpty) {
                        _seleccionarMunicipio(hit.hitValues.first);
                      }
                    },
                    child: PolygonLayer<String>(
                      hitNotifier: _hitMunicipios,
                      polygons: _poligonosMunicipio(),
                    ),
                  ),
                ),
            ],
            if (_capaAreas && _capaEtiquetasAreas && _areas != null)
              MarkerLayer(
                markers: [
                  for (final e in _areasConCentro)
                    Marker(
                      point: e.$2,
                      width: 130,
                      height: 26,
                      child: _EtiquetaMunicipio(
                          texto: e.$1.nombre ?? '', activo: false),
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
            // Mapa de calor: círculos translúcidos superpuestos = densidad.
            if (_capaCalor)
              CircleLayer(
                circles: [
                  for (final n in visibles)
                    CircleMarker(
                      point: LatLng(n.latitud!, n.longitud!),
                      radius: 26,
                      useRadiusInMeter: false,
                      color: const Color(0xFF01BD32).withValues(alpha: 0.14),
                      borderStrokeWidth: 0,
                    ),
                ],
              ),
            if (_capaNegocios && !_capaCalor)
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
                        width: _pinesLivianos ? 16 : 44,
                        height: _pinesLivianos ? 16 : 44,
                        child: _pinesLivianos && n.id != _negocioSel?.id
                            ? const _PuntoNegocio()
                            : PinNegocioMapa(
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
            if (_miUbicacion != null)
              MarkerLayer(markers: [
                Marker(
                  point: _miUbicacion!,
                  width: 22,
                  height: 22,
                  child: const _PuntoUbicacion(),
                ),
              ]),
            if (_lugarMarcado != null)
              MarkerLayer(markers: [
                Marker(
                  point: _lugarMarcado!,
                  width: 30,
                  height: 30,
                  child: const Icon(Icons.location_on,
                      color: NVColors.accent, size: 30),
                ),
              ]),
            // Herramienta "negocios cerca de un punto".
            if (_puntoCerca != null) ...[
              CircleLayer(circles: [
                CircleMarker(
                  point: _puntoCerca!,
                  radius: _radioCerca.toDouble(),
                  useRadiusInMeter: true,
                  color: NVColors.accent.withValues(alpha: 0.10),
                  borderColor: NVColors.accent,
                  borderStrokeWidth: 2,
                ),
              ]),
              MarkerLayer(markers: [
                Marker(
                  point: _puntoCerca!,
                  width: 18,
                  height: 18,
                  child: Container(
                    decoration: BoxDecoration(
                      color: NVColors.accent,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                    ),
                  ),
                ),
              ]),
            ],
            // Herramienta de medición / zona.
            if (_medirArea && _medida.length >= 3)
              PolygonLayer(polygons: [
                Polygon(
                  points: _medida,
                  color: NVColors.accent.withValues(alpha: 0.12),
                  borderColor: NVColors.accent,
                  borderStrokeWidth: 2,
                ),
              ]),
            if (_medida.length >= 2)
              PolylineLayer(polylines: [
                Polyline(
                  points: _medirArea && _medida.length >= 3
                      ? [..._medida, _medida.first]
                      : _medida,
                  color: NVColors.accent,
                  strokeWidth: 2,
                ),
              ]),
            if (_medida.isNotEmpty)
              MarkerLayer(
                markers: [
                  for (final p in _medida)
                    Marker(
                      point: p,
                      width: 14,
                      height: 14,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border:
                              Border.all(color: NVColors.accent, width: 3),
                        ),
                      ),
                    ),
                ],
              ),
            RichAttributionWidget(
              alignment: AttributionAlignment.bottomRight,
              showFlutterMapAttribution: false,
              attributions: [
                TextSourceAttribution(
                  'Base © OpenStreetMap · Áreas: RUNAP · Hidrografía: IDEAM',
                  onTap: () => launchUrl(
                      Uri.parse('https://www.openstreetmap.org/copyright')),
                ),
              ],
            ),
          ],
        ),
        ),
        Positioned(
          right: 12,
          top: 12,
          child: BotonesZoomMapa(controlador: _mapController),
        ),
        Positioned(
          left: 12,
          top: 12,
          child: Column(
            children: [
              _botonMapa(
                _panelAbierto ? Icons.layers_clear : Icons.layers,
                _panelAbierto ? 'Ocultar panel' : 'Mostrar panel',
                () => setState(() => _panelAbierto = !_panelAbierto),
              ),
              const SizedBox(height: 6),
              _botonMapa(
                Icons.my_location,
                'Mi ubicación',
                _buscandoUbicacion ? null : _miUbicacionAhora,
                cargando: _buscandoUbicacion,
              ),
              const SizedBox(height: 6),
              _botonMapa(
                  Icons.photo_camera_outlined, 'Descargar imagen', _descargarPng),
              const SizedBox(height: 6),
              _botonMapa(Icons.help_outline, 'Ayuda', _abrirAyuda),
            ],
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
                : _municipioSel != null || _veredaSel != null
                    ? _ChipFiltroActivo(
                        texto: [
                          if (_municipioSel != null) _municipioSel!,
                          if (_veredaSel != null) _veredaSel!,
                        ].join(' · '),
                        conteo: _negociosVisibles.length,
                        onQuitar: () => setState(() {
                          _municipioSel = null;
                          _veredaSel = null;
                        }),
                      )
                    : const SizedBox.shrink(),
          ),
        ),
      ],
    );
  }

  bool get _hayFiltro =>
      _municipioSel != null ||
      _veredaSel != null ||
      _categoriasOcultas.isNotEmpty ||
      _anioMin != null;

  void _verTodo() {
    setState(() {
      _municipioSel = null;
      _veredaSel = null;
      _categoriasOcultas.clear();
      _anioMin = null;
      _negocioSel = null;
    });
  }

  Widget _panel() {
    final cuerpo = switch (_panelTab) {
      _PanelTab.filtrar => _tabFiltrar(),
      _PanelTab.capas => _tabCapas(),
      _PanelTab.herramientas => _tabHerramientas(),
    };
    return Material(
      elevation: 2,
      color: NVColors.superficie,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 6, 4),
            child: Row(
              children: [
                const Icon(Icons.travel_explore,
                    size: 20, color: NVColors.primaryDark),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text('Geovisor',
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
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: SegmentedButton<_PanelTab>(
              showSelectedIcon: false,
              style: const ButtonStyle(
                visualDensity: VisualDensity.compact,
                textStyle: WidgetStatePropertyAll(TextStyle(fontSize: 12)),
              ),
              segments: const [
                ButtonSegment(
                    value: _PanelTab.filtrar,
                    label: Text('Filtrar'),
                    icon: Icon(Icons.tune, size: 15)),
                ButtonSegment(
                    value: _PanelTab.capas,
                    label: Text('Capas'),
                    icon: Icon(Icons.layers, size: 15)),
                ButtonSegment(
                    value: _PanelTab.herramientas,
                    label: Text('Medir'),
                    icon: Icon(Icons.straighten, size: 15)),
              ],
              selected: {_panelTab},
              onSelectionChanged: (s) =>
                  setState(() => _panelTab = s.first),
            ),
          ),
          const SizedBox(height: 4),
          Expanded(
            child: Scrollbar(
              controller: _panelScroll,
              thumbVisibility: true,
              child: ListView(
                controller: _panelScroll,
                primary: false,
                padding: const EdgeInsets.fromLTRB(14, 8, 18, 40),
                children: [cuerpo],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tabFiltrar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buscador(),
        const SizedBox(height: 8),
        if (_hayFiltro)
          OutlinedButton.icon(
            onPressed: _verTodo,
            icon: const Icon(Icons.restart_alt, size: 16),
            label: const Text('Ver todo (quitar filtros)'),
          ),
        const Divider(height: 20),
        _miniGrafico(),
        const Divider(height: 20),
        const _Rotulo('Por municipio'),
        if (_municipios != null)
          for (final m in _municipiosOrdenados) ...[
            _FilaLista(
              nombre: m.nombre,
              conteo: _conteoMunicipio(m.nombre),
              activo: _municipioSel == m.nombre,
              onTap: () => _seleccionarMunicipio(m.nombre),
            ),
            if (_municipioSel == m.nombre)
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Column(
                  children: [
                    const _Rotulo('Veredas'),
                    for (final v in _veredasDelMunicipio)
                      _FilaLista(
                        nombre: v.nombre,
                        conteo: v.conteo,
                        activo: _veredaSel == v.nombre,
                        menor: true,
                        onTap: () => _seleccionarVereda(v.nombre),
                      ),
                  ],
                ),
              ),
          ],
        const Divider(height: 24),
        const _Rotulo('Por categoría'),
        for (final c in _categoriasPublicas)
          _check(
            '${c.iconoOTexto} ${c.nombre}',
            !_categoriasOcultas.contains(c.slug),
            (v) => setState(() => v
                ? _categoriasOcultas.remove(c.slug)
                : _categoriasOcultas.add(c.slug)),
          ),
        const SizedBox(height: 8),
        _filtroAnio(),
        const Divider(height: 24),
        OutlinedButton.icon(
          onPressed: _copiarEnlace,
          icon: const Icon(Icons.link, size: 18),
          label: const Text('Copiar enlace de esta vista'),
        ),
      ],
    );
  }

  Widget _filtroAnio() {
    final anios = <int>{
      for (final n in (_negocios ?? []))
        if (n.anioRegistro != null) n.anioRegistro!,
    }.toList()
      ..sort();
    if (anios.length < 2) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _Rotulo('Registrados desde'),
        DropdownButton<int?>(
          isDense: true,
          value: _anioMin,
          hint: const Text('Cualquier año', style: TextStyle(fontSize: 13)),
          items: [
            const DropdownMenuItem(value: null, child: Text('Cualquier año')),
            for (final a in anios)
              DropdownMenuItem(value: a, child: Text('$a o después')),
          ],
          onChanged: (v) => setState(() => _anioMin = v),
        ),
      ],
    );
  }

  /// Barras horizontales compactas: negocios de la vista actual por
  /// categoría.
  Widget _miniGrafico() {
    final vis = _negociosVisibles;
    if (vis.isEmpty) return const SizedBox.shrink();
    final porCat = <String, int>{};
    for (final n in vis) {
      final c = n.categoriaOficial;
      final k = (c == null || c.slug == 'pendiente-clasificar')
          ? 'Sin clasificar'
          : c.nombre;
      porCat[k] = (porCat[k] ?? 0) + 1;
    }
    final filas = porCat.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final maxV = filas.first.value;

    Widget barra(String etq, int v, Color color) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Row(children: [
            SizedBox(
              width: 96,
              child: Text(etq,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 10.5)),
            ),
            Expanded(
              child: Stack(children: [
                Container(height: 12, color: NVColors.borde.withValues(alpha: 0.4)),
                FractionallySizedBox(
                  widthFactor: maxV == 0 ? 0 : v / maxV,
                  child: Container(height: 12, color: color),
                ),
              ]),
            ),
            SizedBox(
                width: 26,
                child: Text('  $v',
                    style: const TextStyle(
                        fontSize: 10.5, fontWeight: FontWeight.w600))),
          ]),
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Rotulo('${vis.length} negocios en la vista · por categoría'),
        for (final e in filas)
          barra(e.key, e.value,
              e.key == 'Sin clasificar' ? NVColors.textoSecundario : NVColors.primary),
      ],
    );
  }

  Widget _tabCapas() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _check('Negocios verdes  (${_negociosVisibles.length})',
            _capaNegocios, (v) => setState(() => _capaNegocios = v)),
        _check('Mapa de calor (densidad)', _capaCalor,
            (v) => setState(() => _capaCalor = v)),
        const Divider(height: 20),
        _check('Límites municipales', _capaMunicipios,
            (v) => setState(() => _capaMunicipios = v)),
        if (_capaMunicipios)
          Padding(
            padding: const EdgeInsets.only(left: 24),
            child: _check('Etiquetas de municipio', _capaEtiquetas,
                (v) => setState(() => _capaEtiquetas = v)),
          ),
        const Divider(height: 20),
        _seccionContexto(),
        const Divider(height: 20),
        _leyenda(),
      ],
    );
  }

  Widget _tabHerramientas() => _seccionHerramientas();

  Widget _leyenda() {
    Widget fila(Color c, String t, {bool linea = false}) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 3),
          child: Row(children: [
            Container(
              width: 16,
              height: linea ? 3 : 12,
              decoration: BoxDecoration(
                color: linea ? c : c.withValues(alpha: 0.25),
                border: linea ? null : Border.all(color: c, width: 1.4),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(child: Text(t, style: const TextStyle(fontSize: 11.5))),
          ]),
        );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _Rotulo('Leyenda'),
        fila(NVColors.primaryDark, 'Municipio'),
        fila(NVColors.accent, 'Municipio / zona seleccionada'),
        fila(const Color(0xFF1E6B3E), 'Área protegida administrada por CDMB'),
        fila(const Color(0xFF556B2F), 'Área protegida de otra entidad'),
        fila(const Color(0xFF3D7EB8), 'Ríos y cuerpos de agua'),
      ],
    );
  }

  String _fmtDist(double m) =>
      m < 1000 ? '${m.toStringAsFixed(0)} m' : '${(m / 1000).toStringAsFixed(2)} km';

  String _fmtArea(double m2) {
    if (m2 < 10000) return '${m2.toStringAsFixed(0)} m²';
    final ha = m2 / 10000;
    if (ha < 100) return '${ha.toStringAsFixed(1)} ha';
    return '${(m2 / 1e6).toStringAsFixed(2)} km²  (${ha.toStringAsFixed(0)} ha)';
  }

  Widget _seccionHerramientas() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _Rotulo('Herramientas'),
        _check(
          'Medir / seleccionar una zona',
          _modoMedir,
          (v) => setState(() {
            _modoMedir = v;
            if (v) {
              _modoCerca = false;
              _puntoCerca = null;
            } else {
              _medida.clear();
            }
          }),
        ),
        if (_modoMedir) ...[
          const SizedBox(height: 6),
          SegmentedButton<bool>(
            showSelectedIcon: false,
            style: const ButtonStyle(
              visualDensity: VisualDensity.compact,
              textStyle: WidgetStatePropertyAll(TextStyle(fontSize: 12)),
            ),
            segments: const [
              ButtonSegment(value: false, label: Text('Distancia')),
              ButtonSegment(value: true, label: Text('Zona / área')),
            ],
            selected: {_medirArea},
            onSelectionChanged: (s) => setState(() => _medirArea = s.first),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 6, 4, 6),
            child: Text(
              _medirArea
                  ? 'Toca el mapa para marcar puntos. Con 3+ se cierra la '
                      'zona y se puede descargar.'
                  : 'Toca el mapa para marcar el recorrido a medir (una vía, '
                      'un río, un lindero…).',
              style: const TextStyle(
                  fontSize: 11, color: NVColors.textoSecundario),
            ),
          ),
          if (_medida.length >= 2)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                !_medirArea || _medida.length < 3
                    ? 'Distancia total: ${_fmtDist(_distanciaLineaMetros)}'
                    : 'Perímetro: ${_fmtDist(_perimetroMetros)}\n'
                        'Área: ${_fmtArea(_areaMetros2)}\n'
                        'Negocios verdes dentro: ${_negociosEnZona.length}',
                style: const TextStyle(
                    fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              OutlinedButton.icon(
                onPressed: _medida.isEmpty
                    ? null
                    : () => setState(() => _medida.removeLast()),
                icon: const Icon(Icons.undo, size: 16),
                label: const Text('Quitar punto'),
              ),
              OutlinedButton.icon(
                onPressed: _medida.isEmpty
                    ? null
                    : () => setState(_medida.clear),
                icon: const Icon(Icons.clear, size: 16),
                label: const Text('Limpiar'),
              ),
            ],
          ),
          if (_medida.isNotEmpty) ...[
            const SizedBox(height: 6),
            const _Rotulo('Puntos (lat, lng)'),
            for (var i = 0; i < _medida.length; i++)
              InkWell(
                onTap: () => Clipboard.setData(ClipboardData(
                    text: '${_medida[i].latitude.toStringAsFixed(6)}, '
                        '${_medida[i].longitude.toStringAsFixed(6)}')),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3),
                  child: Row(children: [
                    SizedBox(
                        width: 18,
                        child: Text('${i + 1}',
                            style: const TextStyle(
                                fontSize: 11,
                                color: NVColors.textoSecundario))),
                    Expanded(
                      child: Text(
                        '${_medida[i].latitude.toStringAsFixed(6)}, '
                        '${_medida[i].longitude.toStringAsFixed(6)}',
                        style: const TextStyle(fontSize: 11.5),
                      ),
                    ),
                    const Icon(Icons.copy,
                        size: 13, color: NVColors.textoSecundario),
                  ]),
                ),
              ),
          ],
          if (_medirArea) ...[
            const SizedBox(height: 6),
            FilledButton.icon(
              onPressed: _medida.length >= 3 ? _descargarZona : null,
              icon: const Icon(Icons.download, size: 18),
              label: const Text('Descargar zona (GeoJSON)'),
            ),
            const SizedBox(height: 6),
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: [
                OutlinedButton.icon(
                  onPressed: _medida.length >= 3 ? _copiarEnlaceZona : null,
                  icon: const Icon(Icons.link, size: 16),
                  label: const Text('Enlace de la zona'),
                ),
                OutlinedButton.icon(
                  onPressed:
                      _medida.length >= 3 ? _descargarReporte : null,
                  icon: const Icon(Icons.description_outlined, size: 16),
                  label: const Text('Reporte (HTML)'),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(4, 4, 4, 0),
              child: Text(
                'El GeoJSON incluye la zona y los negocios de adentro; se '
                'abre en QGIS, ArcGIS o Google Earth. El reporte es una '
                'página lista para imprimir o guardar como PDF.',
                style: TextStyle(
                    fontSize: 10.5, color: NVColors.textoSecundario),
              ),
            ),
          ],
        ],
        const Divider(height: 20),
        _check(
          'Negocios cerca de un punto',
          _modoCerca,
          (v) => setState(() {
            _modoCerca = v;
            if (v) {
              _modoMedir = false;
              _medida.clear();
            } else {
              _puntoCerca = null;
            }
          }),
        ),
        if (_modoCerca) ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
            child: Row(children: [
              Expanded(
                child: Text(
                  _puntoCerca == null
                      ? 'Toca el mapa para elegir un punto.'
                      : '${_negociosCerca.length} negocio'
                          '${_negociosCerca.length == 1 ? '' : 's'} verde'
                          '${_negociosCerca.length == 1 ? '' : 's'} a menos de '
                          '${_fmtDist(_radioCerca.toDouble())}',
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w600),
                ),
              ),
              TextButton.icon(
                onPressed: () async {
                  await _miUbicacionAhora();
                  if (_miUbicacion != null) {
                    setState(() => _puntoCerca = _miUbicacion);
                  }
                },
                icon: const Icon(Icons.my_location, size: 15),
                label: const Text('Usar mi ubicación'),
              ),
            ]),
          ),
          Wrap(
            spacing: 6,
            runSpacing: 4,
            children: [
              for (final r in const [500, 1000, 2000, 5000])
                ChoiceChip(
                  label: Text(_fmtDist(r.toDouble()),
                      style: const TextStyle(fontSize: 11)),
                  selected: _radioCerca == r,
                  onSelected: (_) => setState(() => _radioCerca = r),
                ),
            ],
          ),
          if (_puntoCerca != null) ...[
            const SizedBox(height: 4),
            for (final n in _negociosCerca.take(12))
              InkWell(
                onTap: () => setState(() => _negocioSel = n),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 2),
                  child: Text(
                    '· ${n.nombre}  ·  '
                    '${_fmtDist(_dist(_puntoCerca!, LatLng(n.latitud!, n.longitud!)))}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 11.5),
                  ),
                ),
              ),
            if (_negociosCerca.length > 12)
              Text('… y ${_negociosCerca.length - 12} más',
                  style: const TextStyle(
                      fontSize: 11, color: NVColors.textoSecundario)),
            const SizedBox(height: 6),
            OutlinedButton.icon(
              onPressed:
                  _negociosCerca.isEmpty ? null : _descargarCerca,
              icon: const Icon(Icons.download, size: 16),
              label: const Text('Descargar (GeoJSON)'),
            ),
          ],
        ],
        const SizedBox(height: 10),
        const _Rotulo('Descargar lo que se ve ahora'),
        Wrap(
          spacing: 8,
          runSpacing: 6,
          children: [
            OutlinedButton.icon(
              onPressed: _negociosVisibles.isEmpty
                  ? null
                  : () => _descargarVisibles(csv: false),
              icon: const Icon(Icons.map_outlined, size: 16),
              label: Text('GeoJSON (${_negociosVisibles.length})'),
            ),
            OutlinedButton.icon(
              onPressed: _negociosVisibles.isEmpty
                  ? null
                  : () => _descargarVisibles(csv: true),
              icon: const Icon(Icons.table_chart_outlined, size: 16),
              label: const Text('CSV'),
            ),
            OutlinedButton.icon(
              onPressed:
                  _negociosVisibles.isEmpty ? null : _descargarReporte,
              icon: const Icon(Icons.description_outlined, size: 16),
              label: const Text('Reporte'),
            ),
          ],
        ),
        const Padding(
          padding: EdgeInsets.fromLTRB(4, 4, 4, 0),
          child: Text(
            'Respeta los filtros activos (municipio, categoría, '
            'año). Sin registrarse.',
            style: TextStyle(fontSize: 10.5, color: NVColors.textoSecundario),
          ),
        ),
      ],
    );
  }

  Widget _seccionContexto() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _Rotulo('Capas de contexto'),
        _check(
          _cargandoAreas
              ? 'Áreas protegidas  (cargando…)'
              : _areas != null
                  ? 'Áreas protegidas — RUNAP  (${_areas!.elementos.length})'
                  : 'Áreas protegidas — RUNAP',
          _capaAreas,
          _toggleAreas,
        ),
        if (_capaAreas)
          Padding(
            padding: const EdgeInsets.only(left: 24),
            child: _check('Etiquetas de área protegida', _capaEtiquetasAreas,
                (v) => setState(() => _capaEtiquetasAreas = v)),
          ),
        if (_capaAreas && _areas != null)
          for (final e in _areasOrdenadas)
            _FilaArea(
              elemento: e,
              onZoom: () => _encuadrar([for (final r in e.poligonos) ...r]),
              onLink: () {
                final u = e.prop('url');
                if (u != null && u.isNotEmpty) launchUrl(Uri.parse(u));
              },
            ),
        _check(
          _cargandoHidro
              ? 'Hidrografía  (cargando…)'
              : 'Hidrografía — IDEAM  (ríos y cuerpos de agua)',
          _capaHidro,
          _toggleHidro,
        ),
      ],
    );
  }

  Widget _buscador() {
    final q = quitarTildes(_busquedaCtrl.text.trim().toLowerCase());
    final sugerencias = q.isEmpty
        ? const <Negocio>[]
        : (_negocios ?? [])
            .where((n) => quitarTildes(n.nombre.toLowerCase()).contains(q))
            .take(8)
            .toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _busquedaCtrl,
          decoration: InputDecoration(
            isDense: true,
            prefixIcon: _buscandoLugar
                ? const Padding(
                    padding: EdgeInsets.all(12),
                    child: SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(strokeWidth: 2)))
                : const Icon(Icons.search, size: 18),
            hintText: 'Buscar un negocio o un lugar…',
            suffixIcon: _busquedaCtrl.text.isEmpty
                ? null
                : IconButton(
                    iconSize: 16,
                    icon: const Icon(Icons.close),
                    onPressed: () => setState(() => _busquedaCtrl.clear()),
                  ),
          ),
          textInputAction: TextInputAction.search,
          onChanged: (_) => setState(() {}),
          onSubmitted: (v) {
            if (sugerencias.isNotEmpty) {
              _irANegocio(sugerencias.first);
            } else {
              _buscarLugar(v);
            }
          },
        ),
        for (final n in sugerencias)
          InkWell(
            onTap: () => _irANegocio(n),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 4),
              child: Text('${n.nombre}  ·  ${n.municipio}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12)),
            ),
          ),
        if (_busquedaCtrl.text.trim().length >= 3 && sugerencias.isEmpty)
          InkWell(
            onTap: () => _buscarLugar(_busquedaCtrl.text),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
              child: Row(children: [
                const Icon(Icons.place_outlined,
                    size: 15, color: NVColors.primary),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Buscar "${_busquedaCtrl.text.trim()}" como lugar en el mapa',
                    style: const TextStyle(
                        fontSize: 12, color: NVColors.primary),
                  ),
                ),
              ]),
            ),
          ),
        if (_lugarMarcado != null)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 4),
            child: Row(children: [
              const Icon(Icons.location_on, size: 14, color: NVColors.accent),
              const SizedBox(width: 4),
              Expanded(
                child: Text('Lugar: ${_lugarNombre ?? 'marcado'}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 11, color: NVColors.textoSecundario)),
              ),
              InkWell(
                onTap: () => setState(() {
                  _lugarMarcado = null;
                  _lugarNombre = null;
                }),
                child: const Icon(Icons.close, size: 14),
              ),
            ]),
          ),
      ],
    );
  }

  List<MunicipioGeo> get _municipiosOrdenados {
    final l = [..._municipios!];
    l.sort((a, b) =>
        _conteoMunicipio(b.nombre).compareTo(_conteoMunicipio(a.nombre)));
    return l;
  }

  List<CapaGeoElemento> get _areasOrdenadas {
    final l = [..._areas!.elementos.where((e) => e.poligonos.isNotEmpty)];
    l.sort((a, b) => (a.nombre ?? '').compareTo(b.nombre ?? ''));
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

}

class _Rotulo extends StatelessWidget {
  final String texto;
  const _Rotulo(this.texto);
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 6, bottom: 2),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(texto.toUpperCase(),
              style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                  color: NVColors.textoSecundario)),
        ),
      );
}

class _FilaLista extends StatelessWidget {
  final String nombre;
  final int conteo;
  final bool activo;
  final bool menor;
  final VoidCallback onTap;
  const _FilaLista({
    required this.nombre,
    required this.conteo,
    required this.activo,
    required this.onTap,
    this.menor = false,
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
            Icon(
                activo
                    ? (menor ? Icons.check_circle : Icons.place)
                    : (menor
                        ? Icons.circle_outlined
                        : Icons.place_outlined),
                size: menor ? 13 : 15,
                color: activo ? NVColors.accent : NVColors.textoSecundario),
            const SizedBox(width: 6),
            Expanded(
                child: Text(nombre,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: menor ? 11.5 : 12,
                        fontWeight:
                            activo ? FontWeight.w700 : FontWeight.normal))),
            if (conteo >= 0)
              Text('$conteo',
                  style: const TextStyle(
                      fontSize: 12, color: NVColors.textoSecundario)),
          ],
        ),
      ),
    );
  }
}

class _FilaArea extends StatelessWidget {
  final CapaGeoElemento elemento;
  final VoidCallback onZoom;
  final VoidCallback onLink;
  const _FilaArea({
    required this.elemento,
    required this.onZoom,
    required this.onLink,
  });

  @override
  Widget build(BuildContext context) {
    final e = elemento;
    final ha = e.prop('hectareas');
    final sub = [
      if ((e.tipo ?? '').isNotEmpty) e.tipo!,
      if (e.prop('administra') == 'CDMB')
        'CDMB'
      else if ((e.prop('administra') ?? '').isNotEmpty)
        e.prop('administra')!,
      if (ha != null && ha != '0') '$ha ha',
    ].join(' · ');
    return InkWell(
      onTap: onZoom,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 2),
              child: Icon(Icons.forest_outlined,
                  size: 13, color: Color(0xFF556B2F)),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(e.nombre ?? '(sin nombre)',
                      maxLines: 2,
                      style: const TextStyle(
                          fontSize: 11.5, fontWeight: FontWeight.w600)),
                  if (sub.isNotEmpty)
                    Text(sub,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 10.5,
                            color: NVColors.textoSecundario)),
                ],
              ),
            ),
            if ((e.prop('url') ?? '').isNotEmpty)
              InkWell(
                onTap: onLink,
                child: const Padding(
                  padding: EdgeInsets.all(2),
                  child: Icon(Icons.open_in_new,
                      size: 13, color: NVColors.textoSecundario),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Panel de ayuda del geovisor — al lado del mapa, se abre con el botón "?".
class _PanelAyuda extends StatelessWidget {
  final VoidCallback onCerrar;
  const _PanelAyuda({required this.onCerrar});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 6,
      color: NVColors.superficie,
      child: Column(
        children: [
          Container(
            color: NVColors.primaryDark,
            padding: const EdgeInsets.fromLTRB(16, 12, 8, 12),
            child: Row(
              children: [
                const Icon(Icons.help_outline, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text('Cómo usar el geovisor',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15)),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white, size: 20),
                  onPressed: onCerrar,
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 40),
              children: const [
                _AyudaSeccion(
                  icono: Icons.travel_explore,
                  titulo: '¿Qué es?',
                  parrafos: [
                    'Muestra los negocios verdes registrados por la CDMB sobre '
                        'el mapa, con capas oficiales de contexto (municipios, '
                        'áreas protegidas, ríos). No hay que registrarse.',
                  ],
                ),
                _AyudaSeccion(
                  icono: Icons.open_with,
                  titulo: 'Moverse por el mapa',
                  parrafos: [
                    'Arrastra para desplazarte; usa la rueda del mouse o los '
                        'botones + / − para acercar y alejar.',
                    'El botón de diana ("Mi ubicación") centra el mapa donde '
                        'estás (el navegador te pedirá permiso).',
                    'El botón de cámara descarga una imagen PNG del mapa.',
                  ],
                ),
                _AyudaSeccion(
                  icono: Icons.tune,
                  titulo: 'Pestaña "Filtrar"',
                  parrafos: [
                    'Escribe el nombre de un negocio para saltar a él. Si '
                        'escribes un lugar o municipio ("Girón", "El Playón", '
                        '"Vetas") aparece la opción de buscarlo como lugar en '
                        'el mapa.',
                    'Filtra por municipio (y vereda), por categoría y por año '
                        'de registro. Arriba, un mini-gráfico muestra cómo se '
                        'reparten los negocios de la vista.',
                    '"Ver todo" quita todos los filtros. "Copiar enlace de esta '
                        'vista" te da un enlace que abre el geovisor con los '
                        'mismos filtros.',
                  ],
                ),
                _AyudaSeccion(
                  icono: Icons.layers,
                  titulo: 'Pestaña "Capas"',
                  parrafos: [
                    'Enciende o apaga: los negocios, el mapa de calor '
                        '(densidad), los límites municipales y las capas de '
                        'contexto — áreas protegidas (RUNAP) e hidrografía '
                        '(IDEAM). Las capas de contexto se descargan solo al '
                        'encenderlas.',
                    'La leyenda al final explica qué significa cada color.',
                  ],
                ),
                _AyudaSeccion(
                  icono: Icons.straighten,
                  titulo: 'Pestaña "Medir"',
                  parrafos: [
                    'Marca "Medir / seleccionar una zona" y toca el mapa para '
                        'poner puntos. Elige entre medir una DISTANCIA (línea, '
                        'para una vía o un lindero) o una ZONA (polígono).',
                    'Con 2 puntos ves la distancia. Con 3 o más se cierra la '
                        'zona y ves el perímetro, el área (m² / ha / km²) y '
                        'cuántos negocios verdes caen dentro.',
                    'Cada punto muestra su coordenada (lat, lng) — tócala para '
                        'copiarla.',
                    'Otra herramienta: "Negocios cerca de un punto" — toca el '
                        'mapa (o usa tu ubicación), elige un radio (500 m a '
                        '5 km) y ves la lista de negocios dentro de ese círculo, '
                        'descargable.',
                    '"Quitar punto" borra el último; "Limpiar" empieza de nuevo.',
                  ],
                ),
                _AyudaSeccion(
                  icono: Icons.download,
                  titulo: 'Descargar',
                  parrafos: [
                    'De una zona dibujada o de la vista actual puedes descargar:',
                    '• GeoJSON — se abre en QGIS, ArcGIS o Google Earth.',
                    '• CSV — para Excel.',
                    '• Reporte (HTML) — página con mini-mapa y tabla, lista para '
                        'imprimir o guardar como PDF.',
                    'Todas las descargas respetan los filtros activos y no '
                        'requieren registro.',
                  ],
                ),
                _AyudaSeccion(
                  icono: Icons.verified_outlined,
                  titulo: 'Fuentes',
                  parrafos: [
                    'Cartografía base: © OpenStreetMap. Áreas protegidas: RUNAP '
                        '(Parques Nacionales). Hidrografía: IDEAM. Datos de '
                        'negocios: CDMB.',
                    'El geovisor es informativo y no constituye cartografía '
                        'oficial de linderos.',
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AyudaSeccion extends StatelessWidget {
  final IconData icono;
  final String titulo;
  final List<String> parrafos;
  const _AyudaSeccion({
    required this.icono,
    required this.titulo,
    required this.parrafos,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(icono, size: 17, color: NVColors.primaryDark),
            const SizedBox(width: 8),
            Text(titulo,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 13.5)),
          ]),
          const SizedBox(height: 4),
          for (final p in parrafos)
            Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: Text(p,
                  style: const TextStyle(fontSize: 12.5, height: 1.35)),
            ),
        ],
      ),
    );
  }
}

/// Punto simple de negocio (a zoom bajo, en vez del pin con foto).
class _PuntoNegocio extends StatelessWidget {
  const _PuntoNegocio();
  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          color: NVColors.verdeVivo,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 2),
        ),
      );
}

/// Punto "tú estás aquí".
class _PuntoUbicacion extends StatelessWidget {
  const _PuntoUbicacion();
  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1A73E8),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 3),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withValues(alpha: 0.3), blurRadius: 4),
          ],
        ),
      );
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

class _ChipFiltroActivo extends StatelessWidget {
  final String texto;
  final int conteo;
  final VoidCallback onQuitar;
  const _ChipFiltroActivo({
    required this.texto,
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
            Text('$texto · $conteo negocio${conteo == 1 ? '' : 's'}',
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
                negocio.vereda?.nombre,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (negocio.tieneUbicacion)
                  TextButton.icon(
                    onPressed: () => launchUrl(Uri.parse(
                        'https://www.google.com/maps/@?api=1&map_action=pano'
                        '&viewpoint=${negocio.latitud},${negocio.longitud}')),
                    icon: const Icon(Icons.streetview, size: 16),
                    label: const Text('Street View'),
                  ),
                const SizedBox(width: 4),
                FilledButton.icon(
                  onPressed: () => context.go('/negocio/${negocio.slug}'),
                  icon: const Icon(Icons.open_in_new, size: 16),
                  label: const Text('Ver'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
