import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodify_cooking/core/gen/assets.gen.dart';

enum FoodifyLogoSize { small, medium, large }

enum FoodifyLogoText { none, horizontal, vertical }

enum FoodifyLogoColor { stroke, fill }

class FoodifyLogo extends StatelessWidget {
  const FoodifyLogo({
    super.key,
    this.size = FoodifyLogoSize.large,
    this.text = FoodifyLogoText.vertical,
    this.color = FoodifyLogoColor.stroke,
  });

  final FoodifyLogoSize size;
  final FoodifyLogoText text;
  final FoodifyLogoColor color;

  static const _orange = Color(0xFFFF6339);
  static const _white = Colors.white;
  static const _smallBorder = Color(0xFFCBCBCB);

  @override
  Widget build(BuildContext context) {
    final spec = _FoodifyLogoSpec.resolve(size: size, text: text);
    final isFill = color == FoodifyLogoColor.fill;
    final wordmarkColor = isFill ? _orange : _white;

    return Container(
      key: const Key('foodify_logo'),
      width: spec.width.r,
      height: spec.height.r,
      decoration: BoxDecoration(
        color: isFill ? _white : Colors.transparent,
        borderRadius: BorderRadius.circular(spec.radius.r),
        border: _borderFor(spec, isFill),
      ),
      clipBehavior: Clip.antiAlias,
      child: _LogoContent(spec: spec, markColor: _orange, wordmarkColor: wordmarkColor),
    );
  }

  Border? _borderFor(_FoodifyLogoSpec spec, bool isFill) {
    if (isFill) return null;
    if (spec.text == FoodifyLogoText.horizontal) return null;

    return Border.all(
      color: spec.text == FoodifyLogoText.none ? _smallBorder : _white,
      width: spec.text == FoodifyLogoText.none ? 0.5.r : 1.r,
    );
  }
}

class _LogoContent extends StatelessWidget {
  const _LogoContent({required this.spec, required this.markColor, required this.wordmarkColor});

  final _FoodifyLogoSpec spec;
  final Color markColor;
  final Color wordmarkColor;

  @override
  Widget build(BuildContext context) {
    final mark = spec.markAsset;

    if (spec.text == FoodifyLogoText.none) {
      return Center(child: mark);
    }

    final wordmark = Assets.icons.foodifyComponents.foodifyWordmark.svg(
      width: spec.wordmarkWidth.r,
      height: spec.wordmarkHeight.r,
      colorFilter: ColorFilter.mode(wordmarkColor, .srcIn),
    );

    if (spec.text == FoodifyLogoText.horizontal) {
      return Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            mark,
            SizedBox(width: spec.gap.r),
            wordmark,
          ],
        ),
      );
    }

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          mark,
          SizedBox(height: spec.gap.r),
          wordmark,
        ],
      ),
    );
  }
}

class _FoodifyLogoSpec {
  const _FoodifyLogoSpec({
    required this.width,
    required this.height,
    required this.radius,
    required this.gap,
    required this.markWidth,
    required this.markHeight,
    required this.wordmarkWidth,
    required this.wordmarkHeight,
    required this.markAsset,
    required this.text,
  });

  final double width;
  final double height;
  final double radius;
  final double gap;
  final double markWidth;
  final double markHeight;
  final double wordmarkWidth;
  final double wordmarkHeight;
  final Widget markAsset;
  final FoodifyLogoText text;

  static _FoodifyLogoSpec resolve({required FoodifyLogoSize size, required FoodifyLogoText text}) {
    if (text == FoodifyLogoText.none) {
      return _FoodifyLogoSpec(
        width: 24,
        height: 24,
        radius: 4,
        gap: 0,
        markWidth: 10.103,
        markHeight: 9.622,
        wordmarkWidth: 0,
        wordmarkHeight: 0,
        markAsset: Assets.icons.foodifyComponents.logoMarkSmall.svg(width: 10.103, height: 9.622),
        text: FoodifyLogoText.none,
      );
    }

    if (text == FoodifyLogoText.horizontal) {
      return _FoodifyLogoSpec(
        width: 120,
        height: 40,
        radius: 6,
        gap: 4.195,
        markWidth: 31.818,
        markHeight: 30.303,
        wordmarkWidth: 38,
        wordmarkHeight: 11.75,
        markAsset: Assets.icons.foodifyComponents.logoMarkHorizontal.svg(width: 31.818, height: 30.303),
        text: FoodifyLogoText.horizontal,
      );
    }

    if (size == FoodifyLogoSize.medium) {
      return _FoodifyLogoSpec(
        width: 56,
        height: 56,
        radius: 5,
        gap: 1.867,
        markWidth: 25.086,
        markHeight: 23.891,
        wordmarkWidth: 28.7,
        wordmarkHeight: 8.96,
        markAsset: Assets.icons.foodifyComponents.logoMarkMediumVertical.svg(width: 25.086, height: 23.891),
        text: FoodifyLogoText.vertical,
      );
    }

    return _FoodifyLogoSpec(
      width: 120,
      height: 120,
      radius: 6,
      gap: 4,
      markWidth: 53.757,
      markHeight: 51.197,
      wordmarkWidth: 61.44,
      wordmarkHeight: 19.2,
      markAsset: Assets.icons.foodifyComponents.logoMarkLarge.svg(width: 53.757, height: 51.197),
      text: FoodifyLogoText.vertical,
    );
  }
}
