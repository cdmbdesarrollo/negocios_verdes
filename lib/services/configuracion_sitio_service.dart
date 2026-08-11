import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/configuracion_sitio.dart';

class ConfiguracionSitioService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<ConfiguracionSitio> obtener() async {
    try {
      final data = await _supabase
          .from('configuracion_sitio')
          .select()
          .eq('id', 'singleton')
          .single();
      return ConfiguracionSitio.fromJson(data);
    } catch (e) {
      throw Exception('No se pudo cargar la configuración del sitio: $e');
    }
  }

  Future<void> actualizarLogo({String? logoUrl, String? logoPath}) =>
      _actualizarPar('logo_url', logoUrl, 'logo_path', logoPath, 'el logo');

  Future<void> actualizarLogoGovco({String? url, String? path}) =>
      _actualizarPar(
          'logo_govco_url', url, 'logo_govco_path', path, 'el sello GOV.CO');

  Future<void> actualizarLogoColombia({String? url, String? path}) =>
      _actualizarPar('logo_colombia_url', url, 'logo_colombia_path', path,
          'el sello de Colombia');

  Future<void> actualizarLogoPotencia({String? url, String? path}) =>
      _actualizarPar('logo_potencia_url', url, 'logo_potencia_path', path,
          'el sello de Colombia Potencia de la Vida');

  Future<void> _actualizarPar(String campoUrl, String? url, String campoPath,
      String? path, String descripcion) async {
    try {
      await _supabase.from('configuracion_sitio').update({
        campoUrl: url,
        campoPath: path,
      }).eq('id', 'singleton');
    } catch (e) {
      throw Exception('No se pudo actualizar $descripcion: $e');
    }
  }
}

/// Cache en memoria de la configuración del sitio — el logo se muestra en
/// varios sitios a la vez (navbar, inicio, login admin, drawer admin), así
/// que sin esto cada instancia de LogoNegociosVerdes dispararía su propia
/// consulta por separado. Los widgets comparten el mismo Future en vuelo.
class ConfiguracionSitioCache {
  static Future<ConfiguracionSitio>? _futuro;

  static Future<ConfiguracionSitio> obtener() {
    return _futuro ??= ConfiguracionSitioService().obtener();
  }

  /// Llamar después de subir cualquier imagen nueva desde el admin para
  /// que el resto de la app deje de servir la versión en cache.
  static void invalidar() {
    _futuro = null;
  }
}
