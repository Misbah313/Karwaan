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

abstract class WorkspaceMember implements _i1.SerializableModel {
  WorkspaceMember._({
    this.id,
    required this.user,
    required this.workspace,
    this.role,
    required this.joinedAt,
  });

  factory WorkspaceMember({
    int? id,
    required int user,
    required int workspace,
    String? role,
    required DateTime joinedAt,
  }) = _WorkspaceMemberImpl;

  factory WorkspaceMember.fromJson(Map<String, dynamic> jsonSerialization) {
    return WorkspaceMember(
      id: jsonSerialization['id'] as int?,
      user: jsonSerialization['user'] as int,
      workspace: jsonSerialization['workspace'] as int,
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

  int workspace;

  String? role;

  DateTime joinedAt;

  /// Returns a shallow copy of this [WorkspaceMember]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  WorkspaceMember copyWith({
    int? id,
    int? user,
    int? workspace,
    String? role,
    DateTime? joinedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'user': user,
      'workspace': workspace,
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

class _WorkspaceMemberImpl extends WorkspaceMember {
  _WorkspaceMemberImpl({
    int? id,
    required int user,
    required int workspace,
    String? role,
    required DateTime joinedAt,
  }) : super._(
          id: id,
          user: user,
          workspace: workspace,
          role: role,
          joinedAt: joinedAt,
        );

  /// Returns a shallow copy of this [WorkspaceMember]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  WorkspaceMember copyWith({
    Object? id = _Undefined,
    int? user,
    int? workspace,
    Object? role = _Undefined,
    DateTime? joinedAt,
  }) {
    return WorkspaceMember(
      id: id is int? ? id : this.id,
      user: user ?? this.user,
      workspace: workspace ?? this.workspace,
      role: role is String? ? role : this.role,
      joinedAt: joinedAt ?? this.joinedAt,
    );
  }
}
