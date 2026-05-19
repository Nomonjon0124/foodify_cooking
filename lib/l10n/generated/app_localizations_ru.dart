// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Milliy Taste';

  @override
  String get startupError => 'Ошибка запуска';

  @override
  String get navHome => 'Главная';

  @override
  String get navSearch => 'Поиск';

  @override
  String get navAddNew => 'Добавить';

  @override
  String get navSave => 'Сохранено';

  @override
  String get navProfile => 'Профиль';

  @override
  String get onboardingTitleChef => 'Ваш личный гид на пути к шеф-повару';

  @override
  String get onboardingTitleShare => 'Делитесь любовью, делитесь рецептом';

  @override
  String get onboardingTitleGlobalKitchen => 'Foodify для вашей мировой кухни';

  @override
  String get onboardingNext => 'Далее';

  @override
  String get onboardingGo => 'Начать';

  @override
  String get settingsTitle => 'Настройки';

  @override
  String get settingsDarkMode => 'Темная тема';

  @override
  String get settingsLanguage => 'Язык';

  @override
  String settingsLanguageCurrent(String language) {
    return 'Текущий: $language';
  }

  @override
  String get settingsUseSystemLanguage => 'Использовать язык системы';

  @override
  String get languageEnglish => 'Английский';

  @override
  String get languageUzbek => 'Узбекский';

  @override
  String get languageRussian => 'Русский';

  @override
  String get settingsSignInTitle => 'Войти (необязательно)';

  @override
  String get settingsSignInSubtitle =>
      'Открывать авторизацию только по желанию';

  @override
  String fieldRequired(String field) {
    return '$field обязательно';
  }

  @override
  String get invalidEmail => 'Некорректный email';

  @override
  String get loginFailed => 'Не удалось войти';

  @override
  String get searchHint => 'Поиск';

  @override
  String get searchRecipesTab => 'Рецепты';

  @override
  String get searchChefsTab => 'Шефы';

  @override
  String get searchTagsTab => 'Теги';

  @override
  String get searchNoRecipes => 'Рецепты не найдены';

  @override
  String get searchNoChefs => 'Шефы не найдены';

  @override
  String get searchNoTags => 'Теги не найдены';

  @override
  String get searchLoadFailure => 'Не удалось загрузить результаты поиска';

  @override
  String get homePopularRecipes => 'Популярные рецепты';

  @override
  String get homeLatestRecipes => 'Новые рецепты';

  @override
  String get homeLoadFailure => 'Не удалось загрузить ленту';

  @override
  String get homeRecipeCardAction => 'Действие карточки рецепта';

  @override
  String get loginTitle => 'Вход';

  @override
  String get loginWelcomeBack => 'С возвращением';

  @override
  String get loginSubtitle => 'Войдите, чтобы продолжить готовить';

  @override
  String get loginEmail => 'Email';

  @override
  String get loginPassword => 'Пароль';

  @override
  String get loginCreateAccount => 'Создать аккаунт';

  @override
  String get authRequiredTitle => 'Требуется вход';

  @override
  String get authRequiredSubtitle =>
      'Войдите, чтобы добавлять рецепты, сохранять избранное и управлять профилем.';

  @override
  String get authContinueWithGoogle => 'Продолжить с Google';

  @override
  String get authContinueWithEmail => 'Продолжить с email';

  @override
  String get authModuleDisabled => 'Модуль авторизации отключен';

  @override
  String get authGoogleProviderDisabled => 'Вход через Google пока не настроен';

  @override
  String get authInvalidCredentials => 'Неверный email или пароль';

  @override
  String get authEmailNotConfirmed => 'Подтвердите email перед входом.';

  @override
  String get authRateLimited => 'Слишком много попыток. Попробуйте позже.';

  @override
  String get authNetworkFailure =>
      'Проверьте подключение к интернету и попробуйте снова.';

  @override
  String get authGoogleSignInFailed => 'Не удалось начать вход через Google';

  @override
  String get authGoogleCallbackFailed =>
      'Не удалось завершить вход через Google';

  @override
  String get authUnexpectedFailure => 'Не удалось выполнить вход';

  @override
  String get registerTitle => 'Регистрация';

  @override
  String get registerWelcome => 'Создайте аккаунт';

  @override
  String get registerSubtitle =>
      'Присоединяйтесь к Milliy Taste, чтобы сохранять рецепты и делиться ими.';

  @override
  String get registerName => 'Имя';

  @override
  String get registerAlreadyHaveAccount => 'Уже есть аккаунт?';

  @override
  String get registerFailed => 'Не удалось зарегистрироваться';

  @override
  String get registerConfirmationRequired =>
      'Проверьте email, чтобы завершить регистрацию.';

  @override
  String get registerPasswordMinLength =>
      'Пароль должен быть не короче 6 символов';

  @override
  String get back => 'Назад';

  @override
  String get saveTitle => 'Сохранено';

  @override
  String get saveTodo => 'TODO: Реализовать сохраненные рецепты';

  @override
  String get saveEmpty => 'Сохраненных рецептов пока нет';

  @override
  String get saveLoadFailure => 'Не удалось загрузить сохраненные рецепты';

  @override
  String get saveActionFailure => 'Не удалось обновить сохраненные рецепты';

  @override
  String get recipesTitle => 'Рецепты';

  @override
  String get recipesEmpty => 'Рецепты не найдены';

  @override
  String get recipeDetailsTodo => 'TODO: Открыть детали рецепта';

  @override
  String get profileModuleDisabled => 'Модуль профиля отключен';

  @override
  String get profileLoadFailure => 'Не удалось загрузить профиль';

  @override
  String get profileRecipesEmpty => 'Рецепты профиля не найдены';

  @override
  String get profileFollowers => 'Подписчики';

  @override
  String get profileFollowing => 'Подписки';

  @override
  String profilePost(int count) {
    return '$count постов';
  }

  @override
  String get profileLessDetails => 'Кратко';

  @override
  String get profileMoreDetails => 'Подробнее';

  @override
  String get profileEditAction => 'Изменить';

  @override
  String get profileLogout => 'Выйти';

  @override
  String get addNewTitle => 'Новый рецепт';

  @override
  String get addNewNext => 'Далее';

  @override
  String get addNewClearAll => 'Очистить все';

  @override
  String get addNewCoverTitle => 'Добавьте обложку рецепта';

  @override
  String get addNewRecent => 'Недавние';

  @override
  String get addNewGalleryAction => 'Выбрать из галереи';

  @override
  String get addNewCameraAction => 'Сделать фото';

  @override
  String get addNewEditCrop => 'Изменить кадрирование';

  @override
  String get addNewRemove => 'Удалить';

  @override
  String get addNewCropCancel => 'Отмена';

  @override
  String get addNewCropDone => 'Готово';

  @override
  String get addNewCropRotate => 'Повернуть фото';

  @override
  String get addNewFieldName => 'Название';

  @override
  String get addNewHintRecipeName => 'Назовите рецепт';

  @override
  String get addNewFieldNumber => 'Количество';

  @override
  String get addNewServingFor => 'Порций';

  @override
  String get addNewPeople => 'Человек';

  @override
  String get addNewCookTime => 'Время готовки';

  @override
  String get addNewDifficulty => 'Сложность';

  @override
  String get addNewDifficultySimple => 'Легко';

  @override
  String get addNewDifficultyMedium => 'Средне';

  @override
  String get addNewDifficultyHard => 'Сложно';

  @override
  String get addNewDishType => 'Тип блюда';

  @override
  String get addNewDietaryTarget => 'Рекомендуемая диета';

  @override
  String get addNewHashtags => 'Хэштеги';

  @override
  String get addNewHintIngredient => 'Добавьте ингредиент';

  @override
  String get addNewHintInstruction => 'Добавьте шаг инструкции';

  @override
  String get addNewSubmitSuccessTitle => 'Рецепт загружен';

  @override
  String get addNewSubmitSuccessSubtitle => 'Ваш рецепт добавлен в профиль.';

  @override
  String get addNewCreateAnother => 'Создать еще';

  @override
  String get recipesLoadFailure => 'Не удалось загрузить рецепты';

  @override
  String get addNewStepRecipeInformation => 'Информация';

  @override
  String get addNewStepIngredients => 'Ингредиенты';

  @override
  String get addNewStepIntroduction => 'Введение';

  @override
  String get addNewStepPreview => 'Предпросмотр';

  @override
  String get addNewDifficultyEasy => 'Легко';

  @override
  String get addNewDishBreakfast => 'Завтрак';

  @override
  String get addNewDishLunch => 'Обед';

  @override
  String get addNewDishSnack => 'Перекус';

  @override
  String get addNewDishBrunch => 'Бранч';

  @override
  String get addNewDishDessert => 'Десерт';

  @override
  String get addNewDishDinner => 'Ужин';

  @override
  String get addNewDishAppetizers => 'Закуски';

  @override
  String get addNewDietVegetarian => 'Вегетарианское';

  @override
  String get addNewDietHighFat => 'Много жиров';

  @override
  String get addNewDietLowFat => 'Мало жиров';

  @override
  String get addNewDietSugarFree => 'Без сахара';

  @override
  String get addNewDietLactoseFree => 'Без лактозы';

  @override
  String get addNewDietGlutenFree => 'Без глютена';

  @override
  String get addNewPreviewIntroduction => 'Введение';

  @override
  String get addNewPreviewIngredients => 'Ингредиенты';

  @override
  String get addNewPreviewComments => 'Комментарии';

  @override
  String addNewStepsCount(int count) {
    return '$count шагов';
  }

  @override
  String addNewIngredientsCount(int count) {
    return '$count ингредиентов';
  }

  @override
  String addNewCommentsCount(int count) {
    return '$count комментариев';
  }

  @override
  String get addNewInstructionPlaceholder => 'Текст шага инструкции...';

  @override
  String get addNewIngredientPlaceholder => 'Название ингредиента...';

  @override
  String get addNewRecipeTitleFallback => 'Идеальные домашние панкейки';

  @override
  String get addNewHeadlineTagFallback => 'Низкокалорийно';

  @override
  String get ok => 'OK';
}
