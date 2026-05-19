import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/routes/route_names.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/gen/fonts.gen.dart';
import '../../../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../../../features/auth/presentation/cubit/auth_state.dart';
import '../../../../features/auth/presentation/widgets/auth_required_prompt.dart';
import '../../../../l10n/l10n_extension.dart';
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
    if (getIt.isRegistered<AuthCubit>()) {
      return BlocBuilder<AuthCubit, AuthState>(
        bloc: getIt<AuthCubit>(),
        builder: (context, authState) {
          if (!authState.isAuthenticated) {
            return Scaffold(
              backgroundColor: Colors.white,
              body: Center(
                child: Padding(
                  padding: EdgeInsets.all(20.r),
                  child: AuthRequiredPrompt(
                    onGooglePressed: () {
                      getIt<AuthCubit>().signInWithGoogle(
                        returnTo: RouteNames.addNew,
                      );
                    },
                    onEmailPressed: () {
                      context.push(loginRouteForReturnTo(RouteNames.addNew));
                    },
                  ),
                ),
              ),
            );
          }
          return const _AddNewFlow();
        },
      );
    }

    return const _AddNewFlow();
  }
}

class _AddNewFlow extends StatelessWidget {
  const _AddNewFlow();

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
          final resizesForKeyboard = state.phase == AddNewPhase.formSteps;

          if (state.phase == AddNewPhase.cropPhoto) {
            return Scaffold(
              backgroundColor: Colors.black,
              resizeToAvoidBottomInset: false,
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
              state.phase == AddNewPhase.formSteps ||
              state.phase == AddNewPhase.recipePreview;
          final displayedStep = state.phase == AddNewPhase.recipePreview
              ? 3
              : _clampedStepperStep(state.currentStep);

          return Scaffold(
            resizeToAvoidBottomInset: resizesForKeyboard,
            body: AddNewFlowScaffold(
              backgroundColor: state.phase == AddNewPhase.recipePreview
                  ? Colors.white
                  : const Color(0xFFF6FBF4),
              header: state.phase == AddNewPhase.recipePreview
                  ? const SizedBox.shrink()
                  : _buildHeader(context, state),
              body: Column(
                children: [
                  if (showsStepper) AddNewStepper(currentStep: displayedStep),
                  Expanded(
                    child: _AnimatedAddNewBody(
                      state: state,
                      child: _buildBody(context, state),
                    ),
                  ),
                ],
              ),
              bottomBar: state.phase == AddNewPhase.photoPicker
                  ? null
                  : StepActionBar(
                      label: context.l10n.addNewNext,
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
      title: context.l10n.addNewTitle,
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
                context.l10n.addNewClearAll,
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

int _clampedStepperStep(int step) {
  if (step < 0) return 0;
  if (step > 3) return 3;
  return step;
}

class _AnimatedAddNewBody extends StatefulWidget {
  const _AnimatedAddNewBody({required this.state, required this.child});

  final AddNewState state;
  final Widget child;

  @override
  State<_AnimatedAddNewBody> createState() => _AnimatedAddNewBodyState();
}

class _AnimatedAddNewBodyState extends State<_AnimatedAddNewBody> {
  int _direction = 1;

  @override
  void didUpdateWidget(covariant _AnimatedAddNewBody oldWidget) {
    super.didUpdateWidget(oldWidget);

    final previousOrder = _bodyOrder(oldWidget.state);
    final nextOrder = _bodyOrder(widget.state);
    if (previousOrder != nextOrder) {
      _direction = nextOrder > previousOrder ? 1 : -1;
    }
  }

  @override
  Widget build(BuildContext context) {
    final activeKey = ValueKey<String>(_bodyKey(widget.state));

    return ClipRect(
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 220),
        switchInCurve: Curves.easeOutCubic,
        switchOutCurve: Curves.easeInCubic,
        layoutBuilder: (currentChild, previousChildren) {
          return Stack(
            fit: StackFit.expand,
            children: [...previousChildren, ?currentChild],
          );
        },
        transitionBuilder: (child, animation) {
          final isIncoming = child.key == activeKey;
          final beginOffset = Offset(
            (isIncoming ? _direction : -_direction) * 0.06,
            0,
          );
          final position = animation.drive(
            Tween<Offset>(
              begin: beginOffset,
              end: Offset.zero,
            ).chain(CurveTween(curve: Curves.easeOutCubic)),
          );

          return FadeTransition(
            opacity: animation,
            child: SlideTransition(position: position, child: child),
          );
        },
        child: KeyedSubtree(key: activeKey, child: widget.child),
      ),
    );
  }

  int _bodyOrder(AddNewState state) {
    return switch (state.phase) {
      AddNewPhase.photoPicker => 0,
      AddNewPhase.cropPhoto => 1,
      AddNewPhase.coverPreview => 2,
      AddNewPhase.formSteps => 3 + _clampedStepperStep(state.currentStep),
      AddNewPhase.recipePreview => 6,
    };
  }

  String _bodyKey(AddNewState state) {
    return switch (state.phase) {
      AddNewPhase.formSteps => 'form-${_clampedStepperStep(state.currentStep)}',
      _ => state.phase.name,
    };
  }
}
