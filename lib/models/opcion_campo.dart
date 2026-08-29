/// Una opción del catálogo genérico de valores por campo (ver
/// 0025_ficha_tecnica_catalogos.sql) — reemplaza el texto libre en los
/// campos categóricos de la ficha técnica (Sí/No/Pendiente/No aplica y
/// similares) para que un admin siempre elija de una lista existente en
/// vez de escribir un valor ligeramente distinto cada vez. La misma tabla
/// sirve también para campos de nombre de persona (responsable_cdmb,
/// delegado): mismo problema (evitar errores de tipeo), misma solución.
class OpcionCampo {
  final String id;
  final String campo;
  final String valor;
  final int orden;

  const OpcionCampo({
    required this.id,
    required this.campo,
    required this.valor,
    this.orden = 0,
  });

  factory OpcionCampo.fromJson(Map<String, dynamic> json) {
    return OpcionCampo(
      id: json['id']?.toString() ?? '',
      campo: json['campo']?.toString() ?? '',
      valor: json['valor']?.toString() ?? '',
      orden: (json['orden'] as num?)?.toInt() ?? 0,
    );
  }
}
