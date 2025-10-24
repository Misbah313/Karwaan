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

abstract class OverAllAnalytics
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  OverAllAnalytics._({
    this.id,
    required this.userId,
    required this.totalBoard,
    required this.totalCard,
    required this.completedCards,
    required this.completionPercentage,
    this.cardsPerWorkspace,
    this.cardsPerStatus,
    required this.lastUpdate,
  });

  factory OverAllAnalytics({
    int? id,
    required int userId,
    required int totalBoard,
    required int totalCard,
    required int completedCards,
    required double completionPercentage,
    Map<String, int>? cardsPerWorkspace,
    Map<String, int>? cardsPerStatus,
    required DateTime lastUpdate,
  }) = _OverAllAnalyticsImpl;

  factory OverAllAnalytics.fromJson(Map<String, dynamic> jsonSerialization) {
    return OverAllAnalytics(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as int,
      totalBoard: jsonSerialization['totalBoard'] as int,
      totalCard: jsonSerialization['totalCard'] as int,
      completedCards: jsonSerialization['completedCards'] as int,
      completionPercentage:
          (jsonSerialization['completionPercentage'] as num).toDouble(),
      cardsPerWorkspace: (jsonSerialization['cardsPerWorkspace'] as Map?)
          ?.map((k, v) => MapEntry(
                k as String,
                v as int,
              )),
      cardsPerStatus:
          (jsonSerialization['cardsPerStatus'] as Map?)?.map((k, v) => MapEntry(
                k as String,
                v as int,
              )),
      lastUpdate:
          _i1.DateTimeJsonExtension.fromJson(jsonSerialization['lastUpdate']),
    );
  }

  static final t = OverAllAnalyticsTable();

  static const db = OverAllAnalyticsRepository._();

  @override
  int? id;

  int userId;

  int totalBoard;

  int totalCard;

  int completedCards;

  double completionPercentage;

  Map<String, int>? cardsPerWorkspace;

  Map<String, int>? cardsPerStatus;

  DateTime lastUpdate;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [OverAllAnalytics]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  OverAllAnalytics copyWith({
    int? id,
    int? userId,
    int? totalBoard,
    int? totalCard,
    int? completedCards,
    double? completionPercentage,
    Map<String, int>? cardsPerWorkspace,
    Map<String, int>? cardsPerStatus,
    DateTime? lastUpdate,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'userId': userId,
      'totalBoard': totalBoard,
      'totalCard': totalCard,
      'completedCards': completedCards,
      'completionPercentage': completionPercentage,
      if (cardsPerWorkspace != null)
        'cardsPerWorkspace': cardsPerWorkspace?.toJson(),
      if (cardsPerStatus != null) 'cardsPerStatus': cardsPerStatus?.toJson(),
      'lastUpdate': lastUpdate.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'userId': userId,
      'totalBoard': totalBoard,
      'totalCard': totalCard,
      'completedCards': completedCards,
      'completionPercentage': completionPercentage,
      if (cardsPerWorkspace != null)
        'cardsPerWorkspace': cardsPerWorkspace?.toJson(),
      if (cardsPerStatus != null) 'cardsPerStatus': cardsPerStatus?.toJson(),
      'lastUpdate': lastUpdate.toJson(),
    };
  }

  static OverAllAnalyticsInclude include() {
    return OverAllAnalyticsInclude._();
  }

  static OverAllAnalyticsIncludeList includeList({
    _i1.WhereExpressionBuilder<OverAllAnalyticsTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<OverAllAnalyticsTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<OverAllAnalyticsTable>? orderByList,
    OverAllAnalyticsInclude? include,
  }) {
    return OverAllAnalyticsIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(OverAllAnalytics.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(OverAllAnalytics.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _OverAllAnalyticsImpl extends OverAllAnalytics {
  _OverAllAnalyticsImpl({
    int? id,
    required int userId,
    required int totalBoard,
    required int totalCard,
    required int completedCards,
    required double completionPercentage,
    Map<String, int>? cardsPerWorkspace,
    Map<String, int>? cardsPerStatus,
    required DateTime lastUpdate,
  }) : super._(
          id: id,
          userId: userId,
          totalBoard: totalBoard,
          totalCard: totalCard,
          completedCards: completedCards,
          completionPercentage: completionPercentage,
          cardsPerWorkspace: cardsPerWorkspace,
          cardsPerStatus: cardsPerStatus,
          lastUpdate: lastUpdate,
        );

  /// Returns a shallow copy of this [OverAllAnalytics]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  OverAllAnalytics copyWith({
    Object? id = _Undefined,
    int? userId,
    int? totalBoard,
    int? totalCard,
    int? completedCards,
    double? completionPercentage,
    Object? cardsPerWorkspace = _Undefined,
    Object? cardsPerStatus = _Undefined,
    DateTime? lastUpdate,
  }) {
    return OverAllAnalytics(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      totalBoard: totalBoard ?? this.totalBoard,
      totalCard: totalCard ?? this.totalCard,
      completedCards: completedCards ?? this.completedCards,
      completionPercentage: completionPercentage ?? this.completionPercentage,
      cardsPerWorkspace: cardsPerWorkspace is Map<String, int>?
          ? cardsPerWorkspace
          : this.cardsPerWorkspace?.map((
                key0,
                value0,
              ) =>
                  MapEntry(
                    key0,
                    value0,
                  )),
      cardsPerStatus: cardsPerStatus is Map<String, int>?
          ? cardsPerStatus
          : this.cardsPerStatus?.map((
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

class OverAllAnalyticsTable extends _i1.Table<int?> {
  OverAllAnalyticsTable({super.tableRelation})
      : super(tableName: 'over_all_analytics') {
    userId = _i1.ColumnInt(
      'userId',
      this,
    );
    totalBoard = _i1.ColumnInt(
      'totalBoard',
      this,
    );
    totalCard = _i1.ColumnInt(
      'totalCard',
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
    cardsPerWorkspace = _i1.ColumnSerializable(
      'cardsPerWorkspace',
      this,
    );
    cardsPerStatus = _i1.ColumnSerializable(
      'cardsPerStatus',
      this,
    );
    lastUpdate = _i1.ColumnDateTime(
      'lastUpdate',
      this,
    );
  }

  late final _i1.ColumnInt userId;

  late final _i1.ColumnInt totalBoard;

  late final _i1.ColumnInt totalCard;

  late final _i1.ColumnInt completedCards;

  late final _i1.ColumnDouble completionPercentage;

  late final _i1.ColumnSerializable cardsPerWorkspace;

  late final _i1.ColumnSerializable cardsPerStatus;

  late final _i1.ColumnDateTime lastUpdate;

  @override
  List<_i1.Column> get columns => [
        id,
        userId,
        totalBoard,
        totalCard,
        completedCards,
        completionPercentage,
        cardsPerWorkspace,
        cardsPerStatus,
        lastUpdate,
      ];
}

class OverAllAnalyticsInclude extends _i1.IncludeObject {
  OverAllAnalyticsInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => OverAllAnalytics.t;
}

class OverAllAnalyticsIncludeList extends _i1.IncludeList {
  OverAllAnalyticsIncludeList._({
    _i1.WhereExpressionBuilder<OverAllAnalyticsTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(OverAllAnalytics.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => OverAllAnalytics.t;
}

class OverAllAnalyticsRepository {
  const OverAllAnalyticsRepository._();

  /// Returns a list of [OverAllAnalytics]s matching the given query parameters.
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
  Future<List<OverAllAnalytics>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<OverAllAnalyticsTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<OverAllAnalyticsTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<OverAllAnalyticsTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<OverAllAnalytics>(
      where: where?.call(OverAllAnalytics.t),
      orderBy: orderBy?.call(OverAllAnalytics.t),
      orderByList: orderByList?.call(OverAllAnalytics.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [OverAllAnalytics] matching the given query parameters.
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
  Future<OverAllAnalytics?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<OverAllAnalyticsTable>? where,
    int? offset,
    _i1.OrderByBuilder<OverAllAnalyticsTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<OverAllAnalyticsTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<OverAllAnalytics>(
      where: where?.call(OverAllAnalytics.t),
      orderBy: orderBy?.call(OverAllAnalytics.t),
      orderByList: orderByList?.call(OverAllAnalytics.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [OverAllAnalytics] by its [id] or null if no such row exists.
  Future<OverAllAnalytics?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<OverAllAnalytics>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [OverAllAnalytics]s in the list and returns the inserted rows.
  ///
  /// The returned [OverAllAnalytics]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<OverAllAnalytics>> insert(
    _i1.Session session,
    List<OverAllAnalytics> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<OverAllAnalytics>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [OverAllAnalytics] and returns the inserted row.
  ///
  /// The returned [OverAllAnalytics] will have its `id` field set.
  Future<OverAllAnalytics> insertRow(
    _i1.Session session,
    OverAllAnalytics row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<OverAllAnalytics>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [OverAllAnalytics]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<OverAllAnalytics>> update(
    _i1.Session session,
    List<OverAllAnalytics> rows, {
    _i1.ColumnSelections<OverAllAnalyticsTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<OverAllAnalytics>(
      rows,
      columns: columns?.call(OverAllAnalytics.t),
      transaction: transaction,
    );
  }

  /// Updates a single [OverAllAnalytics]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<OverAllAnalytics> updateRow(
    _i1.Session session,
    OverAllAnalytics row, {
    _i1.ColumnSelections<OverAllAnalyticsTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<OverAllAnalytics>(
      row,
      columns: columns?.call(OverAllAnalytics.t),
      transaction: transaction,
    );
  }

  /// Deletes all [OverAllAnalytics]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<OverAllAnalytics>> delete(
    _i1.Session session,
    List<OverAllAnalytics> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<OverAllAnalytics>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [OverAllAnalytics].
  Future<OverAllAnalytics> deleteRow(
    _i1.Session session,
    OverAllAnalytics row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<OverAllAnalytics>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<OverAllAnalytics>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<OverAllAnalyticsTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<OverAllAnalytics>(
      where: where(OverAllAnalytics.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<OverAllAnalyticsTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<OverAllAnalytics>(
      where: where?.call(OverAllAnalytics.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
