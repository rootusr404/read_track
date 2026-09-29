import 'package:flutter_test/flutter_test.dart';
import 'package:read_track/models/book.dart';

void main() {
  group('Book', () {
    test('two books with identical fields are equal (Equatable)', () {
      const a = Book(id: '1', title: 'Dune', author: 'Herbert', category: 'SF');
      const b = Book(id: '1', title: 'Dune', author: 'Herbert', category: 'SF');

      expect(a, equals(b));
      expect(a.hashCode, equals(b.hashCode));
    });

    test('two books with different ids are not equal', () {
      const a = Book(id: '1', title: 'Dune', author: 'Herbert', category: 'SF');
      const b = Book(id: '2', title: 'Dune', author: 'Herbert', category: 'SF');

      expect(a, isNot(equals(b)));
    });

    test('fromJson parses required and optional fields', () {
      final book = Book.fromJson(const {
        'id': 'b01',
        'title': '1984',
        'author': 'Orwell',
        'category': 'Dystopie',
        'description': 'Winston...',
        'coverUrl': 'https://example.com/cover.jpg',
        'pages': 328,
        'year': 1949,
      });

      expect(book.id, 'b01');
      expect(book.title, '1984');
      expect(book.pages, 328);
      expect(book.year, 1949);
      expect(book.coverUrl, 'https://example.com/cover.jpg');
    });

    test('fromJson defaults missing optional fields', () {
      final book = Book.fromJson(const {
        'id': 'b02',
        'title': 'Minimal',
        'author': 'Someone',
        'category': 'Test',
      });

      expect(book.description, '');
      expect(book.coverUrl, isNull);
      expect(book.pages, 0);
      expect(book.year, 0);
    });

    test('toJson then fromJson round-trips to an equal book', () {
      const original = Book(
        id: 'b03',
        title: 'Round Trip',
        author: 'Author',
        category: 'Cat',
        description: 'Desc',
        coverUrl: 'https://x.test/c.jpg',
        pages: 42,
        year: 2020,
      );

      final restored = Book.fromJson(original.toJson());

      expect(restored, equals(original));
    });
  });
}
