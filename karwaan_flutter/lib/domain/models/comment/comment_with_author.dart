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
}
