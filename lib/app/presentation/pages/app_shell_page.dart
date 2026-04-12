import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../cubit/app_shell_cubit.dart';
import '../../cubit/app_shell_state.dart';
import '../widgets/foodify_bottom_navigation_bar.dart';

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
          bottomNavigationBar: FoodifyBottomNavigationBar(
            currentIndex: state.currentIndex,
            onTap: (index) {
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
