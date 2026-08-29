import 'package:supabase_flutter/supabase_flutter.dart';

import '../core/texto_utils.dart';
import '../models/ficha_tecnica_negocio.dart';
import '../models/filtro_busqueda.dart';
import '../models/negocio.dart';

// categorias_oficiales!negocios_categoria_oficial_id_fkey (no solo
// "categorias_oficiales"): desde que existe negocios_categorias,
// PostgREST ve DOS caminos posibles de negocios a categorias_oficiales (el
// FK directo de la categoría principal, y el de la tabla puente) y sin este
// hint explícito responde 300 "more than one relationship was found" en
// CUALQUIER consulta de negocios — se cae el sitio público entero, no solo
// el admin. Este hint fija cuál de los dos es el embed "plano" de arriba.
const String _embeds =
    'categorias_oficiales!negocios_categoria_oficial_id_fkey(*), veredas(*), '
    'negocio_fotos(*), '
    'negocios_subcategorias(subcategorias(*)), '
    'negocios_categorias(categorias_oficiales(*)), '
    'negocios_actividades(actividades_productivas(*))';

/// Solo admin: "*" trae también las ~40 columnas de seguimiento interno
/// (ver 0022_ficha_ampliada_negocios.sql) — correcto para /admin/negocios,
/// ese panel ya requiere sesión de admin autenticada.
const String _selectConEmbeds = '*, $_embeds';

/// Público: lista explícita de columnas, a propósito SIN "*". No es solo
/// una cuestión de UI — RLS en Postgres controla filas, no columnas, así
/// que un SELECT "*" desde el buscador público haría viajar el NIT y el
/// resto de la ficha técnica en la respuesta JSON a cualquier visitante
/// anónimo, aunque la interfaz nunca los muestre (visible igual abriendo
/// las herramientas de red del navegador). Decisión explícita de CDMB:
/// nit/naturaleza_juridica nunca públicos (ver Negocio.nit).
const String _selectPublico =
    'id, nombre, slug, categoria_oficial_id, municipio, vereda_id, '
    'direccion, latitud, longitud, descripcion_corta, descripcion, producto, '
    'telefono, whatsapp, email, sitio_web, facebook_url, instagram_url, '
    'foto_portada_url, foto_portada_path, representante_legal, '
    'emprendimiento_verde, sello_marca, avalado, destacado, activo, '
    'created_at, updated_at, $_embeds';

class NegocioService {
  final SupabaseClient _supabase = Supabase.instance.client;

