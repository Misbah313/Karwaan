import 'package:karwaan_flutter/domain/models/boardcard/board_card.dart';

abstract class BoardCardState {}

class BoardCardInitial extends BoardCardState {}

class BoardCardLoading extends BoardCardState {}

class BoardCardListLoaded extends BoardCardState {
  final List<BoardCard> boardCard;

  BoardCardListLoaded(this.boardCard);
}

class BoardCardUpdated extends BoardCardState {
  final BoardCard card;

  BoardCardUpdated(this.card);
}

class BoardCardCreated extends BoardCardState {
  final BoardCard card;

  BoardCardCreated(this.card);
}

class BoardCardDeleted extends BoardCardState {
  final int boardCardId;

  BoardCardDeleted(this.boardCardId);
}

class BoardCardError extends BoardCardState {
  final String error;

  BoardCardError(this.error);
}
