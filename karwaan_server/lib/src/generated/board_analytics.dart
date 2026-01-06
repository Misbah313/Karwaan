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

abstract class BoardAnalytics
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  BoardAnalytics._({
    this.id,
    required this.boardId,
    required this.totalCards,
    required this.completedCards,
    required this.completionPercentage,
    this.cardPerList,
    required this.lastUpdate,
  });

  factory BoardAnalytics({
    int? id,
    required int boardId,
    required int totalCards,
    required int completedCards,
    required double completionPercentage,
    Map<String, int>? cardPerList,
    required DateTime lastUpdate,
  }) = _BoardAnalyticsImpl;

  factory BoardAnalytics.fromJson(Map<String, dynamic> jsonSerialization) {
    return BoardAnalytics(
      id: jsonSerialization['id'] as int?,
      boardId: jsonSerialization['boardId'] as int,
      totalCards: jsonSerialization['totalCards'] as int,
      completedCards: jsonSerialization['completedCards'] as int,
      completionPercentage:
          (jsonSerialization['completionPercentage'] as num).toDouble(),
      cardPerList:
          (jsonSerialization['cardPerList'] as Map?)?.map((k, v) => MapEntry(
                k as String,
                v as int,
              )),
      lastUpdate:
          _i1.DateTimeJsonExtension.fromJson(jsonSerialization['lastUpdate']),
    );
  }

  static final t = BoardAnalyticsTable();

  static const db = BoardAnalyticsRepository._();

  @override
  int? id;

  int boardId;

  int totalCards;

  int completedCards;

  double completionPercentage;

  Map<String, int>? cardPerList;

  DateTime lastUpdate;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [BoardAnalytics]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  BoardAnalytics copyWith({
    int? id,
    int? boardId,
    int? totalCards,
    int? completedCards,
    double? completionPercentage,
    Map<String, int>? cardPerList,
    DateTime? lastUpdate,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'boardId': boardId,
      'totalCards': totalCards,
      'completedCards': completedCards,
      'completionPercentage': completionPercentage,
      if (cardPerList != null) 'cardPerList': cardPerList?.toJson(),
      'lastUpdate': lastUpdate.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'boardId': boardId,
      'totalCards': totalCards,
      'completedCards': completedCards,
      'completionPercentage': completionPercentage,
      if (cardPerList != null) 'cardPerList': cardPerList?.toJson(),
      'lastUpdate': lastUpdate.toJson(),
    };
  }

  static BoardAnalyticsInclude include() {
    return BoardAnalyticsInclude._();
  }

  static BoardAnalyticsIncludeList includeList({
    _i1.WhereExpressionBuilder<BoardAnalyticsTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<BoardAnalyticsTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<BoardAnalyticsTable>? orderByList,
    BoardAnalyticsInclude? include,
  }) {
    return BoardAnalyticsIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(BoardAnalytics.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(BoardAnalytics.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _BoardAnalyticsImpl extends BoardAnalytics {
  _BoardAnalyticsImpl({
    int? id,
    required int boardId,
    required int totalCards,
    required int completedCards,
    required double completionPercentage,
    Map<String, int>? cardPerList,
    required DateTime lastUpdate,
  }) : super._(
          id: id,
          boardId: boardId,
          totalCards: totalCards,
          completedCards: completedCards,
          completionPercentage: completionPercentage,
          cardPerList: cardPerList,
          lastUpdate: lastUpdate,
        );

  /// Returns a shallow copy of this [BoardAnalytics]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  BoardAnalytics copyWith({
    Object? id = _Undefined,
    int? boardId,
    int? totalCards,
    int? completedCards,
    double? completionPercentage,
    Object? cardPerList = _Undefined,
    DateTime? lastUpdate,
  }) {
    return BoardAnalytics(
      id: id is int? ? id : this.id,
      boardId: boardId ?? this.boardId,
      totalCards: totalCards ?? this.totalCards,
      completedCards: completedCards ?? this.completedCards,
      completionPercentage: completionPercentage ?? this.completionPercentage,
      cardPerList: cardPerList is Map<String, int>?
          ? cardPerList
          : this.cardPerList?.map((
                key0,
                value0,
              ) =>
                  MapEntry(
                    key0,
                    value0,
                  )),
      lastUpdate: lastUpdate ?? this.lastUpdate,
    );
  }
}

class BoardAnalyticsTable extends _i1.Table<int?> {
  BoardAnalyticsTable({super.tableRelation})
      : super(tableName: 'board_analytics') {
    boardId = _i1.ColumnInt(
      'boardId',
      this,
    );
    totalCards = _i1.ColumnInt(
      'totalCards',
      this,
    );
    completedCards = _i1.ColumnInt(
      'completedCards',
      this,
    );
    completionPercentage = _i1.ColumnDouble(
      'completionPercentage',
      this,
    );
    cardPerList = _i1.ColumnSerializable(
      'cardPerList',
      this,
    );
    lastUpdate = _i1.ColumnDateTime(
      'lastUpdate',
      this,
    );
  }

  late final _i1.ColumnInt boardId;

  late final _i1.ColumnInt totalCards;

  late final _i1.ColumnInt completedCards;

  late final _i1.ColumnDouble completionPercentage;

  late final _i1.ColumnSerializable cardPerList;

  late final _i1.ColumnDateTime lastUpdate;

  @override
  List<_i1.Column> get columns => [
        id,
        boardId,
        totalCards,
        completedCards,
        completionPercentage,
        cardPerList,
        lastUpdate,
      ];
}

class BoardAnalyticsInclude extends _i1.IncludeObject {
  BoardAnalyticsInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => BoardAnalytics.t;
}

class BoardAnalyticsIncludeList extends _i1.IncludeList {
  BoardAnalyticsIncludeList._({
    _i1.WhereExpressionBuilder<BoardAnalyticsTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(BoardAnalytics.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => BoardAnalytics.t;
}

class BoardAnalyticsRepository {
  const BoardAnalyticsRepository._();

  /// Returns a list of [BoardAnalytics]s matching the given query parameters.
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
  Future<List<BoardAnalytics>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<BoardAnalyticsTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<BoardAnalyticsTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<BoardAnalyticsTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<BoardAnalytics>(
      where: where?.call(BoardAnalytics.t),
      orderBy: orderBy?.call(BoardAnalytics.t),
      orderByList: orderByList?.call(BoardAnalytics.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [BoardAnalytics] matching the given query parameters.
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
  Future<BoardAnalytics?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<BoardAnalyticsTable>? where,
    int? offset,
    _i1.OrderByBuilder<BoardAnalyticsTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<BoardAnalyticsTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<BoardAnalytics>(
      where: where?.call(BoardAnalytics.t),
      orderBy: orderBy?.call(BoardAnalytics.t),
      orderByList: orderByList?.call(BoardAnalytics.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [BoardAnalytics] by its [id] or null if no such row exists.
  Future<BoardAnalytics?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<BoardAnalytics>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [BoardAnalytics]s in the list and returns the inserted rows.
  ///
  /// The returned [BoardAnalytics]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<BoardAnalytics>> insert(
    _i1.Session session,
    List<BoardAnalytics> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<BoardAnalytics>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [BoardAnalytics] and returns the inserted row.
  ///
  /// The returned [BoardAnalytics] will have its `id` field set.
  Future<BoardAnalytics> insertRow(
    _i1.Session session,
    BoardAnalytics row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<BoardAnalytics>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [BoardAnalytics]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<BoardAnalytics>> update(
    _i1.Session session,
    List<BoardAnalytics> rows, {
    _i1.ColumnSelections<BoardAnalyticsTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<BoardAnalytics>(
      rows,
      columns: columns?.call(BoardAnalytics.t),
      transaction: transaction,
    );
  }

  /// Updates a single [BoardAnalytics]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<BoardAnalytics> updateRow(
    _i1.Session session,
    BoardAnalytics row, {
    _i1.ColumnSelections<BoardAnalyticsTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<BoardAnalytics>(
      row,
      columns: columns?.call(BoardAnalytics.t),
      transaction: transaction,
    );
  }

  /// Deletes all [BoardAnalytics]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<BoardAnalytics>> delete(
    _i1.Session session,
    List<BoardAnalytics> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<BoardAnalytics>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [BoardAnalytics].
  Future<BoardAnalytics> deleteRow(
    _i1.Session session,
    BoardAnalytics row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<BoardAnalytics>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<BoardAnalytics>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<BoardAnalyticsTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<BoardAnalytics>(
      where: where(BoardAnalytics.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<BoardAnalyticsTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<BoardAnalytics>(
      where: where?.call(BoardAnalytics.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
