import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/gen/fonts.gen.dart';

class FoodifyChip extends StatelessWidget {
  const FoodifyChip({
    required this.label,
    super.key,
    this.isActive = true,
    this.onPressed,
  });

  final String label;
  final bool isActive;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final chip = Container(
      key: const Key('foodify_chip_container'),
      height: 32.r,
      padding: EdgeInsets.symmetric(horizontal: 8.r, vertical: 4.r),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFFDEE21B) : Colors.transparent,
        borderRadius: BorderRadius.circular(16.r),
        border: isActive
            ? null
            : Border.all(color: const Color(0xFF353535), width: 1.r),
      ),
      alignment: Alignment.center,
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: isActive ? const Color(0xFF0E0E0E) : Colors.white,
          fontSize: 11.sp,
          fontWeight: FontWeight.w400,
          height: 1,
          fontFamily: FontFamily.montserrat,
        ),
      ),
    );

    if (onPressed == null) return chip;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onPressed,
      child: chip,
    );
  }
}
