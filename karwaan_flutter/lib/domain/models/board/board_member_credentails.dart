class BoardMemberCredentails {
  final int userId;
  final int boardId;
  final String userName;
  final String userRole;

  BoardMemberCredentails(
      {required this.userId,
      required this.boardId,
      required this.userName,
      required this.userRole});
}
