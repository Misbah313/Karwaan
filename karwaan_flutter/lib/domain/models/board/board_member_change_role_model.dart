class BoardMemberChangeRoleModel {
  final int targetUserId;
  final int boardId;
  final String newRole;

  BoardMemberChangeRoleModel(
      {required this.targetUserId,
      required this.boardId,
      required this.newRole});
}
