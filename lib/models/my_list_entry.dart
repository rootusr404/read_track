import 'package:equatable/equatable.dart';

/// Statut d'un livre dans "Ma liste" (favori et/ou lu).
class MyListEntry extends Equatable {
  const MyListEntry({
    required this.bookId,
    this.isFavorite = false,
    this.isRead = false,
  });

  factory MyListEntry.fromJson(Map<String, dynamic> json) {
    return MyListEntry(
      bookId: json['bookId'] as String,
      isFavorite: (json['isFavorite'] as bool?) ?? false,
      isRead: (json['isRead'] as bool?) ?? false,
    );
  }

  final String bookId;
  final bool isFavorite;
  final bool isRead;

  MyListEntry copyWith({bool? isFavorite, bool? isRead}) {
    return MyListEntry(
      bookId: bookId,
      isFavorite: isFavorite ?? this.isFavorite,
      isRead: isRead ?? this.isRead,
    );
  }

  Map<String, dynamic> toJson() => {
    'bookId': bookId,
    'isFavorite': isFavorite,
    'isRead': isRead,
  };

  @override
  List<Object?> get props => [bookId, isFavorite, isRead];
}
