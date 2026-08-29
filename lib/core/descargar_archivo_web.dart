import 'dart:js_interop';

import 'package:web/web.dart' as web;

import 'negocios_csv.dart';
import '../models/negocio.dart';

/// Disparadores de descarga en el navegador — package:web (dart:js_interop),
/// no dart:html, mismo criterio que seo_tags.dart. Separado a propósito de
/// negocios_csv.dart: ese archivo es lógica pura testeable con `flutter
/// test` normal (VM); este, al tocar el navegador, solo puede probarse de
/// verdad con --platform chrome o a mano en la app.

/// Dispara la descarga de [contenido] como archivo — Blob + ancla temporal
/// que se clickea sola y se descarta.
void descargarArchivoTexto({
  required String contenido,
  required String nombreArchivo,
  required String tipoMime,
}) {
  final blob = web.Blob(
    [contenido.toJS].toJS,
    web.BlobPropertyBag(type: tipoMime),
  );
  final url = web.URL.createObjectURL(blob);
  final ancla = web.HTMLAnchorElement()
    ..href = url
    ..download = nombreArchivo;
  web.document.body?.appendChild(ancla);
  ancla.click();
  ancla.remove();
  web.URL.revokeObjectURL(url);
}

String _dosDigitos(int n) => n.toString().padLeft(2, '0');

/// Arma el CSV de [negocios] (ver negocios_csv.dart) y dispara su descarga
/// con un nombre de archivo fechado.
void exportarNegociosComoCsv(List<Negocio> negocios) {
  final hoy = DateTime.now();
  final nombreArchivo = 'negocios_verdes_'
      '${hoy.year}${_dosDigitos(hoy.month)}${_dosDigitos(hoy.day)}.csv';
  descargarArchivoTexto(
    contenido: construirCsvNegocios(negocios),
    nombreArchivo: nombreArchivo,
    tipoMime: 'text/csv;charset=utf-8',
  );
}
