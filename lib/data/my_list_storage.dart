import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';

import '../models/my_list_entry.dart';

/// Persistance locale de "Ma liste" (Hive, JSON dans une Box<String>).
///
/// Pas d'adapter généré : sérialisation explicite via MyListEntry.toJson.
class MyListStorage {
  MyListStorage(this._box);

  static const boxName = 'my_list';

  final Box<String> _box;

  /// À appeler après `Hive.initFlutter()`.
  static Future<MyListStorage> open() async {
    return MyListStorage(await Hive.openBox<String>(boxName));
  }

  List<MyListEntry> readAll() {
    return _box.values
        .map(
          (raw) =>
              MyListEntry.fromJson(jsonDecode(raw) as Map<String, dynamic>),
        )
        .toList();
  }

  Future<void> save(MyListEntry entry) {
    return _box.put(entry.bookId, jsonEncode(entry.toJson()));
  }

  Future<void> remove(String bookId) => _box.delete(bookId);

  Future<void> clear() => _box.clear();
}
