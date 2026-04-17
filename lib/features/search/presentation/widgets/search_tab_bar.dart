import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/gen/fonts.gen.dart';

class SearchTabBar extends StatelessWidget {
  const SearchTabBar({super.key});

  static const _bgColor = Color(0xFFF6FBF4);
  static const _activeTextColor = Color(0xFF353535);
  static const _inactiveTextColor = Color(0xFF717171);
  static const _indicatorColor = Color(0xFF4058A0);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 29.r,
      decoration: BoxDecoration(
        color: _bgColor,
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: TabBar(
        labelStyle: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w700,
          fontFamily: FontFamily.montserrat,
          height: 1.2,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w400,
          fontFamily: FontFamily.montserrat,
          height: 1.2,
        ),
        labelColor: _activeTextColor,
        unselectedLabelColor: _inactiveTextColor,
        indicatorColor: _indicatorColor,
        indicatorWeight: 2,
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        dividerHeight: 0,
        tabs: [
          Tab(height: 29.r, text: 'Recipes'),
          Tab(height: 29.r, text: 'Chefs'),
          Tab(height: 29.r, text: 'Tags'),
        ],
      ),
    );
  }
}
