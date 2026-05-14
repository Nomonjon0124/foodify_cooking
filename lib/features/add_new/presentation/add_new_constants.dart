import 'package:equatable/equatable.dart';
import 'package:foodify_cooking/core/gen/assets.gen.dart';

class AddNewComment extends Equatable {
  const AddNewComment({required this.avatarPath, required this.message});

  final String avatarPath;
  final String message;

  @override
  List<Object?> get props => [avatarPath, message];
}

abstract final class AddNewConstants {
  static const stepLabels = [
    'Recipe Information',
    'Ingredients',
    'Introduction',
    'Preview',
  ];

  static const difficultyOptions = ['Easy', 'Medium', 'Hard'];

  static const dishTypeOptions = [
    'Breakfast',
    'Lunch',
    'Snack',
    'Brunch',
    'Dessert',
    'Dinner',
    'Appetizers',
  ];

  static const dietaryTargetOptions = [
    'Vegetarian',
    'High Fat',
    'Low Fat',
    'Sugar Free',
    'Lactose Free',
    'Gluten Free',
  ];

  static final mockImagePaths = [
    Assets.images.recipeCards.mainCardContent.path,
    Assets.images.recipeCards.mainCardContentOmelets.path,
    Assets.images.recipeCards.mainCardContentVictoria.path,
    Assets.images.foodifyComponents.popularCardCake.path,
    Assets.images.foodifyComponents.popularCardIcecream.path,
    Assets.images.foodifyComponents.popularCardPizza.path,
    Assets.images.onboarding.onboarding11.path,
    Assets.images.onboarding.onboarding21.path,
  ];

  static const previewLikes = '435';
  static const authorName = 'Kelly Mayer';
  static const authorRating = '4.8';
  static const recipeRating = '4.3';

  static final mockComments = [
    AddNewComment(
      avatarPath: Assets.images.recipeCards.userPic.path,
      message:
          'This recipe is a game-changer! The combination of spices and textures is phenomenal.',
    ),
    AddNewComment(
      avatarPath: Assets.images.recipeCards.userPicDave.path,
      message:
          'As a busy mom, I appreciate quick and tasty recipes. This one saved me time and earned compliments.',
    ),
    AddNewComment(
      avatarPath: Assets.images.recipeCards.userPicRick.path,
      message:
          'I am always on the lookout for healthy recipes, and this one exceeded my expectations.',
    ),
  ];
}
