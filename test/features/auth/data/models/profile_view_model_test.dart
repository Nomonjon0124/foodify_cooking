import 'package:flutter_test/flutter_test.dart';
import 'package:foodify_cooking/features/auth/data/models/profile_view_model.dart';

void main() {
  group('ProfileViewModel', () {
    test('maps profile and recipe json to display labels', () {
      final model = ProfileViewModel.fromJson(
        profileJson: {
          'id': 'profile-1',
          'display_name': 'Mark Salvador',
          'location': 'New York, USA',
          'bio': 'Simple ingredients can create magic.',
          'avatar_url': 'https://example.com/avatar.png',
          'cover_image_url': 'https://example.com/cover.png',
          'rating': '5',
          'followers_count': 357000,
          'following_count': 24,
          'posts_count': 18,
        },
        recipesJson: [
          {
            'id': 'recipe-1',
            'title': 'Egg rolls',
            'description': 'Fast egg rolls.',
            'rating': 4.84,
            'duration_minutes': 30,
            'difficulty': 'Medium',
            'cover_image_url': 'https://example.com/recipe.png',
          },
        ],
      );

      expect(model.displayName, 'Mark Salvador');
      expect(model.ratingLabel, '5.0');
      expect(model.followersLabel, '357K');
      expect(model.followingLabel, '24');
      expect(model.postsCount, 18);
      expect(model.recipes.single.chefName, 'Mark Salvador');
      expect(model.recipes.single.ratingLabel, '4.8');
      expect(model.recipes.single.durationLabel, '30 Min');
      expect(
        model.recipes.single.chefAvatarUrl,
        'https://example.com/avatar.png',
      );
    });
  });
}
