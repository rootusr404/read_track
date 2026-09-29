import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/settings_storage.dart';
import 'settings_providers.dart';

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier(this._storage) : super(_storage.readThemeMode());

  final SettingsStorage _storage;

  Future<void> toggle() =>
      set(state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light);

  Future<void> set(ThemeMode mode) async {
    state = mode;
    await _storage.saveThemeMode(mode);
  }
}

final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>((
  ref,
) {
  return ThemeModeNotifier(ref.watch(settingsStorageProvider));
});
