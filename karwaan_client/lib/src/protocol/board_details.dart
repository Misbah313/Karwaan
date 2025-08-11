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

abstract class BoardDetails implements _i1.SerializableModel {
  BoardDetails._({
    this.id,
    required this.workspaceId,
    required this.name,
    this.description,
    required this.createdAt,
    required this.members,
  });

  factory BoardDetails({
    int? id,
    required int workspaceId,
    required String name,
    String? description,
    required DateTime createdAt,
    required List<String> members,
  }) = _BoardDetailsImpl;

  factory BoardDetails.fromJson(Map<String, dynamic> jsonSerialization) {
    return BoardDetails(
      id: jsonSerialization['id'] as int?,
      workspaceId: jsonSerialization['workspaceId'] as int,
      name: jsonSerialization['name'] as String,
      description: jsonSerialization['description'] as String?,
      createdAt:
          _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      members: (jsonSerialization['members'] as List)
          .map((e) => e as String)
          .toList(),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int workspaceId;

  String name;

  String? description;

  DateTime createdAt;

  List<String> members;

  /// Returns a shallow copy of this [BoardDetails]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  BoardDetails copyWith({
    int? id,
    int? workspaceId,
    String? name,
    String? description,
    DateTime? createdAt,
    List<String>? members,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'workspaceId': workspaceId,
      'name': name,
      if (description != null) 'description': description,
      'createdAt': createdAt.toJson(),
      'members': members.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _BoardDetailsImpl extends BoardDetails {
  _BoardDetailsImpl({
    int? id,
    required int workspaceId,
    required String name,
    String? description,
    required DateTime createdAt,
    required List<String> members,
  }) : super._(
          id: id,
          workspaceId: workspaceId,
          name: name,
          description: description,
          createdAt: createdAt,
          members: members,
        );

  /// Returns a shallow copy of this [BoardDetails]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  BoardDetails copyWith({
    Object? id = _Undefined,
    int? workspaceId,
    String? name,
    Object? description = _Undefined,
    DateTime? createdAt,
    List<String>? members,
  }) {
    return BoardDetails(
      id: id is int? ? id : this.id,
      workspaceId: workspaceId ?? this.workspaceId,
      name: name ?? this.name,
      description: description is String? ? description : this.description,
      createdAt: createdAt ?? this.createdAt,
      members: members ?? this.members.map((e0) => e0).toList(),
    );
  }
}
