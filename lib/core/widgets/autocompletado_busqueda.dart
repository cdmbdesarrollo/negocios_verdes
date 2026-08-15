import 'package:flutter/material.dart';

import '../../catalogos.dart';
import '../../models/actividad_productiva.dart';
import '../../models/categoria_oficial.dart';
import '../../models/subcategoria.dart';
import '../../models/sugerencia_busqueda.dart';
import '../../theme/nv_colors.dart';
import '../texto_utils.dart';

/// Sugerencias de autocompletado — compartidas entre la caja de búsqueda
/// del inicio y la de /buscar, para no mantener la misma lógica de
/// filtrado en dos lados. Negocios primero (lo más probable que alguien
/// esté buscando por nombre exacto, ej. "bucarr" → Bucarretes), después
/// municipio/categoría/subcategoría/actividad. Tope de 8 para que el
/// dropdown no se vuelva una pared de opciones.
List<SugerenciaBusqueda> construirSugerenciasBusqueda({
  required String texto,
  required List<CategoriaOficial> categorias,
  required List<Subcategoria> subcategorias,
  required List<ActividadProductiva> actividades,
  required List<(String nombre, String slug)> negocios,
}) {
  final query = texto.trim();
  if (query.isEmpty) return const [];
  final normalizado = quitarTildes(query.toLowerCase());
  bool contiene(String s) => quitarTildes(s.toLowerCase()).contains(normalizado);

  final resultados = <SugerenciaBusqueda>[];
  for (final (nombre, slug) in negocios) {
    if (contiene(nombre)) {
      resultados.add(SugerenciaBusqueda(
          tipo: TipoSugerencia.negocio, etiqueta: nombre, valor: slug));
    }
  }
  for (final m in kMunicipios) {
    if (contiene(m)) {
      resultados.add(
          SugerenciaBusqueda(tipo: TipoSugerencia.municipio, etiqueta: m, valor: m));
    }
  }
  for (final c in categorias) {
    if (contiene(c.nombre)) {
      resultados.add(SugerenciaBusqueda(
          tipo: TipoSugerencia.categoria,
          etiqueta: c.nombre,
          valor: c.slug,
          icono: c.icono));
    }
  }
  for (final s in subcategorias) {
    if (contiene(s.nombre)) {
      resultados.add(SugerenciaBusqueda(
          tipo: TipoSugerencia.subcategoria,
          etiqueta: s.nombre,
          valor: s.slug,
          icono: s.icono));
    }
  }
  for (final a in actividades) {
    if (contiene(a.nombre)) {
      resultados.add(SugerenciaBusqueda(
          tipo: TipoSugerencia.actividad,
          etiqueta: a.nombre,
          valor: a.slug,
          icono: a.icono));
    }
  }
  return resultados.take(8).toList();
}

/// Dropdown de sugerencias agrupadas por tipo — mismo look en cualquier
/// caja de búsqueda que lo use.
Widget vistaOpcionesBusqueda(
  BuildContext context,
  AutocompleteOnSelected<SugerenciaBusqueda> onSelected,
  Iterable<SugerenciaBusqueda> opciones,
) {
  final lista = opciones.toList();
  return Align(
    alignment: Alignment.topLeft,
    child: Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(12),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 320, minWidth: 280),
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 6),
          shrinkWrap: true,
          itemCount: lista.length,
          itemBuilder: (context, i) {
            final sugerencia = lista[i];
            final esNuevoGrupo = i == 0 || lista[i - 1].tipo != sugerencia.tipo;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (esNuevoGrupo)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(14, 8, 14, 4),
                    child: Text(
                      sugerencia.etiquetaGrupo.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.4,
                        color: NVColors.textoSecundario,
                      ),
                    ),
                  ),
                InkWell(
                  onTap: () => onSelected(sugerencia),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    child: Row(
                      children: [
                        if (sugerencia.icono != null) ...[
                          Text(sugerencia.icono!,
                              style: const TextStyle(fontSize: 15)),
                          const SizedBox(width: 8),
                        ] else if (sugerencia.tipo ==
                            TipoSugerencia.negocio) ...[
                          const Icon(Icons.storefront_outlined,
                              size: 16, color: NVColors.verdeVivo),
                          const SizedBox(width: 8),
                        ] else if (sugerencia.tipo ==
                            TipoSugerencia.municipio) ...[
                          const Icon(Icons.place_outlined,
                              size: 16, color: NVColors.verdeVivo),
                          const SizedBox(width: 8),
                        ],
                        Expanded(
                          child: Text(
                            sugerencia.etiqueta,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 13.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    ),
  );
}
