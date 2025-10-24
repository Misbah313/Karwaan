

import 'package:karwaan_flutter/domain/models/board/overall_analytics.dart';

abstract class OverallAnalyticStates {}

class OverallAnalyticInitial extends OverallAnalyticStates {}

class OverallAnalyticsLoading extends OverallAnalyticStates {}

class OverallAnalyticlistLoaded extends OverallAnalyticStates {
  final List<OverallAnalytics> overallAnalytics;

  OverallAnalyticlistLoaded(this.overallAnalytics);
}

class OverallAnalyticsLoaded extends OverallAnalyticStates {
  final OverallAnalytics analytics;
  OverallAnalyticsLoaded(this.analytics);
}

class OverallAnalyticError extends OverallAnalyticStates {
  final String error;

  OverallAnalyticError(this.error);
}
