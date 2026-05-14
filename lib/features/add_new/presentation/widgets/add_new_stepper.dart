import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/gen/fonts.gen.dart';
import '../add_new_constants.dart';

class AddNewStepper extends StatelessWidget {
  const AddNewStepper({required this.currentStep, super.key});

  final int currentStep;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(28.w, 16.h, 20.w, 12.h),
      child: Row(
        children: List.generate(AddNewConstants.stepLabels.length, (index) {
          final isActive = index == currentStep;
          final isCompleted = index < currentStep;
          final isLast = index == AddNewConstants.stepLabels.length - 1;

          return Expanded(
            flex: isActive ? 6 : 2,
            child: Row(
              children: [
                if (isActive)
                  Expanded(
                    child: Container(
                      height: 32.h,
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                      decoration: BoxDecoration(
                        color: const Color(0xFF353535),
                        borderRadius: BorderRadius.circular(38.r),
                      ),
                      child: Row(
                        children: [
                          _StepCircle(
                            label: '${index + 1}',
                            color: const Color(0xFFDEE21B),
                            backgroundColor: const Color(0xFF0E0E0E),
                            isBold: true,
                          ),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: Text(
                              AddNewConstants.stepLabels[index],
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: const Color(0xFFDEE21B),
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                                fontFamily: FontFamily.montserrat,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  _StepCircle(
                    label: '${index + 1}',
                    color: isCompleted
                        ? const Color(0xFFDEE21B)
                        : const Color(0xFF717171),
                    backgroundColor: const Color(0xFF353535),
                    isBold: isCompleted,
                  ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      height: 2.h,
                      margin: EdgeInsets.symmetric(horizontal: 4.w),
                      color: index < currentStep
                          ? const Color(0xFFDEE21B)
                          : const Color(0xFF353535),
                    ),
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class _StepCircle extends StatelessWidget {
  const _StepCircle({
    required this.label,
    required this.color,
    required this.backgroundColor,
    required this.isBold,
  });

  final String label;
  final Color color;
  final Color backgroundColor;
  final bool isBold;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32.r,
      height: 32.r,
      decoration: BoxDecoration(color: backgroundColor, shape: BoxShape.circle),
      alignment: Alignment.center,
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12.sp,
          fontWeight: isBold ? FontWeight.w600 : FontWeight.w400,
          fontFamily: FontFamily.montserrat,
        ),
      ),
    );
  }
}
