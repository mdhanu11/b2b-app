import 'package:flutter/material.dart';

class LocaleService {
  static final LocaleService _instance = LocaleService._internal();
  factory LocaleService() => _instance;
  LocaleService._internal();

  // Default to English
  Locale _currentLocale = const Locale('en');

  // Getter
  Locale get currentLocale => _currentLocale;

  // Setter that will be called by your LocaleProvider
  void updateLocale(Locale locale) {
    print('LocaleService: Updating locale to ${locale.languageCode}');
    _currentLocale = locale;
  }
}
