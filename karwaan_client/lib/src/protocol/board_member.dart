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

abstract class BoardMember implements _i1.SerializableModel {
  BoardMember._({
    this.id,
    required this.user,
    required this.board,
    this.role,
    required this.joinedAt,
  });

  factory BoardMember({
    int? id,
    required int user,
    required int board,
    String? role,
    required DateTime joinedAt,
  }) = _BoardMemberImpl;

  factory BoardMember.fromJson(Map<String, dynamic> jsonSerialization) {
    return BoardMember(
      id: jsonSerialization['id'] as int?,
      user: jsonSerialization['user'] as int,
      board: jsonSerialization['board'] as int,
      role: jsonSerialization['role'] as String?,
      joinedAt:
          _i1.DateTimeJsonExtension.fromJson(jsonSerialization['joinedAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int user;

  int board;

  String? role;

  DateTime joinedAt;

  /// Returns a shallow copy of this [BoardMember]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  BoardMember copyWith({
    int? id,
    int? user,
    int? board,
    String? role,
    DateTime? joinedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'user': user,
      'board': board,
      if (role != null) 'role': role,
      'joinedAt': joinedAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _BoardMemberImpl extends BoardMember {
  _BoardMemberImpl({
    int? id,
    required int user,
    required int board,
    String? role,
    required DateTime joinedAt,
  }) : super._(
          id: id,
          user: user,
          board: board,
          role: role,
          joinedAt: joinedAt,
        );

  /// Returns a shallow copy of this [BoardMember]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  BoardMember copyWith({
    Object? id = _Undefined,
    int? user,
    int? board,
    Object? role = _Undefined,
    DateTime? joinedAt,
  }) {
    return BoardMember(
      id: id is int? ? id : this.id,
      user: user ?? this.user,
      board: board ?? this.board,
      role: role is String? ? role : this.role,
      joinedAt: joinedAt ?? this.joinedAt,
    );
  }
}
