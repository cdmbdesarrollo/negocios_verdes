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
  String? _negocioSeleccionadoId;
  bool _cargando = true;
  String? _error;
  Timer? _debounceBusqueda;
  bool _inicializado = false;

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
    // la carga inicial se dispara aquí, protegida para correr una sola vez
    // aunque didChangeDependencies se vuelva a llamar después.
    if (_inicializado) return;
    _inicializado = true;
    final params = GoRouterState.of(context).uri.queryParameters;
    _filtro = FiltroBusqueda.fromQueryParameters(params);
    _cargarCatalogosYBuscar();
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
      ]);
      if (!mounted) return;
      setState(() {
        _categorias = resultados[0] as List<CategoriaOficial>;
        _subcategorias = resultados[1] as List<Subcategoria>;
        _actividades = resultados[2] as List<ActividadProductiva>;
        _negocios = resultados[3] as List<Negocio>;
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
        // Con 8 categorías + 13 municipios como chips, FiltrosBar puede
        // crecer varias filas — sin este límite empujaba el área de
        // resultados (el Expanded de abajo) a casi cero de alto en
        // pantallas normales, y el "scroll" que quedaba visible era una
        // franja tan chica que parecía que no se podía bajar. Se le pone un
        // techo (fracción del alto REAL de pantalla, no de las
        // constraints del Column — esas pueden llegar sin límite desde
        // arriba según cómo esté armado el shell) y scroll propio adentro,
        // así nunca se come el espacio de los resultados.
        ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.sizeOf(context).height * 0.36,
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: FiltrosBar(
              categorias: _categorias,
              subcategorias: _subcategorias,
              actividades: _actividades,
              filtro: _filtro,
              onCambio: _alCambiarFiltro,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
          child: Row(
            children: [
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
