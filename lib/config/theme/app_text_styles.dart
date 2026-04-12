import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/gen/fonts.gen.dart';
import 'app_colors.dart';

abstract final class AppTextStyles {
  static const _baseFamily = FontFamily.montserrat;

  static TextStyle get title => TextStyle(
    fontFamily: _baseFamily,
    fontSize: 24.sp,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static TextStyle get body => TextStyle(
    fontFamily: _baseFamily,
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );
}
