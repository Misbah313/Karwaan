class WorkspaceMemberDetail {
  final int userId;
  final String userName;
  final String? email;
  final String role;
  final DateTime joinedAt;
  final String? avatarUrl;

  WorkspaceMemberDetail(
      {required this.userId,
      required this.userName,
      this.email,
      required this.role,
      required this.joinedAt,
      this.avatarUrl});

  // copyWith method
  WorkspaceMemberDetail copyWith({
    int? userId,
    String? userName,
    String? email,
    String? role,
    DateTime? joinedAt,
    String? avatarUrl,
  }) {
    return WorkspaceMemberDetail(
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      email: email ?? this.email,
      role: role ?? this.role,
      joinedAt: joinedAt ?? this.joinedAt,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }

  // equality methods
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is WorkspaceMemberDetail &&
        other.userId == userId &&
        other.userName == userName &&
        other.email == email &&
        other.role == role &&
        other.joinedAt == joinedAt &&
        other.avatarUrl == avatarUrl;
  }

  @override
  int get hashCode {
    return Object.hash(
      userId,
      userName,
      email,
      role,
      joinedAt,
      avatarUrl,
    );
  }
}
