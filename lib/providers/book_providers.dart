import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/book_repository.dart';
import '../models/book.dart';
import '../models/library_status.dart';
import '../utils/book_filter.dart';
import 'my_list_providers.dart';

/// Instance unique du repository (cache partagé entre tous les écrans).
final bookRepositoryProvider = Provider<BookRepository>((ref) {
  return BookRepository();
});

/// Catalogue complet (FutureProvider : gère loading / error / data).
final booksProvider = FutureProvider<List<Book>>((ref) {
  return ref.watch(bookRepositoryProvider).getAll();
});

/// Texte de recherche saisi par l'utilisateur.
final searchQueryProvider = StateProvider<String>((ref) => '');

/// Catégorie sélectionnée (`null` = toutes).
final categoryFilterProvider = StateProvider<String?>((ref) => null);

/// Statut sélectionné (tous / à lire / lus / favoris).
final statusFilterProvider = StateProvider<LibraryStatus>(
  (ref) => LibraryStatus.all,
);

/// Catégories disponibles, dérivées du catalogue.
final categoriesProvider = Provider<List<String>>((ref) {
  final books = ref.watch(booksProvider).valueOrNull ?? const <Book>[];
  return (books.map((b) => b.category).toSet().toList())..sort();
});

/// Composition : catalogue + recherche + catégorie + statut + ma liste.
final filteredBooksProvider = Provider<AsyncValue<List<Book>>>((ref) {
  final query = ref.watch(searchQueryProvider);
  final category = ref.watch(categoryFilterProvider);
  final status = ref.watch(statusFilterProvider);
  final entries = ref.watch(myListProvider);
  return ref
      .watch(booksProvider)
      .whenData(
        (books) => filterBooks(
          books,
          query: query,
          category: category,
          status: status,
          entries: entries,
        ),
      );
});

/// Un livre par id (Provider.family), dérivé du catalogue.
final bookByIdProvider = Provider.family<AsyncValue<Book?>, String>((ref, id) {
  return ref
      .watch(booksProvider)
      .whenData((books) => books.where((b) => b.id == id).firstOrNull);
});
