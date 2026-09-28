import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../l10n/generated/app_localizations.dart';
import '../providers/my_list_providers.dart';

/// Actions "Ma liste" d'un livre : ajouter, marquer lu/non lu, retirer.
class BookActions extends ConsumerWidget {
  const BookActions({super.key, required this.bookId});

  final String bookId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final entry = ref.watch(myListEntryProvider(bookId));
    final notifier = ref.read(myListProvider.notifier);

    if (entry == null) {
      return SizedBox(
        width: double.infinity,
        child: FilledButton.icon(
          onPressed: () => notifier.add(bookId),
          icon: const Icon(Icons.playlist_add),
          label: Text(l10n.bookDetailAddToList),
        ),
      );
    }

    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: () => notifier.toggleRead(bookId),
            icon: Icon(entry.isRead ? Icons.undo : Icons.check),
            label: Text(
              entry.isRead
                  ? l10n.bookDetailMarkAsUnread
                  : l10n.bookDetailMarkAsRead,
            ),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () => notifier.remove(bookId),
            icon: const Icon(Icons.delete_outline),
            label: Text(l10n.bookDetailRemoveFromList),
          ),
        ),
      ],
    );
  }
}
