import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../common/widgets/foodify_image.dart';
import '../../../../common/widgets/foodify_components/foodify_popular_card.dart';
import '../../domain/entities/search_results.dart';

class SearchRecipesTab extends StatelessWidget {
  const SearchRecipesTab({super.key, required this.recipes});

  final List<SearchRecipe> recipes;

  @override
  Widget build(BuildContext context) {
    if (recipes.isEmpty) {
      return const Center(child: Text('No recipes found'));
    }

    return GridView.builder(
      padding: EdgeInsets.fromLTRB(19.w, 16.h, 21.w, 118.h),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 8.r,
        crossAxisSpacing: 8.r,
        childAspectRatio: 156 / 199,
      ),
      itemCount: recipes.length,
      itemBuilder: (context, index) {
        final recipe = recipes[index];
        return FoodifyPopularCard(
          title: recipe.title,
          rating: recipe.ratingLabel,
          imagePath: FoodifyImage(recipe.imageUrl, fit: BoxFit.cover),
        );
      },
    );
  }
}
