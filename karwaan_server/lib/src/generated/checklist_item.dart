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

abstract class CheckListItem
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  CheckListItem._({
    this.id,
    required this.checklist,
    required this.content,
    required this.isDone,
  });

  factory CheckListItem({
    int? id,
    required int checklist,
    required String content,
    required bool isDone,
  }) = _CheckListItemImpl;

  factory CheckListItem.fromJson(Map<String, dynamic> jsonSerialization) {
    return CheckListItem(
      id: jsonSerialization['id'] as int?,
      checklist: jsonSerialization['checklist'] as int,
      content: jsonSerialization['content'] as String,
      isDone: jsonSerialization['isDone'] as bool,
    );
  }

  static final t = CheckListItemTable();

  static const db = CheckListItemRepository._();

  @override
  int? id;

  int checklist;

  String content;

  bool isDone;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [CheckListItem]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  CheckListItem copyWith({
    int? id,
    int? checklist,
    String? content,
    bool? isDone,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'checklist': checklist,
      'content': content,
      'isDone': isDone,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'checklist': checklist,
      'content': content,
      'isDone': isDone,
    };
  }

  static CheckListItemInclude include() {
    return CheckListItemInclude._();
  }

  static CheckListItemIncludeList includeList({
    _i1.WhereExpressionBuilder<CheckListItemTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CheckListItemTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CheckListItemTable>? orderByList,
    CheckListItemInclude? include,
  }) {
    return CheckListItemIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CheckListItem.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(CheckListItem.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CheckListItemImpl extends CheckListItem {
  _CheckListItemImpl({
    int? id,
    required int checklist,
    required String content,
    required bool isDone,
  }) : super._(
          id: id,
          checklist: checklist,
          content: content,
          isDone: isDone,
        );

  /// Returns a shallow copy of this [CheckListItem]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  CheckListItem copyWith({
    Object? id = _Undefined,
    int? checklist,
    String? content,
    bool? isDone,
  }) {
    return CheckListItem(
      id: id is int? ? id : this.id,
      checklist: checklist ?? this.checklist,
      content: content ?? this.content,
      isDone: isDone ?? this.isDone,
    );
  }
}

class CheckListItemTable extends _i1.Table<int?> {
  CheckListItemTable({super.tableRelation})
      : super(tableName: 'checklist_item') {
    checklist = _i1.ColumnInt(
      'checklist',
      this,
    );
    content = _i1.ColumnString(
      'content',
      this,
    );
    isDone = _i1.ColumnBool(
      'isDone',
      this,
    );
  }

  late final _i1.ColumnInt checklist;

  late final _i1.ColumnString content;

  late final _i1.ColumnBool isDone;

  @override
  List<_i1.Column> get columns => [
        id,
        checklist,
        content,
        isDone,
      ];
}

class CheckListItemInclude extends _i1.IncludeObject {
  CheckListItemInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => CheckListItem.t;
}

class CheckListItemIncludeList extends _i1.IncludeList {
  CheckListItemIncludeList._({
    _i1.WhereExpressionBuilder<CheckListItemTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(CheckListItem.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => CheckListItem.t;
}

class CheckListItemRepository {
  const CheckListItemRepository._();

  /// Returns a list of [CheckListItem]s matching the given query parameters.
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
  Future<List<CheckListItem>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<CheckListItemTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CheckListItemTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CheckListItemTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<CheckListItem>(
      where: where?.call(CheckListItem.t),
      orderBy: orderBy?.call(CheckListItem.t),
      orderByList: orderByList?.call(CheckListItem.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [CheckListItem] matching the given query parameters.
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
  Future<CheckListItem?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<CheckListItemTable>? where,
    int? offset,
    _i1.OrderByBuilder<CheckListItemTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CheckListItemTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<CheckListItem>(
      where: where?.call(CheckListItem.t),
      orderBy: orderBy?.call(CheckListItem.t),
      orderByList: orderByList?.call(CheckListItem.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [CheckListItem] by its [id] or null if no such row exists.
  Future<CheckListItem?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<CheckListItem>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [CheckListItem]s in the list and returns the inserted rows.
  ///
  /// The returned [CheckListItem]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<CheckListItem>> insert(
    _i1.Session session,
    List<CheckListItem> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<CheckListItem>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [CheckListItem] and returns the inserted row.
  ///
  /// The returned [CheckListItem] will have its `id` field set.
  Future<CheckListItem> insertRow(
    _i1.Session session,
    CheckListItem row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<CheckListItem>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [CheckListItem]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<CheckListItem>> update(
    _i1.Session session,
    List<CheckListItem> rows, {
    _i1.ColumnSelections<CheckListItemTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<CheckListItem>(
      rows,
      columns: columns?.call(CheckListItem.t),
      transaction: transaction,
    );
  }

  /// Updates a single [CheckListItem]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<CheckListItem> updateRow(
    _i1.Session session,
    CheckListItem row, {
    _i1.ColumnSelections<CheckListItemTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<CheckListItem>(
      row,
      columns: columns?.call(CheckListItem.t),
      transaction: transaction,
    );
  }

  /// Deletes all [CheckListItem]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<CheckListItem>> delete(
    _i1.Session session,
    List<CheckListItem> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<CheckListItem>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [CheckListItem].
  Future<CheckListItem> deleteRow(
    _i1.Session session,
    CheckListItem row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<CheckListItem>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<CheckListItem>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<CheckListItemTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<CheckListItem>(
      where: where(CheckListItem.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<CheckListItemTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<CheckListItem>(
      where: where?.call(CheckListItem.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
