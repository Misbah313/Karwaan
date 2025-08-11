import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
      emit(BoardError('Failed from cubit: ${e.toString()}'));
    }
  }

  Future<void> getUserBoards() async {
    emit(BoardLoading());
    try {
      final boards = await boardRepo.getUserBoards();
      emit(BoardlistLoaded(boards));
    } catch (e) {
      emit(BoardError('Failed from cubit: ${e.toString()}'));
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
      emit(BoardError('Failed from cubit: ${e.toString()}'));
    }
  }

  Future<void> deleteBoard(int boardId) async {
    emit(BoardLoading());
    try {
      await boardRepo.deleteBoard(boardId);
      emit(DeletedSuccessfully(boardId));
    } catch (e) {
      emit(BoardError('Failed from cubit : ${e.toString()}'));
    }
  }

  Future<void> getBoardsByWorkspace(int workspaceId) async {
    emit(BoardLoading());
    debugPrint('Starting getting boards from the cubit/1');
    try {
      final boards = await boardRepo.getBoardsByWorkspace(workspaceId);
      debugPrint('Board fetced from cubit.2');
      emit(BoardsFromWorkspaceLoaded(boards));
    } catch (e) {
      emit(BoardError('Failed from cubit : ${e.toString()}'));
    }
  }
}
