import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:read_track/data/my_list_storage.dart';
import 'package:read_track/l10n/generated/app_localizations.dart';
import 'package:read_track/models/book.dart';
import 'package:read_track/models/my_list_entry.dart';
import 'package:read_track/providers/my_list_providers.dart';
import 'package:read_track/widgets/my_list_tile.dart';

const _book = Book(id: 'b01', title: '1984', author: 'George Orwell', category: 'Dystopie');

void main() {
  late Directory tempDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('my_list_tile_test');
    Hive.init(tempDir.path);
  });

  tearDown(() async {
    await Hive.deleteBoxFromDisk(MyListStorage.boxName);
    await tempDir.delete(recursive: true);
  });

  Future<ProviderContainer> pumpTile(WidgetTester tester) async {
    final storage = MyListStorage(await Hive.openBox<String>(MyListStorage.boxName));
    await storage.save(const MyListEntry(bookId: 'b01'));
    late ProviderContainer container;
    await tester.pumpWidget(
      ProviderScope(
        overrides: [myListStorageProvider.overrideWithValue(storage)],
        child: Builder(
          builder: (context) {
            container = ProviderScope.containerOf(context);
            return MaterialApp(
              locale: const Locale('en'),
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              home: Scaffold(body: MyListTile(book: _book, onTap: () {})),
            );
          },
        ),
      ),
    );
    await tester.pumpAndSettle();
    return container;
  }

  testWidgets('confirming the swipe-to-remove dialog removes the entry', (tester) async {
    final container = await pumpTile(tester);

    await tester.drag(find.byType(Dismissible), const Offset(-500, 0));
    await tester.pumpAndSettle();
    expect(find.text('Remove this book?'), findsOneWidget);

    await tester.tap(find.text('Confirm'));
    await tester.pumpAndSettle();

    expect(container.read(myListProvider).containsKey('b01'), isFalse);
  });

  testWidgets('canceling the dialog keeps the entry', (tester) async {
    final container = await pumpTile(tester);

    await tester.drag(find.byType(Dismissible), const Offset(-500, 0));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    expect(container.read(myListProvider).containsKey('b01'), isTrue);
  });
}
