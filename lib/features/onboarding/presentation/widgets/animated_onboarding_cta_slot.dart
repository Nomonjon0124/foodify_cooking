import 'package:flutter/material.dart';

class AnimatedOnboardingCtaSlot extends StatelessWidget {
  const AnimatedOnboardingCtaSlot({
    required this.currentIndex,
    required this.child,
    super.key,
  });

  final int currentIndex;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      key: ValueKey<int>(currentIndex),
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOutBack,
      child: child,
      builder: (context, value, child) {
        final normalizedValue = value.clamp(0.0, 1.0).toDouble();
        final opacity = Curves.easeOutCubic.transform(normalizedValue);
        final scale = 0.92 + (0.08 * value);

        return Opacity(
          opacity: opacity,
          child: Transform.scale(scale: scale, child: child),
        );
      },
    );
  }
}
