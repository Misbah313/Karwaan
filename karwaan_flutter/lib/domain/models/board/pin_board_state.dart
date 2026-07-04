import 'package:karwaan_flutter/domain/models/board/board_wrapper.dart';

abstract class PinnedBoardState {}

class PinnedBoardInitial extends PinnedBoardState {}

class PinnedBoardLoading extends PinnedBoardState {}

class PinnedBoardLoaded extends PinnedBoardState {
  final List<BoardWrapper> pinnedBoards;
  PinnedBoardLoaded(this.pinnedBoards);
}

class PinnedBoardError extends PinnedBoardState {
  final String error;
  PinnedBoardError(this.error);
}

// For checking individual board pin status
class PinStatusChecked extends PinnedBoardState {
  final int boardId;
  final bool isPinned;
  PinStatusChecked(this.boardId, this.isPinned);
}
