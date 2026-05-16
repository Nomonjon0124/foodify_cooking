import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodify_cooking/config/routes/route_names.dart';
import 'package:foodify_cooking/features/splash/presentation/widgets/splash_loading_dots.dart';

import 'package:foodify_cooking/config/routes/app_router.dart';
import 'package:foodify_cooking/core/di/injection_container.dart';
import 'package:foodify_cooking/features/auth/domain/entities/profile_view.dart';
import 'package:foodify_cooking/features/auth/domain/repositories/profile_repository.dart';
import 'package:foodify_cooking/features/home/domain/entities/home_feed.dart';
import 'package:foodify_cooking/features/home/domain/repositories/home_repository.dart';
import 'package:foodify_cooking/features/search/domain/entities/search_results.dart';
import 'package:foodify_cooking/features/search/domain/repositories/search_repository.dart';
import 'helpers/localized_app.dart';

void main() {
  setUpAll(() async {
    await configureDependencies();
    await getIt.unregister<HomeRepository>();
    await getIt.unregister<SearchRepository>();
    await getIt.unregister<ProfileRepository>();
    getIt.registerLazySingleton<HomeRepository>(_FakeHomeRepository.new);
    getIt.registerLazySingleton<SearchRepository>(_FakeSearchRepository.new);
    getIt.registerLazySingleton<ProfileRepository>(_FakeProfileRepository.new);
  });

  tearDownAll(() async {
    await getIt.reset();
  });

  testWidgets('Router starts from splash and opens onboarding', (tester) async {
    AppRouter.router.go(RouteNames.splash);
    await tester.pumpWidget(
      _withScreenUtil(
        MaterialApp.router(
          locale: testLocale,
          localizationsDelegates: testLocalizationsDelegates,
          supportedLocales: testSupportedLocales,
          routerConfig: AppRouter.router,
        ),
      ),
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
      _withScreenUtil(
        MaterialApp.router(
          locale: testLocale,
          localizationsDelegates: testLocalizationsDelegates,
          supportedLocales: testSupportedLocales,
          routerConfig: AppRouter.router,
        ),
      ),
    );
    AppRouter.router.go(RouteNames.home);
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('bottom_nav_item_home_label')), findsOneWidget);
    expect(
      find.byKey(const Key('bottom_nav_item_search_label')),
      findsOneWidget,
    );
    expect(
      find.byKey(const Key('bottom_nav_item_add_new_label')),
      findsOneWidget,
    );
    expect(find.byKey(const Key('bottom_nav_item_save_label')), findsOneWidget);
    expect(
      find.byKey(const Key('bottom_nav_item_profile_label')),
      findsOneWidget,
    );

    await tester.tap(find.byKey(const Key('bottom_nav_item_search')));
    await tester.pumpAndSettle();
    expect(find.text('Recipes'), findsOneWidget);
    expect(find.text('Chefs'), findsOneWidget);
    expect(find.text('Tags'), findsOneWidget);

    await tester.tap(find.byKey(const Key('bottom_nav_item_add_new')));
    await tester.pumpAndSettle();
    expect(find.text('Add a recipe Cover'), findsOneWidget);

    AppRouter.router.go(RouteNames.save);
    await tester.pumpAndSettle();
    expect(find.text('TODO: Implement saved recipes flow'), findsOneWidget);

    AppRouter.router.go(RouteNames.profile);
    await tester.pumpAndSettle();
    expect(find.text('Mark Salvador'), findsOneWidget);
  });
}

class _FakeHomeRepository implements HomeRepository {
  @override
  Future<HomeFeed> getHomeFeed() async {
    return const HomeFeed.empty();
  }
}

class _FakeSearchRepository implements SearchRepository {
  @override
  Future<SearchResults> search(String query) async {
    return const SearchResults(
      recipes: [
        SearchRecipe(
          id: 'recipe-1',
          title: 'chocolate cake with buttercream frosting',
          ratingLabel: '4.8',
          imageUrl: '',
        ),
      ],
      chefs: [SearchChef(id: 'chef-1', name: 'Kelly Mayer', avatarUrl: '')],
      tags: [SearchTag(id: 'tag-1', displayName: '#egg')],
    );
  }
}

class _FakeProfileRepository implements ProfileRepository {
  @override
  Future<ProfileView> getDemoProfile() async {
    return const ProfileView(
      id: 'profile-1',
      displayName: 'Mark Salvador',
      location: 'New York, USA',
      bio:
          'To cook is to see how simple ingredients can create magic on the plate.',
      avatarUrl: '',
      coverImageUrl: '',
      ratingLabel: '5.0',
      followersLabel: '357K',
      followingLabel: '24',
      postsCount: 18,
      recipes: [
        ProfileRecipe(
          id: 'recipe-1',
          title: 'chocolate cake with buttercream frosting',
          chefName: 'Mark Salvador',
          ratingLabel: '4.8',
          durationLabel: '30 Min',
          difficultyLabel: 'Medium',
          description: 'A rich chocolate cake.',
          imageUrl: '',
          chefAvatarUrl: '',
        ),
      ],
    );
  }
}

Widget _withScreenUtil(Widget child) {
  return ScreenUtilInit(
    designSize: const Size(360, 800),
    minTextAdapt: true,
    splitScreenMode: true,
    builder: (context, _) => child,
  );
}
