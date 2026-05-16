import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodify_cooking/core/gen/assets.gen.dart';

import '../../../core/gen/fonts.gen.dart';
import '../../../l10n/l10n_extension.dart';

class FoodifyBottomNavigationBar extends StatelessWidget {
  const FoodifyBottomNavigationBar({
    required this.currentIndex,
    required this.onTap,
    super.key,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  static const _primaryColor = Color(0xFF4058A0);
  static const _secondaryColor = Color(0xFFFF6339);
  static const _inactiveColor = Color(0xFFCBCBCB);
  static const _whiteColor = Colors.white;
  static const _designWidth = 360.0;
  static const _itemCenters = [59.0, 119.0, 178.0, 237.0, 296.0];
  @override
  Widget build(BuildContext context) {
    final items = _itemsFor(context);
    final activeIndex = currentIndex.clamp(0, items.length - 1);

    return Material(
      color: Colors.transparent,
      child: SafeArea(
        top: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth.isFinite
                ? constraints.maxWidth
                : _designWidth.w;
            final activeCenterX = _scaledCenterX(width, activeIndex);

            return Material(
              color: Colors.transparent,
              child: SizedBox(
                width: double.infinity,
                height: 93.h,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      left: 0,
                      right: 0,
                      top: 17.h,
                      height: 76.h,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: _primaryColor,
                          borderRadius: BorderRadius.circular(1.r),
                        ),
                      ),
                    ),
                    AnimatedPositioned(
                      key: const Key('bottom_nav_active_indicator'),
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeOutCubic,
                      left: activeCenterX - (110.w / 2),
                      top: 0,
                      width: 110.w,
                      height: 52.h,
                      child: const CustomPaint(
                        key: Key('bottom_nav_active_shape'),
                        painter: _ActiveTabShapePainter(),
                      ),
                    ),
                    for (var index = 0; index < items.length; index++)
                      Positioned(
                        left:
                            _scaledCenterX(width, index) -
                            (_hitWidthForIndex(index) / 2),
                        top: 0,
                        width: _hitWidthForIndex(index),
                        height: 93.h,
                        child: _FoodifyBottomNavigationItemButton(
                          item: items[index],
                          itemKey: 'bottom_nav_item_${items[index].id}',
                          isSelected: index == activeIndex,
                          onTap: () => onTap(index),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  static double _scaledCenterX(double width, int index) {
    return (_itemCenters[index] / _designWidth) * width;
  }

  static double _hitWidthForIndex(int index) {
    return index == 2 ? 70.w : 60.w;
  }

  static List<_FoodifyBottomNavItem> _itemsFor(BuildContext context) {
    final l10n = context.l10n;
    return [
      _FoodifyBottomNavItem(
        id: 'home',
        label: l10n.navHome,
        selectedIcon: Assets.icons.bottomNav.homeBold.svg(
          width: 24.r,
          height: 24.r,
          colorFilter: const ColorFilter.mode(_whiteColor, BlendMode.srcIn),
        ),
        unselectedIcon: Assets.icons.bottomNav.homeOutline.svg(
          width: 24.r,
          height: 24.r,
          colorFilter: const ColorFilter.mode(_inactiveColor, BlendMode.srcIn),
        ),
      ),
      _FoodifyBottomNavItem(
        id: 'search',
        label: l10n.navSearch,
        selectedIcon: Assets.icons.bottomNav.searchBold.svg(
          width: 24.r,
          height: 24.r,
          colorFilter: const ColorFilter.mode(_whiteColor, BlendMode.srcIn),
        ),
        unselectedIcon: Assets.icons.bottomNav.searchOutline.svg(
          width: 24.r,
          height: 24.r,
          colorFilter: const ColorFilter.mode(_inactiveColor, BlendMode.srcIn),
        ),
      ),
      _FoodifyBottomNavItem(
        id: 'add_new',
        label: l10n.navAddNew,
        selectedIcon: Assets.icons.bottomNav.addNewBold.svg(
          width: 24.r,
          height: 24.r,
          colorFilter: const ColorFilter.mode(_whiteColor, BlendMode.srcIn),
        ),
        unselectedIcon: Assets.icons.bottomNav.addNewOutline.svg(
          width: 24.r,
          height: 24.r,
          colorFilter: const ColorFilter.mode(_inactiveColor, BlendMode.srcIn),
        ),
        labelWidth: 64,
      ),
      _FoodifyBottomNavItem(
        id: 'save',
        label: l10n.navSave,
        selectedIcon: Assets.icons.bottomNav.saveBold.svg(
          width: 24.r,
          height: 24.r,
          colorFilter: const ColorFilter.mode(_whiteColor, BlendMode.srcIn),
        ),
        unselectedIcon: Assets.icons.bottomNav.saveOutline.svg(
          width: 24.r,
          height: 24.r,
          colorFilter: const ColorFilter.mode(_inactiveColor, BlendMode.srcIn),
        ),
        labelWidth: 62,
      ),
      _FoodifyBottomNavItem(
        id: 'profile',
        label: l10n.navProfile,
        selectedIcon: Assets.icons.bottomNav.profileBold.svg(
          width: 24.r,
          height: 24.r,
          colorFilter: const ColorFilter.mode(_whiteColor, BlendMode.srcIn),
        ),
        unselectedIcon: Assets.icons.bottomNav.profileOutline.svg(
          width: 24.r,
          height: 24.r,
          colorFilter: const ColorFilter.mode(_inactiveColor, BlendMode.srcIn),
        ),
        labelWidth: 62,
      ),
    ];
  }
}

class _ActiveTabShapePainter extends CustomPainter {
  const _ActiveTabShapePainter();

  static const _figmaWidth = 110.0;
  static const _figmaHeight = 52.0;
  static const _white = Color(0xFFFFFFFF);
  static const _orange = FoodifyBottomNavigationBar._secondaryColor;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;

    canvas
      ..save()
      ..scale(size.width / _figmaWidth, size.height / _figmaHeight);

    final cutoutPath = Path()
      ..moveTo(55, 52)
      ..cubicTo(85.3757, 52, 78, 17, 110, 17)
      ..lineTo(0, 17)
      ..cubicTo(33.5, 17, 24.6243, 52, 55, 52)
      ..close();

    canvas
      ..drawPath(cutoutPath, Paint()..color = _white)
      ..drawCircle(Offset(55.5, 22.5), 22.5, Paint()..color = _orange)
      ..restore();
  }

  @override
  bool shouldRepaint(covariant _ActiveTabShapePainter oldDelegate) => false;
}

class _FoodifyBottomNavigationItemButton extends StatelessWidget {
  const _FoodifyBottomNavigationItemButton({
    required this.item,
    required this.itemKey,
    required this.isSelected,
    required this.onTap,
  });

  final _FoodifyBottomNavItem item;
  final String itemKey;
  final bool isSelected;
  final VoidCallback onTap;

  static const _inactiveColor = FoodifyBottomNavigationBar._inactiveColor;
  static const _whiteColor = FoodifyBottomNavigationBar._whiteColor;

  @override
  Widget build(BuildContext context) {
    final labelWidth = item.labelWidth.w;
    final iconTop = isSelected ? 11.h : 34.h;
    final labelTop = isSelected ? 54.h : 63.h;
    final color = isSelected ? _whiteColor : _inactiveColor;

    return Semantics(
      button: true,
      selected: isSelected,
      label: item.label,
      child: GestureDetector(
        key: Key(itemKey),
        behavior: HitTestBehavior.translucent,
        onTap: onTap,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final centerX = constraints.maxWidth / 2;

            return SizedBox(
              width: double.infinity,
              height: 93.h,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 180),
                    curve: Curves.easeOutCubic,
                    left: centerX - 12.r,
                    top: iconTop,
                    width: 24.r,
                    height: 24.r,
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 180),
                      switchInCurve: Curves.easeOutCubic,
                      switchOutCurve: Curves.easeInCubic,
                      child: isSelected
                          ? item.selectedIcon
                          : item.unselectedIcon,
                    ),
                  ),
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 180),
                    curve: Curves.easeOutCubic,
                    left: centerX - (labelWidth / 2),
                    top: labelTop,
                    width: labelWidth,
                    height: 18.h,
                    child: AnimatedDefaultTextStyle(
                      key: Key('${itemKey}_label_style'),
                      duration: const Duration(milliseconds: 180),
                      curve: Curves.easeOutCubic,
                      style: TextStyle(
                        color: color,
                        fontSize: 11.sp,
                        height: 1,
                        fontWeight: FontWeight.w400,
                        fontFamily: FontFamily.montserrat,
                      ),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          item.label,
                          key: Key('${itemKey}_label'),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _FoodifyBottomNavItem {
  const _FoodifyBottomNavItem({
    required this.id,
    required this.label,
    required this.selectedIcon,
    required this.unselectedIcon,
    this.labelWidth = 58,
  });

  final String id;
  final String label;
  final Widget selectedIcon;
  final Widget unselectedIcon;
  final double labelWidth;
}
