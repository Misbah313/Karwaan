class BoardAnalytics {
  final int boardId;
  final int totalCards;
  final int completedCards;
  final double completionPercentage;
  final Map<String, int>? cardPerList;
  final DateTime lastUpdate;

  BoardAnalytics(
      {required this.boardId,
      required this.totalCards,
      required this.completedCards,
      required this.completionPercentage,
      this.cardPerList,
      required this.lastUpdate});
}
