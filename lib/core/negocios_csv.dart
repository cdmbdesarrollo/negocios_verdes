import 'package:csv/csv.dart';

import '../catalogos.dart';
import '../models/actividad_productiva.dart';
import '../models/categoria_oficial.dart';
import '../models/negocio.dart';
import '../models/subcategoria.dart';

/// Lógica de CSV de negocios — pura, sin nada de package:web/dart:js_interop
/// a propósito, para poder testearla con `flutter test` normal (VM), sin
/// necesitar --platform chrome. El disparador de descarga en el navegador
/// vive aparte, en descargar_archivo_web.dart.
///
/// Encabezados del CSV de negocios, en el mismo orden que las columnas de
/// exportación e importación — una sola fuente de verdad para que ambos
/// lados nunca queden desalineados. categorias/subcategorias/
/// actividades_productivas van separadas por "|" (varias por negocio); las
/// últimas 4 (activo/id/slug/creado) son solo de referencia: exportar()
/// las llena con el estado real, pero importar() las ignora por completo
/// (un negocio importado siempre nace oculto, sin id/slug propios todavía).
const List<String> kEncabezadosCsvNegocio = [
  'nombre',
  'municipio',
  'categorias',
  'subcategorias',
  'actividades_productivas',
  'direccion',
  'latitud',
  'longitud',
  'descripcion_corta',
  'descripcion',
  'telefono',
  'whatsapp',
  'email',
  'sitio_web',
  'facebook_url',
  'instagram_url',
  'avalado',
  'sello_marca',
  'emprendimiento_verde',
  'destacado',
  'activo',
  'id',
  'slug',
];

String _siONo(bool valor) => valor ? 'SI' : 'NO';

List<CategoriaOficial> _categoriasDe(Negocio n) => n.categoriasOficiales.isNotEmpty
    ? n.categoriasOficiales
    : [if (n.categoriaOficial != null) n.categoriaOficial!];

/// Arma el CSV completo (encabezado + una fila por negocio) — usa el
/// preset "Excel" del paquete csv (delimitador ";" y BOM UTF-8) porque el
/// público de este archivo es personal de la CDMB abriéndolo directo en
/// Excel en español, donde "," ya es el separador decimal.
String construirCsvNegocios(List<Negocio> negocios) {
  final filas = <List<dynamic>>[
    kEncabezadosCsvNegocio,
    for (final n in negocios)
      [
        n.nombre,
        n.municipio,
        _categoriasDe(n).map((c) => c.nombre).join('|'),
        n.subcategorias.map((s) => s.nombre).join('|'),
        n.actividadesProductivas.map((a) => a.nombre).join('|'),
        n.direccion ?? '',
        n.latitud?.toString() ?? '',
        n.longitud?.toString() ?? '',
        n.descripcionCorta,
        n.descripcion,
        n.telefono ?? '',
        n.whatsapp,
        n.email ?? '',
        n.sitioWeb ?? '',
        n.facebookUrl ?? '',
        n.instagramUrl ?? '',
        _siONo(n.avalado),
        _siONo(n.selloMarca),
        _siONo(n.emprendimientoVerde),
        _siONo(n.destacado),
        _siONo(n.activo),
        n.id,
        n.slug,
      ],
  ];
  return Csv.excel().encode(filas);
}

/// Un negocio ya validado, listo para pasarle a NegocioService.guardar().
/// Siempre nace oculto (sin foto de portada todavía) — activo se decide
/// después, a mano, cuando alguien suba la foto desde el formulario admin.
class NegocioParaImportar {
  final String nombre;
  final String municipio;
  final List<String> categoriaIds;
  final List<String> subcategoriaIds;
  final List<String> actividadIds;
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
  final bool avalado;
  final bool selloMarca;
  final bool emprendimientoVerde;
  final bool destacado;

  const NegocioParaImportar({
    required this.nombre,
    required this.municipio,
    required this.categoriaIds,
    required this.subcategoriaIds,
    required this.actividadIds,
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
    required this.avalado,
    required this.selloMarca,
    required this.emprendimientoVerde,
    required this.destacado,
  });
}

