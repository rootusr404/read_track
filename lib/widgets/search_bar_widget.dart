import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../l10n/generated/app_localizations.dart';

/// Champ de recherche avec bouton d'effacement.
///
/// HookWidget : le contrôleur est géré par `useTextEditingController`
/// (créé et libéré automatiquement, sans State manuel).
class SearchBarWidget extends HookWidget {
  const SearchBarWidget({
    super.key,
    required this.hintText,
    required this.onChanged,
    this.initialValue = '',
  });

  final String hintText;
  final String initialValue;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController(text: initialValue);
    final value = useValueListenable(controller);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: const Icon(Icons.search),
          suffixIcon: value.text.isEmpty
              ? null
              : IconButton(
                  icon: const Icon(Icons.clear),
                  tooltip: AppLocalizations.of(context).clearSearch,
                  onPressed: () {
                    controller.clear();
                    onChanged('');
                  },
                ),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(28)),
          ),
        ),
      ),
    );
  }
}
