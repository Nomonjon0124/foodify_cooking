import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../app/cubit/app_shell_cubit.dart';
import '../../app/cubit/app_start_cubit.dart';
import '../constants/storage_keys.dart';
import '../../features/auth/data/data_sources/auth_local_data_source.dart';
import '../../features/auth/data/data_sources/auth_remote_data_source.dart';
import '../../features/auth/data/data_sources/profile_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/data/repositories/profile_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/repositories/profile_repository.dart';
import '../../features/auth/domain/usecases/get_current_user_usecase.dart';
import '../../features/auth/domain/usecases/get_current_profile_usecase.dart';
import '../../features/auth/domain/usecases/get_demo_profile_usecase.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/domain/usecases/logout_usecase.dart';
import '../../features/auth/domain/usecases/register_usecase.dart';
import '../../features/auth/domain/usecases/sign_in_with_google_usecase.dart';
import '../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../features/auth/presentation/cubit/login_cubit.dart';
import '../../features/auth/presentation/cubit/profile_cubit.dart';
import '../../features/auth/presentation/cubit/register_cubit.dart';
import '../../features/home/data/data_sources/home_remote_data_source.dart';
import '../../features/home/data/repositories/home_repository_impl.dart';
import '../../features/home/domain/repositories/home_repository.dart';
import '../../features/home/domain/usecases/get_home_feed_usecase.dart';
import '../../features/home/presentation/cubit/home_cubit.dart';
import '../../features/onboarding/presentation/cubit/onboarding_cubit.dart';
import '../../features/recipe/data/repositories/recipe_repository_impl.dart';
import '../../features/recipe/domain/repositories/recipe_repository.dart';
import '../../features/recipe/domain/usecases/get_popular_recipes_usecase.dart';
import '../../features/recipe/presentation/cubit/recipe_cubit.dart';
import '../../features/search/data/data_sources/search_remote_data_source.dart';
import '../../features/search/data/repositories/search_repository_impl.dart';
import '../../features/search/domain/repositories/search_repository.dart';
import '../../features/search/presentation/cubit/search_cubit.dart';
import '../../features/save/data/data_sources/saved_recipes_remote_data_source.dart';
import '../../features/save/data/repositories/saved_recipes_repository_impl.dart';
import '../../features/save/domain/repositories/saved_recipes_repository.dart';
import '../../features/save/domain/usecases/get_saved_recipe_ids_usecase.dart';
import '../../features/save/domain/usecases/get_saved_recipes_usecase.dart';
import '../../features/save/domain/usecases/save_recipe_usecase.dart';
import '../../features/save/domain/usecases/unsave_recipe_usecase.dart';
import '../../features/save/presentation/cubit/saved_recipes_cubit.dart';
import '../../features/settings/presentation/cubit/settings_cubit.dart';
import '../../features/splash/presentation/cubit/splash_cubit.dart';
import '../network/dio_client.dart';
import '../network/dio_factory.dart';
import '../network/interceptors/auth_interceptor.dart';
import '../network/interceptors/logging_interceptor.dart';
import '../network/interceptors/retry_interceptor.dart';
import '../network/network_info.dart';
import '../services/connectivity_service.dart';
import '../services/logger_service.dart';
import '../services/storage_service.dart';
import '../services/supabase_service.dart';
import '../services/token_service.dart';

final GetIt getIt = GetIt.instance;

Future<void> configureDependencies({bool enableAuthFeature = true}) async {
  if (getIt.isRegistered<Dio>()) return;

  await _registerCoreDependencies();
  _registerHomeDependencies();
  _registerOnboardingDependencies();
  _registerRecipeDependencies();
  _registerSearchDependencies();
  _registerSettingsDependencies();
  _registerSplashDependencies();
  if (enableAuthFeature) {
    _registerAuthDependencies();
  }
}

Future<void> _registerCoreDependencies() async {
  final storageService = await StorageService.persistent(
    allowList: StorageKeys.all,
  );

  getIt
    ..registerLazySingleton<StorageService>(() => storageService)
    ..registerLazySingleton<TokenService>(() => TokenService(getIt()))
    ..registerLazySingleton<LoggerService>(LoggerService.new)
    ..registerLazySingleton<ConnectivityService>(ConnectivityService.new)
    ..registerLazySingleton<SupabaseClient>(() => SupabaseService.client)
    ..registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(getIt()))
    ..registerFactory<AppStartCubit>(() => AppStartCubit(getIt()))
    ..registerLazySingleton<AppShellCubit>(AppShellCubit.new);

  final dio = DioFactory.create()
    ..interceptors.addAll([
      LoggingInterceptor(getIt()),
      AuthInterceptor(getIt()),
      RetryInterceptor(),
    ]);

  getIt
    ..registerLazySingleton<Dio>(() => dio)
    ..registerLazySingleton<DioClient>(() => DioClient(getIt()));
}

