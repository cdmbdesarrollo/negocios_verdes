import 'actividad_productiva.dart';
import 'categoria_oficial.dart';
import 'negocio_foto.dart';
import 'subcategoria.dart';

/// Desenvuelve un embed de Supabase que puede llegar como Map (relación
/// a-uno) o como List de un solo Map (a veces Postgrest lo entrega así según
/// cómo infiera la relación) — mismo problema que resuelve HuellaQR en
/// mascota_model.dart.
Map<String, dynamic>? _desenvolverUno(dynamic campo) {
  if (campo is Map<String, dynamic>) return campo;
  if (campo is List && campo.isNotEmpty && campo.first is Map) {
    return Map<String, dynamic>.from(campo.first as Map);
  }
  return null;
}

List<Map<String, dynamic>> _desenvolverLista(dynamic campo) {
  if (campo is List) {
    return campo.whereType<Map>().map(Map<String, dynamic>.from).toList();
  }
  return const [];
}

class Negocio {
  final String id;
  final String nombre;
  final String slug;
  final String categoriaOficialId;
  final CategoriaOficial? categoriaOficial;
  /// Todas las categorías del negocio (hasta 3) — [categoriaOficial] arriba
  /// sigue siendo solo la principal (la primera elegida), para no romper
  /// nada que ya filtre/muestre por una sola. Esta lista es la fuente de
  /// verdad completa, viene de negocios_categorias.
  final List<CategoriaOficial> categoriasOficiales;
  final List<Subcategoria> subcategorias;
  final List<ActividadProductiva> actividadesProductivas;
  final String municipio;
  final String? direccion;
  final double? latitud;
  final double? longitud;
  final String descripcionCorta;
  final String descripcion;
  final String? telefono;
  final String whatsapp;
  final String? email;
  final String? sitioWeb;
  final String? facebookUrl;
  final String? instagramUrl;
  final String? fotoPortadaUrl;
  final String? fotoPortadaPath;
  final bool destacado;
  final bool activo;
  /// Reconocimiento público — "Negocio avalado por la CDMB". Reemplaza al
  /// viejo enum nivel_desarrollo (en_verificacion/verificado/negocio_ancla):
  /// ahora es un booleano independiente, igual que [selloMarca] y
  /// [avalConfianza] (ver 0020_avalado_y_emprendimiento_verde.sql).
  final bool avalado;
  /// Reconocimiento adicional e independiente de [avalado] — un negocio
  /// puede estar avalado Y tener el Sello Marca de Negocios Verdes a la
  /// vez, no es un nivel excluyente (ver
  /// 0018_sello_marca_negocios_verdes.sql).
  final bool selloMarca;
  /// Igual de independiente que [selloMarca] — CDMB usa "Aval de
  /// Confianza" en sus propios comunicados de prensa para el
  /// reconocimiento base, no confirmado todavía si es sinónimo exacto de
  /// [avalado]. Campo aparte a propósito (ver
  /// 0019_aval_confianza_negocios_verdes.sql).
  final bool avalConfianza;
  /// SOLO uso interno de CDMB — negocios no avalados o en proceso.
  /// Seleccionable desde /admin, pero a propósito NUNCA se muestra en la
  /// ficha pública ni es filtrable en /buscar (ver
  /// 0020_avalado_y_emprendimiento_verde.sql).
  final bool emprendimientoVerde;
  final List<NegocioFoto> fotos;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Negocio({
    required this.id,
    required this.nombre,
    required this.slug,
    required this.categoriaOficialId,
    this.categoriaOficial,
    this.categoriasOficiales = const [],
    this.subcategorias = const [],
    this.actividadesProductivas = const [],
    required this.municipio,
    this.direccion,
    this.latitud,
    this.longitud,
    required this.descripcionCorta,
    required this.descripcion,
    this.telefono,
    required this.whatsapp,
    this.email,
    this.sitioWeb,
    this.facebookUrl,
    this.instagramUrl,
    this.fotoPortadaUrl,
    this.fotoPortadaPath,
    this.destacado = false,
    this.activo = false,
    this.avalado = false,
    this.selloMarca = false,
    this.avalConfianza = false,
    this.emprendimientoVerde = false,
    this.fotos = const [],
    this.createdAt,
    this.updatedAt,
  });

  bool get tieneUbicacion => latitud != null && longitud != null;

