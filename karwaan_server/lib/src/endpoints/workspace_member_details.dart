import 'package:serverpod/serverpod.dart';

class WorkspaceMemberDetails implements SerializableModel {
  final int userId;
  final String userName;
  final String? email;
  final String? avatarUrl;
  final String role;
  final DateTime joinedAt;

  WorkspaceMemberDetails({
    required this.userId,
    required this.userName,
    this.email,
    this.avatarUrl,
    required this.role,
    required this.joinedAt,
  });

  factory WorkspaceMemberDetails.fromJson(Map<String, dynamic> json) => WorkspaceMemberDetails(
    userId: json['userId'] as int,
    userName: json['userName'] as String,
    email: json['email'] as String?,
    avatarUrl: json['avatarUrl'] as String?,
    role: json['role'] as String,
    joinedAt: DateTime.parse(json['joinedAt'] as String),
  );

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'userName': userName,
    'email': email,
    'avatarUrl': avatarUrl,
    'role': role,
    'joinedAt': joinedAt.toIso8601String(),
  };
}
