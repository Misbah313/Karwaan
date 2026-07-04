class CommentWithAuthor {
  final int id;
  final int cardId;
  final int authorId;
  final String authorName;
  final String content;
  final DateTime createdAt;

  CommentWithAuthor(
      {required this.id,
      required this.cardId,
      required this.authorId,
      required this.authorName,
      required this.content,
      required this.createdAt});

  CommentWithAuthor copyWith(
      {int? id,
      int? cardId,
      int? authorId,
      String? authorName,
      String? content,
      DateTime? createdAt}) {
    return CommentWithAuthor(
        id: id ?? this.id,
        cardId: cardId ?? this.cardId,
        authorId: authorId ?? this.authorId,
        authorName: authorName ?? this.authorName,
        content: content ?? this.content,
        createdAt: createdAt ?? this.createdAt);
  }
}
