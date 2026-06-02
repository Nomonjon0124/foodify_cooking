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
    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : 320.w;
        final imageWidth = (availableWidth * 0.42)
            .clamp(104.w, 138.w)
            .toDouble();
        final imageHeight = (imageWidth * 175 / 138)
            .clamp(132.h, 175.h)
            .toDouble();

        return Container(
          width: double.infinity,
          constraints: BoxConstraints(minHeight: 187.h),
          padding: EdgeInsets.all(6.r),
          decoration: BoxDecoration(
            color: const Color(0xFFF6FBF4),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _RecipeImage(
                cookTime: cookTime,
                difficulty: difficulty,
                imageUrl: imageUrl,
                placeholderColor: imagePlaceholderColor,
                width: imageWidth,
                height: imageHeight,
              ),
              SizedBox(width: 13.w),
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
      },
    );
  }
}

class _RecipeImage extends StatelessWidget {
  const _RecipeImage({
    required this.cookTime,
    required this.difficulty,
    required this.imageUrl,
    required this.placeholderColor,
    required this.width,
    required this.height,
  });

  final String cookTime;
  final String difficulty;
  final String imageUrl;
  final Color placeholderColor;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.r),
      child: SizedBox(
        width: width,
        height: height,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (imageUrl.isEmpty)
              Container(color: placeholderColor)
            else
              FoodifyImage(imageUrl, fit: BoxFit.cover),
            // Recipe rating badge hidden.
            // Positioned(
            //   top: 8.h,
            //   left: 8.w,
            //   child: _DarkRatingBadge(rating: rating),
            // ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: height * 0.58,
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

// Recipe rating badge hidden (recipe rating display disabled).
// class _DarkRatingBadge extends StatelessWidget {
//   const _DarkRatingBadge({required this.rating});
//
//   final String rating;
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 18.h,
//       padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 4.h),
//       decoration: BoxDecoration(
//         color: const Color(0xFF353535),
//         borderRadius: BorderRadius.circular(4.r),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Assets.icons.recipeCards.starWhite.svg(
//             width: 12.r,
//             height: 12.r,
//             colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
//           ),
//           SizedBox(width: 4.w),
//           Text(
//             rating,
//             maxLines: 1,
//             overflow: TextOverflow.ellipsis,
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 11.sp,
//               fontWeight: FontWeight.w400,
//               height: 1,
//               fontFamily: FontFamily.montserrat,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

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
          padding: EdgeInsets.fromLTRB(8.w, 0, 8.w, 16.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  cookTime,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    fontFamily: FontFamily.montserrat,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 7.w),
                child: Container(
                  width: 1.w,
                  height: 13.h,
                  color: Colors.white54,
                ),
              ),
              Flexible(
                child: Text(
                  difficulty,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    fontFamily: FontFamily.montserrat,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

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
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      chefName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: const Color(0xFF717171),
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        height: 1,
                        fontFamily: FontFamily.montserrat,
                      ),
                    ),
                    SizedBox(height: 3.h),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: _YellowRatingChip(rating: rating),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 6.h),
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
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
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
