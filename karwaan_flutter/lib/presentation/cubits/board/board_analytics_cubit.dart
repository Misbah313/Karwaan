import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:karwaan_flutter/data/mappers/auth/error/exception_mapper.dart';
import 'package:karwaan_flutter/domain/models/board/board_analytics_state.dart';
import 'package:karwaan_flutter/domain/repository/board/board_repo.dart';

class BoardAnalyticsCubit extends Cubit<BoardAnalyticsState> {
  final BoardRepo boardRepo;

  BoardAnalyticsCubit(this.boardRepo) : super(BoardAnalyticInitial());

  Future<void> getAnalyticsForMultiBoards(List<int> boardIds) async {
    try {
      final analyticsList =
          await boardRepo.getAnalyticsForMultiBoards(boardIds);
      emit(BoardAnalyticlistLoaded(analyticsList));
    } catch (e) {
      emit(BoardAnalyticError(ExceptionMapper.toMessage(e)));
    }
  }

  Future<void> getBoardAnalytics(int boardId) async {
    try {
      final boardAnalytics = await boardRepo.getBoardAnalytics(boardId);
      emit(BoardAnalyticsLoaded(boardAnalytics));
    } catch (e) {
      emit(BoardAnalyticError(ExceptionMapper.toMessage(e)));
    }
  }
}
