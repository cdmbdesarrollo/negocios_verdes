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

  static const Color accent = Color(0xFFD98B2B);
  static const Color accentDark = Color(0xFFB06F1D);

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

  static const Color nivelEnVerificacion = Color(0xFF8C8C7A);
  static const Color nivelVerificado = primary;
  static const Color nivelAncla = Color(0xFFB8860B);

  /// Reservado únicamente para el Sello Marca de Negocios Verdes (ver
  /// SelloMarcaBadge) — un reconocimiento aparte de nivel_desarrollo, por
  /// eso necesita su propio color y no reusa nivelAncla ni accent (ese
  /// sigue solo para CTAs de conversión).
  static const Color selloMarcaDorado = Color(0xFFC9A227);

  static const LinearGradient gradientHero = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryDark, primary],
  );

  /// Neutro oscuro, para diapositivas/secciones grandes que necesitan
  /// contrastar con el verde de marca sin salirse de la paleta.
  static const LinearGradient gradientOscuro = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [neutroOscuro, Color(0xFF37423F)],
  );

  /// Mezcla verde→ámbar, para piezas grandes donde marca y acento conviven
  /// en la misma pieza en vez de alternarlas en piezas separadas.
  static const LinearGradient gradientDuo = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryDark, accentDark],
  );
}
