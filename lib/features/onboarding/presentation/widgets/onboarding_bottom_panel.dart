import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'animated_onboarding_cta_slot.dart';
import 'onboarding_bottom_panel_painter.dart';
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

  static const figmaPanelWidth = 312.0;
  static const figmaPanelHeight = 156.0;
  static const figmaWidgetHeight = 251.0;
  static const horizontalMargin = 24.0;

  static double responsiveHeight(BuildContext context) {
    return _metricsForWidth(MediaQuery.sizeOf(context).width).widgetHeight;
  }

  static _BottomPanelMetrics _metricsForWidth(double availableWidth) {
    final hMargin = horizontalMargin.w;
    final maxPanelWidth = figmaPanelWidth.w;
    final panelWidth = (availableWidth - (hMargin * 2))
        .clamp(0.0, maxPanelWidth)
        .toDouble();
    final scale = panelWidth / figmaPanelWidth;
    final panelHeight = figmaPanelHeight * scale;
    final widgetHeight = figmaWidgetHeight * scale;
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
            : figmaPanelWidth + (horizontalMargin * 2);
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
                child: CustomPaint(painter: const BottomPanelPainter()),
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
                    child: AnimatedOnboardingCtaSlot(
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
