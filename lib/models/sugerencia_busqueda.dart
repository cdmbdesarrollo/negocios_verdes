/// Una fila del autocompletado del buscador — puede ser un negocio (por
/// nombre) o un nivel de la taxonomía/municipio (para aplicar como
/// filtro). [tipo] decide qué hace onSelected en FiltrosBar: para
/// [TipoSugerencia.negocio] navega directo a la ficha; para el resto,
/// aplica el filtro correspondiente (resolviendo los padres necesarios
/// para que los chips se vean marcados).
enum TipoSugerencia { negocio, municipio, categoria, subcategoria, actividad }

class SugerenciaBusqueda {
  final TipoSugerencia tipo;
  final String etiqueta;
  final String? icono;

  /// Slug (categoría/subcategoría/actividad/negocio) o el nombre exacto
  /// del municipio — lo que cada filtro/ruta necesita para aplicarse.
  final String valor;

  const SugerenciaBusqueda({
    required this.tipo,
    required this.etiqueta,
    required this.valor,
    this.icono,
  });

  String get etiquetaGrupo => switch (tipo) {
        TipoSugerencia.negocio => 'Negocios',
        TipoSugerencia.municipio => 'Municipio',
        TipoSugerencia.categoria => 'Categoría',
        TipoSugerencia.subcategoria => 'Subcategoría',
        TipoSugerencia.actividad => 'Actividad productiva',
      };
}
