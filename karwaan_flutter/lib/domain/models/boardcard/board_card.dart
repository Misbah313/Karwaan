class BoardCard {
  final int id;
  final int boardListId;
  final String title;
  final String description;
  final DateTime createdAt;
  final bool isCompleted;
  final List<int>? assignedUserIds;
  final List<int>? assignedLabelIds;

  BoardCard(
      {required this.id,
      required this.boardListId,
      required this.title,
      required this.description,
      required this.createdAt,
      required this.isCompleted,
      this.assignedUserIds,
      this.assignedLabelIds});

  BoardCard copyWith(
      {int? id,
      int? boardlistId,
      String? title,
      String? description,
      DateTime? createdAt,
      bool? isCompleted,
      List<int>? assignedUserIds,
      List<int>? assignedLabelIds}) {
    return BoardCard(
        id: id ?? this.id,
        boardListId: boardListId,
        title: title ?? this.title,
        description: description ?? this.description,
        createdAt: createdAt ?? this.createdAt,
        isCompleted: isCompleted ?? this.isCompleted,
        assignedUserIds: assignedUserIds ?? this.assignedUserIds,
        assignedLabelIds: assignedLabelIds ?? this.assignedLabelIds);
  }
}
