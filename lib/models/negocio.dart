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
  final String nivelDesarrollo;
  final bool destacado;
  final bool activo;
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
    this.nivelDesarrollo = 'en_verificacion',
    this.destacado = false,
    this.activo = false,
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
      nivelDesarrollo: json['nivel_desarrollo']?.toString() ?? 'en_verificacion',
      destacado: json['destacado'] as bool? ?? false,
      activo: json['activo'] as bool? ?? false,
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
      nivelDesarrollo: nivelDesarrollo,
      destacado: destacado ?? this.destacado,
      activo: activo ?? this.activo,
      fotos: fotos,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
