import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// Persistance locale des réglages (thème, langue) dans une Box<String>.
class SettingsStorage {
  SettingsStorage(this._box);

  static const boxName = 'settings';
  static const _themeKey = 'themeMode';
  static const _localeKey = 'locale';

  final Box<String> _box;

  /// À appeler après `Hive.initFlutter()`.
  static Future<SettingsStorage> open() async {
    return SettingsStorage(await Hive.openBox<String>(boxName));
  }

  ThemeMode readThemeMode() {
    final raw = _box.get(_themeKey);
    return ThemeMode.values.firstWhere(
      (mode) => mode.name == raw,
      orElse: () => ThemeMode.light,
    );
  }

  Future<void> saveThemeMode(ThemeMode mode) => _box.put(_themeKey, mode.name);

  Locale readLocale() => Locale(_box.get(_localeKey) ?? 'fr');

  Future<void> saveLocale(Locale locale) =>
      _box.put(_localeKey, locale.languageCode);
}
