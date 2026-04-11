import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodify_cooking/config/routes/route_names.dart';
import 'package:foodify_cooking/features/splash/presentation/widgets/splash_loading_dots.dart';

import 'package:foodify_cooking/config/routes/app_router.dart';
import 'package:foodify_cooking/core/di/injection_container.dart';

void main() {
  setUpAll(() async {
    await configureDependencies();
  });

  tearDownAll(() async {
    await getIt.reset();
  });

  testWidgets('Router starts from splash and opens onboarding', (tester) async {
    AppRouter.router.go(RouteNames.splash);
    await tester.pumpWidget(MaterialApp.router(routerConfig: AppRouter.router));
    await tester.pump();

    expect(find.byType(SplashLoadingDots), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 1900));
    await tester.pumpAndSettle();

    expect(find.text('Your personal guide to be a chef'), findsOneWidget);
    expect(find.text('Login'), findsNothing);
  });

  testWidgets('Bottom navigation switches between tabs', (tester) async {
    await tester.pumpWidget(MaterialApp.router(routerConfig: AppRouter.router));
    AppRouter.router.go(RouteNames.home);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Recipes'));
    await tester.pumpAndSettle();
    expect(find.text('Recipes'), findsWidgets);
    expect(find.text('No recipes found'), findsNothing);

    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();
    expect(find.text('Sign in (optional)'), findsOneWidget);
  });
}
