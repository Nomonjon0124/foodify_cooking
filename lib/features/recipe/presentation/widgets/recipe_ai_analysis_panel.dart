import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/gen/fonts.gen.dart';
import '../../../../features/settings/presentation/cubit/settings_cubit.dart';
import '../../../../features/settings/presentation/cubit/settings_state.dart';
import '../../../../l10n/l10n_extension.dart';
import '../../domain/entities/recipe_analysis.dart';
import '../cubit/recipe_analysis_cubit.dart';
import '../cubit/recipe_analysis_state.dart';

class RecipeAiAnalysisPanel extends StatefulWidget {
  const RecipeAiAnalysisPanel({required this.recipeId, super.key});

  final String recipeId;

  @override
  State<RecipeAiAnalysisPanel> createState() => _RecipeAiAnalysisPanelState();
}

class _RecipeAiAnalysisPanelState extends State<RecipeAiAnalysisPanel> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _trigger());
  }

  void _trigger() {
    if (!mounted) return;
    final locale = context.read<SettingsCubit>().state.languageCode ??
        SettingsCubit.defaultLanguageCode;
    context.read<RecipeAnalysisCubit>().loadIfNeeded(
      recipeId: widget.recipeId,
      locale: locale,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SettingsCubit, SettingsState>(
      listenWhen: (prev, curr) => prev.languageCode != curr.languageCode,
      listener: (_, _) => _trigger(),
      child: BlocBuilder<RecipeAnalysisCubit, RecipeAnalysisState>(
        builder: (context, state) {
          switch (state.status) {
            case RecipeAnalysisStatus.initial:
            case RecipeAnalysisStatus.loading:
              return _LoadingCard();
            case RecipeAnalysisStatus.failure:
              return _ErrorCard(
                message: state.errorMessage ?? '',
                onRetry: () => context.read<RecipeAnalysisCubit>().retry(),
              );
            case RecipeAnalysisStatus.success:
              final analysis = state.analysis;
              if (analysis == null) return const SizedBox.shrink();
              return _SuccessCard(analysis: analysis);
          }
        },
      ),
    );
  }
}

class _LoadingCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _PanelShell(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 24.h),
        child: Row(
          children: [
            SizedBox(
              width: 18.sp,
              height: 18.sp,
              child: const CircularProgressIndicator(strokeWidth: 2),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                context.l10n.recipeAiAnalysisLoading,
                style: _bodyStyle(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorCard extends StatelessWidget {
  const _ErrorCard({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return _PanelShell(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.recipeAiAnalysisError(message),
              style: _bodyStyle(context).copyWith(color: const Color(0xFFFF6339)),
            ),
            SizedBox(height: 12.h),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: onRetry,
                child: Text(context.l10n.recipeAiAnalysisRetry),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SuccessCard extends StatelessWidget {
  const _SuccessCard({required this.analysis});

  final RecipeAnalysis analysis;

  @override
  Widget build(BuildContext context) {
    final disclaimer = analysis.disclaimer.trim().isEmpty
        ? context.l10n.recipeAiAnalysisDisclaimerFallback
        : analysis.disclaimer;
    return _PanelShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 12.h),
          _ScoreGauge(score: analysis.healthScore),
          SizedBox(height: 12.h),
          Text(analysis.healthSummary, style: _bodyStyle(context)),
          SizedBox(height: 16.h),
          Text(
            context.l10n.recipeAiAnalysisNutritionTitle,
            style: _headerStyle(context),
          ),
          SizedBox(height: 8.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: [
              _NutritionChip(
                label: context.l10n.recipeAiAnalysisKcal(
                  analysis.nutrition.kcal.round(),
                ),
              ),
              _NutritionChip(
                label: context.l10n.recipeAiAnalysisProtein(
                  analysis.nutrition.proteinG.round(),
                ),
              ),
              _NutritionChip(
                label: context.l10n.recipeAiAnalysisCarbs(
                  analysis.nutrition.carbsG.round(),
                ),
              ),
              _NutritionChip(
                label: context.l10n.recipeAiAnalysisFat(
                  analysis.nutrition.fatG.round(),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Text(
            disclaimer,
            style: TextStyle(
              fontFamily: FontFamily.montserrat,
              fontSize: 11.sp,
              color: const Color(0xFFADADAD),
              fontStyle: FontStyle.italic,
              height: 1.3,
            ),
          ),
          SizedBox(height: 8.h),
        ],
      ),
    );
  }
}

class _ScoreGauge extends StatelessWidget {
  const _ScoreGauge({required this.score});

  final int score;

  @override
  Widget build(BuildContext context) {
    final clamped = score.clamp(0, 100);
    final fraction = clamped / 100.0;
    final color = clamped >= 70
        ? const Color(0xFF05B5BF)
        : clamped >= 40
            ? const Color(0xFFDEE21B)
            : const Color(0xFFFF6339);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 48.sp,
          height: 48.sp,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 48.sp,
                height: 48.sp,
                child: CircularProgressIndicator(
                  value: fraction,
                  strokeWidth: 4,
                  backgroundColor: const Color(0xFFEDEDED),
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                ),
              ),
              Text(
                '$clamped',
                style: TextStyle(
                  fontFamily: FontFamily.montserrat,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF0E0E0E),
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 12.w),
        Text(
          context.l10n.recipeAiAnalysisHealthScore,
          style: _headerStyle(context),
        ),
      ],
    );
  }
}

class _NutritionChip extends StatelessWidget {
  const _NutritionChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF6FBF4),
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(color: const Color(0xFFEDEDED)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: FontFamily.montserrat,
          fontSize: 12.sp,
          fontWeight: FontWeight.w500,
          color: const Color(0xFF0E0E0E),
        ),
      ),
    );
  }
}

class _PanelShell extends StatelessWidget {
  const _PanelShell({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: const Color(0xFFEDEDED)),
      ),
      child: child,
    );
  }
}

TextStyle _bodyStyle(BuildContext context) => TextStyle(
      fontFamily: FontFamily.montserrat,
      fontSize: 13.sp,
      color: const Color(0xFF0E0E0E),
      height: 1.4,
    );

TextStyle _headerStyle(BuildContext context) => TextStyle(
      fontFamily: FontFamily.montserrat,
      fontSize: 14.sp,
      fontWeight: FontWeight.w600,
      color: const Color(0xFF0E0E0E),
    );
