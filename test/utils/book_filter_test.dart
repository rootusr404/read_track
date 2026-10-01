import 'package:flutter_test/flutter_test.dart';
import 'package:read_track/models/book.dart';
import 'package:read_track/models/library_status.dart';
import 'package:read_track/models/my_list_entry.dart';
import 'package:read_track/utils/book_filter.dart';

void main() {
  const orwell = Book(
    id: '1',
    title: '1984',
    author: 'George Orwell',
    category: 'Dystopie',
  );
  const austen = Book(
    id: '2',
    title: 'Pride and Prejudice',
    author: 'Jane Austen',
    category: 'Classique',
  );
  const herbert = Book(
    id: '3',
    title: 'Dune',
    author: 'Frank Herbert',
    category: 'SF',
  );
  final books = [orwell, austen, herbert];

  group('filterBooks', () {
    test('returns every book with default arguments', () {
      expect(filterBooks(books), hasLength(3));
    });

    test('matches a query against the title, case-insensitive', () {
      final result = filterBooks(books, query: 'dune');
      expect(result, [herbert]);
    });

    test('matches a query against the author', () {
      final result = filterBooks(books, query: 'orwell');
      expect(result, [orwell]);
    });

    test('filters by category', () {
      final result = filterBooks(books, category: 'SF');
      expect(result, [herbert]);
    });

    test('combines a query and a category', () {
      final result = filterBooks(books, query: 'a', category: 'Classique');
      expect(result, [austen]);
    });

    test('status.toRead keeps only books in the list and not read', () {
      final entries = {'1': const MyListEntry(bookId: '1')};
      final result = filterBooks(
        books,
        status: LibraryStatus.toRead,
        entries: entries,
      );
      expect(result, [orwell]);
    });

    test('status.read keeps only books marked as read', () {
      final entries = {'2': const MyListEntry(bookId: '2', isRead: true)};
      final result = filterBooks(
        books,
        status: LibraryStatus.read,
        entries: entries,
      );
      expect(result, [austen]);
    });

    test('status.favorite keeps only favorited books', () {
      final entries = {'3': const MyListEntry(bookId: '3', isFavorite: true)};
      final result = filterBooks(
        books,
        status: LibraryStatus.favorite,
        entries: entries,
      );
      expect(result, [herbert]);
    });

    test('status.toRead excludes a book already marked as read', () {
      final entries = {'1': const MyListEntry(bookId: '1', isRead: true)};
      final result = filterBooks(
        books,
        status: LibraryStatus.toRead,
        entries: entries,
      );
      expect(result, isEmpty);
    });
  });
}
