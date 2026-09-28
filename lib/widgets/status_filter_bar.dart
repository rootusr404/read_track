import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../l10n/generated/app_localizations.dart';
import '../models/library_status.dart';
import '../providers/book_providers.dart';
import 'chip_row.dart';

/// Filtre par statut : tous / à lire / lus / favoris.
class StatusFilterBar extends ConsumerWidget {
  const StatusFilterBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final selected = ref.watch(statusFilterProvider);

    return ChipRow(
      chips: [
        for (final status in LibraryStatus.values)
          ChoiceChip(
            label: Text(_label(l10n, status)),
            selected: status == selected,
            onSelected: (_) =>
                ref.read(statusFilterProvider.notifier).state = status,
          ),
      ],
    );
  }

  String _label(AppLocalizations l10n, LibraryStatus status) {
    return switch (status) {
      LibraryStatus.all => l10n.libraryFilterAll,
      LibraryStatus.toRead => l10n.libraryFilterToRead,
      LibraryStatus.read => l10n.libraryFilterRead,
      LibraryStatus.favorite => l10n.libraryFilterFavorite,
    };
  }
}
