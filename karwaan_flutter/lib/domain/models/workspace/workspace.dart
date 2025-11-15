class Workspace {
  final int id;
  final String workspaceName;
  final String workspaceDescription;
  final DateTime createdAt;
  final String backgroundColor;
  final bool isPrivate;

  const Workspace({
    required this.id,
    required this.workspaceName,
    required this.workspaceDescription,
    required this.createdAt,
    this.backgroundColor = '#6B7280',
    this.isPrivate = false,
  });

  // Essential: copyWith method for optimized updates
  Workspace copyWith({
    int? id,
    String? workspaceName,
    String? workspaceDescription,
    DateTime? createdAt,
    String? backgroundColor,
    bool? isPrivate,
  }) {
    return Workspace(
      id: id ?? this.id,
      workspaceName: workspaceName ?? this.workspaceName,
      workspaceDescription: workspaceDescription ?? this.workspaceDescription,
      createdAt: createdAt ?? this.createdAt,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      isPrivate: isPrivate ?? this.isPrivate,
    );
  }

  // Essential: Equality methods for Bloc state comparison
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Workspace &&
        other.id == id &&
        other.workspaceName == workspaceName &&
        other.workspaceDescription == workspaceDescription &&
        other.createdAt == createdAt &&
        other.backgroundColor == backgroundColor &&
        other.isPrivate == isPrivate;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      workspaceName,
      workspaceDescription,
      createdAt,
      backgroundColor,
      isPrivate,
    );
  }

  // Optional: toString for debugging
  @override
  String toString() {
    return 'Workspace(id: $id, name: $workspaceName, description: $workspaceDescription, color: $backgroundColor, private: $isPrivate)';
  }
}
