import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'foodify_button.dart';
import 'foodify_chip.dart';
import 'foodify_code_cell.dart';
import 'foodify_info_pill.dart';
import 'foodify_logo.dart';
import 'foodify_popular_card.dart';
import 'foodify_search_field.dart';

class FoodifyComponentsPreview extends StatelessWidget {
  const FoodifyComponentsPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      key: const Key('foodify_components_preview'),
      decoration: BoxDecoration(
        color: const Color(0xFF0E0E0E),
        borderRadius: BorderRadius.circular(18.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 12.r,
              runSpacing: 12.r,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: const [
                FoodifyLogo(
                  size: FoodifyLogoSize.small,
                  text: FoodifyLogoText.none,
                ),
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
                  size: FoodifyLogoSize.medium,
                  text: FoodifyLogoText.vertical,
                ),
              ],
            ),
            SizedBox(height: 16.r),
            const FoodifyButton(text: 'Text', onPressed: _noop),
            SizedBox(height: 10.r),
            Wrap(
              spacing: 10.r,
              runSpacing: 10.r,
              children: const [
                FoodifyButton(
                  text: 'Text',
                  onPressed: _noop,
                  size: FoodifyButtonSize.small,
                  variant: FoodifyButtonVariant.stroke,
                ),
                FoodifyButton(
                  text: 'Text',
                  onPressed: _noop,
                  size: FoodifyButtonSize.small,
                  variant: FoodifyButtonVariant.fillWhite,
                ),
                FoodifyButton(
                  text: 'Text',
                  onPressed: _noop,
                  size: FoodifyButtonSize.small,
                  variant: FoodifyButtonVariant.accent,
                ),
                FoodifyButton(
                  text: 'Text',
                  onPressed: _noop,
                  isDisabled: true,
                  size: FoodifyButtonSize.small,
                ),
              ],
            ),
            SizedBox(height: 16.r),
            const FoodifySearchField(
              initialText: 'Chocolate Cake',
              hintText: 'Search recipes',
            ),
            SizedBox(height: 16.r),
            Wrap(
              spacing: 10.r,
              runSpacing: 10.r,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: const [
                FoodifyChip(label: 'Chicken'),
                FoodifyChip(label: 'Chicken', isActive: false),
                FoodifyCodeCell(),
                FoodifyCodeCell(status: FoodifyCodeStatus.success),
                FoodifyCodeCell(status: FoodifyCodeStatus.error),
                FoodifyInfoPill(),
              ],
            ),
            SizedBox(height: 16.r),
            FoodifyButton(
              text: 'Text',
              onPressed: () {},
              variant: FoodifyButtonVariant.accent,
              size: FoodifyButtonSize.large,
              isDisabled: false,
            ),
            SizedBox(height: 16.r),
            Wrap(
              spacing: 12.r,
              runSpacing: 12.r,
              children: const [
                FoodifyPopularCard(),
                FoodifyPopularCard(state: FoodifyPopularCardState.toBeSelected),
                FoodifyPopularCard(state: FoodifyPopularCardState.selected),
                FoodifyPopularCard(state: FoodifyPopularCardState.toBeSaved),
                FoodifyPopularCard(state: FoodifyPopularCardState.saved),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

void _noop() {}
