import 'package:flutter/material.dart';

import '../l10n/generated/app_localizations.dart';
import '../utils/responsive.dart';
import '../widgets/language_selector_tile.dart';
import '../widgets/theme_toggle_tile.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: const ResponsiveCenter(
        child: Column(
          children: [
            ThemeToggleTile(),
            Divider(height: 1),
            LanguageSelectorTile(),
          ],
        ),
      ),
    );
  }
}
