import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:foodify_cooking/core/gen/assets.gen.dart';
import 'package:foodify_cooking/features/onboarding/presentation/widgets/onboarding_bottom_panel.dart';
import 'package:foodify_cooking/features/onboarding/presentation/widgets/onboarding_page_content.dart';

void main() {
  testWidgets(
    'Onboarding food images stay above the bottom panel on small screens',
    (tester) async {
      await _pumpResponsiveOnboarding(tester, const Size(320, 640));

      final panelTop = tester.getTopLeft(find.byType(OnboardingBottomPanel)).dy;
      final plateFinder = find.byKey(const Key('onboarding_plate_image'));

      expect(plateFinder, findsNWidgets(3));
      for (var i = 0; i < 3; i++) {
        final plateBottom = tester.getRect(plateFinder.at(i)).bottom;
        expect(plateBottom <= panelTop, isTrue);
      }
    },
  );

  testWidgets('Onboarding responsive layout renders at Figma base size', (
    tester,
  ) async {
    await _pumpResponsiveOnboarding(tester, const Size(360, 800));

    expect(find.byType(OnboardingBottomPanel), findsOneWidget);
    expect(find.byKey(const Key('onboarding_plate_image')), findsNWidgets(3));
  });

  testWidgets(
    'Onboarding responsive layout remains centered on larger phones',
    (tester) async {
      await _pumpResponsiveOnboarding(tester, const Size(430, 932));

      final panelRect = tester.getRect(find.byType(OnboardingBottomPanel));
      final screenCenterX = 430 / 2;

      expect(panelRect.center.dx, closeTo(screenCenterX, 1));
      expect(find.byKey(const Key('onboarding_plate_image')), findsNWidgets(3));
    },
  );
}

Future<void> _pumpResponsiveOnboarding(WidgetTester tester, Size size) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = size;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  final pageController = PageController();
  addTearDown(pageController.dispose);

  await tester.pumpWidget(
    ScreenUtilInit(
      designSize: const Size(360, 800),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, _) {
        return MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                final bottomReservedHeight =
                    OnboardingBottomPanel.responsiveHeight(context);
                return Stack(
                  children: [
                    OnboardingPageContent(
                      backgroundColor: const Color(0xFF4058A0),
                      imagePaths: [
                        Assets.images.onboarding.onboarding11.path,
                        Assets.images.onboarding.onboarding12.path,
                        Assets.images.onboarding.onboarding13.path,
                      ],
                      isActive: true,
                      bottomReservedHeight: bottomReservedHeight,
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: OnboardingBottomPanel(
                        title: 'Your personal guide to be a chef',
                        currentIndex: 0,
                        totalPages: 3,
                        isLastPage: false,
                        pageColor: const Color(0xFF4058A0),
                        pageController: pageController,
                        onCtaPressed: () {},
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    ),
  );

  await tester.pumpAndSettle();
}
