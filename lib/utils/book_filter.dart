import '../models/book.dart';
import '../models/library_status.dart';
import '../models/my_list_entry.dart';

/// Filtre pur (sans Riverpod) : facile à tester unitairement.
///
/// - [query] : recherche insensible à la casse sur titre ou auteur.
/// - [category] : `null` = toutes les catégories.
/// - [status] : `all`, `toRead` (dans ma liste, non lu), `read`, `favorite`.
List<Book> filterBooks(
  List<Book> books, {
  String query = '',
  String? category,
  LibraryStatus status = LibraryStatus.all,
  Map<String, MyListEntry> entries = const {},
}) {
  final q = query.trim().toLowerCase();
  return books.where((book) {
    if (category != null && book.category != category) return false;
    if (q.isNotEmpty &&
        !book.title.toLowerCase().contains(q) &&
        !book.author.toLowerCase().contains(q)) {
      return false;
    }
    return _matchesStatus(entries[book.id], status);
  }).toList();
}

bool _matchesStatus(MyListEntry? entry, LibraryStatus status) {
  return switch (status) {
    LibraryStatus.all => true,
    LibraryStatus.toRead => entry != null && !entry.isRead,
    LibraryStatus.read => entry?.isRead ?? false,
    LibraryStatus.favorite => entry?.isFavorite ?? false,
  };
}
