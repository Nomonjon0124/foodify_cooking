import '../entities/home_feed.dart';

abstract interface class HomeRepository {
  Future<HomeFeed> getHomeFeed();
}
