class Workspace {
  final int id;
  final String workspaceName;
  final String workspaceDescription;
  final DateTime createdAt;

  Workspace(
      {required this.id,
      required this.workspaceName,
      required this.workspaceDescription, required this.createdAt});
}
