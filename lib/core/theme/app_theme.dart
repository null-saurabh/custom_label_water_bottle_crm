// core/theme/app_theme.dart
import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get light => ThemeData(
    scaffoldBackgroundColor: const Color(0xFFF7F9FC),
    primaryColor: const Color(0xFF4C6FFF),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 0,
    ),
    dataTableTheme: const DataTableThemeData(
      headingRowColor: WidgetStatePropertyAll(Color(0xFFEFF2F7)),
    ),
  );
}
