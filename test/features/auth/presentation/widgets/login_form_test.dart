import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodify_cooking/features/auth/presentation/widgets/login_form.dart';
import 'package:foodify_cooking/l10n/generated/app_localizations.dart';

void main() {
  testWidgets('starts with blank email and password fields', (tester) async {
    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(360, 800),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, _) {
          return MaterialApp(
            locale: const Locale('en'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(
              body: LoginForm(isLoading: false, onSubmit: (_, _) {}),
            ),
          );
        },
      ),
    );

    final fields = tester
        .widgetList<TextFormField>(find.byType(TextFormField))
        .toList();

    expect(fields, hasLength(2));
    expect(fields.first.controller?.text, isEmpty);
    expect(fields.last.controller?.text, isEmpty);
  });
}
