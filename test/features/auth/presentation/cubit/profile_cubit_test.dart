import 'package:flutter_test/flutter_test.dart';
import 'package:foodify_cooking/features/auth/domain/entities/profile_view.dart';
import 'package:foodify_cooking/features/auth/domain/repositories/profile_repository.dart';
import 'package:foodify_cooking/features/auth/domain/usecases/get_current_profile_usecase.dart';
import 'package:foodify_cooking/features/auth/presentation/cubit/profile_cubit.dart';
import 'package:foodify_cooking/features/auth/presentation/cubit/profile_state.dart';

void main() {
  group('ProfileCubit', () {
    test('emits success when current profile loads', () async {
      const profile = ProfileView(
        id: 'profile-1',
        displayName: 'Nomonjon Toychiyev',
        location: 'Tashkent, Uzbekistan',
        bio: 'Default profile bio',
        avatarUrl: 'https://example.com/avatar.png',
        coverImageUrl: 'https://example.com/cover.png',
        ratingLabel: '5.0',
        followersLabel: '0',
        followingLabel: '0',
        postsCount: 1,
        recipes: [
          ProfileRecipe(
            id: 'recipe-1',
            title: 'Egg rolls',
            chefName: 'Mark Salvador',
            ratingLabel: '4.8',
            durationLabel: '30 Min',
            difficultyLabel: 'Medium',
            description: 'Default fallback recipe.',
            imageUrl: 'https://example.com/recipe.png',
            chefAvatarUrl: 'https://example.com/chef.png',
          ),
        ],
      );
      final cubit = ProfileCubit(
        GetCurrentProfileUseCase(_SuccessfulProfileRepository(profile)),
      );
      addTearDown(cubit.close);

      await cubit.loadProfile();

      expect(cubit.state.status, ProfileStatus.success);
      expect(cubit.state.profile, profile);
      expect(cubit.state.errorMessage, isNull);
    });

    test(
      'emits profile load failure when current profile data fails',
      () async {
        final cubit = ProfileCubit(
          GetCurrentProfileUseCase(_FailingProfileRepository()),
        );
        addTearDown(cubit.close);

        await cubit.loadProfile();

        expect(cubit.state.status, ProfileStatus.failure);
        expect(cubit.state.profile, isNull);
        expect(cubit.state.errorMessage, isNull);
      },
    );
  });
}

class _FailingProfileRepository implements ProfileRepository {
  @override
  Future<ProfileView> getCurrentProfile() {
    throw StateError('profiles insert denied');
  }

  @override
  Future<ProfileView> getDemoProfile() => getCurrentProfile();
}

class _SuccessfulProfileRepository implements ProfileRepository {
  const _SuccessfulProfileRepository(this.profile);

  final ProfileView profile;

  @override
  Future<ProfileView> getCurrentProfile() async => profile;

  @override
  Future<ProfileView> getDemoProfile() => getCurrentProfile();
}
