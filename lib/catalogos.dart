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

/// Las 3 categorías de reconocimiento de negocios (ver
/// 0022_ficha_ampliada_negocios.sql: emprendimiento_verde/sello_marca/
/// avalado) son 3 booleanos independientes, no un enum — reemplazan al
/// viejo nivel_desarrollo (en_verificacion/verificado/negocio_ancla) que
/// forzaba una sola opción excluyente y no reflejaba los datos reales de
/// CDMB (un negocio puede tener más de una a la vez). Sin catálogo fijo
/// que mantener acá: cada insignia es su propio widget (ver
/// core/widgets/emprendimiento_verde_badge.dart, sello_marca_badge.dart,
/// avalado_badge.dart) con su etiqueta ya fija en el propio widget.

/// Naturaleza jurídica del titular del negocio — determina si el NIT/CC se
/// puede mostrar públicamente (ver negocios.naturaleza_juridica): para una
/// persona NATURAL el NIT suele ser literalmente su número de cédula, un
/// dato personal sensible (habeas data, Ley 1581/2012 en Colombia) — por
/// eso el NIT nunca se muestra en la ficha pública, sin importar la
/// naturaleza jurídica (ver negocio_detalle_page.dart).
const List<String> kNaturalezasJuridicas = ['Natural', 'Jurídica'];

/// Tipos de documento de identidad para las bases de personas (responsables
/// CDMB, delegados, representantes legales — ver PersonasService / 0031).
/// Lista guía para el desplegable; si un dato viejo trae otro valor se
/// muestra igual, no se pierde.
const List<String> kTiposDocumento = [
  'Cédula de ciudadanía',
  'Cédula de extranjería',
  'NIT',
  'Pasaporte',
  'Tarjeta de identidad',
  'Permiso por Protección Temporal (PPT)',
  'Otro',
];

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
