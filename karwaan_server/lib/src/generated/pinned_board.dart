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

abstract class PinnedBoard
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
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

  static final t = PinnedBoardTable();

  static const db = PinnedBoardRepository._();

  @override
  int? id;

  int userId;

  int boardId;

  DateTime pinnedAt;

  @override
  _i1.Table<int?> get table => t;

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
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'userId': userId,
      'boardId': boardId,
      'pinnedAt': pinnedAt.toJson(),
    };
  }

  static PinnedBoardInclude include() {
    return PinnedBoardInclude._();
  }

  static PinnedBoardIncludeList includeList({
    _i1.WhereExpressionBuilder<PinnedBoardTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<PinnedBoardTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<PinnedBoardTable>? orderByList,
    PinnedBoardInclude? include,
  }) {
    return PinnedBoardIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(PinnedBoard.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(PinnedBoard.t),
      include: include,
    );
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

class PinnedBoardTable extends _i1.Table<int?> {
  PinnedBoardTable({super.tableRelation}) : super(tableName: 'pinned_boards') {
    userId = _i1.ColumnInt(
      'userId',
      this,
    );
    boardId = _i1.ColumnInt(
      'boardId',
      this,
    );
    pinnedAt = _i1.ColumnDateTime(
      'pinnedAt',
      this,
    );
  }

  late final _i1.ColumnInt userId;

  late final _i1.ColumnInt boardId;

  late final _i1.ColumnDateTime pinnedAt;

  @override
  List<_i1.Column> get columns => [
        id,
        userId,
        boardId,
        pinnedAt,
      ];
}

class PinnedBoardInclude extends _i1.IncludeObject {
  PinnedBoardInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => PinnedBoard.t;
}

class PinnedBoardIncludeList extends _i1.IncludeList {
  PinnedBoardIncludeList._({
    _i1.WhereExpressionBuilder<PinnedBoardTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(PinnedBoard.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => PinnedBoard.t;
}

class PinnedBoardRepository {
  const PinnedBoardRepository._();

  /// Returns a list of [PinnedBoard]s matching the given query parameters.
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
  Future<List<PinnedBoard>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<PinnedBoardTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<PinnedBoardTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<PinnedBoardTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<PinnedBoard>(
      where: where?.call(PinnedBoard.t),
      orderBy: orderBy?.call(PinnedBoard.t),
      orderByList: orderByList?.call(PinnedBoard.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [PinnedBoard] matching the given query parameters.
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
  Future<PinnedBoard?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<PinnedBoardTable>? where,
    int? offset,
    _i1.OrderByBuilder<PinnedBoardTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<PinnedBoardTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<PinnedBoard>(
      where: where?.call(PinnedBoard.t),
      orderBy: orderBy?.call(PinnedBoard.t),
      orderByList: orderByList?.call(PinnedBoard.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [PinnedBoard] by its [id] or null if no such row exists.
  Future<PinnedBoard?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<PinnedBoard>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [PinnedBoard]s in the list and returns the inserted rows.
  ///
  /// The returned [PinnedBoard]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<PinnedBoard>> insert(
    _i1.Session session,
    List<PinnedBoard> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<PinnedBoard>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [PinnedBoard] and returns the inserted row.
  ///
  /// The returned [PinnedBoard] will have its `id` field set.
  Future<PinnedBoard> insertRow(
    _i1.Session session,
    PinnedBoard row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<PinnedBoard>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [PinnedBoard]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<PinnedBoard>> update(
    _i1.Session session,
    List<PinnedBoard> rows, {
    _i1.ColumnSelections<PinnedBoardTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<PinnedBoard>(
      rows,
      columns: columns?.call(PinnedBoard.t),
      transaction: transaction,
    );
  }

  /// Updates a single [PinnedBoard]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<PinnedBoard> updateRow(
    _i1.Session session,
    PinnedBoard row, {
    _i1.ColumnSelections<PinnedBoardTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<PinnedBoard>(
      row,
      columns: columns?.call(PinnedBoard.t),
      transaction: transaction,
    );
  }

  /// Deletes all [PinnedBoard]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<PinnedBoard>> delete(
    _i1.Session session,
    List<PinnedBoard> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<PinnedBoard>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [PinnedBoard].
  Future<PinnedBoard> deleteRow(
    _i1.Session session,
    PinnedBoard row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<PinnedBoard>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<PinnedBoard>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<PinnedBoardTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<PinnedBoard>(
      where: where(PinnedBoard.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<PinnedBoardTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<PinnedBoard>(
      where: where?.call(PinnedBoard.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
