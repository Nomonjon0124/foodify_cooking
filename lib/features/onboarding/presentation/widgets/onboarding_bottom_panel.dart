import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'onboarding_cta_button.dart';

class OnboardingBottomPanel extends StatelessWidget {
  const OnboardingBottomPanel({
    required this.title,
    required this.currentIndex,
    required this.totalPages,
    required this.isLastPage,
    required this.pageColor,
    required this.pageController,
    required this.onCtaPressed,
    super.key,
  });

  final String title;
  final int currentIndex;
  final int totalPages;
  final bool isLastPage;
  final Color pageColor;
  final PageController pageController;
  final VoidCallback onCtaPressed;

  static const _figmaPanelWidth = 312.0;
  static const _figmaPanelHeight = 156.0;
  static const _figmaWidgetHeight = 251.0;
  static const _horizontalMargin = 24.0;

  static double responsiveHeight(BuildContext context) {
    return _metricsForWidth(MediaQuery.sizeOf(context).width).widgetHeight;
  }

  static _BottomPanelMetrics _metricsForWidth(double availableWidth) {
    final horizontalMargin = _horizontalMargin.w;
    final maxPanelWidth = _figmaPanelWidth.w;
    final panelWidth = (availableWidth - (horizontalMargin * 2))
        .clamp(0.0, maxPanelWidth)
        .toDouble();
    final scale = panelWidth / _figmaPanelWidth;
    final panelHeight = _figmaPanelHeight * scale;
    final widgetHeight = _figmaWidgetHeight * scale;
    final panelLeft = (availableWidth - panelWidth) / 2;

    return _BottomPanelMetrics(
      panelWidth: panelWidth,
      panelHeight: panelHeight,
      widgetHeight: widgetHeight,
      panelLeft: panelLeft,
      scale: scale,
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : _figmaPanelWidth + (_horizontalMargin * 2);
        final metrics = _metricsForWidth(availableWidth);

        return SizedBox(
          height: metrics.widgetHeight,
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Positioned(
                left: metrics.panelLeft,
                top: 0,
                width: metrics.panelWidth,
                height: metrics.panelHeight,
                child: CustomPaint(painter: const _BottomPanelPainter()),
              ),
              Positioned(
                left: metrics.panelLeft + (13 * metrics.scale),
                top: 19 * metrics.scale,
                width: 285 * metrics.scale,
                height: 90 * metrics.scale,
                child: Center(
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.sp,
                      height: 1.9,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'serif',
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 127 * metrics.scale,
                child: SizedBox(
                  width: 78 * metrics.scale,
                  height: 78 * metrics.scale,
                  child: FittedBox(
                    child: _AnimatedOnboardingCtaSlot(
                      currentIndex: currentIndex,
                      child: OnboardingCtaButton(
                        key: const Key('onboarding_cta'),
                        isLastPage: isLastPage,
                        progress: (currentIndex + 1) / totalPages,
                        onPressed: onCtaPressed,
                        backgroundColor: pageColor,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 214 * metrics.scale,
                child: SmoothPageIndicator(
                  controller: pageController,
                  count: totalPages,
                  onDotClicked: (index) {
                    pageController.animateToPage(
                      index,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                  effect: ExpandingDotsEffect(
                    dotHeight: 6.r,
                    dotWidth: 6.r,
                    expansionFactor: 2.5,
                    spacing: 6.w,
                    dotColor: Colors.white.withValues(alpha: 0.35),
                    activeDotColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _BottomPanelMetrics {
  const _BottomPanelMetrics({
    required this.panelWidth,
    required this.panelHeight,
    required this.widgetHeight,
    required this.panelLeft,
    required this.scale,
  });

  final double panelWidth;
  final double panelHeight;
  final double widgetHeight;
  final double panelLeft;
  final double scale;
}

class _AnimatedOnboardingCtaSlot extends StatelessWidget {
  const _AnimatedOnboardingCtaSlot({
    required this.currentIndex,
    required this.child,
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

class _BottomPanelPainter extends CustomPainter {
  const _BottomPanelPainter();

  static const _color = Color(0xFF0E0E0E);
  static const _width = OnboardingBottomPanel._figmaPanelWidth;
  static const _height = OnboardingBottomPanel._figmaPanelHeight;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;

    final scaleX = size.width / _width;
    final scaleY = size.height / _height;
    Offset p(double x, double y) => Offset(x * scaleX, y * scaleY);

    final path = Path()
      ..moveTo(p(312, 146).dx, p(312, 146).dy)
      ..cubicTo(
        p(312, 151.523).dx,
        p(312, 151.523).dy,
        p(307.523, 156).dx,
        p(307.523, 156).dy,
        p(302, 156).dx,
        p(302, 156).dy,
      )
      ..lineTo(p(201.403, 156).dx, p(201.403, 156).dy)
      ..cubicTo(
        p(196.865, 156).dx,
        p(196.865, 156).dy,
        p(193.014, 152.872).dx,
        p(193.014, 152.872).dy,
        p(191.01, 148.801).dx,
        p(191.01, 148.801).dy,
      )
      ..cubicTo(
        p(184.655, 135.887).dx,
        p(184.655, 135.887).dy,
        p(171.366, 127).dx,
        p(171.366, 127).dy,
        p(156, 127).dx,
        p(156, 127).dy,
      )
      ..cubicTo(
        p(140.634, 127).dx,
        p(140.634, 127).dy,
        p(127.345, 135.887).dx,
        p(127.345, 135.887).dy,
        p(120.99, 148.801).dx,
        p(120.99, 148.801).dy,
      )
      ..cubicTo(
        p(118.986, 152.872).dx,
        p(118.986, 152.872).dy,
        p(115.135, 156).dx,
        p(115.135, 156).dy,
        p(110.597, 156).dx,
        p(110.597, 156).dy,
      )
      ..lineTo(p(10, 156).dx, p(10, 156).dy)
      ..cubicTo(
        p(4.477, 156).dx,
        p(4.477, 156).dy,
        p(0, 151.523).dx,
        p(0, 151.523).dy,
        p(0, 146).dx,
        p(0, 146).dy,
      )
      ..lineTo(p(0, 10).dx, p(0, 10).dy)
      ..cubicTo(
        p(0, 4.477).dx,
        p(0, 4.477).dy,
        p(4.477, 0).dx,
        p(4.477, 0).dy,
        p(10, 0).dx,
        p(10, 0).dy,
      )
      ..lineTo(p(302, 0).dx, p(302, 0).dy)
      ..cubicTo(
        p(307.523, 0).dx,
        p(307.523, 0).dy,
        p(312, 4.477).dx,
        p(312, 4.477).dy,
        p(312, 10).dx,
        p(312, 10).dy,
      )
      ..lineTo(p(312, 146).dx, p(312, 146).dy)
      ..close();

    canvas.drawPath(path, Paint()..color = _color);
  }

  @override
  bool shouldRepaint(covariant _BottomPanelPainter oldDelegate) => false;
}
