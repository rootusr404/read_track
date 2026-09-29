import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../l10n/generated/app_localizations.dart';
import '../providers/locale_provider.dart';

class LanguageSelectorTile extends ConsumerWidget {
  const LanguageSelectorTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final current = ref.watch(localeProvider);

    return ListTile(
      leading: const Icon(Icons.language),
      title: Text(l10n.settingsLanguage),
      trailing: SegmentedButton<Locale>(
        segments: [
          ButtonSegment(
            value: const Locale('fr'),
            label: Text(l10n.settingsLanguageFrench),
          ),
          ButtonSegment(
            value: const Locale('en'),
            label: Text(l10n.settingsLanguageEnglish),
          ),
        ],
        selected: {current},
        onSelectionChanged: (selection) =>
            ref.read(localeProvider.notifier).set(selection.first),
      ),
    );
  }
}
