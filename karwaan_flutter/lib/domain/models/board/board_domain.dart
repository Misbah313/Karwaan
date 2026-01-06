class BoardDomain {
  final int id;
  final String name;
  final String description;
  final DateTime createdAt;
  final int? workspaceId;

  const BoardDomain({
    required this.id,
    required this.name,
    required this.description,
    required this.createdAt,
    this.workspaceId,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BoardDomain &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}