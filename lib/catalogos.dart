/// Fuente única de verdad para catálogos fijos que NO se editan desde el
/// panel admin (si algo necesita edición desde /admin, va en una tabla de
/// Supabase, no aquí — ver categorias_oficiales/subcategorias).
library;

/// Los 13 municipios de la jurisdicción CDMB. Deben coincidir carácter por
/// carácter (con tildes) con el CHECK de la columna "municipio" en
/// lib/migraciones/0004_negocios.sql — si se edita uno, editar el otro.
const List<String> kMunicipios = [
  'Bucaramanga',
  'Floridablanca',
  'Girón',
  'Piedecuesta',
  'Vetas',
  'California',
  'Suratá',
  'Matanza',
  'Charta',
  'Tona',
  'El Playón',
  'Rionegro',
  'Lebrija',
];

/// Valores que puede tomar negocios.nivel_desarrollo (mismo CHECK en SQL) y
/// su etiqueta visible para el público.
const Map<String, String> kNivelesDesarrolloEtiqueta = {
  'en_verificacion': 'En verificación',
  'verificado': 'Verificado',
  'negocio_ancla': 'Negocio Ancla',
};

/// Texto de apoyo para el admin al elegir el nivel en el formulario.
const Map<String, String> kNivelesDesarrolloAyuda = {
  'en_verificacion':
      'Emprendimiento en proceso de verificación por parte de CDMB.',
  'verificado': 'Cumple los criterios del programa y ya fue verificado.',
  'negocio_ancla': 'Negocio verde consolidado, referente en su categoría.',
};

/// Mensaje precargado al abrir el botón de WhatsApp desde la ficha pública.
String mensajeWhatsappPredeterminado(String nombreNegocio) =>
    'Hola, te vi en el directorio de Negocios Verdes CDMB ($nombreNegocio) '
    'y quiero más información.';
