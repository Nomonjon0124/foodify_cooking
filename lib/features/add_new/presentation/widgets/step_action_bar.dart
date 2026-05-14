import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../common/widgets/foodify_components/foodify_button.dart';

class StepActionBar extends StatelessWidget {
  const StepActionBar({
    required this.label,
    required this.onPressed,
    super.key,
    this.isEnabled = true,
    this.isLoading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isEnabled;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 18.h),
      child: FoodifyButton(
        text: label,
        onPressed: isEnabled ? onPressed : null,
        isDisabled: !isEnabled,
        isLoading: isLoading,
      ),
    );
  }
}
