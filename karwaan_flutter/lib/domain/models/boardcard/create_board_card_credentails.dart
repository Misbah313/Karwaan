class CreateBoardCardCredentails {
  final int id;
  final String title;
  final String description;
  final DateTime createAt;
  final List<int>? assignedUserIds;
  final List<int>? assignedLabelIds;

  CreateBoardCardCredentails(
      {required this.id,
      required this.title,
      required this.description,
      required this.createAt,
      this.assignedUserIds,
      this.assignedLabelIds});
}
