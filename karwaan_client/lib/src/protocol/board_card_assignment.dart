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

abstract class BoardCardAssignment implements _i1.SerializableModel {
  BoardCardAssignment._({
    this.id,
    required this.card,
    required this.user,
    required this.assignedBy,
    required this.assignedAt,
  });

  factory BoardCardAssignment({
    int? id,
    required int card,
    required int user,
    required int assignedBy,
    required DateTime assignedAt,
  }) = _BoardCardAssignmentImpl;

  factory BoardCardAssignment.fromJson(Map<String, dynamic> jsonSerialization) {
    return BoardCardAssignment(
      id: jsonSerialization['id'] as int?,
      card: jsonSerialization['card'] as int,
      user: jsonSerialization['user'] as int,
      assignedBy: jsonSerialization['assignedBy'] as int,
      assignedAt:
          _i1.DateTimeJsonExtension.fromJson(jsonSerialization['assignedAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int card;

  int user;

  int assignedBy;

  DateTime assignedAt;

  /// Returns a shallow copy of this [BoardCardAssignment]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  BoardCardAssignment copyWith({
    int? id,
    int? card,
    int? user,
    int? assignedBy,
    DateTime? assignedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'card': card,
      'user': user,
      'assignedBy': assignedBy,
      'assignedAt': assignedAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _BoardCardAssignmentImpl extends BoardCardAssignment {
  _BoardCardAssignmentImpl({
    int? id,
    required int card,
    required int user,
    required int assignedBy,
    required DateTime assignedAt,
  }) : super._(
          id: id,
          card: card,
          user: user,
          assignedBy: assignedBy,
          assignedAt: assignedAt,
        );

  /// Returns a shallow copy of this [BoardCardAssignment]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  BoardCardAssignment copyWith({
    Object? id = _Undefined,
    int? card,
    int? user,
    int? assignedBy,
    DateTime? assignedAt,
  }) {
    return BoardCardAssignment(
      id: id is int? ? id : this.id,
      card: card ?? this.card,
      user: user ?? this.user,
      assignedBy: assignedBy ?? this.assignedBy,
      assignedAt: assignedAt ?? this.assignedAt,
    );
  }
}
