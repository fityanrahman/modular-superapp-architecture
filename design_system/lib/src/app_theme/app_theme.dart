import 'package:flutter/material.dart';

import '../colors/app_colors.dart';
import '../typography/app_typography.dart';

abstract final class AppTheme {
  static ThemeData light() {
    final ThemeData base = ThemeData.light(useMaterial3: true);
    return base.copyWith(
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: base.colorScheme.copyWith(
        primary: AppColors.primary,
        secondary: AppColors.accent,
        surface: AppColors.surface,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        centerTitle: false,
        elevation: 0,
      ),
      textTheme: base.textTheme.copyWith(
        headlineSmall: AppTypography.headline,
        titleMedium: AppTypography.title,
        bodyMedium: AppTypography.body,
        bodySmall: AppTypography.caption,
      ),
    );
  }
}
