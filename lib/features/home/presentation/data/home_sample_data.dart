import '../models/home_recipe_model.dart';

const recipeDescription =
    'In a large bowl, mix together flour, baking powder, sugar, and salt..';

const popularRecipes = [
  PopularRecipeSample(
    title: 'chocolate ice cream buttercream fruit',
    rating: '4.8',
    imagePath: 'assets/images/foodify_components/popular_card_icecream.png',
  ),
  PopularRecipeSample(
    title: 'chocolate cake with buttercream frosting',
    rating: '4.8',
    imagePath: 'assets/images/foodify_components/popular_card_cake.png',
  ),
  PopularRecipeSample(
    title: 'Italian pineapple pizza',
    rating: '4.8',
    imagePath: 'assets/images/foodify_components/popular_card_pizza.png',
  ),
];

const latestRecipes = [
  LatestRecipeSample(
    title: 'Frosted pinecone cake',
    authorName: 'Kelly Mayer',
    description: recipeDescription,
    durationLabel: '30 Min',
    difficultyLabel: 'Medium',
    imagePath: 'assets/images/recipe_cards/main_card_content.png',
    overlayImagePath:
        'assets/images/recipe_cards/main_card_content_overlay.png',
    authorImagePath: 'assets/images/recipe_cards/user_pic.png',
    topRating: '4.8',
    authorRating: '4.9',
  ),
  LatestRecipeSample(
    title: 'Classic Victoria sandwich recip...',
    authorName: 'Rick Dolynsky',
    description: recipeDescription,
    durationLabel: '120 Min',
    difficultyLabel: 'Simple',
    imagePath: 'assets/images/recipe_cards/main_card_content.png',
    overlayImagePath:
        'assets/images/recipe_cards/main_card_content_victoria.png',
    authorImagePath: 'assets/images/recipe_cards/user_pic_rick.png',
    topRating: '3.8',
    authorRating: '4.4',
  ),
  LatestRecipeSample(
    title: 'Pea and Ricotta Omelets',
    authorName: 'Dave Robert',
    description: recipeDescription,
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
