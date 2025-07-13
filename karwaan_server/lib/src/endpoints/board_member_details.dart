import 'package:serverpod/serverpod.dart';

class BoardMemberDetails implements SerializableModel {
  final int userId;
  final String userName;
  final String? email;
  final String role;
  final DateTime joinedAt;

  BoardMemberDetails({
    required this.userId,
    required this.userName,
    this.email,
    required this.role,
    required this.joinedAt,
  });

  factory BoardMemberDetails.fromJson(Map<String, dynamic> json) =>
      BoardMemberDetails(
        userId: json['userId'] as int,
        userName: json['userName'] as String,
        email: json['email'] as String?,
        role: json['role'] as String,
        joinedAt: DateTime.parse(json['joinedAt'] as String),
      );

  @override
  Map<String, dynamic> toJson() => {
        'userId': userId,
        'userName': userName,
        'email': email,
        'role': role,
        'joinedAt': joinedAt.toIso8601String(),
      };
}
