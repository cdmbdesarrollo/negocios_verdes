import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';

import '../../core/responsive.dart';
import '../../core/seo_tags.dart';
import '../../core/widgets/pie_pagina.dart';
import '../../models/actividad_productiva.dart';
import '../../models/categoria_oficial.dart';
import '../../models/filtro_busqueda.dart';
import '../../models/negocio.dart';
import '../../models/subcategoria.dart';
import '../../services/actividad_productiva_service.dart';
import '../../services/categoria_service.dart';
import '../../services/negocio_service.dart';
import '../../services/subcategoria_service.dart';
import '../../theme/nv_colors.dart';
import 'widgets/filtros_bar.dart';
import 'widgets/resultados_lista.dart';
import 'widgets/resultados_mapa.dart';

/// El "megabuscador": una sola página con texto + municipio + categoría +
/// subcategoría + actividad productiva, mostrando lista y mapa sincronizados
/// en las dos direcciones. En pantalla ancha van lado a lado (sin pestañas,
/// a diferencia de cualquiera de las páginas de referencia); en pantalla
/// angosta hay un toggle Lista/Mapa.
class BuscarPage extends StatefulWidget {
  const BuscarPage({super.key});

  @override
  State<BuscarPage> createState() => _BuscarPageState();
}

class _BuscarPageState extends State<BuscarPage> {
  final _negocioService = NegocioService();
  final _categoriaService = CategoriaService();
  final _subcategoriaService = SubcategoriaService();
  final _actividadService = ActividadProductivaService();
  final _mapController = MapController();
  final Map<String, GlobalKey> _clavesPorNegocio = {};

  FiltroBusqueda _filtro = const FiltroBusqueda();
  List<Negocio>? _negocios;
  List<CategoriaOficial> _categorias = [];
  List<Subcategoria> _subcategorias = [];
  List<ActividadProductiva> _actividades = [];
  /// Nombre+slug de TODOS los negocios activos, para el autocompletado —
  /// a diferencia de [_negocios] (los resultados de la búsqueda actual,
  /// que cambian con cada filtro), esta lista se carga una sola vez y no
  /// se vuelve a tocar.
  List<(String nombre, String slug)> _nombresNegocios = [];
  String? _negocioSeleccionadoId;
  bool _cargando = true;
  String? _error;
  Timer? _debounceBusqueda;
  bool _inicializado = false;
  /// Última URL que ESTA página escribió con [_actualizarUrl] — para
  /// distinguir, en [didChangeDependencies], un cambio de query params que
  /// viene de afuera (ej. se tocó un tag de NegocioCard con
  /// context.go('/buscar?...') estando ya en /buscar) de un simple eco de
  /// lo que el propio estado ya reflejaba.
  String? _ultimaUrlPropia;

