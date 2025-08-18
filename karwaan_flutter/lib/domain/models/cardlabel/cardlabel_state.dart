import 'package:karwaan_flutter/domain/models/cardlabel/cardlabel.dart';
import 'package:karwaan_flutter/domain/models/label/label.dart';

abstract class CardlabelState {}

class CardLabelLoading extends CardlabelState {}

class CardLabelInitial extends CardlabelState {}

class CardLabelForCardListLoaded extends CardlabelState {
  final List<Label> labels;

  CardLabelForCardListLoaded(this.labels);
}

class CardLabelForLabelLoaded extends CardlabelState {
  final List<Cardlabel> cardLabels;

  CardLabelForLabelLoaded(this.cardLabels);
}

class CardLabelRemoved extends CardlabelState {
  final int cardId;
  final int labelId;

  CardLabelRemoved(this.cardId, this.labelId);
}

class CardLabelAssigned extends CardlabelState {
  final int cardId;
  final int labelId;

  CardLabelAssigned(this.cardId, this.labelId);
}

class CardLabelError extends CardlabelState {
  final String error;

  CardLabelError(this.error);
}
