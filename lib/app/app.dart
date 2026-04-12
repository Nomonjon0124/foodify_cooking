import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../config/routes/app_router.dart';
import '../config/theme/app_theme.dart';
import '../core/di/injection_container.dart';
import 'cubit/app_start_cubit.dart';
import 'cubit/app_start_state.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 800),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return BlocProvider<AppStartCubit>(
          create: (_) => getIt<AppStartCubit>()..initialize(),
          child: BlocBuilder<AppStartCubit, AppStartState>(
            builder: (context, state) {
              if (state.status == AppStartStatus.loading ||
                  state.status == AppStartStatus.initial) {
                return const MaterialApp(
                  debugShowCheckedModeBanner: false,
                  home: Scaffold(
                    body: Center(child: CircularProgressIndicator()),
                  ),
                );
              }

              if (state.status == AppStartStatus.failure) {
                return MaterialApp(
                  debugShowCheckedModeBanner: false,
                  home: Scaffold(
                    body: Center(
                      child: Text(state.errorMessage ?? 'Startup error'),
                    ),
                  ),
                );
              }

              return MaterialApp.router(
                title: 'Foodify Cooking',
                debugShowCheckedModeBanner: false,
                theme: AppTheme.lightTheme,
                darkTheme: AppTheme.darkTheme,
                routerConfig: AppRouter.router,
              );
            },
          ),
        );
      },
    );
  }
}
