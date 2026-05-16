import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_uz.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('uz'),
    Locale('en'),
    Locale('ru'),
  ];

  /// Application title shown to the OS and app shell.
  ///
  /// In en, this message translates to:
  /// **'Milliy Taste'**
  String get appTitle;

  /// Fallback startup error message.
  ///
  /// In en, this message translates to:
  /// **'Startup error'**
  String get startupError;

  /// Bottom navigation item for the home tab.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// Bottom navigation item for the search tab.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get navSearch;

  /// Bottom navigation item for adding a new recipe.
  ///
  /// In en, this message translates to:
  /// **'Add New'**
  String get navAddNew;

  /// Bottom navigation item for saved recipes.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get navSave;

  /// Bottom navigation item for the profile tab.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// First onboarding page title.
  ///
  /// In en, this message translates to:
  /// **'Your personal guide to be a chef'**
  String get onboardingTitleChef;

  /// Second onboarding page title.
  ///
  /// In en, this message translates to:
  /// **'Share the Love, Share the Recipe'**
  String get onboardingTitleShare;

  /// Third onboarding page title.
  ///
  /// In en, this message translates to:
  /// **'Foodify Your Global Kitchen'**
  String get onboardingTitleGlobalKitchen;

  /// Onboarding button for moving to the next page.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get onboardingNext;

  /// Onboarding final button for entering the app.
  ///
  /// In en, this message translates to:
  /// **'Go'**
  String get onboardingGo;

  /// Settings screen app bar title.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// Settings switch title for dark mode.
  ///
  /// In en, this message translates to:
  /// **'Dark mode'**
  String get settingsDarkMode;

  /// Settings language row title.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// Settings language subtitle showing the current selected language.
  ///
  /// In en, this message translates to:
  /// **'Current: {language}'**
  String settingsLanguageCurrent(String language);

  /// Language selector option to follow the device locale.
  ///
  /// In en, this message translates to:
  /// **'Use system language'**
  String get settingsUseSystemLanguage;

  /// English language name.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// Uzbek language name.
  ///
  /// In en, this message translates to:
  /// **'Uzbek'**
  String get languageUzbek;

  /// Russian language name.
  ///
  /// In en, this message translates to:
  /// **'Russian'**
  String get languageRussian;

  /// Settings row title for optional sign in.
  ///
  /// In en, this message translates to:
  /// **'Sign in (optional)'**
  String get settingsSignInTitle;

  /// Settings row subtitle for optional sign in.
  ///
  /// In en, this message translates to:
  /// **'Open auth flow only if user wants'**
  String get settingsSignInSubtitle;

  /// Validation message for a required field.
  ///
  /// In en, this message translates to:
  /// **'{field} is required'**
  String fieldRequired(String field);

  /// Validation message for an invalid email.
  ///
  /// In en, this message translates to:
  /// **'Invalid email'**
  String get invalidEmail;

  /// Login failure snackbar fallback.
  ///
  /// In en, this message translates to:
  /// **'Login failed'**
  String get loginFailed;

  /// Generic search input placeholder.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get searchHint;

  /// Search tab for recipes.
  ///
  /// In en, this message translates to:
  /// **'Recipes'**
  String get searchRecipesTab;

  /// Search tab for chefs.
  ///
  /// In en, this message translates to:
  /// **'Chefs'**
  String get searchChefsTab;

  /// Search tab for tags.
  ///
  /// In en, this message translates to:
  /// **'Tags'**
  String get searchTagsTab;

  /// Empty state for search recipes.
  ///
  /// In en, this message translates to:
  /// **'No recipes found'**
  String get searchNoRecipes;

  /// Empty state for search chefs.
  ///
  /// In en, this message translates to:
  /// **'No chefs found'**
  String get searchNoChefs;

  /// Empty state for search tags.
  ///
  /// In en, this message translates to:
  /// **'No tags found'**
  String get searchNoTags;

  /// Search results load failure message.
  ///
  /// In en, this message translates to:
  /// **'Failed to load search results'**
  String get searchLoadFailure;

  /// Home section title for popular recipes.
  ///
  /// In en, this message translates to:
  /// **'Popular Recipes'**
  String get homePopularRecipes;

  /// Home section title for latest recipes.
  ///
  /// In en, this message translates to:
  /// **'The Latest Recipes'**
  String get homeLatestRecipes;

  /// Home feed load failure message.
  ///
  /// In en, this message translates to:
  /// **'Failed to load home feed'**
  String get homeLoadFailure;

  /// Temporary snackbar when a home recipe card action is pressed.
  ///
  /// In en, this message translates to:
  /// **'Recipe card action'**
  String get homeRecipeCardAction;

  /// Login screen app bar title.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get loginTitle;

  /// Login screen header title.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get loginWelcomeBack;

  /// Login screen header subtitle.
  ///
  /// In en, this message translates to:
  /// **'Login to continue cooking'**
  String get loginSubtitle;

  /// Email field label.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get loginEmail;

  /// Password field label.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get loginPassword;

  /// Button to navigate to account creation.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get loginCreateAccount;

  /// Message shown when auth DI is disabled.
  ///
  /// In en, this message translates to:
  /// **'Auth module is disabled'**
  String get authModuleDisabled;

  /// Register screen app bar title.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get registerTitle;

  /// Temporary placeholder for registration flow.
  ///
  /// In en, this message translates to:
  /// **'TODO: Implement registration flow'**
  String get registerTodo;

  /// Generic back button label.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// Saved recipes screen title.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get saveTitle;

  /// Temporary placeholder for saved recipes flow.
  ///
  /// In en, this message translates to:
  /// **'TODO: Implement saved recipes flow'**
  String get saveTodo;

  /// Recipe list screen title.
  ///
  /// In en, this message translates to:
  /// **'Recipes'**
  String get recipesTitle;

  /// Empty state for recipe list.
  ///
  /// In en, this message translates to:
  /// **'No recipes found'**
  String get recipesEmpty;

  /// Temporary placeholder for recipe detail navigation.
  ///
  /// In en, this message translates to:
  /// **'TODO: Open recipe details'**
  String get recipeDetailsTodo;

  /// Message shown when profile DI is disabled.
  ///
  /// In en, this message translates to:
  /// **'Profile module is disabled'**
  String get profileModuleDisabled;

  /// Profile load failure message.
  ///
  /// In en, this message translates to:
  /// **'Failed to load profile'**
  String get profileLoadFailure;

  /// Profile recipe empty state.
  ///
  /// In en, this message translates to:
  /// **'No profile recipes found'**
  String get profileRecipesEmpty;

  /// Profile followers label.
  ///
  /// In en, this message translates to:
  /// **'Followers'**
  String get profileFollowers;

  /// Profile following label.
  ///
  /// In en, this message translates to:
  /// **'Following'**
  String get profileFollowing;

  /// Profile post count tab label.
  ///
  /// In en, this message translates to:
  /// **'{count} Post'**
  String profilePost(int count);

  /// Profile tab for less detailed recipe cards.
  ///
  /// In en, this message translates to:
  /// **'Less Details'**
  String get profileLessDetails;

  /// Profile tab for more detailed recipe cards.
  ///
  /// In en, this message translates to:
  /// **'More Details'**
  String get profileMoreDetails;

  /// Add new recipe screen title.
  ///
  /// In en, this message translates to:
  /// **'New Recipe'**
  String get addNewTitle;

  /// Add new recipe next button label.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get addNewNext;

  /// Add new recipe clear draft action.
  ///
  /// In en, this message translates to:
  /// **'Clear all'**
  String get addNewClearAll;

  /// Add new recipe cover picker title.
  ///
  /// In en, this message translates to:
  /// **'Add a recipe Cover'**
  String get addNewCoverTitle;

  /// Recent media section label in the cover picker.
  ///
  /// In en, this message translates to:
  /// **'Recent'**
  String get addNewRecent;

  /// Add new recipe cover edit crop action.
  ///
  /// In en, this message translates to:
  /// **'Edit Crop'**
  String get addNewEditCrop;

  /// Add new recipe cover remove action.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get addNewRemove;

  /// Crop photo cancel action.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get addNewCropCancel;

  /// Crop photo done action.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get addNewCropDone;

  /// Recipe name field label.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get addNewFieldName;

  /// Recipe name input placeholder.
  ///
  /// In en, this message translates to:
  /// **'Name your recipe'**
  String get addNewHintRecipeName;

  /// Recipe servings field label.
  ///
  /// In en, this message translates to:
  /// **'Number'**
  String get addNewFieldNumber;

  /// Serving count prefix label.
  ///
  /// In en, this message translates to:
  /// **'Serving for'**
  String get addNewServingFor;

  /// Serving count suffix label.
  ///
  /// In en, this message translates to:
  /// **'People'**
  String get addNewPeople;

  /// Recipe cook time field label.
  ///
  /// In en, this message translates to:
  /// **'Cook Time'**
  String get addNewCookTime;

  /// Recipe difficulty field label.
  ///
  /// In en, this message translates to:
  /// **'Difficulty'**
  String get addNewDifficulty;

  /// Simple recipe difficulty option.
  ///
  /// In en, this message translates to:
  /// **'Simple'**
  String get addNewDifficultySimple;

  /// Medium recipe difficulty option.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get addNewDifficultyMedium;

  /// Hard recipe difficulty option.
  ///
  /// In en, this message translates to:
  /// **'Hard'**
  String get addNewDifficultyHard;

  /// Recipe category field label.
  ///
  /// In en, this message translates to:
  /// **'Dish Type'**
  String get addNewDishType;

  /// Recipe dietary target field label.
  ///
  /// In en, this message translates to:
  /// **'Suggested Dietary Target'**
  String get addNewDietaryTarget;

  /// Recipe hashtags field label.
  ///
  /// In en, this message translates to:
  /// **'Hashtags'**
  String get addNewHashtags;

  /// Ingredient input placeholder.
  ///
  /// In en, this message translates to:
  /// **'Add ingredient'**
  String get addNewHintIngredient;

  /// Instruction input placeholder.
  ///
  /// In en, this message translates to:
  /// **'Add instruction step'**
  String get addNewHintInstruction;

  /// Recipe submit success bottom sheet title.
  ///
  /// In en, this message translates to:
  /// **'Recipe uploaded'**
  String get addNewSubmitSuccessTitle;

  /// Recipe submit success bottom sheet subtitle.
  ///
  /// In en, this message translates to:
  /// **'Your recipe has been added to your profile.'**
  String get addNewSubmitSuccessSubtitle;

  /// Recipe submit success action to create another recipe.
  ///
  /// In en, this message translates to:
  /// **'Create another'**
  String get addNewCreateAnother;

  /// Recipe list load failure message.
  ///
  /// In en, this message translates to:
  /// **'Unable to load recipes'**
  String get recipesLoadFailure;

  /// Add new stepper label for recipe information.
  ///
  /// In en, this message translates to:
  /// **'Recipe Information'**
  String get addNewStepRecipeInformation;

  /// Add new stepper label for ingredients.
  ///
  /// In en, this message translates to:
  /// **'Ingredients'**
  String get addNewStepIngredients;

  /// Add new stepper label for instructions/introduction.
  ///
  /// In en, this message translates to:
  /// **'Introduction'**
  String get addNewStepIntroduction;

  /// Add new stepper label for recipe preview.
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get addNewStepPreview;

  /// Easy recipe difficulty option.
  ///
  /// In en, this message translates to:
  /// **'Easy'**
  String get addNewDifficultyEasy;

  /// Breakfast dish type option.
  ///
  /// In en, this message translates to:
  /// **'Breakfast'**
  String get addNewDishBreakfast;

  /// Lunch dish type option.
  ///
  /// In en, this message translates to:
  /// **'Lunch'**
  String get addNewDishLunch;

  /// Snack dish type option.
  ///
  /// In en, this message translates to:
  /// **'Snack'**
  String get addNewDishSnack;

  /// Brunch dish type option.
  ///
  /// In en, this message translates to:
  /// **'Brunch'**
  String get addNewDishBrunch;

  /// Dessert dish type option.
  ///
  /// In en, this message translates to:
  /// **'Dessert'**
  String get addNewDishDessert;

  /// Dinner dish type option.
  ///
  /// In en, this message translates to:
  /// **'Dinner'**
  String get addNewDishDinner;

  /// Appetizers dish type option.
  ///
  /// In en, this message translates to:
  /// **'Appetizers'**
  String get addNewDishAppetizers;

  /// Vegetarian dietary target option.
  ///
  /// In en, this message translates to:
  /// **'Vegetarian'**
  String get addNewDietVegetarian;

  /// High fat dietary target option.
  ///
  /// In en, this message translates to:
  /// **'High Fat'**
  String get addNewDietHighFat;

  /// Low fat dietary target option.
  ///
  /// In en, this message translates to:
  /// **'Low Fat'**
  String get addNewDietLowFat;

  /// Sugar free dietary target option.
  ///
  /// In en, this message translates to:
  /// **'Sugar Free'**
  String get addNewDietSugarFree;

  /// Lactose free dietary target option.
  ///
  /// In en, this message translates to:
  /// **'Lactose Free'**
  String get addNewDietLactoseFree;

  /// Gluten free dietary target option.
  ///
  /// In en, this message translates to:
  /// **'Gluten Free'**
  String get addNewDietGlutenFree;

  /// Recipe preview tab for introduction steps.
  ///
  /// In en, this message translates to:
  /// **'Introduction'**
  String get addNewPreviewIntroduction;

  /// Recipe preview tab for ingredients.
  ///
  /// In en, this message translates to:
  /// **'Ingredients'**
  String get addNewPreviewIngredients;

  /// Recipe preview tab for comments.
  ///
  /// In en, this message translates to:
  /// **'Comments'**
  String get addNewPreviewComments;

  /// Recipe preview section headline for instruction step count.
  ///
  /// In en, this message translates to:
  /// **'{count} Steps'**
  String addNewStepsCount(int count);

  /// Recipe preview section headline for ingredient count.
  ///
  /// In en, this message translates to:
  /// **'{count} Ingredients'**
  String addNewIngredientsCount(int count);

  /// Recipe preview section headline for comment count.
  ///
  /// In en, this message translates to:
  /// **'{count} Comments'**
  String addNewCommentsCount(int count);

  /// Placeholder text for an empty instruction in recipe preview.
  ///
  /// In en, this message translates to:
  /// **'Instruction step content...'**
  String get addNewInstructionPlaceholder;

  /// Placeholder text for an empty ingredient in recipe preview.
  ///
  /// In en, this message translates to:
  /// **'Ingredient name...'**
  String get addNewIngredientPlaceholder;

  /// Fallback title shown in recipe preview before user enters a title.
  ///
  /// In en, this message translates to:
  /// **'Perfect homemade pancake'**
  String get addNewRecipeTitleFallback;

  /// Fallback info tag shown in recipe preview.
  ///
  /// In en, this message translates to:
  /// **'Low Calorie'**
  String get addNewHeadlineTagFallback;

  /// Generic OK dialog action.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ru', 'uz'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ru':
      return AppLocalizationsRu();
    case 'uz':
      return AppLocalizationsUz();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
