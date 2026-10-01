/// Abstraction sur un stockage clé/valeur texte.
///
/// Permet de tester `MyListStorage`/`SettingsStorage` sans dépendre de
/// Hive ni d'écriture disque réelle (voir `InMemoryKeyValueStore` dans
/// `test/support/`).
abstract interface class KeyValueStore {
  Iterable<String> get values;
  String? get(String key);
  Future<void> put(String key, String value);
  Future<void> delete(String key);
  Future<void> clear();
}
