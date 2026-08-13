import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../catalogos.dart';
import '../../core/seo_tags.dart';
import '../../core/widgets/chip_filtro.dart';
import '../../core/widgets/entrada_animada.dart';
import '../../core/widgets/hover_lift.dart';
import '../../core/widgets/icono_etiqueta.dart';
import '../../core/widgets/logo_negocios_verdes.dart';
import '../../core/widgets/onda_divisora.dart';
import '../../core/widgets/pie_pagina.dart';
import '../../core/widgets/section_header.dart';
import '../../models/actividad_productiva.dart';
import '../../models/banner_sitio.dart';
import '../../models/categoria_oficial.dart';
import '../../models/filtro_busqueda.dart';
import '../../models/negocio.dart';
import '../../models/subcategoria.dart';
import '../../services/actividad_productiva_service.dart';
import '../../services/banner_service.dart';
import '../../services/categoria_service.dart';
import '../../services/negocio_service.dart';
import '../../services/subcategoria_service.dart';
import '../../theme/nv_colors.dart';
import '../buscar/widgets/negocio_card.dart';
import 'widgets/hero_slider.dart';

class InicioPage extends StatefulWidget {
  const InicioPage({super.key});

  @override
  State<InicioPage> createState() => _InicioPageState();
}

class _InicioPageState extends State<InicioPage> {
  final _negocioService = NegocioService();
  final _categoriaService = CategoriaService();
  final _subcategoriaService = SubcategoriaService();
  final _actividadService = ActividadProductivaService();
  final _bannerService = BannerService();
  final _busquedaCtrl = TextEditingController();

  List<CategoriaOficial> _categorias = [];
  List<Subcategoria> _subcategorias = [];
  List<ActividadProductiva> _actividades = [];
  List<Negocio> _destacados = [];
  List<BannerSitio> _banners = [];
  int _totalNegocios = 0;
  bool _cargando = true;

  // Selección acumulada de los 4 filtros del home (municipio, categoría,
  // subcategoría, actividad) — a diferencia de antes, tocar un chip aquí ya
  // NO navega de inmediato a /buscar: solo marca/desmarca, para poder armar
  // una búsqueda con varios criterios combinados antes de ir al buscador.
  // Se guardan slugs (no ids) porque son lo que espera FiltroBusqueda.
  String? _municipioSel;
  String? _categoriaSel;
  String? _subcategoriaSel;
  String? _actividadSel;

  @override
  void initState() {
    super.initState();
    establecerSeo(
      titulo: 'Negocios Verdes CDMB — Directorio de negocios verdes',
      descripcion:
          'Encuentra negocios verdes verificados por la CDMB en los 13 '
          'municipios de nuestra jurisdicción: agricultura orgánica, turismo '
          'sostenible, biocomercio y mucho más.',
    );
    _cargar();
  }

  @override
  void dispose() {
    _busquedaCtrl.dispose();
    super.dispose();
  }

  Future<void> _cargar() async {
    try {
      final resultados = await Future.wait([
        _categoriaService.listarTodas(),
        _subcategoriaService.listarTodas(),
        _actividadService.listarTodas(),
        _negocioService.buscar(const FiltroBusqueda()),
        _bannerService.listarActivos(),
      ]);
      if (!mounted) return;
      final categorias = resultados[0] as List<CategoriaOficial>;
      final subcategorias = resultados[1] as List<Subcategoria>;
      final actividades = resultados[2] as List<ActividadProductiva>;
      final todos = resultados[3] as List<Negocio>;
      final banners = resultados[4] as List<BannerSitio>;
      setState(() {
        _categorias = categorias.where((c) => c.activo).toList();
        _subcategorias = subcategorias.where((s) => s.activo).toList();
        _actividades = actividades.where((a) => a.activo).toList();
        _destacados = todos.where((n) => n.destacado).take(6).toList();
        _banners = banners;
        _totalNegocios = todos.length;
        _cargando = false;
      });
    } catch (_) {
      if (mounted) setState(() => _cargando = false);
    }
  }

  void _buscar([String? texto]) {
    final query = texto ?? _busquedaCtrl.text;
    _irA(query.trim().isEmpty ? {} : {'q': query.trim()});
  }

  void _irA(Map<String, String> parametros) {
    final uri = Uri(
      path: '/buscar',
      queryParameters: parametros.isEmpty ? null : parametros,
    );
    context.go(uri.toString());
  }

  CategoriaOficial? _categoriaPorSlug(String? slug) {
    if (slug == null) return null;
    for (final c in _categorias) {
      if (c.slug == slug) return c;
    }
    return null;
  }

