import 'package:equatable/equatable.dart';

import '../../domain/entities/home_feed.dart';

enum HomeStatus { initial, loading, success, failure }

class HomeState extends Equatable {
  const HomeState({
    this.status = HomeStatus.initial,
    this.feed = const HomeFeed.empty(),
    this.errorMessage,
  });

  final HomeStatus status;
  final HomeFeed feed;
  final String? errorMessage;

  HomeState copyWith({
    HomeStatus? status,
    HomeFeed? feed,
    String? errorMessage,
  }) {
    return HomeState(
      status: status ?? this.status,
      feed: feed ?? this.feed,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, feed, errorMessage];
}
