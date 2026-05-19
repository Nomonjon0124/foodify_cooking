import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../app/presentation/pages/app_shell_page.dart';
import '../../core/di/injection_container.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/profile_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/add_new/presentation/pages/add_new_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../../features/recipe/presentation/pages/recipe_page.dart';
import '../../features/save/presentation/pages/save_page.dart';
import '../../features/search/presentation/pages/search_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../app/cubit/app_shell_cubit.dart';
import '../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../features/save/presentation/cubit/saved_recipes_cubit.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
import 'auth_callback_route.dart';
import 'route_names.dart';

abstract final class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: RouteNames.splash,
    redirect: (context, state) {
      final uri = state.uri;
      if (!AuthCallbackRoute.matches(uri)) return null;

      if (AuthCallbackRoute.hasFailure(uri) &&
          getIt.isRegistered<AuthCubit>()) {
        final message = AuthCallbackRoute.failureMessage(uri);
        scheduleMicrotask(() {
          if (getIt.isRegistered<AuthCubit>()) {
            unawaited(getIt<AuthCubit>().handleAuthCallbackFailure(message));
          }
        });
      }

      return AuthCallbackRoute.redirectLocation(uri);
    },
    routes: [
      GoRoute(
        path: RouteNames.splash,
        name: 'splash',
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: RouteNames.onboarding,
        name: 'onboarding',
        builder: (context, state) => const OnboardingPage(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MultiBlocProvider(
            providers: [
              BlocProvider<AppShellCubit>.value(value: getIt<AppShellCubit>()),
              if (getIt.isRegistered<AuthCubit>())
                BlocProvider<AuthCubit>.value(value: getIt<AuthCubit>()),
              if (getIt.isRegistered<SavedRecipesCubit>())
                BlocProvider<SavedRecipesCubit>.value(
                  value: getIt<SavedRecipesCubit>(),
                ),
            ],
            child: AppShellPage(navigationShell: navigationShell),
          );
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteNames.home,
                name: 'home',
                builder: (context, state) => const HomePage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteNames.search,
                name: 'search',
                builder: (context, state) => const SearchPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteNames.addNew,
                name: 'add-new',
                builder: (context, state) => const AddNewPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteNames.save,
                name: 'save',
                builder: (context, state) => const SavePage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteNames.profile,
                name: 'profile',
                builder: (context, state) => const ProfilePage(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: RouteNames.login,
        name: 'login',
        builder: (context, state) =>
            LoginPage(returnTo: state.uri.queryParameters['returnTo']),
      ),
      GoRoute(
        path: RouteNames.register,
        name: 'register',
        builder: (context, state) =>
            RegisterPage(returnTo: state.uri.queryParameters['returnTo']),
      ),
      GoRoute(
        path: RouteNames.recipes,
        name: 'recipes',
        builder: (context, state) => const RecipePage(),
      ),
      GoRoute(
        path: RouteNames.settings,
        name: 'settings',
        builder: (context, state) => const SettingsPage(),
      ),
    ],
  );
}
