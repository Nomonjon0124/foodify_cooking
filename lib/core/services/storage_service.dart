class StorageService {
  final Map<String, String> _memoryStorage = <String, String>{};

  Future<void> setString(String key, String value) async {
    _memoryStorage[key] = value;
  }

  String? getString(String key) {
    return _memoryStorage[key];
  }

  Future<void> remove(String key) async {
    _memoryStorage.remove(key);
  }
}
