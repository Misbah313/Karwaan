class BoardMemberDetails {
  final int userId;
  final String userName;
  final String userEmail;
  final String userRole;
  final DateTime joinedAt;

  BoardMemberDetails(
      {required this.userId,
      required this.userName,
      required this.userEmail,
      required this.userRole,
      required this.joinedAt});
}
