import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/gen/fonts.gen.dart';

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
  static const _items = [
    _FoodifyBottomNavItem(
      label: 'Home',
      selectedIconPath: 'assets/icons/bottom_nav/home_bold.svg',
      unselectedIconPath: 'assets/icons/bottom_nav/home_outline.svg',
    ),
    _FoodifyBottomNavItem(
      label: 'Search',
      selectedIconPath: 'assets/icons/bottom_nav/search_bold.svg',
      unselectedIconPath: 'assets/icons/bottom_nav/search_outline.svg',
    ),
    _FoodifyBottomNavItem(
      label: 'Add New',
      selectedIconPath: 'assets/icons/bottom_nav/add_new_bold.svg',
      unselectedIconPath: 'assets/icons/bottom_nav/add_new_outline.svg',
      labelWidth: 59,
    ),
    _FoodifyBottomNavItem(
      label: 'Save',
      selectedIconPath: 'assets/icons/bottom_nav/save_bold.svg',
      unselectedIconPath: 'assets/icons/bottom_nav/save_outline.svg',
    ),
    _FoodifyBottomNavItem(
      label: 'Profile',
      selectedIconPath: 'assets/icons/bottom_nav/profile_bold.svg',
      unselectedIconPath: 'assets/icons/bottom_nav/profile_outline.svg',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final activeIndex = currentIndex.clamp(0, _items.length - 1);

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

            return SizedBox(
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
                  for (var index = 0; index < _items.length; index++)
                    Positioned(
                      left:
                          _scaledCenterX(width, index) -
                          (_hitWidthForIndex(index) / 2),
                      top: 0,
                      width: _hitWidthForIndex(index),
                      height: 93.h,
                      child: _FoodifyBottomNavigationItemButton(
                        item: _items[index],
                        isSelected: index == activeIndex,
                        onTap: () => onTap(index),
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

  static double _scaledCenterX(double width, int index) {
    return (_itemCenters[index] / _designWidth) * width;
  }

  static double _hitWidthForIndex(int index) {
    return index == 2 ? 70.w : 60.w;
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
    required this.isSelected,
    required this.onTap,
  });

  final _FoodifyBottomNavItem item;
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
                      child: SvgPicture.asset(
                        isSelected
                            ? item.selectedIconPath
                            : item.unselectedIconPath,
                        key: ValueKey<String>(
                          '${item.label}_${isSelected ? 'selected' : 'unselected'}',
                        ),
                        width: 24.r,
                        height: 24.r,
                        colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
                      ),
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
                      key: Key('bottom_nav_label_style_${item.label}'),
                      duration: const Duration(milliseconds: 180),
                      curve: Curves.easeOutCubic,
                      style: TextStyle(
                        color: color,
                        fontSize: 11.sp,
                        height: 1,
                        fontWeight: FontWeight.w400,
                        fontFamily: FontFamily.montserrat,
                      ),
                      child: Text(
                        item.label,
                        key: Key('bottom_nav_label_${item.label}'),
                        textAlign: TextAlign.center,
                        maxLines: 1,
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
    required this.label,
    required this.selectedIconPath,
    required this.unselectedIconPath,
    this.labelWidth = 47,
  });

  final String label;
  final String selectedIconPath;
  final String unselectedIconPath;
  final double labelWidth;
}
