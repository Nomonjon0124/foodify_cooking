import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/gen/fonts.gen.dart';

class ProfileTabBar extends StatelessWidget {
  const ProfileTabBar({
    super.key,
    required this.selectedIndex,
    required this.onTabChanged,
    this.postsCount = 18,
  });

  final int selectedIndex;
  final ValueChanged<int> onTabChanged;
  final int postsCount;

  @override
  Widget build(BuildContext context) {
    final tabs = ['$postsCount Post', 'Less Details', 'More Details'];

    return Container(
      width: 348.w,
      height: 29.h,
      decoration: BoxDecoration(
        color: const Color(0xFFF6FBF4),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Row(
        children: List.generate(tabs.length, (i) {
          final isSelected = i == selectedIndex;
          return Expanded(
            child: GestureDetector(
              onTap: () => onTabChanged(i),
              behavior: HitTestBehavior.opaque,
              child: Container(
                height: 29.h,
                alignment: Alignment.center,
                decoration: isSelected
                    ? BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: const Color(0xFF4058A0),
                            width: 1.5.r,
                          ),
                        ),
                      )
                    : null,
                child: Text(
                  tabs[i],
                  style: TextStyle(
                    color: isSelected
                        ? const Color(0xFF353535)
                        : const Color(0xFF717171),
                    fontSize: 12.sp,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                    height: 1.2,
                    fontFamily: FontFamily.montserrat,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
