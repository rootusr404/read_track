import 'package:flutter/material.dart';

/// Widget invisible qui annonce [text] aux lecteurs d'écran (liveRegion)
/// sans rien afficher ni occuper d'espace pour les utilisateurs voyants.
class ResultsAnnouncer extends StatelessWidget {
  const ResultsAnnouncer({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      liveRegion: true,
      label: text,
      child: const SizedBox.shrink(),
    );
  }
}
