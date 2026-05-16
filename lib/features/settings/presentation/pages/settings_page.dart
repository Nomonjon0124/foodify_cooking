import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/routes/route_names.dart';
import '../../../../l10n/l10n_extension.dart';
import '../cubit/settings_cubit.dart';
import '../cubit/settings_state.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          final selectedLanguage =
              state.languageCode ?? SettingsCubit.defaultLanguageCode;
          final selectedLanguageLabel = _languageLabel(context, state);

          return ListView(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            children: [
              SwitchListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
                title: Text(l10n.settingsDarkMode),
                value: state.isDarkMode,
                onChanged: (_) => context.read<SettingsCubit>().toggleTheme(),
              ),
              ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
                title: Text(l10n.settingsLanguage),
                subtitle: Text(
                  l10n.settingsLanguageCurrent(selectedLanguageLabel),
                ),
                trailing: DropdownButton<String>(
                  key: const Key('settings_language_dropdown'),
                  value: selectedLanguage,
                  underline: const SizedBox.shrink(),
                  items: [
                    DropdownMenuItem(
                      value: 'uz',
                      child: Text(l10n.languageUzbek),
                    ),
                    DropdownMenuItem(
                      value: 'en',
                      child: Text(l10n.languageEnglish),
                    ),
                    DropdownMenuItem(
                      value: 'ru',
                      child: Text(l10n.languageRussian),
                    ),
                  ],
                  onChanged: (value) {
                    context.read<SettingsCubit>().changeLanguage(value);
                  },
                ),
              ),
              ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
                title: Text(l10n.settingsSignInTitle),
                subtitle: Text(l10n.settingsSignInSubtitle),
                onTap: () => context.push(RouteNames.login),
              ),
            ],
          );
        },
      ),
    );
  }

  String _languageLabel(BuildContext context, SettingsState state) {
    final l10n = context.l10n;
    return switch (state.languageCode ?? SettingsCubit.defaultLanguageCode) {
      'uz' => l10n.languageUzbek,
      'en' => l10n.languageEnglish,
      'ru' => l10n.languageRussian,
      _ => l10n.languageUzbek,
    };
  }
}
