import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:read_track/data/my_list_storage.dart';
import 'package:read_track/models/my_list_entry.dart';

void main() {
  late Directory tempDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('my_list_storage_test');
    Hive.init(tempDir.path);
  });

  tearDown(() async {
    await Hive.deleteBoxFromDisk(MyListStorage.boxName);
    await tempDir.delete(recursive: true);
  });

  test('readAll returns an empty list when nothing was saved', () async {
    final storage = MyListStorage(await Hive.openBox<String>(MyListStorage.boxName));

    expect(storage.readAll(), isEmpty);
  });

  test('save then readAll returns the saved entry', () async {
    final storage = MyListStorage(await Hive.openBox<String>(MyListStorage.boxName));

    await storage.save(const MyListEntry(bookId: 'b01', isFavorite: true));

    expect(storage.readAll(), [const MyListEntry(bookId: 'b01', isFavorite: true)]);
  });

  test('save twice with the same bookId overwrites the entry', () async {
    final storage = MyListStorage(await Hive.openBox<String>(MyListStorage.boxName));

    await storage.save(const MyListEntry(bookId: 'b01'));
    await storage.save(const MyListEntry(bookId: 'b01', isRead: true));

    expect(storage.readAll(), [const MyListEntry(bookId: 'b01', isRead: true)]);
  });

  test('remove deletes only the targeted entry', () async {
    final storage = MyListStorage(await Hive.openBox<String>(MyListStorage.boxName));
    await storage.save(const MyListEntry(bookId: 'b01'));
    await storage.save(const MyListEntry(bookId: 'b02'));

    await storage.remove('b01');

    expect(storage.readAll(), [const MyListEntry(bookId: 'b02')]);
  });

  test('clear empties the storage', () async {
    final storage = MyListStorage(await Hive.openBox<String>(MyListStorage.boxName));
    await storage.save(const MyListEntry(bookId: 'b01'));

    await storage.clear();

    expect(storage.readAll(), isEmpty);
  });
}
