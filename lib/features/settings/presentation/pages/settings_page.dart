import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/routes/route_names.dart';
import '../../../../core/di/injection_container.dart';
import '../cubit/settings_cubit.dart';
import '../cubit/settings_state.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SettingsCubit>(
      create: (_) => getIt<SettingsCubit>(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Settings')),
        body: BlocBuilder<SettingsCubit, SettingsState>(
          builder: (context, state) {
            return ListView(
              padding: EdgeInsets.symmetric(vertical: 8.h),
              children: [
                SwitchListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
                  title: const Text('Dark mode'),
                  value: state.isDarkMode,
                  onChanged: (_) => context.read<SettingsCubit>().toggleTheme(),
                ),
                ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
                  title: const Text('Language'),
                  subtitle: Text(
                    'Current: ${state.languageCode.toUpperCase()}',
                  ),
                  onTap: () =>
                      context.read<SettingsCubit>().changeLanguage('en'),
                ),
                ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
                  title: const Text('Sign in (optional)'),
                  subtitle: const Text('Open auth flow only if user wants'),
                  onTap: () => context.push(RouteNames.login),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
