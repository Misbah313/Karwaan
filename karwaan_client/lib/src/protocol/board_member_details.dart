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

abstract class BoardMemberDetails implements _i1.SerializableModel {
  BoardMemberDetails._({
    this.id,
    required this.userId,
    required this.userName,
    this.email,
    required this.role,
    required this.joinedAt,
  });

  factory BoardMemberDetails({
    int? id,
    required int userId,
    required String userName,
    String? email,
    required String role,
    required DateTime joinedAt,
  }) = _BoardMemberDetailsImpl;

  factory BoardMemberDetails.fromJson(Map<String, dynamic> jsonSerialization) {
    return BoardMemberDetails(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as int,
      userName: jsonSerialization['userName'] as String,
      email: jsonSerialization['email'] as String?,
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

  String role;

  DateTime joinedAt;

  /// Returns a shallow copy of this [BoardMemberDetails]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  BoardMemberDetails copyWith({
    int? id,
    int? userId,
    String? userName,
    String? email,
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

class _BoardMemberDetailsImpl extends BoardMemberDetails {
  _BoardMemberDetailsImpl({
    int? id,
    required int userId,
    required String userName,
    String? email,
    required String role,
    required DateTime joinedAt,
  }) : super._(
          id: id,
          userId: userId,
          userName: userName,
          email: email,
          role: role,
          joinedAt: joinedAt,
        );

  /// Returns a shallow copy of this [BoardMemberDetails]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  BoardMemberDetails copyWith({
    Object? id = _Undefined,
    int? userId,
    String? userName,
    Object? email = _Undefined,
    String? role,
    DateTime? joinedAt,
  }) {
    return BoardMemberDetails(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      email: email is String? ? email : this.email,
      role: role ?? this.role,
      joinedAt: joinedAt ?? this.joinedAt,
    );
  }
}
