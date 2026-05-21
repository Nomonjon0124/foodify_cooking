import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../common/widgets/foodify_image.dart';
import '../../../../core/gen/assets.gen.dart';
import '../../../../core/gen/fonts.gen.dart';
import '../../domain/entities/recipe_author.dart';

class RecipeDetailAuthorPill extends StatelessWidget {
  const RecipeDetailAuthorPill({required this.author, super.key});

  final RecipeAuthor? author;

  @override
  Widget build(BuildContext context) {
    final name = author?.displayName ?? '';
    final avatarUrl = author?.avatarUrl;
    final rating = author?.ratingLabel;

    return SizedBox(
      height: 48.h,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: 53.w,
            right: 0,
            top: 0,
            bottom: 0,
            child: Container(
              padding: EdgeInsets.only(left: 26.w, right: 12.w),
              decoration: BoxDecoration(
                color: const Color(0xFF353535),
                borderRadius: BorderRadius.circular(84.r),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: FontFamily.montserrat,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        height: 1.2,
                      ),
                    ),
                  ),
                  if (rating != null && rating.isNotEmpty)
                    _AuthorRatingBadge(rating: rating),
                ],
              ),
            ),
          ),
          Positioned(
            left: 20.w,
            top: 0,
            child: _AuthorAvatar(avatarUrl: avatarUrl),
          ),
        ],
      ),
    );
  }
}

class _AuthorAvatar extends StatelessWidget {
  const _AuthorAvatar({this.avatarUrl});

  final String? avatarUrl;

  @override
  Widget build(BuildContext context) {
    final size = 48.r;
    final url = avatarUrl;
    final placeholder = Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: Color(0xFFEAEAEA),
        shape: BoxShape.circle,
      ),
      child: Icon(Icons.person, size: size * 0.55, color: Colors.white),
    );
    if (url == null || url.isEmpty) return placeholder;
    return ClipOval(
      child: SizedBox(
        width: size,
        height: size,
        child: FoodifyImage(url, fit: BoxFit.cover),
      ),
    );
  }
}

class _AuthorRatingBadge extends StatelessWidget {
  const _AuthorRatingBadge({required this.rating});

  final String rating;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 18.h,
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: const Color(0xFFDEE21B),
        borderRadius: BorderRadius.circular(31.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Assets.icons.recipeCards.starDark.svg(width: 12.w, height: 12.h),
          SizedBox(width: 4.w),
          Text(
            rating,
            style: TextStyle(
              color: const Color(0xFF353535),
              fontFamily: FontFamily.montserrat,
              fontSize: 11.sp,
              fontWeight: FontWeight.w400,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}
