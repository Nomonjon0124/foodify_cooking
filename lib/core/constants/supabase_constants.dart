abstract final class SupabaseConstants {
  static const url = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://zxhtseztegvzxvhxbqfj.supabase.co',
  );

  static const anonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: 'sb_publishable_XzA1EF6tOO6NohpLjkgB-Q_1GyD4IWu',
  );
}
