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

abstract class Label implements _i1.SerializableModel {
  Label._({
    this.id,
    required this.name,
    required this.color,
    required this.board,
    required this.createdBy,
  });

  factory Label({
    int? id,
    required String name,
    required String color,
    required int board,
    required int createdBy,
  }) = _LabelImpl;

  factory Label.fromJson(Map<String, dynamic> jsonSerialization) {
    return Label(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      color: jsonSerialization['color'] as String,
      board: jsonSerialization['board'] as int,
      createdBy: jsonSerialization['createdBy'] as int,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String name;

  String color;

  int board;

  int createdBy;

  /// Returns a shallow copy of this [Label]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Label copyWith({
    int? id,
    String? name,
    String? color,
    int? board,
    int? createdBy,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'color': color,
      'board': board,
      'createdBy': createdBy,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _LabelImpl extends Label {
  _LabelImpl({
    int? id,
    required String name,
    required String color,
    required int board,
    required int createdBy,
  }) : super._(
          id: id,
          name: name,
          color: color,
          board: board,
          createdBy: createdBy,
        );

  /// Returns a shallow copy of this [Label]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Label copyWith({
    Object? id = _Undefined,
    String? name,
    String? color,
    int? board,
    int? createdBy,
  }) {
    return Label(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      color: color ?? this.color,
      board: board ?? this.board,
      createdBy: createdBy ?? this.createdBy,
    );
  }
}
