import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'app.dart';
import 'data/my_list_storage.dart';
import 'data/settings_storage.dart';
import 'providers/my_list_providers.dart';
import 'providers/settings_providers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  final myListStorage = await MyListStorage.open();
  final settingsStorage = await SettingsStorage.open();

  runApp(
    ProviderScope(
      overrides: [
        myListStorageProvider.overrideWithValue(myListStorage),
        settingsStorageProvider.overrideWithValue(settingsStorage),
      ],
      child: const ReadTrackApp(),
    ),
  );
}
