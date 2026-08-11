import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../catalogos.dart';
import '../../core/seo_tags.dart';
import '../../core/widgets/chip_filtro.dart';
import '../../core/widgets/icono_etiqueta.dart';
import '../../core/widgets/logo_negocios_verdes.dart';
import '../../core/widgets/pie_pagina.dart';
import '../../core/widgets/section_header.dart';
import '../../models/banner_sitio.dart';
import '../../models/categoria_oficial.dart';
import '../../models/filtro_busqueda.dart';
import '../../models/negocio.dart';
import '../../models/subcategoria.dart';
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
  final _bannerService = BannerService();
  final _busquedaCtrl = TextEditingController();

  List<CategoriaOficial> _categorias = [];
  List<Subcategoria> _subcategorias = [];
  List<Negocio> _destacados = [];
  List<BannerSitio> _banners = [];
  int _totalNegocios = 0;
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    establecerSeo(
      titulo: 'Negocios Verdes CDMB — Directorio de negocios verdes',
      descripcion:
          'Encuentra negocios verdes verificados por la CDMB en los 13 '
          'municipios de su jurisdicción: agroturismo, apicultura, '
          'ecoturismo y mucho más.',
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
        _negocioService.buscar(const FiltroBusqueda()),
        _bannerService.listarActivos(),
      ]);
      if (!mounted) return;
      final categorias = resultados[0] as List<CategoriaOficial>;
      final subcategorias = resultados[1] as List<Subcategoria>;
      final todos = resultados[2] as List<Negocio>;
      final banners = resultados[3] as List<BannerSitio>;
      setState(() {
        _categorias = categorias.where((c) => c.activo).toList();
        _subcategorias = subcategorias.where((s) => s.activo).toList();
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

  /// Banners reales subidos desde /admin/apariencia si existen; si la lista
  /// todavía está vacía (recién instalado, o mientras carga), se usan las 4
  /// diapositivas de fábrica de más abajo — nunca se muestra un carrusel
  /// vacío.
  List<SlideInfo> get _slides {
    if (_banners.isNotEmpty) {
      return [
        for (final banner in _banners)
          SlideInfo.imagen(
            imagenUrl: banner.imagenUrl,
            onTap: _resolverDestino(banner.urlDestino, banner.abrirEnPestanaNueva),
          ),
      ];
    }
    return _slidesDeFabrica;
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
          subtitulo: 'Agrosistemas, ecoturismo, apicultura, energías '
              'renovables y más.',
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
    return SingleChildScrollView(
      child: Column(
        children: [
          HeroSlider(slides: _slides),
          _buscadorPersistente(context),
          if (_categorias.isNotEmpty) _seccionCategorias(context),
          if (_subcategorias.isNotEmpty) _seccionSubcategorias(context),
          _seccionMunicipios(context),
          if (_destacados.isNotEmpty) _seccionDestacados(context),
          _seccionQueSon(context),
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
              constraints: const BoxConstraints(maxWidth: 560),
              child: Material(
                elevation: 4,
                shadowColor: Colors.black.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(30),
                child: TextField(
                  controller: _busquedaCtrl,
                  onSubmitted: _buscar,
                  decoration: InputDecoration(
                    hintText: 'Busca por nombre, categoría o municipio...',
                    prefixIcon:
                        const Icon(Icons.search, color: NVColors.primary),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.arrow_forward),
                      color: NVColors.primaryDark,
                      onPressed: () => _buscar(),
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

  Widget _seccionCategorias(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(titulo: 'Categorías'),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              for (final categoria in _categorias)
                _tarjetaCategoria(context, categoria),
            ],
          ),
        ],
      ),
    );
  }

  Widget _tarjetaCategoria(BuildContext context, CategoriaOficial categoria) {
    return Material(
      color: NVColors.primaryLight,
      elevation: 1,
      shadowColor: Colors.black.withValues(alpha: 0.12),
      borderRadius: BorderRadius.circular(14),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _irA({'categoria': categoria.slug}),
        child: Container(
          width: 132,
          height: 124,
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconoEtiqueta(
                  iconoUrl: categoria.iconoUrl,
                  iconoTexto: categoria.iconoOTexto,
                  tamano: 22),
              const SizedBox(height: 6),
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
    );
  }

  Widget _seccionSubcategorias(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 32, 20, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(titulo: 'Buscar por subcategoría'),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final sub in _subcategorias)
                ChipFiltro(
                  etiqueta: sub.nombre,
                  icono: sub.icono,
                  seleccionado: false,
                  onTap: () => _irA({'subcategoria': sub.slug}),
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
          const SectionHeader(titulo: 'Buscar por municipio'),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final municipio in kMunicipios)
                ChipFiltro(
                  etiqueta: municipio,
                  seleccionado: false,
                  onTap: () => _irA({'municipio': municipio}),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _seccionDestacados(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 32, 20, 8),
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
                    NegocioCard(negocio: _destacados[i]),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _seccionQueSon(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 32),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      color: NVColors.primaryLight,
      child: Column(
        children: [
          const Text(
            '¿Qué son los Negocios Verdes?',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: const Text(
              'Son emprendimientos y empresas que ofrecen bienes y servicios '
              'con impacto ambiental positivo, verificados por la CDMB en su '
              'jurisdicción. Conoce los requisitos y beneficios de hacer '
              'parte del programa.',
              textAlign: TextAlign.center,
              style: TextStyle(color: NVColors.textoSecundario),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => context.go('/nosotros'),
            child: const Text('Conocer más'),
          ),
        ],
      ),
    );
  }
}
