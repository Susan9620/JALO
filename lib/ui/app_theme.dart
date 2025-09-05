import 'package:flutter/material.dart';

const Color jaloRed = Color(0xFFE53935);

ThemeData jaloTheme() => ThemeData(
      colorScheme: const ColorScheme.dark(
        primary: jaloRed,
        secondary: jaloRed,
        background: Colors.black,
      ),
      scaffoldBackgroundColor: Colors.black,
      appBarTheme: const AppBarTheme(backgroundColor: Colors.black, foregroundColor: Colors.white),
      textTheme: const TextTheme(bodyMedium: TextStyle(fontSize: 18, color: Colors.white)),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(backgroundColor: jaloRed, foregroundColor: Colors.white),
      ),
    );
