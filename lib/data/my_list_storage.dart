import 'dart:convert';

import '../models/my_list_entry.dart';
import 'hive_key_value_store.dart';
import 'key_value_store.dart';

/// Persistance locale de "Ma liste" (JSON dans un KeyValueStore).
class MyListStorage {
  MyListStorage(this._store);

  static const boxName = 'my_list';

  final KeyValueStore _store;

  /// À appeler après `Hive.initFlutter()`.
  static Future<MyListStorage> open() async {
    return MyListStorage(await HiveKeyValueStore.open(boxName));
  }

  List<MyListEntry> readAll() {
    return _store.values
        .map(
          (raw) =>
              MyListEntry.fromJson(jsonDecode(raw) as Map<String, dynamic>),
        )
        .toList();
  }

  Future<void> save(MyListEntry entry) {
    return _store.put(entry.bookId, jsonEncode(entry.toJson()));
  }

  Future<void> remove(String bookId) => _store.delete(bookId);

  Future<void> clear() => _store.clear();
}
