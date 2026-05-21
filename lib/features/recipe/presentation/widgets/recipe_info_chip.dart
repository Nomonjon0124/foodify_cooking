import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/gen/fonts.gen.dart';

class RecipeInfoChip extends StatelessWidget {
  const RecipeInfoChip({
    required this.label,
    this.icon,
    this.iconColor,
    super.key,
  });

  final String label;
  final Widget? icon;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 23.h,
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            IconTheme(
              data: IconThemeData(
                color: iconColor ?? const Color(0xFF353535),
                size: 12.sp,
              ),
              child: SizedBox(width: 12.w, height: 12.h, child: icon),
            ),
            SizedBox(width: 4.w),
          ],
          Text(
            label,
            style: TextStyle(
              fontFamily: FontFamily.montserrat,
              fontSize: 11.sp,
              color: const Color(0xFF353535),
              fontWeight: FontWeight.w400,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}
