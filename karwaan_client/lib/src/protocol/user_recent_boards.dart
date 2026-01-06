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

abstract class UserRecentBoards implements _i1.SerializableModel {
  UserRecentBoards._({
    this.id,
    required this.userId,
    required this.boardId,
    required this.lastAccess,
  });

  factory UserRecentBoards({
    int? id,
    required int userId,
    required int boardId,
    required DateTime lastAccess,
  }) = _UserRecentBoardsImpl;

  factory UserRecentBoards.fromJson(Map<String, dynamic> jsonSerialization) {
    return UserRecentBoards(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as int,
      boardId: jsonSerialization['boardId'] as int,
      lastAccess:
          _i1.DateTimeJsonExtension.fromJson(jsonSerialization['lastAccess']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int userId;

  int boardId;

  DateTime lastAccess;

  /// Returns a shallow copy of this [UserRecentBoards]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  UserRecentBoards copyWith({
    int? id,
    int? userId,
    int? boardId,
    DateTime? lastAccess,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'userId': userId,
      'boardId': boardId,
      'lastAccess': lastAccess.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UserRecentBoardsImpl extends UserRecentBoards {
  _UserRecentBoardsImpl({
    int? id,
    required int userId,
    required int boardId,
    required DateTime lastAccess,
  }) : super._(
          id: id,
          userId: userId,
          boardId: boardId,
          lastAccess: lastAccess,
        );

  /// Returns a shallow copy of this [UserRecentBoards]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  UserRecentBoards copyWith({
    Object? id = _Undefined,
    int? userId,
    int? boardId,
    DateTime? lastAccess,
  }) {
    return UserRecentBoards(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      boardId: boardId ?? this.boardId,
      lastAccess: lastAccess ?? this.lastAccess,
    );
  }
}
