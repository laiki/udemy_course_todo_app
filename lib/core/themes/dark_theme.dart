import 'package:flutter/material.dart';


ThemeData getDarkTheme(){
  
  return ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.deepPurple,
      brightness: Brightness.dark),
    useMaterial3: true,
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.deepPurple.shade900
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(style: 
      ElevatedButton.styleFrom(
        minimumSize: const Size(200, 50),
        elevation: 7
      ),
    ),
    appBarTheme: AppBarTheme(
      color: Colors.deepPurple.shade800,
      elevation: 4
    ),
    drawerTheme: DrawerThemeData(
      backgroundColor: Colors.deepPurple.shade900,
      elevation: 4,
      ),
    brightness: Brightness.dark
  );
}