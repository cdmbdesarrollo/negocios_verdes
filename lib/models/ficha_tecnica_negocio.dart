/// Los ~40 campos de seguimiento interno de CDMB (permisos, DOFA,
/// fortalecimiento, puntajes) — ver 0022_ficha_ampliada_negocios.sql.
/// Deliberadamente FUERA de [Negocio]: son admin-only, se cargan solo en
/// el formulario de edición (NegocioService.obtenerFichaTecnica), nunca en
/// el buscador público ni en las tarjetas — así el modelo que sí viaja por
/// todo el sitio público no carga con 40 campos que nunca usa.
class FichaTecnicaNegocio {
  final String negocioId;
  final String? tiempoConstitucion;
  final String? rutCamaraComercio;
  final String? responsableCdmb;
  final String? delegado;
  final String? registroNacionalTurismo;
  final String? usoSuelo;
  final String? concesionAguas;
  final DateTime? concesionAguasVencimiento;
  final String? vertimientos;
  final DateTime? vertimientosVencimiento;
  final String? pueaa;
  final String? pgris;
  final String? pozoSeptico;
  final String? alcantarillado;
  final String? ica;
  final DateTime? icaVencimiento;
  final String? invima;
  final DateTime? invimaVencimiento;
  final String? certificadoTenenciaAnimales;
  final String? buenasPracticasAgricolas;
  final String? buenasPracticasApicolas;
  final String? registroApicola;
  final String? intervencionCauce;
  final String? capacidadCarga;
  final String? sstt;
  final String? canalVenta;
  final String? exportacion;
  final String? huellaCarbono;
  final String? fortalecimientoTecnico;
  final String? fortalecimientoAcademico;
  final String? fortalecimientoFinanciero;
  final String? internacionalizacion;
  final String? certificaciones;
  final String? posicionamientoMarca;
  final String? beneficiosVentanilla;
  final String? fortalezasAmbiental;
  final String? fortalezasSocial;
  final String? fortalezasEconomico;
  final String? debilidadesAmbiental;
  final String? debilidadesSocial;
  final String? debilidadesFinanciera;
  final String? novedad;
  final String? tipoNegocioVerde;
  final String? codigoMarca;
  final int? anioRegistro;
  final String? cotaMsnm;
  final String? aplicacionFicha2025;
  final String? observaciones;
  /// Coordenadas tal cual las escribe CDMB (Este/Norte, no necesariamente
  /// decimal ni un formato único) — [latitud]/[longitud] del propio
  /// [Negocio] siguen siendo las que de verdad usa el mapa; estas son la
  /// fuente admin-only de referencia/edición (ver 0024_este_norte_ubicacion.sql).
  final String? este;
  final String? norte;
  final Map<int, double> puntajes;

  const FichaTecnicaNegocio({
    required this.negocioId,
    this.tiempoConstitucion,
    this.rutCamaraComercio,
    this.responsableCdmb,
    this.delegado,
    this.registroNacionalTurismo,
    this.usoSuelo,
    this.concesionAguas,
    this.concesionAguasVencimiento,
    this.vertimientos,
    this.vertimientosVencimiento,
    this.pueaa,
    this.pgris,
    this.pozoSeptico,
    this.alcantarillado,
    this.ica,
    this.icaVencimiento,
    this.invima,
    this.invimaVencimiento,
    this.certificadoTenenciaAnimales,
    this.buenasPracticasAgricolas,
    this.buenasPracticasApicolas,
    this.registroApicola,
    this.intervencionCauce,
    this.capacidadCarga,
    this.sstt,
    this.canalVenta,
    this.exportacion,
    this.huellaCarbono,
    this.fortalecimientoTecnico,
    this.fortalecimientoAcademico,
    this.fortalecimientoFinanciero,
    this.internacionalizacion,
    this.certificaciones,
    this.posicionamientoMarca,
    this.beneficiosVentanilla,
    this.fortalezasAmbiental,
    this.fortalezasSocial,
    this.fortalezasEconomico,
    this.debilidadesAmbiental,
    this.debilidadesSocial,
    this.debilidadesFinanciera,
    this.novedad,
    this.tipoNegocioVerde,
    this.codigoMarca,
    this.anioRegistro,
    this.cotaMsnm,
    this.aplicacionFicha2025,
    this.observaciones,
    this.este,
    this.norte,
    this.puntajes = const {},
  });

