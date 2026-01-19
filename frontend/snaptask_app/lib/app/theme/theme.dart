import 'package:flutter/material.dart';
import 'app_colors.dart';

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
}
