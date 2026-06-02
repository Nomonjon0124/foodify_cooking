import '../../../../core/utils/result.dart';
import '../entities/create_recipe_draft.dart';

abstract interface class AddNewRepository {
  Future<Result<String>> createRecipe(CreateRecipeDraft draft);
}
