import 'package:flutter/material.dart';


ThemeData getLightTheme(){
  
  return ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.deepPurple,
      brightness: Brightness.light),
    useMaterial3: true,
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.deepPurple.shade50
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(style: 
      ElevatedButton.styleFrom(
        minimumSize: const Size(200, 50),
        elevation: 7
      ),
    ),
    appBarTheme: AppBarTheme(
      color: Colors.deepPurple.shade200,
      elevation: 4
    ),
    drawerTheme: DrawerThemeData(
      backgroundColor: Colors.deepPurple.shade50,
      elevation: 4,
      ),
    brightness: Brightness.light
  );
}