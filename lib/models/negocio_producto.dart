/// Uno de los hasta 3 productos destacados de un negocio (ver
/// 0040_negocio_productos.sql): nombre (0041) + foto + descripción corta,
/// solo vitrina.
class NegocioProducto {
  final String? nombre;
  final String? fotoUrl;
  final String? fotoStoragePath;
  final String? descripcion;
  final int orden;

  const NegocioProducto({
    this.nombre,
    this.fotoUrl,
    this.fotoStoragePath,
    this.descripcion,
    this.orden = 0,
  });

  bool get tieneNombre => nombre != null && nombre!.isNotEmpty;
  bool get tieneFoto => fotoUrl != null && fotoUrl!.isNotEmpty;
  bool get tieneDescripcion => descripcion != null && descripcion!.isNotEmpty;
  bool get estaVacio => !tieneNombre && !tieneFoto && !tieneDescripcion;

  factory NegocioProducto.fromJson(Map<String, dynamic> json) {
    return NegocioProducto(
      nombre: json['nombre']?.toString(),
      fotoUrl: json['foto_url']?.toString(),
      fotoStoragePath: json['foto_storage_path']?.toString(),
      descripcion: json['descripcion']?.toString(),
      orden: (json['orden'] as num?)?.toInt() ?? 0,
    );
  }
}
