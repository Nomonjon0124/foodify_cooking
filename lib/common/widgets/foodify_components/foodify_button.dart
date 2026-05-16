import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodify_cooking/core/gen/assets.gen.dart';

import '../../../core/gen/fonts.gen.dart';

enum FoodifyButtonSize { small, large }

enum FoodifyButtonVariant { fill, accent, stroke, fillWhite }

class FoodifyButton extends StatelessWidget {
  const FoodifyButton({
    required this.text,
    required this.onPressed,
    super.key,
    this.size = FoodifyButtonSize.large,
    this.variant = FoodifyButtonVariant.fill,
    this.isDisabled = false,
    this.isLoading = false,
    this.iconPath,
  });

  final String text;
  final VoidCallback? onPressed;
  final FoodifyButtonSize size;
  final FoodifyButtonVariant variant;
  final bool isDisabled;
  final bool isLoading;
  final Widget? iconPath;

  static const _black = Color(0xFF0E0E0E);
  static const _accent = Color(0xFFF96D63);
  static const _darkText = Color(0xFF353535);
  static const _disabled = Color(0xFFADADAD);

  bool get _isUnavailable => isDisabled || isLoading || onPressed == null;

  @override
  Widget build(BuildContext context) {
    final style = _FoodifyButtonStyle.resolve(
      variant: variant,
      isDisabled: isDisabled || onPressed == null,
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final targetWidth = (size == FoodifyButtonSize.large ? 320 : 128).r;
        final width = constraints.hasBoundedWidth
            ? math.min(targetWidth, constraints.maxWidth)
            : targetWidth;

        return Semantics(
          button: true,
          enabled: !_isUnavailable,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: _isUnavailable ? null : onPressed,
            child: AnimatedContainer(
              key: const Key('foodify_button'),
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOutCubic,
              width: width,
              height: 40.r,
              padding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 10.r),
              decoration: BoxDecoration(
                color: style.backgroundColor,
                borderRadius: BorderRadius.circular(48.r),
                border: style.borderColor == null
                    ? null
                    : Border.all(color: style.borderColor!, width: 1.r),
              ),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 160),
                switchInCurve: Curves.easeOutCubic,
                switchOutCurve: Curves.easeInCubic,
                child: isLoading
                    ? _FoodifyButtonLoader(
                        key: const Key('foodify_button_loader'),
                        color: style.foregroundColor,
                      )
                    : _FoodifyButtonContent(
                        key: ValueKey('foodify_button_content_${variant.name}'),
                        text: text,
                        style: style,
                        showIcon: variant == FoodifyButtonVariant.fillWhite,
                        iconPath: iconPath,
                      ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _FoodifyButtonContent extends StatelessWidget {
  const _FoodifyButtonContent({
    required this.text,
    required this.style,
    required this.showIcon,
    required this.iconPath,
    super.key,
  });

  final String text;
  final _FoodifyButtonStyle style;
  final bool showIcon;
  final Widget? iconPath;

  @override
  Widget build(BuildContext context) {
    final label = Text(
      text,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        color: style.foregroundColor,
        fontSize: 16.sp,
        fontWeight: FontWeight.w500,
        height: 1.2,
        fontFamily: FontFamily.montserrat,
      ),
    );

    if (!showIcon) {
      return Center(child: label);
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(child: label),
        SizedBox(width: 12.r),
        iconPath ??
            Assets.icons.foodifyComponents.documentCopy.svg(
              width: 16.r,
              height: 16.r,
              color: style.foregroundColor,
            ),
      ],
    );
  }
}

class _FoodifyButtonLoader extends StatelessWidget {
  const _FoodifyButtonLoader({required this.color, super.key});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 18.r,
        height: 18.r,
        child: CircularProgressIndicator(
          strokeWidth: 2.r,
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ),
      ),
    );
  }
}

class _FoodifyButtonStyle {
  const _FoodifyButtonStyle({
    required this.backgroundColor,
    required this.foregroundColor,
    this.borderColor,
  });

  final Color backgroundColor;
  final Color foregroundColor;
  final Color? borderColor;

  static _FoodifyButtonStyle resolve({
    required FoodifyButtonVariant variant,
    required bool isDisabled,
  }) {
    if (isDisabled) {
      return const _FoodifyButtonStyle(
        backgroundColor: Colors.transparent,
        foregroundColor: FoodifyButton._disabled,
        borderColor: FoodifyButton._disabled,
      );
    }

    return switch (variant) {
      FoodifyButtonVariant.fill => const _FoodifyButtonStyle(
        backgroundColor: FoodifyButton._black,
        foregroundColor: Colors.white,
      ),
      FoodifyButtonVariant.accent => const _FoodifyButtonStyle(
        backgroundColor: FoodifyButton._accent,
        foregroundColor: Colors.white,
      ),
      FoodifyButtonVariant.stroke => const _FoodifyButtonStyle(
        backgroundColor: Colors.transparent,
        foregroundColor: FoodifyButton._darkText,
        borderColor: FoodifyButton._darkText,
      ),
      FoodifyButtonVariant.fillWhite => const _FoodifyButtonStyle(
        backgroundColor: Colors.white,
        foregroundColor: FoodifyButton._disabled,
      ),
    };
  }
}
