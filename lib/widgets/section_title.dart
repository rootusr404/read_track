import 'package:flutter/material.dart';

/// Titre de section (annoncé comme en-tête par les lecteurs d'écran).
class SectionTitle extends StatelessWidget {
  const SectionTitle(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      header: true,
      child: Padding(
        padding: const EdgeInsets.only(top: 16, bottom: 8),
        child: Text(text, style: Theme.of(context).textTheme.titleMedium),
      ),
    );
  }
}
