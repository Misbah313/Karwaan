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

abstract class Board implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  Board._({
    this.id,
    required this.name,
    this.description,
    required this.workspaceId,
    required this.createdBy,
    required this.createdAt,
  });

  factory Board({
    int? id,
    required String name,
    String? description,
    required int workspaceId,
    required int createdBy,
    required DateTime createdAt,
  }) = _BoardImpl;

  factory Board.fromJson(Map<String, dynamic> jsonSerialization) {
    return Board(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      description: jsonSerialization['description'] as String?,
      workspaceId: jsonSerialization['workspaceId'] as int,
      createdBy: jsonSerialization['createdBy'] as int,
      createdAt:
          _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  static final t = BoardTable();

  static const db = BoardRepository._();

  @override
  int? id;

  String name;

  String? description;

  int workspaceId;

  int createdBy;

  DateTime createdAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [Board]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Board copyWith({
    int? id,
    String? name,
    String? description,
    int? workspaceId,
    int? createdBy,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      if (description != null) 'description': description,
      'workspaceId': workspaceId,
      'createdBy': createdBy,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'name': name,
      if (description != null) 'description': description,
      'workspaceId': workspaceId,
      'createdBy': createdBy,
      'createdAt': createdAt.toJson(),
    };
  }

  static BoardInclude include() {
    return BoardInclude._();
  }

  static BoardIncludeList includeList({
    _i1.WhereExpressionBuilder<BoardTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<BoardTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<BoardTable>? orderByList,
    BoardInclude? include,
  }) {
    return BoardIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Board.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(Board.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _BoardImpl extends Board {
  _BoardImpl({
    int? id,
    required String name,
    String? description,
    required int workspaceId,
    required int createdBy,
    required DateTime createdAt,
  }) : super._(
          id: id,
          name: name,
          description: description,
          workspaceId: workspaceId,
          createdBy: createdBy,
          createdAt: createdAt,
        );

  /// Returns a shallow copy of this [Board]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Board copyWith({
    Object? id = _Undefined,
    String? name,
    Object? description = _Undefined,
    int? workspaceId,
    int? createdBy,
    DateTime? createdAt,
  }) {
    return Board(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      description: description is String? ? description : this.description,
      workspaceId: workspaceId ?? this.workspaceId,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class BoardTable extends _i1.Table<int?> {
  BoardTable({super.tableRelation}) : super(tableName: 'board') {
    name = _i1.ColumnString(
      'name',
      this,
    );
    description = _i1.ColumnString(
      'description',
      this,
    );
    workspaceId = _i1.ColumnInt(
      'workspaceId',
      this,
    );
    createdBy = _i1.ColumnInt(
      'createdBy',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
  }

  late final _i1.ColumnString name;

  late final _i1.ColumnString description;

  late final _i1.ColumnInt workspaceId;

  late final _i1.ColumnInt createdBy;

  late final _i1.ColumnDateTime createdAt;

  @override
  List<_i1.Column> get columns => [
        id,
        name,
        description,
        workspaceId,
        createdBy,
        createdAt,
      ];
}

class BoardInclude extends _i1.IncludeObject {
  BoardInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => Board.t;
}

class BoardIncludeList extends _i1.IncludeList {
  BoardIncludeList._({
    _i1.WhereExpressionBuilder<BoardTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Board.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => Board.t;
}

class BoardRepository {
  const BoardRepository._();

  /// Returns a list of [Board]s matching the given query parameters.
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
  Future<List<Board>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<BoardTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<BoardTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<BoardTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<Board>(
      where: where?.call(Board.t),
      orderBy: orderBy?.call(Board.t),
      orderByList: orderByList?.call(Board.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [Board] matching the given query parameters.
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
  Future<Board?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<BoardTable>? where,
    int? offset,
    _i1.OrderByBuilder<BoardTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<BoardTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<Board>(
      where: where?.call(Board.t),
      orderBy: orderBy?.call(Board.t),
      orderByList: orderByList?.call(Board.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [Board] by its [id] or null if no such row exists.
  Future<Board?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<Board>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [Board]s in the list and returns the inserted rows.
  ///
  /// The returned [Board]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<Board>> insert(
    _i1.Session session,
    List<Board> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<Board>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [Board] and returns the inserted row.
  ///
  /// The returned [Board] will have its `id` field set.
  Future<Board> insertRow(
    _i1.Session session,
    Board row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<Board>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [Board]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<Board>> update(
    _i1.Session session,
    List<Board> rows, {
    _i1.ColumnSelections<BoardTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<Board>(
      rows,
      columns: columns?.call(Board.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Board]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Board> updateRow(
    _i1.Session session,
    Board row, {
    _i1.ColumnSelections<BoardTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<Board>(
      row,
      columns: columns?.call(Board.t),
      transaction: transaction,
    );
  }

  /// Deletes all [Board]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<Board>> delete(
    _i1.Session session,
    List<Board> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Board>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [Board].
  Future<Board> deleteRow(
    _i1.Session session,
    Board row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Board>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<Board>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<BoardTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<Board>(
      where: where(Board.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<BoardTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Board>(
      where: where?.call(Board.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
