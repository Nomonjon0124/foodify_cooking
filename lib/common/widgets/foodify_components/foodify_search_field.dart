import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodify_cooking/core/gen/assets.gen.dart';

import '../../../core/gen/fonts.gen.dart';

class FoodifySearchField extends StatefulWidget {
  const FoodifySearchField({
    super.key,
    this.controller,
    this.initialText,
    this.hintText = 'Search',
    this.backgroundColor,
    this.activeBackgroundColor = Colors.white,
    this.onChanged,
    this.onTap,
    this.enabled = true,
  });

  final TextEditingController? controller;
  final String? initialText;
  final String hintText;
  final Color? backgroundColor;
  final Color activeBackgroundColor;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final bool enabled;

  @override
  State<FoodifySearchField> createState() => _FoodifySearchFieldState();
}

class _FoodifySearchFieldState extends State<FoodifySearchField> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;
  late final bool _ownsController;

  @override
  void initState() {
    super.initState();
    _ownsController = widget.controller == null;
    _controller =
        widget.controller ?? TextEditingController(text: widget.initialText);
    _focusNode = FocusNode()..addListener(_handleStateChanged);
    _controller.addListener(_handleStateChanged);
  }

  @override
  void didUpdateWidget(covariant FoodifySearchField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_ownsController &&
        widget.initialText != oldWidget.initialText &&
        widget.initialText != _controller.text) {
      _controller.text = widget.initialText ?? '';
    }
  }

  @override
  void dispose() {
    _focusNode
      ..removeListener(_handleStateChanged)
      ..dispose();
    _controller.removeListener(_handleStateChanged);
    if (_ownsController) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _handleStateChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final isActive = _focusNode.hasFocus || _controller.text.isNotEmpty;
    final textStyle = TextStyle(
      color: const Color(0xFF353535),
      fontSize: 12.sp,
      fontWeight: FontWeight.w400,
      height: 1.25,
      fontFamily: FontFamily.montserrat,
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final targetWidth = 277.r;
        final width = constraints.hasBoundedWidth
            ? math.min(targetWidth, constraints.maxWidth)
            : targetWidth;

        return SizedBox(
          width: width,
          height: 40.r,
          child: DecoratedBox(
            key: const Key('foodify_search_field_container'),
            decoration: BoxDecoration(
              color:
                  widget.backgroundColor ??
                  (isActive
                      ? widget.activeBackgroundColor
                      : const Color(0xFFF6FBF4)),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.r),
              child: Row(
                children: [
                  Assets.icons.foodifyComponents.searchNormal.svg(
                    width: 24.r,
                    height: 24.r,
                    colorFilter: const ColorFilter.mode(
                      Color(0xFF353535),
                      BlendMode.srcIn,
                    ),
                  ),
                  SizedBox(width: 8.r),
                  Expanded(
                    child: TextField(
                      key: const Key('foodify_search_field_input'),
                      controller: _controller,
                      focusNode: _focusNode,
                      enabled: widget.enabled,
                      onTap: widget.onTap,
                      onChanged: widget.onChanged,
                      maxLines: 1,
                      style: textStyle,
                      cursorColor: const Color(0xFF353535),
                      decoration: InputDecoration.collapsed(
                        hintText: widget.hintText,
                        hintStyle: textStyle.copyWith(
                          color: const Color(0xFFADADAD),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
