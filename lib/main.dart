import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'app.dart';
import 'data/my_list_storage.dart';
import 'providers/my_list_providers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  final storage = await MyListStorage.open();

  runApp(
    ProviderScope(
      overrides: [myListStorageProvider.overrideWithValue(storage)],
      child: const ReadTrackApp(),
    ),
  );
}
