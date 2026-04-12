import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:foodify_cooking/common/widgets/recipe_cards/recipe_main_card.dart';
import 'package:foodify_cooking/core/di/injection_container.dart';
import 'package:foodify_cooking/features/home/presentation/pages/home_page.dart';

void main() {
  setUpAll(() async {
    await configureDependencies();
  });

  tearDownAll(() async {
    await getIt.reset();
  });

  testWidgets('HomePage renders RecipeMainCard demo', (tester) async {
    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(360, 800),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, _) {
          return const MaterialApp(home: HomePage());
        },
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(RecipeMainCard), findsOneWidget);
    expect(find.text('Muffin with Blue Cream'), findsOneWidget);
  });
}
