import 'package:flutter_bloc/flutter_bloc.dart';
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
      emit(MemberErrorState('Failed to leave workspace: ${e.toString()}'));
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
}
