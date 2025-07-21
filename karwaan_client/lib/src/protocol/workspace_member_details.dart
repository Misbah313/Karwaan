/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

abstract class WorkspaceMemberDetails implements _i1.SerializableModel {
  WorkspaceMemberDetails._({
    this.id,
    required this.userId,
    required this.userName,
    this.email,
    this.avatarUrl,
    required this.role,
    required this.joinedAt,
  });

  factory WorkspaceMemberDetails({
    int? id,
    required int userId,
    required String userName,
    String? email,
    String? avatarUrl,
    required String role,
    required DateTime joinedAt,
  }) = _WorkspaceMemberDetailsImpl;

  factory WorkspaceMemberDetails.fromJson(
      Map<String, dynamic> jsonSerialization) {
    return WorkspaceMemberDetails(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as int,
      userName: jsonSerialization['userName'] as String,
      email: jsonSerialization['email'] as String?,
      avatarUrl: jsonSerialization['avatarUrl'] as String?,
      role: jsonSerialization['role'] as String,
      joinedAt:
          _i1.DateTimeJsonExtension.fromJson(jsonSerialization['joinedAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int userId;

  String userName;

  String? email;

  String? avatarUrl;

  String role;

  DateTime joinedAt;

  /// Returns a shallow copy of this [WorkspaceMemberDetails]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  WorkspaceMemberDetails copyWith({
    int? id,
    int? userId,
    String? userName,
    String? email,
    String? avatarUrl,
    String? role,
    DateTime? joinedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'userId': userId,
      'userName': userName,
      if (email != null) 'email': email,
      if (avatarUrl != null) 'avatarUrl': avatarUrl,
      'role': role,
      'joinedAt': joinedAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _WorkspaceMemberDetailsImpl extends WorkspaceMemberDetails {
  _WorkspaceMemberDetailsImpl({
    int? id,
    required int userId,
    required String userName,
    String? email,
    String? avatarUrl,
    required String role,
    required DateTime joinedAt,
  }) : super._(
          id: id,
          userId: userId,
          userName: userName,
          email: email,
          avatarUrl: avatarUrl,
          role: role,
          joinedAt: joinedAt,
        );

  /// Returns a shallow copy of this [WorkspaceMemberDetails]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  WorkspaceMemberDetails copyWith({
    Object? id = _Undefined,
    int? userId,
    String? userName,
    Object? email = _Undefined,
    Object? avatarUrl = _Undefined,
    String? role,
    DateTime? joinedAt,
  }) {
    return WorkspaceMemberDetails(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      email: email is String? ? email : this.email,
      avatarUrl: avatarUrl is String? ? avatarUrl : this.avatarUrl,
      role: role ?? this.role,
      joinedAt: joinedAt ?? this.joinedAt,
    );
  }
}