void _registerHomeDependencies() {
  getIt
    ..registerLazySingleton<HomeRemoteDataSource>(
      () => SupabaseHomeRemoteDataSource(() => getIt<SupabaseClient>()),
    )
    ..registerLazySingleton<HomeRepository>(() => HomeRepositoryImpl(getIt()))
    ..registerLazySingleton<GetHomeFeedUseCase>(
      () => GetHomeFeedUseCase(getIt()),
    )
    ..registerFactory<HomeCubit>(() => HomeCubit(getIt()));
}

void _registerOnboardingDependencies() {
  getIt.registerFactory<OnboardingCubit>(() => OnboardingCubit(getIt()));
}

void _registerRecipeDependencies() {
  getIt
    ..registerLazySingleton<RecipeRepository>(RecipeRepositoryImpl.new)
    ..registerLazySingleton<GetPopularRecipesUseCase>(
      () => GetPopularRecipesUseCase(getIt()),
    )
    ..registerFactory<RecipeCubit>(() => RecipeCubit(getIt()));
}

void _registerSearchDependencies() {
  getIt
    ..registerLazySingleton<SearchRemoteDataSource>(
      () => SupabaseSearchRemoteDataSource(() => getIt<SupabaseClient>()),
    )
    ..registerLazySingleton<SearchRepository>(
      () => SearchRepositoryImpl(getIt()),
    )
    ..registerFactory<SearchCubit>(() => SearchCubit(getIt()));
}

void _registerSettingsDependencies() {
  getIt.registerLazySingleton<SettingsCubit>(() => SettingsCubit(getIt()));
}

void _registerSplashDependencies() {
  getIt.registerFactory<SplashCubit>(SplashCubit.new);
}

void _registerAuthDependencies() {
  getIt
    ..registerLazySingleton<AuthRemoteDataSource>(
      () => SupabaseAuthRemoteDataSource(
        () => getIt<SupabaseClient>(),
        getIt<LoggerService>(),
        getIt<Dio>(),
      ),
    )
    ..registerLazySingleton<AuthLocalDataSource>(
      () => AuthLocalDataSourceImpl(getIt()),
    )
    ..registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(
        remoteDataSource: getIt(),
        localDataSource: getIt(),
        tokenService: getIt(),
        networkInfo: getIt(),
        logger: getIt(),
      ),
    )
    ..registerLazySingleton<LoginUseCase>(() => LoginUseCase(getIt()))
    ..registerLazySingleton<RegisterUseCase>(() => RegisterUseCase(getIt()))
    ..registerLazySingleton<LogoutUseCase>(() => LogoutUseCase(getIt()))
    ..registerLazySingleton<SignInWithGoogleUseCase>(
      () => SignInWithGoogleUseCase(getIt()),
    )
    ..registerLazySingleton<GetCurrentUserUseCase>(
      () => GetCurrentUserUseCase(getIt()),
    )
    ..registerLazySingleton<ProfileRemoteDataSource>(
      () => SupabaseProfileRemoteDataSource(() => getIt<SupabaseClient>()),
    )
    ..registerLazySingleton<ProfileRepository>(
      () => ProfileRepositoryImpl(getIt()),
    )
    ..registerLazySingleton<GetDemoProfileUseCase>(
      () => GetDemoProfileUseCase(getIt()),
    )
    ..registerLazySingleton<GetCurrentProfileUseCase>(
      () => GetCurrentProfileUseCase(getIt()),
    )
    ..registerLazySingleton<SavedRecipesRemoteDataSource>(
      () => SupabaseSavedRecipesRemoteDataSource(() => getIt<SupabaseClient>()),
    )
    ..registerLazySingleton<SavedRecipesRepository>(
      () => SavedRecipesRepositoryImpl(getIt()),
    )
    ..registerLazySingleton<GetSavedRecipesUseCase>(
      () => GetSavedRecipesUseCase(getIt()),
    )
    ..registerLazySingleton<GetSavedRecipeIdsUseCase>(
      () => GetSavedRecipeIdsUseCase(getIt()),
    )
    ..registerLazySingleton<SaveRecipeUseCase>(() => SaveRecipeUseCase(getIt()))
    ..registerLazySingleton<UnsaveRecipeUseCase>(
      () => UnsaveRecipeUseCase(getIt()),
    )
    ..registerFactory<LoginCubit>(() => LoginCubit(getIt()))
    ..registerFactory<RegisterCubit>(() => RegisterCubit(getIt()))
    ..registerFactory<ProfileCubit>(() => ProfileCubit(getIt()))
    ..registerLazySingleton<SavedRecipesCubit>(
      () => SavedRecipesCubit(
        getSavedRecipesUseCase: getIt(),
        getSavedRecipeIdsUseCase: getIt(),
        saveRecipeUseCase: getIt(),
        unsaveRecipeUseCase: getIt(),
      ),
    )
    ..registerLazySingleton<AuthCubit>(
      () => AuthCubit(
        authRepository: getIt(),
        getCurrentUserUseCase: getIt(),
        logoutUseCase: getIt(),
        signInWithGoogleUseCase: getIt(),
        storageService: getIt(),
      ),
    );
}
