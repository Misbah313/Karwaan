class BoardDetails {
  final int id;
  final int workspaceId;
  final String name;
  final String description;
  final DateTime createdAt;

  BoardDetails(
      {required this.id,
      required this.workspaceId,
      required this.name,
      required this.description,
      required this.createdAt});
}
