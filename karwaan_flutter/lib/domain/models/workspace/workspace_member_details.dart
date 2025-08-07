class WorkspaceMemberDetail {
  final int userId;
  final String userName;
  final String? email;
  final String role;
  final DateTime joinedAt;

  WorkspaceMemberDetail({
    required this.userId,
    required this.userName,
    this.email,
    required this.role,
    required this.joinedAt,
  });
}



