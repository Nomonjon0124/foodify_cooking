import 'package:equatable/equatable.dart';

enum HomeStatus { initial, loading, success, failure }

class HomeState extends Equatable {
  const HomeState({
    this.status = HomeStatus.initial,
    this.collections = const <String>[],
    this.errorMessage,
  });

  final HomeStatus status;
  final List<String> collections;
  final String? errorMessage;

  HomeState copyWith({
    HomeStatus? status,
    List<String>? collections,
    String? errorMessage,
  }) {
    return HomeState(
      status: status ?? this.status,
      collections: collections ?? this.collections,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, collections, errorMessage];
}
