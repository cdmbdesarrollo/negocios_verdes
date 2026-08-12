class ActividadProductiva {
  final String id;
  final String subcategoriaId;
  final String nombre;
  final String slug;
  final String? descripcion;
  final String? icono;
  final String? iconoUrl;
  final String? iconoPath;
  final int orden;
  final bool activo;

  const ActividadProductiva({
    required this.id,
    required this.subcategoriaId,
    required this.nombre,
    required this.slug,
    this.descripcion,
    this.icono,
    this.iconoUrl,
    this.iconoPath,
    this.orden = 0,
    this.activo = true,
  });

  factory ActividadProductiva.fromJson(Map<String, dynamic> json) {
    return ActividadProductiva(
      id: json['id']?.toString() ?? '',
      subcategoriaId: json['subcategoria_id']?.toString() ?? '',
      nombre: json['nombre']?.toString() ?? '',
      slug: json['slug']?.toString() ?? '',
      descripcion: json['descripcion']?.toString(),
      icono: json['icono']?.toString(),
      iconoUrl: json['icono_url']?.toString(),
      iconoPath: json['icono_path']?.toString(),
      orden: (json['orden'] as num?)?.toInt() ?? 0,
      activo: json['activo'] as bool? ?? true,
    );
  }

  String get iconoOTexto => icono?.trim().isNotEmpty == true ? icono! : '🔹';
}
