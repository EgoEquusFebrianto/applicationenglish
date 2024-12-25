import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

ThemeData light = ThemeData(
  brightness: Brightness.light,
  primaryColor: Colors.black,
  primarySwatch: Colors.blue,
  scaffoldBackgroundColor: Colors.white,
  colorScheme: ColorScheme(
    brightness: Brightness.light,
    primary: Colors.blue,
    onPrimary: Colors.white,
    secondary: Colors.black,
    onSecondary: Colors.blue,
    error: Colors.blue,
    onError: Colors.blue,
    surface: Colors.blue,
    onSurface: Colors.blue),
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.blue,
    iconTheme: IconThemeData(color: Colors.black),
    titleTextStyle: TextStyle(color: Colors.black, fontSize: 20))
);

ThemeData dark = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Color.fromARGB(255, 219, 219, 219),
  primarySwatch: Colors.lightBlue,
  scaffoldBackgroundColor: Color(0xFF2A3132),
  colorScheme: ColorScheme(
    brightness: Brightness.dark,
    primary: Colors.lightBlue,
    onPrimary: Colors.black,
    secondary: Colors.white,
    onSecondary: Colors.lightBlue,
    error: Colors.lightBlue,
    onError: Colors.lightBlue,
    surface: Colors.lightBlue,
    onSurface: Colors.lightBlue),
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.transparent,
    iconTheme: IconThemeData(color: Colors.white),
    titleTextStyle: TextStyle(color: Colors.white, fontSize: 20))
);

class SwitchModeProvider extends ChangeNotifier {
  ThemeData _themeData = light;
  ThemeData get themeData => _themeData;
  bool get darkMode => _themeData == dark;

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
}
