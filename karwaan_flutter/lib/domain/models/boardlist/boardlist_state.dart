import 'package:karwaan_flutter/domain/models/boardlist/boardlist.dart';

abstract class BoardlistState {}

class BoardlistInitial extends BoardlistState {}

class BoardlistLoading extends BoardlistState {}

class BoardlistLoaded extends BoardlistState {
  final List<Boardlist> boardlist;

  BoardlistLoaded(this.boardlist);
}

class BoardlistUpdated extends BoardlistState {}

class BoardListCreated extends BoardlistState {
  final String boardTitle;

  BoardListCreated(this.boardTitle);
}

class BoardlistDeleted extends BoardlistState {
  final int boardlistId;

  BoardlistDeleted(this.boardlistId);
}

class BoardlistError extends BoardlistState {
  final String error;

  BoardlistError(this.error);
}
