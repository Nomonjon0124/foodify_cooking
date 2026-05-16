import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecases/no_params.dart';
import '../../domain/usecases/get_demo_profile_usecase.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit(this._getDemoProfileUseCase) : super(const ProfileState());

  final GetDemoProfileUseCase _getDemoProfileUseCase;

  Future<void> loadProfile() async {
    emit(state.copyWith(status: ProfileStatus.loading));
    try {
      final profile = await _getDemoProfileUseCase(const NoParams());
      emit(state.copyWith(status: ProfileStatus.success, profile: profile));
    } catch (_) {
      emit(state.copyWith(status: ProfileStatus.failure));
    }
  }
}
