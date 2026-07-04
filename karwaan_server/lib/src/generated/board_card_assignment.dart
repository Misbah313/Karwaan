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

abstract class BoardCardAssignment
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  BoardCardAssignment._({
    this.id,
    required this.card,
    required this.user,
    required this.assignedBy,
    required this.assignedAt,
  });

  factory BoardCardAssignment({
    int? id,
    required int card,
    required int user,
    required int assignedBy,
    required DateTime assignedAt,
  }) = _BoardCardAssignmentImpl;

  factory BoardCardAssignment.fromJson(Map<String, dynamic> jsonSerialization) {
    return BoardCardAssignment(
      id: jsonSerialization['id'] as int?,
      card: jsonSerialization['card'] as int,
      user: jsonSerialization['user'] as int,
      assignedBy: jsonSerialization['assignedBy'] as int,
      assignedAt:
          _i1.DateTimeJsonExtension.fromJson(jsonSerialization['assignedAt']),
    );
  }

  static final t = BoardCardAssignmentTable();

  static const db = BoardCardAssignmentRepository._();

  @override
  int? id;

  int card;

  int user;

  int assignedBy;

  DateTime assignedAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [BoardCardAssignment]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  BoardCardAssignment copyWith({
    int? id,
    int? card,
    int? user,
    int? assignedBy,
    DateTime? assignedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'card': card,
      'user': user,
      'assignedBy': assignedBy,
      'assignedAt': assignedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'card': card,
      'user': user,
      'assignedBy': assignedBy,
      'assignedAt': assignedAt.toJson(),
    };
  }

  static BoardCardAssignmentInclude include() {
    return BoardCardAssignmentInclude._();
  }

  static BoardCardAssignmentIncludeList includeList({
    _i1.WhereExpressionBuilder<BoardCardAssignmentTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<BoardCardAssignmentTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<BoardCardAssignmentTable>? orderByList,
    BoardCardAssignmentInclude? include,
  }) {
    return BoardCardAssignmentIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(BoardCardAssignment.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(BoardCardAssignment.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _BoardCardAssignmentImpl extends BoardCardAssignment {
  _BoardCardAssignmentImpl({
    int? id,
    required int card,
    required int user,
    required int assignedBy,
    required DateTime assignedAt,
  }) : super._(
          id: id,
          card: card,
          user: user,
          assignedBy: assignedBy,
          assignedAt: assignedAt,
        );

  /// Returns a shallow copy of this [BoardCardAssignment]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  BoardCardAssignment copyWith({
    Object? id = _Undefined,
    int? card,
    int? user,
    int? assignedBy,
    DateTime? assignedAt,
  }) {
    return BoardCardAssignment(
      id: id is int? ? id : this.id,
      card: card ?? this.card,
      user: user ?? this.user,
      assignedBy: assignedBy ?? this.assignedBy,
      assignedAt: assignedAt ?? this.assignedAt,
    );
  }
}

class BoardCardAssignmentTable extends _i1.Table<int?> {
  BoardCardAssignmentTable({super.tableRelation})
      : super(tableName: 'board_card_assignment') {
    card = _i1.ColumnInt(
      'card',
      this,
    );
    user = _i1.ColumnInt(
      'user',
      this,
    );
    assignedBy = _i1.ColumnInt(
      'assignedBy',
      this,
    );
    assignedAt = _i1.ColumnDateTime(
      'assignedAt',
      this,
    );
  }

  late final _i1.ColumnInt card;

  late final _i1.ColumnInt user;

  late final _i1.ColumnInt assignedBy;

  late final _i1.ColumnDateTime assignedAt;

  @override
  List<_i1.Column> get columns => [
        id,
        card,
        user,
        assignedBy,
        assignedAt,
      ];
}

class BoardCardAssignmentInclude extends _i1.IncludeObject {
  BoardCardAssignmentInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => BoardCardAssignment.t;
}

class BoardCardAssignmentIncludeList extends _i1.IncludeList {
  BoardCardAssignmentIncludeList._({
    _i1.WhereExpressionBuilder<BoardCardAssignmentTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(BoardCardAssignment.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => BoardCardAssignment.t;
}

class BoardCardAssignmentRepository {
  const BoardCardAssignmentRepository._();

  /// Returns a list of [BoardCardAssignment]s matching the given query parameters.
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
  Future<List<BoardCardAssignment>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<BoardCardAssignmentTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<BoardCardAssignmentTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<BoardCardAssignmentTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<BoardCardAssignment>(
      where: where?.call(BoardCardAssignment.t),
      orderBy: orderBy?.call(BoardCardAssignment.t),
      orderByList: orderByList?.call(BoardCardAssignment.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [BoardCardAssignment] matching the given query parameters.
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
  Future<BoardCardAssignment?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<BoardCardAssignmentTable>? where,
    int? offset,
    _i1.OrderByBuilder<BoardCardAssignmentTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<BoardCardAssignmentTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<BoardCardAssignment>(
      where: where?.call(BoardCardAssignment.t),
      orderBy: orderBy?.call(BoardCardAssignment.t),
      orderByList: orderByList?.call(BoardCardAssignment.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [BoardCardAssignment] by its [id] or null if no such row exists.
  Future<BoardCardAssignment?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<BoardCardAssignment>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [BoardCardAssignment]s in the list and returns the inserted rows.
  ///
  /// The returned [BoardCardAssignment]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<BoardCardAssignment>> insert(
    _i1.Session session,
    List<BoardCardAssignment> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<BoardCardAssignment>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [BoardCardAssignment] and returns the inserted row.
  ///
  /// The returned [BoardCardAssignment] will have its `id` field set.
  Future<BoardCardAssignment> insertRow(
    _i1.Session session,
    BoardCardAssignment row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<BoardCardAssignment>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [BoardCardAssignment]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<BoardCardAssignment>> update(
    _i1.Session session,
    List<BoardCardAssignment> rows, {
    _i1.ColumnSelections<BoardCardAssignmentTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<BoardCardAssignment>(
      rows,
      columns: columns?.call(BoardCardAssignment.t),
      transaction: transaction,
    );
  }

  /// Updates a single [BoardCardAssignment]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<BoardCardAssignment> updateRow(
    _i1.Session session,
    BoardCardAssignment row, {
    _i1.ColumnSelections<BoardCardAssignmentTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<BoardCardAssignment>(
      row,
      columns: columns?.call(BoardCardAssignment.t),
      transaction: transaction,
    );
  }

  /// Deletes all [BoardCardAssignment]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<BoardCardAssignment>> delete(
    _i1.Session session,
    List<BoardCardAssignment> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<BoardCardAssignment>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [BoardCardAssignment].
  Future<BoardCardAssignment> deleteRow(
    _i1.Session session,
    BoardCardAssignment row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<BoardCardAssignment>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<BoardCardAssignment>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<BoardCardAssignmentTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<BoardCardAssignment>(
      where: where(BoardCardAssignment.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<BoardCardAssignmentTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<BoardCardAssignment>(
      where: where?.call(BoardCardAssignment.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
