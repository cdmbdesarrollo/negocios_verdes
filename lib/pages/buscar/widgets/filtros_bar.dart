import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../catalogos.dart';
import '../../../core/widgets/autocompletado_busqueda.dart';
import '../../../core/widgets/chip_filtro.dart';
import '../../../models/actividad_productiva.dart';
import '../../../models/categoria_oficial.dart';
import '../../../models/filtro_busqueda.dart';
import '../../../models/subcategoria.dart';
import '../../../models/sugerencia_busqueda.dart';
import '../../../theme/nv_colors.dart';

class FiltrosBar extends StatefulWidget {
  final List<CategoriaOficial> categorias;
  final List<Subcategoria> subcategorias;
  final List<ActividadProductiva> actividades;

  /// Solo nombre+slug de cada negocio activo — para el autocompletado.
  /// Lista aparte de los resultados de la búsqueda actual (que cambian
  /// con cada filtro): esta es fija, se carga una sola vez.
  final List<(String nombre, String slug)> negocios;
  final FiltroBusqueda filtro;
  final ValueChanged<FiltroBusqueda> onCambio;

  const FiltrosBar({
    super.key,
    required this.categorias,
    required this.subcategorias,
    required this.actividades,
    required this.negocios,
    required this.filtro,
    required this.onCambio,
  });

  @override
  State<FiltrosBar> createState() => _FiltrosBarState();
}

