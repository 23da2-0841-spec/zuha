import 'package:flutter/material.dart';

class ZColors {
  // Light mode
  static const background = Color(0xFFF7F3EF);
  static const surface = Color(0xFFEFE9E2);
  static const primary = Color(0xFF8B6B5E);
  static const accent = Color(0xFF3D5A44);
  static const sand = Color(0xFFC4A882);
  static const textPrimary = Color(0xFF1A1512);
  static const textSecondary = Color(0xFF6B5B52);
  static const divider = Color(0xFFDDD5CC);
  static const error = Color(0xFFC0392B);

  // Dark mode
  static const darkBackground = Color(0xFF1A1512);
  static const darkSurface = Color(0xFF2A2118);
  static const darkPrimary = Color(0xFFC4A882);
  static const darkAccent = Color(0xFF5A8C67);
  static const darkText = Color(0xFFF7F3EF);
  static const darkTextMuted = Color(0xFFA89080);
  static const darkDivider = Color(0xFF3A2E26);
}

class ZSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;
}

class ZRadius {
  static const double small = 8;
  static const double medium = 12;
  static const double large = 20;
  static const double full = 999;
}

class ZTextStyles {
  // Use DM Serif Display for headings
  // Use DM Sans for body and labels
  static const display = TextStyle(
    fontFamily: 'DMSerifDisplay',
    fontSize: 28,
    color: ZColors.textPrimary,
  );
  static const h2 = TextStyle(
    fontFamily: 'DMSerifDisplay',
    fontSize: 22,
    color: ZColors.textPrimary,
  );
  static const h3 = TextStyle(
    fontFamily: 'DMSans',
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: ZColors.textPrimary,
  );
  static const body = TextStyle(
    fontFamily: 'DMSans',
    fontSize: 14,
    color: ZColors.textPrimary,
  );
  static const label = TextStyle(
    fontFamily: 'DMSans',
    fontSize: 13,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
    color: ZColors.textPrimary,
  );
  static const caption = TextStyle(
    fontFamily: 'DMSans',
    fontSize: 11,
    color: ZColors.textSecondary,
  );
}

class ZTheme {
  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: ZColors.background,
    primaryColor: ZColors.primary,
    colorScheme: const ColorScheme.light(
      primary: ZColors.primary,
      secondary: ZColors.accent,
      surface: ZColors.surface,
      error: ZColors.error,
    ),
    fontFamily: 'DMSans',
    appBarTheme: const AppBarTheme(
      backgroundColor: ZColors.background,
      elevation: 0,
      iconTheme: IconThemeData(color: ZColors.textPrimary),
      titleTextStyle: ZTextStyles.h2,
    ),
    dividerTheme: const DividerThemeData(
      color: ZColors.divider,
      thickness: 1,
      space: 1,
    ),
    textTheme: const TextTheme(
      displayLarge: ZTextStyles.display,
      headlineMedium: ZTextStyles.h2,
      headlineSmall: ZTextStyles.h3,
      bodyMedium: ZTextStyles.body,
      labelLarge: ZTextStyles.label,
      bodySmall: ZTextStyles.caption,
    ),
    useMaterial3: true,
  );

  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: ZColors.darkBackground,
    primaryColor: ZColors.darkPrimary,
    colorScheme: const ColorScheme.dark(
      primary: ZColors.darkPrimary,
      secondary: ZColors.darkAccent,
      surface: ZColors.darkSurface,
      error: ZColors.error,
    ),
    fontFamily: 'DMSans',
    appBarTheme: const AppBarTheme(
      backgroundColor: ZColors.darkBackground,
      elevation: 0,
      iconTheme: IconThemeData(color: ZColors.darkText),
      titleTextStyle: TextStyle(
        fontFamily: 'DMSerifDisplay',
        fontSize: 22,
        color: ZColors.darkText,
      ),
    ),
    dividerTheme: const DividerThemeData(
      color: ZColors.darkDivider,
      thickness: 1,
      space: 1,
    ),
    textTheme: TextTheme(
      displayLarge: ZTextStyles.display.copyWith(color: ZColors.darkText),
      headlineMedium: ZTextStyles.h2.copyWith(color: ZColors.darkText),
      headlineSmall: ZTextStyles.h3.copyWith(color: ZColors.darkText),
      bodyMedium: ZTextStyles.body.copyWith(color: ZColors.darkText),
      labelLarge: ZTextStyles.label.copyWith(color: ZColors.darkText),
      bodySmall: ZTextStyles.caption.copyWith(color: ZColors.darkTextMuted),
    ),
    useMaterial3: true,
  );
}