  @override
  void initState() {
    super.initState();
    establecerSeo(
      titulo: 'Buscar negocios verdes — Negocios Verdes CDMB',
      descripcion:
          'Encuentra negocios verdes por categoría, subcategoría o municipio '
          'en la jurisdicción de la CDMB.',
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // GoRouterState.of(context) no se puede llamar de forma segura desde
    // initState (dispara una aserción real de Flutter: depende de
    // inherited widgets que todavía no terminan de montarse ahí) — por eso
    // la carga inicial se dispara aquí.
    final ubicacion = GoRouterState.of(context).uri;
    if (!_inicializado) {
      _inicializado = true;
      _filtro = FiltroBusqueda.fromQueryParameters(ubicacion.queryParameters);
      _cargarCatalogosYBuscar();
      return;
    }
    // BuscarPage no tiene key, así que navegar de /buscar a /buscar con
    // otros query params (ej. tocar el tag "Girón" de una tarjeta estando
    // YA en /buscar) reutiliza este mismo State en vez de recrearlo — sin
    // este chequeo, didChangeDependencies se llama de nuevo pero no hacía
    // nada más, así que el filtro quedaba "congelado" en lo que tenía
    // antes: la URL cambiaba pero ni los resultados ni los chips de
    // FiltrosBar se actualizaban. Comparar contra [_ultimaUrlPropia] evita
    // reaccionar al eco normal de cuando ESTA página es la que acaba de
    // escribir esa misma URL vía [_actualizarUrl] (si no, cada toque de
    // chip dispararía una búsqueda duplicada).
    if (ubicacion.toString() == _ultimaUrlPropia) return;
    final nuevoFiltro = FiltroBusqueda.fromQueryParameters(
      ubicacion.queryParameters,
    );
    setState(() => _filtro = nuevoFiltro);
    _buscarConFiltroActual();
  }

  @override
  void dispose() {
    _debounceBusqueda?.cancel();
    super.dispose();
  }

  Future<void> _cargarCatalogosYBuscar() async {
    try {
      final resultados = await Future.wait([
        _categoriaService.listarTodas(),
        _subcategoriaService.listarTodas(),
        _actividadService.listarTodas(),
        _negocioService.buscar(_filtro),
        _negocioService.listarNombresPublicos(),
      ]);
      if (!mounted) return;
      setState(() {
        _categorias = resultados[0] as List<CategoriaOficial>;
        _subcategorias = resultados[1] as List<Subcategoria>;
        _actividades = resultados[2] as List<ActividadProductiva>;
        _negocios = resultados[3] as List<Negocio>;
        _nombresNegocios =
            resultados[4] as List<(String nombre, String slug)>;
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

  void _alCambiarFiltro(FiltroBusqueda nuevo) {
    final cambioDatos = nuevo.query != _filtro.query ||
        nuevo.municipio != _filtro.municipio ||
        nuevo.categoriaSlug != _filtro.categoriaSlug ||
        nuevo.subcategoriaSlug != _filtro.subcategoriaSlug ||
        nuevo.actividadSlug != _filtro.actividadSlug;
    final soloCambioTexto = cambioDatos &&
        nuevo.query != _filtro.query &&
        nuevo.municipio == _filtro.municipio &&
        nuevo.categoriaSlug == _filtro.categoriaSlug &&
        nuevo.subcategoriaSlug == _filtro.subcategoriaSlug &&
        nuevo.actividadSlug == _filtro.actividadSlug;

    setState(() => _filtro = nuevo);
    _actualizarUrl();

    if (!cambioDatos) return; // solo cambió la vista lista/mapa

    _debounceBusqueda?.cancel();
    if (soloCambioTexto) {
      _debounceBusqueda =
          Timer(const Duration(milliseconds: 350), _buscarConFiltroActual);
    } else {
      _buscarConFiltroActual();
    }
  }

  Future<void> _buscarConFiltroActual() async {
    setState(() => _cargando = true);
    try {
      final resultados = await _negocioService.buscar(_filtro);
      if (mounted) {
        setState(() {
          _negocios = resultados;
          _cargando = false;
          _error = null;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString().replaceFirst('Exception: ', '');
          _cargando = false;
        });
      }
    }
  }

  void _actualizarUrl() {
    final params = _filtro.toQueryParameters();
    final uri =
        Uri(path: '/buscar', queryParameters: params.isEmpty ? null : params);
    _ultimaUrlPropia = uri.toString();
    context.replace(uri.toString());
  }

  void _verEnMapa(Negocio negocio) {
    if (!negocio.tieneUbicacion) return;
    final ancha = esPantallaAncha(context);
    setState(() => _negocioSeleccionadoId = negocio.id);
    if (!ancha && _filtro.vista != VistaResultados.mapa) {
      _alCambiarFiltro(_filtro.copyWith(vista: VistaResultados.mapa));
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _mapController.move(LatLng(negocio.latitud!, negocio.longitud!), 15);
    });
  }

  void _alTocarMarcador(Negocio negocio) {
    setState(() => _negocioSeleccionadoId = negocio.id);
    if (esPantallaAncha(context)) {
      final clave = _clavesPorNegocio[negocio.id];
      final ctx = clave?.currentContext;
      if (ctx != null) {
        Scrollable.ensureVisible(
          ctx,
          duration: const Duration(milliseconds: 300),
          alignment: 0.1,
        );
      }
    } else {
      showModalBottomSheet(
        context: context,
        builder: (_) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: _TarjetaNegocioResumen(negocio: negocio),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return Center(child: Text(_error!));
    }
    if (_cargando && _negocios == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final negocios = _negocios ?? [];
    final conUbicacion = negocios.where((n) => n.tieneUbicacion).length;
    final ancha = esPantallaAncha(context);

    // Antes esta página no tenía scroll propio (filtros + contador fijos
    // arriba, lista/mapa en un Expanded ocupando justo lo que quedaba de
    // viewport) — era la ÚNICA página del sitio sin pie de página, y sin
    // ese cierre el mapa se sentía "cortado" en vez de completo. Ahora es
    // una página normal como el resto (scroll + PiePagina al final);
    // lista/mapa pasan de Expanded a una altura fija generosa en vez de
    // "lo que sobre", así se ven completos sin importar cuánto midan los
    // filtros arriba.
    return SingleChildScrollView(
      child: Column(
        children: [
        // Antes tenía un ConstrainedBox(maxHeight: 36% de pantalla) +
        // scroll propio — de cuando los resultados de abajo eran un
        // Expanded y competían por alto con FiltrosBar. Ya no: los
        // resultados miden 600 fijo (ver más abajo) sin importar cuánto
        // crezca este bloque, así que ese límite quedó sin ningún
        // propósito real y solo cortaba la fila de Subcategoría/Actividad
        // cuando la categoría elegida tenía muchas — la página entera ya
        // tiene su propio scroll (el SingleChildScrollView de más arriba),
        // no hace falta anidar un segundo scroll adentro.
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
          child: FiltrosBar(
            categorias: _categorias,
            subcategorias: _subcategorias,
            actividades: _actividades,
            negocios: _nombresNegocios,
            filtro: _filtro,
            onCambio: _alCambiarFiltro,
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
          child: Row(
            children: [
              // Colibrí pequeño (iconografía de marca), pedido explícito
              // "dentro del buscador en tamaño pequeño".
              Padding(
                padding: const EdgeInsets.only(right: 6),
                child: Image.asset(
                  'assets/images/iconografia/colibri_1.png',
                  width: 20,
                  height: 20,
                ),
              ),
              Expanded(
                child: Text(
                  '${negocios.length} ${negocios.length == 1 ? 'negocio encontrado' : 'negocios encontrados'}'
                  '${conUbicacion != negocios.length && negocios.isNotEmpty ? ' · Mostrando $conUbicacion de ${negocios.length} en el mapa' : ''}',
                  style: const TextStyle(
                      color: NVColors.textoSecundario, fontSize: 12),
                ),
              ),
              if (!ancha)
                SegmentedButton<VistaResultados>(
                  segments: const [
                    ButtonSegment(
                        value: VistaResultados.lista,
                        icon: Icon(Icons.list),
                        label: Text('Lista')),
                    ButtonSegment(
                        value: VistaResultados.mapa,
                        icon: Icon(Icons.map_outlined),
                        label: Text('Mapa')),
                  ],
                  selected: {_filtro.vista},
                  onSelectionChanged: (nuevo) =>
                      _alCambiarFiltro(_filtro.copyWith(vista: nuevo.first)),
                ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 600,
          child: ancha
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      flex: 4,
                      child: ResultadosLista(
                        negocios: negocios,
                        clavesPorNegocio: _clavesPorNegocio,
                        negocioSeleccionadoId: _negocioSeleccionadoId,
                        onVerEnMapa: _verEnMapa,
                      ),
                    ),
                    Expanded(
                      flex: 6,
                      child: ResultadosMapa(
                        negocios: negocios,
                        mapController: _mapController,
                        negocioSeleccionadoId: _negocioSeleccionadoId,
                        onMarcadorTocado: _alTocarMarcador,
                      ),
                    ),
                  ],
                )
              : (_filtro.vista == VistaResultados.lista
                  ? ResultadosLista(
                      negocios: negocios,
                      clavesPorNegocio: _clavesPorNegocio,
                      negocioSeleccionadoId: _negocioSeleccionadoId,
                      onVerEnMapa: _verEnMapa,
                    )
                  : ResultadosMapa(
                      negocios: negocios,
                      mapController: _mapController,
                      negocioSeleccionadoId: _negocioSeleccionadoId,
                      onMarcadorTocado: _alTocarMarcador,
                    )),
        ),
          const PiePagina(),
        ],
      ),
    );
  }
}

class _TarjetaNegocioResumen extends StatelessWidget {
  final Negocio negocio;

  const _TarjetaNegocioResumen({required this.negocio});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(negocio.nombre,
            style:
                const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 4),
        Text(negocio.descripcionCorta),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.go('/negocio/${negocio.slug}');
            },
            child: const Text('Ver ficha completa'),
          ),
        ),
      ],
    );
  }
}
