import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:foodify_cooking/core/utils/result.dart';
import 'package:foodify_cooking/features/add_new/data/data_sources/add_new_remote_data_source.dart';
import 'package:foodify_cooking/features/add_new/data/repositories/add_new_repository_impl.dart';
import 'package:foodify_cooking/features/add_new/domain/entities/create_recipe_draft.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  group('AddNewRepositoryImpl', () {
    test('returns created recipe id on success', () async {
      final repo = AddNewRepositoryImpl(_FakeDataSource(recipeId: 'r-1'));

      final result = await repo.createRecipe(_draft());

      expect(result, isA<Success<String>>());
      result.fold(
        (_) => fail('expected success'),
        (recipeId) => expect(recipeId, 'r-1'),
      );
    });

    test('maps Supabase errors to Failure', () async {
      final repo = AddNewRepositoryImpl(
        _FakeDataSource(error: StorageException('Upload failed')),
      );

      final result = await repo.createRecipe(_draft());

      expect(result, isA<Failure<String>>());
      result.fold(
        (message) => expect(message, 'Upload failed'),
        (_) => fail('expected failure'),
      );
    });
  });
}

CreateRecipeDraft _draft() {
  return CreateRecipeDraft(
    title: 'Soup',
    description: 'Warm',
    durationMinutes: 30,
    difficulty: 'Simple',
    coverImageBytes: Uint8List.fromList([1, 2, 3]),
    coverImageName: 'soup.jpg',
    coverImageMimeType: 'image/jpeg',
    ingredients: const ['Water'],
    instructions: const ['Boil'],
    tags: const ['Dinner'],
  );
}

class _FakeDataSource implements AddNewRemoteDataSource {
  _FakeDataSource({this.recipeId, this.error});

  final String? recipeId;
  final Object? error;

  @override
  Future<String> createRecipe(CreateRecipeDraft draft) async {
    final err = error;
    if (err != null) throw err;
    return recipeId!;
  }
}
