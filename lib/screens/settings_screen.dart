import 'package:flutter/material.dart';

import '../l10n/generated/app_localizations.dart';

/// Placeholder Sprint 3 : implémenté dans un sprint suivant.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: const SizedBox.shrink(),
    );
  }
}
