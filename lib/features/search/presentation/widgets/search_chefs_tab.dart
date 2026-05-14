import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/gen/assets.gen.dart';
import '../../../../core/gen/fonts.gen.dart';

class SearchChefsTab extends StatelessWidget {
  const SearchChefsTab({super.key});

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
        itemCount: _mockChefs.length,
        itemBuilder: (context, index) =>
            _ChefItem(chef: _mockChefs[index], isHighlighted: index == 2),
      ),
    );
  }
}

class _ChefItem extends StatelessWidget {
  const _ChefItem({required this.chef, this.isHighlighted = false});

  final _ChefSample chef;
  final bool isHighlighted;

  @override
  Widget build(BuildContext context) {
    final row = Row(
      children: [
        ClipOval(
          child: chef.image.image(width: 48.r, height: 48.r, fit: BoxFit.cover),
        ),
        SizedBox(width: 4.w),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Text(
              chef.name,
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

class _ChefSample {
  const _ChefSample({required this.name, required this.image});

  final String name;
  final AssetGenImage image;
}

final _mockChefs = [
  _ChefSample(name: 'Mark Salvador', image: Assets.images.recipeCards.userPic),
  _ChefSample(
    name: 'Martin Robert',
    image: Assets.images.recipeCards.userPicRick,
  ),
  _ChefSample(name: 'Melisa Anne', image: Assets.images.recipeCards.userPic),
  _ChefSample(
    name: 'Dave Robert',
    image: Assets.images.recipeCards.userPicDave,
  ),
  _ChefSample(name: 'Kelly Mayer', image: Assets.images.recipeCards.userPic),
];
