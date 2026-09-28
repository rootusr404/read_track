import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../l10n/generated/app_localizations.dart';
import '../providers/my_list_providers.dart';

/// Bouton favori (icône cœur) avec libellé d'accessibilité via tooltip.
class FavoriteButton extends ConsumerWidget {
  const FavoriteButton({super.key, required this.bookId});

  final String bookId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final entry = ref.watch(myListEntryProvider(bookId));
    final isFavorite = entry?.isFavorite ?? false;

    return IconButton(
      tooltip: isFavorite ? l10n.favoriteRemove : l10n.favoriteAdd,
      icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
      onPressed: () => ref.read(myListProvider.notifier).toggleFavorite(bookId),
    );
  }
}
