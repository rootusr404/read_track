import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../l10n/generated/app_localizations.dart';
import '../providers/theme_provider.dart';

class ThemeToggleTile extends ConsumerWidget {
  const ThemeToggleTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final mode = ref.watch(themeModeProvider);
    final isDark = mode == ThemeMode.dark;

    return SwitchListTile(
      title: Text(l10n.settingsTheme),
      subtitle: Text(l10n.settingsThemeSubtitle),
      secondary: Icon(isDark ? Icons.dark_mode : Icons.light_mode),
      value: isDark,
      onChanged: (_) => ref.read(themeModeProvider.notifier).toggle(),
    );
  }
}
