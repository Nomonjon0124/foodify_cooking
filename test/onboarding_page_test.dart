import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:foodify_cooking/core/di/injection_container.dart';
import 'package:foodify_cooking/features/onboarding/presentation/pages/onboarding_page.dart';

void main() {
  setUpAll(() async {
    await configureDependencies();
  });

  tearDownAll(() async {
    await getIt.reset();
  });

  testWidgets('Onboarding starts from first page and changes by CTA', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: OnboardingPage()));
    await tester.pumpAndSettle();

    expect(find.text('Your personal guide to be a chef'), findsOneWidget);
    expect(find.byType(PageView), findsOneWidget);

    await tester.tap(find.byKey(const Key('onboarding_cta')));
    await tester.pumpAndSettle();
    expect(find.text('Share the Love, Share the Recipe'), findsOneWidget);

    await tester.tap(find.byKey(const Key('onboarding_cta')));
    await tester.pumpAndSettle();
    expect(find.text('Foodify Your Global Kitchen'), findsOneWidget);
    expect(find.text('Go'), findsOneWidget);
  });
}
