import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:karwaan_flutter/data/mappers/auth/error/exception_mapper.dart';
import 'package:karwaan_flutter/domain/models/workspace/create_workspace_credentials.dart';
import 'package:karwaan_flutter/domain/models/workspace/workspace_credentials.dart';
import 'package:karwaan_flutter/domain/models/workspace/workspace_state.dart';
import 'package:karwaan_flutter/domain/repository/workspace/workspace_repo.dart';

class WorkspaceCubit extends Cubit<WorkspaceState> {
  final WorkspaceRepo workspaceRepo;

  WorkspaceCubit(this.workspaceRepo) : super(WorkspaceInitial());

  // create workspace
  Future<void> createWorkspace(
      CreateWorkspaceCredentials workspaceCredential) async {
    emit(WorkspaceLoading());
    try {
      final workspace =
          await workspaceRepo.createWorkspace(workspaceCredential);
      emit(WorkspaceCreated(workspace.workspaceName));
    } catch (e) {
      emit(WorkspaceError(ExceptionMapper.toMessage(e)));
    }
  }

  // get user workspace
  Future<void> getUserWorkspace() async {
    emit(WorkspaceLoading());
    try {
      final workspace = await workspaceRepo.getUserWorkspace();
      emit(WorkspaceListLoaded(workspace));
    } catch (e) {
      emit(WorkspaceError(ExceptionMapper.toMessage(e)));
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
      emit(WorkspaceError(ExceptionMapper.toMessage(e)));
    }
  }

  // only update the specific workspace
  Future<void> updateWorkspaceOptimized(
      WorkspaceCredential workspaceCredential) async {
    try {
      await workspaceRepo.updateWorkspace(workspaceCredential);

      // if workspace already loaded, update just the one that changed
      if (state is WorkspaceListLoaded) {
        final currentState = state as WorkspaceListLoaded;
        final updatedWorkspace = currentState.workspaces.map((workspace) {
          if (workspace.id == workspaceCredential.id) {
            return workspace.copyWith(
                workspaceName: workspaceCredential.workspaceName,
                workspaceDescription: workspaceCredential.workspaceDescription,
                backgroundColor: workspaceCredential.backgroundColor);
          }
          return workspace;
        }).toList();
        emit(WorkspaceListLoaded(updatedWorkspace));
      } else {
        await getUserWorkspace();
      }
    } catch (e) {
      emit(WorkspaceError(ExceptionMapper.toMessage(e)));
    }
  }

  // Delete workspace without reloading entire list
  Future<void> deleteWorkspaceOptimized(int workspaceId) async {
    try {
      await workspaceRepo.deleteWorkspace(workspaceId);

      // If workspace already loaded, remove just the deleted one
      if (state is WorkspaceListLoaded) {
        final currentState = state as WorkspaceListLoaded;
        final updatedWorkspaces = currentState.workspaces
            .where((workspace) => workspace.id != workspaceId)
            .toList();

        emit(WorkspaceListLoaded(updatedWorkspaces));
      } else {
        await getUserWorkspace();
      }
    } catch (e) {
      emit(WorkspaceError(ExceptionMapper.toMessage(e)));
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
      emit(WorkspaceError(ExceptionMapper.toMessage(e)));
    }
  }
}
