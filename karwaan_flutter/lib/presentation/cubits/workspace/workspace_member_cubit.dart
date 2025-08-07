import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
      emit(MemberErrorState(
          'Failed to add member to workspace: ${e.toString()}'));
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
      emit(MemberErrorState(
          'Failed to delete member from workspace : ${e.toString()}'));
    }
  }

  // leave workspace
  Future<void> leaveWorkspace(int workspaceId) async {
    emit(MemberLoadingState());
    try {
      await workspaceRepo.leaveWorkspace(workspaceId);
      emit(MemberLeavedSuccessfully(workspaceId));
    } catch (e) {
      final isLastOwner = e.toString().contains('last owner');
      emit(LastOwnerError(
          "Workspace owners can't leave the workspace!!", isLastOwner));
    }
  }

  // get workspae members
  Future<void> getWorkspaceMembers(int workspaceId) async {
    emit(MemberLoadingState());
    try {
      final members = await workspaceRepo.getWorkspaceMembers(workspaceId);
      emit(MemberLoadedState(members));
    } catch (e) {
      emit(MemberErrorState('Failed to load members : ${e.toString()}'));
    }
  }

  // change member role
  Future<void> changeMemberRole(WorkspaceChangeRoleMemberModel update) async {
    emit(MemberRoleChanging(update.targetUserId));
    debugPrint('Starting change member role from cubit.');

    try {
       await workspaceRepo.changeMemberRole(update);
      emit(MemberRoleChanged(
        targetUserId: update.targetUserId,
        newRole: update.newRole
      ));
      debugPrint('Changed member role for the ${update.newRole} from cubit');
      // Optionally refresh members list
      await getWorkspaceMembers(update.workspaceId);
      debugPrint('Refreshed member list after member role changes from cubit');
    } catch (e) {
      emit(MemberRoleChangeError(
        e.toString(),
        update.targetUserId,
      ));
    }
  }
}
