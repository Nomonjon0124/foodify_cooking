import 'package:flutter_test/flutter_test.dart';

import 'package:foodify_cooking/app/cubit/app_shell_cubit.dart';
import 'package:foodify_cooking/app/cubit/app_start_cubit.dart';
import 'package:foodify_cooking/core/di/injection_container.dart';
import 'package:foodify_cooking/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:foodify_cooking/features/home/presentation/cubit/home_cubit.dart';
import 'package:foodify_cooking/features/onboarding/presentation/cubit/onboarding_cubit.dart';
import 'package:foodify_cooking/features/recipe/presentation/cubit/recipe_cubit.dart';
import 'package:foodify_cooking/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:foodify_cooking/features/splash/presentation/cubit/splash_cubit.dart';

void main() {
  test('DI resolves core and feature cubits', () async {
    await configureDependencies();

    expect(getIt<AppStartCubit>(), isA<AppStartCubit>());
    expect(getIt<AppShellCubit>(), isA<AppShellCubit>());
    expect(getIt<HomeCubit>(), isA<HomeCubit>());
    expect(getIt<OnboardingCubit>(), isA<OnboardingCubit>());
    expect(getIt<RecipeCubit>(), isA<RecipeCubit>());
    expect(getIt<SettingsCubit>(), isA<SettingsCubit>());
    expect(getIt<SplashCubit>(), isA<SplashCubit>());
    expect(getIt<AuthCubit>(), isA<AuthCubit>());

    await getIt.reset();
  });

  test('App works when auth feature registration is disabled', () async {
    await configureDependencies(enableAuthFeature: false);

    expect(getIt.isRegistered<AppStartCubit>(), isTrue);
    expect(getIt.isRegistered<HomeCubit>(), isTrue);
    expect(getIt.isRegistered<OnboardingCubit>(), isTrue);
    expect(getIt.isRegistered<SplashCubit>(), isTrue);
    expect(getIt.isRegistered<AuthCubit>(), isFalse);

    await getIt.reset();
  });
}