  Subcategoria? _subcategoriaPorSlug(String? slug) {
    if (slug == null) return null;
    for (final s in _subcategorias) {
      if (s.slug == slug) return s;
    }
    return null;
  }

  ActividadProductiva? _actividadPorSlug(String? slug) {
    if (slug == null) return null;
    for (final a in _actividades) {
      if (a.slug == slug) return a;
    }
    return null;
  }

  /// Subcategorías de la categoría elegida — mismo criterio que
  /// FiltrosBar en /buscar, para que el home cascada exactamente igual.
  List<Subcategoria> get _subcategoriasFiltradas {
    final categoria = _categoriaPorSlug(_categoriaSel);
    if (categoria == null) return const [];
    return _subcategorias
        .where((s) => s.categoriaOficialId == categoria.id)
        .toList();
  }

  List<ActividadProductiva> get _actividadesFiltradas {
    final subcategoria = _subcategoriaPorSlug(_subcategoriaSel);
    if (subcategoria == null) return const [];
    return _actividades
        .where((a) => a.subcategoriaId == subcategoria.id)
        .toList();
  }

  /// Tocar un chip ya elegido lo desmarca (toggle); tocar uno distinto
  /// cambia la selección y poda los niveles hijos, que ya no aplican a la
  /// nueva elección — mismo criterio de cascada que el selector del admin.
  void _alTocarMunicipio(String municipio) {
    setState(() {
      _municipioSel = _municipioSel == municipio ? null : municipio;
    });
  }

  void _alTocarCategoria(String slug) {
    setState(() {
      _categoriaSel = _categoriaSel == slug ? null : slug;
      _subcategoriaSel = null;
      _actividadSel = null;
    });
  }

  void _alTocarSubcategoria(String slug) {
    setState(() {
      _subcategoriaSel = _subcategoriaSel == slug ? null : slug;
      _actividadSel = null;
    });
  }

  void _alTocarActividad(String slug) {
    setState(() {
      _actividadSel = _actividadSel == slug ? null : slug;
    });
  }

  /// El botón "Buscar" del home: junta lo que el visitante haya marcado en
  /// las 4 secciones (puede ser nada, uno, o los 4) y recién ahí navega a
  /// /buscar — a diferencia de antes, donde cada chip navegaba solo con su
  /// propio filtro y perdía cualquier otra selección hecha en el home.
  void _buscarConFiltrosAcumulados() {
    _irA({
      if (_municipioSel != null) 'municipio': _municipioSel!,
      if (_categoriaSel != null) 'categoria': _categoriaSel!,
      if (_subcategoriaSel != null) 'subcategoria': _subcategoriaSel!,
      if (_actividadSel != null) 'actividad': _actividadSel!,
    });
  }

  /// Banners reales subidos desde /admin/apariencia, primero, seguidos de
  /// las diapositivas de fábrica que hagan falta para completar el mismo
  /// total que las de fábrica — así el carrusel SIEMPRE tiene con qué
  /// rotar (flechas, puntos, auto-avance) desde el primer banner real que
  /// se sube, en vez de quedar fijo en una sola imagen estática hasta que
  /// haya 2 o más banners reales cargados. Antes, con exactamente 1 banner
  /// real, el carrusel mostraba solo ese banner sin controles — un
  /// comportamiento correcto por diseño (nada más con qué rotar) pero que
  /// se leía como "el slider está roto".
  List<SlideInfo> get _slides {
    final reales = [
      for (final banner in _banners)
        SlideInfo.imagen(
          imagenUrl: banner.imagenUrl,
          onTap: _resolverDestino(banner.urlDestino, banner.abrirEnPestanaNueva),
        ),
    ];
    if (reales.length >= _slidesDeFabrica.length) return reales;
    return [...reales, ..._slidesDeFabrica];
  }

  VoidCallback? _resolverDestino(String? urlDestino, bool nuevaPestana) {
    if (urlDestino == null || urlDestino.trim().isEmpty) return null;
    if (urlDestino.startsWith('/')) {
      return () => context.go(urlDestino);
    }
    return () async {
      final uri = Uri.tryParse(urlDestino);
      if (uri == null) return;
      await launchUrl(
        uri,
        webOnlyWindowName: nuevaPestana ? '_blank' : '_self',
      );
    };
  }

