import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:foodify_cooking/core/constants/storage_keys.dart';
import 'package:foodify_cooking/core/services/storage_service.dart';
import 'package:foodify_cooking/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:foodify_cooking/features/settings/presentation/cubit/settings_state.dart';
import 'package:foodify_cooking/features/settings/presentation/pages/settings_page.dart';
import 'helpers/localized_app.dart';

void main() {
  test('SettingsCubit defaults to Uzbek when no language is saved', () async {
    final cubit = SettingsCubit(StorageService());
    addTearDown(cubit.close);

    await cubit.loadPreferences();

    expect(cubit.state.languageCode, 'uz');
  });

  test('SettingsCubit loads and persists selected language', () async {
    final storage = StorageService();
    await storage.setString(StorageKeys.languageCode, 'ru');

    final cubit = SettingsCubit(storage);
    addTearDown(cubit.close);

    await cubit.loadPreferences();
    expect(cubit.state.languageCode, 'ru');

    await cubit.changeLanguage('en');
    expect(cubit.state.languageCode, 'en');
    expect(storage.getString(StorageKeys.languageCode), 'en');

    await cubit.changeLanguage(null);
    expect(cubit.state.languageCode, 'uz');
    expect(storage.getString(StorageKeys.languageCode), 'uz');
  });

  testWidgets('Settings language dropdown updates visible copy', (
    tester,
  ) async {
    final cubit = SettingsCubit(StorageService());
    addTearDown(cubit.close);

    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(360, 800),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, _) {
          return BlocProvider.value(
            value: cubit,
            child: BlocBuilder<SettingsCubit, SettingsState>(
              builder: (context, state) {
                return MaterialApp(
                  locale: Locale(
                    state.languageCode ?? SettingsCubit.defaultLanguageCode,
                  ),
                  localizationsDelegates: testLocalizationsDelegates,
                  supportedLocales: testSupportedLocales,
                  home: const SettingsPage(),
                );
              },
            ),
          );
        },
      ),
    );
    await tester.pumpAndSettle();

    await cubit.loadPreferences();
    await tester.pumpAndSettle();

    expect(find.text('Sozlamalar'), findsOneWidget);
    expect(find.text('Til'), findsOneWidget);

    await tester.tap(find.byKey(const Key('settings_language_dropdown')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Ruscha').last);
    await tester.pumpAndSettle();

    expect(find.text('Настройки'), findsOneWidget);
    expect(cubit.state.languageCode, 'ru');
  });
}
