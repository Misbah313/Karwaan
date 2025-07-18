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

abstract class Card implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  Card._({
    this.id,
    required this.title,
    this.description,
    required this.createdBy,
    required this.list,
    required this.createdAt,
    this.position,
    required this.isCompleted,
  });

  factory Card({
    int? id,
    required String title,
    String? description,
    required int createdBy,
    required int list,
    required DateTime createdAt,
    int? position,
    required bool isCompleted,
  }) = _CardImpl;

  factory Card.fromJson(Map<String, dynamic> jsonSerialization) {
    return Card(
      id: jsonSerialization['id'] as int?,
      title: jsonSerialization['title'] as String,
      description: jsonSerialization['description'] as String?,
      createdBy: jsonSerialization['createdBy'] as int,
      list: jsonSerialization['list'] as int,
      createdAt:
          _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      position: jsonSerialization['position'] as int?,
      isCompleted: jsonSerialization['isCompleted'] as bool,
    );
  }

  static final t = CardTable();

  static const db = CardRepository._();

  @override
  int? id;

  String title;

  String? description;

  int createdBy;

  int list;

  DateTime createdAt;

  int? position;

  bool isCompleted;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [Card]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Card copyWith({
    int? id,
    String? title,
    String? description,
    int? createdBy,
    int? list,
    DateTime? createdAt,
    int? position,
    bool? isCompleted,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'title': title,
      if (description != null) 'description': description,
      'createdBy': createdBy,
      'list': list,
      'createdAt': createdAt.toJson(),
      if (position != null) 'position': position,
      'isCompleted': isCompleted,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'title': title,
      if (description != null) 'description': description,
      'createdBy': createdBy,
      'list': list,
      'createdAt': createdAt.toJson(),
      if (position != null) 'position': position,
      'isCompleted': isCompleted,
    };
  }

  static CardInclude include() {
    return CardInclude._();
  }

  static CardIncludeList includeList({
    _i1.WhereExpressionBuilder<CardTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CardTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CardTable>? orderByList,
    CardInclude? include,
  }) {
    return CardIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Card.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(Card.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CardImpl extends Card {
  _CardImpl({
    int? id,
    required String title,
    String? description,
    required int createdBy,
    required int list,
    required DateTime createdAt,
    int? position,
    required bool isCompleted,
  }) : super._(
          id: id,
          title: title,
          description: description,
          createdBy: createdBy,
          list: list,
          createdAt: createdAt,
          position: position,
          isCompleted: isCompleted,
        );

  /// Returns a shallow copy of this [Card]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Card copyWith({
    Object? id = _Undefined,
    String? title,
    Object? description = _Undefined,
    int? createdBy,
    int? list,
    DateTime? createdAt,
    Object? position = _Undefined,
    bool? isCompleted,
  }) {
    return Card(
      id: id is int? ? id : this.id,
      title: title ?? this.title,
      description: description is String? ? description : this.description,
      createdBy: createdBy ?? this.createdBy,
      list: list ?? this.list,
      createdAt: createdAt ?? this.createdAt,
      position: position is int? ? position : this.position,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

class CardTable extends _i1.Table<int?> {
  CardTable({super.tableRelation}) : super(tableName: 'card') {
    title = _i1.ColumnString(
      'title',
      this,
    );
    description = _i1.ColumnString(
      'description',
      this,
    );
    createdBy = _i1.ColumnInt(
      'createdBy',
      this,
    );
    list = _i1.ColumnInt(
      'list',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
    position = _i1.ColumnInt(
      'position',
      this,
    );
    isCompleted = _i1.ColumnBool(
      'isCompleted',
      this,
    );
  }

  late final _i1.ColumnString title;

  late final _i1.ColumnString description;

  late final _i1.ColumnInt createdBy;

  late final _i1.ColumnInt list;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnInt position;

  late final _i1.ColumnBool isCompleted;

  @override
  List<_i1.Column> get columns => [
        id,
        title,
        description,
        createdBy,
        list,
        createdAt,
        position,
        isCompleted,
      ];
}

class CardInclude extends _i1.IncludeObject {
  CardInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => Card.t;
}

class CardIncludeList extends _i1.IncludeList {
  CardIncludeList._({
    _i1.WhereExpressionBuilder<CardTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Card.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => Card.t;
}

class CardRepository {
  const CardRepository._();

  /// Returns a list of [Card]s matching the given query parameters.
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
  Future<List<Card>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<CardTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CardTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CardTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<Card>(
      where: where?.call(Card.t),
      orderBy: orderBy?.call(Card.t),
      orderByList: orderByList?.call(Card.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [Card] matching the given query parameters.
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
  Future<Card?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<CardTable>? where,
    int? offset,
    _i1.OrderByBuilder<CardTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CardTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<Card>(
      where: where?.call(Card.t),
      orderBy: orderBy?.call(Card.t),
      orderByList: orderByList?.call(Card.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [Card] by its [id] or null if no such row exists.
  Future<Card?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<Card>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [Card]s in the list and returns the inserted rows.
  ///
  /// The returned [Card]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<Card>> insert(
    _i1.Session session,
    List<Card> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<Card>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [Card] and returns the inserted row.
  ///
  /// The returned [Card] will have its `id` field set.
  Future<Card> insertRow(
    _i1.Session session,
    Card row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<Card>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [Card]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<Card>> update(
    _i1.Session session,
    List<Card> rows, {
    _i1.ColumnSelections<CardTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<Card>(
      rows,
      columns: columns?.call(Card.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Card]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Card> updateRow(
    _i1.Session session,
    Card row, {
    _i1.ColumnSelections<CardTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<Card>(
      row,
      columns: columns?.call(Card.t),
      transaction: transaction,
    );
  }

  /// Deletes all [Card]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<Card>> delete(
    _i1.Session session,
    List<Card> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Card>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [Card].
  Future<Card> deleteRow(
    _i1.Session session,
    Card row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Card>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<Card>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<CardTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<Card>(
      where: where(Card.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<CardTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Card>(
      where: where?.call(Card.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
