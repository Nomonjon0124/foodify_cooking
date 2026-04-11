import 'dart:convert';

import '../../../../core/constants/storage_keys.dart';
import '../../../../core/services/storage_service.dart';
import '../models/user_model.dart';

abstract interface class AuthLocalDataSource {
  Future<void> cacheUser(UserModel user);
  Future<UserModel?> getCachedUser();
  Future<void> clear();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  AuthLocalDataSourceImpl(this._storageService);

  final StorageService _storageService;

  @override
  Future<void> cacheUser(UserModel user) {
    final payload = jsonEncode(user.toJson());
    return _storageService.setString(StorageKeys.cachedUser, payload);
  }

  @override
  Future<UserModel?> getCachedUser() async {
    final raw = _storageService.getString(StorageKeys.cachedUser);
    if (raw == null || raw.isEmpty) return null;

    return UserModel.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  @override
  Future<void> clear() async {
    await _storageService.remove(StorageKeys.cachedUser);
  }
}
