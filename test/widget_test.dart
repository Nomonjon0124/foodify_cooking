import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:foodify_cooking/app/app.dart';
import 'package:foodify_cooking/config/routes/app_router.dart';
import 'package:foodify_cooking/config/routes/route_names.dart';
import 'package:foodify_cooking/core/di/injection_container.dart';

void main() {
  setUpAll(() async {
    await configureDependencies();
  });

  tearDownAll(() async {
    await getIt.reset();
  });

  testWidgets('App boots and shows onboarding after splash', (tester) async {
    AppRouter.router.go(RouteNames.splash);
    await tester.pumpWidget(const App());
    await tester.pump(const Duration(milliseconds: 1900));
    await tester.pumpAndSettle();

    expect(
      find.text("Oshpaz bo'lishingiz uchun shaxsiy yo'lboshchi"),
      findsOneWidget,
    );
    expect(find.byType(PageView), findsOneWidget);
  });
}
