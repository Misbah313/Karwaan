import 'package:karwaan_flutter/core/services/serverpod_client_service.dart';
import 'package:karwaan_flutter/domain/models/workspace/workspace.dart';
import 'package:karwaan_flutter/domain/models/workspace/workspace_credentials.dart';
import 'package:karwaan_flutter/domain/models/workspace/workspace_member_credentials.dart';
import 'package:karwaan_flutter/domain/repository/workspace/workspace_repo.dart';

class WorkspaceRemoteRepo extends WorkspaceRepo {
  final ServerpodClientService _clientService;

  WorkspaceRemoteRepo(this._clientService);

  @override
  Future<Workspace> createWorkspace(
      WorkspaceCredential workspaceCredential) async {
    try {
      final workspace = await _clientService.createWorkspace(
          workspaceCredential.workspaceName,
          workspaceCredential.workspaceDescription);
      if (workspace.id == null) {
        throw Exception('Server returned null workspace id!');
      }

      return Workspace(
          id: workspace.ownerId,
          workspaceName: workspace.name,
          workspaceDescription: workspace.description!);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Workspace>> getUserWorkspace() {
    // TODO: implement getUserWorkspace
    throw UnimplementedError();
  }

  @override
  Future<bool> updateWorkspace(int workspaceId) async {
    try {
      await _clientService.updateWorkspace(workspaceId);
      return true;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteWorkspace(int workspaceId) async {
    try {
      await _clientService.deleteWorkspace(workspaceId);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> addMemberToWorkspace(
      WorkspaceMemberCredential workspaceMemberCredential) async {
    try {
      await _clientService.addMemberToWorkspace(
          workspaceMemberCredential.workspaceId,
          workspaceMemberCredential.userId);
      return true;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> removeMemberFromWorkspace(
      WorkspaceMemberCredential workspaceMemberCredential) async {
    await _clientService.removeMemberFromWorkspace(
        workspaceMemberCredential.workspaceId,
        workspaceMemberCredential.userId);
  }

  @override
  Future<void> leaveWorkspace(int workspaceId) async {
    try {
      await _clientService.leaveWorkspace(workspaceId);
    } catch (e) {
      rethrow;
    }
  }
}
