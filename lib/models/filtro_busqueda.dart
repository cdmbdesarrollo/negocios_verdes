enum VistaResultados { lista, mapa }

/// Estado de filtros de BuscarPage, reflejado en la URL
/// (?q=&municipio=&categoria=&subcategoria=&actividad=&vista=) para que los
/// resultados sean compartibles y el back/forward del navegador funcione. Se
/// usan slugs para categoría/subcategoría/actividad (no ids) porque son los
/// que se ven bien en una URL — el service resuelve slug→id contra las
/// listas ya cargadas.
class FiltroBusqueda {
  final String query;
  final String? municipio;
  final String? categoriaSlug;
  final String? subcategoriaSlug;
  final String? actividadSlug;
  final VistaResultados vista;

  const FiltroBusqueda({
    this.query = '',
    this.municipio,
    this.categoriaSlug,
    this.subcategoriaSlug,
    this.actividadSlug,
    this.vista = VistaResultados.lista,
  });

  bool get tieneFiltrosActivos =>
      query.isNotEmpty ||
      municipio != null ||
      categoriaSlug != null ||
      subcategoriaSlug != null ||
      actividadSlug != null;

  FiltroBusqueda copyWith({
    String? query,
    String? municipio,
    bool limpiarMunicipio = false,
    String? categoriaSlug,
    bool limpiarCategoria = false,
    String? subcategoriaSlug,
    bool limpiarSubcategoria = false,
    String? actividadSlug,
    bool limpiarActividad = false,
    VistaResultados? vista,
  }) {
    return FiltroBusqueda(
      query: query ?? this.query,
      municipio: limpiarMunicipio ? null : (municipio ?? this.municipio),
      categoriaSlug:
          limpiarCategoria ? null : (categoriaSlug ?? this.categoriaSlug),
      subcategoriaSlug: limpiarSubcategoria
          ? null
          : (subcategoriaSlug ?? this.subcategoriaSlug),
      actividadSlug:
          limpiarActividad ? null : (actividadSlug ?? this.actividadSlug),
      vista: vista ?? this.vista,
    );
  }

  Map<String, String> toQueryParameters() {
    return {
      if (query.isNotEmpty) 'q': query,
      if (municipio != null) 'municipio': municipio!,
      if (categoriaSlug != null) 'categoria': categoriaSlug!,
      if (subcategoriaSlug != null) 'subcategoria': subcategoriaSlug!,
      if (actividadSlug != null) 'actividad': actividadSlug!,
      if (vista == VistaResultados.mapa) 'vista': 'mapa',
    };
  }

  factory FiltroBusqueda.fromQueryParameters(Map<String, String> params) {
    return FiltroBusqueda(
      query: params['q'] ?? '',
      municipio: params['municipio'],
      categoriaSlug: params['categoria'],
      subcategoriaSlug: params['subcategoria'],
      actividadSlug: params['actividad'],
      vista: params['vista'] == 'mapa'
          ? VistaResultados.mapa
          : VistaResultados.lista,
    );
  }
}
