import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/search_results_model.dart';

abstract interface class SearchRemoteDataSource {
  Future<SearchResultsModel> search(String query);
}

class SupabaseSearchRemoteDataSource implements SearchRemoteDataSource {
  SupabaseSearchRemoteDataSource(this._readClient);

  final SupabaseClient Function() _readClient;

  @override
  Future<SearchResultsModel> search(String query) async {
    final normalizedQuery = _normalizeQuery(query);

    final results = await Future.wait<Object>([
      _fetchRecipes(normalizedQuery),
      _fetchChefs(normalizedQuery),
      _fetchTags(normalizedQuery),
    ]);

    return SearchResultsModel(
      recipes: results[0] as List<SearchRecipeModel>,
      chefs: results[1] as List<SearchChefModel>,
      tags: results[2] as List<SearchTagModel>,
    );
  }

  Future<List<SearchRecipeModel>> _fetchRecipes(String query) async {
    final builder = _readClient()
        .from('recipes')
        .select('id,title,rating,cover_image_url')
        .eq('is_profile_visible', true);

    final rows = query.isEmpty
        ? await builder
              .order('search_sort_order', nullsFirst: false)
              .order('created_at', ascending: false)
              .limit(20)
        : await builder
              .or('title.ilike.%$query%,description.ilike.%$query%')
              .order('search_sort_order', nullsFirst: false)
              .order('created_at', ascending: false)
              .limit(20);

    return rows
        .whereType<Map<String, dynamic>>()
        .map(SearchRecipeModel.fromJson)
        .toList();
  }

  Future<List<SearchChefModel>> _fetchChefs(String query) async {
    final builder = _readClient()
        .from('profiles')
        .select('id,display_name,avatar_url')
        .eq('is_search_featured', true);

    final rows = query.isEmpty
        ? await builder.order('search_sort_order', nullsFirst: false).limit(20)
        : await builder
              .or(
                'display_name.ilike.%$query%,location.ilike.%$query%,bio.ilike.%$query%',
              )
              .order('search_sort_order', nullsFirst: false)
              .limit(20);

    return rows
        .whereType<Map<String, dynamic>>()
        .map(SearchChefModel.fromJson)
        .toList();
  }

  Future<List<SearchTagModel>> _fetchTags(String query) async {
    final builder = _readClient()
        .from('tags')
        .select('id,display_name')
        .eq('is_active', true);

    final rows = query.isEmpty
        ? await builder.order('sort_order', nullsFirst: false).limit(20)
        : await builder
              .or('display_name.ilike.%$query%,slug.ilike.%$query%')
              .order('sort_order', nullsFirst: false)
              .limit(20);

    return rows
        .whereType<Map<String, dynamic>>()
        .map(SearchTagModel.fromJson)
        .toList();
  }
}

String _normalizeQuery(String query) {
  return query.trim().replaceAll(',', ' ');
}
