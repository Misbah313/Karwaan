import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:karwaan_flutter/data/mappers/auth/error/exception_mapper.dart';
import 'package:karwaan_flutter/domain/models/board/board_credentials.dart';
import 'package:karwaan_flutter/domain/models/board/board_state.dart';
import 'package:karwaan_flutter/domain/models/board/create_board_credentials.dart';
import 'package:karwaan_flutter/domain/repository/board/board_repo.dart';

class BoardCubit extends Cubit<BoardState> {
  final BoardRepo boardRepo;

  BoardCubit(this.boardRepo) : super(BoardInitial());

  Future<void> createBoard(CreateBoardCredentials credentials) async {
    emit(BoardLoading());
    try {
      final board = await boardRepo.createBoard(credentials);
      emit(CreatedSuccessfully(board.boardName, board.boardDescription));
    } catch (e) {
      emit(BoardError(ExceptionMapper.toMessage(e)));
    }
  }

  Future<void> getUserBoards() async {
    emit(BoardLoading());
    try {
      final boards = await boardRepo.getUserBoards();
      emit(BoardlistLoaded(boards));
    } catch (e) {
      emit(BoardError(ExceptionMapper.toMessage(e)));
    }
  }

  Future<void> updateBoard(BoardCredentials credentials) async {
    emit(BoardLoading());
    try {
      await boardRepo.updateBoard(credentials);
      emit(BoardUpdated());
      final boards = await boardRepo.getUserBoards();
      emit(BoardlistLoaded(boards));
    } catch (e) {
      emit(BoardError(ExceptionMapper.toMessage(e)));
    }
  }

  Future<void> updateBoardOptimized(
      BoardCredentials credentails, int worksapceId) async {
    try {
      await boardRepo.updateBoard(credentails);

      // if board already loaded, update just the one that changed
      if (state is BoardlistLoaded) {
        final currentState = state as BoardlistLoaded;
        final updatedBoard = currentState.boards.map((boards) {
          if (boards.id == credentails.id) {
            return boards.copyWith(
              boardName: credentails.boardName,
              boardDescription: credentails.boardDescription,
            );
          }

          return boards;
        }).toList();
        emit(BoardlistLoaded(updatedBoard));
      } else {
        await getBoardsByWorkspace(worksapceId);
      }
    } catch (e) {
      emit(BoardError(ExceptionMapper.toMessage(e)));
    }
  }

  Future<void> deleteBoard(int boardId) async {
    emit(BoardLoading());
    try {
      await boardRepo.deleteBoard(boardId);
      emit(DeletedSuccessfully(boardId));
    } catch (e) {
      emit(BoardError(ExceptionMapper.toMessage(e)));
    }
  }

  Future<void> deleteBoardOptimized(int boardId, int worksapceId) async {
    try {
      await boardRepo.deleteBoard(boardId);

      // if board already loaded, remove just the deleted one
      if (state is BoardlistLoaded) {
        final currentState = state as BoardlistLoaded;
        final updatedBoards =
            currentState.boards.where((board) => board.id != boardId).toList();
        emit(BoardlistLoaded(updatedBoards));
      } else {
        await getBoardsByWorkspace(worksapceId);
      }
    } catch (e) {
      emit(BoardError(ExceptionMapper.toMessage(e)));
    }
  }

  Future<void> getBoardsByWorkspace(int workspaceId) async {
    emit(BoardLoading());
    try {
      final boards = await boardRepo.getBoardsByWorkspace(workspaceId);
      emit(BoardsFromWorkspaceLoaded(boards));
    } catch (e) {
      emit(BoardError(ExceptionMapper.toMessage(e)));
    }
  }
}
