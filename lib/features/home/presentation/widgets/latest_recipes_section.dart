import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../common/widgets/recipe_cards/recipe_main_card.dart';
import '../../../../config/routes/route_names.dart';
import '../../../../l10n/l10n_extension.dart';
import '../../domain/entities/home_feed.dart';
import 'home_section_title.dart';

class LatestRecipesSection extends StatelessWidget {
  const LatestRecipesSection({
    super.key,
    required this.recipes,
    required this.onActionPressed,
  });

  final List<HomeRecipe> recipes;
  final ValueChanged<HomeRecipe> onActionPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const Key('home_latest_section'),
      margin: EdgeInsets.symmetric(horizontal: 6.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF6FBF4),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 4.w),
              child: HomeSectionTitle(context.l10n.homeLatestRecipes),
            ),
            SizedBox(height: 24.h),
            ...recipes.asMap().entries.expand((entry) {
              final recipe = entry.value;
              final author = recipe.author;

              return [
                Center(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () =>
                        context.push(RouteNames.recipeDetail(recipe.id)),
                    child: RecipeMainCard(
                      title: recipe.title,
                      authorName: author?.displayName ?? '',
                      description: recipe.description ?? '',
                      durationLabel: recipe.durationLabel ?? '',
                      difficultyLabel: recipe.difficultyLabel ?? '',
                      imagePath: recipe.coverImageUrl,
                      overlayImagePath: recipe.overlayImageUrl ?? '',
                      authorImagePath: author?.avatarUrl ?? '',
                      topRating: recipe.topRatingLabel,
                      authorRating: author?.ratingLabel ?? '0.0',
                      onActionPressed: () => onActionPressed(recipe),
                    ),
                  ),
                ),
                if (entry.key != recipes.length - 1) SizedBox(height: 12.h),
              ];
            }),
          ],
        ),
      ),
    );
  }
}
