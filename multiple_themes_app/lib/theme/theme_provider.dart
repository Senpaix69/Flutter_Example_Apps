import 'package:flutter/material.dart';
import 'package:multiple_themes_app/theme/custom_themes/navy_blue.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _themeData = ThemeData.light();
  final ThemeData _darkTheme = ThemeData.dark();
  final ThemeData _lightTheme = ThemeData.light();

  ThemeData get themeData => _themeData;
  ThemeData get darkTheme => _darkTheme;
  ThemeData get lightTheme => _lightTheme;
  ThemeData get navyBlue => NavyBlue.navyBlue;

  void toggleTheme() {
    _themeData = _themeData.brightness == Brightness.light
        ? ThemeData.dark()
        : ThemeData.light();
    notifyListeners();
  }

  void setTheme({required ThemeData theme}) {
    if (theme == _themeData) {
      return;
    }
    _themeData = theme;
    notifyListeners();
  }
}
