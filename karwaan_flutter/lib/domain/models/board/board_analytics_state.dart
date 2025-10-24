import 'package:karwaan_flutter/domain/models/board/board_analytics.dart';

abstract class BoardAnalyticsState {}

class BoardAnalyticInitial extends BoardAnalyticsState {}

class BoardAnalyticsLoading extends BoardAnalyticsState {}

class BoardAnalyticlistLoaded extends BoardAnalyticsState {
  final List<BoardAnalytics> boardAnalytics;

  BoardAnalyticlistLoaded(this.boardAnalytics);
}

class BoardAnalyticsLoaded extends BoardAnalyticsState {
  final BoardAnalytics analytics;
  BoardAnalyticsLoaded(this.analytics);
}

class BoardAnalyticError extends BoardAnalyticsState {
  final String error;

  BoardAnalyticError(this.error);
}
