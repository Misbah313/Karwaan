import 'package:karwaan_flutter/domain/models/board/board_analytics.dart';

sealed class BoardPreviewAnalyticsState {}

class AnalyticsIdle extends BoardPreviewAnalyticsState {}

class AnalyticsPreviewLoading extends BoardPreviewAnalyticsState {
  final int boardId;

  AnalyticsPreviewLoading(this.boardId);
}

class AnalyticsPreviewLoaded extends BoardPreviewAnalyticsState {
  final int boardId;
  final BoardAnalytics analytics;

  AnalyticsPreviewLoaded(this.boardId, this.analytics);
}

class AnalyticsPreviewError extends BoardPreviewAnalyticsState {
  final int boardId;
  final String message;

  AnalyticsPreviewError(this.boardId, this.message);
}
