import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/seo_tags.dart';
import '../../core/widgets/logo_negocios_verdes.dart';
import '../../core/widgets/pie_pagina.dart';
import '../../models/actividad_productiva.dart';
import '../../models/categoria_oficial.dart';
import '../../models/subcategoria.dart';
import '../../services/actividad_productiva_service.dart';
import '../../services/categoria_service.dart';
import '../../services/subcategoria_service.dart';
import '../../theme/nv_colors.dart';

class NosotrosPage extends StatefulWidget {
  const NosotrosPage({super.key});

  @override
  State<NosotrosPage> createState() => _NosotrosPageState();
}

class _NosotrosPageState extends State<NosotrosPage> {
  final _categoriaService = CategoriaService();
  final _subcategoriaService = SubcategoriaService();
  final _actividadService = ActividadProductivaService();

  List<CategoriaOficial> _categorias = [];
  List<Subcategoria> _subcategorias = [];
  List<ActividadProductiva> _actividades = [];

  @override
  void initState() {
    super.initState();
    establecerSeo(
      titulo: '¿Qué son los Negocios Verdes? — Negocios Verdes CDMB',
      descripcion:
          'La definición oficial de Negocios Verdes, sus 3 categorías y '
          'cómo la Ventanilla de Negocios Verdes de la CDMB acompaña a los '
          'negocios de los 13 municipios de nuestra jurisdicción.',
    );
    _cargarTaxonomia();
  }

