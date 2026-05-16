import 'package:flutter/material.dart';
import 'package:foodify_cooking/l10n/generated/app_localizations.dart';

const testLocale = Locale('en');

List<LocalizationsDelegate<dynamic>> get testLocalizationsDelegates =>
    AppLocalizations.localizationsDelegates;

List<Locale> get testSupportedLocales => AppLocalizations.supportedLocales;