  /// Buscador público — solo negocios activos. Aplica los filtros de
  /// [FiltroBusqueda] como AND: texto (full-text en español, sin tildes en
  /// ambos lados), municipio, categoría, subcategoría y actividad
  /// productiva. Categoría/subcategoría/actividad se resuelven vía sus
  /// tablas puente (negocios_categorias/negocios_subcategorias/
  /// negocios_actividades), no contra la columna categoria_oficial_id de
  /// negocios (esa solo guarda la categoría PRINCIPAL — la 1ª de hasta 3 —
  /// así que filtrar directo contra ella dejaría afuera negocios donde la
  /// categoría buscada es la 2ª o 3ª).
  Future<List<Negocio>> buscar(FiltroBusqueda filtro) async {
    try {
      var query =
          _supabase.from('negocios').select(_selectPublico).eq('activo', true);

      if (filtro.municipio != null) {
        query = query.eq('municipio', filtro.municipio!);
      }

      if (filtro.categoriaSlug != null) {
        final categoriaId =
            await _idPorSlug('categorias_oficiales', filtro.categoriaSlug!);
        if (categoriaId == null) return [];
        final negocioIds = await _negocioIdsPorTablaPuente(
            'negocios_categorias', 'categoria_oficial_id', categoriaId);
        if (negocioIds.isEmpty) return [];
        query = query.inFilter('id', negocioIds);
      }

      if (filtro.subcategoriaSlug != null) {
        final subcategoriaId =
            await _idPorSlug('subcategorias', filtro.subcategoriaSlug!);
        if (subcategoriaId == null) return [];
        final negocioIds = await _negocioIdsPorTablaPuente(
            'negocios_subcategorias', 'subcategoria_id', subcategoriaId);
        if (negocioIds.isEmpty) return [];
        query = query.inFilter('id', negocioIds);
      }

      if (filtro.actividadSlug != null) {
        final actividadId =
            await _idPorSlug('actividades_productivas', filtro.actividadSlug!);
        if (actividadId == null) return [];
        final negocioIds = await _negocioIdsPorTablaPuente(
            'negocios_actividades', 'actividad_productiva_id', actividadId);
        if (negocioIds.isEmpty) return [];
        query = query.inFilter('id', negocioIds);
      }

      if (filtro.emprendimientoVerde == true) {
        query = query.eq('emprendimiento_verde', true);
      }
      if (filtro.selloMarca == true) {
        query = query.eq('sello_marca', true);
      }
      if (filtro.avalado == true) {
        query = query.eq('avalado', true);
      }

      if (filtro.query.trim().isNotEmpty) {
        // "busqueda" es una columna generada SOLO a partir de nombre +
        // descripciones del propio negocio (0004_negocios.sql) — Postgres
        // no deja que una columna generada haga JOIN a otras tablas, así
        // que nunca va a "saber" que un negocio pertenece a la actividad
        // "Agricultura orgánica" con solo indexar su fila. Antes de esto,
        // escribir el nombre exacto de una categoría/subcategoría/
        // actividad (justo lo que sugiere el hint del buscador) devolvía
        // 0 resultados aunque sí hubiera negocios en esa clasificación —
        // reportado con un caso real. Se combinan las dos vías: texto
        // libre de siempre + negocios cuya categoría/subcategoría/
        // actividad tenga un nombre que contenga lo escrito.
        final textoNormalizado =
            quitarTildes(filtro.query.trim().toLowerCase());
        final idsPorTexto = await _idsPorTexto(filtro.query.trim());
        final idsPorTaxonomia =
            await _idsPorNombreDeTaxonomia(textoNormalizado);
        final idsCombinados = {...idsPorTexto, ...idsPorTaxonomia};
        if (idsCombinados.isEmpty) return [];
        query = query.inFilter('id', idsCombinados.toList());
      }

      final data = await query
          .order('destacado', ascending: false)
          .order('nombre', ascending: true);

      return (data as List)
          .map((e) => Negocio.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('No se pudieron cargar los negocios: $e');
    }
  }

  /// Solo nombre+slug de cada negocio activo, para el autocompletado del
  /// buscador — a esta escala (cientos, no miles) traer todo una sola vez
  /// es más simple que una consulta "por cada tecla" al servidor, mismo
  /// criterio que listarTodosAdmin(). Payload chico a propósito: nada de
  /// select(_selectConEmbeds) acá, no hace falta ningún embed para esto.
  Future<List<(String nombre, String slug)>> listarNombresPublicos() async {
    try {
      final data = await _supabase
          .from('negocios')
          .select('nombre, slug')
          .eq('activo', true);
      return (data as List).map((e) {
        final mapa = e as Map<String, dynamic>;
        return (mapa['nombre'] as String, mapa['slug'] as String);
      }).toList();
    } catch (e) {
      throw Exception('No se pudieron cargar los nombres de negocios: $e');
    }
  }

  Future<Negocio?> obtenerPorSlug(String slug) async {
    try {
      final data = await _supabase
          .from('negocios')
          .select(_selectPublico)
          .eq('slug', slug)
          .eq('activo', true)
          .maybeSingle();
      return data == null ? null : Negocio.fromJson(data);
    } catch (e) {
      throw Exception('No se pudo cargar el negocio: $e');
    }
  }

  /// Listado admin — sin filtro de "activo" (también ve borradores), sin
  /// paginación server-side: a esta escala (cientos de negocios, no miles)
  /// alcanza traer todo y que la página filtre/busque en memoria, igual que
  /// admin_catalogo_page en HuellaQR.
  Future<List<Negocio>> listarTodosAdmin() async {
    try {
      final data = await _supabase
          .from('negocios')
          .select(_selectConEmbeds)
          .order('created_at', ascending: false);
      return (data as List)
          .map((e) => Negocio.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('No se pudieron cargar los negocios: $e');
    }
  }

  Future<Negocio?> obtenerPorId(String id) async {
    try {
      final data = await _supabase
          .from('negocios')
          .select(_selectConEmbeds)
          .eq('id', id)
          .maybeSingle();
      return data == null ? null : Negocio.fromJson(data);
    } catch (e) {
      throw Exception('No se pudo cargar el negocio: $e');
    }
  }

  /// Crea (id nulo) o edita (id con valor) un negocio completo, incluida la
  /// sincronización de subcategorías, vía la RPC guardar_negocio — atómico
  /// entre negocios, negocios_subcategorias y admin_logs (ver
  /// 0007_rpc_guardar_negocio.sql). Devuelve el id del negocio (el mismo
  /// [id] que se pasó).
  ///
  /// [id] es SIEMPRE requerido, incluso al crear: el formulario lo genera
  /// con Uuid().v4() antes de abrir el editor de fotos, porque necesita ese
  /// id de antemano para las rutas de Storage de portada/galería. La RPC
  /// decide crear vs. actualizar comprobando si ese id ya existe, no si es
  /// nulo — ver el comentario en la propia función SQL.
  Future<String> guardar({
    required String id,
    required String nombre,
    required List<String> categoriaOficialIds,
    required String municipio,
    String? veredaId,
    String? direccion,
    double? latitud,
    double? longitud,
    String? descripcionCorta,
    String? descripcion,
    String? telefono,
    String? whatsapp,
    String? email,
    String? sitioWeb,
    String? facebookUrl,
    String? instagramUrl,
    String? fotoPortadaUrl,
    String? fotoPortadaPath,
    String? representanteLegal,
    String? producto,
    String? nit,
    String? naturalezaJuridica,
    required bool emprendimientoVerde,
    required bool selloMarca,
    required bool avalado,
    required bool destacado,
    required bool activo,
    required List<String> subcategoriaIds,
    required List<String> actividadIds,
  }) async {
    try {
      final resultado = await _supabase.rpc('guardar_negocio', params: {
        'p_id': id,
        'p_nombre': nombre,
        'p_categoria_oficial_ids': categoriaOficialIds,
        'p_municipio': municipio,
        'p_vereda_id': veredaId,
        'p_direccion': direccion,
        'p_latitud': latitud,
        'p_longitud': longitud,
        'p_descripcion_corta': descripcionCorta,
        'p_descripcion': descripcion,
        'p_telefono': telefono,
        'p_whatsapp': whatsapp,
        'p_email': email,
        'p_sitio_web': sitioWeb,
        'p_facebook_url': facebookUrl,
        'p_instagram_url': instagramUrl,
        'p_foto_portada_url': fotoPortadaUrl,
        'p_foto_portada_path': fotoPortadaPath,
        'p_representante_legal': representanteLegal,
        'p_producto': producto,
        'p_nit': nit,
        'p_naturaleza_juridica': naturalezaJuridica,
        'p_emprendimiento_verde': emprendimientoVerde,
        'p_sello_marca': selloMarca,
        'p_avalado': avalado,
        'p_destacado': destacado,
        'p_activo': activo,
        'p_subcategoria_ids': subcategoriaIds,
        'p_actividad_ids': actividadIds,
      });
      return resultado.toString();
    } catch (e) {
      throw Exception('No se pudo guardar el negocio: $e');
    }
  }

  /// Los ~40 campos de seguimiento interno CDMB (ver FichaTecnicaNegocio) —
  /// select explícito porque son las mismas columnas admin-only que
  /// _selectPublico excluye a propósito, no tiene sentido traer también
  /// todo lo público/embeds acá.
  Future<FichaTecnicaNegocio> obtenerFichaTecnica(String negocioId) async {
    try {
      final data = await _supabase
          .from('negocios')
          .select(
              'id, tiempo_constitucion, rut_camara_comercio, responsable_cdmb, '
              'delegado, registro_nacional_turismo, uso_suelo, concesion_aguas, '
              'concesion_aguas_vencimiento, vertimientos, vertimientos_vencimiento, '
              'pueaa, pgris, pozo_septico, alcantarillado, ica, ica_vencimiento, '
              'invima, invima_vencimiento, certificado_tenencia_animales, '
              'buenas_practicas_agricolas, buenas_practicas_apicolas, registro_apicola, '
              'intervencion_cauce, capacidad_carga, sstt, canal_venta, exportacion, '
              'huella_carbono, fortalecimiento_tecnico, fortalecimiento_academico, '
              'fortalecimiento_financiero, internacionalizacion, certificaciones, '
              'posicionamiento_marca, beneficios_ventanilla, fortalezas_ambiental, '
              'fortalezas_social, fortalezas_economico, debilidades_ambiental, '
              'debilidades_social, debilidades_financiera, novedad, tipo_negocio_verde, '
              'codigo_marca, anio_registro, cota_msnm, aplicacion_ficha_2025, observaciones')
          .eq('id', negocioId)
          .single();
      final puntajes = await _supabase
          .from('negocio_puntajes')
          .select('anio, puntaje')
          .eq('negocio_id', negocioId);
      return FichaTecnicaNegocio.fromJson(
          data, (puntajes as List).cast<Map<String, dynamic>>());
    } catch (e) {
      throw Exception('No se pudo cargar la ficha técnica: $e');
    }
  }

  Future<void> guardarFichaTecnica({
    required String id,
    String? novedad,
    String? tipoNegocioVerde,
    String? codigoMarca,
    int? anioRegistro,
    String? cotaMsnm,
    String? aplicacionFicha2025,
    String? observaciones,
    String? delegado,
    String? tiempoConstitucion,
    String? rutCamaraComercio,
    String? responsableCdmb,
    String? registroNacionalTurismo,
    String? usoSuelo,
    String? concesionAguas,
    DateTime? concesionAguasVencimiento,
    String? vertimientos,
    DateTime? vertimientosVencimiento,
    String? pueaa,
    String? pgris,
    String? pozoSeptico,
    String? alcantarillado,
    String? ica,
    DateTime? icaVencimiento,
    String? invima,
    DateTime? invimaVencimiento,
    String? certificadoTenenciaAnimales,
    String? buenasPracticasAgricolas,
    String? buenasPracticasApicolas,
    String? registroApicola,
    String? intervencionCauce,
    String? capacidadCarga,
    String? sstt,
    String? canalVenta,
    String? exportacion,
    String? huellaCarbono,
    String? fortalecimientoTecnico,
    String? fortalecimientoAcademico,
    String? fortalecimientoFinanciero,
    String? internacionalizacion,
    String? certificaciones,
    String? posicionamientoMarca,
    String? beneficiosVentanilla,
    String? fortalezasAmbiental,
    String? fortalezasSocial,
    String? fortalezasEconomico,
    String? debilidadesAmbiental,
    String? debilidadesSocial,
    String? debilidadesFinanciera,
  }) async {
    String? fecha(DateTime? d) => d?.toIso8601String().split('T').first;
    try {
      await _supabase.rpc('guardar_ficha_tecnica_negocio', params: {
        'p_id': id,
        'p_novedad': novedad,
        'p_tipo_negocio_verde': tipoNegocioVerde,
        'p_codigo_marca': codigoMarca,
        'p_anio_registro': anioRegistro,
        'p_cota_msnm': cotaMsnm,
        'p_aplicacion_ficha_2025': aplicacionFicha2025,
        'p_observaciones': observaciones,
        'p_delegado': delegado,
        'p_tiempo_constitucion': tiempoConstitucion,
        'p_rut_camara_comercio': rutCamaraComercio,
        'p_responsable_cdmb': responsableCdmb,
        'p_registro_nacional_turismo': registroNacionalTurismo,
        'p_uso_suelo': usoSuelo,
        'p_concesion_aguas': concesionAguas,
        'p_concesion_aguas_vencimiento': fecha(concesionAguasVencimiento),
        'p_vertimientos': vertimientos,
        'p_vertimientos_vencimiento': fecha(vertimientosVencimiento),
        'p_pueaa': pueaa,
        'p_pgris': pgris,
        'p_pozo_septico': pozoSeptico,
        'p_alcantarillado': alcantarillado,
        'p_ica': ica,
        'p_ica_vencimiento': fecha(icaVencimiento),
        'p_invima': invima,
        'p_invima_vencimiento': fecha(invimaVencimiento),
        'p_certificado_tenencia_animales': certificadoTenenciaAnimales,
        'p_buenas_practicas_agricolas': buenasPracticasAgricolas,
        'p_buenas_practicas_apicolas': buenasPracticasApicolas,
        'p_registro_apicola': registroApicola,
        'p_intervencion_cauce': intervencionCauce,
        'p_capacidad_carga': capacidadCarga,
        'p_sstt': sstt,
        'p_canal_venta': canalVenta,
        'p_exportacion': exportacion,
        'p_huella_carbono': huellaCarbono,
        'p_fortalecimiento_tecnico': fortalecimientoTecnico,
        'p_fortalecimiento_academico': fortalecimientoAcademico,
        'p_fortalecimiento_financiero': fortalecimientoFinanciero,
        'p_internacionalizacion': internacionalizacion,
        'p_certificaciones': certificaciones,
        'p_posicionamiento_marca': posicionamientoMarca,
        'p_beneficios_ventanilla': beneficiosVentanilla,
        'p_fortalezas_ambiental': fortalezasAmbiental,
        'p_fortalezas_social': fortalezasSocial,
        'p_fortalezas_economico': fortalezasEconomico,
        'p_debilidades_ambiental': debilidadesAmbiental,
        'p_debilidades_social': debilidadesSocial,
        'p_debilidades_financiera': debilidadesFinanciera,
      });
    } catch (e) {
      throw Exception('No se pudo guardar la ficha técnica: $e');
    }
  }

  Future<void> guardarPuntaje(String negocioId, int anio, double puntaje) async {
    try {
      await _supabase.rpc('guardar_puntaje_negocio', params: {
        'p_negocio_id': negocioId,
        'p_anio': anio,
        'p_puntaje': puntaje,
      });
    } catch (e) {
      throw Exception('No se pudo guardar el puntaje: $e');
    }
  }

  Future<void> alternarActivo(String id, bool activo) async {
    try {
      await _supabase.from('negocios').update({'activo': activo}).eq('id', id);
    } catch (e) {
      throw Exception('No se pudo cambiar la visibilidad del negocio: $e');
    }
  }

  Future<void> alternarDestacado(String id, bool destacado) async {
    try {
      await _supabase
          .from('negocios')
          .update({'destacado': destacado}).eq('id', id);
    } catch (e) {
      throw Exception('No se pudo cambiar el destacado del negocio: $e');
    }
  }

  Future<void> eliminar(String id) async {
    try {
      await _supabase.from('negocios').delete().eq('id', id);
    } catch (e) {
      throw Exception('No se pudo eliminar el negocio: $e');
    }
  }

  Future<String?> _idPorSlug(String tabla, String slug) async {
    final data = await _supabase
        .from(tabla)
        .select('id')
        .eq('slug', slug)
        .maybeSingle();
    return data?['id']?.toString();
  }

  /// Ids de negocio que tienen [valorId] en una tabla puente
  /// (negocios_categorias/negocios_subcategorias/negocios_actividades) —
  /// mismo shape en las 3, solo cambia el nombre de tabla y de columna.
  Future<List<String>> _negocioIdsPorTablaPuente(
      String tabla, String columna, String valorId) async {
    final data =
        await _supabase.from(tabla).select('negocio_id').eq(columna, valorId);
    return (data as List)
        .map((e) => (e as Map<String, dynamic>)['negocio_id'].toString())
        .toList();
  }

  /// Solo ids (no filas completas) que matchean la búsqueda de texto libre
  /// — consulta separada de la principal para poder combinarla con
  /// [_idsPorNombreDeTaxonomia] antes de aplicar el resto de filtros
  /// (municipio, activo, etc.) una sola vez al final.
  Future<List<String>> _idsPorTexto(String texto) async {
    final data = await _supabase
        .from('negocios')
        .select('id')
        .textSearch('busqueda', quitarTildes(texto),
            config: 'spanish', type: TextSearchType.websearch);
    return (data as List)
        .map((e) => (e as Map<String, dynamic>)['id'].toString())
        .toList();
  }

  /// Negocios cuya categoría, subcategoría o actividad productiva tiene un
  /// nombre que CONTIENE [textoNormalizado] (ya sin tildes y en
  /// minúsculas) — comparación en Dart, no en SQL: las 3 tablas de
  /// catálogo son chicas (3+12+29 filas hoy), traerlas enteras es más
  /// simple que pelear con unaccent()/ilike combinados en PostgREST, y
  /// evita tener que des-tildar una columna que hoy no lo está.
  Future<List<String>> _idsPorNombreDeTaxonomia(String textoNormalizado) async {
    const tablasPuente = [
      ('categorias_oficiales', 'negocios_categorias', 'categoria_oficial_id'),
      ('subcategorias', 'negocios_subcategorias', 'subcategoria_id'),
      ('actividades_productivas', 'negocios_actividades',
          'actividad_productiva_id'),
    ];
    final ids = <String>{};
    for (final (tabla, tablaPuente, columna) in tablasPuente) {
      final filas = await _supabase.from(tabla).select('id, nombre');
      for (final fila in filas as List) {
        final mapa = fila as Map<String, dynamic>;
        final nombre = quitarTildes((mapa['nombre'] as String).toLowerCase());
        if (nombre.contains(textoNormalizado)) {
          ids.addAll(await _negocioIdsPorTablaPuente(
              tablaPuente, columna, mapa['id'].toString()));
        }
      }
    }
    return ids.toList();
  }
}
