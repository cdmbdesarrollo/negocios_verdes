import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/opcion_campo.dart';

class OpcionCampoService {
  final SupabaseClient _supabase = Supabase.instance.client;

  /// Todas las opciones de TODOS los campos en una sola consulta — a esta
  /// escala (unas pocas docenas de campos, cada uno con pocas opciones) es
  /// más simple traer todo una vez al abrir el formulario y filtrar en
  /// Dart por campo, que hacer una consulta separada por cada selector.
  Future<Map<String, List<OpcionCampo>>> listarTodas() async {
    try {
      final data = await _supabase
          .from('opciones_campo')
          .select()
          .order('campo', ascending: true)
          .order('orden', ascending: true);
      final porCampo = <String, List<OpcionCampo>>{};
      for (final fila in (data as List)) {
        final opcion = OpcionCampo.fromJson(fila as Map<String, dynamic>);
        porCampo.putIfAbsent(opcion.campo, () => []).add(opcion);
      }
      return porCampo;
    } catch (e) {
      throw Exception('No se pudieron cargar los catálogos de opciones: $e');
    }
  }

  /// Solo los valores de un campo, en su orden — para un selector suelto
  /// fuera de la ficha técnica (p. ej. el cargo en FormPersonaDialog).
  Future<List<String>> listarValores(String campo) async {
    try {
      final data = await _supabase
          .from('opciones_campo')
          .select('valor')
          .eq('campo', campo)
          .order('orden', ascending: true)
          .order('valor', ascending: true);
      return [
        for (final fila in data as List)
          (fila as Map<String, dynamic>)['valor'].toString(),
      ];
    } catch (e) {
      throw Exception('No se pudo cargar la lista de opciones: $e');
    }
  }

  /// Agrega una opción nueva a un campo — "deja una opción adicional si es
  /// necesario para el administrador". Vía RPC (no insert directo) para
  /// que quede auditada en admin_logs, mismo criterio que el resto de
  /// escrituras admin.
  Future<OpcionCampo> agregar({required String campo, required String valor}) async {
    try {
      final id = await _supabase.rpc('guardar_opcion_campo', params: {
        'p_campo': campo,
        'p_valor': valor,
      });
      return OpcionCampo(id: id.toString(), campo: campo, valor: valor);
    } catch (e) {
      throw Exception('No se pudo agregar la opción: $e');
    }
  }
}
