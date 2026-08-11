class Perfil {
  final String id;
  final String email;
  final bool isAdmin;

  const Perfil({required this.id, required this.email, this.isAdmin = false});

  factory Perfil.fromJson(Map<String, dynamic> json) {
    return Perfil(
      id: json['id']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      isAdmin: json['is_admin'] as bool? ?? false,
    );
  }
}
