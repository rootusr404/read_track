import 'package:flutter/material.dart';

import '../l10n/generated/app_localizations.dart';
import '../models/book.dart';
import 'book_actions.dart';
import 'book_cover.dart';
import 'section_title.dart';

/// Contenu défilant de l'écran de détail d'un livre.
class BookDetailBody extends StatelessWidget {
  const BookDetailBody({super.key, required this.book});

  final Book book;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(child: BookCover(url: book.coverUrl, width: 140, height: 210)),
          const SizedBox(height: 16),
          Text(book.title, style: theme.textTheme.headlineSmall),
          const SizedBox(height: 4),
          Text(book.author, style: theme.textTheme.titleMedium),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: [
              Chip(label: Text(book.category)),
              if (book.year > 0) Chip(label: Text('${book.year}')),
              if (book.pages > 0)
                Chip(label: Text(l10n.bookDetailPages(book.pages))),
            ],
          ),
          SectionTitle(l10n.bookDetailDescription),
          Text(book.description),
          const SizedBox(height: 24),
          BookActions(bookId: book.id),
        ],
      ),
    );
  }
}
