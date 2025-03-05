import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      popupMenuTheme: const PopupMenuThemeData(

      ),
      dividerTheme: DividerThemeData(
        color: Colors.white.withOpacity(0.15),
        thickness: 1,
      ),
      dialogTheme: const DialogTheme(
        // backgroundColor: Colors.black,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        contentTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
      brightness: Brightness.dark,
      primaryColor: const Color.fromRGBO(254, 198, 0, 1),
      hintColor: Colors.white,
      // scaffoldBackgroundColor: Colors.black,
      colorScheme: ColorScheme.fromSeed(
        brightness: Brightness.dark,
          seedColor: Colors.blue
      ),
      appBarTheme: const AppBarTheme(
        // backgroundColor: Colors.black,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      useMaterial3: true,
    );
  }

  static ThemeData get lightTheme{
    return ThemeData(
      primaryColor: const Color.fromRGBO(254, 198, 0, 1),
      cardTheme: CardTheme(
        // color: Colors.white,
        color: Colors.amber.shade50,
        elevation: 5,
        shadowColor: Colors.black.withOpacity(0.5),
      ),
      cardColor: Colors.white,
      dividerTheme: DividerThemeData(
        space: 0,
        color: Colors.black.withOpacity(0.15),
        thickness: 1,
      ),
      popupMenuTheme: const PopupMenuThemeData(
        color: Colors.white,
      ),
      dialogTheme: const DialogTheme(
        backgroundColor: Colors.white,
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        contentTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 16,
        ),
      ),
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: const AppBarTheme(
          // backgroundColor: Colors.white
          backgroundColor: Color.fromRGBO(254, 198, 0, 1)
      ),
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      useMaterial3: true,
    );
  }

}