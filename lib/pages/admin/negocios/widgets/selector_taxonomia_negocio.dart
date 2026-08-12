import 'package:flutter/material.dart';

import '../../../../core/widgets/chip_filtro.dart';
import '../../../../models/actividad_productiva.dart';
import '../../../../models/categoria_oficial.dart';
import '../../../../models/subcategoria.dart';
import '../../../../theme/nv_colors.dart';
import 'selector_actividades.dart';
import 'selector_subcategorias.dart';

/// Categoría (hasta 3) → subcategoría → actividad productiva, la cascada
/// completa en un solo widget con su propio estado local — antes vivía
/// suelta dentro de AdminNegocioFormPageState, así que cada toque disparaba
/// el setState de TODO el formulario (incluido el mapa de ubicación, la
/// galería, los campos de contacto...). Eso dejó de ser inofensivo cuando
/// el municipio pasó a elegirse primero: el mapa quedaba montado y activo
/// justo mientras el admin seguía tocando chips de categoría/subcategoría,
/// y esas reconstrucciones repetidas del formulario entero coincidían con
/// un "Null check operator used on a null value" reportado en producción.
/// Aislar la cascada acá hace que tocar estos chips solo reconstruya ESTE
/// widget — el resto del formulario (mapa incluido) queda intacto. El
/// padre se entera vía [onCambio], igual que ya hacía con la galería
/// (onGaleriaCambiada) — sin necesidad de su propio setState.
class SelectorTaxonomiaNegocio extends StatefulWidget {
  final List<CategoriaOficial> categorias;
  final List<Subcategoria> subcategorias;
  final List<ActividadProductiva> actividades;
  final List<String> categoriaIdsIniciales;
  final Set<String> subcategoriaIdsIniciales;
  final Set<String> actividadIdsIniciales;
  final void Function(List<String> categoriaIds, Set<String> subcategoriaIds,
      Set<String> actividadIds) onCambio;

  const SelectorTaxonomiaNegocio({
    super.key,
    required this.categorias,
    required this.subcategorias,
    required this.actividades,
    required this.categoriaIdsIniciales,
    required this.subcategoriaIdsIniciales,
    required this.actividadIdsIniciales,
    required this.onCambio,
  });

  @override
  State<SelectorTaxonomiaNegocio> createState() =>
      _SelectorTaxonomiaNegocioState();
}

class _SelectorTaxonomiaNegocioState extends State<SelectorTaxonomiaNegocio> {
  late List<String> _categoriaIds;
  late Set<String> _subcategoriaIds;
  late Set<String> _actividadIds;

  @override
  void initState() {
    super.initState();
    _categoriaIds = [...widget.categoriaIdsIniciales];
    _subcategoriaIds = {...widget.subcategoriaIdsIniciales};
    _actividadIds = {...widget.actividadIdsIniciales};
  }

  void _notificar() =>
      widget.onCambio(_categoriaIds, _subcategoriaIds, _actividadIds);

  void _alternarCategoria(String id) {
    if (_categoriaIds.contains(id)) {
      setState(() {
        _categoriaIds.remove(id);
        // Poda subcategorías de la categoría que se acaba de quitar y, un
        // nivel más abajo, las actividades que dependían de esas
        // subcategorías — si no, quedan seleccionadas "a escondidas".
        final idsDeEstaCategoria = widget.subcategorias
            .where((s) => s.categoriaOficialId == id)
            .map((s) => s.id)
            .toSet();
        _subcategoriaIds.removeWhere(idsDeEstaCategoria.contains);
        final idsDeActividadesDeEstaCategoria = widget.actividades
            .where((a) => idsDeEstaCategoria.contains(a.subcategoriaId))
            .map((a) => a.id)
            .toSet();
        _actividadIds.removeWhere(idsDeActividadesDeEstaCategoria.contains);
      });
    } else {
      if (_categoriaIds.length >= 3) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Máximo 3 categorías por negocio.')));
        return;
      }
      setState(() => _categoriaIds.add(id));
    }
    _notificar();
  }

  void _alSeleccionarSubcategorias(Set<String> ids) {
    setState(() {
      _subcategoriaIds = ids;
      final idsDeActividadesValidas = widget.actividades
          .where((a) => ids.contains(a.subcategoriaId))
          .map((a) => a.id)
          .toSet();
      _actividadIds.removeWhere((id) => !idsDeActividadesValidas.contains(id));
    });
    _notificar();
  }

  void _alSeleccionarActividades(Set<String> ids) {
    setState(() => _actividadIds = ids);
    _notificar();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Categorías oficiales (hasta 3 — la primera que marques queda '
          'como principal)',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final c in widget.categorias)
              ChipFiltro(
                etiqueta: c.nombre,
                icono: c.iconoOTexto,
                seleccionado: _categoriaIds.contains(c.id),
                onTap: () => _alternarCategoria(c.id),
                variante: true,
              ),
          ],
        ),
        if (_categoriaIds.isEmpty)
          const Padding(
            padding: EdgeInsets.only(top: 6),
            child: Text('Selecciona al menos una.',
                style: TextStyle(color: NVColors.error, fontSize: 12)),
          ),
        const SizedBox(height: 16),
        SelectorSubcategorias(
          key: ValueKey(_categoriaIds.join(',')),
          categorias: widget.categorias
              .where((c) => _categoriaIds.contains(c.id))
              .toList(),
          subcategorias: widget.subcategorias,
          seleccionadas: _subcategoriaIds,
          onCambio: _alSeleccionarSubcategorias,
        ),
        const SizedBox(height: 16),
        Text('Actividades productivas',
            style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 8),
        SelectorActividades(
          key: ValueKey(_subcategoriaIds.join(',')),
          subcategorias: widget.subcategorias
              .where((s) => _subcategoriaIds.contains(s.id))
              .toList(),
          actividades: widget.actividades,
          seleccionadas: _actividadIds,
          onCambio: _alSeleccionarActividades,
        ),
      ],
    );
  }
}
