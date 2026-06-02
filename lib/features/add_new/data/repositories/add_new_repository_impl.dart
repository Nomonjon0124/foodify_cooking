import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/utils/result.dart';
import '../../domain/entities/create_recipe_draft.dart';
import '../../domain/repositories/add_new_repository.dart';
import '../data_sources/add_new_remote_data_source.dart';

class AddNewRepositoryImpl implements AddNewRepository {
  AddNewRepositoryImpl(this._remoteDataSource);

  final AddNewRemoteDataSource _remoteDataSource;

  @override
  Future<Result<String>> createRecipe(CreateRecipeDraft draft) async {
    try {
      final recipeId = await _remoteDataSource.createRecipe(draft);
      return Success<String>(recipeId);
    } on AuthException catch (error) {
      return Failure<String>(error.message);
    } on StorageException catch (error) {
      return Failure<String>(error.message);
    } on PostgrestException catch (error) {
      return Failure<String>(error.message);
    } catch (_) {
      return const Failure<String>('Unable to create recipe');
    }
  }
}
