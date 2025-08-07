class WorkspaceChangeRoleMemberModel {
  final int targetUserId;
  final int workspaceId;
  final String newRole;

  const WorkspaceChangeRoleMemberModel({
    required this.targetUserId,
    required this.workspaceId,
    required this.newRole,
  });
}
