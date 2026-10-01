import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:read_track/data/my_list_storage.dart';
import 'package:read_track/data/settings_storage.dart';

/// Initialise Hive sur un répertoire temporaire avant chaque test, et le
/// nettoie après — factorise ce qui était dupliqué dans chaque fichier de
/// `integration_test/`.
///
/// `Hive.initFlutter()` n'est pas utilisable ici : il dépend de
/// `path_provider`, indisponible en mode `flutter test` sans device.
void setUpHiveTempDir(String tempDirPrefix) {
  late Directory tempDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp(tempDirPrefix);
    Hive.init(tempDir.path);
  });

  tearDown(() async {
    await Hive.deleteBoxFromDisk(MyListStorage.boxName);
    await Hive.deleteBoxFromDisk(SettingsStorage.boxName);
    await tempDir.delete(recursive: true);
  });
}
