import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:foodify_cooking/common/widgets/foodify_app_bar.dart';
import 'package:foodify_cooking/common/widgets/foodify_components/foodify_components_preview.dart';
import 'package:foodify_cooking/common/widgets/foodify_components/foodify_popular_card.dart';
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

  testWidgets('FoodifyAppBar renders home and title action variants', (
    tester,
  ) async {
    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(360, 800),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, _) {
          return const MaterialApp(
            home: Column(
              children: [
                FoodifyAppBar.home(),
                FoodifyAppBar.titleAction(
                  title: 'New Recipe',
                  actionText: 'Clear all',
                ),
              ],
            ),
          );
        },
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(FoodifyAppBar), findsNWidgets(2));
    expect(find.byKey(const Key('foodify_filter_button')), findsOneWidget);
    expect(find.text('New Recipe'), findsOneWidget);
    expect(find.text('Clear all'), findsOneWidget);
  });

  testWidgets('HomePage renders Figma home composition', (tester) async {
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

    expect(find.byType(FoodifyAppBar), findsOneWidget);
    expect(find.text('Popular Recipes'), findsOneWidget);
    expect(find.text('The Latest Recipes'), findsOneWidget);
    expect(find.byType(FoodifyPopularCard), findsNWidgets(3));
    expect(find.byType(RecipeMainCard), findsNWidgets(3));
    expect(find.text('Frosted pinecone cake'), findsOneWidget);
    expect(find.text('Classic Victoria sandwich recip...'), findsOneWidget);
    expect(find.text('Pea and Ricotta Omelets'), findsOneWidget);
    expect(find.byType(FoodifyComponentsPreview), findsNothing);
  });
}
