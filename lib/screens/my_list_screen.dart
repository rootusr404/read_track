import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../l10n/generated/app_localizations.dart';
import '../providers/book_providers.dart';
import '../providers/my_list_providers.dart';
import '../router/app_router.dart';
import '../utils/responsive.dart';
import '../widgets/error_view.dart';
import '../widgets/my_list_tile.dart';

class MyListScreen extends ConsumerWidget {
  const MyListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final books = ref.watch(myListBooksProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.myListTitle)),
      body: ResponsiveCenter(
        child: books.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => ErrorView(
            message: l10n.errorGeneric,
            retryLabel: l10n.retry,
            onRetry: () => ref.invalidate(booksProvider),
          ),
          data: (list) => list.isEmpty
              ? Center(child: Text(l10n.myListEmpty))
              : ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    final book = list[index];
                    return MyListTile(
                      book: book,
                      onTap: () => context.pushNamed(
                        AppRoutes.bookDetail,
                        pathParameters: {'id': book.id},
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }
}
