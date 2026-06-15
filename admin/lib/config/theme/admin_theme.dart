import 'package:flutter/material.dart';

abstract final class AdminTheme {
  static const primary = Color(0xFF1E3A8A);

  static ThemeData get light => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: primary),
        navigationRailTheme: const NavigationRailThemeData(
          selectedIconTheme: IconThemeData(color: primary),
          selectedLabelTextStyle: TextStyle(color: primary),
        ),
      );
}