  List<SlideInfo> get _slidesDeFabrica => [
        SlideInfo.texto(
          titulo: 'Negocios Verdes CDMB',
          subtitulo: _cargando
              ? 'El directorio de negocios verdes de los 13 municipios de '
                  'la jurisdicción CDMB'
              : '$_totalNegocios negocios verdes en los 13 municipios de '
                  'la jurisdicción CDMB',
          icono: Icons.eco,
          fondo: NVColors.gradientHero,
        ),
        SlideInfo.texto(
          titulo: '¿Qué son los Negocios Verdes?',
          subtitulo: 'Conoce los requisitos y beneficios de hacer parte '
              'del programa de la CDMB.',
          icono: Icons.info_outline,
          fondo:
              const LinearGradient(colors: [NVColors.accentDark, NVColors.accent]),
          textoBoton: 'Conocer más',
          onTap: () => context.go('/nosotros'),
        ),
        SlideInfo.texto(
          titulo: 'Encuentra por categoría',
          subtitulo: 'Agrosistemas, turismo sostenible, biocomercio, '
              'tecnologías verdes y más.',
          icono: Icons.category_outlined,
          fondo: NVColors.gradientOscuro,
          textoBoton: 'Ver categorías',
          onTap: () => _irA(const {}),
        ),
        SlideInfo.texto(
          titulo: '13 municipios, un solo directorio',
          subtitulo: 'Bucaramanga, Floridablanca, Girón, Piedecuesta y 9 '
              'municipios más de la jurisdicción CDMB.',
          icono: Icons.map_outlined,
          fondo: NVColors.gradientDuo,
          textoBoton: 'Buscar por municipio',
          onTap: () => context.go('/buscar'),
        ),
      ];

