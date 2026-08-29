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
  final String? tipoDocumento;
  final String? telefono;
  final String? correo;
  final String? direccion;

  /// Solo responsables CDMB y delegados.
  final String? cargo;

  /// Solo representantes: 'Natural' o 'Jurídica'. Cuando es 'Jurídica' el
  /// nombre que se muestra es [razonSocial], no nombres+apellidos.
  final String? naturalezaJuridica;
  final String? razonSocial;

  /// Solo vienen poblados al leer desde las vistas `v_*` (ver 0030): a
  /// cuántos negocios está asignada esta persona en total y ahora mismo.
  final int? negociosTotal;
  final int? negociosVigentes;

  const Persona({
    required this.id,
    required this.nombres,
    this.apellidos,
    this.documento,
    this.tipoDocumento,
    this.telefono,
    this.correo,
    this.direccion,
    this.cargo,
    this.naturalezaJuridica,
    this.razonSocial,
    this.negociosTotal,
    this.negociosVigentes,
  });

  bool get esJuridica => (naturalezaJuridica ?? '').toLowerCase() == 'jurídica' ||
      (naturalezaJuridica ?? '').toLowerCase() == 'juridica';

  /// Nombre + apellidos en una sola línea.
  String get nombreCompleto {
    final ap = apellidos?.trim() ?? '';
    return ap.isEmpty ? nombres.trim() : '${nombres.trim()} $ap';
  }

  /// Lo que se muestra en listas y buscadores y lo que se copia a
  /// `negocios.representante_legal`: la razón social si es jurídica, si no
  /// el nombre completo.
  String get nombreMostrado {
    final rs = razonSocial?.trim() ?? '';
    if (rs.isNotEmpty) return rs;
    final nc = nombreCompleto;
    return nc.isEmpty ? '(sin nombre)' : nc;
  }

  /// "CC 12345678" / "NIT 900...-1" — tipo abreviado + número.
  String? get documentoMostrado {
    final n = documento?.trim() ?? '';
    if (n.isEmpty) return null;
    final abrev = switch ((tipoDocumento ?? '').toLowerCase()) {
      'cédula de ciudadanía' || 'cedula de ciudadania' => 'CC',
      'cédula de extranjería' || 'cedula de extranjeria' => 'CE',
      'nit' => 'NIT',
      'pasaporte' => 'PA',
      'tarjeta de identidad' => 'TI',
      _ => tipoDocumento?.trim().isNotEmpty == true ? tipoDocumento! : 'Doc.',
    };
    return '$abrev $n';
  }

  factory Persona.fromJson(Map<String, dynamic> json) => Persona(
        id: json['id']?.toString() ?? '',
        nombres: json['nombres']?.toString() ?? '',
        apellidos: json['apellidos']?.toString(),
        documento: json['documento']?.toString(),
        tipoDocumento: json['tipo_documento']?.toString(),
        telefono: json['telefono']?.toString(),
        correo: json['correo']?.toString(),
        direccion: json['direccion']?.toString(),
        cargo: json['cargo']?.toString(),
        naturalezaJuridica: json['naturaleza_juridica']?.toString(),
        razonSocial: json['razon_social']?.toString(),
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
    final razonSocial = persona['razon_social']?.toString() ?? '';
    final nombreCompleto =
        (apellidos.isEmpty ? nombres : '$nombres $apellidos').trim();
    return AsignacionPersona(
      personaNombre: razonSocial.isNotEmpty
          ? razonSocial
          : (nombreCompleto.isEmpty ? '(sin nombre)' : nombreCompleto),
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
