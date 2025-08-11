class CreateBoardCredentials {
  final int workspaceId;
  final String boardName;
  final String boardDescription;
  final DateTime createdAt;

  CreateBoardCredentials(
      {required this.workspaceId,
      required this.boardName,
      required this.boardDescription,
      required this.createdAt});
}
