import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../l10n/generated/app_localizations.dart';
import '../providers/book_providers.dart';
import 'chip_row.dart';

/// Filtre par catégorie, construit depuis les catégories du catalogue.
class CategoryFilterBar extends ConsumerWidget {
  const CategoryFilterBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(categoriesProvider);
    if (categories.isEmpty) return const SizedBox.shrink();

    final l10n = AppLocalizations.of(context);
    final selected = ref.watch(categoryFilterProvider);
    final notifier = ref.read(categoryFilterProvider.notifier);

    return ChipRow(
      chips: [
        ChoiceChip(
          label: Text(l10n.libraryFilterAll),
          selected: selected == null,
          onSelected: (_) => notifier.state = null,
        ),
        for (final category in categories)
          ChoiceChip(
            label: Text(category),
            selected: category == selected,
            onSelected: (_) => notifier.state = category,
          ),
      ],
    );
  }
}
