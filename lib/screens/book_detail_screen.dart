import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../l10n/generated/app_localizations.dart';
import '../providers/book_providers.dart';
import '../utils/responsive.dart';
import '../widgets/book_detail_body.dart';
import '../widgets/error_view.dart';
import '../widgets/favorite_button.dart';

class BookDetailScreen extends ConsumerWidget {
  const BookDetailScreen({super.key, required this.bookId});

  final String bookId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final book = ref.watch(bookByIdProvider(bookId));

    return Scaffold(
      appBar: AppBar(
        title: Text(book.valueOrNull?.title ?? ''),
        actions: [if (book.valueOrNull != null) FavoriteButton(bookId: bookId)],
      ),
      body: ResponsiveCenter(
        child: book.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => ErrorView(
            message: l10n.errorGeneric,
            retryLabel: l10n.retry,
            onRetry: () => ref.invalidate(booksProvider),
          ),
          data: (value) => value == null
              ? Center(child: Text(l10n.bookDetailNotFound))
              : BookDetailBody(book: value),
        ),
      ),
    );
  }
}
