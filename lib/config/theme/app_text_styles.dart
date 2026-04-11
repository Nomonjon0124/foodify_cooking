import 'package:flutter/material.dart';

import '../../core/gen/fonts.gen.dart';
import 'app_colors.dart';

abstract final class AppTextStyles {
  static const _baseFamily = FontFamily.montserrat;

  static const title = TextStyle(
    fontFamily: _baseFamily,
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static const body = TextStyle(
    fontFamily: _baseFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );
}
