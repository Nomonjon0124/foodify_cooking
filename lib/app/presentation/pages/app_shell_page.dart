import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../config/routes/route_names.dart';
import '../../cubit/app_shell_cubit.dart';
import '../../cubit/app_shell_state.dart';

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
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: state.currentIndex,
            onTap: (index) {
              context.read<AppShellCubit>().setCurrentIndex(index);
              navigationShell.goBranch(
                index,
                initialLocation: index == navigationShell.currentIndex,
              );
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home),
                label: 'Home',
                tooltip: RouteNames.home,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.restaurant_menu_outlined),
                activeIcon: Icon(Icons.restaurant_menu),
                label: 'Recipes',
                tooltip: RouteNames.recipes,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings_outlined),
                activeIcon: Icon(Icons.settings),
                label: 'Settings',
                tooltip: RouteNames.settings,
              ),
            ],
          ),
        );
      },
    );
  }
}
