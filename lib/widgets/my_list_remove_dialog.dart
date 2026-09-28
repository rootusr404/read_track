import 'package:flutter/material.dart';

import '../l10n/generated/app_localizations.dart';

/// Boîte de confirmation avant de retirer un livre de "Ma liste".
Future<bool> showMyListRemoveDialog(
  BuildContext context,
  AppLocalizations l10n,
) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(l10n.myListRemoveConfirmTitle),
      content: Text(l10n.myListRemoveConfirmBody),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(l10n.confirm),
        ),
      ],
    ),
  );
  return result ?? false;
}
