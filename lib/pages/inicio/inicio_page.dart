import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/seo_tags.dart';
import '../../core/widgets/pie_pagina.dart';
import '../../core/widgets/section_header.dart';
import '../../models/categoria_oficial.dart';
import '../../models/filtro_busqueda.dart';
import '../../models/negocio.dart';
import '../../services/categoria_service.dart';
import '../../services/negocio_service.dart';
import '../../theme/nv_colors.dart';
import '../buscar/widgets/negocio_card.dart';

class InicioPage extends StatefulWidget {
  const InicioPage({super.key});

  @override
  State<InicioPage> createState() => _InicioPageState();
}

class _InicioPageState extends State<InicioPage> {
  final _negocioService = NegocioService();
  final _categoriaService = CategoriaService();
  final _busquedaCtrl = TextEditingController();

  List<CategoriaOficial> _categorias = [];
  List<Negocio> _destacados = [];
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
        _negocioService.buscar(const FiltroBusqueda()),
      ]);
      if (!mounted) return;
      final categorias = resultados[0] as List<CategoriaOficial>;
      final todos = resultados[1] as List<Negocio>;
      setState(() {
        _categorias = categorias.where((c) => c.activo).toList();
        _destacados = todos.where((n) => n.destacado).take(6).toList();
        _totalNegocios = todos.length;
        _cargando = false;
      });
    } catch (_) {
      if (mounted) setState(() => _cargando = false);
    }
  }

  void _buscar([String? texto]) {
    final query = texto ?? _busquedaCtrl.text;
    final uri = Uri(
      path: '/buscar',
      queryParameters: query.trim().isEmpty ? null : {'q': query.trim()},
    );
    context.go(uri.toString());
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _hero(context),
          if (_categorias.isNotEmpty) _seccionCategorias(context),
          if (_destacados.isNotEmpty) _seccionDestacados(context),
          _seccionQueSon(context),
          const PiePagina(),
        ],
      ),
    );
  }

  Widget _hero(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 48),
      decoration: const BoxDecoration(gradient: NVColors.gradientHero),
      child: Column(
        children: [
          const Text('🌱', style: TextStyle(fontSize: 40)),
          const SizedBox(height: 12),
          const Text(
            'Negocios Verdes CDMB',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            _cargando
                ? 'El directorio de negocios verdes de los 13 municipios de '
                    'la jurisdicción CDMB'
                : '$_totalNegocios negocios verdes en los 13 municipios de '
                    'la jurisdicción CDMB',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white70, fontSize: 16),
          ),
          const SizedBox(height: 24),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: Material(
              borderRadius: BorderRadius.circular(30),
              child: TextField(
                controller: _busquedaCtrl,
                onSubmitted: _buscar,
                decoration: InputDecoration(
                  hintText: 'Busca por nombre, categoría o municipio...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.arrow_forward),
                    onPressed: () => _buscar(),
                  ),
                ),
              ),
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
              for (final categoria in _categorias)
                _tarjetaCategoria(context, categoria),
            ],
          ),
        ],
      ),
    );
  }

  Widget _tarjetaCategoria(BuildContext context, CategoriaOficial categoria) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => context.go(
        Uri(path: '/buscar', queryParameters: {'categoria': categoria.slug})
            .toString(),
      ),
      child: Container(
        width: 160,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: NVColors.primaryLight,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(categoria.iconoOTexto, style: const TextStyle(fontSize: 28)),
            const SizedBox(height: 8),
            Text(
              categoria.nombre,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            ),
          ],
        ),
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
