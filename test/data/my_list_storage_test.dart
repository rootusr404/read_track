import 'package:flutter_test/flutter_test.dart';
import 'package:read_track/data/my_list_storage.dart';
import 'package:read_track/models/my_list_entry.dart';

import '../support/in_memory_key_value_store.dart';

void main() {
  test('readAll returns an empty list when nothing was saved', () {
    final storage = MyListStorage(InMemoryKeyValueStore());

    expect(storage.readAll(), isEmpty);
  });

  test('save then readAll returns the saved entry', () async {
    final storage = MyListStorage(InMemoryKeyValueStore());

    await storage.save(const MyListEntry(bookId: 'b01', isFavorite: true));

    expect(storage.readAll(), [
      const MyListEntry(bookId: 'b01', isFavorite: true),
    ]);
  });

  test('save twice with the same bookId overwrites the entry', () async {
    final storage = MyListStorage(InMemoryKeyValueStore());

    await storage.save(const MyListEntry(bookId: 'b01'));
    await storage.save(const MyListEntry(bookId: 'b01', isRead: true));

    expect(storage.readAll(), [const MyListEntry(bookId: 'b01', isRead: true)]);
  });

  test('remove deletes only the targeted entry', () async {
    final storage = MyListStorage(InMemoryKeyValueStore());
    await storage.save(const MyListEntry(bookId: 'b01'));
    await storage.save(const MyListEntry(bookId: 'b02'));

    await storage.remove('b01');

    expect(storage.readAll(), [const MyListEntry(bookId: 'b02')]);
  });

  test('clear empties the storage', () async {
    final storage = MyListStorage(InMemoryKeyValueStore());
    await storage.save(const MyListEntry(bookId: 'b01'));

    await storage.clear();

    expect(storage.readAll(), isEmpty);
  });
}
