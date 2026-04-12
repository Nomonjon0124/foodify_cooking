import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../common/widgets/app_loader.dart';
import '../../../../common/widgets/app_snackbar.dart';
import '../../../../common/widgets/foodify_app_bar.dart';
import '../../../../common/widgets/foodify_components/foodify_popular_card.dart';
import '../../../../common/widgets/recipe_cards/recipe_main_card.dart';
import '../../../../core/gen/fonts.gen.dart';
import '../../../../core/di/injection_container.dart';
import '../cubit/home_cubit.dart';
import '../cubit/home_state.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeCubit>(
      create: (_) => getIt<HomeCubit>()..loadHome(),
      child: Scaffold(
        appBar: const FoodifyAppBar.home(),
        backgroundColor: Colors.white,
        body: BlocConsumer<HomeCubit, HomeState>(
          listener: (context, state) {
            if (state.status == HomeStatus.failure) {
              AppSnackbar.show(
                context,
                state.errorMessage ?? 'Unable to load data',
              );
            }
          },
          builder: (context, state) {
            if (state.status == HomeStatus.loading) {
              return const AppLoader();
            }

            return _HomeFeedView(
              onRecipeActionPressed: () {
                AppSnackbar.show(context, 'Recipe card action');
              },
            );
          },
        ),
      ),
    );
  }
}

class _HomeFeedView extends StatelessWidget {
  const _HomeFeedView({required this.onRecipeActionPressed});

  final VoidCallback onRecipeActionPressed;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.only(bottom: 118.h),
      children: [
        SizedBox(height: 13.h),
        const _PopularRecipesSection(),
        SizedBox(height: 10.h),
        _LatestRecipesSection(onActionPressed: onRecipeActionPressed),
      ],
    );
  }
}

class _PopularRecipesSection extends StatefulWidget {
  const _PopularRecipesSection();

  @override
  State<_PopularRecipesSection> createState() => _PopularRecipesSectionState();
}

class _PopularRecipesSectionState extends State<_PopularRecipesSection> {
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
    const recipes = _popularRecipes;

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
              child: const _HomeSectionTitle('Popular Recipes'),
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

class _LatestRecipesSection extends StatelessWidget {
  const _LatestRecipesSection({required this.onActionPressed});

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
              child: const _HomeSectionTitle('The Latest Recipes'),
            ),
            SizedBox(height: 24.h),
            ..._latestRecipes.expand(
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
                if (recipe != _latestRecipes.last) SizedBox(height: 12.h),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeSectionTitle extends StatelessWidget {
  const _HomeSectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        color: const Color(0xFF0E0E0E),
        fontSize: 22.sp,
        fontWeight: FontWeight.w600,
        height: 1.18,
        fontFamily: 'Georgia',
        fontFamilyFallback: const ['Times New Roman', FontFamily.montserrat],
      ),
    );
  }
}

class _PopularRecipeSample {
  const _PopularRecipeSample({
    required this.title,
    required this.rating,
    required this.imagePath,
  });

  final String title;
  final String rating;
  final String imagePath;
}

class _LatestRecipeSample {
  const _LatestRecipeSample({
    required this.title,
    required this.authorName,
    required this.description,
    required this.durationLabel,
    required this.difficultyLabel,
    required this.imagePath,
    required this.overlayImagePath,
    required this.authorImagePath,
    required this.topRating,
    required this.authorRating,
  });

  final String title;
  final String authorName;
  final String description;
  final String durationLabel;
  final String difficultyLabel;
  final String imagePath;
  final String overlayImagePath;
  final String authorImagePath;
  final String topRating;
  final String authorRating;
}

const _recipeDescription =
    'In a large bowl, mix together flour, baking powder, sugar, and salt..';

const _popularRecipes = [
  _PopularRecipeSample(
    title: 'chocolate ice cream buttercream fruit',
    rating: '4.8',
    imagePath: 'assets/images/foodify_components/popular_card_icecream.png',
  ),
  _PopularRecipeSample(
    title: 'chocolate cake with buttercream frosting',
    rating: '4.8',
    imagePath: 'assets/images/foodify_components/popular_card_cake.png',
  ),
  _PopularRecipeSample(
    title: 'Italian pineapple pizza',
    rating: '4.8',
    imagePath: 'assets/images/foodify_components/popular_card_pizza.png',
  ),
];

const _latestRecipes = [
  _LatestRecipeSample(
    title: 'Frosted pinecone cake',
    authorName: 'Kelly Mayer',
    description: _recipeDescription,
    durationLabel: '30 Min',
    difficultyLabel: 'Medium',
    imagePath: 'assets/images/recipe_cards/main_card_content.png',
    overlayImagePath:
        'assets/images/recipe_cards/main_card_content_overlay.png',
    authorImagePath: 'assets/images/recipe_cards/user_pic.png',
    topRating: '4.8',
    authorRating: '4.9',
  ),
  _LatestRecipeSample(
    title: 'Classic Victoria sandwich recip...',
    authorName: 'Rick Dolynsky',
    description: _recipeDescription,
    durationLabel: '120 Min',
    difficultyLabel: 'Simple',
    imagePath: 'assets/images/recipe_cards/main_card_content.png',
    overlayImagePath:
        'assets/images/recipe_cards/main_card_content_victoria.png',
    authorImagePath: 'assets/images/recipe_cards/user_pic_rick.png',
    topRating: '3.8',
    authorRating: '4.4',
  ),
  _LatestRecipeSample(
    title: 'Pea and Ricotta Omelets',
    authorName: 'Dave Robert',
    description: _recipeDescription,
    durationLabel: '15 Min',
    difficultyLabel: 'Hard',
    imagePath: 'assets/images/recipe_cards/main_card_content.png',
    overlayImagePath:
        'assets/images/recipe_cards/main_card_content_omelets.png',
    authorImagePath: 'assets/images/recipe_cards/user_pic_dave.png',
    topRating: '4.5',
    authorRating: '5.0',
  ),
];
