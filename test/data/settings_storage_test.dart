import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:read_track/data/settings_storage.dart';

void main() {
  late Directory tempDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('settings_storage_test');
    Hive.init(tempDir.path);
  });

  tearDown(() async {
    await Hive.deleteBoxFromDisk(SettingsStorage.boxName);
    await tempDir.delete(recursive: true);
  });

  test('defaults to light theme and French locale when empty', () async {
    final storage = SettingsStorage(
      await Hive.openBox<String>(SettingsStorage.boxName),
    );

    expect(storage.readThemeMode(), ThemeMode.light);
    expect(storage.readLocale(), const Locale('fr'));
  });

  test('persists theme mode across instances', () async {
    final storage = SettingsStorage(
      await Hive.openBox<String>(SettingsStorage.boxName),
    );
    await storage.saveThemeMode(ThemeMode.dark);

    final reopened = SettingsStorage(Hive.box<String>(SettingsStorage.boxName));
    expect(reopened.readThemeMode(), ThemeMode.dark);
  });

  test('persists locale across instances', () async {
    final storage = SettingsStorage(
      await Hive.openBox<String>(SettingsStorage.boxName),
    );
    await storage.saveLocale(const Locale('en'));

    final reopened = SettingsStorage(Hive.box<String>(SettingsStorage.boxName));
    expect(reopened.readLocale(), const Locale('en'));
  });
}
