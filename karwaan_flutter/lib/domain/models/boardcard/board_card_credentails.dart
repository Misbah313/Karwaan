class BoardCardCredentails {
  final int cardId;
  final String newTitle;
  final String newDec;
  final bool isCompleted;
  final List<int>? assignedUserIds;
  final List<int>? assignedLabelIds;

  BoardCardCredentails(
      {required this.cardId,
      required this.newTitle,
      required this.newDec,
      required this.isCompleted,
      this.assignedUserIds,
      this.assignedLabelIds});
}
