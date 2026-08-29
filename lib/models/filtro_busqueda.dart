enum VistaResultados { lista, mapa }

/// Estado de filtros de BuscarPage, reflejado en la URL
/// (?q=&municipio=&categoria=&subcategoria=&actividad=&emprendimiento=&sello=&avalado=&vista=)
/// para que los resultados sean compartibles y el back/forward del
/// navegador funcione. Se usan slugs para categoría/subcategoría/actividad
/// (no ids) porque son los que se ven bien en una URL — el service resuelve
/// slug→id contra las listas ya cargadas. Los 3 reconocimientos no
/// necesitan esa resolución (son booleanos directos en la base) — se
/// aplican directo.
class FiltroBusqueda {
  final String query;
  final String? municipio;
  final String? categoriaSlug;
  final String? subcategoriaSlug;
  final String? actividadSlug;

  /// true = solo negocios con ese reconocimiento. null = sin filtrar por
  /// esto — no tiene sentido un "false" acá (nadie hace clic en una
  /// insignia para pedir justo lo contrario). Los 3 son independientes
  /// entre sí (ver 0022_ficha_ampliada_negocios.sql).
  final bool? emprendimientoVerde;
  final bool? selloMarca;
  final bool? avalado;
  final VistaResultados vista;

  const FiltroBusqueda({
    this.query = '',
    this.municipio,
    this.categoriaSlug,
    this.subcategoriaSlug,
    this.actividadSlug,
    this.emprendimientoVerde,
    this.selloMarca,
    this.avalado,
    this.vista = VistaResultados.lista,
  });

  bool get tieneFiltrosActivos =>
      query.isNotEmpty ||
      municipio != null ||
      categoriaSlug != null ||
      subcategoriaSlug != null ||
      actividadSlug != null ||
      emprendimientoVerde != null ||
      selloMarca != null ||
      avalado != null;

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
    bool? emprendimientoVerde,
    bool limpiarEmprendimientoVerde = false,
    bool? selloMarca,
    bool limpiarSelloMarca = false,
    bool? avalado,
    bool limpiarAvalado = false,
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
      emprendimientoVerde: limpiarEmprendimientoVerde
          ? null
          : (emprendimientoVerde ?? this.emprendimientoVerde),
      selloMarca: limpiarSelloMarca ? null : (selloMarca ?? this.selloMarca),
      avalado: limpiarAvalado ? null : (avalado ?? this.avalado),
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
      if (emprendimientoVerde == true) 'emprendimiento': '1',
      if (selloMarca == true) 'sello': '1',
      if (avalado == true) 'avalado': '1',
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
      emprendimientoVerde: params['emprendimiento'] == '1' ? true : null,
      selloMarca: params['sello'] == '1' ? true : null,
      avalado: params['avalado'] == '1' ? true : null,
      vista: params['vista'] == 'mapa'
          ? VistaResultados.mapa
          : VistaResultados.lista,
    );
  }
}
