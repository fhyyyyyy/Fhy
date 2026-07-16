import 'package:flutter/material.dart';

/// Material 3 主题（亮/暗）
class AppTheme {
  static const _seed = Color(0xFF1976D2); // 雅思蓝

  static ThemeData light() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: _seed),
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );
  }

  static ThemeData dark() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: _seed,
        brightness: Brightness.dark,
      ),
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );
  }
}