/// Resultado de validar una fila del CSV — [datos] solo viene lleno cuando
/// [errores] está vacío; [seleccionada] es el estado del check en la vista
/// previa (arranca en true solo si la fila es válida).
class FilaImportada {
  final int numeroFila;
  final String nombreMostrado;
  final List<String> errores;
  final List<String> advertencias;
  final NegocioParaImportar? datos;
  bool seleccionada;

  FilaImportada({
    required this.numeroFila,
    required this.nombreMostrado,
    required this.errores,
    required this.advertencias,
    required this.datos,
  }) : seleccionada = errores.isEmpty;

  bool get esValida => errores.isEmpty;
}

List<String> _dividirLista(String texto) =>
    texto.split('|').map((s) => s.trim()).where((s) => s.isNotEmpty).toList();

String? _vacioANulo(String texto) => texto.trim().isEmpty ? null : texto.trim();

/// Decodifica y valida el CSV completo, fila por fila — nunca lanza por un
/// dato inválido: cada problema queda en FilaImportada.errores para que la
/// vista previa se lo muestre al admin antes de crear nada. autoDetect
/// (default del paquete) hace que sirva tanto el "," estándar como el ";"
/// que exporta Excel en español.
List<FilaImportada> interpretarCsvNegocios(
  String contenidoCsv, {
  required List<CategoriaOficial> categorias,
  required List<Subcategoria> subcategorias,
  required List<ActividadProductiva> actividades,
  required List<Negocio> negociosExistentes,
}) {
  var contenido = contenidoCsv;
  if (contenido.startsWith('﻿')) contenido = contenido.substring(1);
  if (contenido.trim().isEmpty) return const [];

  final filas = Csv().decodeWithHeaders(contenido);
  final nombresExistentes =
      negociosExistentes.map((n) => n.nombre.trim().toLowerCase()).toSet();

  return [
    for (final (i, fila) in filas.indexed)
      _interpretarFila(
        fila,
        numeroFila: i + 2, // la fila 1 es el encabezado
        categorias: categorias,
        subcategorias: subcategorias,
        actividades: actividades,
        nombresExistentes: nombresExistentes,
      ),
  ];
}

