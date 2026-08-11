/// Utilidades de texto compartidas por el buscador y por la sugerencia de
/// slug del formulario admin.
library;

const Map<String, String> _tildes = {
  'á': 'a', 'é': 'e', 'í': 'i', 'ó': 'o', 'ú': 'u', 'ñ': 'n', 'ü': 'u',
  'Á': 'A', 'É': 'E', 'Í': 'I', 'Ó': 'O', 'Ú': 'U', 'Ñ': 'N', 'Ü': 'U',
};

/// Quita tildes/diéresis y normaliza la ñ a n, igual que
/// immutable_unaccent() en SQL (lib/migraciones/0001_...). Se usa para que
/// el término de búsqueda que manda el cliente coincida con la columna
/// "busqueda" ya des-tildada — si un lado se des-tilda y el otro no, buscar
/// "giron" sin tilde nunca encuentra "Girón".
String quitarTildes(String texto) {
  var resultado = texto;
  _tildes.forEach((con, sin) {
    resultado = resultado.replaceAll(con, sin);
  });
  return resultado;
}

/// Sugerencia de slug amigable para URL a partir de un texto libre (nombre
/// de negocio, categoría, etc.). Es solo la sugerencia inicial que ve el
/// admin en el formulario — la unicidad real la garantiza el servidor
/// (generar_slug_unico en 0007_rpc_guardar_negocio.sql).
String generarSlug(String texto) {
  final sinTildes = quitarTildes(texto.toLowerCase());
  final limpio = sinTildes.replaceAll(RegExp(r'[^a-z0-9]+'), '-');
  return limpio.replaceAll(RegExp(r'^-+|-+$'), '');
}
