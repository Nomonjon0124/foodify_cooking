import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/routes/route_names.dart';
import '../../../../core/gen/fonts.gen.dart';
import '../cubit/add_new_cubit.dart';
import '../widgets/add_new_flow_scaffold.dart';
import '../widgets/add_new_header.dart';
import '../widgets/add_new_stepper.dart';
import '../widgets/cover_picker_view.dart';
import '../widgets/cover_preview_view.dart';
import '../widgets/crop_photo_view.dart';
import '../widgets/ingredients_step.dart';
import '../widgets/introduction_step.dart';
import '../widgets/recipe_info_step.dart';
import '../widgets/recipe_preview_step.dart';
import '../widgets/step_action_bar.dart';
import '../widgets/submit_success_sheet.dart';

class AddNewPage extends StatelessWidget {
  const AddNewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AddNewCubit(),
      child: BlocConsumer<AddNewCubit, AddNewState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (context, state) async {
          if (state.isSubmitSuccess) {
            await showModalBottomSheet<void>(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.white,
              builder: (context) {
                return SubmitSuccessSheet(
                  onCreateAnother: () => Navigator.of(context).pop(),
                );
              },
            );
            if (context.mounted) {
              context.read<AddNewCubit>().clearDraft();
            }
          }
        },
        builder: (context, state) {
          if (state.phase == AddNewPhase.cropPhoto) {
            return Scaffold(
              backgroundColor: Colors.black,
              body: CropPhotoView(
                imagePath: state.coverImagePath,
                quarterTurns: state.cropQuarterTurns,
                onCancel: context.read<AddNewCubit>().cancelCrop,
                onDone: context.read<AddNewCubit>().confirmCrop,
                onRotate: context.read<AddNewCubit>().rotateCrop,
              ),
            );
          }

          final cubit = context.read<AddNewCubit>();
          final showsStepper =
              state.phase == AddNewPhase.coverPreview ||
              state.phase == AddNewPhase.formSteps;

          return Scaffold(
            resizeToAvoidBottomInset: false,
            body: AddNewFlowScaffold(
              backgroundColor: state.phase == AddNewPhase.recipePreview
                  ? Colors.white
                  : const Color(0xFFF6FBF4),
              header: state.phase == AddNewPhase.recipePreview
                  ? const SizedBox.shrink()
                  : _buildHeader(context, state),
              body: Column(
                children: [
                  if (showsStepper)
                    AddNewStepper(
                      currentStep: state.currentStep < 0
                          ? 0
                          : state.currentStep > 3
                          ? 3
                          : state.currentStep,
                    ),
                  Expanded(child: _buildBody(context, state)),
                ],
              ),
              bottomBar: state.phase == AddNewPhase.photoPicker
                  ? null
                  : StepActionBar(
                      label: 'Next',
                      isEnabled: cubit.canContinueCurrentStage(),
                      isLoading: state.isSubmitting,
                      onPressed: cubit.nextStage,
                    ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AddNewState state) {
    final cubit = context.read<AddNewCubit>();

    return AddNewHeader(
      title: 'New Recipe',
      leading: IconButton(
        key: const Key('add-new-back-button'),
        padding: EdgeInsets.zero,
        onPressed: () {
          final handled = cubit.handleBack();
          if (!handled) {
            context.go(RouteNames.home);
          }
        },
        icon: Icon(Icons.chevron_left_rounded, color: Colors.white, size: 28.r),
      ),
      trailing: state.phase == AddNewPhase.coverPreview
          ? null
          : TextButton(
              key: const Key('add-new-clear-all-button'),
              onPressed: cubit.clearDraft,
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                padding: EdgeInsets.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                'Clear all',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  fontFamily: FontFamily.montserrat,
                ),
              ),
            ),
    );
  }

  Widget _buildBody(BuildContext context, AddNewState state) {
    switch (state.phase) {
      case AddNewPhase.photoPicker:
        return const CoverPickerView();
      case AddNewPhase.cropPhoto:
        return const SizedBox.shrink();
      case AddNewPhase.coverPreview:
        return const CoverPreviewView();
      case AddNewPhase.formSteps:
        switch (state.currentStep) {
          case 0:
            return const RecipeInfoStep();
          case 1:
            return const IngredientsStep();
          case 2:
            return const IntroductionStep();
          default:
            return const RecipeInfoStep();
        }
      case AddNewPhase.recipePreview:
        return RecipePreviewStep(
          onBack: context.read<AddNewCubit>().handleBack,
        );
    }
  }
}
