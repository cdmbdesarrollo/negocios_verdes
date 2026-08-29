/// Catálogo editable de veredas (ver 0021_veredas.sql) — a diferencia de
/// los 13 municipios, fijos en lib/catalogos.dart, las veredas se crean
/// desde /admin/veredas a medida que CDMB las necesita.
class Vereda {
  final String id;
  final String municipio;
  final String nombre;
  final String slug;
  final bool activo;

  const Vereda({
    required this.id,
    required this.municipio,
    required this.nombre,
    required this.slug,
    this.activo = true,
  });

  factory Vereda.fromJson(Map<String, dynamic> json) {
    return Vereda(
      id: json['id']?.toString() ?? '',
      municipio: json['municipio']?.toString() ?? '',
      nombre: json['nombre']?.toString() ?? '',
      slug: json['slug']?.toString() ?? '',
      activo: json['activo'] as bool? ?? true,
    );
  }
}
