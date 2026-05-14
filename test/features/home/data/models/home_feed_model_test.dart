import 'package:flutter_test/flutter_test.dart';
import 'package:foodify_cooking/features/home/data/models/home_feed_model.dart';

void main() {
  group('HomeFeedModel', () {
    test('maps Supabase feed rows into popular and latest sections', () {
      final feed = HomeFeedModel.fromFeedItems([
        {
          'section': 'popular',
          'sort_order': 1,
          'recipe': {
            'id': 'popular-1',
            'title': 'Popular cake',
            'rating': 4.8,
            'cover_image_url': 'https://example.com/popular.png',
          },
        },
        {
          'section': 'latest',
          'sort_order': 1,
          'recipe': {
            'id': 'latest-1',
            'title': 'Latest cake',
            'description': 'Recipe description',
            'rating': '3.8',
            'duration_minutes': 120,
            'difficulty': 'Simple',
            'cover_image_url': 'https://example.com/latest.png',
            'overlay_image_url': 'https://example.com/overlay.png',
            'author': {
              'id': 'author-1',
              'display_name': 'Kelly Mayer',
              'avatar_url': 'https://example.com/avatar.png',
              'rating': 4.9,
            },
          },
        },
      ]);

      expect(feed.popularRecipes, hasLength(1));
      expect(feed.popularRecipes.single.title, 'Popular cake');
      expect(feed.popularRecipes.single.topRatingLabel, '4.8');

      expect(feed.latestRecipes, hasLength(1));
      expect(feed.latestRecipes.single.title, 'Latest cake');
      expect(feed.latestRecipes.single.durationLabel, '120 Min');
      expect(feed.latestRecipes.single.author?.displayName, 'Kelly Mayer');
      expect(feed.latestRecipes.single.author?.ratingLabel, '4.9');
    });
  });
}
