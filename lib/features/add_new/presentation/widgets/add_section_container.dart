import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodify_cooking/core/gen/fonts.gen.dart';

class AddSectionContainer extends StatelessWidget {
  const AddSectionContainer({
    required this.label,
    required this.child,
    super.key,
  });

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          margin: EdgeInsets.only(top: 12.h),
          padding: EdgeInsets.fromLTRB(16.w, 32.h, 16.w, 16.h),
          decoration: BoxDecoration(
            color: const Color(0xFF4058A0),
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: child,
        ),
        Positioned(
          top: 0,
          left: 10.w,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: const Color(0xFFFF6339),
              borderRadius: BorderRadius.circular(5.r),
            ),
            child: Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                fontFamily: FontFamily.montserrat,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
