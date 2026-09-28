/// Contrat générique d'accès aux données.
abstract interface class Repository<T> {
  Future<List<T>> getAll();
  Future<T?> getById(String id);
  Future<void> add(T item);
}
