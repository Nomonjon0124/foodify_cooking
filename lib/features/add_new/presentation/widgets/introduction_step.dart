import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../l10n/l10n_extension.dart';
import '../cubit/add_new_cubit.dart';
import 'numbered_input_tile.dart';

class IntroductionStep extends StatelessWidget {
  const IntroductionStep({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddNewCubit, AddNewState>(
      builder: (context, state) {
        return ListView.builder(
          padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 0),
          itemCount: state.steps.length + 1,
          itemBuilder: (context, index) {
            if (index == state.steps.length) {
              return Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(top: 8.h),
                  child: GestureDetector(
                    key: const Key('add-step-button'),
                    onTap: context.read<AddNewCubit>().addStep,
                    child: Icon(
                      Icons.add_circle,
                      size: 32.r,
                      color: const Color(0xFFADADAD),
                    ),
                  ),
                ),
              );
            }

            return Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: NumberedInputTile(
                key: ValueKey('step-tile-$index'),
                index: index + 1,
                initialValue: state.steps[index],
                hintText: context.l10n.addNewHintInstruction,
                isMultiline: true,
                onChanged: (value) =>
                    context.read<AddNewCubit>().updateStep(index, value),
                onDelete: () => context.read<AddNewCubit>().removeStep(index),
              ),
            );
          },
        );
      },
    );
  }
}
