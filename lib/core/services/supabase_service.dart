import 'package:supabase_flutter/supabase_flutter.dart';

import '../constants/supabase_constants.dart';

abstract final class SupabaseService {
  static Future<Supabase> initialize() {
    return Supabase.initialize(
      url: SupabaseConstants.url,
      anonKey: SupabaseConstants.anonKey,
    );
  }

  static bool get isInitialized {
    try {
      Supabase.instance.client;
      return true;
    } catch (_) {
      return false;
    }
  }

  static SupabaseClient get client => Supabase.instance.client;
}
