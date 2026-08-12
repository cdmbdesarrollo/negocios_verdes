import 'package:flutter/material.dart';

import '../../../../core/widgets/chip_filtro.dart';
import '../../../../models/categoria_oficial.dart';
import '../../../../models/subcategoria.dart';
import '../../../../theme/nv_colors.dart';

/// Selector múltiple de subcategorías, agrupado por categoría oficial.
class SelectorSubcategorias extends StatefulWidget {
  final List<CategoriaOficial> categorias;
  final List<Subcategoria> subcategorias;
  final Set<String> seleccionadas;
  final ValueChanged<Set<String>> onCambio;

  const SelectorSubcategorias({
    super.key,
    required this.categorias,
    required this.subcategorias,
    required this.seleccionadas,
    required this.onCambio,
  });

  @override
  State<SelectorSubcategorias> createState() => _SelectorSubcategoriasState();
}

class _SelectorSubcategoriasState extends State<SelectorSubcategorias> {
  late Set<String> _seleccionadas;

  @override
  void initState() {
    super.initState();
    _seleccionadas = {...widget.seleccionadas};
  }

  void _alternar(String id) {
    setState(() {
      if (_seleccionadas.contains(id)) {
        _seleccionadas.remove(id);
      } else {
        _seleccionadas.add(id);
      }
    });
    widget.onCambio(_seleccionadas);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.categorias.isEmpty) {
      return const Text(
        'Primero crea categorías y subcategorías desde /admin/categorias.',
        style: TextStyle(color: NVColors.textoSecundario),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final categoria in widget.categorias) ...[
          Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 6),
            child: Text(
              '${categoria.iconoOTexto} ${categoria.nombre}',
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            ),
          ),
          _subcategoriasDe(categoria.id),
        ],
      ],
    );
  }

  Widget _subcategoriasDe(String categoriaId) {
    final subs = widget.subcategorias
        .where((s) => s.categoriaOficialId == categoriaId)
        .toList();
    if (subs.isEmpty) {
      return const Text('Sin subcategorías todavía.',
          style: TextStyle(color: NVColors.textoSecundario, fontSize: 12));
    }
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final sub in subs)
          ChipFiltro(
            etiqueta: sub.nombre,
            icono: sub.icono,
            seleccionado: _seleccionadas.contains(sub.id),
            onTap: () => _alternar(sub.id),
            anchoMinimo: 180,
          ),
      ],
    );
  }
}
