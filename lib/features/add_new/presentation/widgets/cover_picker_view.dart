import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/gen/assets.gen.dart';
import '../../../../core/gen/fonts.gen.dart';
import '../../../../l10n/l10n_extension.dart';
import '../add_new_constants.dart';
import '../cubit/add_new_cubit.dart';

class CoverPickerView extends StatelessWidget {
  const CoverPickerView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddNewCubit, AddNewState>(
      builder: (context, state) {
        final selectedPath = state.hasCover
            ? state.coverImagePath
            : AddNewConstants.mockImagePaths.first;

        return LayoutBuilder(
          builder: (context, constraints) {
            final availableWidth = constraints.maxWidth.isFinite
                ? constraints.maxWidth
                : MediaQuery.sizeOf(context).width;
            final availableHeight = constraints.maxHeight.isFinite
                ? constraints.maxHeight
                : MediaQuery.sizeOf(context).height;
            final horizontalPadding = 20.w;
            final previewWidth = (availableWidth - (horizontalPadding * 2))
                .clamp(0.0, 320.w)
                .toDouble();
            final maxPreviewHeight = (availableHeight * 0.52).clamp(
              190.h,
              411.h,
            );
            final previewHeight = (previewWidth * 1.28)
                .clamp(190.h, maxPreviewHeight)
                .toDouble();

            return Column(
              children: [
                SizedBox(height: 16.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  child: Text(
                    context.l10n.addNewCoverTitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: const Color(0xFF717171),
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w500,
                      height: 1.2,
                      fontFamily: FontFamily.montserrat,
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: Image.asset(
                    selectedPath,
                    width: previewWidth,
                    height: previewHeight,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 12.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  child: Row(
                    children: [
                      Flexible(
                        child: Text(
                          context.l10n.addNewRecent,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: const Color(0xFF0E0E0E),
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            fontFamily: FontFamily.montserrat,
                          ),
                        ),
                      ),
                      Icon(Icons.keyboard_arrow_down_rounded, size: 22.r),
                      const Spacer(),
                      _ToolbarIconButton(
                        tooltip: context.l10n.addNewGalleryAction,
                        icon: Assets.icons.foodifyComponents.documentCopy.svg(
                          width: 22.r,
                          height: 22.r,
                          colorFilter: const ColorFilter.mode(
                            Color(0xFF0E0E0E),
                            BlendMode.srcIn,
                          ),
                        ),
                        onTap: () {},
                      ),
                      SizedBox(width: 6.w),
                      _ToolbarIconButton(
                        tooltip: context.l10n.addNewCameraAction,
                        icon: Icon(Icons.camera_alt_outlined, size: 22.r),
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10.h),
                Expanded(
                  child: GridView.builder(
                    padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding,
                    ),
                    physics: const BouncingScrollPhysics(),
                    itemCount: AddNewConstants.mockImagePaths.length,
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 82.w,
                      crossAxisSpacing: 4.w,
                      mainAxisSpacing: 4.h,
                      childAspectRatio: 0.96,
                    ),
                    itemBuilder: (context, index) {
                      final imagePath = AddNewConstants.mockImagePaths[index];
                      final isSelected = imagePath == state.coverImagePath;

                      return GestureDetector(
                        key: Key('cover-picker-item-$index'),
                        onTap: () =>
                            context.read<AddNewCubit>().selectPhoto(imagePath),
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6.r),
                            border: isSelected
                                ? Border.all(
                                    color: const Color(0xFFDEE21B),
                                    width: 2.w,
                                  )
                                : null,
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(isSelected ? 1.r : 0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(6.r),
                              child: Image.asset(imagePath, fit: BoxFit.cover),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class _ToolbarIconButton extends StatelessWidget {
  const _ToolbarIconButton({
    required this.tooltip,
    required this.icon,
    required this.onTap,
  });

  final String tooltip;
  final Widget icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Semantics(
        button: true,
        label: tooltip,
        child: Material(
          color: Colors.white,
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: onTap,
            child: SizedBox(
              width: 44.r,
              height: 44.r,
              child: Center(child: icon),
            ),
          ),
        ),
      ),
    );
  }
}
