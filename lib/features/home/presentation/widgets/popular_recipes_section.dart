import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../common/widgets/foodify_image.dart';
import '../../../../common/widgets/foodify_components/foodify_popular_card.dart';
import '../../../../l10n/l10n_extension.dart';
import '../../domain/entities/home_feed.dart';
import 'home_section_title.dart';

class PopularRecipesSection extends StatefulWidget {
  const PopularRecipesSection({
    required this.recipes,
    required this.savedRecipeIds,
    required this.onSavePressed,
    super.key,
  });

  final List<HomeRecipe> recipes;
  final Set<String> savedRecipeIds;
  final ValueChanged<HomeRecipe> onSavePressed;

  @override
  State<PopularRecipesSection> createState() => _PopularRecipesSectionState();
}

class _PopularRecipesSectionState extends State<PopularRecipesSection> {
  late final ScrollController _scrollController = ScrollController(
    initialScrollOffset: 62,
  );

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const Key('home_popular_section'),
      color: const Color(0xFFF6FBF4),
      child: Padding(
        padding: EdgeInsets.only(bottom: 22.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 24.w, top: 14.h),
              child: HomeSectionTitle(context.l10n.homePopularRecipes),
            ),
            SizedBox(height: 24.h),
            SizedBox(
              height: 199.r,
              child: ListView.separated(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.only(left: 0, right: 20.w),
                physics: const BouncingScrollPhysics(),
                itemCount: widget.recipes.length,
                separatorBuilder: (_, _) => SizedBox(width: 8.w),
                itemBuilder: (context, index) {
                  final recipe = widget.recipes[index];
                  return FoodifyPopularCard(
                    title: recipe.title,
                    rating: recipe.topRatingLabel,
                    imagePath: FoodifyImage(
                      recipe.coverImageUrl,
                      fit: BoxFit.cover,
                    ),
                    state: widget.savedRecipeIds.contains(recipe.id)
                        ? FoodifyPopularCardState.saved
                        : FoodifyPopularCardState.toBeSaved,
                    onSavePressed: () => widget.onSavePressed(recipe),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
