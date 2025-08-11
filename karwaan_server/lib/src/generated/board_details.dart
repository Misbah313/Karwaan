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

abstract class BoardDetails
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  BoardDetails._({
    this.id,
    required this.workspaceId,
    required this.name,
    this.description,
    required this.createdAt,
    required this.members,
  });

  factory BoardDetails({
    int? id,
    required int workspaceId,
    required String name,
    String? description,
    required DateTime createdAt,
    required List<String> members,
  }) = _BoardDetailsImpl;

  factory BoardDetails.fromJson(Map<String, dynamic> jsonSerialization) {
    return BoardDetails(
      id: jsonSerialization['id'] as int?,
      workspaceId: jsonSerialization['workspaceId'] as int,
      name: jsonSerialization['name'] as String,
      description: jsonSerialization['description'] as String?,
      createdAt:
          _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      members: (jsonSerialization['members'] as List)
          .map((e) => e as String)
          .toList(),
    );
  }

  static final t = BoardDetailsTable();

  static const db = BoardDetailsRepository._();

  @override
  int? id;

  int workspaceId;

  String name;

  String? description;

  DateTime createdAt;

  List<String> members;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [BoardDetails]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  BoardDetails copyWith({
    int? id,
    int? workspaceId,
    String? name,
    String? description,
    DateTime? createdAt,
    List<String>? members,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'workspaceId': workspaceId,
      'name': name,
      if (description != null) 'description': description,
      'createdAt': createdAt.toJson(),
      'members': members.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'workspaceId': workspaceId,
      'name': name,
      if (description != null) 'description': description,
      'createdAt': createdAt.toJson(),
      'members': members.toJson(),
    };
  }

  static BoardDetailsInclude include() {
    return BoardDetailsInclude._();
  }

  static BoardDetailsIncludeList includeList({
    _i1.WhereExpressionBuilder<BoardDetailsTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<BoardDetailsTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<BoardDetailsTable>? orderByList,
    BoardDetailsInclude? include,
  }) {
    return BoardDetailsIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(BoardDetails.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(BoardDetails.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _BoardDetailsImpl extends BoardDetails {
  _BoardDetailsImpl({
    int? id,
    required int workspaceId,
    required String name,
    String? description,
    required DateTime createdAt,
    required List<String> members,
  }) : super._(
          id: id,
          workspaceId: workspaceId,
          name: name,
          description: description,
          createdAt: createdAt,
          members: members,
        );

  /// Returns a shallow copy of this [BoardDetails]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  BoardDetails copyWith({
    Object? id = _Undefined,
    int? workspaceId,
    String? name,
    Object? description = _Undefined,
    DateTime? createdAt,
    List<String>? members,
  }) {
    return BoardDetails(
      id: id is int? ? id : this.id,
      workspaceId: workspaceId ?? this.workspaceId,
      name: name ?? this.name,
      description: description is String? ? description : this.description,
      createdAt: createdAt ?? this.createdAt,
      members: members ?? this.members.map((e0) => e0).toList(),
    );
  }
}

class BoardDetailsTable extends _i1.Table<int?> {
  BoardDetailsTable({super.tableRelation}) : super(tableName: 'board_details') {
    workspaceId = _i1.ColumnInt(
      'workspaceId',
      this,
    );
    name = _i1.ColumnString(
      'name',
      this,
    );
    description = _i1.ColumnString(
      'description',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
    members = _i1.ColumnSerializable(
      'members',
      this,
    );
  }

  late final _i1.ColumnInt workspaceId;

  late final _i1.ColumnString name;

  late final _i1.ColumnString description;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnSerializable members;

  @override
  List<_i1.Column> get columns => [
        id,
        workspaceId,
        name,
        description,
        createdAt,
        members,
      ];
}

class BoardDetailsInclude extends _i1.IncludeObject {
  BoardDetailsInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => BoardDetails.t;
}

class BoardDetailsIncludeList extends _i1.IncludeList {
  BoardDetailsIncludeList._({
    _i1.WhereExpressionBuilder<BoardDetailsTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(BoardDetails.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => BoardDetails.t;
}

class BoardDetailsRepository {
  const BoardDetailsRepository._();

  /// Returns a list of [BoardDetails]s matching the given query parameters.
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
  Future<List<BoardDetails>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<BoardDetailsTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<BoardDetailsTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<BoardDetailsTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<BoardDetails>(
      where: where?.call(BoardDetails.t),
      orderBy: orderBy?.call(BoardDetails.t),
      orderByList: orderByList?.call(BoardDetails.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [BoardDetails] matching the given query parameters.
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
  Future<BoardDetails?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<BoardDetailsTable>? where,
    int? offset,
    _i1.OrderByBuilder<BoardDetailsTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<BoardDetailsTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<BoardDetails>(
      where: where?.call(BoardDetails.t),
      orderBy: orderBy?.call(BoardDetails.t),
      orderByList: orderByList?.call(BoardDetails.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [BoardDetails] by its [id] or null if no such row exists.
  Future<BoardDetails?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<BoardDetails>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [BoardDetails]s in the list and returns the inserted rows.
  ///
  /// The returned [BoardDetails]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<BoardDetails>> insert(
    _i1.Session session,
    List<BoardDetails> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<BoardDetails>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [BoardDetails] and returns the inserted row.
  ///
  /// The returned [BoardDetails] will have its `id` field set.
  Future<BoardDetails> insertRow(
    _i1.Session session,
    BoardDetails row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<BoardDetails>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [BoardDetails]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<BoardDetails>> update(
    _i1.Session session,
    List<BoardDetails> rows, {
    _i1.ColumnSelections<BoardDetailsTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<BoardDetails>(
      rows,
      columns: columns?.call(BoardDetails.t),
      transaction: transaction,
    );
  }

  /// Updates a single [BoardDetails]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<BoardDetails> updateRow(
    _i1.Session session,
    BoardDetails row, {
    _i1.ColumnSelections<BoardDetailsTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<BoardDetails>(
      row,
      columns: columns?.call(BoardDetails.t),
      transaction: transaction,
    );
  }

  /// Deletes all [BoardDetails]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<BoardDetails>> delete(
    _i1.Session session,
    List<BoardDetails> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<BoardDetails>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [BoardDetails].
  Future<BoardDetails> deleteRow(
    _i1.Session session,
    BoardDetails row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<BoardDetails>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<BoardDetails>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<BoardDetailsTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<BoardDetails>(
      where: where(BoardDetails.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<BoardDetailsTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<BoardDetails>(
      where: where?.call(BoardDetails.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
