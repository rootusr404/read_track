import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:read_track/data/my_list_storage.dart';
import 'package:read_track/l10n/generated/app_localizations.dart';
import 'package:read_track/models/book.dart';
import 'package:read_track/models/my_list_entry.dart';
import 'package:read_track/providers/my_list_providers.dart';
import 'package:read_track/widgets/my_list_tile.dart';

import '../support/in_memory_key_value_store.dart';

const _book = Book(
  id: 'b01',
  title: '1984',
  author: 'George Orwell',
  category: 'Dystopie',
);

/// `Dismissible` exige que son parent le retire de l'arbre une fois
/// l'animation de balayage terminée (sans quoi il relève une assertion).
/// En production, `MyListScreen` le fait naturellement en reconstruisant
/// sa liste sans l'entrée supprimée — on reproduit ce comportement ici
/// plutôt que de rendre `MyListTile` seul, de façon statique.
class _TestHost extends ConsumerWidget {
  const _TestHost();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isInList = ref.watch(myListEntryProvider(_book.id)) != null;
    return Scaffold(
      body: isInList
          ? MyListTile(book: _book, onTap: () {})
          : const Text('removed'),
    );
  }
}

void main() {
  Future<ProviderContainer> pumpTile(WidgetTester tester) async {
    final store = InMemoryKeyValueStore();
    final storage = MyListStorage(store);
    await storage.save(const MyListEntry(bookId: 'b01'));
    late ProviderContainer container;
    await tester.pumpWidget(
      ProviderScope(
        overrides: [myListStorageProvider.overrideWithValue(storage)],
        child: Builder(
          builder: (context) {
            container = ProviderScope.containerOf(context);
            return const MaterialApp(
              locale: Locale('en'),
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              home: _TestHost(),
            );
          },
        ),
      ),
    );
    await tester.pumpAndSettle();
    return container;
  }

  testWidgets('confirming the swipe-to-remove dialog removes the entry', (
    tester,
  ) async {
    final container = await pumpTile(tester);

    await tester.drag(find.byType(Dismissible), const Offset(-500, 0));
    await tester.pumpAndSettle();
    expect(find.text('Remove this book?'), findsOneWidget);

    await tester.tap(find.text('Confirm'));
    await tester.pumpAndSettle();

    expect(container.read(myListProvider).containsKey('b01'), isFalse);
    expect(find.text('removed'), findsOneWidget);
  });

  testWidgets('canceling the dialog keeps the entry', (tester) async {
    final container = await pumpTile(tester);

    await tester.drag(find.byType(Dismissible), const Offset(-500, 0));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    expect(container.read(myListProvider).containsKey('b01'), isTrue);
    expect(find.byType(MyListTile), findsOneWidget);
  });
}
