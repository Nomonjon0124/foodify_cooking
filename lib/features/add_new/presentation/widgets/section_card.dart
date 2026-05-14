import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/gen/fonts.gen.dart';

class SectionCard extends StatelessWidget {
  const SectionCard({
    required this.label,
    required this.child,
    super.key,
    this.labelWidth,
  });

  final String label;
  final Widget child;
  final double? labelWidth;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          margin: EdgeInsets.only(top: 12.h),
          padding: EdgeInsets.fromLTRB(14.w, 32.h, 14.w, 14.h),
          decoration: BoxDecoration(
            color: const Color(0xFF4058A0),
            borderRadius: BorderRadius.circular(6.r),
          ),
          child: child,
        ),
        Positioned(
          top: 0,
          left: 0,
          child: Container(
            constraints: labelWidth == null
                ? null
                : BoxConstraints(minWidth: labelWidth!.w),
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 3.h),
            decoration: BoxDecoration(
              color: const Color(0xFFFF6339),
              borderRadius: BorderRadius.circular(5.r),
            ),
            child: Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
                height: 1.2,
                fontFamily: FontFamily.montserrat,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
