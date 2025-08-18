import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:karwaan_flutter/domain/models/cardlabel/cardlabel_credentails.dart';
import 'package:karwaan_flutter/domain/models/cardlabel/cardlabel_state.dart';
import 'package:karwaan_flutter/domain/repository/cardlabel/cardlabel_repo.dart';

class CardlabelCubit extends Cubit<CardlabelState> {
  final CardlabelRepo cardlabelRepo;

  CardlabelCubit(this.cardlabelRepo) : super(CardLabelInitial());

  // assign label to card
  Future<void> assignLabelToCard(CardlabelCredentails credentails) async {
    emit(CardLabelLoading());
    try {
      final assigned = await cardlabelRepo.assignLabelToCard(credentails);
      emit(CardLabelAssigned(assigned.cardId, assigned.labelId));
      getLabelForCard(credentails.cardId);
    } catch (e) {
      emit(CardLabelError('Assign failed from cubit: ${e.toString()}'));
    }
  }

  // remove label from card
  Future<void> removeLabelFromCard(CardlabelCredentails credentails) async {
    emit(CardLabelInitial());
    try {
      await cardlabelRepo.removeLabelFromCard(credentails);
      emit(CardLabelRemoved(credentails.cardId, credentails.labelId));
    } catch (e) {
      emit(CardLabelError('Failed to remove card from cubit: ${e.toString()}'));
    }
  }

  // get label for card
  Future<void> getLabelForCard(int cardId) async {
    emit(CardLabelLoading());
    try {
      final labels = await cardlabelRepo.getLabelsforCard(cardId);
      emit(CardLabelForCardListLoaded(labels));
    } catch (e) {
      emit(CardLabelError(
          'Getting label for card failed from cubit: ${e.toString()}'));
    }
  }

  // get card for label (will be used in the ui later...)
  Future<void> getCardForLabel(int labelId) async {
    emit(CardLabelLoading());
    try {
      final card = await cardlabelRepo.getCardsForLabel(labelId);
      emit(CardLabelForLabelLoaded(card));
    } catch (e) {
      emit(CardLabelError(
          'Getting card for label failed from cubit: ${e.toString()}'));
    }
  }
}
