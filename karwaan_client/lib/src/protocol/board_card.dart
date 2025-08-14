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

abstract class BoardCard implements _i1.SerializableModel {
  BoardCard._({
    this.id,
    required this.title,
    this.description,
    required this.createdBy,
    required this.list,
    required this.createdAt,
    this.position,
    required this.isCompleted,
  });

  factory BoardCard({
    int? id,
    required String title,
    String? description,
    required int createdBy,
    required int list,
    required DateTime createdAt,
    int? position,
    required bool isCompleted,
  }) = _BoardCardImpl;

  factory BoardCard.fromJson(Map<String, dynamic> jsonSerialization) {
    return BoardCard(
      id: jsonSerialization['id'] as int?,
      title: jsonSerialization['title'] as String,
      description: jsonSerialization['description'] as String?,
      createdBy: jsonSerialization['createdBy'] as int,
      list: jsonSerialization['list'] as int,
      createdAt:
          _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      position: jsonSerialization['position'] as int?,
      isCompleted: jsonSerialization['isCompleted'] as bool,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String title;

  String? description;

  int createdBy;

  int list;

  DateTime createdAt;

  int? position;

  bool isCompleted;

  /// Returns a shallow copy of this [BoardCard]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  BoardCard copyWith({
    int? id,
    String? title,
    String? description,
    int? createdBy,
    int? list,
    DateTime? createdAt,
    int? position,
    bool? isCompleted,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'title': title,
      if (description != null) 'description': description,
      'createdBy': createdBy,
      'list': list,
      'createdAt': createdAt.toJson(),
      if (position != null) 'position': position,
      'isCompleted': isCompleted,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _BoardCardImpl extends BoardCard {
  _BoardCardImpl({
    int? id,
    required String title,
    String? description,
    required int createdBy,
    required int list,
    required DateTime createdAt,
    int? position,
    required bool isCompleted,
  }) : super._(
          id: id,
          title: title,
          description: description,
          createdBy: createdBy,
          list: list,
          createdAt: createdAt,
          position: position,
          isCompleted: isCompleted,
        );

  /// Returns a shallow copy of this [BoardCard]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  BoardCard copyWith({
    Object? id = _Undefined,
    String? title,
    Object? description = _Undefined,
    int? createdBy,
    int? list,
    DateTime? createdAt,
    Object? position = _Undefined,
    bool? isCompleted,
  }) {
    return BoardCard(
      id: id is int? ? id : this.id,
      title: title ?? this.title,
      description: description is String? ? description : this.description,
      createdBy: createdBy ?? this.createdBy,
      list: list ?? this.list,
      createdAt: createdAt ?? this.createdAt,
      position: position is int? ? position : this.position,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
