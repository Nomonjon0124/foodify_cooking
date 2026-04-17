import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/gen/fonts.gen.dart';

class SearchTagsTab extends StatelessWidget {
  const SearchTagsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF6FBF4),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: ListView.builder(
        padding: EdgeInsets.fromLTRB(0, 16.h, 0, 118.h),
        itemCount: _mockTags.length,
        itemBuilder: (context, index) => _TagItem(
          tag: _mockTags[index],
          isHighlighted: index == 2,
        ),
      ),
    );
  }
}

class _TagItem extends StatelessWidget {
  const _TagItem({required this.tag, this.isHighlighted = false});

  final String tag;
  final bool isHighlighted;

  @override
  Widget build(BuildContext context) {
    final row = Row(
      children: [
        const _TagIcon(),
        SizedBox(width: 4.w),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Text(
              tag,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                fontFamily: FontFamily.montserrat,
                height: 1.2,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ],
    );

    if (isHighlighted) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.h),
        child: Container(
          height: 54.r,
          padding: EdgeInsets.all(3.r),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(27.r),
          ),
          child: row,
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 11.w, vertical: 8.h),
      child: SizedBox(height: 48.r, child: row),
    );
  }
}

class _TagIcon extends StatelessWidget {
  const _TagIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48.r,
      height: 48.r,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFFCBCBCB)),
      ),
      child: Center(
        child: Text(
          '#',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w400,
            fontFamily: FontFamily.montserrat,
            height: 1.2,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}

const _mockTags = [
  '#egg',
  '#eggrecipe',
  '#eggfast',
  '#eggsandvich',
  '#eggrolls',
];
