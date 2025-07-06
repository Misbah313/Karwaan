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

abstract class ListBoard implements _i1.SerializableModel {
  ListBoard._({
    this.id,
    required this.name,
    required this.board,
    required this.createdBy,
    required this.createdAt,
    required this.isArcheived,
    this.position,
  });

  factory ListBoard({
    int? id,
    required String name,
    required int board,
    required int createdBy,
    required DateTime createdAt,
    required bool isArcheived,
    int? position,
  }) = _ListBoardImpl;

  factory ListBoard.fromJson(Map<String, dynamic> jsonSerialization) {
    return ListBoard(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      board: jsonSerialization['board'] as int,
      createdBy: jsonSerialization['createdBy'] as int,
      createdAt:
          _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      isArcheived: jsonSerialization['isArcheived'] as bool,
      position: jsonSerialization['position'] as int?,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String name;

  int board;

  int createdBy;

  DateTime createdAt;

  bool isArcheived;

  int? position;

  /// Returns a shallow copy of this [ListBoard]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ListBoard copyWith({
    int? id,
    String? name,
    int? board,
    int? createdBy,
    DateTime? createdAt,
    bool? isArcheived,
    int? position,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'board': board,
      'createdBy': createdBy,
      'createdAt': createdAt.toJson(),
      'isArcheived': isArcheived,
      if (position != null) 'position': position,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ListBoardImpl extends ListBoard {
  _ListBoardImpl({
    int? id,
    required String name,
    required int board,
    required int createdBy,
    required DateTime createdAt,
    required bool isArcheived,
    int? position,
  }) : super._(
          id: id,
          name: name,
          board: board,
          createdBy: createdBy,
          createdAt: createdAt,
          isArcheived: isArcheived,
          position: position,
        );

  /// Returns a shallow copy of this [ListBoard]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ListBoard copyWith({
    Object? id = _Undefined,
    String? name,
    int? board,
    int? createdBy,
    DateTime? createdAt,
    bool? isArcheived,
    Object? position = _Undefined,
  }) {
    return ListBoard(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      board: board ?? this.board,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      isArcheived: isArcheived ?? this.isArcheived,
      position: position is int? ? position : this.position,
    );
  }
}