  @override
  Widget build(BuildContext context) {
    // Retraso creciente por sección: entran en cascada en vez de golpe
    // único, sensación mucho más "producto premium" que "página estática".
    var indiceEntrada = 0;
    Widget entrada(Widget child) {
      final retraso = Duration(milliseconds: 70 * indiceEntrada);
      indiceEntrada++;
      return EntradaAnimada(retraso: retraso, child: child);
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          HeroSlider(slides: _slides),
          entrada(_buscadorPersistente(context)),
          if (_destacados.isNotEmpty) entrada(_seccionDestacados(context)),
          entrada(_seccionMunicipios(context)),
          if (_categorias.isNotEmpty) entrada(_seccionCategorias(context)),
          if (_categoriaSel != null && _subcategoriasFiltradas.isNotEmpty)
            entrada(_seccionSubcategorias(context)),
          if (_subcategoriaSel != null && _actividadesFiltradas.isNotEmpty)
            entrada(_seccionActividades(context)),
          entrada(_botonBuscarFiltros(context)),
          // CanvasKit a veces deja una línea de un subpíxel entre dos capas
          // adyacentes del mismo color exacto (la onda y la sección sólida
          // que sigue). Un Container/Padding con margen negativo pareció
          // funcionar visualmente pero dispara
          // "margin.isNonNegative"/"padding.isNonNegative" — ambos widgets
          // lo prohíben en el propio RenderObject (verificado en el SDK),
          // solo no se nota en release porque los asserts se compilan
          // fuera; en debug tumba la página. Transform.scale anclado
          // arriba sí es válido: no toca el layout (Column no recorta el
          // desborde de sus hijos por defecto), solo estira 2-3px la
          // pintura hacia abajo —zona que ya es sólida (colorOnda liso) en
          // la onda— tapando la costura sin mover nada más.
          Transform.scale(
            scaleY: 1.1,
            alignment: Alignment.topCenter,
            child: const OndaDivisora(
                colorFondo: NVColors.fondo, colorOnda: NVColors.primary),
          ),
          entrada(_seccionEstadisticas(context)),
          Transform.scale(
            scaleY: 1.1,
            alignment: Alignment.topCenter,
            child: const OndaDivisora(
                colorFondo: NVColors.primary, colorOnda: NVColors.primaryLight),
          ),
          entrada(_seccionQueSon(context)),
          const PiePagina(),
        ],
      ),
    );
  }

  /// Antes esta franja era verde sólido justo debajo del slider (también
  /// verde) — dos bloques de marca apilados sin ningún respiro, la causa
  /// principal de la sensación de "pared verde" que se reportó. Ahora es
  /// clara (se funde con el fondo de la página), un quiebre visual real en
  /// vez de una franja de color más. Antes esta sección flotaba con
  /// Transform.translate encima del borde del slider para dar sensación de
  /// tarjeta — con banners reales (imagen de borde a borde, a veces con
  /// texto propio cerca del borde inferior) terminaba tapando el banner en
  /// vez de solo el borde, así que ya no se solapa: queda debajo del
  /// slider, en flujo normal.
  Widget _buscadorPersistente(BuildContext context) {
    return Container(
      width: double.infinity,
      color: NVColors.fondo,
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 16),
      child: Column(
        children: [
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 580),
              child: Material(
                elevation: 6,
                shadowColor: NVColors.primary.withValues(alpha: 0.25),
                borderRadius: BorderRadius.circular(32),
                child: TextField(
                  controller: _busquedaCtrl,
                  onSubmitted: _buscar,
                  style: const TextStyle(fontSize: 15),
                  decoration: InputDecoration(
                    hintText: 'Busca por nombre, categoría o municipio...',
                    hintStyle: const TextStyle(
                        color: NVColors.textoSecundario, fontSize: 14),
                    prefixIcon:
                        const Icon(Icons.search, color: NVColors.primary),
                    contentPadding: const EdgeInsets.symmetric(vertical: 18),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(32),
                      borderSide: BorderSide(
                          color: NVColors.primary.withValues(alpha: 0.15)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(32),
                      borderSide: BorderSide(
                          color: NVColors.primary.withValues(alpha: 0.15)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(32),
                      borderSide:
                          const BorderSide(color: NVColors.primary, width: 1.5),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    suffixIconConstraints:
                        const BoxConstraints(minWidth: 0, minHeight: 0),
                    suffixIcon: Padding(
                      padding: const EdgeInsets.all(6),
                      child: Material(
                        color: NVColors.primary,
                        shape: const CircleBorder(),
                        child: InkWell(
                          onTap: () => _buscar(),
                          customBorder: const CircleBorder(),
                          child: Semantics(
                            button: true,
                            label: 'Buscar',
                            child: const Padding(
                              padding: EdgeInsets.all(10),
                              child: Icon(Icons.arrow_forward,
                                  color: Colors.white, size: 20),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const LogoNegociosVerdes(altura: 36),
              const SizedBox(width: 10),
              const Flexible(
                child: Text(
                  'Negocios Verdes CDMB',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: NVColors.textoPrincipal,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Franja de cifras — cuentan hacia arriba desde 0 con TweenAnimationBuilder
  /// en vez de aparecer ya escritas: cuando _cargar() termina y llega el
  /// total real por setState, el "end" del tween cambia y el número sube
  /// solo, sin animación manual que armar a mano. Municipios es fijo, pero
  /// se anima igual para que las 3 cifras se vean como un mismo conjunto,
  /// no dos animadas y una estática.
  Widget _seccionEstadisticas(BuildContext context) {
    return Container(
      width: double.infinity,
      color: NVColors.primary,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 820),
          child: Wrap(
            alignment: WrapAlignment.spaceEvenly,
            runSpacing: 20,
            children: [
              _estadistica(
                  Icons.location_on_outlined, 'Municipios', kMunicipios.length),
              _estadistica(
                  Icons.category_outlined, 'Categorías', _categorias.length),
              _estadistica(
                  Icons.label_outline, 'Subcategorías', _subcategorias.length),
              _estadistica(Icons.workspaces_outlined, 'Actividades productivas',
                  _actividades.length),
              _estadistica(
                  Icons.storefront_outlined, 'Negocios verdes', _totalNegocios),
            ],
          ),
        ),
      ),
    );
  }

  Widget _estadistica(IconData icono, String etiqueta, int valor) {
    return SizedBox(
      width: 140,
      child: Column(
        children: [
          Icon(icono, color: Colors.white.withValues(alpha: 0.85), size: 22),
          const SizedBox(height: 6),
          _NumeroAnimado(valor: valor),
          const SizedBox(height: 4),
          Text(
            etiqueta,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _seccionCategorias(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 32, 20, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(titulo: 'Categorías'),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              for (final (i, categoria) in _categorias.indexed)
                _tarjetaCategoria(context, categoria, i,
                    seleccionado: _categoriaSel == categoria.slug),
            ],
          ),
        ],
      ),
    );
  }

  /// Paleta curada (no genérica, tonos tierra/agua/bosque) para que el
  /// círculo de ícono no se vea igual en las 8 categorías — antes todas
  /// compartían el mismo verde claro y el bloque se leía monótono. Se
  /// repite si hay más categorías que colores.
  static const List<Color> _paletaCategorias = [
    Color(0xFFDCEEE6), // verde bosque
    Color(0xFFFBE7D3), // durazno/tierra
    Color(0xFFDCEAF7), // azul cielo
    Color(0xFFF3E1E8), // rosa tierra
    Color(0xFFEFEAD6), // arena
    Color(0xFFDCF0EC), // turquesa agua
    Color(0xFFE9E0F5), // lavanda
    Color(0xFFE9F0DA), // lima
  ];

  Widget _tarjetaCategoria(
      BuildContext context, CategoriaOficial categoria, int indice,
      {required bool seleccionado}) {
    final colorFondo =
        _paletaCategorias[indice % _paletaCategorias.length];
    return HoverLift(
      child: Material(
        color: NVColors.superficie,
        elevation: 2,
        shadowColor: Colors.black.withValues(alpha: 0.10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: seleccionado ? NVColors.primary : Colors.transparent,
            width: 2,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => _alTocarCategoria(categoria.slug),
          child: Container(
            width: 136,
            height: 132,
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: colorFondo,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: IconoEtiqueta(
                      iconoUrl: categoria.iconoUrl,
                      iconoTexto: categoria.iconoOTexto,
                      tamano: 19),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: Text(
                    categoria.nombre,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    // height (interlineado) explícito: Work Sans no tiene el
                    // mismo alto de línea por defecto que el Roboto que se
                    // usaba antes de agregar la tipografía de marca — con la
                    // altura fija de la tarjeta, esa diferencia bastaba para
                    // que la 3ra línea de nombres largos ("Aprovechamiento y
                    // Valorización de Residuos") quedara cortada en vez de
                    // recortada con puntos suspensivos.
                    style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 11,
                        height: 1.2),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _seccionSubcategorias(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 32, 20, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
              titulo: 'Subcategorías',
              subtitulo: 'Dentro de ${_categoriaPorSlug(_categoriaSel)?.nombre ?? ''}'),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final sub in _subcategoriasFiltradas)
                ChipFiltro(
                  etiqueta: sub.nombre,
                  icono: sub.icono,
                  seleccionado: _subcategoriaSel == sub.slug,
                  onTap: () => _alTocarSubcategoria(sub.slug),
                  anchoMinimo: 180,
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _seccionActividades(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 32, 20, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
              titulo: 'Actividades productivas',
              subtitulo:
                  'Dentro de ${_subcategoriaPorSlug(_subcategoriaSel)?.nombre ?? ''}'),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final actividad in _actividadesFiltradas)
                ChipFiltro(
                  etiqueta: actividad.nombre,
                  icono: actividad.icono,
                  seleccionado: _actividadSel == actividad.slug,
                  onTap: () => _alTocarActividad(actividad.slug),
                  anchoMinimo: 180,
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _seccionMunicipios(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 32, 20, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(titulo: 'Municipios'),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final municipio in kMunicipios)
                ChipFiltro(
                  etiqueta: municipio,
                  icono: '📍',
                  seleccionado: _municipioSel == municipio,
                  onTap: () => _alTocarMunicipio(municipio),
                ),
            ],
          ),
        ],
      ),
    );
  }

  /// Cierra las 4 secciones de filtro de arriba: junta lo marcado (puede
  /// ser nada) y recién ahí navega a /buscar — visible siempre, no hace
  /// falta completar los 4 niveles para poder buscar.
  Widget _botonBuscarFiltros(BuildContext context) {
    final resumen = [
      _municipioSel,
      _categoriaPorSlug(_categoriaSel)?.nombre,
      _subcategoriaPorSlug(_subcategoriaSel)?.nombre,
      _actividadPorSlug(_actividadSel)?.nombre,
    ].whereType<String>().join(' · ');

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Column(
            children: [
              if (resumen.isNotEmpty) ...[
                Text(
                  'Buscando: $resumen',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: NVColors.textoSecundario, fontSize: 12.5),
                ),
                const SizedBox(height: 10),
              ],
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _buscarConFiltrosAcumulados,
                  icon: const Icon(Icons.search, size: 20),
                  label: const Text('Buscar negocios verdes'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _seccionDestacados(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            titulo: 'Negocios destacados',
            accion: TextButton(
              onPressed: () => context.go('/buscar'),
              child: const Text('Ver todos'),
            ),
          ),
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, constraints) {
              final columnas = constraints.maxWidth >= 900
                  ? 3
                  : (constraints.maxWidth >= 600 ? 2 : 1);
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _destacados.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columnas,
                  mainAxisExtent: 150,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemBuilder: (context, i) =>
                    HoverLift(child: NegocioCard(negocio: _destacados[i])),
              );
            },
          ),
        ],
      ),
    );
  }

  /// Antes era un párrafo centrado sin mucho más — se leía como relleno de
  /// maqueta. 3 pilares con ícono son más escaneables. El 3er pilar ya no
  /// es "economía local y justa / comunidades de la región / cadenas
  /// externas" — genérico, sonaba a relleno de IA y no citaba nada
  /// verificable. Se reemplazó por la clasificación oficial (mismos datos
  /// que /nosotros: 3 categorías, 12 subcategorías, 29 actividades del
  /// PNNV 2022-2030), consistente con el resto del sitio.
  Widget _seccionQueSon(BuildContext context) {
    const pilares = [
      (
        Icons.verified_outlined,
        'Verificados por la CDMB',
        'Cada negocio pasa por un proceso real de verificación de la '
            'Ventanilla de Negocios Verdes antes de aparecer en este '
            'directorio.',
      ),
      (
        Icons.eco_outlined,
        'Impacto ambiental positivo',
        'Prácticas que protegen los recursos naturales y la biodiversidad '
            'en los 13 municipios de la jurisdicción de la CDMB.',
      ),
      (
        Icons.account_tree_outlined,
        'Parte del Plan Nacional',
        'Cada negocio queda clasificado bajo las 3 categorías, 12 '
            'subcategorías y 29 actividades productivas oficiales del Plan '
            'Nacional de Negocios Verdes 2022-2030.',
      ),
    ];

    return Container(
      width: double.infinity,
      // Antes tenía margin: top 32 — dejaba una franja del fondo crema del
      // Column entre el final de OndaDivisora (que ya termina en este
      // mismo primaryLight) y el inicio de este degradado, un salto de
      // color real y recto, no un artefacto de renderizado. Sin margen,
      // el degradado arranca justo donde la onda termina, mismo color a
      // ambos lados de la unión.
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 44),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [NVColors.primaryLight, NVColors.fondo],
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: const BoxDecoration(
              color: NVColors.superficie,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: const Icon(Icons.eco, color: NVColors.primary, size: 30),
          ),
          const SizedBox(height: 16),
          const Text(
            '¿Qué son los Negocios Verdes?',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: const Text(
              'Son emprendimientos y empresas que ofrecen bienes y servicios '
              'con impacto ambiental positivo, verificados por la '
              'Ventanilla de Negocios Verdes en los 13 municipios de la '
              'jurisdicción de la CDMB.',
              textAlign: TextAlign.center,
              style: TextStyle(color: NVColors.textoSecundario, fontSize: 15),
            ),
          ),
          const SizedBox(height: 32),
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 900),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final ancho = constraints.maxWidth >= 700;
                  final tarjetas = [
                    for (final p in pilares) _tarjetaPilar(p.$1, p.$2, p.$3),
                  ];
                  if (!ancho) {
                    return Column(
                      children: [
                        for (final t in tarjetas)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 14),
                            child: t,
                          ),
                      ],
                    );
                  }
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (final t in tarjetas)
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: t,
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 28),
          ElevatedButton.icon(
            onPressed: () => context.go('/nosotros'),
            icon: const Icon(Icons.arrow_forward, size: 18),
            label: const Text('Conocer más'),
          ),
        ],
      ),
    );
  }

  Widget _tarjetaPilar(IconData icono, String titulo, String texto) {
    return HoverLift(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: NVColors.superficie,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: const BoxDecoration(
                color: NVColors.primaryLight,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Icon(icono, color: NVColors.primary, size: 24),
            ),
            const SizedBox(height: 14),
            Text(titulo,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            const SizedBox(height: 6),
            Text(
              texto,
              style: const TextStyle(
                  color: NVColors.textoSecundario, fontSize: 13, height: 1.4),
            ),
          ],
        ),
      ),
    );
  }
}

/// Cuenta desde 0 hasta [valor] cada vez que [valor] cambia — sin
/// AnimationController propio que crear/limpiar: TweenAnimationBuilder ya
/// maneja ese ciclo de vida y reacciona solo a que cambie el "end".
class _NumeroAnimado extends StatelessWidget {
  final int valor;

  const _NumeroAnimado({required this.valor});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: valor.toDouble()),
      duration: const Duration(milliseconds: 1400),
      curve: Curves.easeOutCubic,
      builder: (context, valorAnimado, _) => Text(
        valorAnimado.round().toString(),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 34,
          fontWeight: FontWeight.bold,
          height: 1,
        ),
      ),
    );
  }
}
