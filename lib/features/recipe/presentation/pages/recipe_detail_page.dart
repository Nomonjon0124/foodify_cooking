import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../common/widgets/app_error_widget.dart';
import '../../../../common/widgets/app_loader.dart';
import '../../../../common/widgets/app_snackbar.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/gen/assets.gen.dart';
import '../../../../core/gen/fonts.gen.dart';
import '../../../../l10n/l10n_extension.dart';
import '../../domain/entities/recipe_detail.dart';
import '../cubit/recipe_analysis_cubit.dart';
import '../cubit/recipe_detail_cubit.dart';
import '../cubit/recipe_detail_state.dart';
import '../widgets/recipe_ai_analysis_panel.dart';
import '../widgets/recipe_detail_author_pill.dart';
import '../widgets/recipe_detail_hero.dart';
import '../widgets/recipe_detail_rows.dart';
import '../widgets/recipe_detail_tab_bar.dart';
import '../widgets/recipe_info_chip.dart';

class RecipeDetailPage extends StatelessWidget {
  const RecipeDetailPage({required this.recipeId, super.key});

  final String recipeId;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<RecipeDetailCubit>(
          create: (_) => getIt<RecipeDetailCubit>()..load(recipeId),
        ),
        BlocProvider<RecipeAnalysisCubit>(
          create: (_) => getIt<RecipeAnalysisCubit>(),
        ),
      ],
      child: _RecipeDetailView(recipeId: recipeId),
    );
  }
}

class _RecipeDetailView extends StatelessWidget {
  const _RecipeDetailView({required this.recipeId});

  final String recipeId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6FBF4),
      body: BlocConsumer<RecipeDetailCubit, RecipeDetailState>(
        listenWhen: (previous, current) =>
            previous.errorMessage != current.errorMessage &&
            current.errorMessage != null,
        listener: (context, state) {
          final message = state.errorMessage;
          if (message != null) AppSnackbar.show(context, message);
        },
        builder: (context, state) {
          if (state.status == RecipeDetailStatus.loading ||
              state.status == RecipeDetailStatus.initial) {
            return const AppLoader();
          }
          if (state.status == RecipeDetailStatus.failure &&
              state.recipe == null) {
            return AppErrorWidget(
              message: state.errorMessage ?? context.l10n.recipeDetailLoadFailure,
            );
          }
          final recipe = state.recipe;
          if (recipe == null) return const SizedBox.shrink();
          return _RecipeDetailContent(
            state: state,
            recipe: recipe,
            recipeId: recipeId,
          );
        },
      ),
    );
  }
}

class _RecipeDetailContent extends StatelessWidget {
  const _RecipeDetailContent({
    required this.state,
    required this.recipe,
    required this.recipeId,
  });

  final RecipeDetailState state;
  final RecipeDetail recipe;
  final String recipeId;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<RecipeDetailCubit>();
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: RecipeDetailHero(
            coverImageUrl: recipe.coverImageUrl,
            ratingLabel: recipe.ratingLabel,
            isSaved: recipe.isSavedByMe,
            isLiked: recipe.isLikedByMe,
            isLikeInFlight: state.isLikeInFlight,
            onSavePressed: cubit.toggleSave,
            onLikePressed: cubit.toggleLike,
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.only(top: 16.h),
            child: RecipeDetailAuthorPill(author: recipe.author),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(8.w, 12.h, 8.w, 0),
            child: _TitleBanner(title: recipe.title),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(8.w, 8.h, 8.w, 0),
            child: _ChipsCard(recipe: recipe),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(8.w, 16.h, 8.w, 12.h),
            child: RecipeDetailTabBar(
              activeTab: state.activeTab,
              labels: {
                RecipeDetailTab.introduction:
                    context.l10n.recipeDetailTabIntroduction,
                RecipeDetailTab.ingredients:
                    context.l10n.recipeDetailTabIngredients,
                RecipeDetailTab.comments: context.l10n.recipeDetailTabComments,
                RecipeDetailTab.aiAnalysis:
                    context.l10n.recipeDetailTabAiAnalysis,
              },
              onTabSelected: cubit.changeTab,
            ),
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 24.h),
          sliver: _TabBody(
            activeTab: state.activeTab,
            recipe: recipe,
            recipeId: recipeId,
          ),
        ),
      ],
    );
  }
}

