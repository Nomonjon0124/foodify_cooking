import 'package:flutter_test/flutter_test.dart';
import 'package:foodify_cooking/features/auth/domain/entities/profile_view.dart';
import 'package:foodify_cooking/features/auth/domain/repositories/profile_repository.dart';
import 'package:foodify_cooking/features/auth/domain/usecases/get_current_profile_usecase.dart';
import 'package:foodify_cooking/features/auth/presentation/cubit/profile_cubit.dart';
import 'package:foodify_cooking/features/auth/presentation/cubit/profile_state.dart';

void main() {
  group('ProfileCubit', () {
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
