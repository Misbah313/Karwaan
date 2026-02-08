/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

abstract class BoardAnalytics implements _i1.SerializableModel {
  BoardAnalytics._({
    this.id,
    required this.boardId,
    this.boardName,
    required this.totalCards,
    required this.completedCards,
    required this.completionPercentage,
    this.cardPerList,
    required this.lastUpdate,
  });

  factory BoardAnalytics({
    int? id,
    required int boardId,
    String? boardName,
    required int totalCards,
    required int completedCards,
    required double completionPercentage,
    Map<String, int>? cardPerList,
    required DateTime lastUpdate,
  }) = _BoardAnalyticsImpl;

  factory BoardAnalytics.fromJson(Map<String, dynamic> jsonSerialization) {
    return BoardAnalytics(
      id: jsonSerialization['id'] as int?,
      boardId: jsonSerialization['boardId'] as int,
      boardName: jsonSerialization['boardName'] as String?,
      totalCards: jsonSerialization['totalCards'] as int,
      completedCards: jsonSerialization['completedCards'] as int,
      completionPercentage:
          (jsonSerialization['completionPercentage'] as num).toDouble(),
      cardPerList:
          (jsonSerialization['cardPerList'] as Map?)?.map((k, v) => MapEntry(
                k as String,
                v as int,
              )),
      lastUpdate:
          _i1.DateTimeJsonExtension.fromJson(jsonSerialization['lastUpdate']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int boardId;

  String? boardName;

  int totalCards;

  int completedCards;

  double completionPercentage;

  Map<String, int>? cardPerList;

  DateTime lastUpdate;

  /// Returns a shallow copy of this [BoardAnalytics]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  BoardAnalytics copyWith({
    int? id,
    int? boardId,
    String? boardName,
    int? totalCards,
    int? completedCards,
    double? completionPercentage,
    Map<String, int>? cardPerList,
    DateTime? lastUpdate,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'boardId': boardId,
      if (boardName != null) 'boardName': boardName,
      'totalCards': totalCards,
      'completedCards': completedCards,
      'completionPercentage': completionPercentage,
      if (cardPerList != null) 'cardPerList': cardPerList?.toJson(),
      'lastUpdate': lastUpdate.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _BoardAnalyticsImpl extends BoardAnalytics {
  _BoardAnalyticsImpl({
    int? id,
    required int boardId,
    String? boardName,
    required int totalCards,
    required int completedCards,
    required double completionPercentage,
    Map<String, int>? cardPerList,
    required DateTime lastUpdate,
  }) : super._(
          id: id,
          boardId: boardId,
          boardName: boardName,
          totalCards: totalCards,
          completedCards: completedCards,
          completionPercentage: completionPercentage,
          cardPerList: cardPerList,
          lastUpdate: lastUpdate,
        );

  /// Returns a shallow copy of this [BoardAnalytics]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  BoardAnalytics copyWith({
    Object? id = _Undefined,
    int? boardId,
    Object? boardName = _Undefined,
    int? totalCards,
    int? completedCards,
    double? completionPercentage,
    Object? cardPerList = _Undefined,
    DateTime? lastUpdate,
  }) {
    return BoardAnalytics(
      id: id is int? ? id : this.id,
      boardId: boardId ?? this.boardId,
      boardName: boardName is String? ? boardName : this.boardName,
      totalCards: totalCards ?? this.totalCards,
      completedCards: completedCards ?? this.completedCards,
      completionPercentage: completionPercentage ?? this.completionPercentage,
      cardPerList: cardPerList is Map<String, int>?
          ? cardPerList
          : this.cardPerList?.map((
                key0,
                value0,
              ) =>
                  MapEntry(
                    key0,
                    value0,
                  )),
      lastUpdate: lastUpdate ?? this.lastUpdate,
    );
  }
}