  factory Negocio.fromJson(Map<String, dynamic> json) {
    final categoriaJson = _desenvolverUno(json['categorias_oficiales']);
    final fotosJson = _desenvolverLista(json['negocio_fotos']);
    final subcategoriasJoin = _desenvolverLista(json['negocios_subcategorias']);
    final categoriasJoin = _desenvolverLista(json['negocios_categorias']);
    final actividadesJoin = _desenvolverLista(json['negocios_actividades']);

    return Negocio(
      id: json['id']?.toString() ?? '',
      nombre: json['nombre']?.toString() ?? '',
      slug: json['slug']?.toString() ?? '',
      categoriaOficialId: json['categoria_oficial_id']?.toString() ?? '',
      categoriaOficial:
          categoriaJson != null ? CategoriaOficial.fromJson(categoriaJson) : null,
      categoriasOficiales: categoriasJoin
          .map((e) => _desenvolverUno(e['categorias_oficiales']))
          .whereType<Map<String, dynamic>>()
          .map(CategoriaOficial.fromJson)
          .toList(),
      subcategorias: subcategoriasJoin
          .map((e) => _desenvolverUno(e['subcategorias']))
          .whereType<Map<String, dynamic>>()
          .map(Subcategoria.fromJson)
          .toList(),
      actividadesProductivas: actividadesJoin
          .map((e) => _desenvolverUno(e['actividades_productivas']))
          .whereType<Map<String, dynamic>>()
          .map(ActividadProductiva.fromJson)
          .toList(),
      municipio: json['municipio']?.toString() ?? '',
      direccion: json['direccion']?.toString(),
      latitud: (json['latitud'] as num?)?.toDouble(),
      longitud: (json['longitud'] as num?)?.toDouble(),
      descripcionCorta: json['descripcion_corta']?.toString() ?? '',
      descripcion: json['descripcion']?.toString() ?? '',
      telefono: json['telefono']?.toString(),
      whatsapp: json['whatsapp']?.toString() ?? '',
      email: json['email']?.toString(),
      sitioWeb: json['sitio_web']?.toString(),
      facebookUrl: json['facebook_url']?.toString(),
      instagramUrl: json['instagram_url']?.toString(),
      fotoPortadaUrl: json['foto_portada_url']?.toString(),
      fotoPortadaPath: json['foto_portada_path']?.toString(),
      destacado: json['destacado'] as bool? ?? false,
      activo: json['activo'] as bool? ?? false,
      avalado: json['avalado'] as bool? ?? false,
      selloMarca: json['sello_marca'] as bool? ?? false,
      avalConfianza: json['aval_confianza'] as bool? ?? false,
      emprendimientoVerde: json['emprendimiento_verde'] as bool? ?? false,
      fotos: fotosJson.map(NegocioFoto.fromJson).toList()
        ..sort((a, b) => a.orden.compareTo(b.orden)),
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? ''),
      updatedAt: DateTime.tryParse(json['updated_at']?.toString() ?? ''),
    );
  }

  /// Solo los campos que la UI realmente muta localmente (toggles rápidos
  /// desde el listado admin) — el formulario de crear/editar arma sus
  /// propios parámetros para la RPC guardar_negocio en vez de copyWith-ear
  /// esta clase entera.
  Negocio copyWith({bool? activo, bool? destacado}) {
    return Negocio(
      id: id,
      nombre: nombre,
      slug: slug,
      categoriaOficialId: categoriaOficialId,
      categoriaOficial: categoriaOficial,
      categoriasOficiales: categoriasOficiales,
      subcategorias: subcategorias,
      actividadesProductivas: actividadesProductivas,
      municipio: municipio,
      direccion: direccion,
      latitud: latitud,
      longitud: longitud,
      descripcionCorta: descripcionCorta,
      descripcion: descripcion,
      telefono: telefono,
      whatsapp: whatsapp,
      email: email,
      sitioWeb: sitioWeb,
      facebookUrl: facebookUrl,
      instagramUrl: instagramUrl,
      fotoPortadaUrl: fotoPortadaUrl,
      fotoPortadaPath: fotoPortadaPath,
      destacado: destacado ?? this.destacado,
      activo: activo ?? this.activo,
      avalado: avalado,
      selloMarca: selloMarca,
      avalConfianza: avalConfianza,
      emprendimientoVerde: emprendimientoVerde,
      fotos: fotos,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
