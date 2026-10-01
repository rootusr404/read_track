import 'package:hive_flutter/hive_flutter.dart';

import 'key_value_store.dart';

/// Implémentation de [KeyValueStore] adossée à une `Box<String>` Hive.
class HiveKeyValueStore implements KeyValueStore {
  HiveKeyValueStore(this._box);

  final Box<String> _box;

  static Future<HiveKeyValueStore> open(String boxName) async {
    return HiveKeyValueStore(await Hive.openBox<String>(boxName));
  }

  @override
  Iterable<String> get values => _box.values;

  @override
  String? get(String key) => _box.get(key);

  @override
  Future<void> put(String key, String value) => _box.put(key, value);

  @override
  Future<void> delete(String key) => _box.delete(key);

  @override
  Future<void> clear() => _box.clear();
}
