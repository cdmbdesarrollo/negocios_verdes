enum VistaResultados { lista, mapa }

/// Estado de filtros de BuscarPage, reflejado en la URL
/// (?q=&municipio=&categoria=&subcategoria=&actividad=&nivel=&sello=&aval=&vista=)
/// para que los resultados sean compartibles y el back/forward del
/// navegador funcione. Se usan slugs para categoría/subcategoría/actividad
/// (no ids) porque son los que se ven bien en una URL — el service resuelve
/// slug→id contra las listas ya cargadas. nivel/sello/aval no necesitan esa
/// resolución (nivel ya es un string plano en la base, sello/aval son
/// booleanos) — se aplican directo.
class FiltroBusqueda {
  final String query;
  final String? municipio;
  final String? categoriaSlug;
  final String? subcategoriaSlug;
  final String? actividadSlug;

  /// 'en_verificacion' | 'verificado' | 'negocio_ancla' — mismo valor
  /// crudo que negocios.nivel_desarrollo, sin traducir.
  final String? nivelDesarrollo;

  /// true = solo negocios con ese reconocimiento. null = sin filtrar por
  /// esto — no tiene sentido un "false" acá (nadie hace clic en una
  /// insignia para pedir justo lo contrario).
  final bool? selloMarca;
  final bool? avalConfianza;
  final VistaResultados vista;

  const FiltroBusqueda({
    this.query = '',
    this.municipio,
    this.categoriaSlug,
    this.subcategoriaSlug,
    this.actividadSlug,
    this.nivelDesarrollo,
    this.selloMarca,
    this.avalConfianza,
    this.vista = VistaResultados.lista,
  });

  bool get tieneFiltrosActivos =>
      query.isNotEmpty ||
      municipio != null ||
      categoriaSlug != null ||
      subcategoriaSlug != null ||
      actividadSlug != null ||
      nivelDesarrollo != null ||
      selloMarca != null ||
      avalConfianza != null;

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
    String? nivelDesarrollo,
    bool limpiarNivelDesarrollo = false,
    bool? selloMarca,
    bool limpiarSelloMarca = false,
    bool? avalConfianza,
    bool limpiarAvalConfianza = false,
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
      nivelDesarrollo: limpiarNivelDesarrollo
          ? null
          : (nivelDesarrollo ?? this.nivelDesarrollo),
      selloMarca: limpiarSelloMarca ? null : (selloMarca ?? this.selloMarca),
      avalConfianza:
          limpiarAvalConfianza ? null : (avalConfianza ?? this.avalConfianza),
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
      if (nivelDesarrollo != null) 'nivel': nivelDesarrollo!,
      if (selloMarca == true) 'sello': '1',
      if (avalConfianza == true) 'aval': '1',
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
      nivelDesarrollo: params['nivel'],
      selloMarca: params['sello'] == '1' ? true : null,
      avalConfianza: params['aval'] == '1' ? true : null,
      vista: params['vista'] == 'mapa'
          ? VistaResultados.mapa
          : VistaResultados.lista,
    );
  }
}
