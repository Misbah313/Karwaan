class UpdateChecklistItemCredentails {
  final int checklistItemId;
  final int checklistId;
  final String newContent;

  UpdateChecklistItemCredentails(
      {required this.checklistItemId,
      required this.checklistId,
      required this.newContent});
}
