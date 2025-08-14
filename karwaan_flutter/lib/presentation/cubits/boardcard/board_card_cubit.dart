import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:karwaan_flutter/domain/models/boardcard/board_card_credentails.dart';
import 'package:karwaan_flutter/domain/models/boardcard/board_card_state.dart';
import 'package:karwaan_flutter/domain/models/boardcard/create_board_card_credentails.dart';
import 'package:karwaan_flutter/domain/repository/boardcard/boardcard_repo.dart';

class BoardCardCubit extends Cubit<BoardCardState> {
  final BoardcardRepo boardcardRepo;

  BoardCardCubit(this.boardcardRepo) : super(BoardCardInitial());

  // create board card
  Future<void> createBoardCard(CreateBoardCardCredentails credentails) async {
    emit(BoardCardLoading());
    try {
      debugPrint('Starting card creation from cubit.');
      final card = await boardcardRepo.createBoardCard(credentails);
      debugPrint('Card has been created form cubit.');
      emit(BoardCardCreated(card));
    } catch (e) {
      emit(BoardCardError('Creation failed from cubit: ${e.toString()}'));
    }
  }

  // get list by boardcard
  Future<void> getListByBoardCard(int boardlistId) async {
    emit(BoardCardLoading());
    try {
      debugPrint('Starting getting the list of cards from cubit!');
      final boardcard = await boardcardRepo.getListByBoardCard(boardlistId);
      debugPrint('Cards has been loaded from cubit.');
      emit(BoardCardListLoaded(boardcard));
    } catch (e) {
      emit(BoardCardError('fetching failed from cubit: ${e.toString()}'));
    }
  }

  // update board card
  Future<void> updateBoardCard(BoardCardCredentails credentails) async {
    emit(BoardCardLoading());
    try {
      final updated = await boardcardRepo.updateBoardCard(credentails);
      emit(BoardCardUpdated(updated));
    } catch (e) {
      emit(BoardCardError('Updating failed from cubit : ${e.toString()}'));
    }
  }

  // delete board card
  Future<void> deleteBoardCard(int cardId) async {
    emit(BoardCardLoading());
    try {
      await boardcardRepo.deleteBoardCard(cardId);
      emit(BoardCardDeleted(cardId));
    } catch (e) {
      emit(BoardCardError('Deletion failed from cubit: ${e.toString()}'));
    }
  }
}
