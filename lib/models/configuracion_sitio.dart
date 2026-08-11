class ConfiguracionSitio {
  final String? logoUrl;
  final String? logoPath;

  /// Sellos institucionales del pie de página — Negocios Verdes es un
  /// micrositio de la Sede Electrónica de la CDMB. GOV.CO y Colombia son
  /// los que trae esa página en su franja azul inferior; el de "Colombia
  /// Potencia de la Vida" es la marca país vigente, va justo a la derecha
  /// del sello de Colombia.
  final String? logoGovcoUrl;
  final String? logoGovcoPath;
  final String? logoColombiaUrl;
  final String? logoColombiaPath;
  final String? logoPotenciaUrl;
  final String? logoPotenciaPath;

  const ConfiguracionSitio({
    this.logoUrl,
    this.logoPath,
    this.logoGovcoUrl,
    this.logoGovcoPath,
    this.logoColombiaUrl,
    this.logoColombiaPath,
    this.logoPotenciaUrl,
    this.logoPotenciaPath,
  });

  factory ConfiguracionSitio.fromJson(Map<String, dynamic> json) {
    return ConfiguracionSitio(
      logoUrl: json['logo_url']?.toString(),
      logoPath: json['logo_path']?.toString(),
      logoGovcoUrl: json['logo_govco_url']?.toString(),
      logoGovcoPath: json['logo_govco_path']?.toString(),
      logoColombiaUrl: json['logo_colombia_url']?.toString(),
      logoColombiaPath: json['logo_colombia_path']?.toString(),
      logoPotenciaUrl: json['logo_potencia_url']?.toString(),
      logoPotenciaPath: json['logo_potencia_path']?.toString(),
    );
  }

  ConfiguracionSitio copyWith({
    String? logoUrl,
    String? logoPath,
    String? logoGovcoUrl,
    String? logoGovcoPath,
    String? logoColombiaUrl,
    String? logoColombiaPath,
    String? logoPotenciaUrl,
    String? logoPotenciaPath,
  }) {
    return ConfiguracionSitio(
      logoUrl: logoUrl ?? this.logoUrl,
      logoPath: logoPath ?? this.logoPath,
      logoGovcoUrl: logoGovcoUrl ?? this.logoGovcoUrl,
      logoGovcoPath: logoGovcoPath ?? this.logoGovcoPath,
      logoColombiaUrl: logoColombiaUrl ?? this.logoColombiaUrl,
      logoColombiaPath: logoColombiaPath ?? this.logoColombiaPath,
      logoPotenciaUrl: logoPotenciaUrl ?? this.logoPotenciaUrl,
      logoPotenciaPath: logoPotenciaPath ?? this.logoPotenciaPath,
    );
  }
}
