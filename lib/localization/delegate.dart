import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:initiative/localization/localization.dart';

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  static const AppLocalizationsDelegate delegate = AppLocalizationsDelegate();

  static const supportedLocales = [
    Locale('en', 'US'),
    Locale('de', 'DE'),
  ];

  @override
  bool isSupported(Locale locale) => supportedLocales.contains(locale);

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(AppLocalizations(locale));
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}
