import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:foodify_cooking/app/cubit/app_shell_cubit.dart';
import 'package:foodify_cooking/app/cubit/app_start_cubit.dart';
import 'package:foodify_cooking/core/di/injection_container.dart';
import 'package:foodify_cooking/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:foodify_cooking/features/auth/presentation/cubit/profile_cubit.dart';
import 'package:foodify_cooking/features/home/presentation/cubit/home_cubit.dart';
import 'package:foodify_cooking/features/onboarding/presentation/cubit/onboarding_cubit.dart';
import 'package:foodify_cooking/features/recipe/presentation/cubit/recipe_detail_cubit.dart';
import 'package:foodify_cooking/features/search/presentation/cubit/search_cubit.dart';
import 'package:foodify_cooking/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:foodify_cooking/features/splash/presentation/cubit/splash_cubit.dart';

void main() {
  test('DI resolves core and feature cubits', () async {
    await configureDependencies();

    expect(getIt<AppStartCubit>(), isA<AppStartCubit>());
    expect(getIt<AppShellCubit>(), isA<AppShellCubit>());
    expect(getIt.isRegistered<SupabaseClient>(), isTrue);
    expect(getIt<HomeCubit>(), isA<HomeCubit>());
    expect(getIt<OnboardingCubit>(), isA<OnboardingCubit>());
    expect(getIt<RecipeDetailCubit>(), isA<RecipeDetailCubit>());
    expect(getIt<SearchCubit>(), isA<SearchCubit>());
    expect(getIt<SettingsCubit>(), isA<SettingsCubit>());
    expect(getIt<SplashCubit>(), isA<SplashCubit>());
    expect(getIt<AuthCubit>(), isA<AuthCubit>());
    expect(getIt<ProfileCubit>(), isA<ProfileCubit>());

    await getIt.reset();
  });

  test('App works when auth feature registration is disabled', () async {
    await configureDependencies(enableAuthFeature: false);

    expect(getIt.isRegistered<AppStartCubit>(), isTrue);
    expect(getIt.isRegistered<SupabaseClient>(), isTrue);
    expect(getIt.isRegistered<HomeCubit>(), isTrue);
    expect(getIt.isRegistered<OnboardingCubit>(), isTrue);
    expect(getIt.isRegistered<SearchCubit>(), isTrue);
    expect(getIt.isRegistered<SplashCubit>(), isTrue);
    expect(getIt.isRegistered<AuthCubit>(), isFalse);
    expect(getIt.isRegistered<ProfileCubit>(), isFalse);

    await getIt.reset();
  });
}
