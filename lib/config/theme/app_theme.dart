import 'package:flutter/material.dart';

class AppTheme {
  ThemeData getTheme() => ThemeData(
        useMaterial3: true,
        appBarTheme: const AppBarTheme(centerTitle: true),
        colorSchemeSeed: const Color(0xff2862F5),
        brightness: Brightness.dark
      );
}
