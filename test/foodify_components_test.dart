import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:foodify_cooking/common/widgets/foodify_components/foodify_components.dart';

void main() {
  testWidgets('FoodifyLogo renders key Figma variants without text fallback', (
    tester,
  ) async {
    await _pump(
      tester,
      const Wrap(
        children: [
          FoodifyLogo(size: FoodifyLogoSize.small, text: FoodifyLogoText.none),
          FoodifyLogo(
            size: FoodifyLogoSize.medium,
            text: FoodifyLogoText.horizontal,
          ),
          FoodifyLogo(
            size: FoodifyLogoSize.medium,
            text: FoodifyLogoText.vertical,
          ),
          FoodifyLogo(
            color: FoodifyLogoColor.fill,
            size: FoodifyLogoSize.large,
            text: FoodifyLogoText.vertical,
          ),
        ],
      ),
    );

    expect(find.byType(FoodifyLogo), findsNWidgets(4));
    expect(find.text('Foodify'), findsNothing);
  });

  testWidgets('FoodifySearchField matches default and typed state colors', (
    tester,
  ) async {
    await _pump(tester, const FoodifySearchField());

    var decoration =
        tester
                .widget<DecoratedBox>(
                  find.byKey(const Key('foodify_search_field_container')),
                )
                .decoration
            as BoxDecoration;
    expect(decoration.color, const Color(0xFFF6FBF4));
    expect(find.text('Search'), findsOneWidget);

    await _pump(
      tester,
      const FoodifySearchField(initialText: 'Chocolate Cake'),
    );

    decoration =
        tester
                .widget<DecoratedBox>(
                  find.byKey(const Key('foodify_search_field_container')),
                )
                .decoration
            as BoxDecoration;
    expect(decoration.color, Colors.white);
    expect(find.text('Chocolate Cake'), findsOneWidget);
  });

  testWidgets('FoodifyButton renders variants, disabled state, and loading', (
    tester,
  ) async {
    var tapCount = 0;
    await _pump(
      tester,
      Column(
        children: [
          FoodifyButton(text: 'Text', onPressed: () => tapCount++),
          FoodifyButton(
            text: 'Text',
            onPressed: () {},
            size: FoodifyButtonSize.small,
            variant: FoodifyButtonVariant.accent,
          ),
          FoodifyButton(
            text: 'Text',
            onPressed: () {},
            variant: FoodifyButtonVariant.fillWhite,
          ),
          FoodifyButton(text: 'Text', onPressed: () {}, isDisabled: true),
          FoodifyButton(text: 'Text', onPressed: () {}, isLoading: true),
        ],
      ),
    );

    expect(find.byType(FoodifyButton), findsNWidgets(5));
    expect(find.byKey(const Key('foodify_button_loader')), findsOneWidget);
    expect(tester.getSize(find.byType(FoodifyButton).first).width, 320);
    expect(tester.getSize(find.byType(FoodifyButton).at(1)).width, 128);
    final buttonDecorations = find
        .byKey(const Key('foodify_button'))
        .evaluate()
        .map((element) => (element.widget as AnimatedContainer).decoration)
        .cast<BoxDecoration>()
        .toList();
    expect(buttonDecorations[0].color, const Color(0xFF0E0E0E));
    expect(buttonDecorations[1].color, const Color(0xFFF96D63));
    expect(buttonDecorations[2].color, Colors.white);
    expect(buttonDecorations[3].border, isNotNull);

    await tester.tap(find.byType(FoodifyButton).first);
    await tester.tap(find.byType(FoodifyButton).at(3));
    await tester.tap(find.byType(FoodifyButton).at(4));
    await tester.pump();

    expect(tapCount, 1);
  });

  testWidgets('FoodifyPopularCard renders all Figma states responsively', (
    tester,
  ) async {
    var selectTapCount = 0;
    var saveTapCount = 0;
    await _pump(
      tester,
      Wrap(
        children: [
          const FoodifyPopularCard(),
          FoodifyPopularCard(
            state: FoodifyPopularCardState.toBeSelected,
            onSelectPressed: () => selectTapCount++,
          ),
          FoodifyPopularCard(
            state: FoodifyPopularCardState.selected,
            onSelectPressed: () => selectTapCount++,
          ),
          FoodifyPopularCard(
            state: FoodifyPopularCardState.toBeSaved,
            onSavePressed: () => saveTapCount++,
          ),
          FoodifyPopularCard(
            state: FoodifyPopularCardState.saved,
            onSavePressed: () => saveTapCount++,
          ),
        ],
      ),
    );

    expect(find.byType(FoodifyPopularCard), findsNWidgets(5));
    expect(
      find.text('chocolate cake with buttercream frosting'),
      findsNWidgets(5),
    );
    expect(
      tester.getSize(find.byType(FoodifyPopularCard).first),
      const Size(156, 199),
    );
    expect(
      find.byKey(const Key('foodify_popular_card_select_circle')),
      findsNWidgets(2),
    );
    expect(
      find.byKey(const Key('foodify_popular_card_save_icon')),
      findsOneWidget,
    );
    expect(
      find.byKey(const Key('foodify_popular_card_unsave_icon')),
      findsOneWidget,
    );

    await tester.tap(
      find.byKey(const Key('foodify_popular_card_select_circle')).first,
    );
    await tester.tap(
      find.byKey(const Key('foodify_popular_card_unsave_icon')).first,
    );
    await tester.pump();

    expect(selectTapCount, 1);
    expect(saveTapCount, 1);
  });

  testWidgets('FoodifyChip active and inactive states render and tap', (
    tester,
  ) async {
    var tapCount = 0;
    await _pump(
      tester,
      Row(
        children: [
          FoodifyChip(label: 'Chicken', onPressed: () => tapCount++),
          const FoodifyChip(label: 'Beef', isActive: false),
        ],
      ),
    );

    await tester.tap(find.text('Chicken'));
    await tester.pump();

    expect(tapCount, 1);
    expect(find.text('Chicken'), findsOneWidget);
    expect(find.text('Beef'), findsOneWidget);
  });

  testWidgets('FoodifyCodeCell renders empty success and error states', (
    tester,
  ) async {
    await _pump(
      tester,
      const Row(
        children: [
          FoodifyCodeCell(),
          FoodifyCodeCell(status: FoodifyCodeStatus.success),
          FoodifyCodeCell(status: FoodifyCodeStatus.error),
        ],
      ),
    );

    expect(find.byType(FoodifyCodeCell), findsNWidgets(3));
    expect(find.text('6'), findsNWidgets(2));
  });

  testWidgets('FoodifyInfoPill renders Figma label and height at base size', (
    tester,
  ) async {
    await _pump(tester, const FoodifyInfoPill());

    expect(find.text('Low Callery'), findsOneWidget);
    expect(
      tester.getSize(find.byKey(const Key('foodify_info_pill'))).height,
      23,
    );
  });
}

Future<void> _pump(WidgetTester tester, Widget child) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = const Size(360, 800);
  addTearDown(tester.view.resetDevicePixelRatio);
  addTearDown(tester.view.resetPhysicalSize);

  await tester.pumpWidget(
    ScreenUtilInit(
      designSize: const Size(360, 800),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, _) => MaterialApp(
        home: Scaffold(body: Center(child: child)),
      ),
    ),
  );
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 250));
}
