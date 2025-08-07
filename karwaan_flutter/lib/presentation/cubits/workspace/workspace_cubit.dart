import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:karwaan_flutter/domain/models/workspace/create_workspace_credentials.dart';
import 'package:karwaan_flutter/domain/models/workspace/workspace_credentials.dart';
import 'package:karwaan_flutter/domain/models/workspace/workspace_state.dart';
import 'package:karwaan_flutter/domain/repository/workspace/workspace_repo.dart';

class WorkspaceCubit extends Cubit<WorkspaceState> {
  final WorkspaceRepo workspaceRepo;

  WorkspaceCubit(this.workspaceRepo) : super(WorkspaceInitial());

  // create workspace
  Future<void> createWorkspace(CreateWorkspaceCredentials workspaceCredential) async {
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

  // get user workspace
  Future<void> getUserWorkspace() async {
    emit(WorkspaceLoading());
    try {
      final workspace = await workspaceRepo.getUserWorkspace();
      emit(WorkspaceListLoaded(workspace));
    } catch (e) {
      emit(WorkspaceError(
          'Failed to get the list of workspace: ${e.toString()}'));
    }
  }

  // update workspace
  Future<void> updateWorkspace(WorkspaceCredential workspaceCredential) async {
    emit(WorkspaceLoading());
    try {
      await workspaceRepo.updateWorkspace(workspaceCredential);
      final workspaces = await workspaceRepo.getUserWorkspace();
      emit(WorkspaceListLoaded(workspaces));
    } catch (e) {
      emit(WorkspaceError('Failed to update workspace: ${e.toString()}'));
    }
  }

  // delete workspace
  Future<void> deleteWorkspace(int workspaceId) async {
    emit(WorkspaceLoading());
    try {
      await workspaceRepo.deleteWorkspace(workspaceId);
      final workspaces = await workspaceRepo.getUserWorkspace();
      emit(WorkspaceListLoaded(workspaces));
    } catch (e) {
      emit(WorkspaceError('Failed to delete workspace: ${e.toString()}'));
    }
  }

 
}