FilaImportada _interpretarFila(
  CsvRow fila, {
  required int numeroFila,
  required List<CategoriaOficial> categorias,
  required List<Subcategoria> subcategorias,
  required List<ActividadProductiva> actividades,
  required Set<String> nombresExistentes,
}) {
  String texto(String columna) => (fila[columna]?.toString() ?? '').trim();
  bool booleano(String columna) {
    final v = texto(columna).toLowerCase();
    return v == 'si' || v == 'sí' || v == 's' || v == 'true' || v == '1' || v == 'x';
  }

  final errores = <String>[];
  final advertencias = <String>[];

  final nombre = texto('nombre');
  if (nombre.isEmpty) errores.add('Falta el nombre del negocio.');
  if (nombre.isNotEmpty && nombresExistentes.contains(nombre.toLowerCase())) {
    advertencias.add(
        'Ya existe un negocio con este nombre — revisa que no sea un duplicado.');
  }

  final municipioTexto = texto('municipio');
  String? municipio;
  if (municipioTexto.isEmpty) {
    errores.add('Falta el municipio.');
  } else {
    for (final m in kMunicipios) {
      if (m.toLowerCase() == municipioTexto.toLowerCase()) {
        municipio = m;
        break;
      }
    }
    if (municipio == null) {
      errores.add('Municipio desconocido: "$municipioTexto". Debe ser uno de '
          'los 13 de la jurisdicción CDMB.');
    }
  }

  final categoriaIds = <String>[];
  final categoriasDesconocidas = <String>[];
  for (final nombreCategoria in _dividirLista(texto('categorias'))) {
    final match = categorias
        .where((c) => c.nombre.toLowerCase() == nombreCategoria.toLowerCase());
    if (match.isEmpty) {
      categoriasDesconocidas.add(nombreCategoria);
    } else {
      categoriaIds.add(match.first.id);
    }
  }
  if (categoriaIds.isEmpty) {
    errores.add('Falta al menos una categoría oficial válida.');
  }
  if (categoriaIds.length > 3) {
    errores.add('Máximo 3 categorías oficiales (hay ${categoriaIds.length}).');
  }
  if (categoriasDesconocidas.isNotEmpty) {
    errores.add('Categoría(s) desconocida(s): ${categoriasDesconocidas.join(", ")}.');
  }

  final subcategoriaIds = <String>[];
  final subcategoriasDesconocidas = <String>[];
  for (final nombreSub in _dividirLista(texto('subcategorias'))) {
    final match =
        subcategorias.where((s) => s.nombre.toLowerCase() == nombreSub.toLowerCase());
    if (match.isEmpty) {
      subcategoriasDesconocidas.add(nombreSub);
    } else {
      subcategoriaIds.add(match.first.id);
    }
  }
  if (subcategoriasDesconocidas.isNotEmpty) {
    errores.add(
        'Subcategoría(s) desconocida(s): ${subcategoriasDesconocidas.join(", ")}.');
  }

  final actividadIds = <String>[];
  final actividadesDesconocidas = <String>[];
  for (final nombreAct in _dividirLista(texto('actividades_productivas'))) {
    final match =
        actividades.where((a) => a.nombre.toLowerCase() == nombreAct.toLowerCase());
    if (match.isEmpty) {
      actividadesDesconocidas.add(nombreAct);
    } else {
      actividadIds.add(match.first.id);
    }
  }
  if (actividadesDesconocidas.isNotEmpty) {
    errores
        .add('Actividad(es) desconocida(s): ${actividadesDesconocidas.join(", ")}.');
  }

  double? latitud;
  final latitudTexto = texto('latitud');
  if (latitudTexto.isNotEmpty) {
    latitud = double.tryParse(latitudTexto.replaceAll(',', '.'));
    if (latitud == null) errores.add('Latitud inválida: "$latitudTexto".');
  }
  double? longitud;
  final longitudTexto = texto('longitud');
  if (longitudTexto.isNotEmpty) {
    longitud = double.tryParse(longitudTexto.replaceAll(',', '.'));
    if (longitud == null) errores.add('Longitud inválida: "$longitudTexto".');
  }

  final descripcionCorta = texto('descripcion_corta');
  if (descripcionCorta.isEmpty) errores.add('Falta la descripción corta.');
  final descripcion = texto('descripcion');
  if (descripcion.isEmpty) errores.add('Falta la descripción completa.');

  final whatsapp = texto('whatsapp').replaceAll(RegExp(r'[^0-9]'), '');
  if (whatsapp.isEmpty) errores.add('Falta el WhatsApp (obligatorio).');

  final datos = errores.isNotEmpty
      ? null
      : NegocioParaImportar(
          nombre: nombre,
          municipio: municipio!,
          categoriaIds: categoriaIds,
          subcategoriaIds: subcategoriaIds,
          actividadIds: actividadIds,
          direccion: _vacioANulo(texto('direccion')),
          latitud: latitud,
          longitud: longitud,
          descripcionCorta: descripcionCorta,
          descripcion: descripcion,
          telefono: _vacioANulo(texto('telefono')),
          whatsapp: whatsapp,
          email: _vacioANulo(texto('email')),
          sitioWeb: _vacioANulo(texto('sitio_web')),
          facebookUrl: _vacioANulo(texto('facebook_url')),
          instagramUrl: _vacioANulo(texto('instagram_url')),
          avalado: booleano('avalado'),
          selloMarca: booleano('sello_marca'),
          emprendimientoVerde: booleano('emprendimiento_verde'),
          destacado: booleano('destacado'),
        );

  return FilaImportada(
    numeroFila: numeroFila,
    nombreMostrado: nombre.isEmpty ? '(sin nombre) fila $numeroFila' : nombre,
    errores: errores,
    advertencias: advertencias,
    datos: datos,
  );
}
