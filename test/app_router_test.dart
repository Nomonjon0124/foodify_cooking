import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
    await tester.pumpWidget(
      _withScreenUtil(MaterialApp.router(routerConfig: AppRouter.router)),
    );
    await tester.pump();

    expect(find.byType(SplashLoadingDots), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 1900));
    await tester.pumpAndSettle();

    expect(find.text('Your personal guide to be a chef'), findsOneWidget);
    expect(find.text('Login'), findsNothing);
  });

  testWidgets('Bottom navigation switches between tabs', (tester) async {
    await tester.pumpWidget(
      _withScreenUtil(MaterialApp.router(routerConfig: AppRouter.router)),
    );
    AppRouter.router.go(RouteNames.home);
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('bottom_nav_label_Home')), findsOneWidget);
    expect(find.byKey(const Key('bottom_nav_label_Search')), findsOneWidget);
    expect(find.byKey(const Key('bottom_nav_label_Add New')), findsOneWidget);
    expect(find.byKey(const Key('bottom_nav_label_Save')), findsOneWidget);
    expect(find.byKey(const Key('bottom_nav_label_Profile')), findsOneWidget);

    await tester.tap(find.byKey(const Key('bottom_nav_label_Search')));
    await tester.pumpAndSettle();
    expect(find.text('Recipes'), findsOneWidget);
    expect(find.text('Chefs'), findsOneWidget);
    expect(find.text('Tags'), findsOneWidget);

    await tester.tap(find.byKey(const Key('bottom_nav_label_Add New')));
    await tester.pumpAndSettle();
    expect(find.text('Add a recipe Cover'), findsOneWidget);

    AppRouter.router.go(RouteNames.save);
    await tester.pumpAndSettle();
    expect(find.text('TODO: Implement saved recipes flow'), findsOneWidget);

    AppRouter.router.go(RouteNames.profile);
    await tester.pumpAndSettle();
    expect(find.text('Guest mode: no profile loaded'), findsOneWidget);
  });
}

Widget _withScreenUtil(Widget child) {
  return ScreenUtilInit(
    designSize: const Size(360, 800),
    minTextAdapt: true,
    splitScreenMode: true,
    builder: (context, _) => child,
  );
}
