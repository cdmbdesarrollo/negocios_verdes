import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'nv_colors.dart';

abstract final class NVTheme {
  static ThemeData get light {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: NVColors.primary,
      primary: NVColors.primary,
      secondary: NVColors.accent,
      surface: NVColors.superficie,
      error: NVColors.error,
      brightness: Brightness.light,
      // Material 3 pinta un tinte del color semilla sobre cualquier
      // superficie con elevación (diálogos, tarjetas con sombra) — con la
      // semilla verde, eso se veía como un verde pálido "sucio" encima de
      // fondos que deberían ser blancos puros (diálogos de admin, tarjetas
      // con la sombra que se agregó esta sesión). Blanco puro en todas las
      // superficies, la marca ya la llevan los bordes y botones.
      surfaceTint: Colors.transparent,
    );

    // Work Sans: la misma tipografía que usa la Sede Electrónica de la CDMB
    // (verificada en su CSS) — Negocios Verdes es un micrositio de esa
    // página, hereda su tipografía además de sus colores. Antes no se
    // fijaba ninguna fuente y el navegador caía al Roboto por defecto.
    final textTheme = GoogleFonts.workSansTextTheme().apply(
      bodyColor: NVColors.textoPrincipal,
      displayColor: NVColors.textoPrincipal,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: NVColors.fondo,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: NVColors.primaryDark,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.workSans(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      cardTheme: CardThemeData(
        color: NVColors.superficie,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: NVColors.borde),
        ),
        margin: EdgeInsets.zero,
      ),
      dialogTheme: const DialogThemeData(
        backgroundColor: NVColors.superficie,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: NVColors.primaryLight,
        selectedColor: NVColors.primary,
        labelStyle: GoogleFonts.workSans(color: NVColors.textoPrincipal),
        side: BorderSide.none,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: NVColors.accent,
          foregroundColor: Colors.white,
          elevation: 1,
          shadowColor: NVColors.accentDark.withValues(alpha: 0.4),
          textStyle: GoogleFonts.workSans(
              fontWeight: FontWeight.w600, fontSize: 14.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: NVColors.primaryDark,
          side: const BorderSide(color: NVColors.primary),
          textStyle: GoogleFonts.workSans(
              fontWeight: FontWeight.w600, fontSize: 14.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: NVColors.primaryDark,
          textStyle: GoogleFonts.workSans(fontWeight: FontWeight.w600),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: NVColors.superficie,
        // NVColors.borde es un gris muy claro, pensado para separar
        // superficies blancas sutilmente (tarjetas, divisores) — como
        // borde de campo de formulario se perdía casi por completo contra
        // el fondo también claro de los diálogos, y el campo se veía "sin
        // formato" (una caja sin contorno) hasta que se enfocaba. Un poco
        // más oscuro y de 1.4px en vez de 1px, solo para esta situación.
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFC7CEC5), width: 1.4),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFC7CEC5), width: 1.4),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: NVColors.primary, width: 2),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: NVColors.borde,
        thickness: 1,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: NVColors.textoPrincipal,
        contentTextStyle: GoogleFonts.workSans(color: Colors.white),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
