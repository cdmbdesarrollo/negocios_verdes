import 'package:supabase_flutter/supabase_flutter.dart';

import '../core/texto_utils.dart';
import '../models/filtro_busqueda.dart';
import '../models/negocio.dart';

// categorias_oficiales!negocios_categoria_oficial_id_fkey (no solo
// "categorias_oficiales"): desde que existe negocios_categorias,
// PostgREST ve DOS caminos posibles de negocios a categorias_oficiales (el
// FK directo de la categoría principal, y el de la tabla puente) y sin este
// hint explícito responde 300 "more than one relationship was found" en
// CUALQUIER consulta de negocios — se cae el sitio público entero, no solo
// el admin. Este hint fija cuál de los dos es el embed "plano" de arriba.
const String _selectConEmbeds =
    '*, categorias_oficiales!negocios_categoria_oficial_id_fkey(*), '
    'negocio_fotos(*), '
    'negocios_subcategorias(subcategorias(*)), '
    'negocios_categorias(categorias_oficiales(*)), '
    'negocios_actividades(actividades_productivas(*))';

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
          _supabase.from('negocios').select(_selectConEmbeds).eq('activo', true);

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

  Future<Negocio?> obtenerPorSlug(String slug) async {
    try {
      final data = await _supabase
          .from('negocios')
          .select(_selectConEmbeds)
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
    String? direccion,
    double? latitud,
    double? longitud,
    required String descripcionCorta,
    required String descripcion,
    String? telefono,
    required String whatsapp,
    String? email,
    String? sitioWeb,
    String? facebookUrl,
    String? instagramUrl,
    String? fotoPortadaUrl,
    String? fotoPortadaPath,
    required String nivelDesarrollo,
    required bool destacado,
    required bool activo,
    required List<String> subcategoriaIds,
    required List<String> actividadIds,
    required bool selloMarca,
    required bool avalConfianza,
  }) async {
    try {
      final resultado = await _supabase.rpc('guardar_negocio', params: {
        'p_id': id,
        'p_nombre': nombre,
        'p_categoria_oficial_ids': categoriaOficialIds,
        'p_municipio': municipio,
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
        'p_nivel_desarrollo': nivelDesarrollo,
        'p_destacado': destacado,
        'p_activo': activo,
        'p_subcategoria_ids': subcategoriaIds,
        'p_actividad_ids': actividadIds,
        'p_sello_marca': selloMarca,
        'p_aval_confianza': avalConfianza,
      });
      return resultado.toString();
    } catch (e) {
      throw Exception('No se pudo guardar el negocio: $e');
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
