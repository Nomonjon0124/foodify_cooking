import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../common/widgets/foodify_image.dart';
import '../../../../core/gen/assets.gen.dart';
import '../../../../core/gen/fonts.gen.dart';

class RecipeDetailHero extends StatelessWidget {
  const RecipeDetailHero({
    required this.coverImageUrl,
    required this.ratingLabel,
    required this.isSaved,
    required this.isLiked,
    required this.isLikeInFlight,
    required this.onSavePressed,
    required this.onLikePressed,
    super.key,
  });

  final String coverImageUrl;
  final String ratingLabel;
  final bool isSaved;
  final bool isLiked;
  final bool isLikeInFlight;
  final VoidCallback onSavePressed;
  final VoidCallback onLikePressed;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final topInset = media.padding.top;

    return SizedBox(
      height: 256.h + topInset,
      child: Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(12.r)),
            child: FoodifyImage(coverImageUrl, fit: BoxFit.cover),
          ),
          Positioned.fill(
            child: IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(12.r),
                  ),
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0.4, 1],
                    colors: [Colors.transparent, Color(0xCC000000)],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 20.w,
            top: topInset + 12.h,
            child: _CircleIconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
              onPressed: () => context.pop(),
            ),
          ),
          Positioned(
            left: 16.w,
            bottom: 16.h,
            child: _RatingBadge(rating: ratingLabel),
          ),
          Positioned(
            right: 16.w,
            bottom: 16.h,
            child: Row(
              children: [
                _HeroAction(
                  icon: Icon(
                    isSaved ? Icons.bookmark : Icons.bookmark_outline,
                    color: Colors.white,
                    size: 22.sp,
                  ),
                  assetIcon: isSaved
                      ? Assets.icons.foodifyComponents.archiveMinusBold.svg(
                          width: 22.w,
                          height: 22.h,
                          colorFilter: const ColorFilter.mode(
                            Colors.white,
                            BlendMode.srcIn,
                          ),
                        )
                      : Assets.icons.foodifyComponents.archiveMinusOutline.svg(
                          width: 22.w,
                          height: 22.h,
                          colorFilter: const ColorFilter.mode(
                            Colors.white,
                            BlendMode.srcIn,
                          ),
                        ),
                  onPressed: onSavePressed,
                ),
                SizedBox(width: 16.w),
                _HeroAction(
                  icon: isLikeInFlight
                      ? SizedBox(
                          width: 20.w,
                          height: 20.h,
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation(Colors.white),
                          ),
                        )
                      : Icon(
                          isLiked ? Icons.favorite : Icons.favorite_border,
                          color: isLiked ? const Color(0xFFFF6339) : Colors.white,
                          size: 22.sp,
                        ),
                  onPressed: isLikeInFlight ? null : onLikePressed,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RatingBadge extends StatelessWidget {
  const _RatingBadge({required this.rating});

  final String rating;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 23.h,
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: const Color(0xFF353535),
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Assets.icons.recipeCards.starWhite.svg(width: 12.w, height: 12.h),
          SizedBox(width: 4.w),
          Text(
            rating,
            style: TextStyle(
              color: Colors.white,
              fontSize: 11.sp,
              fontFamily: FontFamily.montserrat,
              fontWeight: FontWeight.w400,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroAction extends StatelessWidget {
  const _HeroAction({
    required this.icon,
    this.assetIcon,
    required this.onPressed,
  });

  final Widget icon;
  final Widget? assetIcon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: EdgeInsets.all(4.r),
        child: assetIcon ?? icon,
      ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  const _CircleIconButton({required this.icon, required this.onPressed});

  final Widget icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withValues(alpha: 0.25),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onPressed,
        child: Padding(
          padding: EdgeInsets.all(8.r),
          child: IconTheme(
            data: IconThemeData(size: 18.sp, color: Colors.white),
            child: icon,
          ),
        ),
      ),
    );
  }
}
