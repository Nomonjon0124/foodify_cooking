import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodify_cooking/core/gen/fonts.gen.dart';

import '../../../../l10n/l10n_extension.dart';
import '../cubit/add_new_cubit.dart';

class InstructionsFormStep extends StatelessWidget {
  const InstructionsFormStep({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddNewCubit, AddNewState>(
      builder: (context, state) {
        return ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          itemCount: state.steps.length + 1,
          itemBuilder: (context, index) {
            if (index == state.steps.length) {
              return Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(top: 10.h),
                  child: GestureDetector(
                    onTap: () => context.read<AddNewCubit>().addStep(),
                    child: Container(
                      width: 32.r,
                      height: 32.r,
                      decoration: const BoxDecoration(
                        color: Color(0xFFADADAD),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.add, color: Colors.white, size: 24.r),
                    ),
                  ),
                ),
              );
            }

            return Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: _StepListItem(
                index: index + 1,
                onChanged: (val) =>
                    context.read<AddNewCubit>().updateStep(index, val),
                initialValue: state.steps[index],
                onDelete: () => context.read<AddNewCubit>().removeStep(index),
              ),
            );
          },
        );
      },
    );
  }
}

class _StepListItem extends StatelessWidget {
  const _StepListItem({
    required this.index,
    required this.onChanged,
    required this.initialValue,
    this.onDelete,
  });

  final int index;
  final ValueChanged<String> onChanged;
  final String initialValue;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          constraints: BoxConstraints(minHeight: 57.h),
          padding: EdgeInsets.fromLTRB(35.w, 12.h, 40.w, 12.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: TextField(
            onChanged: onChanged,
            controller: TextEditingController(
              text: initialValue,
            )..selection = TextSelection.collapsed(offset: initialValue.length),
            maxLines: null,
            style: TextStyle(
              color: const Color(0xFF353535),
              fontSize: 12.sp,
              fontFamily: FontFamily.montserrat,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              isDense: true,
              hintText: context.l10n.addNewHintInstruction,
            ),
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          child: Container(
            width: 25.r,
            height: 25.r,
            decoration: BoxDecoration(
              color: const Color(0xFFFF6339),
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: Center(
              child: Text(
                index.toString().padLeft(2, '0'),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  fontFamily: FontFamily.montserrat,
                ),
              ),
            ),
          ),
        ),
        Positioned(
          right: 10.w,
          bottom: 14.h,
          child: GestureDetector(
            onTap: onDelete,
            child: Icon(
              Icons.remove_circle,
              color: const Color(0xFFADADAD),
              size: 20.r,
            ),
          ),
        ),
      ],
    );
  }
}
