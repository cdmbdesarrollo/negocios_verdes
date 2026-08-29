import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/persona.dart';

/// Bases de responsables CDMB / delegados / representantes y su asignación
/// (con historial) a cada negocio — ver
/// 0029_personas_responsable_delegado_representante.sql. Toda escritura pasa
/// por una RPC `SECURITY DEFINER` con chequeo `es_admin()` interno; las
/// lecturas van directo a las tablas (RLS deja ver solo a admin).
class PersonasService {
  final SupabaseClient _supabase = Supabase.instance.client;

  static const _comunes =
      'id, nombres, apellidos, documento, tipo_documento, telefono, correo, '
      'direccion, municipio';

  /// Columnas a pedir por tipo — responsables/delegados llevan `cargo`,
  /// representantes llevan `naturaleza_juridica` y `razon_social` (ver 0031).
  String _columnas(TipoPersona t) => t == TipoPersona.representante
      ? '$_comunes, naturaleza_juridica, razon_social'
      : '$_comunes, cargo';

  String _rpcGuardar(TipoPersona t) => switch (t) {
        TipoPersona.responsable => 'guardar_responsable',
        TipoPersona.delegado => 'guardar_delegado',
        TipoPersona.representante => 'guardar_representante',
      };

  String _rpcAsignar(TipoPersona t) => switch (t) {
        TipoPersona.responsable => 'asignar_responsable_negocio',
        TipoPersona.delegado => 'asignar_delegado_negocio',
        TipoPersona.representante => 'asignar_representante_negocio',
      };

  String _rpcQuitar(TipoPersona t) => switch (t) {
        TipoPersona.responsable => 'quitar_responsable_negocio',
        TipoPersona.delegado => 'quitar_delegado_negocio',
        TipoPersona.representante => 'quitar_representante_negocio',
      };

  String _rpcEliminar(TipoPersona t) => switch (t) {
        TipoPersona.responsable => 'eliminar_responsable',
        TipoPersona.delegado => 'eliminar_delegado',
        TipoPersona.representante => 'eliminar_representante',
      };

  String _vista(TipoPersona t) => switch (t) {
        TipoPersona.responsable => 'v_responsables_cdmb',
        TipoPersona.delegado => 'v_delegados',
        TipoPersona.representante => 'v_representantes',
      };

  ({String tabla, String fkPersona, String embed}) _puente(TipoPersona t) =>
      switch (t) {
        TipoPersona.responsable => (
            tabla: 'negocio_responsable',
            fkPersona: 'responsable_id',
            embed: 'responsables_cdmb',
          ),
        TipoPersona.delegado => (
            tabla: 'negocio_delegado',
            fkPersona: 'delegado_id',
            embed: 'delegados',
          ),
        TipoPersona.representante => (
            tabla: 'negocio_representante',
            fkPersona: 'representante_id',
            embed: 'representantes',
          ),
      };

