import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined, size: 24.r),
                activeIcon: Icon(Icons.home, size: 24.r),
                label: 'Home',
                tooltip: RouteNames.home,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.restaurant_menu_outlined, size: 24.r),
                activeIcon: Icon(Icons.restaurant_menu, size: 24.r),
                label: 'Recipes',
                tooltip: RouteNames.recipes,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings_outlined, size: 24.r),
                activeIcon: Icon(Icons.settings, size: 24.r),
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