class _FiltrosBarState extends State<FiltrosBar> {
  late final TextEditingController _busquedaCtrl;
  final _busquedaFocus = FocusNode();

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
    _busquedaFocus.dispose();
    super.dispose();
  }

  CategoriaOficial? _categoriaPorSlug(String? slug) {
    if (slug == null) return null;
    for (final c in widget.categorias) {
      if (c.slug == slug) return c;
    }
    return null;
  }

  Subcategoria? _subcategoriaPorSlug(String? slug) {
    if (slug == null) return null;
    for (final s in widget.subcategorias) {
      if (s.slug == slug) return s;
    }
    return null;
  }

  CategoriaOficial? _categoriaPorId(String id) {
    for (final c in widget.categorias) {
      if (c.id == id) return c;
    }
    return null;
  }

  Subcategoria? _subcategoriaPorId(String id) {
    for (final s in widget.subcategorias) {
      if (s.id == id) return s;
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

  List<ActividadProductiva> get _actividadesDeSubcategoriaActual {
    final subcategoria = _subcategoriaPorSlug(widget.filtro.subcategoriaSlug);
    if (subcategoria == null) return const [];
    return widget.actividades
        .where((a) => a.subcategoriaId == subcategoria.id)
        .toList();
  }

  /// Negocio: navega directo a la ficha (mismo criterio que un resultado
  /// de búsqueda cualquiera). Categoría/subcategoría/actividad: se
  /// resuelven los padres necesarios (subcategoría necesita su categoría,
  /// actividad necesita su subcategoría Y su categoría) para que los
  /// chips correspondientes queden marcados, no solo el filtro aplicado
  /// "a ciegas". Municipio: se aplica directo, no tiene padres.
  void _alSeleccionarSugerencia(SugerenciaBusqueda sugerencia) {
    _busquedaCtrl.clear();
    _busquedaFocus.unfocus();
    switch (sugerencia.tipo) {
      case TipoSugerencia.negocio:
        context.go('/negocio/${sugerencia.valor}');
      case TipoSugerencia.municipio:
        widget.onCambio(
            widget.filtro.copyWith(municipio: sugerencia.valor, query: ''));
      case TipoSugerencia.categoria:
        widget.onCambio(widget.filtro.copyWith(
          categoriaSlug: sugerencia.valor,
          limpiarSubcategoria: true,
          limpiarActividad: true,
          query: '',
        ));
      case TipoSugerencia.subcategoria:
        final sub = _subcategoriaPorSlug(sugerencia.valor);
        final categoriaPadre =
            sub == null ? null : _categoriaPorId(sub.categoriaOficialId);
        widget.onCambio(widget.filtro.copyWith(
          categoriaSlug: categoriaPadre?.slug ?? widget.filtro.categoriaSlug,
          subcategoriaSlug: sugerencia.valor,
          limpiarActividad: true,
          query: '',
        ));
      case TipoSugerencia.actividad:
        ActividadProductiva? actividad;
        for (final a in widget.actividades) {
          if (a.slug == sugerencia.valor) {
            actividad = a;
            break;
          }
        }
        final subPadre =
            actividad == null ? null : _subcategoriaPorId(actividad.subcategoriaId);
        final categoriaPadre =
            subPadre == null ? null : _categoriaPorId(subPadre.categoriaOficialId);
        widget.onCambio(widget.filtro.copyWith(
          categoriaSlug: categoriaPadre?.slug ?? widget.filtro.categoriaSlug,
          subcategoriaSlug: subPadre?.slug ?? widget.filtro.subcategoriaSlug,
          actividadSlug: sugerencia.valor,
          query: '',
        ));
    }
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
          RawAutocomplete<SugerenciaBusqueda>(
            textEditingController: _busquedaCtrl,
            focusNode: _busquedaFocus,
            optionsBuilder: (valor) => construirSugerenciasBusqueda(
              texto: valor.text,
              categorias: widget.categorias,
              subcategorias: widget.subcategorias,
              actividades: widget.actividades,
              negocios: widget.negocios,
            ),
            displayStringForOption: (s) => s.etiqueta,
            onSelected: _alSeleccionarSugerencia,
            fieldViewBuilder: (context, controller, focusNode, onSubmitted) {
              return TextField(
                controller: controller,
                focusNode: focusNode,
                style: const TextStyle(fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'Buscar negocios verdes (ej. ganadería sostenible, '
                      'turismo de naturaleza...)',
                  hintStyle: const TextStyle(fontSize: 13.5),
                  prefixIcon: const Icon(Icons.search, color: NVColors.primary),
                  suffixIcon: widget.filtro.query.isNotEmpty
                      ? IconButton(
                          tooltip: 'Borrar búsqueda',
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            controller.clear();
                            widget.onCambio(widget.filtro.copyWith(query: ''));
                          },
                        )
                      : null,
                  filled: true,
                  fillColor: NVColors.fondo,
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
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
                    borderSide:
                        const BorderSide(color: NVColors.primary, width: 1.5),
                  ),
                ),
                onChanged: (v) =>
                    widget.onCambio(widget.filtro.copyWith(query: v)),
              );
            },
            optionsViewBuilder: vistaOpcionesBusqueda,
          ),
          const SizedBox(height: 10),
          _etiquetaFiltro('Municipio'),
          const SizedBox(height: 6),
          Wrap(
            spacing: 6,
            runSpacing: 6,
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
          const SizedBox(height: 10),
          _etiquetaFiltro('Categoría'),
          const SizedBox(height: 6),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              ChipFiltro(
                etiqueta: 'Todas las categorías',
                seleccionado: widget.filtro.categoriaSlug == null,
                onTap: () => widget.onCambio(widget.filtro.copyWith(
                  limpiarCategoria: true,
                  limpiarSubcategoria: true,
                  limpiarActividad: true,
                )),
                anchoMinimo: 190,
              ),
              for (final c in widget.categorias)
                ChipFiltro(
                  etiqueta: c.nombre,
                  icono: c.icono,
                  seleccionado: widget.filtro.categoriaSlug == c.slug,
                  onTap: () => widget.onCambio(widget.filtro.copyWith(
                    categoriaSlug: c.slug,
                    limpiarSubcategoria: true,
                    limpiarActividad: true,
                  )),
                  anchoMinimo: 190,
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
                  seleccionado: widget.filtro.subcategoriaSlug == null,
                  onTap: () => widget.onCambio(widget.filtro.copyWith(
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
                    seleccionado: widget.filtro.subcategoriaSlug == s.slug,
                    onTap: () => widget.onCambio(widget.filtro.copyWith(
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
                  seleccionado: widget.filtro.actividadSlug == null,
                  onTap: () => widget.onCambio(
                      widget.filtro.copyWith(limpiarActividad: true)),
                  anchoMinimo: 180,
                ),
                for (final a in actividadesDisponibles)
                  ChipFiltro(
                    etiqueta: a.nombre,
                    icono: a.icono,
                    variante: true,
                    seleccionado: widget.filtro.actividadSlug == a.slug,
                    onTap: () => widget.onCambio(
                        widget.filtro.copyWith(actividadSlug: a.slug)),
                    anchoMinimo: 180,
                  ),
              ],
            ),
          ],
          const SizedBox(height: 10),
          _etiquetaFiltro('Reconocimiento'),
          const SizedBox(height: 6),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              ChipFiltro(
                etiqueta: 'Todos',
                seleccionado: widget.filtro.nivelDesarrollo == null,
                onTap: () => widget.onCambio(
                    widget.filtro.copyWith(limpiarNivelDesarrollo: true)),
              ),
              ChipFiltro(
                etiqueta: 'En verificación',
                seleccionado: widget.filtro.nivelDesarrollo == 'en_verificacion',
                onTap: () => widget.onCambio(widget.filtro
                    .copyWith(nivelDesarrollo: 'en_verificacion')),
              ),
              ChipFiltro(
                etiqueta: 'Verificado',
                seleccionado: widget.filtro.nivelDesarrollo == 'verificado',
                onTap: () => widget.onCambio(
                    widget.filtro.copyWith(nivelDesarrollo: 'verificado')),
              ),
              ChipFiltro(
                etiqueta: 'Negocio ancla',
                seleccionado: widget.filtro.nivelDesarrollo == 'negocio_ancla',
                onTap: () => widget.onCambio(
                    widget.filtro.copyWith(nivelDesarrollo: 'negocio_ancla')),
              ),
              // Sello Marca y Aval de Confianza son independientes entre sí
              // y de nivelDesarrollo (mismo criterio de siempre) — por eso
              // cada chip alterna su propio booleano en vez de ser parte
              // del mismo grupo "elegí uno" que los chips de arriba.
              ChipFiltro(
                etiqueta: '🎖️ Sello Marca',
                seleccionado: widget.filtro.selloMarca == true,
                onTap: () => widget.onCambio(widget.filtro.selloMarca == true
                    ? widget.filtro.copyWith(limpiarSelloMarca: true)
                    : widget.filtro.copyWith(selloMarca: true)),
              ),
              ChipFiltro(
                etiqueta: '🛡️ Aval de Confianza',
                seleccionado: widget.filtro.avalConfianza == true,
                onTap: () => widget.onCambio(widget.filtro.avalConfianza == true
                    ? widget.filtro.copyWith(limpiarAvalConfianza: true)
                    : widget.filtro.copyWith(avalConfianza: true)),
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
