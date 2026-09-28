import 'package:flutter/material.dart';

/// Rangée de chips défilante horizontalement.
class ChipRow extends StatelessWidget {
  const ChipRow({super.key, required this.chips});

  final List<Widget> chips;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          for (final chip in chips)
            Padding(padding: const EdgeInsets.only(right: 8), child: chip),
        ],
      ),
    );
  }
}
