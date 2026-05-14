import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AnimatedOnboardingPlate extends StatelessWidget {
  const AnimatedOnboardingPlate({
    required this.controller,
    required this.index,
    required this.path,
    required this.size,
    required this.entranceOffsetY,
    super.key,
  });

  final AnimationController controller;
  final int index;
  final String path;
  final double size;
  final double entranceOffsetY;

  static const staggerDelay = 120.0;
  static const plateDuration = 650.0;
  static const animationTotalDuration = 890.0;

  @override
  Widget build(BuildContext context) {
    final start = (staggerDelay * index) / animationTotalDuration;
    final end = start + (plateDuration / animationTotalDuration);
    final clampedEnd = end > 1.0 ? 1.0 : end;

    final animation = CurvedAnimation(
      parent: controller,
      curve: Interval(start, clampedEnd),
    );

    return AnimatedBuilder(
      animation: animation,
      child: _PlateImage(path: path, size: size),
      builder: (context, child) {
        final slideValue = Curves.easeOutCubic.transform(animation.value);
        final scaleValue = Curves.easeOutBack.transform(animation.value);
        final opacity = slideValue.clamp(0.0, 1.0).toDouble();

        return Opacity(
          opacity: opacity,
          child: Transform.translate(
            offset: Offset(0, lerpDouble(entranceOffsetY, 0, slideValue)!),
            child: Transform.scale(
              scale: lerpDouble(0.86, 1.0, scaleValue)!,
              child: child,
            ),
          ),
        );
      },
    );
  }
}

class _PlateImage extends StatelessWidget {
  const _PlateImage({required this.path, required this.size});

  final String path;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const Key('onboarding_plate_image'),
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.22),
            blurRadius: 8.r,
            offset: Offset(0, 6.h),
          ),
        ],
      ),
      child: ClipOval(child: Image.asset(path, fit: BoxFit.cover)),
    );
  }
}
