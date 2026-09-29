import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:read_track/data/book_repository.dart';
import 'package:read_track/data/my_list_storage.dart';
import 'package:read_track/l10n/generated/app_localizations.dart';
import 'package:read_track/providers/book_providers.dart';
import 'package:read_track/providers/my_list_providers.dart';
import 'package:read_track/screens/library_screen.dart';

import '../support/fake_asset_bundle.dart';

void main() {
  late Directory tempDir;
  final sampleJson = jsonEncode([
    {'id': 'b01', 'title': '1984', 'author': 'George Orwell', 'category': 'Dystopie'},
    {'id': 'b02', 'title': 'Dune', 'author': 'Frank Herbert', 'category': 'SF'},
  ]);

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('library_screen_test');
    Hive.init(tempDir.path);
  });

  tearDown(() async {
    await Hive.deleteBoxFromDisk(MyListStorage.boxName);
    await tempDir.delete(recursive: true);
  });

  Future<void> pumpLibrary(WidgetTester tester) async {
    final storage = MyListStorage(await Hive.openBox<String>(MyListStorage.boxName));
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          bookRepositoryProvider.overrideWithValue(
            BookRepository(bundle: FakeAssetBundle(sampleJson), latency: Duration.zero),
          ),
          myListStorageProvider.overrideWithValue(storage),
        ],
        child: MaterialApp(
          locale: const Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const LibraryScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('shows every book once loaded', (tester) async {
    await pumpLibrary(tester);

    expect(find.text('1984'), findsOneWidget);
    expect(find.text('Dune'), findsOneWidget);
  });

  testWidgets('search filters the list by title', (tester) async {
    await pumpLibrary(tester);

    await tester.enterText(find.byType(TextField), 'dune');
    await tester.pump();

    expect(find.text('Dune'), findsOneWidget);
    expect(find.text('1984'), findsNothing);
  });

  testWidgets('shows the empty state when nothing matches', (tester) async {
    await pumpLibrary(tester);

    await tester.enterText(find.byType(TextField), 'nonexistent book title');
    await tester.pump();

    expect(find.text('No books match your search.'), findsOneWidget);
  });

  testWidgets('clearing the search restores the full list', (tester) async {
    await pumpLibrary(tester);

    await tester.enterText(find.byType(TextField), 'dune');
    await tester.pump();
    await tester.tap(find.byIcon(Icons.clear));
    await tester.pump();

    expect(find.text('1984'), findsOneWidget);
    expect(find.text('Dune'), findsOneWidget);
  });
}
