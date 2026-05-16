import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodify_cooking/core/gen/assets.gen.dart';

import '../../../core/gen/fonts.gen.dart';

class FoodifyInfoPill extends StatelessWidget {
  const FoodifyInfoPill({super.key, this.label = 'Low Callery'});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const Key('foodify_info_pill'),
      height: 23.r,
      padding: EdgeInsets.symmetric(horizontal: 8.r, vertical: 4.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Assets.icons.foodifyComponents.trendDown.svg(
            width: 12.r,
            height: 12.r,
            colorFilter: const ColorFilter.mode(
              Color(0xFF4058A0),
              BlendMode.srcIn,
            ),
          ),
          SizedBox(width: 4.r),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: const Color(0xFF353535),
              fontSize: 11.sp,
              fontWeight: FontWeight.w400,
              height: 1,
              fontFamily: FontFamily.montserrat,
            ),
          ),
        ],
      ),
    );
  }
}
