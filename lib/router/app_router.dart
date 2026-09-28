import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../screens/add_book_screen.dart';
import '../screens/book_detail_screen.dart';
import '../screens/library_screen.dart';
import '../screens/my_list_screen.dart';
import '../screens/settings_screen.dart';
import '../widgets/app_shell.dart';

/// Noms des 5 routes de l'application.
abstract final class AppRoutes {
  static const library = 'library';
  static const bookDetail = 'book-detail';
  static const addBook = 'add-book';
  static const myList = 'my-list';
  static const settings = 'settings';
}

/// Router fourni par Riverpod (une instance par ProviderScope, utile aux tests).
final routerProvider = Provider<GoRouter>((ref) {
  final router = GoRouter(
    initialLocation: '/',
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) => AppShell(navigationShell: shell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/',
                name: AppRoutes.library,
                builder: (context, state) => const LibraryScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/my-list',
                name: AppRoutes.myList,
                builder: (context, state) => const MyListScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/settings',
                name: AppRoutes.settings,
                builder: (context, state) => const SettingsScreen(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/book/:id',
        name: AppRoutes.bookDetail,
        builder: (context, state) =>
            BookDetailScreen(bookId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/add',
        name: AppRoutes.addBook,
        builder: (context, state) => const AddBookScreen(),
      ),
    ],
  );
  ref.onDispose(router.dispose);
  return router;
});
