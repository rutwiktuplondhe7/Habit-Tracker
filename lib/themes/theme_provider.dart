import 'package:flutter/material.dart';
import 'package:habbit_tracker/themes/light_mode.dart';
import 'dark_mode.dart';

class ThemePovider extends ChangeNotifier {
  //light initially
  ThemeData _themeData = lightMode;

  //get current theme
  ThemeData get themeData => _themeData;

  //is current theme dark mode
  bool get isDarkMode => _themeData == darkMode;

  //set theme
  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  //toggle method
  void toggleTheme() {
    if (_themeData == lightMode) {
      themeData = darkMode;
    } else {
      themeData = lightMode;
    }
  }
}
