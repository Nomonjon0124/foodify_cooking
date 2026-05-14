import 'package:flutter/material.dart';
import '../../domain/entities/home_feed.dart';
import '../widgets/popular_recipes_section.dart';
import '../widgets/latest_recipes_section.dart';

class HomeFeedView extends StatelessWidget {
  const HomeFeedView({
    required this.feed,
    required this.onRecipeActionPressed,
    super.key,
  });

  final HomeFeed feed;
  final VoidCallback onRecipeActionPressed;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const .only(bottom: 118),
      children: [
        const SizedBox(height: 13),
        PopularRecipesSection(recipes: feed.popularRecipes),
        const SizedBox(height: 10),
        LatestRecipesSection(
          recipes: feed.latestRecipes,
          onActionPressed: onRecipeActionPressed,
        ),
      ],
    );
  }
}
