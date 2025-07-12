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

abstract class BoardList
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
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

  static final t = BoardListTable();

  static const db = BoardListRepository._();

  @override
  int? id;

  int board;

  String title;

  DateTime createdAt;

  @override
  _i1.Table<int?> get table => t;

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
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'board': board,
      'title': title,
      'createdAt': createdAt.toJson(),
    };
  }

  static BoardListInclude include() {
    return BoardListInclude._();
  }

  static BoardListIncludeList includeList({
    _i1.WhereExpressionBuilder<BoardListTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<BoardListTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<BoardListTable>? orderByList,
    BoardListInclude? include,
  }) {
    return BoardListIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(BoardList.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(BoardList.t),
      include: include,
    );
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

class BoardListTable extends _i1.Table<int?> {
  BoardListTable({super.tableRelation}) : super(tableName: 'board_list') {
    board = _i1.ColumnInt(
      'board',
      this,
    );
    title = _i1.ColumnString(
      'title',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
  }

  late final _i1.ColumnInt board;

  late final _i1.ColumnString title;

  late final _i1.ColumnDateTime createdAt;

  @override
  List<_i1.Column> get columns => [
        id,
        board,
        title,
        createdAt,
      ];
}

class BoardListInclude extends _i1.IncludeObject {
  BoardListInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => BoardList.t;
}

class BoardListIncludeList extends _i1.IncludeList {
  BoardListIncludeList._({
    _i1.WhereExpressionBuilder<BoardListTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(BoardList.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => BoardList.t;
}

class BoardListRepository {
  const BoardListRepository._();

  /// Returns a list of [BoardList]s matching the given query parameters.
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
  Future<List<BoardList>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<BoardListTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<BoardListTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<BoardListTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<BoardList>(
      where: where?.call(BoardList.t),
      orderBy: orderBy?.call(BoardList.t),
      orderByList: orderByList?.call(BoardList.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [BoardList] matching the given query parameters.
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
  Future<BoardList?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<BoardListTable>? where,
    int? offset,
    _i1.OrderByBuilder<BoardListTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<BoardListTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<BoardList>(
      where: where?.call(BoardList.t),
      orderBy: orderBy?.call(BoardList.t),
      orderByList: orderByList?.call(BoardList.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [BoardList] by its [id] or null if no such row exists.
  Future<BoardList?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<BoardList>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [BoardList]s in the list and returns the inserted rows.
  ///
  /// The returned [BoardList]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<BoardList>> insert(
    _i1.Session session,
    List<BoardList> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<BoardList>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [BoardList] and returns the inserted row.
  ///
  /// The returned [BoardList] will have its `id` field set.
  Future<BoardList> insertRow(
    _i1.Session session,
    BoardList row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<BoardList>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [BoardList]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<BoardList>> update(
    _i1.Session session,
    List<BoardList> rows, {
    _i1.ColumnSelections<BoardListTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<BoardList>(
      rows,
      columns: columns?.call(BoardList.t),
      transaction: transaction,
    );
  }

  /// Updates a single [BoardList]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<BoardList> updateRow(
    _i1.Session session,
    BoardList row, {
    _i1.ColumnSelections<BoardListTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<BoardList>(
      row,
      columns: columns?.call(BoardList.t),
      transaction: transaction,
    );
  }

  /// Deletes all [BoardList]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<BoardList>> delete(
    _i1.Session session,
    List<BoardList> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<BoardList>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [BoardList].
  Future<BoardList> deleteRow(
    _i1.Session session,
    BoardList row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<BoardList>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<BoardList>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<BoardListTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<BoardList>(
      where: where(BoardList.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<BoardListTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<BoardList>(
      where: where?.call(BoardList.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
