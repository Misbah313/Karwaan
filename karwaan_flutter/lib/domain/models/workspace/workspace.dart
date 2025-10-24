class Workspace {
  final int id;
  final String workspaceName;
  final String workspaceDescription;
  final DateTime createdAt;
  final String backgroundColor;
  final bool isPrivate;

  Workspace(
      {required this.id,
      required this.workspaceName,
      required this.workspaceDescription,
      required this.createdAt,
      this.backgroundColor = '#6B7280',
      this.isPrivate = false});
}
