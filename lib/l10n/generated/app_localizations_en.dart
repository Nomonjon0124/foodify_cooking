// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Milliy Taste';

  @override
  String get startupError => 'Startup error';

  @override
  String get navHome => 'Home';

  @override
  String get navSearch => 'Search';

  @override
  String get navAddNew => 'Add New';

  @override
  String get navSave => 'Save';

  @override
  String get navProfile => 'Profile';

  @override
  String get onboardingTitleChef => 'Your personal guide to be a chef';

  @override
  String get onboardingTitleShare => 'Share the Love, Share the Recipe';

  @override
  String get onboardingTitleGlobalKitchen => 'Foodify Your Global Kitchen';

  @override
  String get onboardingNext => 'Next';

  @override
  String get onboardingGo => 'Go';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsDarkMode => 'Dark mode';

  @override
  String get settingsLanguage => 'Language';

  @override
  String settingsLanguageCurrent(String language) {
    return 'Current: $language';
  }

  @override
  String get settingsUseSystemLanguage => 'Use system language';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageUzbek => 'Uzbek';

  @override
  String get languageRussian => 'Russian';

  @override
  String get settingsSignInTitle => 'Sign in (optional)';

  @override
  String get settingsSignInSubtitle => 'Open auth flow only if user wants';

  @override
  String fieldRequired(String field) {
    return '$field is required';
  }

  @override
  String get invalidEmail => 'Invalid email';

  @override
  String get loginFailed => 'Login failed';

  @override
  String get searchHint => 'Search';

  @override
  String get searchRecipesTab => 'Recipes';

  @override
  String get searchChefsTab => 'Chefs';

  @override
  String get searchTagsTab => 'Tags';

  @override
  String get searchNoRecipes => 'No recipes found';

  @override
  String get searchNoChefs => 'No chefs found';

  @override
  String get searchNoTags => 'No tags found';

  @override
  String get searchLoadFailure => 'Failed to load search results';

  @override
  String get homePopularRecipes => 'Popular Recipes';

  @override
  String get homeLatestRecipes => 'The Latest Recipes';

  @override
  String get homeLoadFailure => 'Failed to load home feed';

  @override
  String get homeRecipeCardAction => 'Recipe card action';

  @override
  String get loginTitle => 'Login';

  @override
  String get loginWelcomeBack => 'Welcome back';

  @override
  String get loginSubtitle => 'Login to continue cooking';

  @override
  String get loginEmail => 'Email';

  @override
  String get loginPassword => 'Password';

  @override
  String get loginCreateAccount => 'Create account';

  @override
  String get authModuleDisabled => 'Auth module is disabled';

  @override
  String get registerTitle => 'Register';

  @override
  String get registerTodo => 'TODO: Implement registration flow';

  @override
  String get back => 'Back';

  @override
  String get saveTitle => 'Save';

  @override
  String get saveTodo => 'TODO: Implement saved recipes flow';

  @override
  String get recipesTitle => 'Recipes';

  @override
  String get recipesEmpty => 'No recipes found';

  @override
  String get recipeDetailsTodo => 'TODO: Open recipe details';

  @override
  String get profileModuleDisabled => 'Profile module is disabled';

  @override
  String get profileLoadFailure => 'Failed to load profile';

  @override
  String get profileRecipesEmpty => 'No profile recipes found';

  @override
  String get profileFollowers => 'Followers';

  @override
  String get profileFollowing => 'Following';

  @override
  String profilePost(int count) {
    return '$count Post';
  }

  @override
  String get profileLessDetails => 'Less Details';

  @override
  String get profileMoreDetails => 'More Details';

  @override
  String get profileEditAction => 'Edit Profile';

  @override
  String get addNewTitle => 'New Recipe';

  @override
  String get addNewNext => 'Next';

  @override
  String get addNewClearAll => 'Clear all';

  @override
  String get addNewCoverTitle => 'Add a recipe Cover';

  @override
  String get addNewRecent => 'Recent';

  @override
  String get addNewEditCrop => 'Edit Crop';

  @override
  String get addNewRemove => 'Remove';

  @override
  String get addNewCropCancel => 'Cancel';

  @override
  String get addNewCropDone => 'Done';

  @override
  String get addNewFieldName => 'Name';

  @override
  String get addNewHintRecipeName => 'Name your recipe';

  @override
  String get addNewFieldNumber => 'Number';

  @override
  String get addNewServingFor => 'Serving for';

  @override
  String get addNewPeople => 'People';

  @override
  String get addNewCookTime => 'Cook Time';

  @override
  String get addNewDifficulty => 'Difficulty';

  @override
  String get addNewDifficultySimple => 'Simple';

  @override
  String get addNewDifficultyMedium => 'Medium';

  @override
  String get addNewDifficultyHard => 'Hard';

  @override
  String get addNewDishType => 'Dish Type';

  @override
  String get addNewDietaryTarget => 'Suggested Dietary Target';

  @override
  String get addNewHashtags => 'Hashtags';

  @override
  String get addNewHintIngredient => 'Add ingredient';

  @override
  String get addNewHintInstruction => 'Add instruction step';

  @override
  String get addNewSubmitSuccessTitle => 'Recipe uploaded';

  @override
  String get addNewSubmitSuccessSubtitle =>
      'Your recipe has been added to your profile.';

  @override
  String get addNewCreateAnother => 'Create another';

  @override
  String get recipesLoadFailure => 'Unable to load recipes';

  @override
  String get addNewStepRecipeInformation => 'Recipe Information';

  @override
  String get addNewStepIngredients => 'Ingredients';

  @override
  String get addNewStepIntroduction => 'Introduction';

  @override
  String get addNewStepPreview => 'Preview';

  @override
  String get addNewDifficultyEasy => 'Easy';

  @override
  String get addNewDishBreakfast => 'Breakfast';

  @override
  String get addNewDishLunch => 'Lunch';

  @override
  String get addNewDishSnack => 'Snack';

  @override
  String get addNewDishBrunch => 'Brunch';

  @override
  String get addNewDishDessert => 'Dessert';

  @override
  String get addNewDishDinner => 'Dinner';

  @override
  String get addNewDishAppetizers => 'Appetizers';

  @override
  String get addNewDietVegetarian => 'Vegetarian';

  @override
  String get addNewDietHighFat => 'High Fat';

  @override
  String get addNewDietLowFat => 'Low Fat';

  @override
  String get addNewDietSugarFree => 'Sugar Free';

  @override
  String get addNewDietLactoseFree => 'Lactose Free';

  @override
  String get addNewDietGlutenFree => 'Gluten Free';

  @override
  String get addNewPreviewIntroduction => 'Introduction';

  @override
  String get addNewPreviewIngredients => 'Ingredients';

  @override
  String get addNewPreviewComments => 'Comments';

  @override
  String addNewStepsCount(int count) {
    return '$count Steps';
  }

  @override
  String addNewIngredientsCount(int count) {
    return '$count Ingredients';
  }

  @override
  String addNewCommentsCount(int count) {
    return '$count Comments';
  }

  @override
  String get addNewInstructionPlaceholder => 'Instruction step content...';

  @override
  String get addNewIngredientPlaceholder => 'Ingredient name...';

  @override
  String get addNewRecipeTitleFallback => 'Perfect homemade pancake';

  @override
  String get addNewHeadlineTagFallback => 'Low Calorie';

  @override
  String get ok => 'OK';
}
