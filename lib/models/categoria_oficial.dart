class CategoriaOficial {
  final String id;
  final String nombre;
  final String slug;
  final String? descripcion;
  final String? icono;
  final String? iconoUrl;
  final String? iconoPath;
  final String? categoriaNacional;
  final int orden;
  final bool activo;

  const CategoriaOficial({
    required this.id,
    required this.nombre,
    required this.slug,
    this.descripcion,
    this.icono,
    this.iconoUrl,
    this.iconoPath,
    this.categoriaNacional,
    this.orden = 0,
    this.activo = true,
  });

  factory CategoriaOficial.fromJson(Map<String, dynamic> json) {
    return CategoriaOficial(
      id: json['id']?.toString() ?? '',
      nombre: json['nombre']?.toString() ?? '',
      slug: json['slug']?.toString() ?? '',
      descripcion: json['descripcion']?.toString(),
      icono: json['icono']?.toString(),
      iconoUrl: json['icono_url']?.toString(),
      iconoPath: json['icono_path']?.toString(),
      categoriaNacional: json['categoria_nacional']?.toString(),
      orden: (json['orden'] as num?)?.toInt() ?? 0,
      activo: json['activo'] as bool? ?? true,
    );
  }

  String get iconoOTexto => icono?.trim().isNotEmpty == true ? icono! : '🌱';
}
