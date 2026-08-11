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

  Future<void> actualizarLogo({String? logoUrl, String? logoPath}) async {
    try {
      await _supabase.from('configuracion_sitio').update({
        'logo_url': logoUrl,
        'logo_path': logoPath,
      }).eq('id', 'singleton');
    } catch (e) {
      throw Exception('No se pudo actualizar el logo: $e');
    }
  }
}

/// Cache en memoria del logo — se muestra en varios sitios a la vez
/// (navbar, buscador de inicio, login admin, drawer admin), así que sin
/// esto cada instancia de LogoNegociosVerdes dispararía su propia consulta
/// por separado. Los widgets comparten el mismo Future en vuelo.
class ConfiguracionSitioCache {
  static Future<ConfiguracionSitio>? _futuro;

  static Future<ConfiguracionSitio> obtener() {
    return _futuro ??= ConfiguracionSitioService().obtener();
  }

  /// Llamar después de subir un logo nuevo desde el admin para que el
  /// resto de la app deje de servir la versión en cache.
  static void invalidar() {
    _futuro = null;
  }
}
