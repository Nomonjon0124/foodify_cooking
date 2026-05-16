import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodify_cooking/features/add_new/presentation/cubit/add_new_cubit.dart';
import 'package:foodify_cooking/features/add_new/presentation/widgets/ingredients_step.dart';
import 'package:foodify_cooking/features/add_new/presentation/widgets/introduction_step.dart';
import 'helpers/localized_app.dart';

void main() {
  testWidgets('ingredient input keeps focus after bloc rebuild', (
    tester,
  ) async {
    final cubit = AddNewCubit();
    cubit.selectPhoto('mock');
    cubit.confirmCrop();
    cubit.nextStage();
    cubit.updateTitle('Recipe');
    cubit.nextStage();

    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(360, 800),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, _) {
          return MaterialApp(
            locale: testLocale,
            localizationsDelegates: testLocalizationsDelegates,
            supportedLocales: testSupportedLocales,
            home: BlocProvider.value(
              value: cubit,
              child: const Scaffold(body: IngredientsStep()),
            ),
          );
        },
      ),
    );
    await tester.pumpAndSettle();

    final field = find.byType(TextFormField).first;
    await tester.tap(field);
    await tester.enterText(field, '2 cups flour');
    await tester.pump();

    final editableText = tester.widget<EditableText>(find.byType(EditableText));
    expect(editableText.focusNode.hasFocus, isTrue);
  });

  testWidgets('introduction input keeps focus after bloc rebuild', (
    tester,
  ) async {
    final cubit = AddNewCubit();
    cubit.selectPhoto('mock');
    cubit.confirmCrop();
    cubit.nextStage();
    cubit.updateTitle('Recipe');
    cubit.nextStage();
    cubit.updateIngredient(0, '2 cups flour');
    cubit.nextStage();

    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(360, 800),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, _) {
          return MaterialApp(
            locale: testLocale,
            localizationsDelegates: testLocalizationsDelegates,
            supportedLocales: testSupportedLocales,
            home: BlocProvider.value(
              value: cubit,
              child: const Scaffold(body: IntroductionStep()),
            ),
          );
        },
      ),
    );
    await tester.pumpAndSettle();

    final field = find.byType(TextFormField).first;
    await tester.tap(field);
    await tester.enterText(field, 'Mix the dry and wet ingredients.');
    await tester.pump();

    final editableText = tester.widget<EditableText>(find.byType(EditableText));
    expect(editableText.focusNode.hasFocus, isTrue);
  });
}
