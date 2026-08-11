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

/// Datos de contacto institucionales de la CDMB, verificados directamente
/// en su Sede Electrónica (micolombiadigital.gov.co) el 2026-08-11 —
/// Negocios Verdes es un micrositio de esa página, así que reutiliza los
/// mismos datos en vez de mantener una segunda fuente de verdad en
/// PiePagina y en ContactoPage. Si la CDMB cambia algún dato (teléfono,
/// horario, redes), actualizar solo aquí.
const String kCdmbDireccion =
    'Carrera 23 # 37 - 63, Bucaramanga, Santander, Colombia';
const String kCdmbHorario =
    'Lunes a viernes de 7:30 a.m. a 11:45 a.m. y 2 p.m. a 5:45 p.m.';
const String kCdmbTelefonoConmutador = '+57 (607) 6970241';
const String kCdmbTelefonoMovil = '+57 318 706 9866';
const String kCdmbLineaGratuita = '01 8000 180 527';
const String kCdmbCorreoInstitucional = 'info@cdmb.gov.co';

const String kCdmbFacebookUrl =
    'https://www.facebook.com/profile.php?id=100075845605762';
const String kCdmbTwitterUrl = 'https://twitter.com/CARCDMB';
const String kCdmbYoutubeUrl =
    'https://www.youtube.com/channel/UCiYntF63C_9-m5jr7t6b69w';
const String kCdmbInstagramUrl = 'https://www.instagram.com/carcdmb';
