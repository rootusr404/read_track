import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../l10n/generated/app_localizations.dart';
import '../models/book.dart';
import '../providers/my_list_providers.dart';
import 'book_card.dart';
import 'my_list_remove_dialog.dart';

/// Carte "Ma liste" : réutilise BookCard, avec suppression au balayage.
///
/// Le balayage seul n'est pas accessible aux lecteurs d'écran : on
/// expose donc la même action via `customSemanticsActions`, ce qui la
/// rend disponible dans le menu d'actions de TalkBack/VoiceOver.
class MyListTile extends ConsumerWidget {
  const MyListTile({super.key, required this.book, required this.onTap});

  final Book book;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final entry = ref.watch(myListEntryProvider(book.id));

    Future<void> removeFromList() async {
      if (await showMyListRemoveDialog(context, l10n)) {
        await ref.read(myListProvider.notifier).remove(book.id);
      }
    }

    return Semantics(
      customSemanticsActions: {
        CustomSemanticsAction(label: l10n.myListRemoveAction): removeFromList,
      },
      child: Dismissible(
        key: ValueKey(book.id),
        direction: DismissDirection.endToStart,
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 24),
          color: Theme.of(context).colorScheme.errorContainer,
          child: const Icon(Icons.delete_outline),
        ),
        confirmDismiss: (_) => showMyListRemoveDialog(context, l10n),
        onDismissed: (_) => ref.read(myListProvider.notifier).remove(book.id),
        child: BookCard(book: book, entry: entry, onTap: onTap),
      ),
    );
  }
}