  /// Solo para el árbol expandible de categoría→subcategoría→actividad —
  /// el resto de esta página es contenido estático que no depende de la
  /// base de datos, por eso no hay pantalla de carga: el árbol simplemente
  /// aparece cuando estos 3 listados terminan de llegar.
  Future<void> _cargarTaxonomia() async {
    try {
      final resultados = await Future.wait([
        _categoriaService.listarTodas(),
        _subcategoriaService.listarTodas(),
        _actividadService.listarTodas(),
      ]);
      if (!mounted) return;
      setState(() {
        _categorias =
            (resultados[0] as List<CategoriaOficial>).where((c) => c.activo).toList();
        _subcategorias =
            (resultados[1] as List<Subcategoria>).where((s) => s.activo).toList();
        _actividades =
            (resultados[2] as List<ActividadProductiva>).where((a) => a.activo).toList();
      });
    } catch (_) {
      // Silencioso a propósito: el árbol es un complemento, no bloquea el
      // resto de la página si el listado no carga.
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            decoration: const BoxDecoration(gradient: NVColors.gradientHero),
            child: Column(
              children: [
                const LogoNegociosVerdes(altura: 48),
                const SizedBox(height: 8),
                const Text(
                  '¿Qué son los Negocios Verdes?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 760),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _parrafo(
                      'Los Negocios Verdes son las actividades económicas que '
                      'ofrecen bienes y servicios con enfoque ecosistémico y de '
                      'ciclo de vida, generando impactos sociales y ambientales '
                      'positivos. Incorporan prácticas sostenibles y aportan al '
                      'desarrollo bajo en carbono y a la resiliencia climática, a '
                      'partir del uso, transformación, valorización y '
                      'conservación de los recursos, para contribuir al '
                      'desarrollo de los territorios.',
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Text(
                        '— Definición oficial, Plan Nacional de Negocios '
                        'Verdes 2022-2030 (Ministerio de Ambiente y '
                        'Desarrollo Sostenible)',
                        style: TextStyle(
                          fontSize: 12.5,
                          fontStyle: FontStyle.italic,
                          color: NVColors.textoSecundario,
                        ),
                      ),
                    ),
                    const Text(
                      'Las 3 categorías oficiales',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    const SizedBox(height: 12),
                    _categoria(
                      context,
                      '🌱 Bioproductos y Servicios Sostenibles',
                      'Incorporan buenas prácticas ambientales en el '
                          'aprovechamiento, producción, transformación o '
                          'comercialización de recursos biológicos — desde la '
                          'materia prima hasta el producto final. Agrupa la '
                          'agricultura sostenible, el biocomercio, la '
                          'biotecnología y el turismo sostenible.',
                      'bioproductos-servicios-sostenibles',
                    ),
                    _categoria(
                      context,
                      '♻️ Ecoproductos Industriales',
                      'Bienes y servicios que, frente a otros de su mismo '
                          'segmento, resultan menos contaminantes: aprovechan '
                          'ciclos extendidos de los materiales y reducen la '
                          'generación de residuos, con impacto directo en la '
                          'economía circular.',
                      'ecoproductos-industriales',
                    ),
                    _categoria(
                      context,
                      '🌍 Productos por la Calidad Ambiental',
                      'Negocios que reducen la contaminación del aire, el '
                          'agua y el suelo, y que mitigan o se adaptan al '
                          'cambio climático mediante tecnologías verdes — con '
                          'impacto en energía, transporte sostenible y '
                          'restauración de ecosistemas.',
                      'calidad-ambiental',
                    ),
                    if (_categorias.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      const Text(
                        'Estructura completa de la clasificación',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      const SizedBox(height: 4),
                      _parrafo(
                        'Toca una categoría para ver sus subcategorías, y '
                        'una subcategoría para ver sus actividades '
                        'productivas — cada actividad lleva directo a los '
                        'negocios verdes que la practican.',
                      ),
                      _arbolTaxonomia(context),
                      const SizedBox(height: 12),
                    ],
                    const Text(
                      '¿Qué es la Ventanilla de Negocios Verdes?',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    const SizedBox(height: 8),
                    _parrafo(
                      'Las Ventanillas de Negocios Verdes son los equipos '
                      'técnicos que cada autoridad ambiental del país '
                      'conforma para liderar el Programa Regional de '
                      'Negocios Verdes en su territorio: articulan a los '
                      'actores regionales, hacen seguimiento a los negocios '
                      'verdes de la zona y generan las estadísticas que '
                      'miden su aporte al desarrollo económico y a la '
                      'conservación de los recursos naturales. Nosotros '
                      'tenemos la nuestra para los 13 municipios de nuestra '
                      'jurisdicción.',
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Niveles de desarrollo',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    const SizedBox(height: 8),
                    _nivel(
                      '🌱 En verificación',
                      'Emprendimientos que están iniciando su proceso de '
                          'verificación con la CDMB.',
                    ),
                    _nivel(
                      '✅ Verificado',
                      'Negocios que ya cumplen los criterios del programa y '
                          'fueron verificados por la CDMB.',
                    ),
                    _nivel(
                      '🏆 Negocio ancla',
                      'Negocios verdes consolidados, referentes en su '
                          'categoría y en su municipio.',
                    ),
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: NVColors.fondo,
                        border: Border.all(color: NVColors.borde),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '🎖️ Sello Marca de Negocios Verdes',
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 15),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Certificación oficial que reconoce a las '
                            'empresas y emprendimientos que generan un '
                            'impacto ambiental positivo, garantizan buenas '
                            'prácticas sociales y económicas, y protegen '
                            'los recursos naturales. Se otorga a los '
                            'negocios que superan el 71 % de cumplimiento '
                            'en la evaluación de criterios.',
                            style: TextStyle(
                                color: NVColors.textoSecundario,
                                fontSize: 13,
                                height: 1.4),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: NVColors.fondo,
                        border: Border.all(color: NVColors.borde),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '🛡️ Aval de Confianza',
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 15),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Reconocimiento oficial otorgado por la '
                            'Ventanilla de Negocios Verdes a las empresas y '
                            'emprendimientos que cumplen los requisitos '
                            'mínimos y superan el 51 % de avance en '
                            'criterios ambientales, sociales y económicos.',
                            style: TextStyle(
                                color: NVColors.textoSecundario,
                                fontSize: 13,
                                height: 1.4),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: NVColors.primaryLight,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Meta nacional a 2030: 12.630 negocios verdes '
                            'verificados',
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 15),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Este directorio es la implementación local de '
                            'la CDMB del Plan Nacional de Negocios Verdes '
                            '2022-2030. Conoce sus objetivos, líneas '
                            'estratégicas y metas completas.',
                            style: TextStyle(
                                color: NVColors.textoSecundario, fontSize: 13),
                          ),
                          const SizedBox(height: 10),
                          OutlinedButton(
                            onPressed: () => context.go('/plan-nacional'),
                            child: const Text('Conocer el Plan Nacional →'),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      '¿Cómo hacer parte de los Negocios Verdes de la CDMB?',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    const SizedBox(height: 8),
                    _parrafo(
                      'Por ahora, la vinculación al programa y la '
                      'verificación de cada negocio las gestiona directamente '
                      'el equipo de la Ventanilla de Negocios Verdes de la '
                      'CDMB. Si tienes un negocio verde en alguno de los 13 '
                      'municipios de la jurisdicción y quieres más '
                      'información sobre el proceso, escríbenos desde la '
                      'página de contacto.',
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () => context.go('/contacto'),
                      child: const Text('Ir a contacto'),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const PiePagina(),
        ],
      ),
    );
  }

  Widget _parrafo(String texto) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(texto, style: const TextStyle(fontSize: 15, height: 1.5)),
    );
  }

