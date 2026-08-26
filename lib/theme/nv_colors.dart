import 'package:flutter/material.dart';

/// Paleta de Negocios Verdes CDMB. Todo el árbol de widgets debe consumir
/// estas constantes (nunca colores sueltos) para que un cambio de marca sea
/// un solo archivo, igual que PawColors en HuellaQR.
///
/// Convención de uso: [primary] para marca/navegación, [accent] SOLO para
/// llamados a la acción de conversión (nunca para decoración), [whatsapp]
/// SOLO para el botón de WhatsApp (color de marca reconocible, no se reusa
/// como acento genérico). Sin texto de CTA en mayúsculas sostenidas.
abstract final class NVColors {
  // Verde institucional real de la CDMB (#038F67) — tomado directo de su
  // Sede Electrónica (micolombiadigital.gov.co), donde es el color del
  // ítem de navegación activo y de la franja inferior del pie de página.
  // Negocios Verdes es un micrositio de esa página, por eso el primary ya
  // no es un verde inventado sino el verde real de la entidad.
  static const Color primary = Color(0xFF038F67);
  static const Color primaryDark = Color(0xFF026B4D);
  static const Color primaryLight = Color(0xFFDCEEE6);

  // Naranja de la campaña de la Feria Regional de Negocios Verdes (banner
  // oficial, valores RGB confirmados por CDMB: #FF8623). accentDark es ese
  // mismo tono escalado ~80%, mismo criterio que ya tenía el naranja
  // anterior con el suyo.
  static const Color accent = Color(0xFFFF8623);
  static const Color accentDark = Color(0xFFCC6B1C);

  /// Verde vivo de la misma campaña (#01BD32, también confirmado por
  /// CDMB) — deliberadamente NO reemplaza a [primary] (ese sigue siendo el
  /// institucional real de la Sede Electrónica): es un segundo verde para
  /// piezas nuevas/de campaña, pensado para bordes, íconos y como ancla
  /// clara de un degradado — no para texto blanco encima a tamaño chico,
  /// su luminancia es alta y el contraste con blanco queda por debajo de
  /// lo institucional (~2.5:1 vs. ~4:1 de [primary]).
  static const Color verdeVivo = Color(0xFF01BD32);

  /// Segundo verde de campaña, confirmado por CDMB específicamente para los
  /// menús (navbar público + sidebar admin) — distinto de [verdeVivo], que
  /// cubre el resto del sitio (chips, botones, íconos). Mismo criterio de
  /// contraste: su luminancia es alta (más aún que [verdeVivo]), así que va
  /// siempre con texto oscuro encima, nunca blanco.
  static const Color verdeMenu = Color(0xFF85C800);

  /// Azul de la franja superior obligatoria de GOV.CO — NO es parte de la
  /// paleta propia de la marca, es el color que trae la franja institucional
  /// de gov.co en la Sede Electrónica de la CDMB (de la que este sitio es
  /// micrositio). Se usa solo en esa franja, en ningún otro lado.
  static const Color govCoAzul = Color(0xFF3366CC);

  static const Color fondo = Color(0xFFFAF8F3);
  static const Color superficie = Color(0xFFFFFFFF);

  static const Color textoPrincipal = Color(0xFF1B2A20);
  static const Color textoSecundario = Color(0xFF5B6B60);
  static const Color borde = Color(0xFFE1E5DF);

  /// Neutro oscuro (no es verde) para romper la monotonía cuando varias
  /// piezas de marca —slider, franjas, botones— quedan apiladas y todo
  /// terminaría leyéndose como "una pared verde". Se usa en piezas grandes
  /// de fondo (p. ej. una diapositiva del slider), nunca en texto ni ícono
  /// pequeño, donde [textoPrincipal] sigue siendo lo correcto.
  static const Color neutroOscuro = Color(0xFF20272A);

  static const Color error = Color(0xFFC0392B);
  static const Color exito = Color(0xFF2E8B57);
  static const Color advertencia = Color(0xFFD98B2B);

  /// Verde oficial de marca de WhatsApp — reservado únicamente para el
  /// botón de contacto por WhatsApp, no se usa como acento del sitio.
  static const Color whatsapp = Color(0xFF25D366);

  /// Reservado únicamente para la insignia "Avalado" (ver AvaladoBadge) —
  /// mismo verde institucional que ya usaba el viejo nivel "Verificado":
  /// sigue siendo el reconocimiento base otorgado directo por la CDMB, solo
  /// que ahora es un booleano independiente en vez de un valor de enum.
  static const Color avaladoColor = primary;

  /// Reservado únicamente para el Sello Marca de Negocios Verdes (ver
  /// SelloMarcaBadge) — reconocimiento independiente de avalado/
  /// aval_confianza, por eso necesita su propio color y no reusa accent
  /// (ese sigue solo para CTAs de conversión).
  static const Color selloMarcaDorado = Color(0xFFC9A227);

  /// Reservado únicamente para el Aval de Confianza (ver
  /// AvalConfianzaBadge) — mismo criterio que selloMarcaDorado: un
  /// reconocimiento aparte, necesita su propio color. Deliberadamente
  /// distinto de govCoAzul (esa es la franja institucional obligatoria,
  /// nunca se reusa) y de selloMarcaDorado (para no verse como "el mismo
  /// tipo de insignia" cuando son dos reconocimientos independientes).
  static const Color avalConfianzaAzul = Color(0xFF2A6F97);
}
