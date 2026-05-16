import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodify_cooking/core/gen/assets.gen.dart';

import '../../core/gen/fonts.gen.dart';
import 'foodify_components/foodify_logo.dart';
import 'foodify_components/foodify_search_field.dart';

enum _FoodifyAppBarVariant { home, searchFilter, titleAction }

class FoodifyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const FoodifyAppBar.home({
    super.key,
    this.controller,
    this.hintText = 'Search',
    this.onChanged,
    this.onFilterTap,
  }) : _variant = _FoodifyAppBarVariant.home,
       initialText = null,
       title = null,
       actionText = null,
       onBackTap = null,
       onActionTap = null;

  const FoodifyAppBar.searchFilter({
    super.key,
    this.controller,
    this.initialText,
    this.hintText = 'Search',
    this.onChanged,
    this.onFilterTap,
  }) : _variant = _FoodifyAppBarVariant.searchFilter,
       title = null,
       actionText = null,
       onBackTap = null,
       onActionTap = null;

  const FoodifyAppBar.titleAction({
    required this.title,
    super.key,
    this.onBackTap,
    this.actionText,
    this.onActionTap,
  }) : _variant = _FoodifyAppBarVariant.titleAction,
       controller = null,
       initialText = null,
       hintText = 'Search',
       onChanged = null,
       onFilterTap = null;

  final _FoodifyAppBarVariant _variant;
  final TextEditingController? controller;
  final String? initialText;
  final String hintText;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onFilterTap;
  final String? title;
  final String? actionText;
  final VoidCallback? onBackTap;
  final VoidCallback? onActionTap;

  static const _primary = Color(0xFF4058A0);
  static const _tertiary = Color(0xFFDEE21B);
  static const _dark = Color(0xFF353535);
  static final _filterIcon = Assets.icons.foodifyComponents.documentFilter.svg(
    width: 20.r,
    height: 20.r,
    colorFilter: const ColorFilter.mode(FoodifyAppBar._dark, BlendMode.srcIn),
  );

  @override
  Size get preferredSize => Size.fromHeight(_spec.height);

  _FoodifyAppBarSpec get _spec {
    return switch (_variant) {
      _FoodifyAppBarVariant.home => const _FoodifyAppBarSpec(
        height: 131,
        bottomRadius: 12,
      ),
      _FoodifyAppBarVariant.searchFilter => const _FoodifyAppBarSpec(
        height: 98,
        bottomRadius: 12,
      ),
      _FoodifyAppBarVariant.titleAction => const _FoodifyAppBarSpec(
        height: 80,
        bottomRadius: 20,
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    final spec = _spec;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: _primary,
        systemNavigationBarColor: Colors.white,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(spec.bottomRadius.r),
        ),
        child: DecoratedBox(
          decoration: const BoxDecoration(color: _primary),
          child: SafeArea(
            bottom: false,
            child: SizedBox(
              height: spec.height.h,
              width: double.infinity,
              child: switch (_variant) {
                _FoodifyAppBarVariant.home => _buildHomeHeader(),
                _FoodifyAppBarVariant.searchFilter => _buildSearchHeader(),
                _FoodifyAppBarVariant.titleAction => _buildTitleHeader(context),
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHomeHeader() {
    return Stack(
      children: [
        Positioned(
          top: 27.h,
          left: 0,
          right: 0,
          child: const Center(
            child: FoodifyLogo(
              size: FoodifyLogoSize.medium,
              text: FoodifyLogoText.horizontal,
              color: FoodifyLogoColor.stroke,
            ),
          ),
        ),
        Positioned(
          left: 20.w,
          right: 20.w,
          top: 77.h,
          child: _SearchAndFilterRow(
            controller: controller,
            hintText: hintText,
            initialText: initialText,
            onChanged: onChanged,
            onFilterTap: onFilterTap,
            searchBackgroundColor: const Color(0xFFF6FBF4),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchHeader() {
    return Stack(
      children: [
        Positioned(
          left: 20.w,
          right: 20.w,
          top: 41.h,
          child: _SearchAndFilterRow(
            controller: controller,
            hintText: hintText,
            initialText: initialText,
            onChanged: onChanged,
            onFilterTap: onFilterTap,
            searchBackgroundColor: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildTitleHeader(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: 12.w,
          top: 32.h,
          width: 40.r,
          height: 40.r,
          child: IconButton(
            key: const Key('foodify_app_bar_back'),
            padding: EdgeInsets.zero,
            splashRadius: 22.r,
            icon: Icon(
              Icons.chevron_left_rounded,
              color: Colors.white,
              size: 28.r,
            ),
            onPressed: onBackTap ?? () => Navigator.of(context).maybePop(),
          ),
        ),
        Positioned(
          left: 72.w,
          right: 72.w,
          top: 40.h,
          child: Text(
            title ?? '',
            key: const Key('foodify_app_bar_title'),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: _headlineStyle(fontSize: 22.sp, color: Colors.white),
          ),
        ),
        if (actionText != null)
          Positioned(
            right: 20.w,
            top: 39.h,
            child: TextButton(
              key: const Key('foodify_app_bar_action'),
              onPressed: onActionTap,
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                padding: EdgeInsets.zero,
                minimumSize: Size(50.w, 28.h),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                actionText!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  height: 1.2,
                  fontFamily: FontFamily.montserrat,
                ),
              ),
            ),
          ),
      ],
    );
  }

  static TextStyle _headlineStyle({
    required double fontSize,
    required Color color,
  }) {
    return TextStyle(
      color: color,
      fontSize: fontSize,
      fontWeight: FontWeight.w600,
      height: 1.18,
      fontFamily: 'Georgia',
      fontFamilyFallback: const ['Times New Roman', FontFamily.montserrat],
    );
  }
}

class _SearchAndFilterRow extends StatelessWidget {
  const _SearchAndFilterRow({
    required this.hintText,
    required this.searchBackgroundColor,
    this.controller,
    this.initialText,
    this.onChanged,
    this.onFilterTap,
  });

  final TextEditingController? controller;
  final String? initialText;
  final String hintText;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onFilterTap;
  final Color searchBackgroundColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: FoodifySearchField(
            controller: controller,
            initialText: initialText,
            hintText: hintText,
            onChanged: onChanged,
            backgroundColor: searchBackgroundColor,
          ),
        ),
        SizedBox(width: 3.w),
        _FilterButton(onPressed: onFilterTap),
      ],
    );
  }
}

class _FilterButton extends StatelessWidget {
  const _FilterButton({this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      key: const Key('foodify_filter_button'),
      color: FoodifyAppBar._tertiary,
      borderRadius: BorderRadius.circular(8.r),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onPressed,
        child: SizedBox(
          width: 40.r,
          height: 40.r,
          child: Center(child: FoodifyAppBar._filterIcon),
        ),
      ),
    );
  }
}

class _FoodifyAppBarSpec {
  const _FoodifyAppBarSpec({required this.height, required this.bottomRadius});

  final double height;
  final double bottomRadius;
}
