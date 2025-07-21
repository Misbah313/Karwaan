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

abstract class BoardMemberDetails
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  BoardMemberDetails._({
    this.id,
    required this.userId,
    required this.userName,
    this.email,
    required this.role,
    required this.joinedAt,
  });

  factory BoardMemberDetails({
    int? id,
    required int userId,
    required String userName,
    String? email,
    required String role,
    required DateTime joinedAt,
  }) = _BoardMemberDetailsImpl;

  factory BoardMemberDetails.fromJson(Map<String, dynamic> jsonSerialization) {
    return BoardMemberDetails(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as int,
      userName: jsonSerialization['userName'] as String,
      email: jsonSerialization['email'] as String?,
      role: jsonSerialization['role'] as String,
      joinedAt:
          _i1.DateTimeJsonExtension.fromJson(jsonSerialization['joinedAt']),
    );
  }

  static final t = BoardMemberDetailsTable();

  static const db = BoardMemberDetailsRepository._();

  @override
  int? id;

  int userId;

  String userName;

  String? email;

  String role;

  DateTime joinedAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [BoardMemberDetails]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  BoardMemberDetails copyWith({
    int? id,
    int? userId,
    String? userName,
    String? email,
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
      'role': role,
      'joinedAt': joinedAt.toJson(),
    };
  }

  static BoardMemberDetailsInclude include() {
    return BoardMemberDetailsInclude._();
  }

  static BoardMemberDetailsIncludeList includeList({
    _i1.WhereExpressionBuilder<BoardMemberDetailsTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<BoardMemberDetailsTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<BoardMemberDetailsTable>? orderByList,
    BoardMemberDetailsInclude? include,
  }) {
    return BoardMemberDetailsIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(BoardMemberDetails.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(BoardMemberDetails.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _BoardMemberDetailsImpl extends BoardMemberDetails {
  _BoardMemberDetailsImpl({
    int? id,
    required int userId,
    required String userName,
    String? email,
    required String role,
    required DateTime joinedAt,
  }) : super._(
          id: id,
          userId: userId,
          userName: userName,
          email: email,
          role: role,
          joinedAt: joinedAt,
        );

  /// Returns a shallow copy of this [BoardMemberDetails]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  BoardMemberDetails copyWith({
    Object? id = _Undefined,
    int? userId,
    String? userName,
    Object? email = _Undefined,
    String? role,
    DateTime? joinedAt,
  }) {
    return BoardMemberDetails(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      email: email is String? ? email : this.email,
      role: role ?? this.role,
      joinedAt: joinedAt ?? this.joinedAt,
    );
  }
}

class BoardMemberDetailsTable extends _i1.Table<int?> {
  BoardMemberDetailsTable({super.tableRelation})
      : super(tableName: 'boardmemberdetails') {
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

  late final _i1.ColumnString role;

  late final _i1.ColumnDateTime joinedAt;

  @override
  List<_i1.Column> get columns => [
        id,
        userId,
        userName,
        email,
        role,
        joinedAt,
      ];
}

class BoardMemberDetailsInclude extends _i1.IncludeObject {
  BoardMemberDetailsInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => BoardMemberDetails.t;
}

class BoardMemberDetailsIncludeList extends _i1.IncludeList {
  BoardMemberDetailsIncludeList._({
    _i1.WhereExpressionBuilder<BoardMemberDetailsTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(BoardMemberDetails.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => BoardMemberDetails.t;
}

class BoardMemberDetailsRepository {
  const BoardMemberDetailsRepository._();

  /// Returns a list of [BoardMemberDetails]s matching the given query parameters.
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
  Future<List<BoardMemberDetails>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<BoardMemberDetailsTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<BoardMemberDetailsTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<BoardMemberDetailsTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<BoardMemberDetails>(
      where: where?.call(BoardMemberDetails.t),
      orderBy: orderBy?.call(BoardMemberDetails.t),
      orderByList: orderByList?.call(BoardMemberDetails.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [BoardMemberDetails] matching the given query parameters.
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
  Future<BoardMemberDetails?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<BoardMemberDetailsTable>? where,
    int? offset,
    _i1.OrderByBuilder<BoardMemberDetailsTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<BoardMemberDetailsTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<BoardMemberDetails>(
      where: where?.call(BoardMemberDetails.t),
      orderBy: orderBy?.call(BoardMemberDetails.t),
      orderByList: orderByList?.call(BoardMemberDetails.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [BoardMemberDetails] by its [id] or null if no such row exists.
  Future<BoardMemberDetails?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<BoardMemberDetails>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [BoardMemberDetails]s in the list and returns the inserted rows.
  ///
  /// The returned [BoardMemberDetails]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<BoardMemberDetails>> insert(
    _i1.Session session,
    List<BoardMemberDetails> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<BoardMemberDetails>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [BoardMemberDetails] and returns the inserted row.
  ///
  /// The returned [BoardMemberDetails] will have its `id` field set.
  Future<BoardMemberDetails> insertRow(
    _i1.Session session,
    BoardMemberDetails row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<BoardMemberDetails>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [BoardMemberDetails]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<BoardMemberDetails>> update(
    _i1.Session session,
    List<BoardMemberDetails> rows, {
    _i1.ColumnSelections<BoardMemberDetailsTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<BoardMemberDetails>(
      rows,
      columns: columns?.call(BoardMemberDetails.t),
      transaction: transaction,
    );
  }

  /// Updates a single [BoardMemberDetails]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<BoardMemberDetails> updateRow(
    _i1.Session session,
    BoardMemberDetails row, {
    _i1.ColumnSelections<BoardMemberDetailsTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<BoardMemberDetails>(
      row,
      columns: columns?.call(BoardMemberDetails.t),
      transaction: transaction,
    );
  }

  /// Deletes all [BoardMemberDetails]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<BoardMemberDetails>> delete(
    _i1.Session session,
    List<BoardMemberDetails> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<BoardMemberDetails>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [BoardMemberDetails].
  Future<BoardMemberDetails> deleteRow(
    _i1.Session session,
    BoardMemberDetails row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<BoardMemberDetails>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<BoardMemberDetails>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<BoardMemberDetailsTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<BoardMemberDetails>(
      where: where(BoardMemberDetails.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<BoardMemberDetailsTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<BoardMemberDetails>(
      where: where?.call(BoardMemberDetails.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
