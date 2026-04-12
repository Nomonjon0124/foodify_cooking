import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/gen/fonts.gen.dart';

enum FoodifyCodeStatus { empty, success, error }

class FoodifyCodeCell extends StatelessWidget {
  const FoodifyCodeCell({
    super.key,
    this.status = FoodifyCodeStatus.empty,
    this.value,
  });

  final FoodifyCodeStatus status;
  final String? value;

  @override
  Widget build(BuildContext context) {
    final colors = switch (status) {
      FoodifyCodeStatus.empty => (
        background: Colors.transparent,
        border: const Color(0xFF0E0E0E),
      ),
      FoodifyCodeStatus.success => (
        background: Colors.white,
        border: const Color(0xFF388916),
      ),
      FoodifyCodeStatus.error => (
        background: const Color(0xFFF6FBF4),
        border: const Color(0xFFF96D63),
      ),
    };

    return Container(
      key: const Key('foodify_code_cell'),
      width: 40.r,
      height: 40.r,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: BorderRadius.circular(31.r),
        border: Border.all(color: colors.border, width: 1.r),
      ),
      child: status == FoodifyCodeStatus.empty
          ? null
          : Text(
              value ?? '6',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: const Color(0xFF0E0E0E),
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                height: 1,
                fontFamily: FontFamily.montserrat,
              ),
            ),
    );
  }
}
