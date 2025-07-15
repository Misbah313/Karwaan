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

abstract class CheckList
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  CheckList._({
    this.id,
    required this.title,
    required this.card,
    required this.createdAt,
    required this.createdBy,
  });

  factory CheckList({
    int? id,
    required String title,
    required int card,
    required DateTime createdAt,
    required int createdBy,
  }) = _CheckListImpl;

  factory CheckList.fromJson(Map<String, dynamic> jsonSerialization) {
    return CheckList(
      id: jsonSerialization['id'] as int?,
      title: jsonSerialization['title'] as String,
      card: jsonSerialization['card'] as int,
      createdAt:
          _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      createdBy: jsonSerialization['createdBy'] as int,
    );
  }

  static final t = CheckListTable();

  static const db = CheckListRepository._();

  @override
  int? id;

  String title;

  int card;

  DateTime createdAt;

  int createdBy;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [CheckList]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  CheckList copyWith({
    int? id,
    String? title,
    int? card,
    DateTime? createdAt,
    int? createdBy,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'title': title,
      'card': card,
      'createdAt': createdAt.toJson(),
      'createdBy': createdBy,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'title': title,
      'card': card,
      'createdAt': createdAt.toJson(),
      'createdBy': createdBy,
    };
  }

  static CheckListInclude include() {
    return CheckListInclude._();
  }

  static CheckListIncludeList includeList({
    _i1.WhereExpressionBuilder<CheckListTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CheckListTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CheckListTable>? orderByList,
    CheckListInclude? include,
  }) {
    return CheckListIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CheckList.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(CheckList.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CheckListImpl extends CheckList {
  _CheckListImpl({
    int? id,
    required String title,
    required int card,
    required DateTime createdAt,
    required int createdBy,
  }) : super._(
          id: id,
          title: title,
          card: card,
          createdAt: createdAt,
          createdBy: createdBy,
        );

  /// Returns a shallow copy of this [CheckList]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  CheckList copyWith({
    Object? id = _Undefined,
    String? title,
    int? card,
    DateTime? createdAt,
    int? createdBy,
  }) {
    return CheckList(
      id: id is int? ? id : this.id,
      title: title ?? this.title,
      card: card ?? this.card,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
    );
  }
}

class CheckListTable extends _i1.Table<int?> {
  CheckListTable({super.tableRelation}) : super(tableName: 'check_list') {
    title = _i1.ColumnString(
      'title',
      this,
    );
    card = _i1.ColumnInt(
      'card',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
    createdBy = _i1.ColumnInt(
      'createdBy',
      this,
    );
  }

  late final _i1.ColumnString title;

  late final _i1.ColumnInt card;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnInt createdBy;

  @override
  List<_i1.Column> get columns => [
        id,
        title,
        card,
        createdAt,
        createdBy,
      ];
}

class CheckListInclude extends _i1.IncludeObject {
  CheckListInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => CheckList.t;
}

class CheckListIncludeList extends _i1.IncludeList {
  CheckListIncludeList._({
    _i1.WhereExpressionBuilder<CheckListTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(CheckList.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => CheckList.t;
}

class CheckListRepository {
  const CheckListRepository._();

  /// Returns a list of [CheckList]s matching the given query parameters.
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
  Future<List<CheckList>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<CheckListTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CheckListTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CheckListTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<CheckList>(
      where: where?.call(CheckList.t),
      orderBy: orderBy?.call(CheckList.t),
      orderByList: orderByList?.call(CheckList.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [CheckList] matching the given query parameters.
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
  Future<CheckList?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<CheckListTable>? where,
    int? offset,
    _i1.OrderByBuilder<CheckListTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CheckListTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<CheckList>(
      where: where?.call(CheckList.t),
      orderBy: orderBy?.call(CheckList.t),
      orderByList: orderByList?.call(CheckList.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [CheckList] by its [id] or null if no such row exists.
  Future<CheckList?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<CheckList>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [CheckList]s in the list and returns the inserted rows.
  ///
  /// The returned [CheckList]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<CheckList>> insert(
    _i1.Session session,
    List<CheckList> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<CheckList>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [CheckList] and returns the inserted row.
  ///
  /// The returned [CheckList] will have its `id` field set.
  Future<CheckList> insertRow(
    _i1.Session session,
    CheckList row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<CheckList>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [CheckList]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<CheckList>> update(
    _i1.Session session,
    List<CheckList> rows, {
    _i1.ColumnSelections<CheckListTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<CheckList>(
      rows,
      columns: columns?.call(CheckList.t),
      transaction: transaction,
    );
  }

  /// Updates a single [CheckList]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<CheckList> updateRow(
    _i1.Session session,
    CheckList row, {
    _i1.ColumnSelections<CheckListTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<CheckList>(
      row,
      columns: columns?.call(CheckList.t),
      transaction: transaction,
    );
  }

  /// Deletes all [CheckList]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<CheckList>> delete(
    _i1.Session session,
    List<CheckList> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<CheckList>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [CheckList].
  Future<CheckList> deleteRow(
    _i1.Session session,
    CheckList row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<CheckList>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<CheckList>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<CheckListTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<CheckList>(
      where: where(CheckList.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<CheckListTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<CheckList>(
      where: where?.call(CheckList.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
