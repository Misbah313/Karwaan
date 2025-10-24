class CreateWorkspaceCredentials {
  final String workspaceName;
  final String workspaceDescription;
  final DateTime createdAt;
  final String backgroundColor;
  final bool isPrivate;

  CreateWorkspaceCredentials(
      {required this.workspaceName,
      required this.workspaceDescription,
      required this.createdAt,
      this.backgroundColor = '#6B7280',
      this.isPrivate = false});
}
