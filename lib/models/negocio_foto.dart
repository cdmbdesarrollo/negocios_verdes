class NegocioFoto {
  final String id;
  final String negocioId;
  final String url;
  final String storagePath;
  final int orden;

  const NegocioFoto({
    required this.id,
    required this.negocioId,
    required this.url,
    required this.storagePath,
    this.orden = 0,
  });

  factory NegocioFoto.fromJson(Map<String, dynamic> json) {
    return NegocioFoto(
      id: json['id']?.toString() ?? '',
      negocioId: json['negocio_id']?.toString() ?? '',
      url: json['url']?.toString() ?? '',
      storagePath: json['storage_path']?.toString() ?? '',
      orden: (json['orden'] as num?)?.toInt() ?? 0,
    );
  }
}
