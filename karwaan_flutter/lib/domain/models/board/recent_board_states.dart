import 'package:karwaan_flutter/domain/models/board/board.dart';

abstract class RecentBoardStates {}

class RecentBoardInitial extends RecentBoardStates {}

class RecentBoardLoading extends RecentBoardStates {}

class RecentBoardlistLoaded extends RecentBoardStates {
  final List<Board> boards;

  RecentBoardlistLoaded(this.boards);
}

// class BoardsFromWorkspaceLoaded extends BoardState {
//   final List<BoardDetails> boards;

//   BoardsFromWorkspaceLoaded(this.boards);
// }

// class CreatedSuccessfully extends BoardState {
//   final String boardName;
//   final String boardDescription;

//   CreatedSuccessfully(this.boardName, this.boardDescription);
// }

// class DeletedSuccessfully extends BoardState {
//   final int boardId;

//   DeletedSuccessfully(this.boardId);
// }

class RecentBoardError extends RecentBoardStates {
  final String error;

  RecentBoardError(this.error);
}