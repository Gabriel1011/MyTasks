import 'package:flutter/material.dart';

var DRACULA_THEME = ThemeData(
    brightness: Brightness.dark,
    primaryColor: const Color(0xFF6272A4),
    scaffoldBackgroundColor: const Color(0xFF282A36),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF44475A),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      foregroundColor: Color(0xFF282A36),
    ),
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF6272A4),
      secondary: Color(0xFFFF79C6),
      surface: Color(0xFF44475A),
      error: Color(0xFFFF5555),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        minimumSize: const Size(double.infinity, 50),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        minimumSize: const Size(40, 50),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        // ignore: prefer_const_constructors
        borderSide: BorderSide(color: Colors.white),
      ),
      filled: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),
    dialogTheme: DialogTheme(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      backgroundColor: const Color(0xFF44475A),
      titleTextStyle: const TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
      contentTextStyle: const TextStyle(
        color: Colors.white,
        fontSize: 14,
      ),
      actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    ));
