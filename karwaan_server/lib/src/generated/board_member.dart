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

abstract class BoardMember
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  BoardMember._({
    this.id,
    required this.user,
    required this.board,
    this.role,
    required this.joinedAt,
  });

  factory BoardMember({
    int? id,
    required int user,
    required int board,
    String? role,
    required DateTime joinedAt,
  }) = _BoardMemberImpl;

  factory BoardMember.fromJson(Map<String, dynamic> jsonSerialization) {
    return BoardMember(
      id: jsonSerialization['id'] as int?,
      user: jsonSerialization['user'] as int,
      board: jsonSerialization['board'] as int,
      role: jsonSerialization['role'] as String?,
      joinedAt:
          _i1.DateTimeJsonExtension.fromJson(jsonSerialization['joinedAt']),
    );
  }

  static final t = BoardMemberTable();

  static const db = BoardMemberRepository._();

  @override
  int? id;

  int user;

  int board;

  String? role;

  DateTime joinedAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [BoardMember]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  BoardMember copyWith({
    int? id,
    int? user,
    int? board,
    String? role,
    DateTime? joinedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'user': user,
      'board': board,
      if (role != null) 'role': role,
      'joinedAt': joinedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'user': user,
      'board': board,
      if (role != null) 'role': role,
      'joinedAt': joinedAt.toJson(),
    };
  }

  static BoardMemberInclude include() {
    return BoardMemberInclude._();
  }

  static BoardMemberIncludeList includeList({
    _i1.WhereExpressionBuilder<BoardMemberTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<BoardMemberTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<BoardMemberTable>? orderByList,
    BoardMemberInclude? include,
  }) {
    return BoardMemberIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(BoardMember.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(BoardMember.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _BoardMemberImpl extends BoardMember {
  _BoardMemberImpl({
    int? id,
    required int user,
    required int board,
    String? role,
    required DateTime joinedAt,
  }) : super._(
          id: id,
          user: user,
          board: board,
          role: role,
          joinedAt: joinedAt,
        );

  /// Returns a shallow copy of this [BoardMember]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  BoardMember copyWith({
    Object? id = _Undefined,
    int? user,
    int? board,
    Object? role = _Undefined,
    DateTime? joinedAt,
  }) {
    return BoardMember(
      id: id is int? ? id : this.id,
      user: user ?? this.user,
      board: board ?? this.board,
      role: role is String? ? role : this.role,
      joinedAt: joinedAt ?? this.joinedAt,
    );
  }
}

class BoardMemberTable extends _i1.Table<int?> {
  BoardMemberTable({super.tableRelation}) : super(tableName: 'board_member') {
    user = _i1.ColumnInt(
      'user',
      this,
    );
    board = _i1.ColumnInt(
      'board',
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

  late final _i1.ColumnInt user;

  late final _i1.ColumnInt board;

  late final _i1.ColumnString role;

  late final _i1.ColumnDateTime joinedAt;

  @override
  List<_i1.Column> get columns => [
        id,
        user,
        board,
        role,
        joinedAt,
      ];
}

class BoardMemberInclude extends _i1.IncludeObject {
  BoardMemberInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => BoardMember.t;
}

class BoardMemberIncludeList extends _i1.IncludeList {
  BoardMemberIncludeList._({
    _i1.WhereExpressionBuilder<BoardMemberTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(BoardMember.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => BoardMember.t;
}

class BoardMemberRepository {
  const BoardMemberRepository._();

  /// Returns a list of [BoardMember]s matching the given query parameters.
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
  Future<List<BoardMember>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<BoardMemberTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<BoardMemberTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<BoardMemberTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<BoardMember>(
      where: where?.call(BoardMember.t),
      orderBy: orderBy?.call(BoardMember.t),
      orderByList: orderByList?.call(BoardMember.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [BoardMember] matching the given query parameters.
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
  Future<BoardMember?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<BoardMemberTable>? where,
    int? offset,
    _i1.OrderByBuilder<BoardMemberTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<BoardMemberTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<BoardMember>(
      where: where?.call(BoardMember.t),
      orderBy: orderBy?.call(BoardMember.t),
      orderByList: orderByList?.call(BoardMember.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [BoardMember] by its [id] or null if no such row exists.
  Future<BoardMember?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<BoardMember>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [BoardMember]s in the list and returns the inserted rows.
  ///
  /// The returned [BoardMember]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<BoardMember>> insert(
    _i1.Session session,
    List<BoardMember> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<BoardMember>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [BoardMember] and returns the inserted row.
  ///
  /// The returned [BoardMember] will have its `id` field set.
  Future<BoardMember> insertRow(
    _i1.Session session,
    BoardMember row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<BoardMember>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [BoardMember]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<BoardMember>> update(
    _i1.Session session,
    List<BoardMember> rows, {
    _i1.ColumnSelections<BoardMemberTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<BoardMember>(
      rows,
      columns: columns?.call(BoardMember.t),
      transaction: transaction,
    );
  }

  /// Updates a single [BoardMember]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<BoardMember> updateRow(
    _i1.Session session,
    BoardMember row, {
    _i1.ColumnSelections<BoardMemberTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<BoardMember>(
      row,
      columns: columns?.call(BoardMember.t),
      transaction: transaction,
    );
  }

  /// Deletes all [BoardMember]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<BoardMember>> delete(
    _i1.Session session,
    List<BoardMember> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<BoardMember>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [BoardMember].
  Future<BoardMember> deleteRow(
    _i1.Session session,
    BoardMember row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<BoardMember>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<BoardMember>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<BoardMemberTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<BoardMember>(
      where: where(BoardMember.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<BoardMemberTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<BoardMember>(
      where: where?.call(BoardMember.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
