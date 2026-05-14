import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/gen/fonts.gen.dart';

class AddNewHeader extends StatelessWidget {
  const AddNewHeader({
    super.key,
    this.title,
    this.leading,
    this.trailing,
    this.backgroundColor = const Color(0xFF4058A0),
    this.height = 80,
    this.borderRadius = const BorderRadius.vertical(
      bottom: Radius.circular(20),
    ),
  });

  final String? title;
  final Widget? leading;
  final Widget? trailing;
  final Color backgroundColor;
  final double height;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height.h,
      width: double.infinity,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: borderRadius,
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: [
          SizedBox(
            width: 72.w,
            child: Align(alignment: Alignment.centerLeft, child: leading),
          ),
          Expanded(
            child: title == null
                ? const SizedBox.shrink()
                : Text(
                    title!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                      height: 1.2,
                      fontFamily: 'Georgia',
                      fontFamilyFallback: const [
                        'Times New Roman',
                        FontFamily.montserrat,
                      ],
                    ),
                  ),
          ),
          SizedBox(
            width: 72.w,
            child: Align(alignment: Alignment.centerRight, child: trailing),
          ),
        ],
      ),
    );
  }
}
