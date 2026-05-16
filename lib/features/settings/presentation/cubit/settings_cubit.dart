import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/storage_keys.dart';
import '../../../../core/services/storage_service.dart';
import 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit(this._storageService) : super(const SettingsState());

  static const defaultLanguageCode = 'uz';
  static const supportedLanguageCodes = {'uz', 'en', 'ru'};

  final StorageService _storageService;

  Future<void> loadPreferences() async {
    final savedLanguageCode = _normalizeLanguageCode(
      _storageService.getString(StorageKeys.languageCode),
    );
    emit(state.copyWith(languageCode: savedLanguageCode));
  }

  void toggleTheme() {
    // TODO: Persist theme choice in storage and rehydrate on app start.
    emit(state.copyWith(isDarkMode: !state.isDarkMode));
  }

  Future<void> changeLanguage(String? languageCode) async {
    final normalized = _normalizeLanguageCode(languageCode);
    await _storageService.setString(StorageKeys.languageCode, normalized);
    emit(state.copyWith(languageCode: normalized));
  }

  String _normalizeLanguageCode(String? languageCode) {
    if (languageCode == null || languageCode.trim().isEmpty) {
      return defaultLanguageCode;
    }
    final normalized = languageCode.trim().toLowerCase();
    return supportedLanguageCodes.contains(normalized)
        ? normalized
        : defaultLanguageCode;
  }
}
