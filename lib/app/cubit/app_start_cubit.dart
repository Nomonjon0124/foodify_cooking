import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/constants/storage_keys.dart';
import '../../core/services/storage_service.dart';
import 'app_start_state.dart';

class AppStartCubit extends Cubit<AppStartState> {
  AppStartCubit(this._storageService) : super(const AppStartState());

  final StorageService _storageService;

  Future<void> initialize() async {
    emit(state.copyWith(status: AppStartStatus.loading));
    try {
      // TODO: Expand startup checks (remote config, migrations, locale, theme).
      _storageService.getString(StorageKeys.authToken);
      emit(state.copyWith(status: AppStartStatus.ready));
    } catch (_) {
      emit(
        state.copyWith(
          status: AppStartStatus.failure,
          errorMessage: 'App initialization failed',
        ),
      );
    }
  }
}
