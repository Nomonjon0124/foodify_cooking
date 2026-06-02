import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/gen/fonts.gen.dart';
import '../../../../l10n/l10n_extension.dart';
import '../cubit/add_new_cubit.dart';
import 'add_new_cover_image.dart';

class CoverPreviewView extends StatelessWidget {
  const CoverPreviewView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddNewCubit, AddNewState>(
      builder: (context, state) {
        return LayoutBuilder(
          builder: (context, constraints) {
            final availableWidth = constraints.maxWidth.isFinite
                ? constraints.maxWidth
                : MediaQuery.sizeOf(context).width;
            final availableHeight = constraints.maxHeight.isFinite
                ? constraints.maxHeight
                : MediaQuery.sizeOf(context).height;
            final horizontalPadding = 20.w;
            final imageWidth = (availableWidth - (horizontalPadding * 2))
                .clamp(0.0, 320.w)
                .toDouble();
            final imageHeight = (imageWidth * 210 / 296)
                .clamp(168.h, availableHeight * 0.42)
                .toDouble();

            return SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                40.h,
                horizontalPadding,
                12.h,
              ),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
                    child: AddNewCoverImage(
                      source: state.coverImagePath,
                      bytes: state.coverImageBytes,
                      width: imageWidth,
                      height: imageHeight,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: 28.h),
                  Row(
                    children: [
                      Expanded(
                        child: _SmallPillButton(
                          label: context.l10n.addNewEditCrop,
                          textColor: const Color(0xFF353535),
                          backgroundColor: Colors.white,
                          borderColor: const Color(0xFFADADAD),
                          onTap: context.read<AddNewCubit>().editCrop,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: _SmallPillButton(
                          label: context.l10n.addNewRemove,
                          textColor: Colors.white,
                          backgroundColor: const Color(0xFF353535),
                          borderColor: const Color(0xFF353535),
                          onTap: context.read<AddNewCubit>().removeCover,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _SmallPillButton extends StatelessWidget {
  const _SmallPillButton({
    required this.label,
    required this.textColor,
    required this.backgroundColor,
    required this.borderColor,
    required this.onTap,
  });

  final String label;
  final Color textColor;
  final Color backgroundColor;
  final Color borderColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(48.r),
      child: InkWell(
        borderRadius: BorderRadius.circular(48.r),
        onTap: onTap,
        child: Container(
          constraints: BoxConstraints(minHeight: 44.r),
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
          decoration: BoxDecoration(
            border: Border.all(color: borderColor),
            borderRadius: BorderRadius.circular(48.r),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: textColor,
              fontSize: 15.sp,
              fontWeight: FontWeight.w600,
              fontFamily: FontFamily.montserrat,
            ),
          ),
        ),
      ),
    );
  }
}
