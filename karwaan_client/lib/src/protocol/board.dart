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

abstract class Board implements _i1.SerializableModel {
  Board._({
    this.id,
    required this.name,
    this.description,
    required this.workspaceId,
    required this.createdBy,
    required this.createdAt,
  });

  factory Board({
    int? id,
    required String name,
    String? description,
    required int workspaceId,
    required int createdBy,
    required DateTime createdAt,
  }) = _BoardImpl;

  factory Board.fromJson(Map<String, dynamic> jsonSerialization) {
    return Board(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      description: jsonSerialization['description'] as String?,
      workspaceId: jsonSerialization['workspaceId'] as int,
      createdBy: jsonSerialization['createdBy'] as int,
      createdAt:
          _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String name;

  String? description;

  int workspaceId;

  int createdBy;

  DateTime createdAt;

  /// Returns a shallow copy of this [Board]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Board copyWith({
    int? id,
    String? name,
    String? description,
    int? workspaceId,
    int? createdBy,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      if (description != null) 'description': description,
      'workspaceId': workspaceId,
      'createdBy': createdBy,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _BoardImpl extends Board {
  _BoardImpl({
    int? id,
    required String name,
    String? description,
    required int workspaceId,
    required int createdBy,
    required DateTime createdAt,
  }) : super._(
          id: id,
          name: name,
          description: description,
          workspaceId: workspaceId,
          createdBy: createdBy,
          createdAt: createdAt,
        );

  /// Returns a shallow copy of this [Board]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Board copyWith({
    Object? id = _Undefined,
    String? name,
    Object? description = _Undefined,
    int? workspaceId,
    int? createdBy,
    DateTime? createdAt,
  }) {
    return Board(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      description: description is String? ? description : this.description,
      workspaceId: workspaceId ?? this.workspaceId,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
