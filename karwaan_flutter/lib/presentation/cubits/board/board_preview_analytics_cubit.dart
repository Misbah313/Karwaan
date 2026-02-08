import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:karwaan_flutter/data/mappers/auth/error/exception_mapper.dart';
import 'package:karwaan_flutter/domain/models/board/board_preview_analytics_state.dart';
import 'package:karwaan_flutter/domain/repository/board/board_repo.dart';

class BoardPreviewAnalyticsCubit extends Cubit<BoardPreviewAnalyticsState> {
  final BoardRepo repo;

  BoardPreviewAnalyticsCubit(this.repo) : super(AnalyticsIdle());

  Future<void> loadForBoard(int boardId) async {
    // lazy guard
    final current = state;
    if (current is AnalyticsPreviewLoaded && current.boardId == boardId) return;
    if (current is AnalyticsPreviewLoading && current.boardId == boardId)
      return;

    emit(AnalyticsPreviewLoading(boardId));

    try {
      final analytics = await repo.getBoardAnalytics(boardId);

      // stale response guard
      // if user switched boards while request is ongoing, just ignore results
      final latest = state;
      if (latest is AnalyticsPreviewLoading && latest.boardId != boardId)
        return;

      emit(AnalyticsPreviewLoaded(boardId, analytics));
    } catch (e) {
      final message = ExceptionMapper.toMessage(e);

      final latest = state;
      if (latest is AnalyticsPreviewLoading && latest.boardId != boardId)
        return;
      emit(AnalyticsPreviewError(boardId, message));
    }
  }

  void clear() {
    emit(AnalyticsIdle());
  }
}
