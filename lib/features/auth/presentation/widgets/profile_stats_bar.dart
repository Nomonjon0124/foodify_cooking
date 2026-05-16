import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/gen/fonts.gen.dart';
import '../../../../l10n/l10n_extension.dart';

class ProfileStatsBar extends StatelessWidget {
  const ProfileStatsBar({
    super.key,
    this.followers = '357K',
    this.following = '24',
  });

  final String followers;
  final String following;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 348.w,
      height: 48.h,
      decoration: BoxDecoration(
        color: const Color(0xFF4058A0),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Row(
        children: [
          SizedBox(width: 32.w),
          _StatColumn(count: followers, label: context.l10n.profileFollowers),
          const Spacer(),
          _StatColumn(count: following, label: context.l10n.profileFollowing),
          SizedBox(width: 20.w),
        ],
      ),
    );
  }
}

class _StatColumn extends StatelessWidget {
  const _StatColumn({required this.count, required this.label});

  final String count;
  final String label;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            count,
            style: TextStyle(
              color: Colors.white,
              fontSize: 12.sp,
              fontWeight: FontWeight.w700,
              height: 1.2,
              fontFamily: FontFamily.montserrat,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              height: 1.25,
              fontFamily: FontFamily.montserrat,
            ),
          ),
        ],
      ),
    );
  }
}