class _TitleBanner extends StatelessWidget {
  const _TitleBanner({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: const Color(0xFF4058A0),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Text(
        title,
        style: TextStyle(
          fontFamily: FontFamily.montserrat,
          color: Colors.white,
          fontSize: 18.sp,
          fontWeight: FontWeight.w400,
          height: 1.2,
        ),
      ),
    );
  }
}

class _ChipsCard extends StatelessWidget {
  const _ChipsCard({required this.recipe});

  final RecipeDetail recipe;

  @override
  Widget build(BuildContext context) {
    final trendDown = Assets.icons.foodifyComponents.trendDown.svg(
      width: 12.w,
      height: 12.h,
    );

    final chips = <Widget>[
      for (final tag in recipe.tags)
        RecipeInfoChip(label: tag.displayName, icon: trendDown),
      if (recipe.difficultyLabel != null)
        RecipeInfoChip(label: recipe.difficultyLabel!, icon: trendDown),
      if (recipe.durationLabel != null)
        RecipeInfoChip(label: recipe.durationLabel!, icon: trendDown),
      RecipeInfoChip(
        label: recipe.likesCount.toString(),
        icon: Icon(
          Icons.favorite,
          size: 12.sp,
          color: const Color(0xFFFF6339),
        ),
      ),
      RecipeInfoChip(
        label: recipe.commentsCount.toString(),
        icon: const Icon(Icons.mode_comment_outlined),
      ),
    ];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: const Color(0xFFEDEDED),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Wrap(spacing: 8.w, runSpacing: 8.h, children: chips),
    );
  }
}

class _TabBody extends StatelessWidget {
  const _TabBody({
    required this.activeTab,
    required this.recipe,
    required this.recipeId,
  });

  final RecipeDetailTab activeTab;
  final RecipeDetail recipe;
  final String recipeId;

  @override
  Widget build(BuildContext context) {
    switch (activeTab) {
      case RecipeDetailTab.introduction:
        return SliverList.list(
          children: [
            _SectionHeader(
              label: context.l10n.recipeDetailStepsCount(
                recipe.instructions.length,
              ),
            ),
            for (final step in recipe.instructions)
              RecipeNumberedRow(number: step.stepNumber, content: step.content),
          ],
        );
      case RecipeDetailTab.ingredients:
        return SliverList.list(
          children: [
            _SectionHeader(
              label: context.l10n.recipeDetailIngredientsCount(
                recipe.ingredients.length,
              ),
            ),
            for (final ingredient in recipe.ingredients)
              RecipeNumberedRow(
                number: ingredient.position,
                content: ingredient.content,
                isBold: true,
              ),
          ],
        );
      case RecipeDetailTab.comments:
        return SliverList.list(
          children: [
            _SectionHeader(
              label: context.l10n.recipeDetailCommentsCount(
                recipe.comments.length,
              ),
            ),
            if (recipe.comments.isEmpty)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.h),
                child: Text(
                  context.l10n.recipeDetailCommentsEmpty,
                  style: TextStyle(
                    fontFamily: FontFamily.montserrat,
                    fontSize: 12.sp,
                    color: const Color(0xFFADADAD),
                  ),
                ),
              ),
            for (final comment in recipe.comments)
              RecipeCommentRow(
                authorName: comment.authorName,
                authorAvatarUrl: comment.authorAvatarUrl,
                content: comment.content,
              ),
          ],
        );
      case RecipeDetailTab.aiAnalysis:
        return SliverToBoxAdapter(
          child: RecipeAiAnalysisPanel(recipeId: recipeId),
        );
    }
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        children: [
          Icon(Icons.keyboard_arrow_down, color: const Color(0xFFFF6339), size: 24.sp),
          SizedBox(width: 4.w),
          Text(
            label,
            style: TextStyle(
              fontFamily: FontFamily.montserrat,
              fontSize: 18.sp,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF0E0E0E),
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}
