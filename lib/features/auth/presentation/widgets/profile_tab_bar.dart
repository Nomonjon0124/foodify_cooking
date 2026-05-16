import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/gen/fonts.gen.dart';
import '../../../../l10n/l10n_extension.dart';

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
    final l10n = context.l10n;
    final tabs = [
      l10n.profilePost(postsCount),
      l10n.profileLessDetails,
      l10n.profileMoreDetails,
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : MediaQuery.sizeOf(context).width;
        final width = availableWidth.clamp(0.0, 348.w).toDouble();

        return Container(
          width: width,
          constraints: BoxConstraints(minHeight: 40.r),
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
                    constraints: BoxConstraints(minHeight: 40.r),
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
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
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: isSelected
                            ? const Color(0xFF353535)
                            : const Color(0xFF717171),
                        fontSize: 12.sp,
                        fontWeight: isSelected
                            ? FontWeight.w700
                            : FontWeight.w400,
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
      },
    );
  }
}
