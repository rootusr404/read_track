import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/my_list_storage.dart';
import '../models/book.dart';
import '../models/my_list_entry.dart';
import 'book_providers.dart';

/// Storage Hive : doit être fourni via `overrides` (main.dart et tests).
final myListStorageProvider = Provider<MyListStorage>((ref) {
  throw UnimplementedError('myListStorageProvider must be overridden');
});

/// État de "Ma liste" : bookId -> entrée. Chaque modification est persistée.
class MyListNotifier extends StateNotifier<Map<String, MyListEntry>> {
  MyListNotifier(MyListStorage storage)
    : _storage = storage,
      super({for (final e in storage.readAll()) e.bookId: e});

  final MyListStorage _storage;

  Future<void> add(String bookId) {
    return _put(state[bookId] ?? MyListEntry(bookId: bookId));
  }

  Future<void> toggleFavorite(String bookId) {
    final current = state[bookId] ?? MyListEntry(bookId: bookId);
    return _put(current.copyWith(isFavorite: !current.isFavorite));
  }

  Future<void> toggleRead(String bookId) {
    final current = state[bookId] ?? MyListEntry(bookId: bookId);
    return _put(current.copyWith(isRead: !current.isRead));
  }

  Future<void> remove(String bookId) async {
    if (!state.containsKey(bookId)) return;
    state = {...state}..remove(bookId);
    await _storage.remove(bookId);
  }

  Future<void> _put(MyListEntry entry) async {
    state = {...state, entry.bookId: entry};
    await _storage.save(entry);
  }
}

final myListProvider =
    StateNotifierProvider<MyListNotifier, Map<String, MyListEntry>>((ref) {
      return MyListNotifier(ref.watch(myListStorageProvider));
    });

/// Entrée d'un livre dans ma liste (`null` si absent) — Provider.family.
final myListEntryProvider = Provider.family<MyListEntry?, String>((
  ref,
  bookId,
) {
  return ref.watch(myListProvider)[bookId];
});

/// Composition : catalogue + ma liste -> livres de ma liste.
final myListBooksProvider = Provider<AsyncValue<List<Book>>>((ref) {
  final entries = ref.watch(myListProvider);
  return ref.watch(booksProvider).whenData((books) {
    final byId = {for (final b in books) b.id: b};
    return entries.keys.map((id) => byId[id]).whereType<Book>().toList();
  });
});
