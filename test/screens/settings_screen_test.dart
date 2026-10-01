import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:read_track/data/settings_storage.dart';
import 'package:read_track/l10n/generated/app_localizations.dart';
import 'package:read_track/providers/locale_provider.dart';
import 'package:read_track/providers/settings_providers.dart';
import 'package:read_track/providers/theme_provider.dart';
import 'package:read_track/screens/settings_screen.dart';

import '../support/in_memory_key_value_store.dart';

void main() {
  Future<ProviderContainer> pumpSettings(WidgetTester tester) async {
    final storage = SettingsStorage(InMemoryKeyValueStore());
    late ProviderContainer container;
    await tester.pumpWidget(
      ProviderScope(
        overrides: [settingsStorageProvider.overrideWithValue(storage)],
        child: Builder(
          builder: (context) {
            container = ProviderScope.containerOf(context);
            return const MaterialApp(
              locale: Locale('en'),
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              home: SettingsScreen(),
            );
          },
        ),
      ),
    );
    await tester.pumpAndSettle();
    return container;
  }

  testWidgets('starts in light mode and French by default', (tester) async {
    final container = await pumpSettings(tester);

    expect(container.read(themeModeProvider), ThemeMode.light);
    expect(container.read(localeProvider), const Locale('fr'));
  });

  testWidgets('toggling the switch enables dark mode', (tester) async {
    final container = await pumpSettings(tester);

    await tester.tap(find.byType(Switch));
    await tester.pump();

    expect(container.read(themeModeProvider), ThemeMode.dark);
  });

  testWidgets('selecting English updates the locale', (tester) async {
    final container = await pumpSettings(tester);

    await tester.tap(find.text('English'));
    await tester.pumpAndSettle();

    expect(container.read(localeProvider), const Locale('en'));
  });
}
