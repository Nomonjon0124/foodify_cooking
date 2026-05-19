import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../cubit/app_shell_cubit.dart';
import '../../cubit/app_shell_state.dart';
import '../widgets/foodify_bottom_navigation_bar.dart';
import '../../../config/routes/route_names.dart';
import '../../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../../features/auth/presentation/widgets/auth_required_prompt.dart';

class AppShellPage extends StatelessWidget {
  const AppShellPage({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final shellCubit = context.read<AppShellCubit>();
    if (shellCubit.state.currentIndex != navigationShell.currentIndex) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) {
          context.read<AppShellCubit>().setCurrentIndex(
            navigationShell.currentIndex,
          );
        }
      });
    }

    return BlocBuilder<AppShellCubit, AppShellState>(
      builder: (context, state) {
        return Scaffold(
          body: navigationShell,
          resizeToAvoidBottomInset: false,
          extendBody: true,
          bottomNavigationBar: state.currentIndex == 2
              ? null
              : FoodifyBottomNavigationBar(
                  currentIndex: state.currentIndex,
                  onTap: (index) {
                    final authCubit = context.read<AuthCubit>();
                    final isProtected = index == 2 || index == 3;
                    if (isProtected && !authCubit.state.isAuthenticated) {
                      showAuthRequiredSheet(
                        context,
                        returnTo: index == 2
                            ? RouteNames.addNew
                            : RouteNames.save,
                      );
                      return;
                    }

                    context.read<AppShellCubit>().setCurrentIndex(index);
                    navigationShell.goBranch(
                      index,
                      initialLocation: index == navigationShell.currentIndex,
                    );
                  },
                ),
        );
      },
    );
  }
}
