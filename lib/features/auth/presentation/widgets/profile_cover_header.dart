import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../common/widgets/foodify_image.dart';
import '../../../../core/gen/assets.gen.dart';
import '../../../../core/gen/fonts.gen.dart';

class ProfileCoverHeader extends StatelessWidget {
  const ProfileCoverHeader({
    super.key,
    required this.coverImageUrl,
    required this.rating,
  });

  final String coverImageUrl;
  final String rating;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 128.h,
      child: Stack(
        children: [
          // Cover background (placeholder — swap for real image later)
          ClipRRect(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(8.r)),
            child: SizedBox(
              width: double.infinity,
              height: 128.h,
              child: FoodifyImage(coverImageUrl, fit: BoxFit.cover),
            ),
          ),
          // Bottom gradient overlay
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: 70.h,
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(8.r)),
              child: const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    stops: [0.03, 0.58],
                    colors: [Color(0xED000000), Color(0x00000000)],
                  ),
                ),
              ),
            ),
          ),
          // Yellow rating chip — bottom-left of cover
          Positioned(
            left: 24.w,
            top: 100.h,
            child: _RatingChip(rating: rating),
          ),
          // Share / export icon
          Positioned(
            left: 75.w,
            top: 99.h,
            child: Icon(
              Icons.ios_share_rounded,
              color: Colors.white,
              size: 20.r,
            ),
          ),
          // Menu button — top-right
          Positioned(right: 20.w, top: 37.h, child: const _MenuButton()),
        ],
      ),
    );
  }
}

class _RatingChip extends StatelessWidget {
  const _RatingChip({required this.rating});

  final String rating;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 18.h,
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: const Color(0xFFDEE21B),
        borderRadius: BorderRadius.circular(22.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Assets.icons.recipeCards.starDark.svg(width: 12.r, height: 12.r),
          SizedBox(width: 4.w),
          Text(
            rating,
            style: TextStyle(
              color: const Color(0xFF353535),
              fontSize: 11.sp,
              fontWeight: FontWeight.w400,
              height: 1,
              fontFamily: FontFamily.montserrat,
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuButton extends StatelessWidget {
  const _MenuButton();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32.r,
      height: 32.r,
      decoration: const BoxDecoration(
        color: Color(0xFF353535),
        shape: BoxShape.circle,
      ),
      child: Icon(Icons.menu_rounded, color: Colors.white, size: 20.r),
    );
  }
}
