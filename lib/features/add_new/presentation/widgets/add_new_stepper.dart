import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/gen/fonts.gen.dart';
import '../../../../l10n/l10n_extension.dart';
import '../add_new_constants.dart';
import '../add_new_l10n.dart';

class AddNewStepper extends StatelessWidget {
  const AddNewStepper({required this.currentStep, super.key});

  final int currentStep;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 12.h),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final stepCount = AddNewConstants.stepLabels.length;
          final circleSize = 32.r;
          final connectorWidth = (constraints.maxWidth * 0.06)
              .clamp(10.r, 22.r)
              .toDouble();
          final inactiveWidth = circleSize * (stepCount - 1);
          final connectorsWidth = connectorWidth * (stepCount - 1);
          final activeWidth =
              (constraints.maxWidth - inactiveWidth - connectorsWidth)
                  .clamp(112.r, constraints.maxWidth)
                  .toDouble();

          return Row(
            children: List.generate(stepCount * 2 - 1, (position) {
              if (position.isOdd) {
                final connectorIndex = position ~/ 2;
                return _StepConnector(
                  width: connectorWidth,
                  isCompleted: connectorIndex < currentStep,
                );
              }

              final index = position ~/ 2;
              final isActive = index == currentStep;
              final isCompleted = index < currentStep;

              return _StepSegment(
                width: isActive ? activeWidth : circleSize,
                label: l10n.addNewStepLabel(index),
                number: '${index + 1}',
                isActive: isActive,
                isCompleted: isCompleted,
              );
            }),
          );
        },
      ),
    );
  }
}

class _StepSegment extends StatelessWidget {
  const _StepSegment({
    required this.width,
    required this.label,
    required this.number,
    required this.isActive,
    required this.isCompleted,
  });

  final double width;
  final String label;
  final String number;
  final bool isActive;
  final bool isCompleted;

  @override
  Widget build(BuildContext context) {
    final foregroundColor = isActive || isCompleted
        ? const Color(0xFFDEE21B)
        : const Color(0xFF717171);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
      width: width,
      height: isActive ? 40.r : 32.r,
      padding: isActive
          ? EdgeInsets.only(left: 4.r, right: 8.r)
          : EdgeInsets.zero,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: const Color(0xFF353535),
        borderRadius: BorderRadius.circular(38.r),
      ),
      child: isActive
          ? FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _StepCircle(
                    label: number,
                    color: const Color(0xFFDEE21B),
                    backgroundColor: const Color(0xFF0E0E0E),
                    isBold: true,
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    label,
                    maxLines: 1,
                    softWrap: false,
                    style: TextStyle(
                      color: const Color(0xFFDEE21B),
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                      fontFamily: FontFamily.montserrat,
                    ),
                  ),
                ],
              ),
            )
          : Center(
              child: Text(
                number,
                style: TextStyle(
                  color: foregroundColor,
                  fontSize: 12.sp,
                  fontWeight: isCompleted ? FontWeight.w600 : FontWeight.w400,
                  fontFamily: FontFamily.montserrat,
                ),
              ),
            ),
    );
  }
}

class _StepConnector extends StatelessWidget {
  const _StepConnector({required this.width, required this.isCompleted});

  final double width;
  final bool isCompleted;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
      width: width,
      height: 2.h,
      color: isCompleted ? const Color(0xFFDEE21B) : const Color(0xFF353535),
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
