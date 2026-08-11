/// "BannerSitio" y no "Banner" a secas para no chocar con el Banner de
/// Material (widget de aviso persistente que trae Flutter).
class BannerSitio {
  final String id;
  final String imagenUrl;
  final String imagenPath;
  final String? urlDestino;
  final bool abrirEnPestanaNueva;
  final int orden;
  final bool activo;

  const BannerSitio({
    required this.id,
    required this.imagenUrl,
    required this.imagenPath,
    this.urlDestino,
    this.abrirEnPestanaNueva = true,
    this.orden = 0,
    this.activo = true,
  });

  factory BannerSitio.fromJson(Map<String, dynamic> json) {
    return BannerSitio(
      id: json['id']?.toString() ?? '',
      imagenUrl: json['imagen_url']?.toString() ?? '',
      imagenPath: json['imagen_path']?.toString() ?? '',
      urlDestino: json['url_destino']?.toString(),
      abrirEnPestanaNueva: json['abrir_en_pestana_nueva'] as bool? ?? true,
      orden: (json['orden'] as num?)?.toInt() ?? 0,
      activo: json['activo'] as bool? ?? true,
    );
  }
}
