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

abstract class BoardCard
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  BoardCard._({
    this.id,
    required this.title,
    this.description,
    required this.createdBy,
    required this.list,
    required this.createdAt,
    this.position,
    required this.isCompleted,
  });

  factory BoardCard({
    int? id,
    required String title,
    String? description,
    required int createdBy,
    required int list,
    required DateTime createdAt,
    int? position,
    required bool isCompleted,
  }) = _BoardCardImpl;

  factory BoardCard.fromJson(Map<String, dynamic> jsonSerialization) {
    return BoardCard(
      id: jsonSerialization['id'] as int?,
      title: jsonSerialization['title'] as String,
      description: jsonSerialization['description'] as String?,
      createdBy: jsonSerialization['createdBy'] as int,
      list: jsonSerialization['list'] as int,
      createdAt:
          _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      position: jsonSerialization['position'] as int?,
      isCompleted: jsonSerialization['isCompleted'] as bool,
    );
  }

  static final t = BoardCardTable();

  static const db = BoardCardRepository._();

  @override
  int? id;

  String title;

  String? description;

  int createdBy;

  int list;

  DateTime createdAt;

  int? position;

  bool isCompleted;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [BoardCard]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  BoardCard copyWith({
    int? id,
    String? title,
    String? description,
    int? createdBy,
    int? list,
    DateTime? createdAt,
    int? position,
    bool? isCompleted,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'title': title,
      if (description != null) 'description': description,
      'createdBy': createdBy,
      'list': list,
      'createdAt': createdAt.toJson(),
      if (position != null) 'position': position,
      'isCompleted': isCompleted,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'title': title,
      if (description != null) 'description': description,
      'createdBy': createdBy,
      'list': list,
      'createdAt': createdAt.toJson(),
      if (position != null) 'position': position,
      'isCompleted': isCompleted,
    };
  }

  static BoardCardInclude include() {
    return BoardCardInclude._();
  }

  static BoardCardIncludeList includeList({
    _i1.WhereExpressionBuilder<BoardCardTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<BoardCardTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<BoardCardTable>? orderByList,
    BoardCardInclude? include,
  }) {
    return BoardCardIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(BoardCard.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(BoardCard.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _BoardCardImpl extends BoardCard {
  _BoardCardImpl({
    int? id,
    required String title,
    String? description,
    required int createdBy,
    required int list,
    required DateTime createdAt,
    int? position,
    required bool isCompleted,
  }) : super._(
          id: id,
          title: title,
          description: description,
          createdBy: createdBy,
          list: list,
          createdAt: createdAt,
          position: position,
          isCompleted: isCompleted,
        );

  /// Returns a shallow copy of this [BoardCard]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  BoardCard copyWith({
    Object? id = _Undefined,
    String? title,
    Object? description = _Undefined,
    int? createdBy,
    int? list,
    DateTime? createdAt,
    Object? position = _Undefined,
    bool? isCompleted,
  }) {
    return BoardCard(
      id: id is int? ? id : this.id,
      title: title ?? this.title,
      description: description is String? ? description : this.description,
      createdBy: createdBy ?? this.createdBy,
      list: list ?? this.list,
      createdAt: createdAt ?? this.createdAt,
      position: position is int? ? position : this.position,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

class BoardCardTable extends _i1.Table<int?> {
  BoardCardTable({super.tableRelation}) : super(tableName: 'board_card') {
    title = _i1.ColumnString(
      'title',
      this,
    );
    description = _i1.ColumnString(
      'description',
      this,
    );
    createdBy = _i1.ColumnInt(
      'createdBy',
      this,
    );
    list = _i1.ColumnInt(
      'list',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
    position = _i1.ColumnInt(
      'position',
      this,
    );
    isCompleted = _i1.ColumnBool(
      'isCompleted',
      this,
    );
  }

  late final _i1.ColumnString title;

  late final _i1.ColumnString description;

  late final _i1.ColumnInt createdBy;

  late final _i1.ColumnInt list;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnInt position;

  late final _i1.ColumnBool isCompleted;

  @override
  List<_i1.Column> get columns => [
        id,
        title,
        description,
        createdBy,
        list,
        createdAt,
        position,
        isCompleted,
      ];
}

class BoardCardInclude extends _i1.IncludeObject {
  BoardCardInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => BoardCard.t;
}

class BoardCardIncludeList extends _i1.IncludeList {
  BoardCardIncludeList._({
    _i1.WhereExpressionBuilder<BoardCardTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(BoardCard.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => BoardCard.t;
}

class BoardCardRepository {
  const BoardCardRepository._();

  /// Returns a list of [BoardCard]s matching the given query parameters.
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
  Future<List<BoardCard>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<BoardCardTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<BoardCardTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<BoardCardTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<BoardCard>(
      where: where?.call(BoardCard.t),
      orderBy: orderBy?.call(BoardCard.t),
      orderByList: orderByList?.call(BoardCard.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [BoardCard] matching the given query parameters.
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
  Future<BoardCard?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<BoardCardTable>? where,
    int? offset,
    _i1.OrderByBuilder<BoardCardTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<BoardCardTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<BoardCard>(
      where: where?.call(BoardCard.t),
      orderBy: orderBy?.call(BoardCard.t),
      orderByList: orderByList?.call(BoardCard.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [BoardCard] by its [id] or null if no such row exists.
  Future<BoardCard?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<BoardCard>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [BoardCard]s in the list and returns the inserted rows.
  ///
  /// The returned [BoardCard]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<BoardCard>> insert(
    _i1.Session session,
    List<BoardCard> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<BoardCard>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [BoardCard] and returns the inserted row.
  ///
  /// The returned [BoardCard] will have its `id` field set.
  Future<BoardCard> insertRow(
    _i1.Session session,
    BoardCard row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<BoardCard>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [BoardCard]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<BoardCard>> update(
    _i1.Session session,
    List<BoardCard> rows, {
    _i1.ColumnSelections<BoardCardTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<BoardCard>(
      rows,
      columns: columns?.call(BoardCard.t),
      transaction: transaction,
    );
  }

  /// Updates a single [BoardCard]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<BoardCard> updateRow(
    _i1.Session session,
    BoardCard row, {
    _i1.ColumnSelections<BoardCardTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<BoardCard>(
      row,
      columns: columns?.call(BoardCard.t),
      transaction: transaction,
    );
  }

  /// Deletes all [BoardCard]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<BoardCard>> delete(
    _i1.Session session,
    List<BoardCard> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<BoardCard>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [BoardCard].
  Future<BoardCard> deleteRow(
    _i1.Session session,
    BoardCard row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<BoardCard>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<BoardCard>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<BoardCardTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<BoardCard>(
      where: where(BoardCard.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<BoardCardTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<BoardCard>(
      where: where?.call(BoardCard.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
