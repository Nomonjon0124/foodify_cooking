import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/gen/assets.gen.dart';
import '../../../../core/gen/fonts.gen.dart';
import '../../../../l10n/l10n_extension.dart';
import '../add_new_constants.dart';
import '../add_new_l10n.dart';
import '../cubit/add_new_cubit.dart';
import 'preview_header_card.dart';
import 'preview_tabs.dart';

class RecipePreviewStep extends StatelessWidget {
  const RecipePreviewStep({required this.onBack, super.key});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddNewCubit, AddNewState>(
      builder: (context, state) {
        return SingleChildScrollView(
          padding: EdgeInsets.only(bottom: 12.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PreviewHeaderCard(state: state, onBack: onBack),
              Padding(
                padding: EdgeInsets.fromLTRB(8.w, 8.h, 8.w, 0),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFEDEDED),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  padding: EdgeInsets.fromLTRB(12.w, 7.h, 12.w, 8.h),
                  child: Wrap(
                    spacing: 4.w,
                    runSpacing: 4.h,
                    children: [
                      _InfoPill(
                        icon: Assets.icons.foodifyComponents.trendDown.svg(
                          width: 12.r,
                          height: 12.r,
                          colorFilter: const ColorFilter.mode(
                            Color(0xFF4058A0),
                            BlendMode.srcIn,
                          ),
                        ),
                        label: _localizedHeadlineTag(context, state),
                      ),
                      _InfoPill(
                        icon: const Icon(
                          Icons.auto_awesome_outlined,
                          size: 12,
                          color: Color(0xFF4058A0),
                        ),
                        label: context.l10n.addNewDifficultyLabel(
                          state.difficulty,
                        ),
                      ),
                      _InfoPill(
                        icon: const Icon(
                          Icons.schedule_outlined,
                          size: 12,
                          color: Color(0xFF4058A0),
                        ),
                        label: state.cookTimeLabel,
                      ),
                      _InfoPill(
                        icon: const Icon(
                          Icons.favorite,
                          size: 12,
                          color: Color(0xFF4058A0),
                        ),
                        label: AddNewConstants.previewLikes,
                      ),
                      _InfoPill(
                        icon: const Icon(
                          Icons.chat_bubble_outline_rounded,
                          size: 12,
                          color: Color(0xFF4058A0),
                        ),
                        label: '${state.mockComments.length}',
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(8.w, 12.h, 8.w, 0),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF6FBF4),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  padding: EdgeInsets.fromLTRB(12.w, 8.h, 12.w, 16.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      PreviewTabs(
                        activeTab: state.previewTab,
                        onChanged: context.read<AddNewCubit>().setPreviewTab,
                      ),
                      SizedBox(height: 12.h),
                      Row(
                        children: [
                          const Icon(
                            Icons.arrow_drop_down,
                            color: Color(0xFFFF6339),
                          ),
                          Text(
                            _sectionHeadline(context, state),
                            style: TextStyle(
                              color: const Color(0xFF0E0E0E),
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w400,
                              fontFamily: FontFamily.montserrat,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.h),
                      ..._buildContent(context, state),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _sectionHeadline(BuildContext context, AddNewState state) {
    switch (state.previewTab) {
      case RecipePreviewTab.introduction:
        return context.l10n.addNewStepsCount(state.steps.length);
      case RecipePreviewTab.ingredients:
        return context.l10n.addNewIngredientsCount(state.ingredients.length);
      case RecipePreviewTab.comments:
        return context.l10n.addNewCommentsCount(state.mockComments.length);
    }
  }

  String _localizedHeadlineTag(BuildContext context, AddNewState state) {
    final l10n = context.l10n;
    if (state.tags.isNotEmpty) {
      return l10n.addNewDietaryTargetLabel(state.tags.first);
    }
    if (state.category.trim().isNotEmpty) {
      return l10n.addNewDishTypeLabel(state.category.trim());
    }
    return l10n.addNewHeadlineTagFallback;
  }

  List<Widget> _buildContent(BuildContext context, AddNewState state) {
    switch (state.previewTab) {
      case RecipePreviewTab.introduction:
        return List.generate(
          state.steps.length,
          (index) => _PreviewCard(
            index: index + 1,
            text: state.steps[index].trim().isEmpty
                ? context.l10n.addNewInstructionPlaceholder
                : state.steps[index].trim(),
            isHighlighted: index == state.steps.length - 1,
          ),
        );
      case RecipePreviewTab.ingredients:
        return List.generate(
          state.ingredients.length,
          (index) => _PreviewCard(
            index: index + 1,
            text: state.ingredients[index].trim().isEmpty
                ? context.l10n.addNewIngredientPlaceholder
                : state.ingredients[index].trim(),
          ),
        );
      case RecipePreviewTab.comments:
        return state.mockComments
            .map((comment) => _CommentCard(comment: comment))
            .toList();
    }
  }
}

class _InfoPill extends StatelessWidget {
  const _InfoPill({required this.icon, required this.label});

  final Widget icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 23.h,
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon,
          SizedBox(width: 4.w),
          Text(
            label,
            style: TextStyle(
              color: const Color(0xFF353535),
              fontSize: 11.sp,
              fontWeight: FontWeight.w400,
              fontFamily: FontFamily.montserrat,
            ),
          ),
        ],
      ),
    );
  }
}

class _PreviewCard extends StatelessWidget {
  const _PreviewCard({
    required this.index,
    required this.text,
    this.isHighlighted = false,
  });

  final int index;
  final String text;
  final bool isHighlighted;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.fromLTRB(36.w, 12.h, 16.w, 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Text(
            text,
            style: TextStyle(
              color: const Color(0xFF353535),
              fontSize: 12.sp,
              height: 1.25,
              fontWeight: isHighlighted ? FontWeight.w600 : FontWeight.w400,
              fontFamily: FontFamily.montserrat,
            ),
          ),
          Positioned(
            left: -36.w,
            top: -12.h,
            child: Container(
              width: 23.r,
              height: 23.r,
              decoration: BoxDecoration(
                color: const Color(0xFFFF6339),
                borderRadius: BorderRadius.circular(4.r),
              ),
              alignment: Alignment.center,
              child: Text(
                index.toString().padLeft(2, '0'),
                style: TextStyle(
                  color: const Color(0xFFF6FBF4),
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  fontFamily: FontFamily.montserrat,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CommentCard extends StatelessWidget {
  const _CommentCard({required this.comment});

  final AddNewComment comment;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.fromLTRB(36.w, 12.h, 14.w, 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Text(
            comment.message,
            style: TextStyle(
              color: const Color(0xFF353535),
              fontSize: 12.sp,
              height: 1.25,
              fontFamily: FontFamily.montserrat,
            ),
          ),
          Positioned(
            left: -36.w,
            top: -12.h,
            child: ClipOval(
              child: Image.asset(
                comment.avatarPath,
                width: 23.r,
                height: 23.r,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
