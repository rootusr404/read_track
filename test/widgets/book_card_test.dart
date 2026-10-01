import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:read_track/l10n/generated/app_localizations.dart';
import 'package:read_track/models/book.dart';
import 'package:read_track/models/my_list_entry.dart';
import 'package:read_track/widgets/book_card.dart';

const _book = Book(
  id: 'b01',
  title: '1984',
  author: 'George Orwell',
  category: 'Dystopie',
);

Widget _wrap(Widget child) {
  return MaterialApp(
    locale: const Locale('en'),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(body: child),
  );
}

void main() {
  testWidgets('renders the title, author and category', (tester) async {
    await tester.pumpWidget(_wrap(BookCard(book: _book, onTap: () {})));

    expect(find.text('1984'), findsOneWidget);
    expect(find.text('George Orwell'), findsOneWidget);
    expect(find.text('Dystopie'), findsOneWidget);
  });

  testWidgets('shows favorite and read icons only when the entry says so', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        BookCard(
          book: _book,
          entry: const MyListEntry(
            bookId: 'b01',
            isFavorite: true,
            isRead: true,
          ),
          onTap: () {},
        ),
      ),
    );

    expect(find.byIcon(Icons.favorite), findsOneWidget);
    expect(find.byIcon(Icons.check_circle), findsOneWidget);
  });

  testWidgets('hides favorite and read icons with no entry', (tester) async {
    await tester.pumpWidget(_wrap(BookCard(book: _book, onTap: () {})));

    expect(find.byIcon(Icons.favorite), findsNothing);
    expect(find.byIcon(Icons.check_circle), findsNothing);
  });

  testWidgets('calls onTap when tapped', (tester) async {
    var tapped = false;
    await tester.pumpWidget(
      _wrap(BookCard(book: _book, onTap: () => tapped = true)),
    );

    await tester.tap(find.byType(InkWell));

    expect(tapped, isTrue);
  });
}
