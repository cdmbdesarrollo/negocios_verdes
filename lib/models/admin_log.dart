class AdminLog {
  final String id;
  final String? adminId;
  final String? adminEmail;
  final String accion;
  final String? entidad;
  final String? entidadId;
  final Map<String, dynamic>? detalle;
  final DateTime? createdAt;

  const AdminLog({
    required this.id,
    this.adminId,
    this.adminEmail,
    required this.accion,
    this.entidad,
    this.entidadId,
    this.detalle,
    this.createdAt,
  });

  factory AdminLog.fromJson(Map<String, dynamic> json) {
    return AdminLog(
      id: json['id']?.toString() ?? '',
      adminId: json['admin_id']?.toString(),
      adminEmail: json['admin_email']?.toString(),
      accion: json['accion']?.toString() ?? '',
      entidad: json['entidad']?.toString(),
      entidadId: json['entidad_id']?.toString(),
      detalle: json['detalle'] is Map
          ? Map<String, dynamic>.from(json['detalle'] as Map)
          : null,
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? ''),
    );
  }
}
