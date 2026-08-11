import 'package:flutter/material.dart';

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
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: NVColors.fondo,
      appBarTheme: const AppBarTheme(
        backgroundColor: NVColors.primaryDark,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
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
      chipTheme: ChipThemeData(
        backgroundColor: NVColors.primaryLight,
        selectedColor: NVColors.primary,
        labelStyle: const TextStyle(color: NVColors.textoPrincipal),
        side: BorderSide.none,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: NVColors.accent,
          foregroundColor: Colors.white,
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
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
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: NVColors.primaryDark),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: NVColors.superficie,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: NVColors.borde),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: NVColors.borde),
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
        contentTextStyle: const TextStyle(color: Colors.white),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: NVColors.textoPrincipal),
        bodyMedium: TextStyle(color: NVColors.textoPrincipal),
      ).apply(
        bodyColor: NVColors.textoPrincipal,
        displayColor: NVColors.textoPrincipal,
      ),
    );
  }
}
