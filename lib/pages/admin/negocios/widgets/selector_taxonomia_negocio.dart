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
///
/// Pedido explícito: antes las 3 categorías eran chips sueltos siempre
/// seleccionables a la vez, y si se elegían 2-3 se veían TODOS sus
/// árboles de subcategoría/actividad apilados juntos — "se ve un poco
/// desordenado" (con captura real). Ahora es secuencial: cada categoría
/// YA elegida tiene su propia sección con su propio árbol adentro, en el
/// orden en que se eligieron (la primera es la principal), y solo AL
/// FINAL aparece un selector para agregar la siguiente (hasta 3) — nunca
/// las 3 opciones sueltas a la vez.
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
  static const _ordinales = ['primera', 'segunda', 'tercera'];

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

  /// [nuevoSubset] son SOLO las subcategorías de [categoriaId] (la sección
  /// de esta categoría no puede reportar subcategorías de otra) — hay que
  /// mezclarlas con las de las OTRAS secciones en vez de reemplazar todo
  /// _subcategoriaIds, que es un set global compartido entre las 3
  /// secciones posibles.
  void _alSeleccionarSubcategoriasDeCategoria(
      String categoriaId, Set<String> nuevoSubset) {
    final idsDeEstaCategoria = widget.subcategorias
        .where((s) => s.categoriaOficialId == categoriaId)
        .map((s) => s.id)
        .toSet();
    setState(() {
      _subcategoriaIds.removeWhere(idsDeEstaCategoria.contains);
      _subcategoriaIds.addAll(nuevoSubset);
      final idsActividadesValidas = widget.actividades
          .where((a) => _subcategoriaIds.contains(a.subcategoriaId))
          .map((a) => a.id)
          .toSet();
      _actividadIds.removeWhere((id) => !idsActividadesValidas.contains(id));
    });
    _notificar();
  }

  void _alSeleccionarActividadesDeCategoria(
      String categoriaId, Set<String> nuevoSubset) {
    final subcatsDeEstaCategoria = widget.subcategorias
        .where((s) => s.categoriaOficialId == categoriaId)
        .map((s) => s.id)
        .toSet();
    final idsActividadesDeEstaCategoria = widget.actividades
        .where((a) => subcatsDeEstaCategoria.contains(a.subcategoriaId))
        .map((a) => a.id)
        .toSet();
    setState(() {
      _actividadIds.removeWhere(idsActividadesDeEstaCategoria.contains);
      _actividadIds.addAll(nuevoSubset);
    });
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
        const SizedBox(height: 10),
        for (final (indice, categoriaId) in _categoriaIds.indexed)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _seccionCategoria(indice, categoriaId),
          ),
        if (_categoriaIds.isEmpty)
          const Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: Text('Selecciona al menos una.',
                style: TextStyle(color: NVColors.error, fontSize: 12)),
          ),
        if (_categoriaIds.length < 3) _promptSiguienteCategoria(),
      ],
    );
  }

  Widget _seccionCategoria(int indice, String categoriaId) {
    CategoriaOficial? categoria;
    for (final c in widget.categorias) {
      if (c.id == categoriaId) {
        categoria = c;
        break;
      }
    }
    if (categoria == null) return const SizedBox.shrink();

    final subcatsDeEstaCategoria = widget.subcategorias
        .where((s) => s.categoriaOficialId == categoriaId)
        .toList();
    final idsSubcatsDeEstaCategoria =
        subcatsDeEstaCategoria.map((s) => s.id).toSet();
    final subcatsSeleccionadasIds =
        _subcategoriaIds.intersection(idsSubcatsDeEstaCategoria);
    final subcatsSeleccionadasObjetos = subcatsDeEstaCategoria
        .where((s) => subcatsSeleccionadasIds.contains(s.id))
        .toList();
    final actividadesDeEstaCategoria = widget.actividades
        .where((a) => subcatsSeleccionadasIds.contains(a.subcategoriaId))
        .toList();
    final idsActividadesDeEstaCategoria =
        actividadesDeEstaCategoria.map((a) => a.id).toSet();
    final actividadesSeleccionadasIds =
        _actividadIds.intersection(idsActividadesDeEstaCategoria);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: NVColors.fondo,
        border: Border.all(color: NVColors.borde),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(categoria.iconoOTexto, style: const TextStyle(fontSize: 16)),
              const SizedBox(width: 6),
              Expanded(
                child: Text(categoria.nombre,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14)),
              ),
              if (indice == 0)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: NVColors.primaryLight,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text('Principal',
                      style: TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w600,
                          color: NVColors.primaryDark)),
                ),
              IconButton(
                tooltip: 'Quitar esta categoría',
                icon: const Icon(Icons.close, size: 18),
                visualDensity: VisualDensity.compact,
                onPressed: () => _alternarCategoria(categoriaId),
              ),
            ],
          ),
          const SizedBox(height: 4),
          SelectorSubcategorias(
            key: ValueKey('subcats-$categoriaId'),
            categorias: [categoria],
            subcategorias: subcatsDeEstaCategoria,
            seleccionadas: subcatsSeleccionadasIds,
            onCambio: (ids) =>
                _alSeleccionarSubcategoriasDeCategoria(categoriaId, ids),
          ),
          if (subcatsSeleccionadasObjetos.isNotEmpty) ...[
            const SizedBox(height: 8),
            SelectorActividades(
              key: ValueKey(
                  'act-$categoriaId-${subcatsSeleccionadasIds.join(',')}'),
              subcategorias: subcatsSeleccionadasObjetos,
              actividades: actividadesDeEstaCategoria,
              seleccionadas: actividadesSeleccionadasIds,
              onCambio: (ids) =>
                  _alSeleccionarActividadesDeCategoria(categoriaId, ids),
            ),
          ],
        ],
      ),
    );
  }

  Widget _promptSiguienteCategoria() {
    final restantes =
        widget.categorias.where((c) => !_categoriaIds.contains(c.id)).toList();
    if (restantes.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _categoriaIds.isEmpty
              ? 'Elige tu categoría oficial'
              : 'Elige tu ${_ordinales[_categoriaIds.length]} categoría '
                  'oficial (opcional)',
          style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: NVColors.textoSecundario),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final c in restantes)
              ChipFiltro(
                etiqueta: c.nombre,
                icono: c.iconoOTexto,
                variante: true,
                seleccionado: false,
                onTap: () => _alternarCategoria(c.id),
              ),
          ],
        ),
      ],
    );
  }
}
