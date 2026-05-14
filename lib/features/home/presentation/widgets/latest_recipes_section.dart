import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../common/widgets/recipe_cards/recipe_main_card.dart';
import '../data/home_sample_data.dart';
import 'home_section_title.dart';

class LatestRecipesSection extends StatelessWidget {
  const LatestRecipesSection({super.key, required this.onActionPressed});

  final VoidCallback onActionPressed;

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
              child: const HomeSectionTitle('The Latest Recipes'),
            ),
            SizedBox(height: 24.h),
            ...latestRecipes.expand(
              (recipe) => [
                Center(
                  child: RecipeMainCard(
                    title: recipe.title,
                    authorName: recipe.authorName,
                    description: recipe.description,
                    durationLabel: recipe.durationLabel,
                    difficultyLabel: recipe.difficultyLabel,
                    imagePath: recipe.imagePath,
                    overlayImagePath: recipe.overlayImagePath,
                    authorImagePath: recipe.authorImagePath,
                    topRating: recipe.topRating,
                    authorRating: recipe.authorRating,
                    onActionPressed: onActionPressed,
                  ),
                ),
                if (recipe != latestRecipes.last) SizedBox(height: 12.h),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
