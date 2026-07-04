import 'package:karwaan_flutter/domain/models/auth/auth_user.dart';
import 'package:karwaan_flutter/domain/models/boardcard/board_card.dart';
import 'package:karwaan_flutter/domain/models/boardcard/board_card_assignment.dart';

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

// card assignement
class BoardCardAssignmentsLoading extends BoardCardState {}

class BoardCardAssignmentsLoaded extends BoardCardState {
  final List<BoardCardAssignment> assignments;
  BoardCardAssignmentsLoaded(this.assignments);
}

class BoardCardAssigneesLoaded extends BoardCardState {
  final List<AuthUser> assigness;
  BoardCardAssigneesLoaded(this.assigness);
}
