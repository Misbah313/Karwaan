class BoardCard {
  final int id;
  final int boardListId;
  final String title;
  final String description;
  final DateTime createdAt;
  final bool isCompleted;

  BoardCard(
      {required this.id,
      required this.boardListId,
      required this.title,
      required this.description,
      required this.createdAt,
      required this.isCompleted});
}
