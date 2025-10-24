/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

abstract class UserRecentBoards
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
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

  static final t = UserRecentBoardsTable();

  static const db = UserRecentBoardsRepository._();

  @override
  int? id;

  int userId;

  int boardId;

  DateTime lastAccess;

  @override
  _i1.Table<int?> get table => t;

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
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'userId': userId,
      'boardId': boardId,
      'lastAccess': lastAccess.toJson(),
    };
  }

  static UserRecentBoardsInclude include() {
    return UserRecentBoardsInclude._();
  }

  static UserRecentBoardsIncludeList includeList({
    _i1.WhereExpressionBuilder<UserRecentBoardsTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UserRecentBoardsTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UserRecentBoardsTable>? orderByList,
    UserRecentBoardsInclude? include,
  }) {
    return UserRecentBoardsIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(UserRecentBoards.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(UserRecentBoards.t),
      include: include,
    );
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

class UserRecentBoardsTable extends _i1.Table<int?> {
  UserRecentBoardsTable({super.tableRelation})
      : super(tableName: 'user_recent_boards') {
    userId = _i1.ColumnInt(
      'userId',
      this,
    );
    boardId = _i1.ColumnInt(
      'boardId',
      this,
    );
    lastAccess = _i1.ColumnDateTime(
      'lastAccess',
      this,
    );
  }

  late final _i1.ColumnInt userId;

  late final _i1.ColumnInt boardId;

  late final _i1.ColumnDateTime lastAccess;

  @override
  List<_i1.Column> get columns => [
        id,
        userId,
        boardId,
        lastAccess,
      ];
}

class UserRecentBoardsInclude extends _i1.IncludeObject {
  UserRecentBoardsInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => UserRecentBoards.t;
}

class UserRecentBoardsIncludeList extends _i1.IncludeList {
  UserRecentBoardsIncludeList._({
    _i1.WhereExpressionBuilder<UserRecentBoardsTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(UserRecentBoards.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => UserRecentBoards.t;
}

class UserRecentBoardsRepository {
  const UserRecentBoardsRepository._();

  /// Returns a list of [UserRecentBoards]s matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order of the items use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// The maximum number of items can be set by [limit]. If no limit is set,
  /// all items matching the query will be returned.
  ///
  /// [offset] defines how many items to skip, after which [limit] (or all)
  /// items are read from the database.
  ///
  /// ```dart
  /// var persons = await Persons.db.find(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// );
  /// ```
  Future<List<UserRecentBoards>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<UserRecentBoardsTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UserRecentBoardsTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UserRecentBoardsTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<UserRecentBoards>(
      where: where?.call(UserRecentBoards.t),
      orderBy: orderBy?.call(UserRecentBoards.t),
      orderByList: orderByList?.call(UserRecentBoards.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [UserRecentBoards] matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// [offset] defines how many items to skip, after which the next one will be picked.
  ///
  /// ```dart
  /// var youngestPerson = await Persons.db.findFirstRow(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.age,
  /// );
  /// ```
  Future<UserRecentBoards?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<UserRecentBoardsTable>? where,
    int? offset,
    _i1.OrderByBuilder<UserRecentBoardsTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UserRecentBoardsTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<UserRecentBoards>(
      where: where?.call(UserRecentBoards.t),
      orderBy: orderBy?.call(UserRecentBoards.t),
      orderByList: orderByList?.call(UserRecentBoards.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [UserRecentBoards] by its [id] or null if no such row exists.
  Future<UserRecentBoards?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<UserRecentBoards>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [UserRecentBoards]s in the list and returns the inserted rows.
  ///
  /// The returned [UserRecentBoards]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<UserRecentBoards>> insert(
    _i1.Session session,
    List<UserRecentBoards> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<UserRecentBoards>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [UserRecentBoards] and returns the inserted row.
  ///
  /// The returned [UserRecentBoards] will have its `id` field set.
  Future<UserRecentBoards> insertRow(
    _i1.Session session,
    UserRecentBoards row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<UserRecentBoards>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [UserRecentBoards]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<UserRecentBoards>> update(
    _i1.Session session,
    List<UserRecentBoards> rows, {
    _i1.ColumnSelections<UserRecentBoardsTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<UserRecentBoards>(
      rows,
      columns: columns?.call(UserRecentBoards.t),
      transaction: transaction,
    );
  }

  /// Updates a single [UserRecentBoards]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<UserRecentBoards> updateRow(
    _i1.Session session,
    UserRecentBoards row, {
    _i1.ColumnSelections<UserRecentBoardsTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<UserRecentBoards>(
      row,
      columns: columns?.call(UserRecentBoards.t),
      transaction: transaction,
    );
  }

  /// Deletes all [UserRecentBoards]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<UserRecentBoards>> delete(
    _i1.Session session,
    List<UserRecentBoards> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<UserRecentBoards>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [UserRecentBoards].
  Future<UserRecentBoards> deleteRow(
    _i1.Session session,
    UserRecentBoards row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<UserRecentBoards>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<UserRecentBoards>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<UserRecentBoardsTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<UserRecentBoards>(
      where: where(UserRecentBoards.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<UserRecentBoardsTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<UserRecentBoards>(
      where: where?.call(UserRecentBoards.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
