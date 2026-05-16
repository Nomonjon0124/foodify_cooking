// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Uzbek (`uz`).
class AppLocalizationsUz extends AppLocalizations {
  AppLocalizationsUz([String locale = 'uz']) : super(locale);

  @override
  String get appTitle => 'Milliy Taste';

  @override
  String get startupError => 'Ishga tushirish xatosi';

  @override
  String get navHome => 'Bosh sahifa';

  @override
  String get navSearch => 'Qidiruv';

  @override
  String get navAddNew => 'Qo\'shish';

  @override
  String get navSave => 'Saqlangan';

  @override
  String get navProfile => 'Profil';

  @override
  String get onboardingTitleChef =>
      'Oshpaz bo\'lishingiz uchun shaxsiy yo\'lboshchi';

  @override
  String get onboardingTitleShare => 'Mehrni ulashing, retseptni ulashing';

  @override
  String get onboardingTitleGlobalKitchen =>
      'Global oshxonangizni Foodify qiling';

  @override
  String get onboardingNext => 'Keyingi';

  @override
  String get onboardingGo => 'Boshlash';

  @override
  String get settingsTitle => 'Sozlamalar';

  @override
  String get settingsDarkMode => 'Qorong\'i rejim';

  @override
  String get settingsLanguage => 'Til';

  @override
  String settingsLanguageCurrent(String language) {
    return 'Joriy: $language';
  }

  @override
  String get settingsUseSystemLanguage => 'Tizim tilidan foydalanish';

  @override
  String get languageEnglish => 'Inglizcha';

  @override
  String get languageUzbek => 'O\'zbekcha';

  @override
  String get languageRussian => 'Ruscha';

  @override
  String get settingsSignInTitle => 'Kirish (ixtiyoriy)';

  @override
  String get settingsSignInSubtitle =>
      'Foydalanuvchi xohlasa auth oqimini ochish';

  @override
  String fieldRequired(String field) {
    return '$field kiritilishi shart';
  }

  @override
  String get invalidEmail => 'Email noto\'g\'ri';

  @override
  String get loginFailed => 'Kirish amalga oshmadi';

  @override
  String get searchHint => 'Qidirish';

  @override
  String get searchRecipesTab => 'Retseptlar';

  @override
  String get searchChefsTab => 'Oshpazlar';

  @override
  String get searchTagsTab => 'Teglar';

  @override
  String get searchNoRecipes => 'Retseptlar topilmadi';

  @override
  String get searchNoChefs => 'Oshpazlar topilmadi';

  @override
  String get searchNoTags => 'Teglar topilmadi';

  @override
  String get searchLoadFailure => 'Qidiruv natijalarini yuklab bo\'lmadi';

  @override
  String get homePopularRecipes => 'Mashhur retseptlar';

  @override
  String get homeLatestRecipes => 'Eng so\'nggi retseptlar';

  @override
  String get homeLoadFailure => 'Bosh sahifa ma\'lumotlarini yuklab bo\'lmadi';

  @override
  String get homeRecipeCardAction => 'Retsept kartasi amali';

  @override
  String get loginTitle => 'Kirish';

  @override
  String get loginWelcomeBack => 'Qaytganingiz bilan';

  @override
  String get loginSubtitle => 'Pishirishni davom ettirish uchun kiring';

  @override
  String get loginEmail => 'Email';

  @override
  String get loginPassword => 'Parol';

  @override
  String get loginCreateAccount => 'Hisob yaratish';

  @override
  String get authModuleDisabled => 'Auth moduli o\'chirilgan';

  @override
  String get registerTitle => 'Ro\'yxatdan o\'tish';

  @override
  String get registerTodo => 'TODO: Ro\'yxatdan o\'tish oqimini qo\'shish';

  @override
  String get back => 'Orqaga';

  @override
  String get saveTitle => 'Saqlanganlar';

  @override
  String get saveTodo => 'TODO: Saqlangan retseptlar oqimini qo\'shish';

  @override
  String get recipesTitle => 'Retseptlar';

  @override
  String get recipesEmpty => 'Retseptlar topilmadi';

  @override
  String get recipeDetailsTodo => 'TODO: Retsept tafsilotlarini ochish';

  @override
  String get profileModuleDisabled => 'Profil moduli o\'chirilgan';

  @override
  String get profileLoadFailure => 'Profilni yuklab bo\'lmadi';

  @override
  String get profileRecipesEmpty => 'Profil retseptlari topilmadi';

  @override
  String get profileFollowers => 'Obunachilar';

  @override
  String get profileFollowing => 'Obunalar';

  @override
  String profilePost(int count) {
    return '$count post';
  }

