import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:integration_test/integration_test.dart';
import 'package:read_track/app.dart';
import 'package:read_track/data/my_list_storage.dart';
import 'package:read_track/data/settings_storage.dart';
import 'package:read_track/providers/my_list_providers.dart';
import 'package:read_track/providers/settings_providers.dart';

/// Parcours complet : ajouter un livre au catalogue, le retrouver dans la
/// bibliothèque, ouvrir sa fiche, l'ajouter à "Ma liste", puis vérifier
/// qu'il apparaît bien dans l'onglet "Ma liste".
///
/// N'appelle pas le vrai `main()` : `Hive.initFlutter()` dépend de
/// `path_provider`, indisponible en mode "flutter test" sans device. On
/// initialise donc Hive manuellement sur un répertoire temporaire, comme
/// dans les tests de widgets (Sprints 7-8).
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late Directory tempDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('add_and_track_book_test');
    Hive.init(tempDir.path);
  });

  tearDown(() async {
    await Hive.deleteBoxFromDisk(MyListStorage.boxName);
    await Hive.deleteBoxFromDisk(SettingsStorage.boxName);
    await tempDir.delete(recursive: true);
  });

  testWidgets('add a book, find it in the library, add it to my list', (
    tester,
  ) async {
    final myListStorage = await MyListStorage.open();
    final settingsStorage = await SettingsStorage.open();
    await settingsStorage.saveLocale(
      const Locale('en'),
    ); // textes déterministes

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          myListStorageProvider.overrideWithValue(myListStorage),
          settingsStorageProvider.overrideWithValue(settingsStorage),
        ],
        child: const ReadTrackApp(),
      ),
    );
    await tester.pumpAndSettle();

    // 1. Ouvrir le formulaire d'ajout depuis la Bibliothèque.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    // 2. Remplir et valider le formulaire.
    await tester.enterText(
      find.byType(TextFormField).at(0),
      'Integration Test Book',
    );
    await tester.enterText(find.byType(TextFormField).at(1), 'Test Author');
    await tester.enterText(find.byType(TextFormField).at(2), 'Test Category');
    await tester.tap(find.text('Save book'));
    await tester.pumpAndSettle();

    // 3. Le livre apparaît désormais dans la Bibliothèque.
    expect(find.text('Integration Test Book'), findsOneWidget);

    // 4. Ouvrir sa fiche détail.
    await tester.tap(find.text('Integration Test Book'));
    await tester.pumpAndSettle();
    expect(find.text('Add to my list'), findsOneWidget);

    // 5. L'ajouter à "Ma liste".
    await tester.tap(find.text('Add to my list'));
    await tester.pumpAndSettle();
    expect(find.text('Mark as read'), findsOneWidget);
    expect(find.text('Remove from my list'), findsOneWidget);

    // 6. Revenir en arrière puis ouvrir l'onglet "My List".
    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.tap(find.text('My List'));
    await tester.pumpAndSettle();

    // 7. Le livre y figure bien.
    expect(find.text('Integration Test Book'), findsOneWidget);
  });
}
