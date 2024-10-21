import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  // Toggle between light and dark themes
  void toggleTheme(bool isDarkMode) async {
    _themeMode = isDarkMode ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();

    // Persist the theme mode in SharedPreferences for future sessions
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', isDarkMode);
  }

  // Load the saved theme from SharedPreferences when the app starts
  Future<void> loadThemeFromPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isDarkMode = prefs.getBool('isDarkMode');

    if (isDarkMode != null) {
      _themeMode = isDarkMode ? ThemeMode.dark : ThemeMode.light;
      notifyListeners();
    }
  }
}
