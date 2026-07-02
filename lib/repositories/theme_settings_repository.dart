import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class ThemeSettingsRepository {
  Future<ThemeMode> load();

  Future<void> save(ThemeMode mode);
}

class PrefsThemeSettingsRepository implements ThemeSettingsRepository {
  static const _key = 'theme_mode_v1';

  @override
  Future<ThemeMode> load() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString(_key);

    return switch (value) {
      'dark' => ThemeMode.dark,
      'light' => ThemeMode.light,
      _ => ThemeMode.light,
    };
  }

  @override
  Future<void> save(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    final value = switch (mode) {
      ThemeMode.dark => 'dark',
      ThemeMode.light => 'light',
      ThemeMode.system => 'light',
    };

    await prefs.setString(_key, value);
  }
}
