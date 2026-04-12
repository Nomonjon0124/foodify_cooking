import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:foodify_cooking/common/widgets/recipe_cards/recipe_main_card.dart';

void main() {
  testWidgets('RecipeMainCard renders Figma content and background painter', (
    tester,
  ) async {
    await _pumpCard(tester);

    expect(find.text('Muffin with Blue Cream'), findsOneWidget);
    expect(find.text('Kelly Mayer'), findsOneWidget);
    expect(find.text('4.8'), findsOneWidget);
    expect(find.text('4.9'), findsOneWidget);
    expect(find.text('30 Min'), findsOneWidget);
    expect(find.text('Simple'), findsOneWidget);
    expect(
      find.byKey(const Key('recipe_main_card_background')),
      findsOneWidget,
    );
    expect(find.byType(CustomPaint), findsWidgets);
  });

  testWidgets('RecipeMainCard keeps Figma base size at 360x800', (
    tester,
  ) async {
    await _pumpCard(tester);

    expect(
      tester.getSize(find.byKey(const Key('recipe_main_card'))),
      const Size(320, 187),
    );
  });

  testWidgets('RecipeMainCard action button triggers callback', (tester) async {
    var tapCount = 0;
    await _pumpCard(tester, onActionPressed: () => tapCount++);

    await tester.tap(find.byKey(const Key('recipe_card_action_button')));
    await tester.pump();

    expect(tapCount, 1);
  });

  testWidgets('RecipeMainCard action button matches Figma notch position', (
    tester,
  ) async {
    await _pumpCard(tester);

    final cardTopLeft = tester.getTopLeft(
      find.byKey(const Key('recipe_main_card')),
    );
    final actionTopLeft = tester.getTopLeft(
      find.byKey(const Key('recipe_card_action_button')),
    );

    expect(actionTopLeft.dx - cardTopLeft.dx, closeTo(288, 0.01));
    expect(actionTopLeft.dy - cardTopLeft.dy, closeTo(120, 0.01));
  });

  testWidgets(
    'RecipeMainCard keeps aspect ratio on compact and tablet widths',
    (tester) async {
      await _pumpCard(tester, surfaceSize: const Size(320, 640));

      var cardSize = tester.getSize(find.byKey(const Key('recipe_main_card')));
      var cardRect = tester.getRect(find.byKey(const Key('recipe_main_card')));
      var actionRect = tester.getRect(
        find.byKey(const Key('recipe_card_action_button')),
      );

      expect(cardSize.width, closeTo(284.44, 0.02));
      expect(cardSize.height / cardSize.width, closeTo(187 / 320, 0.001));
      expect(actionRect.right <= cardRect.right + 0.01, isTrue);
      expect(actionRect.bottom <= cardRect.bottom + 0.01, isTrue);

      await _pumpCard(tester, surfaceSize: const Size(768, 1024));

      cardSize = tester.getSize(find.byKey(const Key('recipe_main_card')));
      cardRect = tester.getRect(find.byKey(const Key('recipe_main_card')));
      actionRect = tester.getRect(
        find.byKey(const Key('recipe_card_action_button')),
      );

      expect(cardSize.width, 420);
      expect(cardSize.height / cardSize.width, closeTo(187 / 320, 0.001));
      expect(actionRect.right <= cardRect.right + 0.01, isTrue);
      expect(actionRect.bottom <= cardRect.bottom + 0.01, isTrue);
    },
  );
}

Future<void> _pumpCard(
  WidgetTester tester, {
  VoidCallback? onActionPressed,
  Size surfaceSize = const Size(360, 800),
}) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = surfaceSize;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  await tester.pumpWidget(
    ScreenUtilInit(
      designSize: const Size(360, 800),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, _) {
        return MaterialApp(
          home: Scaffold(
            body: Center(
              child: RecipeMainCard(
                title: 'Muffin with Blue Cream',
                authorName: 'Kelly Mayer',
                description:
                    'In a large bowl, mix together flour, baking powder, sugar, and salt..',
                durationLabel: '30 Min',
                difficultyLabel: 'Simple',
                imagePath: 'assets/images/recipe_cards/main_card_content.png',
                authorImagePath: 'assets/images/recipe_cards/user_pic.png',
                topRating: '4.8',
                authorRating: '4.9',
                onActionPressed: onActionPressed,
              ),
            ),
          ),
        );
      },
    ),
  );

  await tester.pumpAndSettle();
}
