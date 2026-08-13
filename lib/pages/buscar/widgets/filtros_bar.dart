import 'package:flutter/material.dart';

import '../../../catalogos.dart';
import '../../../core/widgets/chip_filtro.dart';
import '../../../models/actividad_productiva.dart';
import '../../../models/categoria_oficial.dart';
import '../../../models/filtro_busqueda.dart';
import '../../../models/subcategoria.dart';
import '../../../theme/nv_colors.dart';

/// Solo los 4 niveles de chips (Municipio→Categoría→Subcategoría→
/// Actividad) — la caja de texto vive aparte en BarraBusquedaTexto desde
/// que este bloque pasó a poder ubicarse en una columna lateral angosta
/// en escritorio (ver BuscarPage): la caja de búsqueda necesita todo el
/// ancho de la página arriba, no el ancho angosto de la barra lateral.
class FiltrosBar extends StatelessWidget {
  final List<CategoriaOficial> categorias;
  final List<Subcategoria> subcategorias;
  final List<ActividadProductiva> actividades;
  final FiltroBusqueda filtro;
  final ValueChanged<FiltroBusqueda> onCambio;

  const FiltrosBar({
    super.key,
    required this.categorias,
    required this.subcategorias,
    required this.actividades,
    required this.filtro,
    required this.onCambio,
  });

  CategoriaOficial? _categoriaPorSlug(String? slug) {
    if (slug == null) return null;
    for (final c in categorias) {
      if (c.slug == slug) return c;
    }
    return null;
  }

  Subcategoria? _subcategoriaPorSlug(String? slug) {
    if (slug == null) return null;
    for (final s in subcategorias) {
      if (s.slug == slug) return s;
    }
    return null;
  }

  List<Subcategoria> get _subcategoriasDeCategoriaActual {
    final categoria = _categoriaPorSlug(filtro.categoriaSlug);
    if (categoria == null) return const [];
    return subcategorias
        .where((s) => s.categoriaOficialId == categoria.id)
        .toList();
  }

  List<ActividadProductiva> get _actividadesDeSubcategoriaActual {
    final subcategoria = _subcategoriaPorSlug(filtro.subcategoriaSlug);
    if (subcategoria == null) return const [];
    return actividades
        .where((a) => a.subcategoriaId == subcategoria.id)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final subcategoriasDisponibles = _subcategoriasDeCategoriaActual;
    final actividadesDisponibles = _actividadesDeSubcategoriaActual;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: NVColors.superficie,
        borderRadius: BorderRadius.circular(12),
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
          _etiquetaFiltro('Municipio'),
          const SizedBox(height: 6),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              ChipFiltro(
                etiqueta: 'Todos los municipios',
                seleccionado: filtro.municipio == null,
                onTap: () =>
                    onCambio(filtro.copyWith(limpiarMunicipio: true)),
              ),
              for (final m in kMunicipios)
                ChipFiltro(
                  etiqueta: m,
                  seleccionado: filtro.municipio == m,
                  onTap: () => onCambio(filtro.copyWith(municipio: m)),
                ),
            ],
          ),
          const SizedBox(height: 10),
          _etiquetaFiltro('Categoría'),
          const SizedBox(height: 6),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              ChipFiltro(
                etiqueta: 'Todas las categorías',
                seleccionado: filtro.categoriaSlug == null,
                onTap: () => onCambio(filtro.copyWith(
                  limpiarCategoria: true,
                  limpiarSubcategoria: true,
                  limpiarActividad: true,
                )),
              ),
              for (final c in categorias)
                ChipFiltro(
                  etiqueta: c.nombre,
                  icono: c.icono,
                  seleccionado: filtro.categoriaSlug == c.slug,
                  onTap: () => onCambio(filtro.copyWith(
                    categoriaSlug: c.slug,
                    limpiarSubcategoria: true,
                    limpiarActividad: true,
                  )),
                ),
            ],
          ),
          if (subcategoriasDisponibles.isNotEmpty) ...[
            const SizedBox(height: 10),
            _etiquetaFiltro('Subcategoría — dentro de la categoría elegida'),
            const SizedBox(height: 6),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ChipFiltro(
                  etiqueta: 'Todas',
                  variante: true,
                  seleccionado: filtro.subcategoriaSlug == null,
                  onTap: () => onCambio(filtro.copyWith(
                    limpiarSubcategoria: true,
                    limpiarActividad: true,
                  )),
                  anchoMinimo: 180,
                ),
                for (final s in subcategoriasDisponibles)
                  ChipFiltro(
                    etiqueta: s.nombre,
                    icono: s.icono,
                    variante: true,
                    seleccionado: filtro.subcategoriaSlug == s.slug,
                    onTap: () => onCambio(filtro.copyWith(
                      subcategoriaSlug: s.slug,
                      limpiarActividad: true,
                    )),
                    anchoMinimo: 180,
                  ),
              ],
            ),
          ],
          if (actividadesDisponibles.isNotEmpty) ...[
            const SizedBox(height: 10),
            _etiquetaFiltro(
                'Actividad productiva — dentro de la subcategoría elegida'),
            const SizedBox(height: 6),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ChipFiltro(
                  etiqueta: 'Todas',
                  variante: true,
                  seleccionado: filtro.actividadSlug == null,
                  onTap: () =>
                      onCambio(filtro.copyWith(limpiarActividad: true)),
                  anchoMinimo: 180,
                ),
                for (final a in actividadesDisponibles)
                  ChipFiltro(
                    etiqueta: a.nombre,
                    icono: a.icono,
                    variante: true,
                    seleccionado: filtro.actividadSlug == a.slug,
                    onTap: () =>
                        onCambio(filtro.copyWith(actividadSlug: a.slug)),
                    anchoMinimo: 180,
                  ),
              ],
            ),
          ],
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
