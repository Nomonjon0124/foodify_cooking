import '../../../l10n/generated/app_localizations.dart';
import 'cubit/add_new_cubit.dart';

extension AddNewLocalizations on AppLocalizations {
  String addNewStepLabel(int index) {
    return switch (index) {
      0 => addNewStepRecipeInformation,
      1 => addNewStepIngredients,
      2 => addNewStepIntroduction,
      3 => addNewStepPreview,
      _ => '',
    };
  }

  String addNewDifficultyLabel(String value) {
    return switch (value) {
      'Easy' => addNewDifficultyEasy,
      'Simple' => addNewDifficultySimple,
      'Medium' => addNewDifficultyMedium,
      'Hard' => addNewDifficultyHard,
      _ => value,
    };
  }

  String addNewDishTypeLabel(String value) {
    return switch (value) {
      'Breakfast' => addNewDishBreakfast,
      'Lunch' => addNewDishLunch,
      'Snack' => addNewDishSnack,
      'Brunch' => addNewDishBrunch,
      'Dessert' => addNewDishDessert,
      'Dinner' => addNewDishDinner,
      'Appetizers' => addNewDishAppetizers,
      _ => value,
    };
  }

  String addNewDietaryTargetLabel(String value) {
    return switch (value) {
      'Vegetarian' => addNewDietVegetarian,
      'High Fat' => addNewDietHighFat,
      'Low Fat' => addNewDietLowFat,
      'Sugar Free' => addNewDietSugarFree,
      'Lactose Free' => addNewDietLactoseFree,
      'Gluten Free' => addNewDietGlutenFree,
      _ => value,
    };
  }

  String addNewPreviewTabLabel(RecipePreviewTab tab) {
    return switch (tab) {
      RecipePreviewTab.introduction => addNewPreviewIntroduction,
      RecipePreviewTab.ingredients => addNewPreviewIngredients,
      RecipePreviewTab.comments => addNewPreviewComments,
    };
  }
}
