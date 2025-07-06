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

abstract class Label implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  Label._({
    this.id,
    required this.name,
    required this.color,
    required this.board,
  });

  factory Label({
    int? id,
    required String name,
    required String color,
    required int board,
  }) = _LabelImpl;

  factory Label.fromJson(Map<String, dynamic> jsonSerialization) {
    return Label(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      color: jsonSerialization['color'] as String,
      board: jsonSerialization['board'] as int,
    );
  }

  static final t = LabelTable();

  static const db = LabelRepository._();

  @override
  int? id;

  String name;

  String color;

  int board;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [Label]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Label copyWith({
    int? id,
    String? name,
    String? color,
    int? board,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'color': color,
      'board': board,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'color': color,
      'board': board,
    };
  }

  static LabelInclude include() {
    return LabelInclude._();
  }

  static LabelIncludeList includeList({
    _i1.WhereExpressionBuilder<LabelTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<LabelTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<LabelTable>? orderByList,
    LabelInclude? include,
  }) {
    return LabelIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Label.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(Label.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _LabelImpl extends Label {
  _LabelImpl({
    int? id,
    required String name,
    required String color,
    required int board,
  }) : super._(
          id: id,
          name: name,
          color: color,
          board: board,
        );

  /// Returns a shallow copy of this [Label]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Label copyWith({
    Object? id = _Undefined,
    String? name,
    String? color,
    int? board,
  }) {
    return Label(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      color: color ?? this.color,
      board: board ?? this.board,
    );
  }
}

class LabelTable extends _i1.Table<int?> {
  LabelTable({super.tableRelation}) : super(tableName: 'lable') {
    name = _i1.ColumnString(
      'name',
      this,
    );
    color = _i1.ColumnString(
      'color',
      this,
    );
    board = _i1.ColumnInt(
      'board',
      this,
    );
  }

  late final _i1.ColumnString name;

  late final _i1.ColumnString color;

  late final _i1.ColumnInt board;

  @override
  List<_i1.Column> get columns => [
        id,
        name,
        color,
        board,
      ];
}

class LabelInclude extends _i1.IncludeObject {
  LabelInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => Label.t;
}

class LabelIncludeList extends _i1.IncludeList {
  LabelIncludeList._({
    _i1.WhereExpressionBuilder<LabelTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Label.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => Label.t;
}

class LabelRepository {
  const LabelRepository._();

  /// Returns a list of [Label]s matching the given query parameters.
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
  Future<List<Label>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<LabelTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<LabelTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<LabelTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<Label>(
      where: where?.call(Label.t),
      orderBy: orderBy?.call(Label.t),
      orderByList: orderByList?.call(Label.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [Label] matching the given query parameters.
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
  Future<Label?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<LabelTable>? where,
    int? offset,
    _i1.OrderByBuilder<LabelTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<LabelTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<Label>(
      where: where?.call(Label.t),
      orderBy: orderBy?.call(Label.t),
      orderByList: orderByList?.call(Label.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [Label] by its [id] or null if no such row exists.
  Future<Label?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<Label>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [Label]s in the list and returns the inserted rows.
  ///
  /// The returned [Label]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<Label>> insert(
    _i1.Session session,
    List<Label> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<Label>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [Label] and returns the inserted row.
  ///
  /// The returned [Label] will have its `id` field set.
  Future<Label> insertRow(
    _i1.Session session,
    Label row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<Label>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [Label]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<Label>> update(
    _i1.Session session,
    List<Label> rows, {
    _i1.ColumnSelections<LabelTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<Label>(
      rows,
      columns: columns?.call(Label.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Label]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Label> updateRow(
    _i1.Session session,
    Label row, {
    _i1.ColumnSelections<LabelTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<Label>(
      row,
      columns: columns?.call(Label.t),
      transaction: transaction,
    );
  }

  /// Deletes all [Label]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<Label>> delete(
    _i1.Session session,
    List<Label> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Label>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [Label].
  Future<Label> deleteRow(
    _i1.Session session,
    Label row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Label>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<Label>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<LabelTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<Label>(
      where: where(Label.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<LabelTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Label>(
      where: where?.call(Label.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
