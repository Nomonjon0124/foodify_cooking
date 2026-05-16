import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/gen/fonts.gen.dart';
import '../../../../l10n/l10n_extension.dart';
import '../cubit/add_new_cubit.dart';

class CoverPreviewView extends StatelessWidget {
  const CoverPreviewView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddNewCubit, AddNewState>(
      builder: (context, state) {
        return SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(20.w, 56.h, 20.w, 12.h),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: Image.asset(
                  state.coverImagePath,
                  width: 296.w,
                  height: 210.h,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 44.h),
              Row(
                children: [
                  Expanded(
                    child: _SmallPillButton(
                      label: context.l10n.addNewEditCrop,
                      textColor: const Color(0xFFADADAD),
                      borderColor: const Color(0xFFADADAD),
                      onTap: context.read<AddNewCubit>().editCrop,
                    ),
                  ),
                  SizedBox(width: 15.w),
                  Expanded(
                    child: _SmallPillButton(
                      label: context.l10n.addNewRemove,
                      textColor: const Color(0xFF353535),
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
  }
}

class _SmallPillButton extends StatelessWidget {
  const _SmallPillButton({
    required this.label,
    required this.textColor,
    required this.borderColor,
    required this.onTap,
  });

  final String label;
  final Color textColor;
  final Color borderColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40.h,
        decoration: BoxDecoration(
          border: Border.all(color: borderColor),
          borderRadius: BorderRadius.circular(48.r),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: textColor,
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            fontFamily: FontFamily.montserrat,
          ),
        ),
      ),
    );
  }
}
