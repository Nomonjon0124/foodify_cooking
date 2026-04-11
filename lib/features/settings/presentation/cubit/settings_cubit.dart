import 'package:flutter_bloc/flutter_bloc.dart';

import 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit() : super(const SettingsState());

  void toggleTheme() {
    // TODO: Persist theme choice in storage and rehydrate on app start.
    emit(state.copyWith(isDarkMode: !state.isDarkMode));
  }

  void changeLanguage(String languageCode) {
    // TODO: Integrate localization package and dynamic locale updates.
    emit(state.copyWith(languageCode: languageCode));
  }
}
