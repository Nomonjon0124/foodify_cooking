import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../common/widgets/foodify_components/foodify_button.dart';
import '../../../../common/widgets/foodify_components/foodify_logo.dart';
import '../../../../core/gen/fonts.gen.dart';

class SubmitSuccessSheet extends StatelessWidget {
  const SubmitSuccessSheet({required this.onCreateAnother, super.key});

  final VoidCallback onCreateAnother;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 24.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const FoodifyLogo(
            size: FoodifyLogoSize.medium,
            text: FoodifyLogoText.vertical,
            color: FoodifyLogoColor.fill,
          ),
          SizedBox(height: 16.h),
          Text(
            'Recipe draft created',
            style: TextStyle(
              color: const Color(0xFF0E0E0E),
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              fontFamily: FontFamily.montserrat,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Your Figma-inspired add new flow completed successfully.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: const Color(0xFF717171),
              fontSize: 14.sp,
              fontFamily: FontFamily.montserrat,
            ),
          ),
          SizedBox(height: 20.h),
          FoodifyButton(text: 'Create another', onPressed: onCreateAnother),
        ],
      ),
    );
  }
}
