import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

ThemeData light = ThemeData(
  brightness: Brightness.light,
  primarySwatch: Colors.blue,
);

ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Color(0xFF2A3132),
    scaffoldBackgroundColor: Color(0xFF2A3132),
    primarySwatch: Colors.lightBlue,
    appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 20)));

class SwitchModeProvider extends ChangeNotifier {
  ThemeData _themeData = light;

  ThemeData get themeData => _themeData;

  bool get darkMode => _themeData == dark;

  SwitchModeProvider() {
    _loadThemeFromPreferences();
  }

  set themeData(ThemeData val) {
    _themeData = val;
    _saveThemeToPreferences();
    notifyListeners();
  }

  void toggleTheme() {
    _themeData = darkMode ? light : dark;
    _saveThemeToPreferences();
    notifyListeners();
  }

  void _saveThemeToPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkMode', darkMode);
  }

  void _loadThemeFromPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isDarkMode = prefs.getBool('isDarkMode') ?? false;
    _themeData = isDarkMode ? dark : light;
    notifyListeners();
  }
}
