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

abstract class WorkspaceMemberDetails
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  WorkspaceMemberDetails._({
    this.id,
    required this.userId,
    required this.userName,
    this.email,
    this.avatarUrl,
    required this.role,
    required this.joinedAt,
  });

  factory WorkspaceMemberDetails({
    int? id,
    required int userId,
    required String userName,
    String? email,
    String? avatarUrl,
    required String role,
    required DateTime joinedAt,
  }) = _WorkspaceMemberDetailsImpl;

  factory WorkspaceMemberDetails.fromJson(
      Map<String, dynamic> jsonSerialization) {
    return WorkspaceMemberDetails(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as int,
      userName: jsonSerialization['userName'] as String,
      email: jsonSerialization['email'] as String?,
      avatarUrl: jsonSerialization['avatarUrl'] as String?,
      role: jsonSerialization['role'] as String,
      joinedAt:
          _i1.DateTimeJsonExtension.fromJson(jsonSerialization['joinedAt']),
    );
  }

  static final t = WorkspaceMemberDetailsTable();

  static const db = WorkspaceMemberDetailsRepository._();

  @override
  int? id;

  int userId;

  String userName;

  String? email;

  String? avatarUrl;

  String role;

  DateTime joinedAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [WorkspaceMemberDetails]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  WorkspaceMemberDetails copyWith({
    int? id,
    int? userId,
    String? userName,
    String? email,
    String? avatarUrl,
    String? role,
    DateTime? joinedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'userId': userId,
      'userName': userName,
      if (email != null) 'email': email,
      if (avatarUrl != null) 'avatarUrl': avatarUrl,
      'role': role,
      'joinedAt': joinedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'userId': userId,
      'userName': userName,
      if (email != null) 'email': email,
      if (avatarUrl != null) 'avatarUrl': avatarUrl,
      'role': role,
      'joinedAt': joinedAt.toJson(),
    };
  }

  static WorkspaceMemberDetailsInclude include() {
    return WorkspaceMemberDetailsInclude._();
  }

  static WorkspaceMemberDetailsIncludeList includeList({
    _i1.WhereExpressionBuilder<WorkspaceMemberDetailsTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<WorkspaceMemberDetailsTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<WorkspaceMemberDetailsTable>? orderByList,
    WorkspaceMemberDetailsInclude? include,
  }) {
    return WorkspaceMemberDetailsIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(WorkspaceMemberDetails.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(WorkspaceMemberDetails.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _WorkspaceMemberDetailsImpl extends WorkspaceMemberDetails {
  _WorkspaceMemberDetailsImpl({
    int? id,
    required int userId,
    required String userName,
    String? email,
    String? avatarUrl,
    required String role,
    required DateTime joinedAt,
  }) : super._(
          id: id,
          userId: userId,
          userName: userName,
          email: email,
          avatarUrl: avatarUrl,
          role: role,
          joinedAt: joinedAt,
        );

  /// Returns a shallow copy of this [WorkspaceMemberDetails]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  WorkspaceMemberDetails copyWith({
    Object? id = _Undefined,
    int? userId,
    String? userName,
    Object? email = _Undefined,
    Object? avatarUrl = _Undefined,
    String? role,
    DateTime? joinedAt,
  }) {
    return WorkspaceMemberDetails(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      email: email is String? ? email : this.email,
      avatarUrl: avatarUrl is String? ? avatarUrl : this.avatarUrl,
      role: role ?? this.role,
      joinedAt: joinedAt ?? this.joinedAt,
    );
  }
}

class WorkspaceMemberDetailsTable extends _i1.Table<int?> {
  WorkspaceMemberDetailsTable({super.tableRelation})
      : super(tableName: 'workspacememberdetails') {
    userId = _i1.ColumnInt(
      'userId',
      this,
    );
    userName = _i1.ColumnString(
      'userName',
      this,
    );
    email = _i1.ColumnString(
      'email',
      this,
    );
    avatarUrl = _i1.ColumnString(
      'avatarUrl',
      this,
    );
    role = _i1.ColumnString(
      'role',
      this,
    );
    joinedAt = _i1.ColumnDateTime(
      'joinedAt',
      this,
    );
  }

  late final _i1.ColumnInt userId;

  late final _i1.ColumnString userName;

  late final _i1.ColumnString email;

  late final _i1.ColumnString avatarUrl;

  late final _i1.ColumnString role;

  late final _i1.ColumnDateTime joinedAt;

  @override
  List<_i1.Column> get columns => [
        id,
        userId,
        userName,
        email,
        avatarUrl,
        role,
        joinedAt,
      ];
}

class WorkspaceMemberDetailsInclude extends _i1.IncludeObject {
  WorkspaceMemberDetailsInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => WorkspaceMemberDetails.t;
}

class WorkspaceMemberDetailsIncludeList extends _i1.IncludeList {
  WorkspaceMemberDetailsIncludeList._({
    _i1.WhereExpressionBuilder<WorkspaceMemberDetailsTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(WorkspaceMemberDetails.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => WorkspaceMemberDetails.t;
}

class WorkspaceMemberDetailsRepository {
  const WorkspaceMemberDetailsRepository._();

  /// Returns a list of [WorkspaceMemberDetails]s matching the given query parameters.
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
  Future<List<WorkspaceMemberDetails>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<WorkspaceMemberDetailsTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<WorkspaceMemberDetailsTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<WorkspaceMemberDetailsTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<WorkspaceMemberDetails>(
      where: where?.call(WorkspaceMemberDetails.t),
      orderBy: orderBy?.call(WorkspaceMemberDetails.t),
      orderByList: orderByList?.call(WorkspaceMemberDetails.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [WorkspaceMemberDetails] matching the given query parameters.
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
  Future<WorkspaceMemberDetails?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<WorkspaceMemberDetailsTable>? where,
    int? offset,
    _i1.OrderByBuilder<WorkspaceMemberDetailsTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<WorkspaceMemberDetailsTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<WorkspaceMemberDetails>(
      where: where?.call(WorkspaceMemberDetails.t),
      orderBy: orderBy?.call(WorkspaceMemberDetails.t),
      orderByList: orderByList?.call(WorkspaceMemberDetails.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [WorkspaceMemberDetails] by its [id] or null if no such row exists.
  Future<WorkspaceMemberDetails?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<WorkspaceMemberDetails>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [WorkspaceMemberDetails]s in the list and returns the inserted rows.
  ///
  /// The returned [WorkspaceMemberDetails]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<WorkspaceMemberDetails>> insert(
    _i1.Session session,
    List<WorkspaceMemberDetails> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<WorkspaceMemberDetails>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [WorkspaceMemberDetails] and returns the inserted row.
  ///
  /// The returned [WorkspaceMemberDetails] will have its `id` field set.
  Future<WorkspaceMemberDetails> insertRow(
    _i1.Session session,
    WorkspaceMemberDetails row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<WorkspaceMemberDetails>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [WorkspaceMemberDetails]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<WorkspaceMemberDetails>> update(
    _i1.Session session,
    List<WorkspaceMemberDetails> rows, {
    _i1.ColumnSelections<WorkspaceMemberDetailsTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<WorkspaceMemberDetails>(
      rows,
      columns: columns?.call(WorkspaceMemberDetails.t),
      transaction: transaction,
    );
  }

  /// Updates a single [WorkspaceMemberDetails]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<WorkspaceMemberDetails> updateRow(
    _i1.Session session,
    WorkspaceMemberDetails row, {
    _i1.ColumnSelections<WorkspaceMemberDetailsTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<WorkspaceMemberDetails>(
      row,
      columns: columns?.call(WorkspaceMemberDetails.t),
      transaction: transaction,
    );
  }

  /// Deletes all [WorkspaceMemberDetails]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<WorkspaceMemberDetails>> delete(
    _i1.Session session,
    List<WorkspaceMemberDetails> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<WorkspaceMemberDetails>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [WorkspaceMemberDetails].
  Future<WorkspaceMemberDetails> deleteRow(
    _i1.Session session,
    WorkspaceMemberDetails row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<WorkspaceMemberDetails>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<WorkspaceMemberDetails>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<WorkspaceMemberDetailsTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<WorkspaceMemberDetails>(
      where: where(WorkspaceMemberDetails.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<WorkspaceMemberDetailsTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<WorkspaceMemberDetails>(
      where: where?.call(WorkspaceMemberDetails.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
