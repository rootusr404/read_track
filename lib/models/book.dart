import 'package:equatable/equatable.dart';

/// Livre du catalogue. Immuable, comparé par valeur (Equatable).
class Book extends Equatable {
  const Book({
    required this.id,
    required this.title,
    required this.author,
    required this.category,
    this.description = '',
    this.coverUrl,
    this.pages = 0,
    this.year = 0,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'] as String,
      title: json['title'] as String,
      author: json['author'] as String,
      category: json['category'] as String,
      description: (json['description'] as String?) ?? '',
      coverUrl: json['coverUrl'] as String?,
      pages: (json['pages'] as num?)?.toInt() ?? 0,
      year: (json['year'] as num?)?.toInt() ?? 0,
    );
  }

  final String id;
  final String title;
  final String author;
  final String category;
  final String description;
  final String? coverUrl;
  final int pages;
  final int year;

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'author': author,
    'category': category,
    'description': description,
    'coverUrl': coverUrl,
    'pages': pages,
    'year': year,
  };

  @override
  List<Object?> get props => [
    id,
    title,
    author,
    category,
    description,
    coverUrl,
    pages,
    year,
  ];
}
