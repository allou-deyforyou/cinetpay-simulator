import 'package:flutter/material.dart';

import '_assets.dart';

class Themes {
  const Themes._();

  static const Color primary = Color(0xFFFDB813);
  static const Color secondary = Color(0xFF000000);
  static const Color background = Color(0xFFF5F2EF);

  static ThemeData get theme {
    return ThemeData(
      fontFamily: FontFamily.sFProRounded,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.green,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(),
      ),
      dividerTheme: const DividerThemeData(
        thickness: 1.0,
        space: 1.0,
      ),
    );
  }
}
