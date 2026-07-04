import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:karwaan_flutter/data/mappers/auth/error/exception_mapper.dart';
import 'package:karwaan_flutter/domain/models/boardlist/boardlist_credentails.dart';
import 'package:karwaan_flutter/domain/models/boardlist/boardlist_state.dart';
import 'package:karwaan_flutter/domain/models/boardlist/create_board_list_credentails.dart';
import 'package:karwaan_flutter/domain/repository/boardlist/boardlist_repo.dart';

class BoardlistCubit extends Cubit<BoardlistState> {
  final BoardlistRepo boardlistRepo;

  BoardlistCubit(this.boardlistRepo) : super(BoardlistInitial());

  Future<void> createBoardList(CreateBoardListCredentails credentails) async {
    emit(BoardlistLoading());
    try {
      final created = await boardlistRepo.createBoardList(credentails);
      emit(BoardListCreated(created.boardlistTitle));
    } catch (e) {
      emit(BoardlistError(ExceptionMapper.toMessage(e)));
    }
  }

  Future<void> listBoardLists(int boardId) async {
    emit(BoardlistLoading());
    try {
      final list = await boardlistRepo.listBoardLists(boardId);
      emit(BoardlistLoaded(list));
    } catch (e) {
      emit(BoardlistError(ExceptionMapper.toMessage(e)));
    }
  }

  Future<void> updateBoardList(BoardlistCredentails credentails) async {
    emit(BoardlistLoading());
    try {
      await boardlistRepo.updateBoardList(credentails);
      emit(BoardlistUpdated());
    } catch (e) {
      emit(BoardlistError(ExceptionMapper.toMessage(e)));
    }
  }

  Future<void> deleteBoardList(int boardlistId) async {
    emit(BoardlistLoading());
    try {
      await boardlistRepo.deleteBoardList(boardlistId);
      emit(BoardlistDeleted(boardlistId));
    } catch (e) {
      emit(BoardlistError(ExceptionMapper.toMessage(e)));
    }
  }

  Future<void> updateBoardListOptimized(
      BoardlistCredentails credentails, int boardId) async {
    try {
      await boardlistRepo.updateBoardList(credentails);

      if (state is BoardlistLoaded) {
        final currentState = state as BoardlistLoaded;
        final updatedList = currentState.boardlist.map((lists) {
          if (lists.id == credentails.id) {
            return lists.copyWith(boardlistTitle: credentails.newTitle);
          }

          return lists;
        }).toList();
        emit(BoardlistLoaded(updatedList));
      } else {
        await listBoardLists(boardId);
      }
    } catch (e) {
      emit(BoardlistError(ExceptionMapper.toMessage(e)));
    }
  }

  Future<void> deleteBoardListOptimized(int boardlistId, int boardId) async {
    try {
      await boardlistRepo.deleteBoardList(boardlistId);

      if (state is BoardlistLoaded) {
        final currentState = state as BoardlistLoaded;
        final updatedLists = currentState.boardlist
            .where((list) => list.id != boardlistId)
            .toList();
        emit(BoardlistLoaded(updatedLists));
      } else {
        await listBoardLists(boardId);
      }
    } catch (e) {
      emit(BoardlistError(ExceptionMapper.toMessage(e)));
    }
  }
}
