enum VistaResultados { lista, mapa }

/// Estado de filtros de BuscarPage, reflejado en la URL
/// (?q=&categoria=&subcategoria=&municipio=&vista=) para que los resultados
/// sean compartibles y el back/forward del navegador funcione. Se usan slugs
/// para categoría/subcategoría (no ids) porque son los que se ven bien en
/// una URL — el service resuelve slug→id contra las listas ya cargadas.
class FiltroBusqueda {
  final String query;
  final String? categoriaSlug;
  final String? subcategoriaSlug;
  final String? municipio;
  final VistaResultados vista;

  const FiltroBusqueda({
    this.query = '',
    this.categoriaSlug,
    this.subcategoriaSlug,
    this.municipio,
    this.vista = VistaResultados.lista,
  });

  bool get tieneFiltrosActivos =>
      query.isNotEmpty ||
      categoriaSlug != null ||
      subcategoriaSlug != null ||
      municipio != null;

  FiltroBusqueda copyWith({
    String? query,
    String? categoriaSlug,
    bool limpiarCategoria = false,
    String? subcategoriaSlug,
    bool limpiarSubcategoria = false,
    String? municipio,
    bool limpiarMunicipio = false,
    VistaResultados? vista,
  }) {
    return FiltroBusqueda(
      query: query ?? this.query,
      categoriaSlug:
          limpiarCategoria ? null : (categoriaSlug ?? this.categoriaSlug),
      subcategoriaSlug: limpiarSubcategoria
          ? null
          : (subcategoriaSlug ?? this.subcategoriaSlug),
      municipio: limpiarMunicipio ? null : (municipio ?? this.municipio),
      vista: vista ?? this.vista,
    );
  }

  Map<String, String> toQueryParameters() {
    return {
      if (query.isNotEmpty) 'q': query,
      if (categoriaSlug != null) 'categoria': categoriaSlug!,
      if (subcategoriaSlug != null) 'subcategoria': subcategoriaSlug!,
      if (municipio != null) 'municipio': municipio!,
      if (vista == VistaResultados.mapa) 'vista': 'mapa',
    };
  }

  factory FiltroBusqueda.fromQueryParameters(Map<String, String> params) {
    return FiltroBusqueda(
      query: params['q'] ?? '',
      categoriaSlug: params['categoria'],
      subcategoriaSlug: params['subcategoria'],
      municipio: params['municipio'],
      vista: params['vista'] == 'mapa'
          ? VistaResultados.mapa
          : VistaResultados.lista,
    );
  }
}
