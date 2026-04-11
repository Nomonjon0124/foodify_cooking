import 'package:flutter/material.dart';

class AppThemeExtension extends ThemeExtension<AppThemeExtension> {
  const AppThemeExtension({required this.cardRadius});

  final double cardRadius;

  @override
  ThemeExtension<AppThemeExtension> copyWith({double? cardRadius}) {
    return AppThemeExtension(cardRadius: cardRadius ?? this.cardRadius);
  }

  @override
  ThemeExtension<AppThemeExtension> lerp(
    covariant ThemeExtension<AppThemeExtension>? other,
    double t,
  ) {
    if (other is! AppThemeExtension) return this;
    return AppThemeExtension(
      cardRadius: cardRadius + (other.cardRadius - cardRadius) * t,
    );
  }
}
