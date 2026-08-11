class ConfiguracionSitio {
  final String? logoUrl;
  final String? logoPath;

  /// Sellos institucionales del pie de página — Negocios Verdes es un
  /// micrositio de la Sede Electrónica de la CDMB, que muestra estos dos
  /// sellos en la franja verde inferior de su footer.
  final String? logoGovcoUrl;
  final String? logoGovcoPath;
  final String? logoColombiaUrl;
  final String? logoColombiaPath;

  const ConfiguracionSitio({
    this.logoUrl,
    this.logoPath,
    this.logoGovcoUrl,
    this.logoGovcoPath,
    this.logoColombiaUrl,
    this.logoColombiaPath,
  });

  factory ConfiguracionSitio.fromJson(Map<String, dynamic> json) {
    return ConfiguracionSitio(
      logoUrl: json['logo_url']?.toString(),
      logoPath: json['logo_path']?.toString(),
      logoGovcoUrl: json['logo_govco_url']?.toString(),
      logoGovcoPath: json['logo_govco_path']?.toString(),
      logoColombiaUrl: json['logo_colombia_url']?.toString(),
      logoColombiaPath: json['logo_colombia_path']?.toString(),
    );
  }

  ConfiguracionSitio copyWith({
    String? logoUrl,
    String? logoPath,
    String? logoGovcoUrl,
    String? logoGovcoPath,
    String? logoColombiaUrl,
    String? logoColombiaPath,
  }) {
    return ConfiguracionSitio(
      logoUrl: logoUrl ?? this.logoUrl,
      logoPath: logoPath ?? this.logoPath,
      logoGovcoUrl: logoGovcoUrl ?? this.logoGovcoUrl,
      logoGovcoPath: logoGovcoPath ?? this.logoGovcoPath,
      logoColombiaUrl: logoColombiaUrl ?? this.logoColombiaUrl,
      logoColombiaPath: logoColombiaPath ?? this.logoColombiaPath,
    );
  }
}
