import 'package:flutter/material.dart';

import '../../../catalogos.dart';
import '../../../core/widgets/chip_filtro.dart';
import '../../../models/categoria_oficial.dart';
import '../../../models/filtro_busqueda.dart';
import '../../../models/subcategoria.dart';
import '../../../theme/nv_colors.dart';

class FiltrosBar extends StatefulWidget {
  final List<CategoriaOficial> categorias;
  final List<Subcategoria> subcategorias;
  final FiltroBusqueda filtro;
  final ValueChanged<FiltroBusqueda> onCambio;

  const FiltrosBar({
    super.key,
    required this.categorias,
    required this.subcategorias,
    required this.filtro,
    required this.onCambio,
  });

  @override
  State<FiltrosBar> createState() => _FiltrosBarState();
}

class _FiltrosBarState extends State<FiltrosBar> {
  late final TextEditingController _busquedaCtrl;

  @override
  void initState() {
    super.initState();
    _busquedaCtrl = TextEditingController(text: widget.filtro.query);
  }

  @override
  void didUpdateWidget(covariant FiltrosBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Solo sincroniza si el cambio vino de afuera (ej. se limpió desde otro
    // lado) — si viniera de este mismo TextField perdería el cursor.
    if (widget.filtro.query != _busquedaCtrl.text &&
        widget.filtro.query != oldWidget.filtro.query) {
      _busquedaCtrl.text = widget.filtro.query;
    }
  }

  @override
  void dispose() {
    _busquedaCtrl.dispose();
    super.dispose();
  }

  CategoriaOficial? _categoriaPorSlug(String? slug) {
    if (slug == null) return null;
    for (final c in widget.categorias) {
      if (c.slug == slug) return c;
    }
    return null;
  }

  List<Subcategoria> get _subcategoriasDeCategoriaActual {
    final categoria = _categoriaPorSlug(widget.filtro.categoriaSlug);
    if (categoria == null) return const [];
    return widget.subcategorias
        .where((s) => s.categoriaOficialId == categoria.id)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final subcategoriasDisponibles = _subcategoriasDeCategoriaActual;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: NVColors.superficie,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _busquedaCtrl,
            style: const TextStyle(fontSize: 14),
            decoration: InputDecoration(
              hintText:
                  'Buscar negocios verdes (ej. apicultura, ecoturismo...)',
              hintStyle: const TextStyle(fontSize: 13.5),
              prefixIcon: const Icon(Icons.search, color: NVColors.primary),
              suffixIcon: widget.filtro.query.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        _busquedaCtrl.clear();
                        widget.onCambio(widget.filtro.copyWith(query: ''));
                      },
                    )
                  : null,
              filled: true,
              fillColor: NVColors.fondo,
              contentPadding: const EdgeInsets.symmetric(vertical: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(26),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(26),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(26),
                borderSide: const BorderSide(color: NVColors.primary, width: 1.5),
              ),
            ),
            onChanged: (v) => widget.onCambio(widget.filtro.copyWith(query: v)),
          ),
          const SizedBox(height: 18),
          _etiquetaFiltro('Categoría'),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ChipFiltro(
                etiqueta: 'Todas las categorías',
                seleccionado: widget.filtro.categoriaSlug == null,
                onTap: () => widget.onCambio(widget.filtro.copyWith(
                  limpiarCategoria: true,
                  limpiarSubcategoria: true,
                )),
              ),
              for (final c in widget.categorias)
                ChipFiltro(
                  etiqueta: c.nombre,
                  icono: c.icono,
                  seleccionado: widget.filtro.categoriaSlug == c.slug,
                  onTap: () => widget.onCambio(widget.filtro.copyWith(
                    categoriaSlug: c.slug,
                    limpiarSubcategoria: true,
                  )),
                ),
            ],
          ),
          if (subcategoriasDisponibles.isNotEmpty) ...[
            const SizedBox(height: 18),
            _etiquetaFiltro('Subcategoría — dentro de la categoría elegida'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ChipFiltro(
                  etiqueta: 'Todas',
                  variante: true,
                  seleccionado: widget.filtro.subcategoriaSlug == null,
                  onTap: () => widget.onCambio(
                      widget.filtro.copyWith(limpiarSubcategoria: true)),
                ),
                for (final s in subcategoriasDisponibles)
                  ChipFiltro(
                    etiqueta: s.nombre,
                    icono: s.icono,
                    variante: true,
                    seleccionado: widget.filtro.subcategoriaSlug == s.slug,
                    onTap: () => widget.onCambio(
                        widget.filtro.copyWith(subcategoriaSlug: s.slug)),
                  ),
              ],
            ),
          ],
          const SizedBox(height: 18),
          _etiquetaFiltro('Municipio'),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ChipFiltro(
                etiqueta: 'Todos los municipios',
                seleccionado: widget.filtro.municipio == null,
                onTap: () => widget.onCambio(
                    widget.filtro.copyWith(limpiarMunicipio: true)),
              ),
              for (final m in kMunicipios)
                ChipFiltro(
                  etiqueta: m,
                  seleccionado: widget.filtro.municipio == m,
                  onTap: () =>
                      widget.onCambio(widget.filtro.copyWith(municipio: m)),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _etiquetaFiltro(String texto) {
    return Text(
      texto.toUpperCase(),
      style: const TextStyle(
        color: NVColors.textoSecundario,
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.4,
      ),
    );
  }
}
