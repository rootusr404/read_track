import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:integration_test/integration_test.dart';
import 'package:read_track/app.dart';
import 'package:read_track/data/book_repository.dart';
import 'package:read_track/data/my_list_storage.dart';
import 'package:read_track/data/settings_storage.dart';
import 'package:read_track/providers/book_providers.dart';
import 'package:read_track/providers/my_list_providers.dart';
import 'package:read_track/providers/settings_providers.dart';
import 'package:read_track/widgets/status_filter_bar.dart';

import '../test/support/fake_asset_bundle.dart';

/// Le chip "All" existe à la fois dans le filtre de statut et dans le
/// filtre de catégorie (même libellé `libraryFilterAll`) : on doit donc
/// cibler celui de `StatusFilterBar` explicitement pour éviter une
/// résolution ambiguë du Finder.
///
/// On cible le `ChoiceChip` (toute la zone cliquable) plutôt que le
/// `Text` qu'il contient : à l'intérieur d'une rangée défilante
/// horizontalement, le centre géométrique du texte seul peut ne pas
/// correspondre exactement à sa position de rendu au moment du tap.
Finder _statusChip(String label) => find.ancestor(
  of: find.descendant(
    of: find.byType(StatusFilterBar),
    matching: find.text(label),
  ),
  matching: find.byType(ChoiceChip),
);

Future<void> _tapStatusChip(WidgetTester tester, String label) async {
  final chip = _statusChip(label);
  await tester.ensureVisible(chip);
  await tester.pumpAndSettle();
  await tester.tap(chip);
}

/// Parcours complet : rechercher un livre, vérifier le filtre "Favoris" à
/// vide, marquer un livre comme favori depuis sa fiche détail, puis
/// vérifier qu'il ressort bien du filtre "Favoris" en revenant à la
/// bibliothèque — traverse donc Bibliothèque -> Détail -> Bibliothèque.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late Directory tempDir;
  final sampleJson = jsonEncode([
    {
      'id': 'b01',
      'title': '1984',
      'author': 'George Orwell',
      'category': 'Dystopie',
    },
    {'id': 'b02', 'title': 'Dune', 'author': 'Frank Herbert', 'category': 'SF'},
  ]);

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('search_and_filter_test');
    Hive.init(tempDir.path);
  });

  tearDown(() async {
    await Hive.deleteBoxFromDisk(MyListStorage.boxName);
    await Hive.deleteBoxFromDisk(SettingsStorage.boxName);
    await tempDir.delete(recursive: true);
  });

  testWidgets(
    'search filters the library, and favoriting updates the favorite filter',
    (tester) async {
      final myListStorage = await MyListStorage.open();
      final settingsStorage = await SettingsStorage.open();
      await settingsStorage.saveLocale(const Locale('en'));

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            bookRepositoryProvider.overrideWithValue(
              BookRepository(
                bundle: FakeAssetBundle(sampleJson),
                latency: Duration.zero,
              ),
            ),
            myListStorageProvider.overrideWithValue(myListStorage),
            settingsStorageProvider.overrideWithValue(settingsStorage),
          ],
          child: const ReadTrackApp(),
        ),
      );
      await tester.pumpAndSettle();

      // 1. Recherche : ne montre que le livre correspondant.
      await tester.enterText(find.byType(TextField), 'dune');
      await tester.pump();
      expect(find.text('Dune'), findsOneWidget);
      expect(find.text('1984'), findsNothing);

      // 2. On efface la recherche puis on filtre par "Favorites" : personne
      // n'est favori pour l'instant, la liste doit être vide.
      await tester.tap(find.byIcon(Icons.clear));
      await tester.pump();
      await _tapStatusChip(tester, 'Favorites');
      await tester.pump();
      expect(find.text('No books match your search.'), findsOneWidget);

      // 3. Retour à "All", ouverture de la fiche de Dune.
      await _tapStatusChip(tester, 'All');
      await tester.pump();
      await tester.tap(find.text('Dune'));
      await tester.pumpAndSettle();

      // 4. Marquer comme favori depuis la fiche détail.
      await tester.tap(find.byIcon(Icons.favorite_border));
      await tester.pump();
      expect(find.byIcon(Icons.favorite), findsOneWidget);

      // 5. Retour à la bibliothèque, filtre "Favorites" : Dune y figure.
      await tester.pageBack();
      await tester.pumpAndSettle();
      await _tapStatusChip(tester, 'Favorites');
      await tester.pump();
      expect(find.text('Dune'), findsOneWidget);
      expect(find.text('1984'), findsNothing);
    },
  );
}
