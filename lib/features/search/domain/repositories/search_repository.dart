import '../entities/search_results.dart';

abstract interface class SearchRepository {
  Future<SearchResults> search(String query);
}
