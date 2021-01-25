import 'package:flutter/material.dart';
import 'package:skill_drills/models/Settings.dart';

class SettingsStateNotifier extends ChangeNotifier {
  Settings settings = Settings(
    true,
    (ThemeMode.system == ThemeMode.dark),
  );

  void updateSettings(Settings settings) {
    this.settings = settings;
    notifyListeners();
  }
}
