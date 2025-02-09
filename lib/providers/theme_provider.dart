import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _currentTheme;

  ThemeProvider({bool isDarkMode = false})
      : _currentTheme =
            isDarkMode ? ThemeData.dark() : ThemeData.light();

  ThemeData get temaActual => _currentTheme;

  bool get isDarkMode => _currentTheme.brightness == Brightness.dark;

  void toggleTheme() async {
    _currentTheme =
        _currentTheme.brightness == Brightness.dark
            ? ThemeData.light()
            : ThemeData.dark();

    // Guardar el estado del tema en shared_preferences
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkMode', isDarkMode);

    notifyListeners();
  }

  // Cargar el tema al iniciar la app
  Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool('isDarkMode') ?? false; // Default: Light Mode
    _currentTheme = isDark ? ThemeData.dark() : ThemeData.light();
    notifyListeners();
  }
}