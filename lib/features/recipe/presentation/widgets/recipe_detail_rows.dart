import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/gen/fonts.gen.dart';
import '../../../../common/widgets/foodify_image.dart';

class RecipeNumberedRow extends StatelessWidget {
  const RecipeNumberedRow({
    required this.number,
    required this.content,
    this.isBold = false,
    super.key,
  });

  final int number;
  final String content;
  final bool isBold;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _NumberBadge(number: number),
          SizedBox(width: 12.w),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4.r),
              ),
              child: Text(
                content,
                style: TextStyle(
                  fontFamily: FontFamily.montserrat,
                  fontSize: 12.sp,
                  fontWeight: isBold ? FontWeight.w700 : FontWeight.w400,
                  height: 1.25,
                  color: const Color(0xFF353535),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NumberBadge extends StatelessWidget {
  const _NumberBadge({required this.number});

  final int number;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 23.r,
      height: 23.r,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0xFFFF6339),
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Text(
        number.toString().padLeft(2, '0'),
        style: TextStyle(
          fontFamily: FontFamily.montserrat,
          color: const Color(0xFFF6FBF4),
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.8,
          height: 1,
        ),
      ),
    );
  }
}

class RecipeCommentRow extends StatelessWidget {
  const RecipeCommentRow({
    required this.authorName,
    required this.content,
    this.authorAvatarUrl,
    super.key,
  });

  final String authorName;
  final String content;
  final String? authorAvatarUrl;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CommentAvatar(avatarUrl: authorAvatarUrl),
          SizedBox(width: 12.w),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    authorName,
                    style: TextStyle(
                      fontFamily: FontFamily.montserrat,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF353535),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    content,
                    style: TextStyle(
                      fontFamily: FontFamily.montserrat,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      height: 1.25,
                      color: const Color(0xFF353535),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CommentAvatar extends StatelessWidget {
  const _CommentAvatar({this.avatarUrl});

  final String? avatarUrl;

  @override
  Widget build(BuildContext context) {
    final size = 23.r;
    final placeholder = Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: Color(0xFFEAEAEA),
        shape: BoxShape.circle,
      ),
      child: Icon(Icons.person, size: size * 0.6, color: Colors.white),
    );
    final url = avatarUrl;
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
