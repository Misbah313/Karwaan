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

abstract class UserToken
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  UserToken._({
    this.id,
    required this.userId,
    required this.token,
    required this.createdAt,
    required this.expiresAt,
  });

  factory UserToken({
    int? id,
    required int userId,
    required String token,
    required DateTime createdAt,
    required DateTime expiresAt,
  }) = _UserTokenImpl;

  factory UserToken.fromJson(Map<String, dynamic> jsonSerialization) {
    return UserToken(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as int,
      token: jsonSerialization['token'] as String,
      createdAt:
          _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      expiresAt:
          _i1.DateTimeJsonExtension.fromJson(jsonSerialization['expiresAt']),
    );
  }

  static final t = UserTokenTable();

  static const db = UserTokenRepository._();

  @override
  int? id;

  int userId;

  String token;

  DateTime createdAt;

  DateTime expiresAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [UserToken]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  UserToken copyWith({
    int? id,
    int? userId,
    String? token,
    DateTime? createdAt,
    DateTime? expiresAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'userId': userId,
      'token': token,
      'createdAt': createdAt.toJson(),
      'expiresAt': expiresAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'userId': userId,
      'token': token,
      'createdAt': createdAt.toJson(),
      'expiresAt': expiresAt.toJson(),
    };
  }

  static UserTokenInclude include() {
    return UserTokenInclude._();
  }

  static UserTokenIncludeList includeList({
    _i1.WhereExpressionBuilder<UserTokenTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UserTokenTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UserTokenTable>? orderByList,
    UserTokenInclude? include,
  }) {
    return UserTokenIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(UserToken.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(UserToken.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UserTokenImpl extends UserToken {
  _UserTokenImpl({
    int? id,
    required int userId,
    required String token,
    required DateTime createdAt,
    required DateTime expiresAt,
  }) : super._(
          id: id,
          userId: userId,
          token: token,
          createdAt: createdAt,
          expiresAt: expiresAt,
        );

  /// Returns a shallow copy of this [UserToken]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  UserToken copyWith({
    Object? id = _Undefined,
    int? userId,
    String? token,
    DateTime? createdAt,
    DateTime? expiresAt,
  }) {
    return UserToken(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      token: token ?? this.token,
      createdAt: createdAt ?? this.createdAt,
      expiresAt: expiresAt ?? this.expiresAt,
    );
  }
}

class UserTokenTable extends _i1.Table<int?> {
  UserTokenTable({super.tableRelation}) : super(tableName: 'user_token') {
    userId = _i1.ColumnInt(
      'userId',
      this,
    );
    token = _i1.ColumnString(
      'token',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
    expiresAt = _i1.ColumnDateTime(
      'expiresAt',
      this,
    );
  }

  late final _i1.ColumnInt userId;

  late final _i1.ColumnString token;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime expiresAt;

  @override
  List<_i1.Column> get columns => [
        id,
        userId,
        token,
        createdAt,
        expiresAt,
      ];
}

class UserTokenInclude extends _i1.IncludeObject {
  UserTokenInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => UserToken.t;
}

class UserTokenIncludeList extends _i1.IncludeList {
  UserTokenIncludeList._({
    _i1.WhereExpressionBuilder<UserTokenTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(UserToken.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => UserToken.t;
}

class UserTokenRepository {
  const UserTokenRepository._();

  /// Returns a list of [UserToken]s matching the given query parameters.
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
  Future<List<UserToken>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<UserTokenTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UserTokenTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UserTokenTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<UserToken>(
      where: where?.call(UserToken.t),
      orderBy: orderBy?.call(UserToken.t),
      orderByList: orderByList?.call(UserToken.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [UserToken] matching the given query parameters.
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
  Future<UserToken?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<UserTokenTable>? where,
    int? offset,
    _i1.OrderByBuilder<UserTokenTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UserTokenTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<UserToken>(
      where: where?.call(UserToken.t),
      orderBy: orderBy?.call(UserToken.t),
      orderByList: orderByList?.call(UserToken.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [UserToken] by its [id] or null if no such row exists.
  Future<UserToken?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<UserToken>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [UserToken]s in the list and returns the inserted rows.
  ///
  /// The returned [UserToken]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<UserToken>> insert(
    _i1.Session session,
    List<UserToken> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<UserToken>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [UserToken] and returns the inserted row.
  ///
  /// The returned [UserToken] will have its `id` field set.
  Future<UserToken> insertRow(
    _i1.Session session,
    UserToken row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<UserToken>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [UserToken]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<UserToken>> update(
    _i1.Session session,
    List<UserToken> rows, {
    _i1.ColumnSelections<UserTokenTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<UserToken>(
      rows,
      columns: columns?.call(UserToken.t),
      transaction: transaction,
    );
  }

  /// Updates a single [UserToken]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<UserToken> updateRow(
    _i1.Session session,
    UserToken row, {
    _i1.ColumnSelections<UserTokenTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<UserToken>(
      row,
      columns: columns?.call(UserToken.t),
      transaction: transaction,
    );
  }

  /// Deletes all [UserToken]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<UserToken>> delete(
    _i1.Session session,
    List<UserToken> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<UserToken>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [UserToken].
  Future<UserToken> deleteRow(
    _i1.Session session,
    UserToken row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<UserToken>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<UserToken>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<UserTokenTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<UserToken>(
      where: where(UserToken.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<UserTokenTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<UserToken>(
      where: where?.call(UserToken.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
