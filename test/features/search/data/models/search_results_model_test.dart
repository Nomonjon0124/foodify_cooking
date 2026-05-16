import 'package:flutter_test/flutter_test.dart';
import 'package:foodify_cooking/features/search/data/models/search_results_model.dart';

void main() {
  group('Search result models', () {
    test('maps recipe json to UI labels', () {
      final model = SearchRecipeModel.fromJson({
        'id': 'recipe-1',
        'title': 'Egg rolls',
        'rating': 4.75,
        'cover_image_url': 'https://example.com/egg.png',
      });

      expect(model.id, 'recipe-1');
      expect(model.title, 'Egg rolls');
      expect(model.ratingLabel, '4.8');
      expect(model.imageUrl, 'https://example.com/egg.png');
    });

    test('maps chef and tag json', () {
      final chef = SearchChefModel.fromJson({
        'id': 'chef-1',
        'display_name': 'Mark Salvador',
        'avatar_url': 'https://example.com/avatar.png',
      });
      final tag = SearchTagModel.fromJson({
        'id': 'tag-1',
        'display_name': '#egg',
      });

      expect(chef.name, 'Mark Salvador');
      expect(chef.avatarUrl, 'https://example.com/avatar.png');
      expect(tag.displayName, '#egg');
    });
  });
}
