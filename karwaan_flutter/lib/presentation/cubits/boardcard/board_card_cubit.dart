import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:karwaan_flutter/data/mappers/auth/error/exception_mapper.dart';
import 'package:karwaan_flutter/domain/models/boardcard/board_card_credentails.dart';
import 'package:karwaan_flutter/domain/models/boardcard/board_card_state.dart';
import 'package:karwaan_flutter/domain/models/boardcard/create_board_card_credentails.dart';
import 'package:karwaan_flutter/domain/repository/boardcard/boardcard_repo.dart';
import 'package:karwaan_flutter/presentation/cubits/board/overall_analytic_cubit.dart';

class BoardCardCubit extends Cubit<BoardCardState> {
  final BoardcardRepo boardcardRepo;
  final OverallAnalyticsCubit? overallAnalyticsCubit;

  BoardCardCubit(this.boardcardRepo, [this.overallAnalyticsCubit])
      : super(BoardCardInitial());

  // create board card
  Future<void> createBoardCard(CreateBoardCardCredentails credentails) async {
    emit(BoardCardLoading());
    try {
      final card = await boardcardRepo.createBoardCard(credentails);
      emit(BoardCardCreated(card));
      overallAnalyticsCubit?.getOverallAnalytics();
    } catch (e) {
      emit(BoardCardError(ExceptionMapper.toMessage(e)));
    }
  }

  // get list by boardcard
  Future<void> getListByBoardCard(int boardlistId) async {
    emit(BoardCardLoading());
    try {
      final boardcard = await boardcardRepo.getListByBoardCard(boardlistId);
      emit(BoardCardListLoaded(boardcard));
    } catch (e) {
      emit(BoardCardError(ExceptionMapper.toMessage(e)));
    }
  }

  // get all user cards
  Future<void> getAllUserCards() async {
    emit(BoardCardLoading());
    try {
      final cards = await boardcardRepo.getAllUserCards();
      emit(BoardCardListLoaded(cards));
    } catch (e) {
      emit(BoardCardError(ExceptionMapper.toMessage(e)));
    }
  }

  // update board card
  Future<void> updateBoardCard(BoardCardCredentails credentails) async {
    emit(BoardCardLoading());
    try {
      final updated = await boardcardRepo.updateBoardCard(credentails);
      emit(BoardCardUpdated(updated));
      overallAnalyticsCubit?.getOverallAnalytics();
    } catch (e) {
      emit(BoardCardError(ExceptionMapper.toMessage(e)));
    }
  }

  // delete board card
  Future<void> deleteBoardCard(int cardId) async {
    emit(BoardCardLoading());
    try {
      await boardcardRepo.deleteBoardCard(cardId);
      emit(BoardCardDeleted(cardId));
      overallAnalyticsCubit?.getOverallAnalytics();
    } catch (e) {
      emit(BoardCardError(ExceptionMapper.toMessage(e)));
    }
  }
}
