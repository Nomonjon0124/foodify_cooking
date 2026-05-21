import 'package:flutter_test/flutter_test.dart';
import 'package:foodify_cooking/core/utils/result.dart';
import 'package:foodify_cooking/features/recipe/data/data_sources/recipe_detail_remote_data_source.dart';
import 'package:foodify_cooking/features/recipe/data/models/recipe_detail_model.dart';
import 'package:foodify_cooking/features/recipe/data/repositories/recipe_repository_impl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  group('RecipeRepositoryImpl', () {
    test('returns Success on happy path', () async {
      final data = _detail();
      final repo = RecipeRepositoryImpl(_FakeDataSource(detail: data));

      final result = await repo.getRecipeDetail('r-1');

      expect(result, isA<Success>());
      result.fold((_) => fail('expected success'), (detail) {
        expect(detail.id, 'r-1');
        expect(detail.likesCount, 7);
      });
    });

    test('returns Failure when data source throws AuthException', () async {
      final repo = RecipeRepositoryImpl(
        _FakeDataSource(error: AuthException('Login required')),
      );

      final result = await repo.getRecipeDetail('r-1');

      expect(result, isA<Failure>());
      result.fold(
        (message) => expect(message, contains('Login required')),
        (_) => fail('expected failure'),
      );
    });

    test('toggleLike maps result to RecipeLikeToggle', () async {
      final repo = RecipeRepositoryImpl(
        _FakeDataSource(
          toggleResult: const RecipeLikeToggleResult(
            isLiked: true,
            likesCount: 12,
          ),
        ),
      );

      final result = await repo.toggleLike('r-1');

      result.fold((_) => fail('expected success'), (toggle) {
        expect(toggle.isLiked, isTrue);
        expect(toggle.likesCount, 12);
      });
    });
  });
}

RecipeDetailModel _detail() {
  return const RecipeDetailModel(
    id: 'r-1',
    title: 'Pancake',
    coverImageUrl: 'https://example.com/p.png',
    ratingLabel: '4.5',
    likesCount: 7,
    commentsCount: 0,
    isLikedByMe: false,
    isSavedByMe: false,
    tags: [],
    ingredients: [],
    instructions: [],
    comments: [],
  );
}

class _FakeDataSource implements RecipeDetailRemoteDataSource {
  _FakeDataSource({this.detail, this.error, this.toggleResult});

  final RecipeDetailModel? detail;
  final Object? error;
  final RecipeLikeToggleResult? toggleResult;

  @override
  Future<RecipeDetailModel> getRecipeDetail(String recipeId) async {
    final err = error;
    if (err != null) throw err;
    return detail!;
  }

  @override
  Future<RecipeLikeToggleResult> toggleLike(String recipeId) async {
    final err = error;
    if (err != null) throw err;
    return toggleResult!;
  }
}
