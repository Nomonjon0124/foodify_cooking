import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodify_cooking/core/gen/fonts.gen.dart';
import '../cubit/add_new_cubit.dart';

class CoverPreviewStep extends StatelessWidget {
  const CoverPreviewStep({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddNewCubit, AddNewState>(
      builder: (context, state) {
        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: state.coverImagePath.isEmpty
                    ? Container(
                        width: 296.w,
                        height: 210.h,
                        color: const Color(0xFFCBCBCB),
                        child: Icon(
                          Icons.image,
                          size: 60.r,
                          color: const Color(0xFF717171),
                        ),
                      )
                    : Image.network(
                        state.coverImagePath,
                        width: 296.w,
                        height: 210.h,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stack) => Container(
                          width: 296.w,
                          height: 210.h,
                          color: const Color(0xFFCBCBCB),
                        ),
                      ),
              ),
              SizedBox(height: 20.h),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => context.read<AddNewCubit>().editCrop(),
                      child: Container(
                        height: 40.h,
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFFADADAD)),
                          borderRadius: BorderRadius.circular(48.r),
                        ),
                        child: Center(
                          child: Text(
                            'Edit Crop',
                            style: TextStyle(
                              color: const Color(0xFFADADAD),
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                              fontFamily: FontFamily.montserrat,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 15.w),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => context.read<AddNewCubit>().removeCover(),
                      child: Container(
                        height: 40.h,
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFF353535)),
                          borderRadius: BorderRadius.circular(48.r),
                        ),
                        child: Center(
                          child: Text(
                            'Remove',
                            style: TextStyle(
                              color: const Color(0xFF353535),
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                              fontFamily: FontFamily.montserrat,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