  Future<List<Persona>> listar(TipoPersona tipo) async {
    try {
      final data = await _supabase
          .from(tipo.tabla)
          .select(_columnas(tipo))
          .order('nombres');
      return (data as List)
          .map((e) => Persona.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('No se pudo cargar la lista de ${tipo.etiqueta}: $e');
    }
  }

  /// Igual que [listar] pero desde la vista `v_*` (ver 0030): cada persona
  /// trae `negociosTotal` / `negociosVigentes`. Para la pantalla
  /// /admin/personas.
  Future<List<Persona>> listarConConteo(TipoPersona tipo) async {
    try {
      final data = await _supabase
          .from(_vista(tipo))
          .select('${_columnas(tipo)}, negocios_total, negocios_vigentes')
          .order('nombres');
      return (data as List)
          .map((e) => Persona.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('No se pudo cargar la lista de ${tipo.etiqueta}: $e');
    }
  }

  /// Borra una persona que nunca se asignó a un negocio. Si tiene historial
  /// la RPC lo rechaza con un mensaje claro (la traza no se rompe).
  Future<void> eliminarPersona(TipoPersona tipo, String id) async {
    try {
      await _supabase.rpc(_rpcEliminar(tipo), params: {'p_id': id});
    } catch (e) {
      throw Exception(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  /// Crea (id nulo) o edita una persona. Devuelve el id. Los campos que no
  /// aplican al tipo (cargo para representante; razón social / naturaleza
  /// para responsable-delegado) simplemente se ignoran.
  Future<String> guardarPersona(TipoPersona tipo, Persona p) async {
    try {
      final base = <String, dynamic>{
        'p_id': p.id.isEmpty ? null : p.id,
        'p_nombres': p.nombres,
        'p_apellidos': p.apellidos,
        'p_documento': p.documento,
        'p_tipo_documento': p.tipoDocumento,
        'p_telefono': p.telefono,
        'p_correo': p.correo,
        'p_direccion': p.direccion,
        'p_municipio': p.municipio,
      };
      if (tipo == TipoPersona.representante) {
        base['p_razon_social'] = p.razonSocial;
        base['p_naturaleza_juridica'] = p.naturalezaJuridica;
      } else {
        base['p_cargo'] = p.cargo;
      }
      final r = await _supabase.rpc(_rpcGuardar(tipo), params: base);
      return r.toString();
    } catch (e) {
      throw Exception(
          'No se pudo guardar la persona: ${e.toString().replaceFirst('Exception: ', '')}');
    }
  }

  /// Asigna una persona a un negocio (cierra la asignación vigente anterior y
  /// abre una nueva — queda la traza). [nit]/[naturalezaJuridica] solo se
  /// usan para representante.
  Future<void> asignar(
    TipoPersona tipo, {
    required String negocioId,
    required String personaId,
    String? nit,
    String? naturalezaJuridica,
    String? nota,
  }) async {
    try {
      final params = <String, dynamic>{
        'p_negocio_id': negocioId,
        'p_nota': nota,
      };
      if (tipo == TipoPersona.representante) {
        params['p_representante_id'] = personaId;
        params['p_nit'] = nit;
        params['p_naturaleza_juridica'] = naturalezaJuridica;
      } else if (tipo == TipoPersona.responsable) {
        params['p_responsable_id'] = personaId;
      } else {
        params['p_delegado_id'] = personaId;
      }
      await _supabase.rpc(_rpcAsignar(tipo), params: params);
    } catch (e) {
      throw Exception('No se pudo asignar ${tipo.etiqueta.toLowerCase()}: $e');
    }
  }

  Future<void> quitar(
    TipoPersona tipo, {
    required String negocioId,
    String? nota,
  }) async {
    try {
      await _supabase.rpc(_rpcQuitar(tipo), params: {
        'p_negocio_id': negocioId,
        'p_nota': nota,
      });
    } catch (e) {
      throw Exception('No se pudo quitar ${tipo.etiqueta.toLowerCase()}: $e');
    }
  }

  /// Asignaciones vigentes de un negocio (para precargar el formulario).
  Future<AsignacionesActuales> actuales(String negocioId) async {
    try {
      Future<Map<String, dynamic>?> vigente(TipoPersona t, String cols) async {
        final p = _puente(t);
        final data = await _supabase
            .from(p.tabla)
            .select(cols)
            .eq('negocio_id', negocioId)
            .filter('vigente_hasta', 'is', null)
            .maybeSingle();
        return data;
      }

      final resp = await vigente(TipoPersona.responsable, 'responsable_id');
      final del = await vigente(TipoPersona.delegado, 'delegado_id');
      final rep = await vigente(TipoPersona.representante,
          'representante_id, nit, naturaleza_juridica');
      return AsignacionesActuales(
        responsableId: resp?['responsable_id']?.toString(),
        delegadoId: del?['delegado_id']?.toString(),
        representanteId: rep?['representante_id']?.toString(),
        nit: rep?['nit']?.toString(),
        naturalezaJuridica: rep?['naturaleza_juridica']?.toString(),
      );
    } catch (e) {
      throw Exception('No se pudieron cargar las asignaciones actuales: $e');
    }
  }

  /// Historial completo (todas las asignaciones, vigentes y cerradas) de un
  /// tipo de persona para un negocio, de la más reciente a la más antigua.
  Future<List<AsignacionPersona>> historial(
      TipoPersona tipo, String negocioId) async {
    try {
      final p = _puente(tipo);
      final esRepr = tipo == TipoPersona.representante;
      final extra = esRepr ? ', nit, naturaleza_juridica' : '';
      final embedCols = esRepr
          ? 'nombres, apellidos, documento, razon_social'
          : 'nombres, apellidos, documento';
      final data = await _supabase
          .from(p.tabla)
          .select(
              'vigente_desde, vigente_hasta, nota$extra, ${p.embed}($embedCols)')
          .eq('negocio_id', negocioId)
          .order('vigente_desde', ascending: false);
      return (data as List)
          .map((e) => AsignacionPersona.fromJson(
              e as Map<String, dynamic>, p.embed))
          .toList();
    } catch (e) {
      throw Exception('No se pudo cargar el historial: $e');
    }
  }
}
