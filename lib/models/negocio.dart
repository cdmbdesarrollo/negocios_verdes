import 'actividad_productiva.dart';
import 'categoria_oficial.dart';
import 'negocio_foto.dart';
import 'subcategoria.dart';
import 'vereda.dart';

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
  /// Público (pedido explícito de CDMB) — a diferencia de [municipio], que
  /// es un catálogo fijo, vereda es editable (ver 0021_veredas.sql y
  /// VeredaService). [vereda] solo llega poblado cuando el negocio se cargó
  /// con el embed correspondiente (ver _selectPublico/_selectConEmbeds en
  /// NegocioService).
  final String? veredaId;
  final Vereda? vereda;
  final String? direccion;
  final double? latitud;
  final double? longitud;
  final String? descripcionCorta;
  final String? descripcion;
  /// Público — qué vende/ofrece el negocio en concreto (ej. "Agua natural
  /// 300 cc"), más específico que [descripcion].
  final String? producto;
  final String? telefono;
  /// Segundo número de contacto (ver 0028_telefono_secundario.sql) — antes
  /// se pegaban los dos en [telefono] con un guion, lo que rompía el link
  /// de WhatsApp.
  final String? telefonoSecundario;
  /// Ya no es obligatorio (ver 0022_ficha_ampliada_negocios.sql): la base
  /// real de CDMB trae muchos negocios sin WhatsApp capturado todavía, se
  /// completa después desde /admin/negocios. Se guarda con indicativo país
  /// (57…) para que el botón de WhatsApp funcione.
  final String? whatsapp;
  final String? email;
  final String? sitioWeb;
  final String? facebookUrl;
  final String? instagramUrl;
  final String? fotoPortadaUrl;
  final String? fotoPortadaPath;
  /// Público — nombre de quien representa legalmente al negocio (pedido
  /// explícito de CDMB).
  final String? representanteLegal;
  /// Admin-only, NUNCA se expone en el select público (ver
  /// NegocioService._selectPublico): para una persona Natural el NIT suele
  /// ser su número de cédula, un dato personal sensible.
  final String? nit;
  final String? naturalezaJuridica;
  final bool destacado;
  final bool activo;
  /// Las 3 categorías de reconocimiento de CDMB (ver
  /// 0022_ficha_ampliada_negocios.sql) son independientes entre sí — un
  /// negocio puede tener 1, 2 o las 3 a la vez, reemplazan al viejo
  /// nivel_desarrollo (enum de 3 valores excluyentes que no reflejaba la
  /// realidad) y a aval_confianza (fold-in de "avalado").
  final bool emprendimientoVerde;
  final bool selloMarca;
  final bool avalado;
  /// Admin-only — clasificación de madurez de CDMB (Dinamizadoras/Inicial/
  /// Intermedio/Avanzado/...), un eje aparte de los 3 reconocimientos.
  final String? tipoNegocioVerde;
  /// Admin-only — estado original tal cual venía en la base de CDMB
  /// (ACTIVO/RETIRADO/SUSPENDIDO/...), para auditoría y filtro admin.
  /// [activo] (arriba) sigue siendo la única fuente de verdad de qué se
  /// publica.
  final String? novedad;
  final int? anioRegistro;
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
    this.veredaId,
    this.vereda,
    this.direccion,
    this.latitud,
    this.longitud,
    this.descripcionCorta,
    this.descripcion,
    this.producto,
    this.telefono,
    this.telefonoSecundario,
    this.whatsapp,
    this.email,
    this.sitioWeb,
    this.facebookUrl,
    this.instagramUrl,
    this.fotoPortadaUrl,
    this.fotoPortadaPath,
    this.representanteLegal,
    this.nit,
    this.naturalezaJuridica,
    this.destacado = false,
    this.activo = false,
    this.emprendimientoVerde = false,
    this.selloMarca = false,
    this.avalado = false,
    this.tipoNegocioVerde,
    this.novedad,
    this.anioRegistro,
    this.fotos = const [],
    this.createdAt,
    this.updatedAt,
  });

  bool get tieneUbicacion => latitud != null && longitud != null;

  factory Negocio.fromJson(Map<String, dynamic> json) {
    final categoriaJson = _desenvolverUno(json['categorias_oficiales']);
    final veredaJson = _desenvolverUno(json['veredas']);
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
      veredaId: json['vereda_id']?.toString(),
      vereda: veredaJson != null ? Vereda.fromJson(veredaJson) : null,
      direccion: json['direccion']?.toString(),
      latitud: (json['latitud'] as num?)?.toDouble(),
      longitud: (json['longitud'] as num?)?.toDouble(),
      descripcionCorta: json['descripcion_corta']?.toString(),
      descripcion: json['descripcion']?.toString(),
      producto: json['producto']?.toString(),
      telefono: json['telefono']?.toString(),
      telefonoSecundario: json['telefono_secundario']?.toString(),
      whatsapp: json['whatsapp']?.toString(),
      email: json['email']?.toString(),
      sitioWeb: json['sitio_web']?.toString(),
      facebookUrl: json['facebook_url']?.toString(),
      instagramUrl: json['instagram_url']?.toString(),
      fotoPortadaUrl: json['foto_portada_url']?.toString(),
      fotoPortadaPath: json['foto_portada_path']?.toString(),
      representanteLegal: json['representante_legal']?.toString(),
      nit: json['nit']?.toString(),
      naturalezaJuridica: json['naturaleza_juridica']?.toString(),
      destacado: json['destacado'] as bool? ?? false,
      activo: json['activo'] as bool? ?? false,
      emprendimientoVerde: json['emprendimiento_verde'] as bool? ?? false,
      selloMarca: json['sello_marca'] as bool? ?? false,
      avalado: json['avalado'] as bool? ?? false,
      tipoNegocioVerde: json['tipo_negocio_verde']?.toString(),
      novedad: json['novedad']?.toString(),
      anioRegistro: (json['anio_registro'] as num?)?.toInt(),
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
      veredaId: veredaId,
      vereda: vereda,
      direccion: direccion,
      latitud: latitud,
      longitud: longitud,
      descripcionCorta: descripcionCorta,
      descripcion: descripcion,
      producto: producto,
      telefono: telefono,
      telefonoSecundario: telefonoSecundario,
      whatsapp: whatsapp,
      email: email,
      sitioWeb: sitioWeb,
      facebookUrl: facebookUrl,
      instagramUrl: instagramUrl,
      fotoPortadaUrl: fotoPortadaUrl,
      fotoPortadaPath: fotoPortadaPath,
      representanteLegal: representanteLegal,
      nit: nit,
      naturalezaJuridica: naturalezaJuridica,
      destacado: destacado ?? this.destacado,
      activo: activo ?? this.activo,
      emprendimientoVerde: emprendimientoVerde,
      selloMarca: selloMarca,
      avalado: avalado,
      tipoNegocioVerde: tipoNegocioVerde,
      novedad: novedad,
      anioRegistro: anioRegistro,
      fotos: fotos,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
