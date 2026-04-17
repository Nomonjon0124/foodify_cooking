import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../common/widgets/foodify_components/foodify_popular_card.dart';
import '../../../../core/gen/assets.gen.dart';

class SearchRecipesTab extends StatelessWidget {
  const SearchRecipesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.fromLTRB(19.w, 16.h, 21.w, 118.h),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 8.r,
        crossAxisSpacing: 8.r,
        childAspectRatio: 156 / 199,
      ),
      itemCount: _mockRecipes.length,
      itemBuilder: (context, index) {
        final recipe = _mockRecipes[index];
        return FoodifyPopularCard(
          title: recipe.title,
          rating: recipe.rating,
          imagePath: recipe.image.image(fit: BoxFit.cover),
        );
      },
    );
  }
}

class _RecipeSample {
  const _RecipeSample({
    required this.title,
    required this.rating,
    required this.image,
  });

  final String title;
  final String rating;
  final AssetGenImage image;
}

final _mockRecipes = [
  _RecipeSample(
    title: 'chocolate cake with buttercream frosting',
    rating: '4.8',
    image: Assets.images.foodifyComponents.popularCardCake,
  ),
  _RecipeSample(
    title: 'chocolate ice cream fruit smoothie',
    rating: '4.6',
    image: Assets.images.foodifyComponents.popularCardIcecream,
  ),
  _RecipeSample(
    title: 'Italian pineapple pizza',
    rating: '4.5',
    image: Assets.images.foodifyComponents.popularCardPizza,
  ),
  _RecipeSample(
    title: 'chocolate cake with buttercream frosting',
    rating: '4.8',
    image: Assets.images.foodifyComponents.popularCardCake,
  ),
  _RecipeSample(
    title: 'chocolate ice cream fruit smoothie',
    rating: '4.7',
    image: Assets.images.foodifyComponents.popularCardIcecream,
  ),
  _RecipeSample(
    title: 'Italian pineapple pizza',
    rating: '4.9',
    image: Assets.images.foodifyComponents.popularCardPizza,
  ),
];
