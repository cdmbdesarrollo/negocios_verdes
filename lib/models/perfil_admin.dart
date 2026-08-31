/// Una cuenta administradora de CDMB (fila de `perfiles`). Ver 0039.
class PerfilAdmin {
  final String id;
  final String email;
  final String? nombre;
  final bool esAdmin;
  final bool esSuperAdmin;
  final bool activo;
  final DateTime? creadoEn;

  const PerfilAdmin({
    required this.id,
    required this.email,
    this.nombre,
    required this.esAdmin,
    required this.esSuperAdmin,
    required this.activo,
    this.creadoEn,
  });

  factory PerfilAdmin.fromMap(Map<String, dynamic> m) => PerfilAdmin(
        id: m['id'] as String,
        email: m['email'] as String? ?? '',
        nombre: (m['nombre'] as String?)?.trim().isEmpty ?? true
            ? null
            : (m['nombre'] as String).trim(),
        esAdmin: m['is_admin'] as bool? ?? false,
        esSuperAdmin: m['es_super_admin'] as bool? ?? false,
        activo: m['activo'] as bool? ?? true,
        creadoEn: m['created_at'] != null
            ? DateTime.tryParse(m['created_at'] as String)
            : null,
      );

  String get nivel => esSuperAdmin ? 'Súper administrador' : 'Administrador';
}
