class Board {
  final int id;
  final String boardName;
  final String boardDescription;
  final DateTime createAt;
  // final String createdBy;

  Board(
      {required this.id,
      required this.boardName,
      required this.boardDescription,
      required this.createAt,
      // required this.createdBy
      });

Board copyWith({
  int? id,
  String? boardName,
  String? boardDescription,
  DateTime? createAt,
}) {
  return Board(id: id ?? this.id, boardName: boardName ?? this.boardName, boardDescription: boardDescription ?? this.boardDescription, createAt: createAt ?? this.createAt);
}
}
