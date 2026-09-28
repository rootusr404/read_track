import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/book.dart';
import 'repository.dart';

/// Erreur de chargement ou d'écriture du catalogue.
class BookRepositoryException implements Exception {
  const BookRepositoryException(this.message);
  final String message;

  @override
  String toString() => 'BookRepositoryException: $message';
}

/// Catalogue lu depuis un asset JSON, avec latence réseau simulée.
///
/// Le cache est partagé entre tous les écrans : cette classe doit être
/// instanciée UNE seule fois (via un provider Riverpod, Sprint 2).
class BookRepository implements Repository<Book> {
  BookRepository({
    AssetBundle? bundle,
    this.assetPath = 'assets/data/books.json',
    this.latency = const Duration(milliseconds: 600),
  }) : _bundle = bundle ?? rootBundle;

  final AssetBundle _bundle;
  final String assetPath;
  final Duration latency;

  List<Book>? _cache;

  Future<List<Book>> _ensureLoaded() async {
    final cached = _cache;
    if (cached != null) return cached;
    try {
      final raw = await _bundle.loadString(assetPath);
      final list = jsonDecode(raw) as List<dynamic>;
      return _cache = list
          .map((e) => Book.fromJson(e as Map<String, dynamic>))
          .toList();
    } on Object catch (e) {
      throw BookRepositoryException('Impossible de charger $assetPath: $e');
    }
  }

  @override
  Future<List<Book>> getAll() async {
    await Future<void>.delayed(latency);
    return List.unmodifiable(await _ensureLoaded());
  }

  @override
  Future<Book?> getById(String id) async {
    final books = await getAll();
    for (final book in books) {
      if (book.id == id) return book;
    }
    return null;
  }

  @override
  Future<void> add(Book item) async {
    final books = await _ensureLoaded();
    if (books.any((b) => b.id == item.id)) {
      throw BookRepositoryException('Livre déjà existant: ${item.id}');
    }
    books.insert(0, item);
  }
}
