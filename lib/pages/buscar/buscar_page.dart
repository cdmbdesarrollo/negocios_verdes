import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';

import '../../core/responsive.dart';
import '../../core/seo_tags.dart';
import '../../core/widgets/hover_lift.dart';
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
import 'widgets/negocio_card.dart';
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
  final _claveMapa = GlobalKey();

  /// Los resultados se muestran en grilla horizontal; si son muchos se
  /// paginan (pedido explícito: "cuando da muchos negocios se pierden").
  static const _porPagina = 24;
  int _pagina = 0;

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
        nuevo.actividadSlug != _filtro.actividadSlug ||
        // BUG que devolvía "siempre lo mismo" al tocar los chips de
        // reconocimiento: no estaban en esta comparación, así que
        // cambioDatos daba false y la búsqueda no se volvía a correr.
        nuevo.emprendimientoVerde != _filtro.emprendimientoVerde ||
        nuevo.selloMarca != _filtro.selloMarca ||
        nuevo.avalado != _filtro.avalado;
    final soloCambioTexto = cambioDatos &&
        nuevo.query != _filtro.query &&
        nuevo.municipio == _filtro.municipio &&
        nuevo.categoriaSlug == _filtro.categoriaSlug &&
        nuevo.subcategoriaSlug == _filtro.subcategoriaSlug &&
        nuevo.actividadSlug == _filtro.actividadSlug &&
        nuevo.emprendimientoVerde == _filtro.emprendimientoVerde &&
        nuevo.selloMarca == _filtro.selloMarca &&
        nuevo.avalado == _filtro.avalado;

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
          _pagina = 0;
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
    setState(() => _negocioSeleccionadoId = negocio.id);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ctx = _claveMapa.currentContext;
      if (ctx != null) {
        Scrollable.ensureVisible(ctx,
            duration: const Duration(milliseconds: 350), alignment: 0.05);
      }
      _mapController.move(LatLng(negocio.latitud!, negocio.longitud!), 15);
    });
  }

  void _alTocarMarcador(Negocio negocio) {
    final lista = _negocios ?? [];
    final idx = lista.indexWhere((n) => n.id == negocio.id);
    setState(() {
      _negocioSeleccionadoId = negocio.id;
      if (idx >= 0) _pagina = idx ~/ _porPagina;
    });
    if (esPantallaAncha(context)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final ctx = _clavesPorNegocio[negocio.id]?.currentContext;
        if (ctx != null) {
          Scrollable.ensureVisible(ctx,
              duration: const Duration(milliseconds: 300), alignment: 0.1);
        }
      });
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

    // Layout pedido explícitamente: los resultados en grilla horizontal
    // (varias filas), paginados si son muchos, y DEBAJO de todos el mapa a
    // lo ancho con todos los puntos.
    final totalPaginas =
        negocios.isEmpty ? 1 : ((negocios.length - 1) ~/ _porPagina) + 1;
    final pagina = _pagina.clamp(0, totalPaginas - 1);
    final desde = pagina * _porPagina;
    final hasta = (desde + _porPagina).clamp(0, negocios.length);
    final pagVisibles =
        negocios.isEmpty ? <Negocio>[] : negocios.sublist(desde, hasta);

    return SingleChildScrollView(
      child: Column(
        children: [
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
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '${negocios.length} ${negocios.length == 1 ? 'negocio encontrado' : 'negocios encontrados'}'
                '${totalPaginas > 1 ? ' · página ${pagina + 1} de $totalPaginas' : ''}',
                style: const TextStyle(
                    color: NVColors.textoSecundario, fontSize: 12),
              ),
            ),
          ),
          const SizedBox(height: 10),
          if (_cargando)
            const Padding(
              padding: EdgeInsets.all(40),
              child: CircularProgressIndicator(),
            )
          else if (negocios.isEmpty)
            _vacio()
          else
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: LayoutBuilder(
                builder: (context, c) {
                  const objetivo = 380.0;
                  final cols = (c.maxWidth / objetivo).floor().clamp(1, 4);
                  final ancho = (c.maxWidth - (cols - 1) * 12) / cols;
                  return Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      for (final n in pagVisibles)
                        SizedBox(
                          width: ancho,
                          child: KeyedSubtree(
                            key: _clavesPorNegocio.putIfAbsent(
                                n.id, () => GlobalKey()),
                            child: HoverLift(
                              child: NegocioCard(
                                negocio: n,
                                seleccionado: n.id == _negocioSeleccionadoId,
                                onVerEnMapa: n.tieneUbicacion
                                    ? () => _verEnMapa(n)
                                    : null,
                              ),
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
          if (totalPaginas > 1) _pager(negocios.length, pagina, totalPaginas),
          if (conUbicacion > 0) ...[
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Ubicación de los $conUbicacion negocios con dirección',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: NVColors.primaryDark),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Container(
                key: _claveMapa,
                height: 480,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: NVColors.borde),
                ),
                child: ResultadosMapa(
                  negocios: negocios,
                  mapController: _mapController,
                  negocioSeleccionadoId: _negocioSeleccionadoId,
                  onMarcadorTocado: _alTocarMarcador,
                ),
              ),
            ),
          ],
          const SizedBox(height: 24),
          const PiePagina(),
        ],
      ),
    );
  }

  Widget _pager(int total, int pagina, int totalPaginas) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: pagina > 0
                ? () => setState(() => _pagina = pagina - 1)
                : null,
          ),
          Text('${pagina + 1} / $totalPaginas',
              style: const TextStyle(fontWeight: FontWeight.w600)),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: pagina < totalPaginas - 1
                ? () => setState(() => _pagina = pagina + 1)
                : null,
          ),
        ],
      ),
    );
  }

  Widget _vacio() {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          Image.asset('assets/images/iconografia/oso_anteojos_2.png',
              width: 56, height: 56),
          const SizedBox(height: 14),
          const Text('No encontramos negocios con estos filtros',
              style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          const Text('Prueba con otra búsqueda o quita algún filtro.',
              style: TextStyle(color: NVColors.textoSecundario, fontSize: 13)),
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
        if (negocio.descripcionCorta != null &&
            negocio.descripcionCorta!.isNotEmpty)
          Text(negocio.descripcionCorta!),
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
