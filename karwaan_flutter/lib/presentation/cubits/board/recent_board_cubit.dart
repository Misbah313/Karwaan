import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:karwaan_flutter/data/mappers/auth/error/exception_mapper.dart';
import 'package:karwaan_flutter/domain/models/board/recent_board_states.dart';
import 'package:karwaan_flutter/domain/repository/board/board_repo.dart';

class RecentBoardCubit extends Cubit<RecentBoardStates> {
  final BoardRepo boardRepo;

  RecentBoardCubit(this.boardRepo) : super(RecentBoardInitial());

  Future<void> trackRecentBoard(int boardId) async {
    try {
      await boardRepo.trackRecentBoard(boardId);
    } catch (e) {
      emit(RecentBoardError(ExceptionMapper.toMessage(e)));
    }
  }

  Future<void> getUserRecentBoards({bool silent = false}) async {
    if (!silent) {
      emit(RecentBoardLoading());
    }

    try {
      final boards = await boardRepo.getUserRecentBoards();
      emit(RecentBoardlistLoaded(boards));
    } catch (e) {
      if (!silent) {
        emit(RecentBoardError(ExceptionMapper.toMessage(e)));
      }
    }
  }
}
