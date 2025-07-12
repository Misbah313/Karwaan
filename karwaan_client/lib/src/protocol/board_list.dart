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

abstract class BoardList implements _i1.SerializableModel {
  BoardList._({
    this.id,
    required this.board,
    required this.title,
    required this.createdAt,
  });

  factory BoardList({
    int? id,
    required int board,
    required String title,
    required DateTime createdAt,
  }) = _BoardListImpl;

  factory BoardList.fromJson(Map<String, dynamic> jsonSerialization) {
    return BoardList(
      id: jsonSerialization['id'] as int?,
      board: jsonSerialization['board'] as int,
      title: jsonSerialization['title'] as String,
      createdAt:
          _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int board;

  String title;

  DateTime createdAt;

  /// Returns a shallow copy of this [BoardList]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  BoardList copyWith({
    int? id,
    int? board,
    String? title,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'board': board,
      'title': title,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _BoardListImpl extends BoardList {
  _BoardListImpl({
    int? id,
    required int board,
    required String title,
    required DateTime createdAt,
  }) : super._(
          id: id,
          board: board,
          title: title,
          createdAt: createdAt,
        );

  /// Returns a shallow copy of this [BoardList]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  BoardList copyWith({
    Object? id = _Undefined,
    int? board,
    String? title,
    DateTime? createdAt,
  }) {
    return BoardList(
      id: id is int? ? id : this.id,
      board: board ?? this.board,
      title: title ?? this.title,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
