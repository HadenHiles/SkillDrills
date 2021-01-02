import 'package:flutter/material.dart';

class ThemeStateNotifier extends ChangeNotifier {
  bool isDarkMode = (ThemeMode.system == ThemeMode.dark);

  void updateTheme(bool isDarkMode) {
    this.isDarkMode = isDarkMode;
    notifyListeners();
  }
}
