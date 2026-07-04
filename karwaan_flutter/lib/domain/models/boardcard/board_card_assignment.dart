class BoardCardAssignment {
  final int id;
  final int cardId;
  final int userId;
  final int assignedBy;
  final DateTime assignedAt;

  BoardCardAssignment(
      {required this.id,
      required this.cardId,
      required this.userId,
      required this.assignedBy,
      required this.assignedAt});

  BoardCardAssignment copyWith(
      {int? id,
      int? cardId,
      int? userId,
      int? assignedBy,
      DateTime? assignedAt}) {
    return BoardCardAssignment(
        id: id ?? this.id,
        cardId: cardId ?? this.cardId,
        userId: userId ?? this.userId,
        assignedBy: assignedBy ?? this.assignedBy,
        assignedAt: assignedAt ?? this.assignedAt);
  }
}
