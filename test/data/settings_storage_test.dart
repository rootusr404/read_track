import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:read_track/data/settings_storage.dart';

import '../support/in_memory_key_value_store.dart';

void main() {
  test('defaults to light theme and French locale when empty', () {
    final storage = SettingsStorage(InMemoryKeyValueStore());

    expect(storage.readThemeMode(), ThemeMode.light);
    expect(storage.readLocale(), const Locale('fr'));
  });

  test('persists theme mode across instances sharing the same store', () async {
    final store = InMemoryKeyValueStore();
    final storage = SettingsStorage(store);
    await storage.saveThemeMode(ThemeMode.dark);

    final reopened = SettingsStorage(store);
    expect(reopened.readThemeMode(), ThemeMode.dark);
  });

  test('persists locale across instances sharing the same store', () async {
    final store = InMemoryKeyValueStore();
    final storage = SettingsStorage(store);
    await storage.saveLocale(const Locale('en'));

    final reopened = SettingsStorage(store);
    expect(reopened.readLocale(), const Locale('en'));
  });
}