  factory FichaTecnicaNegocio.fromJson(
      Map<String, dynamic> json, List<Map<String, dynamic>> puntajesJson) {
    DateTime? fecha(String campo) =>
        DateTime.tryParse(json[campo]?.toString() ?? '');
    return FichaTecnicaNegocio(
      negocioId: json['id']?.toString() ?? '',
      tiempoConstitucion: json['tiempo_constitucion']?.toString(),
      rutCamaraComercio: json['rut_camara_comercio']?.toString(),
      responsableCdmb: json['responsable_cdmb']?.toString(),
      delegado: json['delegado']?.toString(),
      registroNacionalTurismo: json['registro_nacional_turismo']?.toString(),
      usoSuelo: json['uso_suelo']?.toString(),
      concesionAguas: json['concesion_aguas']?.toString(),
      concesionAguasVencimiento: fecha('concesion_aguas_vencimiento'),
      vertimientos: json['vertimientos']?.toString(),
      vertimientosVencimiento: fecha('vertimientos_vencimiento'),
      pueaa: json['pueaa']?.toString(),
      pgris: json['pgris']?.toString(),
      pozoSeptico: json['pozo_septico']?.toString(),
      alcantarillado: json['alcantarillado']?.toString(),
      ica: json['ica']?.toString(),
      icaVencimiento: fecha('ica_vencimiento'),
      invima: json['invima']?.toString(),
      invimaVencimiento: fecha('invima_vencimiento'),
      certificadoTenenciaAnimales:
          json['certificado_tenencia_animales']?.toString(),
      buenasPracticasAgricolas: json['buenas_practicas_agricolas']?.toString(),
      buenasPracticasApicolas: json['buenas_practicas_apicolas']?.toString(),
      registroApicola: json['registro_apicola']?.toString(),
      intervencionCauce: json['intervencion_cauce']?.toString(),
      capacidadCarga: json['capacidad_carga']?.toString(),
      sstt: json['sstt']?.toString(),
      canalVenta: json['canal_venta']?.toString(),
      exportacion: json['exportacion']?.toString(),
      huellaCarbono: json['huella_carbono']?.toString(),
      fortalecimientoTecnico: json['fortalecimiento_tecnico']?.toString(),
      fortalecimientoAcademico: json['fortalecimiento_academico']?.toString(),
      fortalecimientoFinanciero:
          json['fortalecimiento_financiero']?.toString(),
      internacionalizacion: json['internacionalizacion']?.toString(),
      certificaciones: json['certificaciones']?.toString(),
      posicionamientoMarca: json['posicionamiento_marca']?.toString(),
      beneficiosVentanilla: json['beneficios_ventanilla']?.toString(),
      fortalezasAmbiental: json['fortalezas_ambiental']?.toString(),
      fortalezasSocial: json['fortalezas_social']?.toString(),
      fortalezasEconomico: json['fortalezas_economico']?.toString(),
      debilidadesAmbiental: json['debilidades_ambiental']?.toString(),
      debilidadesSocial: json['debilidades_social']?.toString(),
      debilidadesFinanciera: json['debilidades_financiera']?.toString(),
      novedad: json['novedad']?.toString(),
      tipoNegocioVerde: json['tipo_negocio_verde']?.toString(),
      codigoMarca: json['codigo_marca']?.toString(),
      anioRegistro: (json['anio_registro'] as num?)?.toInt(),
      cotaMsnm: json['cota_msnm']?.toString(),
      aplicacionFicha2025: json['aplicacion_ficha_2025']?.toString(),
      observaciones: json['observaciones']?.toString(),
      este: json['este']?.toString(),
      norte: json['norte']?.toString(),
      puntajes: {
        for (final p in puntajesJson)
          (p['anio'] as num).toInt(): (p['puntaje'] as num).toDouble(),
      },
    );
  }
}
