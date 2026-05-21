abstract final class RouteNames {
  static const splash = '/splash';
  static const onboarding = '/onboarding';
  static const home = '/home';
  static const search = '/search';
  static const addNew = '/add-new';
  static const save = '/save';
  static const recipes = '/recipes';
  static const recipeDetailPath = '/recipes/:id';

  static String recipeDetail(String id) => '/recipes/$id';
  static const settings = '/settings';

  static const login = '/login';
  static const register = '/register';
  static const verifyEmail = '/verify-email';
  static const profile = '/profile';
}
