import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../common/widgets/foodify_image.dart';
import '../../../../core/gen/assets.gen.dart';
import '../../../../core/gen/fonts.gen.dart';

class ProfileRecipeCard extends StatelessWidget {
  const ProfileRecipeCard({
    super.key,
    required this.title,
    required this.chefName,
    required this.rating,
    required this.cookTime,
    required this.difficulty,
    required this.description,
    required this.imageUrl,
    required this.chefAvatarUrl,
    this.imagePlaceholderColor = const Color(0xFF353535),
  });

  final String title;
  final String chefName;
  final String rating;
  final String cookTime;
  final String difficulty;
  final String description;
  final String imageUrl;
  final String chefAvatarUrl;
  final Color imagePlaceholderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320.w,
      height: 187.h,
      decoration: BoxDecoration(
        color: const Color(0xFFF6FBF4),
        borderRadius: BorderRadius.circular(8.r),
      ),
      padding: EdgeInsets.all(6.r),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left — food image with overlays
          _RecipeImage(
            rating: rating,
            cookTime: cookTime,
            difficulty: difficulty,
            imageUrl: imageUrl,
            placeholderColor: imagePlaceholderColor,
          ),
          SizedBox(width: 13.w),
          // Right — text content
          Expanded(
            child: _RecipeDetails(
              title: title,
              chefName: chefName,
              rating: rating,
              description: description,
              chefAvatarUrl: chefAvatarUrl,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Left image section ────────────────────────────────────────────────────

class _RecipeImage extends StatelessWidget {
  const _RecipeImage({
    required this.rating,
    required this.cookTime,
    required this.difficulty,
    required this.imageUrl,
    required this.placeholderColor,
  });

  final String rating;
  final String cookTime;
  final String difficulty;
  final String imageUrl;
  final Color placeholderColor;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.r),
      child: SizedBox(
        width: 138.w,
        height: 175.h,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (imageUrl.isEmpty)
              Container(color: placeholderColor)
            else
              FoodifyImage(imageUrl, fit: BoxFit.cover),
            // Dark rating badge — top-left
            Positioned(
              top: 8.h,
              left: 8.w,
              child: _DarkRatingBadge(rating: rating),
            ),
            // Bottom gradient + time / difficulty
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: 101.h,
              child: _TimeDifficultyOverlay(
                cookTime: cookTime,
                difficulty: difficulty,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DarkRatingBadge extends StatelessWidget {
  const _DarkRatingBadge({required this.rating});

  final String rating;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 18.h,
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: const Color(0xFF353535),
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Assets.icons.recipeCards.starWhite.svg(
            width: 12.r,
            height: 12.r,
            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
          ),
          SizedBox(width: 4.w),
          Text(
            rating,
            style: TextStyle(
              color: Colors.white,
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

class _TimeDifficultyOverlay extends StatelessWidget {
  const _TimeDifficultyOverlay({
    required this.cookTime,
    required this.difficulty,
  });

  final String cookTime;
  final String difficulty;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0x00030303), Colors.black],
        ),
      ),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: EdgeInsets.only(bottom: 16.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                cookTime,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  fontFamily: FontFamily.montserrat,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 9.w),
                child: Container(
                  width: 1.w,
                  height: 13.h,
                  color: Colors.white54,
                ),
              ),
              Text(
                difficulty,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  fontFamily: FontFamily.montserrat,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Right details section ─────────────────────────────────────────────────

class _RecipeDetails extends StatelessWidget {
  const _RecipeDetails({
    required this.title,
    required this.chefName,
    required this.rating,
    required this.description,
    required this.chefAvatarUrl,
  });

  final String title;
  final String chefName;
  final String rating;
  final String description;
  final String chefAvatarUrl;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 3.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Recipe title
          Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: const Color(0xFF0E0E0E),
              fontSize: 18.sp,
              fontWeight: FontWeight.w500,
              height: 1.12,
              fontFamily: FontFamily.montserrat,
            ),
          ),
          SizedBox(height: 6.h),
          // Chef row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipOval(
                child: FoodifyImage(
                  chefAvatarUrl,
                  width: 37.r,
                  height: 37.r,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 10.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    chefName,
                    style: TextStyle(
                      color: const Color(0xFF717171),
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      height: 1,
                      fontFamily: FontFamily.montserrat,
                    ),
                  ),
                  SizedBox(height: 3.h),
                  _YellowRatingChip(rating: rating),
                ],
              ),
            ],
          ),
          SizedBox(height: 6.h),
          // Description + send button
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  description,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: const Color(0xFF353535),
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    height: 1.25,
                    fontFamily: FontFamily.montserrat,
                  ),
                ),
              ),
              SizedBox(width: 6.w),
              const _SendButton(),
            ],
          ),
        ],
      ),
    );
  }
}

class _YellowRatingChip extends StatelessWidget {
  const _YellowRatingChip({required this.rating});

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

class _SendButton extends StatelessWidget {
  const _SendButton();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32.r,
      height: 32.r,
      decoration: BoxDecoration(
        color: const Color(0xFFFF6339),
        borderRadius: BorderRadius.circular(7.r),
      ),
      child: Center(
        child: Assets.icons.recipeCards.send.svg(
          width: 18.r,
          height: 18.r,
          colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
        ),
      ),
    );
  }
}
