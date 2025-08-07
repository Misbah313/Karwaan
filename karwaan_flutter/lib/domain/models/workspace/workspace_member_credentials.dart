class WorkspaceMemberCredential {
  final int userId;
  final int workspaceId;
  final String userName;
  final String userRole;

  WorkspaceMemberCredential(
      {required this.userId,
      required this.workspaceId,
      required this.userName,
      required this.userRole});
}
