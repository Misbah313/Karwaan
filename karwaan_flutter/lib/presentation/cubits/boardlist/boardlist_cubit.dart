import 'package:flutter_bloc/flutter_bloc.dart';
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
      emit(BoardlistError('Failed from cubit: ${e.toString()}'));
    }
  }

  Future<void> listBoardLists(int boardId) async {
    emit(BoardlistLoading());
    try {
      final list = await boardlistRepo.listBoardLists(boardId);
      emit(BoardlistLoaded(list));
    } catch (e) {
      emit(BoardlistError('Failed from cubit: ${e.toString()}'));
    }
  }

  Future<void> updateBoardList(BoardlistCredentails credentails) async {
    emit(BoardlistLoading());
    try {
      await boardlistRepo.updateBoardList(credentails);
      emit(BoardlistUpdated());
    } catch (e) {
      emit(BoardlistError('Failed from cubit: ${e.toString()}'));
    }
  }

  Future<void> deleteBoardList(int boardlistId) async {
    emit(BoardlistLoading());
    try {
      await boardlistRepo.deleteBoardList(boardlistId);
      emit(BoardlistDeleted(boardlistId));
    } catch (e) {
      emit(BoardlistError('Failed from cubit: ${e.toString()}'));
    }
  }
}
