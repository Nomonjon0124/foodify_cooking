import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_dimensions.dart';
import 'app_text_styles.dart';
import 'app_theme_extension.dart';

abstract final class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
      textTheme: TextTheme(
        titleLarge: AppTextStyles.title,
        bodyMedium: AppTextStyles.body,
      ),
      extensions: [AppThemeExtension(cardRadius: AppDimensions.borderRadiusMd)],
    );
  }

  static ThemeData get darkTheme {
    return lightTheme.copyWith(brightness: Brightness.dark);
  }
}
