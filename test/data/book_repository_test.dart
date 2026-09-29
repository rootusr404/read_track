import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:read_track/data/book_repository.dart';
import 'package:read_track/models/book.dart';

import '../support/fake_asset_bundle.dart';

void main() {
  final sampleJson = jsonEncode([
    {'id': 'b01', 'title': '1984', 'author': 'Orwell', 'category': 'Dystopie'},
    {'id': 'b02', 'title': 'Dune', 'author': 'Herbert', 'category': 'SF'},
  ]);

  BookRepository buildRepository(String json) {
    return BookRepository(
      bundle: FakeAssetBundle(json),
      latency: Duration.zero,
    );
  }

  group('BookRepository.getAll', () {
    test('parses every book from the asset', () async {
      final repository = buildRepository(sampleJson);

      final books = await repository.getAll();

      expect(books, hasLength(2));
      expect(books.map((b) => b.id), containsAll(['b01', 'b02']));
    });

    test('caches after the first load (asset read only once)', () async {
      final bundle = FakeAssetBundle(sampleJson);
      final repository = BookRepository(bundle: bundle, latency: Duration.zero);

      await repository.getAll();
      await repository.getAll();

      expect(bundle.loadStringCallCount, 1);
    });

    test('throws BookRepositoryException on malformed JSON', () async {
      final repository = buildRepository('not valid json');

      expect(repository.getAll(), throwsA(isA<BookRepositoryException>()));
    });
  });

  group('BookRepository.getById', () {
    test('returns the matching book', () async {
      final repository = buildRepository(sampleJson);

      final book = await repository.getById('b02');

      expect(book?.title, 'Dune');
    });

    test('returns null when no book matches', () async {
      final repository = buildRepository(sampleJson);

      final book = await repository.getById('missing');

      expect(book, isNull);
    });
  });

  group('BookRepository.add', () {
    test('inserts the new book, visible in a later getAll', () async {
      final repository = buildRepository(sampleJson);
      await repository.getAll(); // force le premier chargement / cache

      const newBook = Book(id: 'b03', title: 'New', author: 'Someone', category: 'Cat');
      await repository.add(newBook);

      final books = await repository.getAll();
      expect(books, contains(newBook));
      expect(books, hasLength(3));
    });

    test('throws BookRepositoryException when the id already exists', () async {
      final repository = buildRepository(sampleJson);
      await repository.getAll();

      const duplicate = Book(id: 'b01', title: 'Dup', author: 'X', category: 'Y');

      expect(repository.add(duplicate), throwsA(isA<BookRepositoryException>()));
    });
  });
}
