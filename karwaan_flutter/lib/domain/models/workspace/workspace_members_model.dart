class WorkspaceMembersModel {
  final int id;
  final int workspaceId;
  final int userId;
  final String usersName;
  final String role;

  WorkspaceMembersModel(
      this.id, this.userId, this.workspaceId, this.usersName, this.role);
}
