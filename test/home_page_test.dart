import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:foodify_cooking/common/widgets/foodify_app_bar.dart';
import 'package:foodify_cooking/common/widgets/foodify_components/foodify_components_preview.dart';
import 'package:foodify_cooking/common/widgets/foodify_components/foodify_popular_card.dart';
import 'package:foodify_cooking/common/widgets/recipe_cards/recipe_main_card.dart';
import 'package:foodify_cooking/core/di/injection_container.dart';
import 'package:foodify_cooking/features/home/domain/entities/home_feed.dart';
import 'package:foodify_cooking/features/home/domain/repositories/home_repository.dart';
import 'package:foodify_cooking/features/home/presentation/pages/home_page.dart';
import 'helpers/localized_app.dart';

void main() {
  setUpAll(() async {
    await configureDependencies();
    await getIt.unregister<HomeRepository>();
    getIt.registerLazySingleton<HomeRepository>(_FakeHomeRepository.new);
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
          return MaterialApp(
            locale: testLocale,
            localizationsDelegates: testLocalizationsDelegates,
            supportedLocales: testSupportedLocales,
            home: Scaffold(
              body: const Column(
                children: [
                  FoodifyAppBar.home(),
                  FoodifyAppBar.titleAction(
                    title: 'New Recipe',
                    actionText: 'Clear all',
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(FoodifyAppBar), findsNWidgets(2));
    expect(find.byKey(const Key('foodify_filter_button')), findsNothing);
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
          return MaterialApp(
            locale: testLocale,
            localizationsDelegates: testLocalizationsDelegates,
            supportedLocales: testSupportedLocales,
            home: const HomePage(),
          );
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

class _FakeHomeRepository implements HomeRepository {
  @override
  Future<HomeFeed> getHomeFeed() async {
    return const HomeFeed(
      popularRecipes: [
        HomeRecipe(
          id: 'popular-1',
          title: 'chocolate ice cream buttercream fruit',
          coverImageUrl:
              'assets/images/foodify_components/popular_card_icecream.png',
          topRatingLabel: '4.8',
        ),
        HomeRecipe(
          id: 'popular-2',
          title: 'chocolate cake with buttercream frosting',
          coverImageUrl:
              'assets/images/foodify_components/popular_card_cake.png',
          topRatingLabel: '4.8',
        ),
        HomeRecipe(
          id: 'popular-3',
          title: 'Italian pineapple pizza',
          coverImageUrl:
              'assets/images/foodify_components/popular_card_pizza.png',
          topRatingLabel: '4.8',
        ),
      ],
      latestRecipes: [
        HomeRecipe(
          id: 'latest-1',
          title: 'Frosted pinecone cake',
          description:
              'In a large bowl, mix together flour, baking powder, sugar, and salt..',
          durationLabel: '30 Min',
          difficultyLabel: 'Medium',
          coverImageUrl: 'assets/images/recipe_cards/main_card_content.png',
          overlayImageUrl:
              'assets/images/recipe_cards/main_card_content_overlay.png',
          topRatingLabel: '4.8',
          author: HomeProfile(
            id: 'author-1',
            displayName: 'Kelly Mayer',
            avatarUrl: 'assets/images/recipe_cards/user_pic.png',
            ratingLabel: '4.9',
          ),
        ),
        HomeRecipe(
          id: 'latest-2',
          title: 'Classic Victoria sandwich recip...',
          description:
              'In a large bowl, mix together flour, baking powder, sugar, and salt..',
          durationLabel: '120 Min',
          difficultyLabel: 'Simple',
          coverImageUrl: 'assets/images/recipe_cards/main_card_content.png',
          overlayImageUrl:
              'assets/images/recipe_cards/main_card_content_victoria.png',
          topRatingLabel: '3.8',
          author: HomeProfile(
            id: 'author-2',
            displayName: 'Rick Dolynsky',
            avatarUrl: 'assets/images/recipe_cards/user_pic_rick.png',
            ratingLabel: '4.4',
          ),
        ),
        HomeRecipe(
          id: 'latest-3',
          title: 'Pea and Ricotta Omelets',
          description:
              'In a large bowl, mix together flour, baking powder, sugar, and salt..',
          durationLabel: '15 Min',
          difficultyLabel: 'Hard',
          coverImageUrl: 'assets/images/recipe_cards/main_card_content.png',
          overlayImageUrl:
              'assets/images/recipe_cards/main_card_content_omelets.png',
          topRatingLabel: '4.5',
          author: HomeProfile(
            id: 'author-3',
            displayName: 'Dave Robert',
            avatarUrl: 'assets/images/recipe_cards/user_pic_dave.png',
            ratingLabel: '5.0',
          ),
        ),
      ],
    );
  }
}
