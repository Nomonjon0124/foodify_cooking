import 'package:flutter/material.dart';
import '../widgets/popular_recipes_section.dart';
import '../widgets/latest_recipes_section.dart';

class HomeFeedView extends StatelessWidget {
  const HomeFeedView({required this.onRecipeActionPressed, super.key});

  final VoidCallback onRecipeActionPressed;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const .only(bottom: 118),
      children: [
        const SizedBox(height: 13),
        const PopularRecipesSection(),
        const SizedBox(height: 10),
        LatestRecipesSection(onActionPressed: onRecipeActionPressed),
      ],
    );
  }
}
