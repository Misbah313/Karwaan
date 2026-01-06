class OverallAnalytics {
  final int userId;
  final int totalCards;
  final int totalBoard;
  final int compeletedCards;
  final double completionPercentage;
  final Map<String, int>? cardsPerWorkspace;
  final Map<String, int>? cardsPerStatus;
  final DateTime lastUpdate;

  OverallAnalytics(
      {required this.userId,
      required this.totalCards,
      required this.totalBoard,
      required this.compeletedCards,
      required this.completionPercentage,
      this.cardsPerWorkspace,
      this.cardsPerStatus,
      required this.lastUpdate});
}
