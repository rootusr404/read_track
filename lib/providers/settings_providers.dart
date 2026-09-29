import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/settings_storage.dart';

/// Fourni via `overrides` (main.dart et tests) — même pattern que
/// `myListStorageProvider` (Sprint 2).
final settingsStorageProvider = Provider<SettingsStorage>((ref) {
  throw UnimplementedError('settingsStorageProvider must be overridden');
});
