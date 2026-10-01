import 'package:read_track/data/key_value_store.dart';

/// Implémentation en mémoire de [KeyValueStore], pour les tests.
///
/// Aucune écriture disque, aucune dépendance à Hive : élimine le risque
/// de conflit entre l'I/O réelle et les timers internes de `pumpAndSettle`
/// dans les tests de widgets.
class InMemoryKeyValueStore implements KeyValueStore {
  final Map<String, String> _map = {};

  @override
  Iterable<String> get values => _map.values;

  @override
  String? get(String key) => _map[key];

  @override
  Future<void> put(String key, String value) async => _map[key] = value;

  @override
  Future<void> delete(String key) async => _map.remove(key);

  @override
  Future<void> clear() async => _map.clear();
}
