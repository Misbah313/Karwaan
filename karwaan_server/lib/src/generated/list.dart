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

abstract class ListBoard
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
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

  static final t = ListBoardTable();

  static const db = ListBoardRepository._();

  @override
  int? id;

  String name;

  int board;

  int createdBy;

  DateTime createdAt;

  bool isArcheived;

  int? position;

  @override
  _i1.Table<int?> get table => t;

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
  Map<String, dynamic> toJsonForProtocol() {
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

  static ListBoardInclude include() {
    return ListBoardInclude._();
  }

  static ListBoardIncludeList includeList({
    _i1.WhereExpressionBuilder<ListBoardTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ListBoardTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ListBoardTable>? orderByList,
    ListBoardInclude? include,
  }) {
    return ListBoardIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ListBoard.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(ListBoard.t),
      include: include,
    );
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

class ListBoardTable extends _i1.Table<int?> {
  ListBoardTable({super.tableRelation}) : super(tableName: 'listboard') {
    name = _i1.ColumnString(
      'name',
      this,
    );
    board = _i1.ColumnInt(
      'board',
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
    isArcheived = _i1.ColumnBool(
      'isArcheived',
      this,
    );
    position = _i1.ColumnInt(
      'position',
      this,
    );
  }

  late final _i1.ColumnString name;

  late final _i1.ColumnInt board;

  late final _i1.ColumnInt createdBy;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnBool isArcheived;

  late final _i1.ColumnInt position;

  @override
  List<_i1.Column> get columns => [
        id,
        name,
        board,
        createdBy,
        createdAt,
        isArcheived,
        position,
      ];
}

class ListBoardInclude extends _i1.IncludeObject {
  ListBoardInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => ListBoard.t;
}

class ListBoardIncludeList extends _i1.IncludeList {
  ListBoardIncludeList._({
    _i1.WhereExpressionBuilder<ListBoardTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ListBoard.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => ListBoard.t;
}

class ListBoardRepository {
  const ListBoardRepository._();

  /// Returns a list of [ListBoard]s matching the given query parameters.
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
  Future<List<ListBoard>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ListBoardTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ListBoardTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ListBoardTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<ListBoard>(
      where: where?.call(ListBoard.t),
      orderBy: orderBy?.call(ListBoard.t),
      orderByList: orderByList?.call(ListBoard.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [ListBoard] matching the given query parameters.
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
  Future<ListBoard?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ListBoardTable>? where,
    int? offset,
    _i1.OrderByBuilder<ListBoardTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ListBoardTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<ListBoard>(
      where: where?.call(ListBoard.t),
      orderBy: orderBy?.call(ListBoard.t),
      orderByList: orderByList?.call(ListBoard.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [ListBoard] by its [id] or null if no such row exists.
  Future<ListBoard?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<ListBoard>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [ListBoard]s in the list and returns the inserted rows.
  ///
  /// The returned [ListBoard]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<ListBoard>> insert(
    _i1.Session session,
    List<ListBoard> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<ListBoard>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [ListBoard] and returns the inserted row.
  ///
  /// The returned [ListBoard] will have its `id` field set.
  Future<ListBoard> insertRow(
    _i1.Session session,
    ListBoard row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<ListBoard>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [ListBoard]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<ListBoard>> update(
    _i1.Session session,
    List<ListBoard> rows, {
    _i1.ColumnSelections<ListBoardTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<ListBoard>(
      rows,
      columns: columns?.call(ListBoard.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ListBoard]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ListBoard> updateRow(
    _i1.Session session,
    ListBoard row, {
    _i1.ColumnSelections<ListBoardTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<ListBoard>(
      row,
      columns: columns?.call(ListBoard.t),
      transaction: transaction,
    );
  }

  /// Deletes all [ListBoard]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<ListBoard>> delete(
    _i1.Session session,
    List<ListBoard> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<ListBoard>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [ListBoard].
  Future<ListBoard> deleteRow(
    _i1.Session session,
    ListBoard row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ListBoard>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<ListBoard>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<ListBoardTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<ListBoard>(
      where: where(ListBoard.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<ListBoardTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<ListBoard>(
      where: where?.call(ListBoard.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
