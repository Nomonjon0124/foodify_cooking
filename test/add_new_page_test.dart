import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodify_cooking/features/add_new/presentation/pages/add_new_page.dart';
import 'package:foodify_cooking/features/add_new/presentation/widgets/ingredients_step.dart';
import 'package:foodify_cooking/features/add_new/presentation/widgets/introduction_step.dart';

void main() {
  testWidgets('AddNewPage completes the local wizard flow', (tester) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(360, 800),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, _) {
          return const MaterialApp(home: AddNewPage());
        },
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Add a recipe Cover'), findsOneWidget);

    await tester.tap(find.byKey(const Key('cover-picker-item-0')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('crop-done-button')), findsOneWidget);

    await tester.tap(find.byKey(const Key('crop-done-button')));
    await tester.pumpAndSettle();
    expect(find.text('Edit Crop'), findsOneWidget);

    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();
    expect(find.text('Name'), findsOneWidget);

    final nameField = find.byWidgetPredicate(
      (widget) =>
          widget is TextField &&
          widget.decoration?.hintText == 'Name your recipe',
    );
    await tester.enterText(nameField, 'Sunrise Pancakes');
    await tester.pump();
    await tester.tap(find.text('Next').last);
    await tester.pumpAndSettle();
    expect(find.byType(IngredientsStep), findsOneWidget);

    await tester.enterText(find.byType(TextFormField).first, '2 cups flour');
    await tester.pump();
    await tester.tap(find.text('Next').last);
    await tester.pumpAndSettle();
    expect(find.byType(IntroductionStep), findsOneWidget);

    await tester.enterText(
      find.byType(TextFormField).first,
      'Mix the dry and wet ingredients until smooth.',
    );
    await tester.pump();
    await tester.tap(find.text('Next').last);
    await tester.pumpAndSettle();

    expect(find.text('Sunrise Pancakes'), findsOneWidget);
    expect(find.text('Comments'), findsOneWidget);
  });
}
