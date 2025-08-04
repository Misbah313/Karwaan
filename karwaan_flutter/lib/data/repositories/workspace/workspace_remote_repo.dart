import 'package:flutter/widgets.dart';
import 'package:karwaan_flutter/core/services/serverpod_client_service.dart';
import 'package:karwaan_flutter/domain/models/workspace/create_workspace_credentials.dart';
import 'package:karwaan_flutter/domain/models/workspace/workspace.dart';
import 'package:karwaan_flutter/domain/models/workspace/workspace_credentials.dart';
import 'package:karwaan_flutter/domain/models/workspace/workspace_member_credentials.dart';
import 'package:karwaan_flutter/domain/models/workspace/workspace_member_details.dart';
import 'package:karwaan_flutter/domain/models/workspace/workspace_member_model.dart';
import 'package:karwaan_flutter/domain/repository/workspace/workspace_repo.dart';

class WorkspaceRemoteRepo extends WorkspaceRepo {
  final ServerpodClientService _clientService;

  WorkspaceRemoteRepo(this._clientService);

  @override
  Future<Workspace> createWorkspace(
      CreateWorkspaceCredentials workspaceCredential) async {
    try {
      final workspace = await _clientService.createWorkspace(
          workspaceCredential.workspaceName,
          workspaceCredential.workspaceDescription);
      if (workspace.id == null) {
        throw Exception('Server returned null workspace id!');
      }

      return Workspace(
          id: workspace.id!,
          createdAt: workspaceCredential.createdAt,
          workspaceName: workspace.name,
          workspaceDescription: workspace.description ?? '');
    } catch (e) {
      debugPrint(
          'Failed to create workspace form remote repo: ${e.toString()}');
      rethrow;
    }
  }

  @override
  Future<List<Workspace>> getUserWorkspace() async {
    try {
      final workspaces = await _clientService.getUserWorkspace();
      return workspaces
          .map(
            (e) => Workspace(
                id: e.id!,
                createdAt: e.createdAt,
                workspaceName: e.name,
                workspaceDescription: e.description ?? ''),
          )
          .toList();
    } catch (e) {
      debugPrint(
          'Failed to get user workspace form remote repo: ${e.toString()}');
      rethrow;
    }
  }

  @override
  Future<Workspace> updateWorkspace(
      WorkspaceCredential workspaceCredential) async {
    try {
      final updatedWorkspace = await _clientService.updateWorkspace(
          workspaceCredential.workspaceName,
          workspaceCredential.workspaceDescription,
          workspaceCredential.id);

      return Workspace(
          id: updatedWorkspace.id!,
          createdAt: updatedWorkspace.createdAt,
          workspaceName: updatedWorkspace.name,
          workspaceDescription: updatedWorkspace.description ?? '');
    } catch (e) {
      debugPrint(
          'Failed to update workspace form remote repo: ${e.toString()}');
      rethrow;
    }
  }

  @override
  Future<void> deleteWorkspace(int workspaceId) async {
    try {
      await _clientService.deleteWorkspace(workspaceId);
    } catch (e) {
      debugPrint(
          'Failed to delete workspace form remote repo: ${e.toString()}');
      rethrow;
    }
  }

  @override
  Future<WorkspaceMemberModel> addMemberToWorkspace(
      WorkspaceMemberCredential workspaceMemberCredential) async {
    try {
      final member = await _clientService.addMemberToWorkspace(
          workspaceMemberCredential.workspaceId,
          workspaceMemberCredential.userId);
      return WorkspaceMemberModel(
        id: member.id!,
        workspaceId: member.workspace,
        userId: member.user,
      );
    } catch (e) {
      debugPrint(
          'Failed to add member to workspace form remote repo: ${e.toString()}');
      rethrow;
    }
  }

  @override
  Future<void> removeMemberFromWorkspace(
      WorkspaceMemberCredential workspaceMemberCredential) async {
    try {
      await _clientService.removeMemberFromWorkspace(
          workspaceMemberCredential.workspaceId,
          workspaceMemberCredential.userId);
    } catch (e) {
      debugPrint(
          'Failed to remove meber from workspace from remote repo: ${e.toString()}');
      rethrow;
    }
  }

  @override
  Future<void> leaveWorkspace(int workspaceId) async {
    try {
      await _clientService.leaveWorkspace(workspaceId);
    } catch (e) {
      debugPrint('Failed to leave workspace form remote repo: ${e.toString()}');
      rethrow;
    }
  }

  @override
  Future<List<WorkspaceMemberDetail>> getWorkspaceMembers(
      int workspaceId) async {
    try {
      final members = await _clientService.getWorkspaceMembers(workspaceId);
      return members
          .map(
            (e) => WorkspaceMemberDetail(
                userId: e.userId,
                userName: e.userName,
                role: e.role,
                joinedAt: e.joinedAt),
          )
          .toList();
    } catch (e) {
      debugPrint('Failed to get workspace members from remote repo.');
      rethrow;
    }
  }
}
