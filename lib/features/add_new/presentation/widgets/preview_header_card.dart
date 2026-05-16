import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/gen/assets.gen.dart';
import '../../../../core/gen/fonts.gen.dart';
import '../../../../l10n/l10n_extension.dart';
import '../add_new_constants.dart';
import '../cubit/add_new_cubit.dart';

class PreviewHeaderCard extends StatelessWidget {
  const PreviewHeaderCard({
    required this.state,
    required this.onBack,
    super.key,
  });

  final AddNewState state;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final contentWidth = MediaQuery.sizeOf(
      context,
    ).width.clamp(0.0, 430.0).toDouble();
    final headerHeight = (contentWidth * 0.62).clamp(220.h, 256.h).toDouble();

    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(12.r),
                bottomRight: Radius.circular(12.r),
              ),
              child: SizedBox(
                width: double.infinity,
                height: headerHeight,
                child: Image.asset(state.coverImagePath, fit: BoxFit.cover),
              ),
            ),
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(12.r),
                    bottomRight: Radius.circular(12.r),
                  ),
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0x00000000), Color(0xFF000000)],
                    stops: [0.35, 1],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 26.h,
              left: 16.w,
              child: GestureDetector(
                key: const Key('preview-back-button'),
                onTap: onBack,
                child: Container(
                  width: 28.r,
                  height: 28.r,
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.chevron_left_rounded,
                    color: Colors.white,
                    size: 26.r,
                  ),
                ),
              ),
            ),
            Positioned(
              left: 15.w,
              bottom: 11.h,
              child: _RatingBadge(
                backgroundColor: const Color(0xFF353535),
                labelColor: Colors.white,
                icon: Assets.icons.recipeCards.starWhite.svg(
                  width: 12.r,
                  height: 12.r,
                ),
                label: AddNewConstants.recipeRating,
              ),
            ),
            Positioned(
              right: 20.w,
              bottom: 13.h,
              child: Row(
                children: [
                  Assets.icons.foodifyComponents.archiveMinusOutline.svg(
                    width: 20.r,
                    height: 20.r,
                    colorFilter: const ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcIn,
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Icon(
                    Icons.favorite_border_rounded,
                    color: Colors.white,
                    size: 20.r,
                  ),
                  SizedBox(width: 16.w),
                  Assets.icons.recipeCards.send.svg(
                    width: 20.r,
                    height: 20.r,
                    colorFilter: const ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcIn,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: -24.h,
              child: Row(
                children: [
                  Container(
                    width: 68.w,
                    height: 48.h,
                    decoration: BoxDecoration(
                      color: const Color(0xFF353535),
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(40.r),
                        bottomRight: Radius.circular(40.r),
                      ),
                    ),
                  ),
                  SizedBox(width: 5.w),
                  Expanded(
                    child: Container(
                      height: 48.h,
                      decoration: BoxDecoration(
                        color: const Color(0xFF353535),
                        borderRadius: BorderRadius.circular(84.r),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Row(
                        children: [
                          ClipOval(
                            child: Image.asset(
                              Assets.images.recipeCards.userPic.path,
                              width: 48.r,
                              height: 48.r,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: Text(
                              AddNewConstants.authorName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w700,
                                fontFamily: FontFamily.montserrat,
                              ),
                            ),
                          ),
                          _RatingBadge(
                            backgroundColor: const Color(0xFFDEE21B),
                            labelColor: const Color(0xFF353535),
                            icon: Assets.icons.recipeCards.starDark.svg(
                              width: 12.r,
                              height: 12.r,
                            ),
                            label: AddNewConstants.authorRating,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 20.w),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 40.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: const Color(0xFF4058A0),
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: Text(
              state.title.trim().isEmpty
                  ? context.l10n.addNewRecipeTitleFallback
                  : state.title.trim(),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.sp,
                fontWeight: FontWeight.w400,
                fontFamily: FontFamily.montserrat,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _RatingBadge extends StatelessWidget {
  const _RatingBadge({
    required this.backgroundColor,
    required this.labelColor,
    required this.icon,
    required this.label,
  });

  final Color backgroundColor;
  final Color labelColor;
  final Widget icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 23.h,
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(31.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon,
          SizedBox(width: 4.w),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: labelColor,
              fontSize: 11.sp,
              fontWeight: FontWeight.w400,
              fontFamily: FontFamily.montserrat,
            ),
          ),
        ],
      ),
    );
  }
}
