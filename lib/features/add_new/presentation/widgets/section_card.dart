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
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxLabelWidth = constraints.maxWidth.isFinite
            ? (constraints.maxWidth - 16.w).clamp(80.w, constraints.maxWidth)
            : double.infinity;
        final minLabelWidth = labelWidth == null
            ? 0.0
            : labelWidth!.w.clamp(0.0, maxLabelWidth).toDouble();

        return Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: double.infinity,
              margin: EdgeInsets.only(top: 12.h),
              padding: EdgeInsets.fromLTRB(14.w, 34.h, 14.w, 14.h),
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
                constraints: BoxConstraints(
                  minWidth: minLabelWidth,
                  maxWidth: maxLabelWidth.toDouble(),
                ),
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF6339),
                  borderRadius: BorderRadius.circular(5.r),
                ),
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
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
      },
    );
  }
}
