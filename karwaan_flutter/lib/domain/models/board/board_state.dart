import 'package:karwaan_flutter/domain/models/board/board.dart';
import 'package:karwaan_flutter/domain/models/board/board_details.dart';

abstract class BoardState {}

class BoardInitial extends BoardState {}

class BoardLoading extends BoardState {}

class BoardUpdated extends BoardState {}

class BoardlistLoaded extends BoardState {
  final List<Board> boards;

  BoardlistLoaded(this.boards);
}

class BoardsFromWorkspaceLoaded extends BoardState {
  final List<BoardDetails> boards;

  BoardsFromWorkspaceLoaded(this.boards);
}

class CreatedSuccessfully extends BoardState {
  final String boardName;
  final String boardDescription;

  CreatedSuccessfully(this.boardName, this.boardDescription);
}

class DeletedSuccessfully extends BoardState {
  final int boardId;

  DeletedSuccessfully(this.boardId);
}

class BoardError extends BoardState {
  final String error;

  BoardError(this.error);
}
