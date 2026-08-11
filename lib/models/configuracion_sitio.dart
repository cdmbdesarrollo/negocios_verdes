class ConfiguracionSitio {
  final String? logoUrl;
  final String? logoPath;

  const ConfiguracionSitio({this.logoUrl, this.logoPath});

  factory ConfiguracionSitio.fromJson(Map<String, dynamic> json) {
    return ConfiguracionSitio(
      logoUrl: json['logo_url']?.toString(),
      logoPath: json['logo_path']?.toString(),
    );
  }
}
