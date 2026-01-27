import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_colors_light.dart';

class AppTheme {
  static ThemeData dark() {
    return ThemeData(
      useMaterial3: false,
      scaffoldBackgroundColor: AppColors.bg,
      textTheme: const TextTheme(bodyMedium: TextStyle(color: AppColors.text)),
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: AppColors.text,
        selectionColor: AppColors.selection,
        selectionHandleColor: AppColors.handle,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.bg,
        labelStyle: const TextStyle(color: AppColors.muted),
        floatingLabelStyle: const TextStyle(color: AppColors.text),
        prefixIconColor: AppColors.muted,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.borderFocus),
        ),
      ),
    );
  }

  static ThemeData light() {
    final scheme = const ColorScheme(
      brightness: Brightness.light,
      primary: AppColorsLight.accent,
      onPrimary: Colors.white,
      secondary: AppColorsLight.accent,
      onSecondary: Colors.white,
      background: AppColorsLight.bg,
      onBackground: AppColorsLight.text,
      surface: AppColorsLight.surface,
      onSurface: AppColorsLight.text,
      error: Color(0xFFB42318),
      onError: Colors.white,
      outline: AppColorsLight.border,
    );

    return ThemeData(
      useMaterial3: false,
      colorScheme: scheme,
      primaryColor: scheme.primary,
      scaffoldBackgroundColor: scheme.background,

      appBarTheme: AppBarTheme(
        backgroundColor: scheme.background,
        foregroundColor: scheme.onBackground,
        elevation: 0,
        iconTheme: IconThemeData(color: scheme.onBackground),
        titleTextStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColorsLight.text,
        ),
      ),

      dividerTheme: const DividerThemeData(color: AppColorsLight.border),

      textTheme: const TextTheme(
        bodyMedium: TextStyle(color: AppColorsLight.text),
        bodySmall: TextStyle(color: AppColorsLight.muted),
      ),

      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: AppColorsLight.text,
        selectionColor: AppColorsLight.selection,
        selectionHandleColor: AppColorsLight.handle,
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColorsLight.fieldFill,
        labelStyle: const TextStyle(color: AppColorsLight.muted),
        floatingLabelStyle: const TextStyle(color: AppColorsLight.text),
        prefixIconColor: AppColorsLight.muted,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColorsLight.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColorsLight.accent),
        ),
      ),
    );
  }
}
