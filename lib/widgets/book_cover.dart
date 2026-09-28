import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// Couverture : chargement paresseux + cache disque/mémoire.
///
/// Sans URL (ou en cas d'erreur), affiche une icône de remplacement.
class BookCover extends StatelessWidget {
  const BookCover({
    super.key,
    required this.url,
    this.width = 60,
    this.height = 90,
  });

  final String? url;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    final placeholder = ColoredBox(
      color: Theme.of(context).colorScheme.secondaryContainer,
      child: const Icon(Icons.menu_book),
    );
    final pixelRatio = MediaQuery.devicePixelRatioOf(context);
    final imageUrl = url;

    return ExcludeSemantics(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: SizedBox(
          width: width,
          height: height,
          child: imageUrl == null
              ? placeholder
              : CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.cover,
                  memCacheWidth: (width * pixelRatio).round(),
                  placeholder: (context, _) => placeholder,
                  errorWidget: (context, _, __) => placeholder,
                ),
        ),
      ),
    );
  }
}
