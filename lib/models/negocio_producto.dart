/// Uno de los hasta 3 productos destacados de un negocio (ver
/// 0040_negocio_productos.sql): foto + descripción corta, solo vitrina.
class NegocioProducto {
  final String? fotoUrl;
  final String? fotoStoragePath;
  final String? descripcion;
  final int orden;

  const NegocioProducto({
    this.fotoUrl,
    this.fotoStoragePath,
    this.descripcion,
    this.orden = 0,
  });

  bool get tieneFoto => fotoUrl != null && fotoUrl!.isNotEmpty;
  bool get tieneDescripcion => descripcion != null && descripcion!.isNotEmpty;
  bool get estaVacio => !tieneFoto && !tieneDescripcion;

  factory NegocioProducto.fromJson(Map<String, dynamic> json) {
    return NegocioProducto(
      fotoUrl: json['foto_url']?.toString(),
      fotoStoragePath: json['foto_storage_path']?.toString(),
      descripcion: json['descripcion']?.toString(),
      orden: (json['orden'] as num?)?.toInt() ?? 0,
    );
  }
}
