class Subcategoria {
  final String id;
  final String categoriaOficialId;
  final String nombre;
  final String slug;
  final String? icono;
  final String? iconoUrl;
  final String? iconoPath;
  final int orden;
  final bool activo;

  const Subcategoria({
    required this.id,
    required this.categoriaOficialId,
    required this.nombre,
    required this.slug,
    this.icono,
    this.iconoUrl,
    this.iconoPath,
    this.orden = 0,
    this.activo = true,
  });

  factory Subcategoria.fromJson(Map<String, dynamic> json) {
    return Subcategoria(
      id: json['id']?.toString() ?? '',
      categoriaOficialId: json['categoria_oficial_id']?.toString() ?? '',
      nombre: json['nombre']?.toString() ?? '',
      slug: json['slug']?.toString() ?? '',
      icono: json['icono']?.toString(),
      iconoUrl: json['icono_url']?.toString(),
      iconoPath: json['icono_path']?.toString(),
      orden: (json['orden'] as num?)?.toInt() ?? 0,
      activo: json['activo'] as bool? ?? true,
    );
  }

  String get iconoOTexto => icono?.trim().isNotEmpty == true ? icono! : '🏷️';
}
