import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../services/locale_service.dart';

class LocaleProvider with ChangeNotifier {
  final LocaleService _localeService = LocaleService();

  LocaleProvider() {
    print('LocaleProvider initialized');
  }

  Locale get locale => _localeService.currentLocale;

  void setLocale(Locale locale) {
    print('Setting locale to: ${locale.languageCode}');

    if (!['en', 'ar'].contains(locale.languageCode)) {
      print('Invalid locale: ${locale.languageCode}');
      return;
    }

    if (_localeService.currentLocale.languageCode != locale.languageCode) {
      print(
          'Locale changed from ${_localeService.currentLocale.languageCode} to ${locale.languageCode}');

      // Update the global service
      _localeService.updateLocale(locale);

      // Notify listeners for UI updates
      notifyListeners();

      print('Listeners notified. New locale: ${locale.languageCode}');
    } else {
      print('Locale unchanged, still ${locale.languageCode}');
    }
  }
}
