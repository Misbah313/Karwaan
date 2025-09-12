import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:karwaan_flutter/data/mappers/auth/error/exception_mapper.dart';
import 'package:karwaan_flutter/domain/models/workspace/workspace_change_role_member_model.dart';
import 'package:karwaan_flutter/domain/models/workspace/workspace_member_credentials.dart';
import 'package:karwaan_flutter/domain/repository/workspace/workspace_repo.dart';
import 'package:karwaan_flutter/presentation/cubits/workspace/workspace_member_state.dart';

class WorkspaceMemberCubit extends Cubit<WorkspaceMemberState> {
  final WorkspaceRepo workspaceRepo;

  WorkspaceMemberCubit(this.workspaceRepo) : super(MemberIntialState());

  // add member to workspace
  Future<void> addMemberToWorkspace(
      WorkspaceMemberCredential workspaceMemberCredential) async {
    emit(MemberLoadingState());
    try {
      final member =
          await workspaceRepo.addMemberToWorkspace(workspaceMemberCredential);
      emit(AddMemberSuccess(member));
    } catch (e) {
      emit(MemberErrorState(ExceptionMapper.toMessage(e)));
    }
  }

  // remove member from workspace
  Future<void> removeMemberFromWorkspace(
      WorkspaceMemberCredential workspaceMemberCredential) async {
    emit(MemberLoadingState());
    try {
      await workspaceRepo.removeMemberFromWorkspace(workspaceMemberCredential);
      emit(MemberDeletionSuccess(workspaceMemberCredential.userId));
    } catch (e) {
      emit(MemberErrorState(ExceptionMapper.toMessage(e)));
    }
  }

  // leave workspace
  Future<void> leaveWorkspace(int workspaceId) async {
    emit(MemberLoadingState());
    try {
      await workspaceRepo.leaveWorkspace(workspaceId);
      emit(MemberLeavedSuccessfully(workspaceId));
    } catch (e) {
      emit(MemberErrorState(ExceptionMapper.toMessage(e)));
    }
  }

  // get workspae members
  Future<void> getWorkspaceMembers(int workspaceId) async {
    emit(MemberLoadingState());
    try {
      final members = await workspaceRepo.getWorkspaceMembers(workspaceId);
      emit(MemberLoadedState(members));
    } catch (e) {
      emit(MemberErrorState(ExceptionMapper.toMessage(e)));
    }
  }

  // change member role
  Future<void> changeMemberRole(WorkspaceChangeRoleMemberModel update) async {
    emit(MemberRoleChanging(update.targetUserId));

    try {
       await workspaceRepo.changeMemberRole(update);
      emit(MemberRoleChanged(
        targetUserId: update.targetUserId,
        newRole: update.newRole
      ));
      await getWorkspaceMembers(update.workspaceId);
    } catch (e) {
      emit(MemberErrorState(ExceptionMapper.toMessage(e)
      ));
    }
  }
}
