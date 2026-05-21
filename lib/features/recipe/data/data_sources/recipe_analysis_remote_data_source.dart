import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/recipe_analysis_model.dart';

abstract interface class RecipeAnalysisRemoteDataSource {
  Future<RecipeAnalysisModel> analyze({
    required String recipeId,
    required String locale,
  });
}

class SupabaseRecipeAnalysisRemoteDataSource
    implements RecipeAnalysisRemoteDataSource {
  SupabaseRecipeAnalysisRemoteDataSource(this._readClient);

  final SupabaseClient Function() _readClient;

  static const _functionName = 'analyze-recipe';

  @override
  Future<RecipeAnalysisModel> analyze({
    required String recipeId,
    required String locale,
  }) async {
    final client = _readClient();
    final response = await client.functions.invoke(
      _functionName,
      body: {'recipe_id': recipeId, 'locale': locale},
    );

    final status = response.status;
    if (status >= 400) {
      final data = response.data;
      final message = data is Map && data['error'] is String
          ? data['error'] as String
          : 'analyze-recipe failed with status $status';
      throw FunctionException(
        status: status,
        details: message,
        reasonPhrase: message,
      );
    }

    final data = response.data;
    if (data is! Map) {
      throw const FormatException('analyze-recipe: unexpected payload');
    }
    return RecipeAnalysisModel.fromInvokeResponse(
      Map<String, dynamic>.from(data),
    );
  }
}
