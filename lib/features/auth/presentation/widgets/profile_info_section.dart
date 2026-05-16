import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../common/widgets/foodify_components/foodify_button.dart';
import '../../../../core/gen/fonts.gen.dart';
import '../../../../l10n/l10n_extension.dart';

class ProfileInfoSection extends StatelessWidget {
  const ProfileInfoSection({
    super.key,
    this.name = 'Mark Salvador',
    this.location = 'New York, USA',
    this.bio =
        'To cook is to see how simple ingredients can create magic on the plate.',
    this.showEditButton = false,
  });

  final String name;
  final String location;
  final String bio;
  final bool showEditButton;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          name,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: const Color(0xFF0E0E0E),
            fontSize: 15.sp,
            fontWeight: FontWeight.w700,
            height: 1.2,
            fontFamily: FontFamily.montserrat,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          location,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: const Color(0xFF0E0E0E),
            fontSize: 12.sp,
            fontWeight: FontWeight.w400,
            height: 1.2,
            fontFamily: FontFamily.montserrat,
          ),
        ),
        SizedBox(height: 8.h),
        LayoutBuilder(
          builder: (context, constraints) {
            final availableWidth = constraints.maxWidth.isFinite
                ? constraints.maxWidth
                : MediaQuery.sizeOf(context).width;
            final bioWidth = (availableWidth - 48.w)
                .clamp(0.0, 277.w)
                .toDouble();

            return SizedBox(
              width: bioWidth,
              child: Text(
                bio,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: const Color(0xFF4058A0),
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w300,
                  height: 1.2,
                  fontFamily: FontFamily.montserrat,
                ),
              ),
            );
          },
        ),
        // Always reserve the edit-button slot so the tab bar stays at a fixed position
        SizedBox(
          height: 56.h, // 16px gap + 40px button
          child: showEditButton
              ? Padding(
                  padding: EdgeInsets.only(top: 16.h),
                  child: FoodifyButton(
                    text: context.l10n.profileEditAction,
                    onPressed: () {},
                    size: FoodifyButtonSize.small,
                    variant: FoodifyButtonVariant.stroke,
                  ),
                )
              : null,
        ),
      ],
    );
  }
}
