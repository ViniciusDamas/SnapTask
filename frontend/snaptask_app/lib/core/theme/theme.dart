import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_colors_light.dart';

class AppTheme {
  static ThemeData dark() {
    const scheme = ColorScheme(
      brightness: Brightness.dark,
      primary: AppColors.handle,
      onPrimary: Colors.white,
      secondary: AppColors.handle,
      onSecondary: Colors.white,
      background: AppColors.bg,
      onBackground: AppColors.text,
      surface: AppColors.canvas,
      surfaceVariant: AppColors.panel,
      onSurface: AppColors.text,
      error: Color(0xFFB42318),
      onError: Colors.white,
      outline: AppColors.border,
      outlineVariant: AppColors.borderStrong,
    );

    return _baseTheme(
      scheme,
      textColor: AppColors.text,
      mutedColor: AppColors.muted,
      fieldFill: AppColors.bg,
      focusBorder: AppColors.borderFocus,
      selectionColor: AppColors.selection,
      selectionHandle: AppColors.handle,
    );
  }

  static ThemeData light() {
    const scheme = ColorScheme(
      brightness: Brightness.light,
      primary: AppColorsLight.accent,
      onPrimary: Colors.white,
      secondary: AppColorsLight.accent,
      onSecondary: Colors.white,
      background: AppColorsLight.bg,
      onBackground: AppColorsLight.text,
      surface: AppColorsLight.canvas,
      surfaceVariant: AppColorsLight.panel,
      onSurface: AppColorsLight.text,
      error: Color(0xFFB42318),
      onError: Colors.white,
      outline: AppColorsLight.border,
      outlineVariant: AppColorsLight.borderStrong,
    );

    return _baseTheme(
      scheme,
      textColor: AppColorsLight.text,
      mutedColor: AppColorsLight.muted,
      fieldFill: AppColorsLight.fieldFill,
      focusBorder: AppColorsLight.accent,
      selectionColor: AppColorsLight.selection,
      selectionHandle: AppColorsLight.handle,
    );
  }

  static ThemeData _baseTheme(
    ColorScheme scheme, {
    required Color textColor,
    required Color mutedColor,
    required Color fieldFill,
    required Color focusBorder,
    required Color selectionColor,
    required Color selectionHandle,
  }) {
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
      scaffoldBackgroundColor: scheme.background,
      canvasColor: scheme.surface,
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.background,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        iconTheme: IconThemeData(color: scheme.onSurface),
        titleTextStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: scheme.onSurface,
        ),
      ),
      dividerTheme: DividerThemeData(color: scheme.outlineVariant),
      dialogTheme: DialogThemeData(
        backgroundColor: scheme.surfaceContainerHighest,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: scheme.outline),
        ),
      ),
      cardTheme: CardThemeData(
        color: scheme.surfaceContainerHighest,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(color: scheme.outline),
        ),
      ),
      drawerTheme: DrawerThemeData(backgroundColor: scheme.background),
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
      textTheme: TextTheme(
        bodyMedium: TextStyle(color: textColor),
        bodySmall: TextStyle(color: mutedColor),
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: textColor,
        selectionColor: selectionColor,
        selectionHandleColor: selectionHandle,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: fieldFill,
        labelStyle: TextStyle(color: mutedColor),
        floatingLabelStyle: TextStyle(color: textColor),
        prefixIconColor: mutedColor,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: scheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: focusBorder),
        ),
      ),
    );
  }
}
