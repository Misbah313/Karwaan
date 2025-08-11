import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:karwaan_flutter/domain/models/board/board_member_change_role_model.dart';
import 'package:karwaan_flutter/domain/models/board/board_member_credentails.dart';
import 'package:karwaan_flutter/domain/models/board/board_member_state.dart';
import 'package:karwaan_flutter/domain/repository/board/board_repo.dart';

class BoardMemberCubit extends Cubit<BoardMemberState> {
  final BoardRepo boardRepo;

  BoardMemberCubit(this.boardRepo) : super(BoardMemberInitial());

  // add member
  Future<void> addMemberToBoard(BoardMemberCredentails credentails) async {
    emit(BoardMemberLoading());
    try {
      final member = await boardRepo.addMemberToBoard(credentails);
      emit(BoardAddMemberSuccess(member));
    } catch (e) {
      emit(BoardMemberError(
          'Failed to add board member from cubit: ${e.toString()}'));
    }
  }

  // remove member
  Future<void> removeMemberFromBoard(BoardMemberCredentails credentails) async {
    emit(BoardMemberLoading());
    try {
      await boardRepo.removeMemberFromBoard(credentails);
      emit(BoardDeleteMemberSuccess(credentails.userId));
    } catch (e) {
      emit(BoardMemberError(
          'Failed to remove member from board from cubit: ${e.toString()}'));
    }
  }

  // get board members
  Future<void> getBoardMembers(int boardId) async {
    emit(BoardMemberLoading());
    try {
      final members = await boardRepo.getBoardMembers(boardId);
      emit(BoardMemberLoaded(members));
    } catch (e) {
      emit(BoardMemberError(
          'Failed to load board members form cubit: ${e.toString()}'));
    }
  }

  // change member role
  Future<void> changeBoardMemberRole(BoardMemberChangeRoleModel change) async {
    emit(BoardMemberRoleChanging(change.targetUserId));
    try {
      await boardRepo.changeBoardMemberRole(change);
      emit(BoardMemberRoleChanged(change.targetUserId, change.newRole));
    } catch (e) {
      emit(BoardMemberRoleChangingError(e.toString(), change.targetUserId));
    }
  }

  // leave board
  Future<void> leaveBoard(int boardId) async {
    emit(BoardMemberLoading());
    try {
      await boardRepo.leaveBoard(boardId);
      emit(BoardMemberLeavedSuccessfully(boardId));
    } catch(e) {
      final isLastOwner = e.toString().contains('last owner');
      emit(BoardLastOwner("Board owners can't leave boards", isLastOwner));
    }
  }
}
