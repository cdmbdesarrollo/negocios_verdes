/// Una persona de alguna de las tres bases del proyecto (ver
/// 0029_personas_responsable_delegado_representante.sql):
///   - responsables_cdmb : personal de CDMB que hace el seguimiento
///   - delegados         : delegado que el negocio pone como contacto
///   - representantes     : representante legal
/// Las tres tienen exactamente la misma forma, así que un solo modelo las
/// cubre; [TipoPersona] dice contra qué tabla/RPC trabajar.
enum TipoPersona { responsable, delegado, representante }

extension TipoPersonaX on TipoPersona {
  String get etiqueta => switch (this) {
        TipoPersona.responsable => 'Responsable CDMB',
        TipoPersona.delegado => 'Delegado',
        TipoPersona.representante => 'Representante legal',
      };

  String get tabla => switch (this) {
        TipoPersona.responsable => 'responsables_cdmb',
        TipoPersona.delegado => 'delegados',
        TipoPersona.representante => 'representantes',
      };
}

class Persona {
  final String id;
  final String nombres;
  final String? apellidos;
  final String? documento;
  final String? telefono;
  final String? correo;

  /// Solo vienen poblados al leer desde las vistas `v_*` (ver 0030): a
  /// cuántos negocios está asignada esta persona en total y ahora mismo.
  final int? negociosTotal;
  final int? negociosVigentes;

  const Persona({
    required this.id,
    required this.nombres,
    this.apellidos,
    this.documento,
    this.telefono,
    this.correo,
    this.negociosTotal,
    this.negociosVigentes,
  });

  /// Nombre + apellidos en una sola línea — es lo que se guarda como copia
  /// denormalizada en `negocios` y lo que se muestra en el buscador.
  String get nombreCompleto {
    final ap = apellidos?.trim() ?? '';
    return ap.isEmpty ? nombres.trim() : '${nombres.trim()} $ap';
  }

  factory Persona.fromJson(Map<String, dynamic> json) => Persona(
        id: json['id']?.toString() ?? '',
        nombres: json['nombres']?.toString() ?? '',
        apellidos: json['apellidos']?.toString(),
        documento: json['documento']?.toString(),
        telefono: json['telefono']?.toString(),
        correo: json['correo']?.toString(),
        negociosTotal: (json['negocios_total'] as num?)?.toInt(),
        negociosVigentes: (json['negocios_vigentes'] as num?)?.toInt(),
      );
}

/// Una fila del historial de asignación de un responsable/delegado/
/// representante a un negocio (tablas negocio_responsable / negocio_delegado
/// / negocio_representante). [vigenteHasta] nulo = asignación actual.
class AsignacionPersona {
  final String personaNombre;
  final String? documento;
  final DateTime? vigenteDesde;
  final DateTime? vigenteHasta;
  final String? nota;
  final String? nit; // solo representante
  final String? naturalezaJuridica; // solo representante

  const AsignacionPersona({
    required this.personaNombre,
    this.documento,
    this.vigenteDesde,
    this.vigenteHasta,
    this.nota,
    this.nit,
    this.naturalezaJuridica,
  });

  bool get vigente => vigenteHasta == null;

  factory AsignacionPersona.fromJson(
      Map<String, dynamic> json, String claveEmbed) {
    final embed = json[claveEmbed];
    final persona = embed is Map
        ? Map<String, dynamic>.from(embed)
        : (embed is List && embed.isNotEmpty && embed.first is Map
            ? Map<String, dynamic>.from(embed.first as Map)
            : <String, dynamic>{});
    final nombres = persona['nombres']?.toString() ?? '';
    final apellidos = persona['apellidos']?.toString() ?? '';
    return AsignacionPersona(
      personaNombre:
          (apellidos.isEmpty ? nombres : '$nombres $apellidos').trim(),
      documento: persona['documento']?.toString(),
      vigenteDesde: DateTime.tryParse(json['vigente_desde']?.toString() ?? ''),
      vigenteHasta: DateTime.tryParse(json['vigente_hasta']?.toString() ?? ''),
      nota: json['nota']?.toString(),
      nit: json['nit']?.toString(),
      naturalezaJuridica: json['naturaleza_juridica']?.toString(),
    );
  }
}

/// Asignaciones vigentes de un negocio — para precargar el formulario.
class AsignacionesActuales {
  final String? responsableId;
  final String? delegadoId;
  final String? representanteId;
  final String? nit;
  final String? naturalezaJuridica;

  const AsignacionesActuales({
    this.responsableId,
    this.delegadoId,
    this.representanteId,
    this.nit,
    this.naturalezaJuridica,
  });
}
