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

abstract class PinnedBoard implements _i1.SerializableModel {
  PinnedBoard._({
    this.id,
    required this.userId,
    required this.boardId,
    required this.pinnedAt,
  });

  factory PinnedBoard({
    int? id,
    required int userId,
    required int boardId,
    required DateTime pinnedAt,
  }) = _PinnedBoardImpl;

  factory PinnedBoard.fromJson(Map<String, dynamic> jsonSerialization) {
    return PinnedBoard(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as int,
      boardId: jsonSerialization['boardId'] as int,
      pinnedAt:
          _i1.DateTimeJsonExtension.fromJson(jsonSerialization['pinnedAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int userId;

  int boardId;

  DateTime pinnedAt;

  /// Returns a shallow copy of this [PinnedBoard]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  PinnedBoard copyWith({
    int? id,
    int? userId,
    int? boardId,
    DateTime? pinnedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'userId': userId,
      'boardId': boardId,
      'pinnedAt': pinnedAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PinnedBoardImpl extends PinnedBoard {
  _PinnedBoardImpl({
    int? id,
    required int userId,
    required int boardId,
    required DateTime pinnedAt,
  }) : super._(
          id: id,
          userId: userId,
          boardId: boardId,
          pinnedAt: pinnedAt,
        );

  /// Returns a shallow copy of this [PinnedBoard]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  PinnedBoard copyWith({
    Object? id = _Undefined,
    int? userId,
    int? boardId,
    DateTime? pinnedAt,
  }) {
    return PinnedBoard(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      boardId: boardId ?? this.boardId,
      pinnedAt: pinnedAt ?? this.pinnedAt,
    );
  }
}
