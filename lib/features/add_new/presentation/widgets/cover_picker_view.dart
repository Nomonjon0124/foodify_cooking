import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/gen/assets.gen.dart';
import '../../../../core/gen/fonts.gen.dart';
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

        return Column(
          children: [
            SizedBox(height: 20.h),
            Text(
              'Add a recipe Cover',
              style: TextStyle(
                color: const Color(0xFFADADAD),
                fontSize: 18.sp,
                fontWeight: FontWeight.w400,
                height: 1.2,
                fontFamily: FontFamily.montserrat,
              ),
            ),
            SizedBox(height: 10.h),
            ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: Image.asset(
                selectedPath,
                width: 320.w,
                height: 411.h,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 16.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Row(
                children: [
                  Text(
                    'Recent',
                    style: TextStyle(
                      color: const Color(0xFF0E0E0E),
                      fontSize: 14.sp,
                      fontFamily: FontFamily.montserrat,
                    ),
                  ),
                  Icon(Icons.keyboard_arrow_down_rounded, size: 22.r),
                  const Spacer(),
                  Assets.icons.foodifyComponents.documentCopy.svg(
                    width: 24.r,
                    height: 24.r,
                    colorFilter: const ColorFilter.mode(
                      Color(0xFF0E0E0E),
                      BlendMode.srcIn,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Icon(Icons.camera_alt_outlined, size: 24.r),
                ],
              ),
            ),
            SizedBox(height: 14.h),
            Expanded(
              child: GridView.builder(
                padding: EdgeInsets.zero,
                physics: const BouncingScrollPhysics(),
                itemCount: AddNewConstants.mockImagePaths.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
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
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6.r),
                        child: Image.asset(imagePath, fit: BoxFit.cover),
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
  }
}
