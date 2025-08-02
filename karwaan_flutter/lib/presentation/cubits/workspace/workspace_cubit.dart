import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:karwaan_flutter/domain/models/workspace/workspace_credentials.dart';
import 'package:karwaan_flutter/domain/models/workspace/workspace_member_credentials.dart';
import 'package:karwaan_flutter/domain/models/workspace/workspace_state.dart';
import 'package:karwaan_flutter/domain/repository/workspace/workspace_repo.dart';
import 'package:karwaan_flutter/presentation/cubits/workspace/workspace_member_state.dart';

class WorkspaceCubit extends Cubit {
  final WorkspaceRepo workspaceRepo;

  WorkspaceCubit(this.workspaceRepo) : super(WorkspaceInitial());

  // create workspace
  Future<void> createWorkspace(WorkspaceCredential workspaceCredential) async {
    emit(WorkspaceLoading());
    try {
      final workspace =
          await workspaceRepo.createWorkspace(workspaceCredential);
      emit(SuccessAction(
          workspace.workspaceName, workspace.workspaceDescription));
    } catch (e) {
      emit(WorkspaceError('Creating workspace error: ${e.toString()}'));
    }
  }

  /* get user workspace
  Future<void> getUserWorkspace() async{
    emit(WorkspaceLoading());
    try{
      final workspace = await workspaceRepo.getUserWorkspace();
      emit(WorkspaceLoaded([workspace]))
    }
  }
  */

  // update workspace
  Future<void> updateWorkspace(WorkspaceCredential workspaceCredential) async {
    emit(WorkspaceLoading());
    try {
      await workspaceRepo.updateWorkspace(workspaceCredential.id);
      emit(SuccessAction(workspaceCredential.workspaceName,
          workspaceCredential.workspaceDescription));
    } catch (e) {
      emit(WorkspaceError('Failed to update workspace: ${e.toString()}'));
    }
  }

  // delete workspace
  Future<void> deleteWorkspace(int workspaceId) async {
    emit(WorkspaceLoading());
    try {
      await workspaceRepo.deleteWorkspace(workspaceId);
      emit(DeletedSuccessfully(workspaceId));
    } catch (e) {
      emit(WorkspaceError('Failed to delete workspace: ${e.toString()}'));
    }
  }

  // add member to workspace
  Future<void> addMemberToWorkspace(
      WorkspaceMemberCredential workspaceMemberCredential) async {
    emit(MemberLoadingState());
    try {
      await workspaceRepo.addMemberToWorkspace(workspaceMemberCredential);
      emit(MemberSuccessState(workspaceMemberCredential.userId,
          workspaceMemberCredential.workspaceId));
    } catch (e) {
      emit(
          MemberErroState('Failed to add member to workspace: ${e.toString()}'));
    }
  }

  // remove member from workspace
  Future<void> removeMemberFromWorkspace(WorkspaceMemberCredential workspaceMemberCredential) async{
    emit(WorkspaceLoading());
    try{
      await workspaceRepo.removeMemberFromWorkspace(workspaceMemberCredential);
      emit(MemberDeletionSuccess(workspaceMemberCredential.userId));
    } catch(e) {
      emit(MemberErroState('Failed to delete member from workspace : ${e.toString()}'));
    }
  }

  // leave workspace
  Future<void> leaveWorkspace(int workspaceId) async{
    emit(WorkspaceLoading());
    try{
      await workspaceRepo.leaveWorkspace(workspaceId);
      emit(MemberLeavedSuccessfully(workspaceId));
    } catch(e) {
      emit(MemberErroState('Failed to leave workspace: ${e.toString()}'));
    }
  }
}
