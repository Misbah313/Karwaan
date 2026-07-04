class Boardlist {
  final int id;
  String boardlistTitle;
  final DateTime createdAt;

  Boardlist(
      {required this.id,
      required this.boardlistTitle,
      required this.createdAt});

  Boardlist copyWith({int? id, String? boardlistTitle, DateTime? createdAt}) {
    return Boardlist(
        id: id ?? this.id,
        boardlistTitle: boardlistTitle ?? this.boardlistTitle,
        createdAt: createdAt ?? this.createdAt);
  }
}
