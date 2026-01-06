import 'package:karwaan_flutter/domain/models/board/board_member.dart';
import 'package:karwaan_flutter/domain/models/board/board_member_details.dart';

abstract class BoardMemberState {}

class BoardMemberInitial extends BoardMemberState {}

class BoardMemberLoading extends BoardMemberState {}

class BoardMemberLoaded extends BoardMemberState {
  final List<BoardMemberDetails> members;

  BoardMemberLoaded(this.members);
}

class BoardAddMemberSuccess extends BoardMemberState {
  final BoardMember member;

  BoardAddMemberSuccess(this.member);
}

class BoardDeleteMemberSuccess extends BoardMemberState {
  final int userId;

  BoardDeleteMemberSuccess(this.userId);
}

class BoardMemberNotLoaded extends BoardMemberState {}

class BoardMemberError extends BoardMemberState {
  final String error;

  BoardMemberError(this.error);
}

class BoardMemberLeavedSuccessfully extends BoardMemberState {
  final int boardId;

  BoardMemberLeavedSuccessfully(this.boardId);
}

class BoardLastOwner extends BoardMemberState {
  final String error;
  final bool isLastOwner;

  BoardLastOwner(this.error, this.isLastOwner);
}

class BoardMemberRoleChanging extends BoardMemberState {
  final List<BoardMemberDetails> currentMembers;
  final int targetUserId;

  BoardMemberRoleChanging(this.targetUserId, this.currentMembers);
}

class BoardMemberRoleChanged extends BoardMemberState {
  final int targetUserId;
  final String newRole;

  BoardMemberRoleChanged(this.targetUserId, this.newRole);
}

class BoardMemberRoleChangingError extends BoardMemberState {
  final int userToChangeRoleId;
  final String error;

  BoardMemberRoleChangingError(this.error, this.userToChangeRoleId);
}

// state for optimized methods

class BoardMemberRemoving extends BoardMemberState {
  final List<BoardMemberDetails> currentMembers;
  final int userId;
  BoardMemberRemoving(this.currentMembers, this.userId);
}

class BoardMemberAdding extends BoardMemberState {
  final List<BoardMemberDetails> currentMembers;
  BoardMemberAdding(this.currentMembers);
}

// success state for optimized states
class BoardMemberRoleChangedSuccessfully extends BoardMemberState {
  final List<BoardMemberDetails> updatedMembers;
  BoardMemberRoleChangedSuccessfully(this.updatedMembers);
}

class BoardMemberAddedSuccessfully extends BoardMemberState {
  final List<BoardMemberDetails> updatedMembers;
  BoardMemberAddedSuccessfully(this.updatedMembers);
}

class BoardMemberRemovedSuccessfully extends BoardMemberState {
  final List<BoardMemberDetails> updatedMembers;
  BoardMemberRemovedSuccessfully(this.updatedMembers);
}
