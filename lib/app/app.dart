import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../config/routes/app_router.dart';
import '../config/theme/app_theme.dart';
import '../core/di/injection_container.dart';
import '../core/services/supabase_service.dart';
import '../features/auth/presentation/auth_error_l10n.dart';
import '../features/auth/presentation/cubit/auth_cubit.dart';
import '../features/auth/presentation/cubit/auth_state.dart';
import '../features/save/presentation/cubit/saved_recipes_cubit.dart';
import '../features/settings/presentation/cubit/settings_cubit.dart';
import '../features/settings/presentation/cubit/settings_state.dart';
import '../l10n/generated/app_localizations.dart';
import '../l10n/l10n_extension.dart';
import 'cubit/app_start_cubit.dart';
import 'cubit/app_start_state.dart';

final _rootScaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 800),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider<SettingsCubit>(
              create: (_) => getIt<SettingsCubit>()..loadPreferences(),
            ),
            BlocProvider<AppStartCubit>(
              create: (_) => getIt<AppStartCubit>()..initialize(),
            ),
            if (getIt.isRegistered<AuthCubit>() &&
                SupabaseService.isInitialized)
              BlocProvider<AuthCubit>(
                create: (_) => getIt<AuthCubit>()..initialize(),
              ),
            if (getIt.isRegistered<SavedRecipesCubit>())
              BlocProvider<SavedRecipesCubit>.value(
                value: getIt<SavedRecipesCubit>(),
              ),
          ],
          child: BlocBuilder<SettingsCubit, SettingsState>(
            builder: (context, settingsState) {
              return BlocBuilder<AppStartCubit, AppStartState>(
                builder: (context, appStartState) {
                  if (appStartState.status == AppStartStatus.loading ||
                      appStartState.status == AppStartStatus.initial) {
                    return _LocalizedMaterialApp(
                      languageCode: settingsState.languageCode,
                      home: const Scaffold(
                        body: Center(child: CircularProgressIndicator()),
                      ),
                    );
                  }

                  if (appStartState.status == AppStartStatus.failure) {
                    return _LocalizedMaterialApp(
                      languageCode: settingsState.languageCode,
                      home: Builder(
                        builder: (context) {
                          return Scaffold(
                            body: Center(
                              child: Text(
                                appStartState.errorMessage ??
                                    context.l10n.startupError,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }

                  final app = MaterialApp.router(
                    scaffoldMessengerKey: _rootScaffoldMessengerKey,
                    onGenerateTitle: (context) => context.l10n.appTitle,
                    debugShowCheckedModeBanner: false,
                    locale: _localeFromLanguageCode(settingsState.languageCode),
                    localizationsDelegates:
                        AppLocalizations.localizationsDelegates,
                    supportedLocales: AppLocalizations.supportedLocales,
                    theme: AppTheme.lightTheme,
                    darkTheme: AppTheme.darkTheme,
                    routerConfig: AppRouter.router,
                  );

                  if (!getIt.isRegistered<AuthCubit>() ||
                      !SupabaseService.isInitialized) {
                    return app;
                  }

                  return BlocListener<AuthCubit, AuthState>(
                    listenWhen: (previous, current) =>
                        previous.status != current.status ||
                        previous.pendingRoute != current.pendingRoute,
                    listener: (context, state) async {
                      if (state.isAuthenticated) {
                        context.read<SavedRecipesCubit>().loadSavedRecipeIds();
                      } else {
                        context.read<SavedRecipesCubit>().clear();
                      }

                      if (state.status == AuthStatus.failure) {
                        final messenger =
                            _rootScaffoldMessengerKey.currentState;
                        final messengerContext =
                            _rootScaffoldMessengerKey.currentContext;
                        if (messenger != null && messengerContext != null) {
                          messenger.showSnackBar(
                            SnackBar(
                              content: Text(
                                AuthErrorL10n.messageFor(
                                  messengerContext,
                                  state.errorMessage,
                                  fallback: messengerContext
                                      .l10n
                                      .authUnexpectedFailure,
                                ),
                              ),
                            ),
                          );
                        }
                      }

                      final pendingRoute = state.pendingRoute;
                      if (state.isAuthenticated &&
                          pendingRoute != null &&
                          pendingRoute.isNotEmpty) {
                        AppRouter.router.go(pendingRoute);
                        await context.read<AuthCubit>().clearPendingRoute();
                      }
                    },
                    child: app,
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}

class _LocalizedMaterialApp extends StatelessWidget {
  const _LocalizedMaterialApp({required this.languageCode, required this.home});

  final String? languageCode;
  final Widget home;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateTitle: (context) => context.l10n.appTitle,
      debugShowCheckedModeBanner: false,
      locale: _localeFromLanguageCode(languageCode),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: home,
    );
  }
}

Locale _localeFromLanguageCode(String? languageCode) {
  return Locale(languageCode ?? SettingsCubit.defaultLanguageCode);
}
