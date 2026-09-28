import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../l10n/generated/app_localizations.dart';
import '../providers/book_providers.dart';
import '../providers/my_list_providers.dart';
import '../router/app_router.dart';
import '../utils/responsive.dart';
import '../widgets/book_card.dart';
import '../widgets/category_filter_bar.dart';
import '../widgets/error_view.dart';
import '../widgets/search_bar_widget.dart';
import '../widgets/status_filter_bar.dart';

class LibraryScreen extends ConsumerWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final books = ref.watch(filteredBooksProvider);
    final entries = ref.watch(myListProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.libraryTitle)),
      floatingActionButton: FloatingActionButton(
        tooltip: l10n.addBookTitle,
        onPressed: () => context.pushNamed(AppRoutes.addBook),
        child: const Icon(Icons.add),
      ),
      body: ResponsiveCenter(
        child: Column(
          children: [
            SearchBarWidget(
              hintText: l10n.librarySearchHint,
              initialValue: ref.read(searchQueryProvider),
              onChanged: (value) =>
                  ref.read(searchQueryProvider.notifier).state = value,
            ),
            const StatusFilterBar(),
            const SizedBox(height: 4),
            const CategoryFilterBar(),
            const SizedBox(height: 4),
            Expanded(
              child: books.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, _) => ErrorView(
                  message: l10n.errorGeneric,
                  retryLabel: l10n.retry,
                  onRetry: () => ref.invalidate(booksProvider),
                ),
                data: (list) => list.isEmpty
                    ? Center(child: Text(l10n.libraryEmpty))
                    : ListView.builder(
                        itemCount: list.length,
                        itemBuilder: (context, index) {
                          final book = list[index];
                          return BookCard(
                            book: book,
                            entry: entries[book.id],
                            onTap: () => context.pushNamed(
                              AppRoutes.bookDetail,
                              pathParameters: {'id': book.id},
                            ),
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
