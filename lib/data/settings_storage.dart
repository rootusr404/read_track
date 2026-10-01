import 'package:flutter/material.dart';

import 'hive_key_value_store.dart';
import 'key_value_store.dart';

/// Persistance locale des réglages (thème, langue) dans un KeyValueStore.
class SettingsStorage {
  SettingsStorage(this._store);

  static const boxName = 'settings';
  static const _themeKey = 'themeMode';
  static const _localeKey = 'locale';

  final KeyValueStore _store;

  /// À appeler après `Hive.initFlutter()`.
  static Future<SettingsStorage> open() async {
    return SettingsStorage(await HiveKeyValueStore.open(boxName));
  }

  ThemeMode readThemeMode() {
    final raw = _store.get(_themeKey);
    return ThemeMode.values.firstWhere(
      (mode) => mode.name == raw,
      orElse: () => ThemeMode.light,
    );
  }

  Future<void> saveThemeMode(ThemeMode mode) =>
      _store.put(_themeKey, mode.name);

  Locale readLocale() => Locale(_store.get(_localeKey) ?? 'fr');

  Future<void> saveLocale(Locale locale) =>
      _store.put(_localeKey, locale.languageCode);
}
