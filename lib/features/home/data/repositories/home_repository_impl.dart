import '../../domain/entities/home_feed.dart';
import '../../domain/repositories/home_repository.dart';
import '../data_sources/home_remote_data_source.dart';

class HomeRepositoryImpl implements HomeRepository {
  HomeRepositoryImpl(this._remoteDataSource);

  final HomeRemoteDataSource _remoteDataSource;

  @override
  Future<HomeFeed> getHomeFeed() {
    return _remoteDataSource.getHomeFeed();
  }
}
