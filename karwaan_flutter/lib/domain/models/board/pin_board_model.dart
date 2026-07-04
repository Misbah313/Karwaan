class PinnedBoard {
  final int id;
  final int boardId;
  final String boardName;
  final String? boardDescription;
  final DateTime pinnedAt;

  PinnedBoard({
    required this.id,
    required this.boardId,
    required this.boardName,
    this.boardDescription,
    required this.pinnedAt,
  });

}