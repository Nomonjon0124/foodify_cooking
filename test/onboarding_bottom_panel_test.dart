import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'package:foodify_cooking/features/onboarding/presentation/widgets/onboarding_bottom_panel.dart';

void main() {
  testWidgets('OnboardingBottomPanel renders and handles CTA tap', (
    tester,
  ) async {
    var tapCount = 0;
    final pageController = PageController();
    addTearDown(pageController.dispose);

    await tester.pumpWidget(
      _withScreenUtil(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 360,
              height: 800,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: OnboardingBottomPanel(
                  title: 'Your personal guide to be a chef',
                  currentIndex: 0,
                  totalPages: 3,
                  isLastPage: false,
                  ctaLabel: 'Go',
                  pageColor: const Color(0xFF4058A0),
                  pageController: pageController,
                  onCtaPressed: () => tapCount++,
                ),
              ),
            ),
          ),
        ),
      ),
    );

    expect(find.byType(OnboardingBottomPanel), findsOneWidget);
    expect(find.byType(CustomPaint), findsWidgets);
    expect(find.byType(TweenAnimationBuilder<double>), findsAtLeastNWidgets(2));
    expect(find.byType(AnimatedContainer), findsOneWidget);
    expect(find.byType(AnimatedSwitcher), findsOneWidget);
    expect(find.byType(SmoothPageIndicator), findsOneWidget);
    expect(find.byKey(const Key('onboarding_cta')), findsOneWidget);

    await tester.tap(find.byKey(const Key('onboarding_cta')));
    await tester.pump();

    expect(tapCount, 1);
  });

  testWidgets('OnboardingBottomPanel shows Go on the last page', (
    tester,
  ) async {
    final pageController = PageController();
    addTearDown(pageController.dispose);

    await tester.pumpWidget(
      _withScreenUtil(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 360,
              height: 800,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: OnboardingBottomPanel(
                  title: 'Foodify Your Global Kitchen',
                  currentIndex: 2,
                  totalPages: 3,
                  isLastPage: true,
                  ctaLabel: 'Go',
                  pageColor: const Color(0xFFDEE21B),
                  pageController: pageController,
                  onCtaPressed: () {},
                ),
              ),
            ),
          ),
        ),
      ),
    );

    expect(find.text('Go'), findsOneWidget);
  });

  testWidgets(
    'OnboardingBottomPanel animates CTA when the page index changes',
    (tester) async {
      var currentIndex = 0;
      final pageController = PageController();
      addTearDown(pageController.dispose);

      await tester.pumpWidget(
        _withScreenUtil(
          MaterialApp(
            home: StatefulBuilder(
              builder: (context, setState) {
                return Scaffold(
                  body: SizedBox(
                    width: 360,
                    height: 800,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: OnboardingBottomPanel(
                        title: currentIndex == 0
                            ? 'Your personal guide to be a chef'
                            : 'Share the Love, Share the Recipe',
                        currentIndex: currentIndex,
                        totalPages: 3,
                        isLastPage: false,
                        ctaLabel: 'Go',
                        pageColor: currentIndex == 0
                            ? const Color(0xFF4058A0)
                            : const Color(0xFFFF6339),
                        pageController: pageController,
                        onCtaPressed: () => setState(() => currentIndex = 1),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('onboarding_cta')));
      await tester.pump();

      expect(
        find.byType(TweenAnimationBuilder<double>),
        findsAtLeastNWidgets(2),
      );
      expect(find.byType(AnimatedContainer), findsOneWidget);
      expect(find.byType(AnimatedSwitcher), findsOneWidget);
    },
  );

  testWidgets(
    'OnboardingBottomPanel indicator dot tap animates the attached PageController',
    (tester) async {
      final pageController = PageController();
      addTearDown(pageController.dispose);

      await tester.pumpWidget(
        _withScreenUtil(
          MaterialApp(
            home: Scaffold(
              body: SizedBox(
                width: 360,
                height: 800,
                child: Stack(
                  children: [
                    PageView(
                      controller: pageController,
                      children: const [
                        ColoredBox(color: Color(0xFF4058A0)),
                        ColoredBox(color: Color(0xFFFF6339)),
                        ColoredBox(color: Color(0xFFDEE21B)),
                      ],
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: OnboardingBottomPanel(
                        title: 'Your personal guide to be a chef',
                        currentIndex: 0,
                        totalPages: 3,
                        isLastPage: false,
                        ctaLabel: 'Go',
                        pageColor: const Color(0xFF4058A0),
                        pageController: pageController,
                        onCtaPressed: () {},
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final indicatorRect = tester.getRect(find.byType(SmoothPageIndicator));
      await tester.tapAt(
        Offset(indicatorRect.right - 2, indicatorRect.center.dy),
      );
      await tester.pumpAndSettle();

      expect(pageController.page, closeTo(2, 0.01));
    },
  );
}

Widget _withScreenUtil(Widget child) {
  return ScreenUtilInit(
    designSize: const Size(360, 800),
    minTextAdapt: true,
    splitScreenMode: true,
    builder: (context, _) => child,
  );
}
