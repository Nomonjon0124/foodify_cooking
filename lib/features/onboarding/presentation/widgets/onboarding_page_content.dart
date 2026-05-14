import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'animated_onboarding_plate.dart';

class OnboardingPageContent extends StatefulWidget {
  const OnboardingPageContent({
    required this.backgroundColor,
    required this.imagePaths,
    required this.isActive,
    required this.bottomReservedHeight,
    super.key,
  });

  final Color backgroundColor;
  final List<String> imagePaths;
  final bool isActive;
  final double bottomReservedHeight;

  @override
  State<OnboardingPageContent> createState() => _OnboardingPageContentState();
}

class _OnboardingPageContentState extends State<OnboardingPageContent>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  static const _animationDuration = Duration(milliseconds: 890);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: _animationDuration,
    );
    if (widget.isActive) {
      _controller.forward();
    } else {
      _controller.value = 1;
    }
  }

  @override
  void didUpdateWidget(covariant OnboardingPageContent oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (!oldWidget.isActive && widget.isActive) {
      _controller
        ..reset()
        ..forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: widget.backgroundColor,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final mediaPadding = MediaQuery.paddingOf(context);
          final screenWidth = constraints.maxWidth;
          final screenHeight = constraints.maxHeight;
          final imageCount = widget.imagePaths.length;
          if (imageCount == 0) {
            return const SizedBox.shrink();
          }

          final availableHeight = math.max(
            0.0,
            screenHeight -
                widget.bottomReservedHeight -
                mediaPadding.top -
                16.h,
          );
          final minGaps = 16.h * math.max(0, imageCount - 1);
          final maxPlateFromHeight = math.max(
            48.r,
            (availableHeight - minGaps) / imageCount,
          );
          final plateSize = math.min(130.r, maxPlateFromHeight).toDouble();
          final totalPlatesHeight = plateSize * imageCount;
          final freeHeight = math.max(0.0, availableHeight - totalPlatesHeight);
          final baseGap = imageCount == 0 ? 0.0 : freeHeight / (imageCount + 1);
          final topGap = math.min(66.h, math.max(12.h, baseGap * 1.4));
          final interGap = imageCount > 1
              ? math.max(0.0, (freeHeight - topGap) / (imageCount - 1))
              : 0.0;

          return Stack(
            fit: StackFit.expand,
            children: [
              for (var i = 0; i < imageCount; i++)
                Positioned(
                  top: mediaPadding.top + topGap + ((plateSize + interGap) * i),
                  left: (screenWidth - plateSize) / 2,
                  child: AnimatedOnboardingPlate(
                    controller: _controller,
                    index: i,
                    path: widget.imagePaths[i],
                    size: plateSize,
                    entranceOffsetY: -screenHeight * 0.22,
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
