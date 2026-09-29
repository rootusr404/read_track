import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/settings_storage.dart';
import 'settings_providers.dart';

/// Langues supportées (FR par défaut).
const supportedLocales = [Locale('fr'), Locale('en')];

class LocaleNotifier extends StateNotifier<Locale> {
  LocaleNotifier(this._storage) : super(_storage.readLocale());

  final SettingsStorage _storage;

  Future<void> set(Locale locale) async {
    state = locale;
    await _storage.saveLocale(locale);
  }
}

final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  return LocaleNotifier(ref.watch(settingsStorageProvider));
});
