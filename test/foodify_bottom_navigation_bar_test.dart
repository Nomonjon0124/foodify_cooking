import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:foodify_cooking/app/presentation/widgets/foodify_bottom_navigation_bar.dart';
import 'helpers/localized_app.dart';

void main() {
  testWidgets(
    'FoodifyBottomNavigationBar matches Figma base height and labels',
    (tester) async {
      await _pumpNav(tester, currentIndex: 0);

      expect(find.byType(FoodifyBottomNavigationBar), findsOneWidget);
      expect(
        tester.getSize(find.byType(FoodifyBottomNavigationBar)).height,
        closeTo(93, 0.01),
      );
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Search'), findsOneWidget);
      expect(find.text('Add New'), findsOneWidget);
      expect(find.text('Save'), findsOneWidget);
      expect(find.text('Profile'), findsOneWidget);
    },
  );

  testWidgets('FoodifyBottomNavigationBar renders active and inactive colors', (
    tester,
  ) async {
    await _pumpNav(tester, currentIndex: 0);

    final activeShapeFinder = find.byKey(const Key('bottom_nav_active_shape'));
    expect(activeShapeFinder, findsOneWidget);
    expect(tester.widget<CustomPaint>(activeShapeFinder).painter, isNotNull);
    expect(tester.getSize(activeShapeFinder), const Size(110, 52));

    final activeTextStyle = _labelStyle(tester, 'home');
    final inactiveTextStyle = _labelStyle(tester, 'search');
    expect(activeTextStyle.color, Colors.white);
    expect(inactiveTextStyle.color, const Color(0xFFCBCBCB));
  });

  testWidgets('FoodifyBottomNavigationBar exposes tap callbacks by index', (
    tester,
  ) async {
    var selectedIndex = 0;
    await _pumpNav(
      tester,
      currentIndex: selectedIndex,
      onTap: (index) => selectedIndex = index,
    );

    for (final entry in <String, int>{
      'home': 0,
      'search': 1,
      'add_new': 2,
      'save': 3,
      'profile': 4,
    }.entries) {
      await tester.tap(find.byKey(Key('bottom_nav_item_${entry.key}')));
      await tester.pumpAndSettle();
      expect(selectedIndex, entry.value);
    }
  });

  testWidgets('FoodifyBottomNavigationBar active shape uses Figma positions', (
    tester,
  ) async {
    for (final entry in <int, double>{
      0: 4,
      1: 64,
      2: 123,
      3: 182,
      4: 241,
    }.entries) {
      await _pumpNav(tester, currentIndex: entry.key);

      final rect = tester.getRect(
        find.byKey(const Key('bottom_nav_active_shape')),
      );
      expect(rect.left, closeTo(entry.value, 0.01));
      expect(rect.top, closeTo(707, 0.01));
    }
  });
}

TextStyle _labelStyle(WidgetTester tester, String id) {
  return tester
      .widget<AnimatedDefaultTextStyle>(
        find.byKey(Key('bottom_nav_item_${id}_label_style')),
      )
      .style;
}

Future<void> _pumpNav(
  WidgetTester tester, {
  required int currentIndex,
  ValueChanged<int>? onTap,
}) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = const Size(360, 800);
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  await tester.pumpWidget(
    ScreenUtilInit(
      designSize: const Size(360, 800),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, _) {
        return MaterialApp(
          locale: testLocale,
          localizationsDelegates: testLocalizationsDelegates,
          supportedLocales: testSupportedLocales,
          home: Scaffold(
            bottomNavigationBar: FoodifyBottomNavigationBar(
              currentIndex: currentIndex,
              onTap: onTap ?? (_) {},
            ),
          ),
        );
      },
    ),
  );
  await tester.pumpAndSettle();
}
