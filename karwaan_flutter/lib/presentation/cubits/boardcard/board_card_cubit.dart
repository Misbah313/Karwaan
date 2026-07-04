import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:karwaan_flutter/data/mappers/auth/error/exception_mapper.dart';
import 'package:karwaan_flutter/domain/models/boardcard/board_card.dart';
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

  Future<void> createCardOptimized(
      CreateBoardCardCredentails credentails) async {
    try {
      final card = await boardcardRepo.createBoardCard(credentails);

      final updatedCard = card.copyWith(
          assignedUserIds: credentails.assignedUserIds,
          assignedLabelIds: credentails.assignedLabelIds);

      if (state is BoardCardListLoaded) {
        final currentState = state as BoardCardListLoaded;
        final updated = List<BoardCard>.from(currentState.boardCard)
          ..add(updatedCard);

        emit(BoardCardListLoaded(updated));
      } else {
        await getListByBoardCard(credentails.id);
      }

      overallAnalyticsCubit?.getOverallAnalytics();
    } catch (e) {
      emit(BoardCardError(ExceptionMapper.toMessage(e)));
    }
  }

  Future<void> updateBoardCardOptimized(
      BoardCardCredentails credentails, int boardlistId) async {
    try {
      await boardcardRepo.updateBoardCard(credentails);

      if (state is BoardCardListLoaded) {
        final currentState = state as BoardCardListLoaded;
        final updatedCards = currentState.boardCard.map((cards) {
          if (cards.id == credentails.cardId) {
            return cards.copyWith(
                isCompleted: credentails.isCompleted,
                description: credentails.newDec,
                title: credentails.newTitle);
          }

          return cards;
        }).toList();
        emit(BoardCardListLoaded(updatedCards));
      } else {
        await getListByBoardCard(boardlistId);
      }
    } catch (e) {
      emit(BoardCardError(ExceptionMapper.toMessage(e)));
    }
  }

  Future<void> deleteBoardCardOptimized(int cardId) async {
    try {
      await boardcardRepo.deleteBoardCard(cardId);

      if (state is BoardCardListLoaded) {
        final current = state as BoardCardListLoaded;
        final updated = current.boardCard.where((c) => c.id != cardId).toList();
        emit(BoardCardListLoaded(updated));
      }

      overallAnalyticsCubit?.getOverallAnalytics();
    } catch (e) {
      emit(BoardCardError(ExceptionMapper.toMessage(e)));
    }
  }

  // Future<void> assignUsersToCard(int cardId, List<int> userIds) async {
  //   try {
  //     await boardcardRepo.assignUsersToCard(cardId, userIds);

  //     if (state is BoardCardListLoaded) {
  //       final current = state as BoardCardListLoaded;

  //       final updatedCards = current.boardCard.map((card) {
  //         if (card.id == cardId) {
  //           final existing = card.assignedUserIds ?? [];

  //           final updatedIds = {...existing, ...userIds}.toList();
  //           return card.copyWith(assignedUserIds: updatedIds);
  //         }
  //         return card;
  //       }).toList();

  //       emit(BoardCardListLoaded(updatedCards));
  //     }
  //   } catch (e) {
  //     emit(BoardCardError(ExceptionMapper.toMessage(e)));
  //   }
  // }

  // Future<void> removeUsersFromCard(int cardId, List<int> userIds) async {
  //   try {
  //     emit(BoardCardLoading());
  //     await boardcardRepo.removeUsersFromCard(cardId, userIds);

  //     // Refresh the current card list
  //     if (state is BoardCardListLoaded) {
  //       final currentState = state as BoardCardListLoaded;
  //       if (currentState.boardCard.isNotEmpty) {
  //         await getListByBoardCard(currentState.boardCard.first.boardListId);
  //       }
  //     }
  //   } catch (e) {
  //     emit(BoardCardError(ExceptionMapper.toMessage(e)));
  //   }
  // }

  Future<void> removeUserFromCardOptimized(
      int cardId, List<int> usersIds) async {
    try {
      await boardcardRepo.removeUsersFromCard(cardId, usersIds);

      if (state is BoardCardListLoaded) {
        final current = state as BoardCardListLoaded;
        final updated = current.boardCard.map((card) {
          if (card.id == cardId) {
            final existing = card.assignedUserIds ?? [];

            final updatedIds =
                existing.where((id) => !usersIds.contains(id)).toList();
            return card.copyWith(assignedUserIds: updatedIds);
          }
          return card;
        }).toList();
        emit(BoardCardListLoaded(updated));
      }
    } catch (e) {
      emit(BoardCardError(ExceptionMapper.toMessage(e)));
    }
  }

  // Future<void> getCardAssignees(int cardId) async {
  //   try {
  //     emit(BoardCardLoading());
  //     final assignees = await boardcardRepo.getCardAssignees(cardId);
  //     emit(BoardCardAssigneesLoaded(assignees));
  //   } catch (e) {
  //     emit(BoardCardError(ExceptionMapper.toMessage(e)));
  //   }
  // }

  // Future<void> getMyAssignedCards() async {
  //   try {
  //     emit(BoardCardLoading());
  //     final cards = await boardcardRepo.getMyAssignedCards();
  //     emit(BoardCardListLoaded(cards));
  //   } catch (e) {
  //     emit(BoardCardError(ExceptionMapper.toMessage(e)));
  //   }
  // }
}
