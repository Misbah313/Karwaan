import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:karwaan_flutter/data/mappers/auth/error/exception_mapper.dart';
import 'package:karwaan_flutter/domain/models/board/board_member_change_role_model.dart';
import 'package:karwaan_flutter/domain/models/board/board_member_credentails.dart';
import 'package:karwaan_flutter/domain/models/board/board_member_details.dart';
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
      emit(BoardMemberError(ExceptionMapper.toMessage(e)));
    }
  }

  // remove member
  Future<void> removeMemberFromBoard(BoardMemberCredentails credentails) async {
    emit(BoardMemberLoading());
    try {
      await boardRepo.removeMemberFromBoard(credentails);
      emit(BoardDeleteMemberSuccess(credentails.userId));
    } catch (e) {
      emit(BoardMemberError(ExceptionMapper.toMessage(e)));
    }
  }

  // get board members
  Future<List<BoardMemberDetails>> getBoardMembers(int boardId) async {
    emit(BoardMemberLoading());
    try {
      final members = await boardRepo.getBoardMembers(boardId);
      emit(BoardMemberLoaded(members));
      return members;
    } catch (e) {
      emit(BoardMemberError(ExceptionMapper.toMessage(e)));
      rethrow;
    }
  }

  // change member role
  Future<void> changeBoardMemberRole(BoardMemberChangeRoleModel change) async {
    emit(BoardMemberRoleChanging(change.targetUserId, []));
    try {
      await boardRepo.changeBoardMemberRole(change);
      emit(BoardMemberRoleChanged(change.targetUserId, change.newRole));
    } catch (e) {
      emit(BoardMemberError(ExceptionMapper.toMessage(e)));
    }
  }

  // leave board
  Future<void> leaveBoard(int boardId) async {
    emit(BoardMemberLoading());
    try {
      await boardRepo.leaveBoard(boardId);
      emit(BoardMemberLeavedSuccessfully(boardId));
    } catch (e) {
      emit(BoardMemberError(ExceptionMapper.toMessage(e)));
    }
  }

  // optimized change role
  Future<void> changeRoleOptimized(BoardMemberChangeRoleModel change) async {
    try {
      if (state is BoardMemberLoaded) {
        final currentState = state as BoardMemberLoaded;
        emit(
            BoardMemberRoleChanging(change.targetUserId, currentState.members));
      }

      await boardRepo.changeBoardMemberRole(change);

      if (state is BoardMemberRoleChanging) {
        final currentState = state as BoardMemberRoleChanging;
        final updatedMembers = currentState.currentMembers.map((member) {
          if (member.userId == change.targetUserId) {
            return BoardMemberDetails(
                userId: member.userId,
                userName: member.userName,
                userEmail: member.userEmail,
                userRole: change.newRole,
                joinedAt: member.joinedAt);
          }
          return member;
        }).toList();
        emit(BoardMemberRoleChangedSuccessfully(updatedMembers));
      } else {
        await getBoardMembers(change.boardId);
      }
    } catch (e) {
      emit(BoardMemberError(ExceptionMapper.toMessage(e)));
    }
  }

  // optimized add member
  Future<void> addMemberOptimized(BoardMemberCredentails credentails) async {
    try {
      if (state is BoardMemberLoaded) {
        final currentState = state as BoardMemberLoaded;
        emit(BoardMemberAdding(currentState.members));
      }

      await boardRepo.addMemberToBoard(credentails);

      if (state is BoardMemberAdding) {
        state as BoardMemberAdding;

        final updatedMembers =
            await boardRepo.getBoardMembers(credentails.boardId);
        emit(BoardMemberAddedSuccessfully(updatedMembers));
      } else {
        await getBoardMembers(credentails.boardId);
      }
    } catch (e) {
      emit(BoardMemberError(ExceptionMapper.toMessage(e)));
    }
  }

  // optimized remove member
  Future<void> removeMemberOptimized(BoardMemberCredentails credentails) async {
    try {
      if (state is BoardMemberLoaded) {
        final currentState = state as BoardMemberLoaded;
        emit(BoardMemberRemoving(currentState.members, credentails.userId));
      }

      await boardRepo.removeMemberFromBoard(credentails);

      if (state is BoardMemberRemoving) {
        final currentState = state as BoardMemberRemoving;
        final updatedMembers = currentState.currentMembers
            .where((member) => member.userId != credentails.userId)
            .toList();
        emit(BoardMemberRemovedSuccessfully(updatedMembers));
      } else {
        await getBoardMembers(credentails.boardId);
      }
    } catch (e) {
      emit(BoardMemberError(ExceptionMapper.toMessage(e)));
    }
  }
}
