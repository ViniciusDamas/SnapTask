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
      surface: AppColorsLight.surface,
      onSurface: AppColorsLight.text,
      error: Color(0xFFB42318),
      onError: Colors.white,
      outline: AppColorsLight.border,
    );

    final hover = scheme.primary.withOpacity(0.06);
    final pressed = scheme.primary.withOpacity(0.12);
    final overlay = WidgetStateProperty.resolveWith<Color?>((states) {
      if (states.contains(WidgetState.pressed)) return pressed;
      if (states.contains(WidgetState.hovered)) return hover;
      if (states.contains(WidgetState.focused)) return hover;
      return null;
    });

    return ThemeData(
      useMaterial3: false,
      colorScheme: scheme,
      primaryColor: scheme.primary,
      scaffoldBackgroundColor: scheme.surface,

      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        iconTheme: IconThemeData(color: scheme.onSurface),
        titleTextStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColorsLight.text,
        ),
      ),

      dividerTheme: const DividerThemeData(color: AppColorsLight.border),

      iconButtonTheme: IconButtonThemeData(
        style: ButtonStyle(
          shape: WidgetStateProperty.all(const CircleBorder()),
          overlayColor: overlay,
        ),
      ),

      filledButtonTheme: FilledButtonThemeData(
        style: ButtonStyle(
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
          ),
          overlayColor: overlay,
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
          ),
          overlayColor: overlay,
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
          ),
          overlayColor: overlay,
        ),
      ),

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
