import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ViewModel untuk mengatur & menyimpan preferensi mode tampilan (terang/gelap)
class ThemeViewModel extends ChangeNotifier {
  static const _prefsKey = 'is_dark_mode';

  bool _isDark = true;
  bool get isDark => _isDark;
  ThemeMode get themeMode => _isDark ? ThemeMode.dark : ThemeMode.light;

  ThemeViewModel() {
    _loadPreference();
  }

  Future<void> _loadPreference() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getBool(_prefsKey);
    if (saved != null && saved != _isDark) {
      _isDark = saved;
      notifyListeners();
    }
  }

  Future<void> setDarkMode(bool value) async {
    if (_isDark == value) return;
    _isDark = value;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefsKey, value);
  }
}
