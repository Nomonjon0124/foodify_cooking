import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/gen/fonts.gen.dart';
import '../cubit/add_new_cubit.dart';

class PreviewTabs extends StatelessWidget {
  const PreviewTabs({
    required this.activeTab,
    required this.onChanged,
    super.key,
  });

  final RecipePreviewTab activeTab;
  final ValueChanged<RecipePreviewTab> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: RecipePreviewTab.values
          .map(
            (tab) => Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  right: tab == RecipePreviewTab.comments ? 0 : 8.w,
                ),
                child: GestureDetector(
                  onTap: () => onChanged(tab),
                  child: Container(
                    height: 37.h,
                    decoration: BoxDecoration(
                      color: activeTab == tab
                          ? Colors.white
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(4.r),
                      border: Border.all(
                        color: activeTab == tab
                            ? Colors.transparent
                            : const Color(0xFFADADAD),
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      _labelFor(tab),
                      style: TextStyle(
                        color: activeTab == tab
                            ? const Color(0xFF0E0E0E)
                            : const Color(0xFFADADAD),
                        fontSize: 14.sp,
                        fontWeight: activeTab == tab
                            ? FontWeight.w700
                            : FontWeight.w400,
                        fontFamily: FontFamily.montserrat,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  String _labelFor(RecipePreviewTab tab) {
    switch (tab) {
      case RecipePreviewTab.introduction:
        return 'Introduction';
      case RecipePreviewTab.ingredients:
        return 'Ingredients';
      case RecipePreviewTab.comments:
        return 'Comments';
    }
  }
}
