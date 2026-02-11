import 'package:flutter/material.dart';

class AppTheme {
  static const Color primary = Color(0xFFD1603D);
  static const Color primaryDark = Color(0xFFA84526);
  static const Color secondary = Color(0xFFE8DED1);
  static const Color bgLight = Color(0xFFFDFCFB);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color textMain = Color(0xFF1C110D);
  static const Color textSec = Color(0xFF635853);

  static ThemeData lightTheme = ThemeData(
    primaryColor: primary,
    scaffoldBackgroundColor: bgLight,
    fontFamily: 'PlusJakartaSans',
    colorScheme: const ColorScheme.light(
      primary: primary,
      secondary: secondary,
      surface: surface,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: surface,
      elevation: 0,
      iconTheme: IconThemeData(color: textMain),
      titleTextStyle: TextStyle(
        color: textMain,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        elevation: 8,
        shadowColor: primary.withOpacity(0.25),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
      ),
    ),
  );
}
