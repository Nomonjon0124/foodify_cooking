import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/gen/fonts.gen.dart';
import '../cubit/recipe_detail_state.dart';

class RecipeDetailTabBar extends StatelessWidget {
  const RecipeDetailTabBar({
    required this.activeTab,
    required this.labels,
    required this.onTabSelected,
    super.key,
  });

  final RecipeDetailTab activeTab;
  final Map<RecipeDetailTab, String> labels;
  final ValueChanged<RecipeDetailTab> onTabSelected;

  @override
  Widget build(BuildContext context) {
    final tabs = RecipeDetailTab.values;
    return Row(
      children: [
        for (final tab in tabs) ...[
          Expanded(
            child: _TabSegment(
              label: labels[tab] ?? '',
              isActive: tab == activeTab,
              onPressed: () => onTabSelected(tab),
            ),
          ),
          if (tab != tabs.last) SizedBox(width: 8.w),
        ],
      ],
    );
  }
}

class _TabSegment extends StatelessWidget {
  const _TabSegment({
    required this.label,
    required this.isActive,
    required this.onPressed,
  });

  final String label;
  final bool isActive;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        height: 37.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(
            color: isActive ? Colors.transparent : const Color(0xFFADADAD),
          ),
          borderRadius: BorderRadius.circular(4.r),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: FontFamily.montserrat,
            fontSize: 14.sp,
            fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
            color: isActive
                ? const Color(0xFF0E0E0E)
                : const Color(0xFFADADAD),
            height: 1.2,
          ),
        ),
      ),
    );
  }
}
