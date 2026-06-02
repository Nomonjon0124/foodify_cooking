import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/create_recipe_draft.dart';

abstract interface class AddNewRemoteDataSource {
  Future<String> createRecipe(CreateRecipeDraft draft);
}

class SupabaseAddNewRemoteDataSource implements AddNewRemoteDataSource {
  SupabaseAddNewRemoteDataSource(this._readClient);

  final SupabaseClient Function() _readClient;

  @override
  Future<String> createRecipe(CreateRecipeDraft draft) async {
    final client = _readClient();
    final user = client.auth.currentUser;
    if (user == null) {
      throw AuthException('Login required');
    }

    await _ensureCurrentProfile(client, user);

    final objectPath =
        'user-recipes/${user.id}/${DateTime.now().millisecondsSinceEpoch}-${_sanitizeFileName(draft.coverImageName)}';
    await client.storage
        .from('recipe-images')
        .uploadBinary(
          objectPath,
          draft.coverImageBytes,
          fileOptions: FileOptions(
            cacheControl: '3600',
            contentType: draft.coverImageMimeType,
            upsert: false,
          ),
        );

    final publicUrl = client.storage
        .from('recipe-images')
        .getPublicUrl(objectPath);
    final response = await client.rpc(
      'create_recipe',
      params: {
        'p_title': draft.title,
        'p_description': draft.description,
        'p_duration_minutes': draft.durationMinutes,
        'p_difficulty': draft.difficulty,
        'p_cover_image_url': publicUrl,
        'p_ingredients': draft.ingredients,
        'p_instructions': draft.instructions,
        'p_tags': draft.tags,
      },
    );

    return response.toString();
  }

  Future<void> _ensureCurrentProfile(SupabaseClient client, User user) async {
    final existing = await client
        .from('profiles')
        .select('id')
        .eq('auth_user_id', user.id)
        .maybeSingle();
    if (existing != null) return;

    try {
      await client.from('profiles').insert(_profileInsertPayload(user));
    } on PostgrestException catch (error) {
      if (error.code != '23505') rethrow;
    }
  }

  Map<String, dynamic> _profileInsertPayload(User user) {
    final metadata = user.userMetadata ?? const <String, dynamic>{};
    final email = user.email ?? '';
    final fallbackName = email.contains('@') ? email.split('@').first : email;
    final displayName =
        (metadata['full_name'] ??
                metadata['name'] ??
                metadata['display_name'] ??
                fallbackName)
            .toString()
            .trim();
    final nameParts = _splitDisplayName(displayName);
    final avatarUrl = (metadata['avatar_url'] ?? metadata['picture'] ?? '')
        .toString()
        .trim();

    return {
      'auth_user_id': user.id,
      'first_name': nameParts.$1,
      'last_name': nameParts.$2,
      'display_name': displayName.isEmpty ? 'Foodify User' : displayName,
      if (avatarUrl.isNotEmpty) 'avatar_url': avatarUrl,
    };
  }
}

(String, String?) _splitDisplayName(String displayName) {
  final trimmed = displayName.trim();
  if (trimmed.isEmpty) return ('Foodify', 'User');

  final parts = trimmed.split(RegExp(r'\s+'));
  if (parts.length == 1) return (parts.first, null);

  return (parts.first, parts.skip(1).join(' '));
}

String _sanitizeFileName(String fileName) {
  final fallback = fileName.trim().isEmpty ? 'cover.jpg' : fileName.trim();
  final sanitized = fallback.replaceAll(RegExp(r'[^a-zA-Z0-9._-]+'), '-');
  return sanitized.isEmpty ? 'cover.jpg' : sanitized;
}
