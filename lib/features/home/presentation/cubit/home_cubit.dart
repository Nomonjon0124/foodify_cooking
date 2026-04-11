import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecases/no_params.dart';
import '../../domain/usecases/get_home_feed_usecase.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this._getHomeFeedUseCase) : super(const HomeState());

  final GetHomeFeedUseCase _getHomeFeedUseCase;

  Future<void> loadHome() async {
    emit(state.copyWith(status: HomeStatus.loading));
    try {
      final collections = await _getHomeFeedUseCase(const NoParams());
      emit(
        state.copyWith(status: HomeStatus.success, collections: collections),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: HomeStatus.failure,
          errorMessage: 'Failed to load home feed',
        ),
      );
    }
  }
}
