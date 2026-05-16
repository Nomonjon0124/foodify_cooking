import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:foodify_cooking/features/add_new/presentation/pages/add_new_page.dart';
import 'package:foodify_cooking/features/add_new/presentation/widgets/cover_picker_view.dart';
import 'package:foodify_cooking/features/add_new/presentation/widgets/cover_preview_view.dart';
import 'package:foodify_cooking/features/add_new/presentation/widgets/crop_photo_view.dart';
import 'package:foodify_cooking/features/add_new/presentation/widgets/recipe_preview_step.dart';
import 'package:foodify_cooking/l10n/generated/app_localizations.dart';

void main() {
  testWidgets('Uzbek cover picker and crop controls keep safe spacing', (
    tester,
  ) async {
    await _pumpAddNewPage(tester, const Size(320, 640));

    final coverTitleRect = tester.getRect(find.text("Retsept rasmi qo'shing"));
    final firstThumbRect = tester.getRect(
      find.byKey(const Key('cover-picker-item-0')),
    );

    expect(coverTitleRect.left, greaterThanOrEqualTo(0));
    expect(firstThumbRect.bottom, lessThanOrEqualTo(640));
    expect(tester.takeException(), isNull);

    await tester.tap(find.byKey(const Key('cover-picker-item-0')));
    await tester.pumpAndSettle();

    final cancelRect = tester.getRect(
      find.byKey(const Key('crop-cancel-button')),
    );
    final doneRect = tester.getRect(find.byKey(const Key('crop-done-button')));
    final rotateRect = tester.getRect(
      find.byKey(const Key('crop-rotate-button')),
    );

    expect(cancelRect.top, greaterThanOrEqualTo(0));
    expect(doneRect.top, closeTo(cancelRect.top, 1));
    expect(cancelRect.bottom, lessThan(110));
    expect(rotateRect.bottom, lessThanOrEqualTo(640));
    expect(tester.takeException(), isNull);
  });

  testWidgets('Uzbek cover preview action buttons remain readable', (
    tester,
  ) async {
    await _pumpAddNewPage(tester, const Size(320, 640));

    await tester.tap(find.byKey(const Key('cover-picker-item-0')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('crop-done-button')));
    await tester.pumpAndSettle();

    final editRect = tester.getRect(find.text('Kesishni tahrirlash'));
    final removeRect = tester.getRect(find.text("O'chirish"));

    expect(editRect.left, greaterThanOrEqualTo(20));
    expect(removeRect.right, lessThanOrEqualTo(300));
    expect(editRect.center.dy, closeTo(removeRect.center.dy, 1));
    expect(tester.takeException(), isNull);
  });

  for (final size in [
    const Size(320, 640),
    const Size(360, 800),
    const Size(430, 932),
  ]) {
    testWidgets(
      'Uzbek AddNewPage flow stays responsive at ${size.width.toInt()}x${size.height.toInt()}',
      (tester) async {
        await _pumpAddNewPage(tester, size);

        expect(find.byType(CoverPickerView), findsOneWidget);
        expect(find.text("Retsept rasmi qo'shing"), findsOneWidget);
        expect(find.byTooltip('Galereyadan tanlash'), findsOneWidget);
        expect(find.byTooltip('Rasmga olish'), findsOneWidget);
        expect(tester.takeException(), isNull);

        await tester.tap(find.byKey(const Key('cover-picker-item-0')));
        await tester.pumpAndSettle();
        expect(find.byType(CropPhotoView), findsOneWidget);
        expect(find.byKey(const Key('crop-cancel-button')), findsOneWidget);
        expect(find.byKey(const Key('crop-done-button')), findsOneWidget);
        expect(find.byTooltip('Rasmni aylantirish'), findsOneWidget);
        expect(tester.takeException(), isNull);

        await tester.tap(find.byKey(const Key('crop-done-button')));
        await tester.pumpAndSettle();
        expect(find.byType(CoverPreviewView), findsOneWidget);
        expect(find.text('Kesishni tahrirlash'), findsOneWidget);
        expect(find.text("O'chirish"), findsOneWidget);
        expect(tester.takeException(), isNull);

        await tester.tap(find.text('Keyingi').last);
        await tester.pumpAndSettle();
        expect(find.text('Nomi'), findsOneWidget);
        expect(tester.takeException(), isNull);

        final nameField = find.byWidgetPredicate(
          (widget) =>
              widget is TextField &&
              widget.decoration?.hintText == 'Retsept nomini yozing',
        );
        await tester.enterText(
          nameField,
          'Uy sharoitida tayyorlanadigan juda mazali pankeyk',
        );
        await tester.pump();
        expect(tester.takeException(), isNull);

        await tester.tap(find.text('Keyingi').last);
        await tester.pumpAndSettle();
        await tester.enterText(find.byType(TextFormField).first, '2 stakan un');
        await tester.pump();
        expect(tester.takeException(), isNull);

        await tester.tap(find.text('Keyingi').last);
        await tester.pumpAndSettle();
        await tester.enterText(
          find.byType(TextFormField).first,
          "Quruq va suyuq masalliqlarni bir xil massa bo'lguncha aralashtiring.",
        );
        await tester.pump();
        expect(tester.takeException(), isNull);

        await tester.tap(find.text('Keyingi').last);
        await tester.pumpAndSettle();
        expect(find.byType(RecipePreviewStep), findsOneWidget);
        expect(find.text('Tayyorlash'), findsWidgets);
        expect(find.text('Ingredientlar'), findsOneWidget);
        expect(find.text('Izohlar'), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );
  }
}

Future<void> _pumpAddNewPage(WidgetTester tester, Size size) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = size;
  addTearDown(tester.view.resetDevicePixelRatio);
  addTearDown(tester.view.resetPhysicalSize);

  await tester.pumpWidget(
    ScreenUtilInit(
      designSize: const Size(360, 800),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, _) {
        return MaterialApp(
          locale: const Locale('uz'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const AddNewPage(),
        );
      },
    ),
  );
  await tester.pumpAndSettle();
}
