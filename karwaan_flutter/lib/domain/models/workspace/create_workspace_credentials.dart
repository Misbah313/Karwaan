class CreateWorkspaceCredentials {
  final String workspaceName;
  final String workspaceDescription;
  final DateTime createdAt;

  CreateWorkspaceCredentials(
      {required this.workspaceName, required this.workspaceDescription, required this.createdAt});
}
