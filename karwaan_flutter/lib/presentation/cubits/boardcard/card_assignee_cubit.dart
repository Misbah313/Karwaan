import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:karwaan_flutter/data/mappers/auth/error/exception_mapper.dart';
import 'package:karwaan_flutter/domain/models/boardcard/card_assignee_state.dart';
import 'package:karwaan_flutter/domain/repository/boardcard/boardcard_repo.dart';
import 'package:karwaan_flutter/presentation/cubits/boardcard/board_card_cubit.dart';


class CardAssigneeCubit extends Cubit<CardAssigneeState> {
  final BoardcardRepo boardcardRepo;
  final BoardCardCubit boardCardCubit;

  CardAssigneeCubit(this.boardcardRepo, this.boardCardCubit)
      : super(CardAssigneeInitial());

  Future<void> getCardAssignees(int cardId) async {
    try {
      emit(CardAssigneeLoading());
      final assignees = await boardcardRepo.getCardAssignees(cardId);
      emit(CardAssigneeLoaded(assignees));
    } catch (e) {
      emit(CardAssigneeError(ExceptionMapper.toMessage(e)));
    }
  }

  Future<void> assignUsers(int cardId, List<int> userIds) async {
    try {
      await boardcardRepo.assignUsersToCard(cardId, userIds);

      if (state is CardAssigneeLoaded) {
        final current = state as CardAssigneeLoaded;

        // NOTE: you may need to fetch full user objects depending on your backend
        // For now assume they already exist in UI

        emit(CardAssigneeLoaded([...current.assignees]));
      }
    } catch (e) {
      emit(CardAssigneeError(ExceptionMapper.toMessage(e)));
    }
  }

  Future<void> removeUsers(int cardId, List<int> userIds) async {
    try {
      await boardcardRepo.removeUsersFromCard(cardId, userIds);

      if (state is CardAssigneeLoaded) {
        final current = state as CardAssigneeLoaded;

        final updated = current.assignees
            .where((user) => !userIds.contains(user.id))
            .toList();

        emit(CardAssigneeLoaded(updated));
      }
      boardCardCubit.removeUserFromCardOptimized(cardId, userIds);
    } catch (e) {
      emit(CardAssigneeError(ExceptionMapper.toMessage(e)));
    }
  }
}