  @override
  String get profileLessDetails => 'Qisqa tafsilotlar';

  @override
  String get profileMoreDetails => 'Batafsil';

  @override
  String get profileEditAction => 'Tahrirlash';

  @override
  String get addNewTitle => 'Yangi retsept';

  @override
  String get addNewNext => 'Keyingi';

  @override
  String get addNewClearAll => 'Tozalash';

  @override
  String get addNewCoverTitle => 'Retsept rasmi qo\'shing';

  @override
  String get addNewRecent => 'So\'nggilar';

  @override
  String get addNewGalleryAction => 'Galereyadan tanlash';

  @override
  String get addNewCameraAction => 'Rasmga olish';

  @override
  String get addNewEditCrop => 'Kesishni tahrirlash';

  @override
  String get addNewRemove => 'O\'chirish';

  @override
  String get addNewCropCancel => 'Bekor qilish';

  @override
  String get addNewCropDone => 'Tayyor';

  @override
  String get addNewCropRotate => 'Rasmni aylantirish';

  @override
  String get addNewFieldName => 'Nomi';

  @override
  String get addNewHintRecipeName => 'Retsept nomini yozing';

  @override
  String get addNewFieldNumber => 'Soni';

  @override
  String get addNewServingFor => 'Porsiya';

  @override
  String get addNewPeople => 'Kishi';

  @override
  String get addNewCookTime => 'Pishirish vaqti';

  @override
  String get addNewDifficulty => 'Qiyinlik';

  @override
  String get addNewDifficultySimple => 'Oson';

  @override
  String get addNewDifficultyMedium => 'O\'rtacha';

  @override
  String get addNewDifficultyHard => 'Qiyin';

  @override
  String get addNewDishType => 'Taom turi';

  @override
  String get addNewDietaryTarget => 'Tavsiya etilgan parhez turi';

  @override
  String get addNewHashtags => 'Hashtaglar';

  @override
  String get addNewHintIngredient => 'Ingredient qo\'shing';

  @override
  String get addNewHintInstruction => 'Tayyorlash bosqichini qo\'shing';

  @override
  String get addNewSubmitSuccessTitle => 'Retsept yuklandi';

  @override
  String get addNewSubmitSuccessSubtitle =>
      'Retseptingiz profilingizga qo\'shildi.';

  @override
  String get addNewCreateAnother => 'Yana yaratish';

  @override
  String get recipesLoadFailure => 'Retseptlarni yuklab bo\'lmadi';

  @override
  String get addNewStepRecipeInformation => 'Retsept ma\'lumotlari';

  @override
  String get addNewStepIngredients => 'Ingredientlar';

  @override
  String get addNewStepIntroduction => 'Tayyorlash';

  @override
  String get addNewStepPreview => 'Ko\'rish';

  @override
  String get addNewDifficultyEasy => 'Oson';

  @override
  String get addNewDishBreakfast => 'Nonushta';

  @override
  String get addNewDishLunch => 'Tushlik';

  @override
  String get addNewDishSnack => 'Yengil tamaddi';

  @override
  String get addNewDishBrunch => 'Branch';

  @override
  String get addNewDishDessert => 'Desert';

  @override
  String get addNewDishDinner => 'Kechki ovqat';

  @override
  String get addNewDishAppetizers => 'Gazaklar';

  @override
  String get addNewDietVegetarian => 'Vegetarian';

  @override
  String get addNewDietHighFat => 'Yog\'i yuqori';

  @override
  String get addNewDietLowFat => 'Yog\'i kam';

  @override
  String get addNewDietSugarFree => 'Shakarsiz';

  @override
  String get addNewDietLactoseFree => 'Laktozasiz';

  @override
  String get addNewDietGlutenFree => 'Glyutensiz';

  @override
  String get addNewPreviewIntroduction => 'Tayyorlash';

  @override
  String get addNewPreviewIngredients => 'Ingredientlar';

  @override
  String get addNewPreviewComments => 'Izohlar';

  @override
  String addNewStepsCount(int count) {
    return '$count bosqich';
  }

  @override
  String addNewIngredientsCount(int count) {
    return '$count ingredient';
  }

  @override
  String addNewCommentsCount(int count) {
    return '$count izoh';
  }

  @override
  String get addNewInstructionPlaceholder => 'Tayyorlash bosqichi matni...';

  @override
  String get addNewIngredientPlaceholder => 'Ingredient nomi...';

  @override
  String get addNewRecipeTitleFallback => 'Mukammal uy pankeyki';

  @override
  String get addNewHeadlineTagFallback => 'Kam kaloriyali';

  @override
  String get ok => 'OK';
}
