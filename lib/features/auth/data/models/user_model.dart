import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.email,
    required super.name,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: (json['id'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
    );
  }

  factory UserModel.fromSupabaseUser(supabase.User user) {
    final metadata = user.userMetadata ?? const <String, dynamic>{};
    final email = user.email ?? '';
    final fallbackName = email.contains('@') ? email.split('@').first : email;
    final name =
        (metadata['full_name'] ??
                metadata['name'] ??
                metadata['display_name'] ??
                fallbackName)
            .toString();

    return UserModel(id: user.id, email: email, name: name);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'email': email, 'name': name};
  }
}
