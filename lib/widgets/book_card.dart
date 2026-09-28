import 'package:flutter/material.dart';

import '../l10n/generated/app_localizations.dart';
import '../models/book.dart';
import '../models/my_list_entry.dart';
import 'book_cover.dart';

/// Carte d'un livre dans la liste de la bibliothèque.
class BookCard extends StatelessWidget {
  const BookCard({
    super.key,
    required this.book,
    required this.onTap,
    this.entry,
  });

  final Book book;
  final MyListEntry? entry;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Semantics(
      button: true,
      label: l10n.bookCardSemantics(book.title, book.author),
      excludeSemantics: true,
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                BookCover(url: book.coverUrl),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        book.title,
                        style: theme.textTheme.titleMedium,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(book.author, style: theme.textTheme.bodyMedium),
                      const SizedBox(height: 8),
                      Text(book.category, style: theme.textTheme.labelSmall),
                    ],
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (entry?.isFavorite ?? false)
                      const Icon(Icons.favorite, size: 20),
                    if (entry?.isRead ?? false)
                      const Icon(Icons.check_circle, size: 20),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
