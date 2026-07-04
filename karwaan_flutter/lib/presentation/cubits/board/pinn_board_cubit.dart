import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:karwaan_flutter/data/mappers/auth/error/exception_mapper.dart';
import 'package:karwaan_flutter/domain/models/board/pin_board_state.dart';
import 'package:karwaan_flutter/domain/repository/board/board_repo.dart';

class PinnedBoardCubit extends Cubit<PinnedBoardState> {
  final BoardRepo boardRepo;
  final Map<int, bool> _pinStatusCache = {};

  PinnedBoardCubit(this.boardRepo) : super(PinnedBoardInitial());

  // Get all pinned boards
  Future<void> getPinnedBoards() async {
    emit(PinnedBoardLoading());
    try {
      final boards = await boardRepo.getPinnedBoards();
      // Update cache
      for (var board in boards) {
        _pinStatusCache[board.id] = true;
      }
      emit(PinnedBoardLoaded(boards));
    } catch (e) {
      emit(PinnedBoardError(ExceptionMapper.toMessage(e)));
    }
  }

  // Pin a board
  Future<void> pinBoard(int boardId) async {
    try {
      await boardRepo.pinBoard(boardId);
      _pinStatusCache[boardId] = true;
      await getPinnedBoards();
      emit(PinStatusChecked(boardId, true));
    } catch (e) {
      rethrow;
    }
  }

  // Unpin a board
  Future<void> unpinBoard(int boardId) async {
    try {
      await boardRepo.unpinBoard(boardId);
      _pinStatusCache[boardId] = false;
      await getPinnedBoards();
      
      emit(PinStatusChecked(boardId, false));
    } catch (e) {
      rethrow;
    }
  }

  // Check if a specific board is pinned
  Future<bool> isBoardPinned(int boardId) async {
    if (_pinStatusCache.containsKey(boardId)) {
      return _pinStatusCache[boardId]!;
    }

    try {
      final isPinned = await boardRepo.isBoardPinned(boardId);
      _pinStatusCache[boardId] = isPinned;
      return isPinned;
    } catch (e) {
      return false;
    }
  }

  // Clear cache (useful for logout)
  void clearCache() {
    _pinStatusCache.clear();
  }
}