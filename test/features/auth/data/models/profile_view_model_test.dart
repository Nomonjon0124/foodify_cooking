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
            'chef_name': 'Chef Mark',
            'chef_avatar_url': 'https://example.com/chef.png',
          },
        ],
      );

      expect(model.displayName, 'Mark Salvador');
      expect(model.ratingLabel, '5.0');
      expect(model.followersLabel, '357K');
      expect(model.followingLabel, '24');
      expect(model.postsCount, 18);
      expect(model.recipes.single.chefName, 'Chef Mark');
      expect(model.recipes.single.ratingLabel, '4.8');
      expect(model.recipes.single.durationLabel, '30 Min');
      expect(
        model.recipes.single.chefAvatarUrl,
        'https://example.com/chef.png',
      );
    });

    test('uses fallback recipe count when real posts are empty', () {
      final model = ProfileViewModel.fromJson(
        profileJson: {
          'id': 'profile-1',
          'display_name': 'Nomonjon Toychiyev',
          'posts_count': 0,
        },
        recipesJson: [
          {'id': 'recipe-1', 'title': 'Egg rolls'},
          {'id': 'recipe-2', 'title': 'Chicken bowl'},
        ],
        useRecipesCountWhenPostsEmpty: true,
      );

      expect(model.postsCount, 2);
      expect(model.recipes, hasLength(2));
    });

    test('keeps real empty posts count when fallback count is disabled', () {
      final model = ProfileViewModel.fromJson(
        profileJson: {
          'id': 'profile-1',
          'display_name': 'Nomonjon Toychiyev',
          'posts_count': 0,
        },
        recipesJson: [
          {'id': 'recipe-1', 'title': 'Egg rolls'},
        ],
      );

      expect(model.postsCount, 0);
      expect(model.recipes, hasLength(1));
    });
  });
}
