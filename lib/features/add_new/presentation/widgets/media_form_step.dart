import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodify_cooking/core/gen/fonts.gen.dart';

import '../cubit/add_new_cubit.dart';

class MediaPickerView extends StatelessWidget {
  const MediaPickerView({super.key, this.selectedImagePath = ''});

  final String selectedImagePath;

  static const _placeholderImages = [
    'https://picsum.photos/200/200?random=1',
    'https://picsum.photos/200/200?random=2',
    'https://picsum.photos/200/200?random=3',
    'https://picsum.photos/200/200?random=4',
    'https://picsum.photos/200/200?random=5',
    'https://picsum.photos/200/200?random=6',
    'https://picsum.photos/200/200?random=7',
    'https://picsum.photos/200/200?random=8',
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddNewCubit, AddNewState>(
      builder: (context, state) {
        final previewUrl = state.coverImagePath.isEmpty
            ? _placeholderImages[0]
            : state.coverImagePath;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
              child: Center(
                child: Text(
                  'Add a recipe Cover',
                  style: TextStyle(
                    color: const Color(0xFFADADAD),
                    fontSize: 18.sp,
                    fontFamily: FontFamily.montserrat,
                  ),
                ),
              ),
            ),
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.r),
                child: Image.network(
                  previewUrl,
                  width: 320.w,
                  height: 411.h,
                  fit: BoxFit.cover,
                  errorBuilder: (ctx, error, stack) => Container(
                    width: 320.w,
                    height: 411.h,
                    color: const Color(0xFF2A2A2A),
                    child: Icon(
                      Icons.image_outlined,
                      color: const Color(0xFF717171),
                      size: 48.r,
                    ),
                  ),
                ),
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
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      fontFamily: FontFamily.montserrat,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.white,
                    size: 20.r,
                  ),
                  const Spacer(),
                  Icon(Icons.copy_outlined, color: Colors.white, size: 22.r),
                  SizedBox(width: 14.w),
                  Icon(
                    Icons.camera_alt_outlined,
                    color: Colors.white,
                    size: 22.r,
                  ),
                ],
              ),
            ),
            SizedBox(height: 12.h),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 2.w),
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 2.w,
                    mainAxisSpacing: 2.h,
                  ),
                  itemCount: _placeholderImages.length,
                  itemBuilder: (context, index) {
                    final url = _placeholderImages[index];
                    return GestureDetector(
                      onTap: () => context.read<AddNewCubit>().selectPhoto(url),
                      child: Image.network(
                        url,
                        fit: BoxFit.cover,
                        errorBuilder: (ctx, error, stack) =>
                            Container(color: const Color(0xFF2A2A2A)),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
