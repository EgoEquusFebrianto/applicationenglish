import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleProvider extends ChangeNotifier {
  Locale _locale = Locale('en', 'US'); // Default locale

  Locale get locale => _locale;

  LocaleProvider() {
    _loadLocaleFromPreferences();
  }

  Future<void> setLocale(Locale locale) async {
    _locale = locale;
    notifyListeners();
    await _saveLocaleToPreferences(locale);
  }

  Future<void> _loadLocaleFromPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? localeCode = prefs.getString('localeCode');
    if (localeCode != null) {
      List<String> parts = localeCode.split('_');
      _locale = Locale(parts[0], parts[1]);
      notifyListeners();
    }
  }

  Future<void> _saveLocaleToPreferences(Locale locale) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('localeCode', '${locale.languageCode}_${locale.countryCode}');
  }
}
