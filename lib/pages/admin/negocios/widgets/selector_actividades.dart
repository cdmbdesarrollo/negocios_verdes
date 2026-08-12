import 'package:flutter/material.dart';

import '../../../../core/widgets/chip_filtro.dart';
import '../../../../models/actividad_productiva.dart';
import '../../../../models/subcategoria.dart';
import '../../../../theme/nv_colors.dart';

/// Un nivel más abajo que SelectorSubcategorias, mismo patrón exacto:
/// [subcategorias] ya viene filtrada de afuera (solo las que el admin
/// eligió), así que solo se muestran actividades relevantes a esa
/// selección, agrupadas por su subcategoría.
class SelectorActividades extends StatefulWidget {
  final List<Subcategoria> subcategorias;
  final List<ActividadProductiva> actividades;
  final Set<String> seleccionadas;
  final ValueChanged<Set<String>> onCambio;

  const SelectorActividades({
    super.key,
    required this.subcategorias,
    required this.actividades,
    required this.seleccionadas,
    required this.onCambio,
  });

  @override
  State<SelectorActividades> createState() => _SelectorActividadesState();
}

class _SelectorActividadesState extends State<SelectorActividades> {
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
    if (widget.subcategorias.isEmpty) {
      return const Text(
        'Elige primero una subcategoría arriba para ver sus actividades productivas.',
        style: TextStyle(color: NVColors.textoSecundario),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final subcategoria in widget.subcategorias) ...[
          Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 6),
            child: Text(
              '${subcategoria.iconoOTexto} ${subcategoria.nombre}',
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            ),
          ),
          _actividadesDe(subcategoria.id),
        ],
      ],
    );
  }

  Widget _actividadesDe(String subcategoriaId) {
    final actividades = widget.actividades
        .where((a) => a.subcategoriaId == subcategoriaId)
        .toList();
    if (actividades.isEmpty) {
      return const Text('Sin actividades productivas todavía.',
          style: TextStyle(color: NVColors.textoSecundario, fontSize: 12));
    }
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final actividad in actividades)
          ChipFiltro(
            etiqueta: actividad.nombre,
            icono: actividad.icono,
            variante: true,
            seleccionado: _seleccionadas.contains(actividad.id),
            onTap: () => _alternar(actividad.id),
          ),
      ],
    );
  }
}
