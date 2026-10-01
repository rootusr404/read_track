import 'package:flutter_test/flutter_test.dart';
import 'package:read_track/models/my_list_entry.dart';

void main() {
  group('MyListEntry', () {
    test('defaults isFavorite and isRead to false', () {
      const entry = MyListEntry(bookId: 'b01');

      expect(entry.isFavorite, isFalse);
      expect(entry.isRead, isFalse);
    });

    test('copyWith changes only the requested field', () {
      const entry = MyListEntry(bookId: 'b01');

      final favorited = entry.copyWith(isFavorite: true);

      expect(favorited.isFavorite, isTrue);
      expect(favorited.isRead, isFalse);
      expect(favorited.bookId, 'b01');
    });

    test('toJson then fromJson round-trips to an equal entry', () {
      const original = MyListEntry(
        bookId: 'b01',
        isFavorite: true,
        isRead: true,
      );

      final restored = MyListEntry.fromJson(original.toJson());

      expect(restored, equals(original));
    });
  });
}
