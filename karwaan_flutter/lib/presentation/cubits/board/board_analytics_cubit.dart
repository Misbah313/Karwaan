import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:karwaan_flutter/data/mappers/auth/error/exception_mapper.dart';
import 'package:karwaan_flutter/domain/models/board/board_analytics.dart';
import 'package:karwaan_flutter/domain/models/board/board_analytics_state.dart';
import 'package:karwaan_flutter/domain/repository/board/board_repo.dart';

// In your BoardAnalyticsCubit
class BoardAnalyticsCubit extends Cubit<BoardAnalyticsState> {
  final BoardRepo boardRepo;
  List<BoardAnalytics> _lastAnalytics = [];

  BoardAnalyticsCubit(this.boardRepo) : super(BoardAnalyticInitial());

  Future<void> getAnalyticsForMultiBoards(List<int> boardIds) async {
    // Don't emit loading state for auto-refreshes
    if (state is! BoardAnalyticsLoading) {
      emit(BoardAnalyticsLoading());
    }

    try {
      final analyticsList =
          await boardRepo.getAnalyticsForMultiBoards(boardIds);

      // Only emit if data actually changed
      if (!_hasAnalyticsChanged(analyticsList)) {
        return;
      }

      _lastAnalytics = analyticsList;
      emit(BoardAnalyticlistLoaded(analyticsList));
    } catch (e) {
      // Only emit error if we're not in a silent refresh
      if (state is! BoardAnalyticlistLoaded) {
        emit(BoardAnalyticError(ExceptionMapper.toMessage(e)));
      }
    }
  }

  bool _hasAnalyticsChanged(List<BoardAnalytics> newAnalytics) {
    if (_lastAnalytics.length != newAnalytics.length) return true;

    for (int i = 0; i < newAnalytics.length; i++) {
      final oldAnalytics = _lastAnalytics[i];
      final newAnalyticsItem = newAnalytics[i];

      if (oldAnalytics.boardId != newAnalyticsItem.boardId ||
          oldAnalytics.totalCards != newAnalyticsItem.totalCards ||
          oldAnalytics.completedCards != newAnalyticsItem.completedCards) {
        return true;
      }
    }

    return false;
  }
}
