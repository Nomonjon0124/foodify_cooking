import '../../domain/repositories/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  @override
  Future<List<String>> getFeaturedCollections() async {
    // TODO: Replace static feed with API + local cache strategy.
    return const <String>[
      'Quick Breakfast',
      'Healthy Lunch',
      'Dinner in 30 Minutes',
    ];
  }
}