  Widget _nivel(String titulo, String descripcion) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(titulo, style: const TextStyle(fontWeight: FontWeight.w600)),
          Text(descripcion,
              style: const TextStyle(color: NVColors.textoSecundario)),
        ],
      ),
    );
  }

  Widget _categoria(
      BuildContext context, String titulo, String descripcion, String slug) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: NVColors.superficie,
        border: Border.all(color: NVColors.borde),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(titulo,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
          const SizedBox(height: 6),
          Text(descripcion,
              style: const TextStyle(
                  color: NVColors.textoSecundario, fontSize: 13.5, height: 1.4)),
          const SizedBox(height: 8),
          InkWell(
            onTap: () => context.go('/buscar?categoria=$slug'),
            child: const Text(
              'Ver negocios de esta categoría →',
              style: TextStyle(
                  color: NVColors.primary,
                  fontSize: 13,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  /// Árbol expandible categoría → subcategoría → actividad. ExpansionTile
  /// (Material estándar) en vez de algo hecho a mano — con 29 actividades
  /// mostrarlas todas de una sería una pared de texto; colapsado por
  /// defecto se navega mucho mejor.
  Widget _arbolTaxonomia(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: NVColors.superficie,
        border: Border.all(color: NVColors.borde),
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAlias,
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: Column(
          children: [
            for (final categoria in _categorias) _nodoCategoria(context, categoria),
          ],
        ),
      ),
    );
  }

  Widget _nodoCategoria(BuildContext context, CategoriaOficial categoria) {
    final subs = _subcategorias
        .where((s) => s.categoriaOficialId == categoria.id)
        .toList();
    return ExpansionTile(
      tilePadding: const EdgeInsets.symmetric(horizontal: 16),
      title: Text('${categoria.iconoOTexto} ${categoria.nombre}',
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14.5)),
      children: [
        for (final sub in subs) _nodoSubcategoria(context, categoria, sub),
      ],
    );
  }

  Widget _nodoSubcategoria(
      BuildContext context, CategoriaOficial categoria, Subcategoria sub) {
    final actividades =
        _actividades.where((a) => a.subcategoriaId == sub.id).toList();
    return Padding(
      padding: const EdgeInsets.only(left: 12),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16),
        title: Text('${sub.iconoOTexto} ${sub.nombre}',
            style: const TextStyle(fontSize: 13.5)),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
            child: actividades.isEmpty
                ? const Text('Sin actividades productivas todavía.',
                    style: TextStyle(
                        color: NVColors.textoSecundario, fontSize: 12))
                : Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final actividad in actividades)
                        ActionChip(
                          label: Text(
                            '${actividad.iconoOTexto} ${actividad.nombre}',
                            style: const TextStyle(fontSize: 12.5),
                          ),
                          backgroundColor: NVColors.primaryLight,
                          // Los 3 niveles en el link (no solo actividad):
                          // así el buscador llega con la cascada completa
                          // resaltada, no solo con el resultado ya filtrado
                          // pero los chips de categoría/subcategoría en
                          // blanco.
                          onPressed: () => context.go(
                              '/buscar?categoria=${categoria.slug}&subcategoria=${sub.slug}&actividad=${actividad.slug}'),
                        ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
