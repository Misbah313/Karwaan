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

abstract class CardLabel
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  CardLabel._({
    this.id,
    required this.card,
    required this.label,
  });

  factory CardLabel({
    int? id,
    required int card,
    required int label,
  }) = _CardLabelImpl;

  factory CardLabel.fromJson(Map<String, dynamic> jsonSerialization) {
    return CardLabel(
      id: jsonSerialization['id'] as int?,
      card: jsonSerialization['card'] as int,
      label: jsonSerialization['label'] as int,
    );
  }

  static final t = CardLabelTable();

  static const db = CardLabelRepository._();

  @override
  int? id;

  int card;

  int label;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [CardLabel]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  CardLabel copyWith({
    int? id,
    int? card,
    int? label,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'card': card,
      'label': label,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'card': card,
      'label': label,
    };
  }

  static CardLabelInclude include() {
    return CardLabelInclude._();
  }

  static CardLabelIncludeList includeList({
    _i1.WhereExpressionBuilder<CardLabelTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CardLabelTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CardLabelTable>? orderByList,
    CardLabelInclude? include,
  }) {
    return CardLabelIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CardLabel.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(CardLabel.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CardLabelImpl extends CardLabel {
  _CardLabelImpl({
    int? id,
    required int card,
    required int label,
  }) : super._(
          id: id,
          card: card,
          label: label,
        );

  /// Returns a shallow copy of this [CardLabel]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  CardLabel copyWith({
    Object? id = _Undefined,
    int? card,
    int? label,
  }) {
    return CardLabel(
      id: id is int? ? id : this.id,
      card: card ?? this.card,
      label: label ?? this.label,
    );
  }
}

class CardLabelTable extends _i1.Table<int?> {
  CardLabelTable({super.tableRelation}) : super(tableName: 'card_label') {
    card = _i1.ColumnInt(
      'card',
      this,
    );
    label = _i1.ColumnInt(
      'label',
      this,
    );
  }

  late final _i1.ColumnInt card;

  late final _i1.ColumnInt label;

  @override
  List<_i1.Column> get columns => [
        id,
        card,
        label,
      ];
}

class CardLabelInclude extends _i1.IncludeObject {
  CardLabelInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => CardLabel.t;
}

class CardLabelIncludeList extends _i1.IncludeList {
  CardLabelIncludeList._({
    _i1.WhereExpressionBuilder<CardLabelTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(CardLabel.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => CardLabel.t;
}

class CardLabelRepository {
  const CardLabelRepository._();

  /// Returns a list of [CardLabel]s matching the given query parameters.
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
  Future<List<CardLabel>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<CardLabelTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CardLabelTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CardLabelTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<CardLabel>(
      where: where?.call(CardLabel.t),
      orderBy: orderBy?.call(CardLabel.t),
      orderByList: orderByList?.call(CardLabel.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [CardLabel] matching the given query parameters.
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
  Future<CardLabel?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<CardLabelTable>? where,
    int? offset,
    _i1.OrderByBuilder<CardLabelTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CardLabelTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<CardLabel>(
      where: where?.call(CardLabel.t),
      orderBy: orderBy?.call(CardLabel.t),
      orderByList: orderByList?.call(CardLabel.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [CardLabel] by its [id] or null if no such row exists.
  Future<CardLabel?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<CardLabel>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [CardLabel]s in the list and returns the inserted rows.
  ///
  /// The returned [CardLabel]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<CardLabel>> insert(
    _i1.Session session,
    List<CardLabel> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<CardLabel>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [CardLabel] and returns the inserted row.
  ///
  /// The returned [CardLabel] will have its `id` field set.
  Future<CardLabel> insertRow(
    _i1.Session session,
    CardLabel row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<CardLabel>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [CardLabel]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<CardLabel>> update(
    _i1.Session session,
    List<CardLabel> rows, {
    _i1.ColumnSelections<CardLabelTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<CardLabel>(
      rows,
      columns: columns?.call(CardLabel.t),
      transaction: transaction,
    );
  }

  /// Updates a single [CardLabel]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<CardLabel> updateRow(
    _i1.Session session,
    CardLabel row, {
    _i1.ColumnSelections<CardLabelTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<CardLabel>(
      row,
      columns: columns?.call(CardLabel.t),
      transaction: transaction,
    );
  }

  /// Deletes all [CardLabel]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<CardLabel>> delete(
    _i1.Session session,
    List<CardLabel> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<CardLabel>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [CardLabel].
  Future<CardLabel> deleteRow(
    _i1.Session session,
    CardLabel row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<CardLabel>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<CardLabel>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<CardLabelTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<CardLabel>(
      where: where(CardLabel.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<CardLabelTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<CardLabel>(
      where: where?.call(CardLabel.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
