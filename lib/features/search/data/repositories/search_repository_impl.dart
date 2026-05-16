import '../../domain/entities/search_results.dart';
import '../../domain/repositories/search_repository.dart';
import '../data_sources/search_remote_data_source.dart';

class SearchRepositoryImpl implements SearchRepository {
  SearchRepositoryImpl(this._remoteDataSource);

  final SearchRemoteDataSource _remoteDataSource;

  @override
  Future<SearchResults> search(String query) {
    return _remoteDataSource.search(query);
  }
}
