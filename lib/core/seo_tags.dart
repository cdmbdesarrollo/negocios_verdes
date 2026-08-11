import 'package:web/web.dart' as web;

/// Actualiza (nunca duplica) el <title> y las meta tags de SEO/redes
/// sociales de la página actual. Usa package:web (dart:js_interop), no
/// dart:html — proyecto nuevo, sin deuda técnica que migrar.
///
/// Esto solo cubre crawlers que ejecutan JavaScript. Bots que no lo hacen
/// (varios previsualizadores, notablemente el de WhatsApp) no ven estos
/// cambios — por eso web/index.html trae valores por defecto fuertes, y el
/// pre-renderizado real por negocio queda para una fase futura (ver plan).
void establecerSeo({
  required String titulo,
  required String descripcion,
  String? imagenUrl,
}) {
  web.document.title = titulo;

  _upsertMeta(name: 'description', content: descripcion);
  _upsertMeta(property: 'og:title', content: titulo);
  _upsertMeta(property: 'og:description', content: descripcion);
  _upsertMeta(name: 'twitter:title', content: titulo);
  _upsertMeta(name: 'twitter:description', content: descripcion);

  if (imagenUrl != null && imagenUrl.isNotEmpty) {
    _upsertMeta(property: 'og:image', content: imagenUrl);
    _upsertMeta(name: 'twitter:image', content: imagenUrl);
  }
}

void _upsertMeta({String? name, String? property, required String content}) {
  assert(
    (name == null) != (property == null),
    'Pasa exactamente uno de name/property',
  );

  final selector =
      name != null ? 'meta[name="$name"]' : 'meta[property="$property"]';

  // querySelectorAll (no querySelector): si por error quedaron dos tags
  // iguales, se corrigen las dos en vez de dejar la segunda huérfana — el
  // bug real que rompió el snippet de Google en HuellaQR fue justo ese.
  final existentes = web.document.querySelectorAll(selector);
  if (existentes.length > 0) {
    for (var i = 0; i < existentes.length; i++) {
      // NodeList.item() devuelve Node? (no Element?). Un cast directo
      // alcanza: querySelectorAll('meta[...]') solo puede devolver
      // elementos <meta>, nunca otro tipo de Node.
      (existentes.item(i) as web.Element?)?.setAttribute('content', content);
    }
    return;
  }

  final meta = web.HTMLMetaElement();
  if (name != null) {
    meta.name = name;
  } else {
    meta.setAttribute('property', property!);
  }
  meta.content = content;
  web.document.head?.appendChild(meta);
}
