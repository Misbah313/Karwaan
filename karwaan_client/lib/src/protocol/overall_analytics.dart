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

abstract class OverAllAnalytics implements _i1.SerializableModel {
  OverAllAnalytics._({
    this.id,
    required this.userId,
    required this.totalBoard,
    required this.totalCard,
    required this.completedCards,
    required this.completionPercentage,
    this.cardsPerWorkspace,
    this.cardsPerStatus,
    required this.lastUpdate,
  });

  factory OverAllAnalytics({
    int? id,
    required int userId,
    required int totalBoard,
    required int totalCard,
    required int completedCards,
    required double completionPercentage,
    Map<String, int>? cardsPerWorkspace,
    Map<String, int>? cardsPerStatus,
    required DateTime lastUpdate,
  }) = _OverAllAnalyticsImpl;

  factory OverAllAnalytics.fromJson(Map<String, dynamic> jsonSerialization) {
    return OverAllAnalytics(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as int,
      totalBoard: jsonSerialization['totalBoard'] as int,
      totalCard: jsonSerialization['totalCard'] as int,
      completedCards: jsonSerialization['completedCards'] as int,
      completionPercentage:
          (jsonSerialization['completionPercentage'] as num).toDouble(),
      cardsPerWorkspace: (jsonSerialization['cardsPerWorkspace'] as Map?)
          ?.map((k, v) => MapEntry(
                k as String,
                v as int,
              )),
      cardsPerStatus:
          (jsonSerialization['cardsPerStatus'] as Map?)?.map((k, v) => MapEntry(
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

  int userId;

  int totalBoard;

  int totalCard;

  int completedCards;

  double completionPercentage;

  Map<String, int>? cardsPerWorkspace;

  Map<String, int>? cardsPerStatus;

  DateTime lastUpdate;

  /// Returns a shallow copy of this [OverAllAnalytics]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  OverAllAnalytics copyWith({
    int? id,
    int? userId,
    int? totalBoard,
    int? totalCard,
    int? completedCards,
    double? completionPercentage,
    Map<String, int>? cardsPerWorkspace,
    Map<String, int>? cardsPerStatus,
    DateTime? lastUpdate,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'userId': userId,
      'totalBoard': totalBoard,
      'totalCard': totalCard,
      'completedCards': completedCards,
      'completionPercentage': completionPercentage,
      if (cardsPerWorkspace != null)
        'cardsPerWorkspace': cardsPerWorkspace?.toJson(),
      if (cardsPerStatus != null) 'cardsPerStatus': cardsPerStatus?.toJson(),
      'lastUpdate': lastUpdate.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _OverAllAnalyticsImpl extends OverAllAnalytics {
  _OverAllAnalyticsImpl({
    int? id,
    required int userId,
    required int totalBoard,
    required int totalCard,
    required int completedCards,
    required double completionPercentage,
    Map<String, int>? cardsPerWorkspace,
    Map<String, int>? cardsPerStatus,
    required DateTime lastUpdate,
  }) : super._(
          id: id,
          userId: userId,
          totalBoard: totalBoard,
          totalCard: totalCard,
          completedCards: completedCards,
          completionPercentage: completionPercentage,
          cardsPerWorkspace: cardsPerWorkspace,
          cardsPerStatus: cardsPerStatus,
          lastUpdate: lastUpdate,
        );

  /// Returns a shallow copy of this [OverAllAnalytics]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  OverAllAnalytics copyWith({
    Object? id = _Undefined,
    int? userId,
    int? totalBoard,
    int? totalCard,
    int? completedCards,
    double? completionPercentage,
    Object? cardsPerWorkspace = _Undefined,
    Object? cardsPerStatus = _Undefined,
    DateTime? lastUpdate,
  }) {
    return OverAllAnalytics(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      totalBoard: totalBoard ?? this.totalBoard,
      totalCard: totalCard ?? this.totalCard,
      completedCards: completedCards ?? this.completedCards,
      completionPercentage: completionPercentage ?? this.completionPercentage,
      cardsPerWorkspace: cardsPerWorkspace is Map<String, int>?
          ? cardsPerWorkspace
          : this.cardsPerWorkspace?.map((
                key0,
                value0,
              ) =>
                  MapEntry(
                    key0,
                    value0,
                  )),
      cardsPerStatus: cardsPerStatus is Map<String, int>?
          ? cardsPerStatus
          : this.cardsPerStatus?.map((
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
