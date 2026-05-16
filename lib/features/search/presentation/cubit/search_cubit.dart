import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/debouncer.dart';
import '../../domain/entities/search_results.dart';
import '../../domain/repositories/search_repository.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit(this._repository) : super(const SearchState());

  final SearchRepository _repository;
  final Debouncer _debouncer = Debouncer(
    duration: const Duration(milliseconds: 250),
  );
  int _requestId = 0;

  Future<void> loadInitial() {
    return _runSearch('');
  }

  void updateQuery(String query) {
    final requestId = ++_requestId;
    emit(state.copyWith(query: query, status: SearchStatus.loading));

    _debouncer.run(() {
      _runSearch(query, requestId: requestId);
    });
  }

  Future<void> _runSearch(String query, {int? requestId}) async {
    final currentRequestId = requestId ?? ++_requestId;
    emit(state.copyWith(query: query, status: SearchStatus.loading));

    try {
      final results = await _repository.search(query);
      if (currentRequestId != _requestId) return;

      emit(
        state.copyWith(
          status: SearchStatus.success,
          results: results,
          errorMessage: '',
        ),
      );
    } catch (_) {
      if (currentRequestId != _requestId) return;

      emit(
        state.copyWith(
          status: SearchStatus.failure,
          errorMessage: 'Failed to load search results',
        ),
      );
    }
  }

  @override
  Future<void> close() {
    _debouncer.dispose();
    return super.close();
  }
}
