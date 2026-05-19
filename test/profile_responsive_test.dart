import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:foodify_cooking/core/di/injection_container.dart';
import 'package:foodify_cooking/core/services/storage_service.dart';
import 'package:foodify_cooking/core/utils/result.dart';
import 'package:foodify_cooking/features/auth/domain/entities/profile_view.dart';
import 'package:foodify_cooking/features/auth/domain/entities/user_entity.dart';
import 'package:foodify_cooking/features/auth/domain/repositories/profile_repository.dart';
import 'package:foodify_cooking/features/auth/domain/repositories/auth_repository.dart';
import 'package:foodify_cooking/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:foodify_cooking/features/auth/domain/usecases/logout_usecase.dart';
import 'package:foodify_cooking/features/auth/domain/usecases/sign_in_with_google_usecase.dart';
import 'package:foodify_cooking/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:foodify_cooking/features/auth/presentation/cubit/auth_state.dart';
import 'package:foodify_cooking/features/auth/presentation/pages/profile_page.dart';
import 'package:foodify_cooking/features/auth/presentation/widgets/profile_recipe_card.dart';
import 'package:foodify_cooking/l10n/generated/app_localizations.dart';

void main() {
  setUpAll(() async {
    await configureDependencies();
    if (getIt.isRegistered<ProfileRepository>()) {
      await getIt.unregister<ProfileRepository>();
    }
    if (getIt.isRegistered<AuthCubit>()) {
      await getIt.unregister<AuthCubit>();
    }
    getIt.registerLazySingleton<ProfileRepository>(
      _ResponsiveProfileRepository.new,
    );
    getIt.registerLazySingleton<AuthCubit>(_AuthenticatedAuthCubit.new);
  });

  tearDownAll(() async {
    await getIt.reset();
  });

  testWidgets(
    'Uzbek Profile detailed tab keeps long content inside padded cards',
    (tester) async {
      await _pumpProfile(tester, const Size(320, 640));

      expect(find.text('Qisqa tafsilotlar'), findsOneWidget);

      await tester.tap(find.text('Batafsil'));
      await tester.pumpAndSettle();

      expect(find.text('Tahrirlash'), findsOneWidget);
      expect(find.byType(ProfileRecipeCard), findsOneWidget);

      final cardRect = tester.getRect(find.byType(ProfileRecipeCard));
      final horizontalInsets = 320 - cardRect.right;

      expect(cardRect.left, closeTo(horizontalInsets, 1));
      expect(cardRect.left, greaterThan(15));
      expect(cardRect.right, lessThan(305));
      expect(tester.takeException(), isNull);
    },
  );
}

Future<void> _pumpProfile(WidgetTester tester, Size size) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = size;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  await tester.pumpWidget(
    ScreenUtilInit(
      designSize: const Size(360, 800),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, _) {
        return MaterialApp(
          locale: const Locale('uz'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const ProfilePage(),
        );
      },
    ),
  );
  await tester.pumpAndSettle();
}

class _AuthenticatedAuthCubit extends AuthCubit {
  _AuthenticatedAuthCubit()
    : super(
        authRepository: _AuthRepository(),
        getCurrentUserUseCase: GetCurrentUserUseCase(_AuthRepository()),
        logoutUseCase: LogoutUseCase(_AuthRepository()),
        signInWithGoogleUseCase: SignInWithGoogleUseCase(_AuthRepository()),
        storageService: StorageService(),
      ) {
    emit(
      const AuthState(
        status: AuthStatus.authenticated,
        user: UserEntity(
          id: 'user-responsive',
          email: 'profile@test.local',
          name: 'Profile Tester',
        ),
      ),
    );
  }
}

class _AuthRepository implements AuthRepository {
  static const _user = UserEntity(
    id: 'user-responsive',
    email: 'profile@test.local',
    name: 'Profile Tester',
  );

  @override
  Stream<UserEntity?> authStateChanges() => const Stream<UserEntity?>.empty();

  @override
  Future<Result<UserEntity?>> getCurrentUser() async {
    return const Success<UserEntity?>(_user);
  }

  @override
  Future<Result<UserEntity>> login({
    required String email,
    required String password,
  }) async {
    return const Success<UserEntity>(_user);
  }

  @override
  Future<Result<void>> logout() async => const Success<void>(null);

  @override
  Future<Result<UserEntity>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    return const Success<UserEntity>(_user);
  }

  @override
  Future<Result<void>> signInWithGoogle({required String redirectTo}) async {
    return const Success<void>(null);
  }
}

class _ResponsiveProfileRepository implements ProfileRepository {
  @override
  Future<ProfileView> getCurrentProfile() async {
    return const ProfileView(
      id: 'profile-responsive',
      displayName: 'Mark Salvador bilan juda uzun oshpaz profili',
      location: "Toshkent, O'zbekiston va xalqaro oshxona studiyasi",
      bio:
          "Oddiy mahsulotlar bilan katta va batafsil retseptlar yaratishni yaxshi ko'radigan oshpaz.",
      avatarUrl: '',
      coverImageUrl: '',
      ratingLabel: '5.0',
      followersLabel: '357K',
      followingLabel: '24',
      postsCount: 18,
      recipes: [
        ProfileRecipe(
          id: 'recipe-responsive',
          title:
              'Chocolate cake with buttercream frosting and seasonal fruit decoration',
          chefName: 'Mark Salvador bilan juda uzun oshpaz nomi',
          ratingLabel: '4.8',
          durationLabel: '120 Min',
          difficultyLabel: 'Professional daraja',
          description:
              'A rich chocolate cake with layered cream, fruit, and a long description that should stay inside the detailed profile card.',
          imageUrl: '',
          chefAvatarUrl: '',
        ),
      ],
    );
  }

  @override
  Future<ProfileView> getDemoProfile() => getCurrentProfile();
}
