import 'package:flutter_test/flutter_test.dart';
import 'package:foodify_cooking/core/constants/supabase_constants.dart';

void main() {
  group('SupabaseConstants', () {
    test('exposes configured project URL and anon key', () {
      expect(SupabaseConstants.url, 'https://zxhtseztegvzxvhxbqfj.supabase.co');
      expect(
        SupabaseConstants.anonKey,
        'sb_publishable_XzA1EF6tOO6NohpLjkgB-Q_1GyD4IWu',
      );
    });
  });
}
