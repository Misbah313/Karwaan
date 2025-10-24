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

abstract class Workspace implements _i1.SerializableModel {
  Workspace._({
    this.id,
    required this.name,
    this.description,
    required this.createdAt,
    required this.ownerId,
    this.backgroundColor,
    this.isPrivate,
  });

  factory Workspace({
    int? id,
    required String name,
    String? description,
    required DateTime createdAt,
    required int ownerId,
    String? backgroundColor,
    bool? isPrivate,
  }) = _WorkspaceImpl;

  factory Workspace.fromJson(Map<String, dynamic> jsonSerialization) {
    return Workspace(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      description: jsonSerialization['description'] as String?,
      createdAt:
          _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      ownerId: jsonSerialization['ownerId'] as int,
      backgroundColor: jsonSerialization['backgroundColor'] as String?,
      isPrivate: jsonSerialization['isPrivate'] as bool?,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String name;

  String? description;

  DateTime createdAt;

  int ownerId;

  String? backgroundColor;

  bool? isPrivate;

  /// Returns a shallow copy of this [Workspace]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Workspace copyWith({
    int? id,
    String? name,
    String? description,
    DateTime? createdAt,
    int? ownerId,
    String? backgroundColor,
    bool? isPrivate,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      if (description != null) 'description': description,
      'createdAt': createdAt.toJson(),
      'ownerId': ownerId,
      if (backgroundColor != null) 'backgroundColor': backgroundColor,
      if (isPrivate != null) 'isPrivate': isPrivate,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _WorkspaceImpl extends Workspace {
  _WorkspaceImpl({
    int? id,
    required String name,
    String? description,
    required DateTime createdAt,
    required int ownerId,
    String? backgroundColor,
    bool? isPrivate,
  }) : super._(
          id: id,
          name: name,
          description: description,
          createdAt: createdAt,
          ownerId: ownerId,
          backgroundColor: backgroundColor,
          isPrivate: isPrivate,
        );

  /// Returns a shallow copy of this [Workspace]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Workspace copyWith({
    Object? id = _Undefined,
    String? name,
    Object? description = _Undefined,
    DateTime? createdAt,
    int? ownerId,
    Object? backgroundColor = _Undefined,
    Object? isPrivate = _Undefined,
  }) {
    return Workspace(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      description: description is String? ? description : this.description,
      createdAt: createdAt ?? this.createdAt,
      ownerId: ownerId ?? this.ownerId,
      backgroundColor:
          backgroundColor is String? ? backgroundColor : this.backgroundColor,
      isPrivate: isPrivate is bool? ? isPrivate : this.isPrivate,
    );
  }
}
