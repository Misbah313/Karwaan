import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:karwaan_flutter/data/mappers/auth/error/exception_mapper.dart';
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
  Future<void> getBoardMembers(int boardId) async {
    emit(BoardMemberLoading());
    try {
      final members = await boardRepo.getBoardMembers(boardId);
      emit(BoardMemberLoaded(members));
    } catch (e) {
      emit(BoardMemberError(ExceptionMapper.toMessage(e)));
    }
  }

  // change member role
  Future<void> changeBoardMemberRole(BoardMemberChangeRoleModel change) async {
    emit(BoardMemberRoleChanging(change.targetUserId));
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
    } catch(e) {
      emit(BoardMemberError(ExceptionMapper.toMessage(e)));
    }
  }
}
