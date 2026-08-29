import 'package:supabase_flutter/supabase_flutter.dart';

import '../core/texto_utils.dart';
import '../models/vereda.dart';

class VeredaService {
  final SupabaseClient _supabase = Supabase.instance.client;

  /// Todas (activas e inactivas) — igual criterio que CategoriaService:
  /// "activo" solo oculta del selector del formulario, no es una
  /// restricción de visibilidad pública real.
  Future<List<Vereda>> listarTodas() async {
    try {
      final data = await _supabase
          .from('veredas')
          .select()
          .order('municipio', ascending: true)
          .order('nombre', ascending: true);
      return (data as List)
          .map((e) => Vereda.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('No se pudieron cargar las veredas: $e');
    }
  }

  /// Crea una vereda nueva "al vuelo" desde el selector del formulario de
  /// negocio — pedido explícito: "con la posibilidad de crear nuevas
  /// veredas a futuro", sin necesidad de una pantalla CRUD aparte todavía.
  /// El slug se genera acá mismo (sin tildes, minúsculas) para que
  /// coincida con el que ya usa 0021_veredas.sql para el UNIQUE
  /// (municipio, slug).
  Future<Vereda> crear({required String municipio, required String nombre}) async {
    try {
      final slug = quitarTildes(nombre.trim().toLowerCase())
          .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
          .replaceAll(RegExp(r'^-+|-+$'), '');
      final data = await _supabase
          .from('veredas')
          .insert({'municipio': municipio, 'nombre': nombre.trim(), 'slug': slug})
          .select()
          .single();
      return Vereda.fromJson(data);
    } catch (e) {
      throw Exception('No se pudo crear la vereda: $e');
    }
  }
}
