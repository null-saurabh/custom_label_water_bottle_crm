import 'package:flutter/material.dart';

/// --------------------------------------------------
/// App UI Constants
/// --------------------------------------------------

class AppUI {
  AppUI._(); // no instances
}

/// --------------------------------------------------
/// Gradients
/// --------------------------------------------------

class AppGradients {
  AppGradients._();

  static const LinearGradient primary = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      Color(0xFF5B7CFA),
      Color(0xFF4C6FFF),
    ],
  );

  static const LinearGradient softBlue = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFDCE4FF),
      Color(0xFFEEF2FF),
    ],
  );

  static const LinearGradient subtleCool = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFEEF1F8),
      // Color(0xFFFFFFFF),
      Color(0xFFEEF1F8),

    ],
  );

  static const LinearGradient subtleBackground = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFFFFFF),
      Color(0xFFF2F3F7),
    ],
  );



  static const LinearGradient success = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      Color(0xFF4ADE80),
      Color(0xFF22C55E),
    ],
  );

  static const LinearGradient warning = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      Color(0xFFFBBF24),
      Color(0xFFF59E0B),
    ],
  );

  static const LinearGradient danger = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      Color(0xFFF87171),
      Color(0xFFEF4444),
    ],
  );
}

/// --------------------------------------------------
/// Colors
/// --------------------------------------------------

class AppColors {
  AppColors._();

  static const Color primary = Color(0xFF4C6FFF);
  static const Color primaryLight = Color(0xFFEEF2FF);
  static const Color background = Color(0xFFF8F9FD);

  static const Color textPrimary = Color(0xFF1F2937);
  static const Color textSecondary = Color(0xFF6B7280);

  static const Color border = Color(0xFFE5E7EB);
  static const Color divider = Color(0xFFF1F5F9);

  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF59E0B);
  static const Color danger = Color(0xFFEF4444);

  static const Color card = Color(0xFFFFFFFF);
}

/// --------------------------------------------------
/// Spacing
/// --------------------------------------------------

class AppSpacing {
  AppSpacing._();

  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;
}

/// --------------------------------------------------
/// Radius
/// --------------------------------------------------

class AppRadius {
  AppRadius._();

  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
}

/// --------------------------------------------------
/// Shadows
/// --------------------------------------------------

class AppShadows {
  AppShadows._();

  static const List<BoxShadow> soft = [
    BoxShadow(
      color: Color(0x14000000),
      blurRadius: 12,
      offset: Offset(0, 6),
    ),
  ];

  static const List<BoxShadow> card = [
    BoxShadow(
      color: Color(0x0F000000),
      blurRadius: 20,
      offset: Offset(0, 10),
    ),
  ];
}
