import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'onboarding_cta_button.dart';

class OnboardingBottomPanel extends StatelessWidget {
  const OnboardingBottomPanel({
    required this.title,
    required this.currentIndex,
    required this.totalPages,
    required this.isLastPage,
    required this.pageColor,
    required this.onCtaPressed,
    super.key,
  });

  final String title;
  final int currentIndex;
  final int totalPages;
  final bool isLastPage;
  final Color pageColor;
  final VoidCallback onCtaPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 235,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Positioned(
            left: 24,
            right: 24,
            top: 0,
            child: ClipPath(
              clipper: _BottomPanelClipper(),
              child: Container(
                height: 156,
                color: const Color(0xFF0E0E0E),
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 52),
                alignment: Alignment.center,
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    height: 1.9,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'serif',
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 152,
            child: AnimatedSmoothIndicator(
              activeIndex: currentIndex,
              count: totalPages,
              effect: ExpandingDotsEffect(
                dotHeight: 6,
                dotWidth: 6,
                expansionFactor: 2.5,
                spacing: 6,
                dotColor: Colors.white.withValues(alpha: 0.35),
                activeDotColor: Colors.white,
              ),
            ),
          ),
          Positioned(
            top: 178,
            child: OnboardingCtaButton(
              key: const Key('onboarding_cta'),
              isLastPage: isLastPage,
              progress: (currentIndex + 1) / totalPages,
              onPressed: onCtaPressed,
              backgroundColor: pageColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomPanelClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    const notchRadius = 30.0;
    final centerX = size.width / 2;
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(0, size.height - notchRadius)
      ..lineTo(centerX - notchRadius * 1.05, size.height - notchRadius)
      ..arcToPoint(
        Offset(centerX + notchRadius * 1.05, size.height - notchRadius),
        radius: const Radius.circular(notchRadius),
        clockwise: false,
      )
      ..lineTo(size.width, size.height - notchRadius)
      ..lineTo(size.width, 0)
      ..close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
