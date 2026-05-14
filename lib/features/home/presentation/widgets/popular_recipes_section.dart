import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../common/widgets/foodify_components/foodify_popular_card.dart';
import '../data/home_sample_data.dart';
import 'home_section_title.dart';

class PopularRecipesSection extends StatefulWidget {
  const PopularRecipesSection({super.key});

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
    const recipes = popularRecipes;

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
              child: const HomeSectionTitle('Popular Recipes'),
            ),
            SizedBox(height: 24.h),
            SizedBox(
              height: 199.r,
              child: ListView.separated(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.only(left: 0, right: 20.w),
                physics: const BouncingScrollPhysics(),
                itemCount: recipes.length,
                separatorBuilder: (_, _) => SizedBox(width: 8.w),
                itemBuilder: (context, index) {
                  final recipe = recipes[index];
                  return FoodifyPopularCard(
                    title: recipe.title,
                    rating: recipe.rating,
                    imagePath: Image.asset(recipe.imagePath, fit: BoxFit.cover),
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
